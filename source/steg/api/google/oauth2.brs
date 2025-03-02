' Stegman Company LLC v1.1

'-------------------------------------------------------------------------------
' Steg_Api_Google_OAUTH2_DiscoveryDocument
'
' @description - gets the available endpoints from google
' @link https://developers.google.com/identity/protocols/oauth2/openid-connect#discovery
'-------------------------------------------------------------------------------
Sub Steg_Api_Google_OAUTH2_DiscoveryDocument(callback)

	request = {
	    hostUrl:"https://accounts.google.com/.well-known/openid-configuration"
        requestId:"google-discovery-document",
        type:"GET",
		validate:true,
        log:false,
		converResponseToNode:""
    }
	
    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' Steg_Api_Google_OAUTH2_Authorization
'
' @description - gets an authorization code from google
' @link https://developers.google.com/identity/protocols/oauth2/limited-input-device
' @param endpoint String - retrieved an authorization code
' @param scopes String - permissions requested (example: email profile)
'-------------------------------------------------------------------------------
Sub Steg_Api_Google_OAUTH2_Authorization(callback, endpoint as String, scopes as String)

    if TYPE_isValid(m.global.environment)

        environment = m.global.environment

        request = {
            headers:{
                "Content-Type":"application/x-www-form-urlencoded"
            },
            type:"POST",
            hostUrl:endpoint,
            requestId:"google-photos-authorize",
            validate:true,
            log:false,
            converResponseToNode:""
        }

        params = "client_id=" + environment.google.clientId
        params += "&scope=" + scopes.EncodeUri()
        request.params = params
        ' print "LOG: ";params

        API_Utils_SendRequest(callback, request)
    end if
End Sub

'-------------------------------------------------------------------------------
' Steg_Api_Google_OAUTH2_AuthorizationCode
'
' @description - gets the users response after they validate the code
' @link https://developers.google.com/identity/protocols/oauth2/limited-input-device
'-------------------------------------------------------------------------------
Sub Steg_Api_Google_OAUTH2_AuthorizationCode(callback, endpoint as String, code as String)

    if TYPE_isValid(m.global.environment)

        environment = m.global.environment

        request = {
            headers:{
                "Content-Type":"application/x-www-form-urlencoded"
            },
            type:"POST",
            hostUrl:endpoint,
            requestId:"google-authorization-code",
            validate:true,
            log:false,
            converResponseToNode:""
        }

        params = "client_id=" + environment.google.clientId
        params += "&client_secret=" + environment.google.clientSecret
        params += "&grant_type=urn:ietf:params:oauth:grant-type:device_code"
        params += "&device_code=" + code
        request.params = params
        ' print "LOG: ";params

        API_Utils_SendRequest(callback, request)
    end if
End Sub

'-------------------------------------------------------------------------------
' Steg_Api_Google_OAUTH2_RefreshToken
'
' @description - refresh the user access token
' @link https://developers.google.com/identity/protocols/oauth2/limited-input-device
'-------------------------------------------------------------------------------
' Sub Steg_Api_Google_OAUTH2_RefreshToken(callback, refreshToken as String)

'     if TYPE_isValid(m.global.environment)

'         environment = m.global.environment

'         request = {
'             headers:{
'                 "Content-Type":"application/x-www-form-urlencoded"
'             },
'             type:"POST",
'             hostUrl:"https://oauth2.googleapis.com/token",
'             requestId:"google-refresh-token",
'             validate:true,
'             log:false,
'             converResponseToNode:""
'         }

'         params = "client_id=" + environment.google.clientId
'         params += "&client_secret=" + environment.google.clientSecret
'         params += "&refresh_token=" + refreshToken
'         params += "&grant_type=refresh_token"
'         request.params = params
'         ' print "LOG: ";params

'         API_Utils_SendRequest(callback, request)
'     end if
' End Sub
