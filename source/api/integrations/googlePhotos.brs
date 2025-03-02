'-------------------------------------------------------------------------------
' API_Integrations_GooglePhotos_Get
'-------------------------------------------------------------------------------
Sub API_Integrations_GooglePhotos_Get(callback)

	request = Utils_API_PrepHttp()
	request.headers["Authorization"] = "Bearer " + m.userManager.user.token
    request.type = "GET"
	request.requestId = "integrations-googlephotos-get"
	request.url = "/v1/ua/integrations/google-photos"
	
    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_Integrations_GooglePhotos_Refresh
'-------------------------------------------------------------------------------
Sub API_Integrations_GooglePhotos_Refresh(callback, refreshToken as String)

	request = Utils_API_PrepHttp()
	request.headers["Authorization"] = "Bearer " + m.userManager.user.token
    request.type = "POST"
	request.requestId = "integrations-googlephotos-refresh"
	request.url = "/v1/ua/integrations/google/refresh"
	request.params = "refreshToken=" + refreshToken

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_Integrations_GooglePhotos_Revoke
'-------------------------------------------------------------------------------
Sub API_Integrations_GooglePhotos_Revoke(callback)

	request = Utils_API_PrepHttp()
	request.headers["Authorization"] = "Bearer " + m.userManager.user.token
    request.type = "DELETE"
	request.requestId = "integrations-googlephotos-revoke"
	request.url = "/v1/ua/integrations/google/revoke"

    API_Utils_SendRequest(callback, request)
End Sub