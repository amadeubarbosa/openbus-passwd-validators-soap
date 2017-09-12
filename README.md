# Example how to make SOAP requests from an OpenBus Password Validator

This example assumes the usage of a SOAP service that runs at http://localhost:8080
The SOAP service accepts requests using the following envelope:
```xml 
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:v41="http://customauthentication.mydomain.com/v41">
  <soapenv:Header/>
  <soapenv:Body>
    <v41:validateUserTicketSSO>
      <userSessionId>TICKET_AS_STRING</userSessionId>
      <applicationId>APPLICATION_ID_AS_STRING</applicationId>
      <applicationPassword>APPLICATION_PASSWD_AS_STRING</applicationPassword>
    </v41:validateUserTicketSSO>
  </soapenv:Body>
</soapenv:Envelope>
```

And it produces responses like this containing the data type ```/Envelope/Body/validateUserTicketSSO/return/value/user/login``` that it's only an username string.
