local _G = require "_G"
local ipairs = _G.ipairs
local pcall = _G.pcall
local tonumber = _G.tonumber

local array = require "table"
local concat = array.concat

local string = require "string"
local gmatch = string.gmatch

local socket = require "cothread.socket"
local newtcp = socket.tcp

local http = require "socket.http"
local httpreq = http.request

local ltn12 = require "ltn12"
local strsrc = ltn12.source.string
local tabsnk = ltn12.sink.table

local slaxdom = require "slaxdom"

local function xpath(value, path)
	value = value.kids
	for name in gmatch(path, "[^/]+") do
		local found
		for _, entry in ipairs(value) do
			if entry.type == "element" and entry.name == name then
				found = entry.kids
				break
			end
		end
		if not found then
			return nil, "not found", value
		end
		value = found
	end
	return value[1].value
end

local soap = {}

function soap.call(param)
	local url, result, request = param.url, param.result, param.request
	local body = {}
	local ok, code, headers, status = httpreq{
		url = url,
		create = newtcp,
		source = strsrc(request),
		sink = tabsnk(body),
		headers = {
			["content-length"] = #request,
			["content-type"] = "application/x-www-form-urlencoded"
		},
		method = "POST",
	}
	if ok and tonumber(code) == 200 then
		local ok, reply = pcall(slaxdom.dom, slaxdom, concat(body))
		if ok then
			return xpath(reply, result)
		end
	end
end

return soap
