local soap = require "soap"
local soapcall = soap.call

return function (configs)
	local url = assert(configs.authsoapservice.url, "missing the external AuthSOAPService URL")
	local application = assert(configs.authsoapservice.application, "missing the AppId to request user validations")
	local application_pw = assert(configs.authsoapservice.application_pw, "missing the Password to request user validations")
	return function (entity, sessionId)
		if entity == soapcall{
			url = url,
			result = "/Envelope/Body/validateUserTicketSSO/return/value/user/login",
			request = [[
				<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
				                  xmlns:v41="http://customauthentication.mydomain.com/v41">
					<soapenv:Header/>
					<soapenv:Body>
						<v41:validateUserTicketSSO>
							<userSessionId>]]..sessionId..[[</userSessionId>
							<applicationId>]]..application..[["</applicationId>
							<applicationPassword>]]..application_pw..[[</applicationPassword>
						</v41:validateUserTicketSSO>
					</soapenv:Body>
				</soapenv:Envelope>
			]]}
		then
			return true
		else
			return false, "SessionID "..sessionId.." is not valid on SSO ticket system"
		end
	end
end
