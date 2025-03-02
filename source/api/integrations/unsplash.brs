'-------------------------------------------------------------------------------
' API_Integrations_Unsplash_Get
'-------------------------------------------------------------------------------
Sub API_Integrations_Unsplash_Get(callback)

	request = Utils_API_PrepHttp()
	request.headers["Authorization"] = "Bearer " + m.userManager.user.token
    request.type = "GET"
	request.requestId = "integrations-unsplash-get"
	request.url = "/v1/ua/integrations/unsplash"
	
    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_Integrations_Unsplash_Revoke
'-------------------------------------------------------------------------------
Sub API_Integrations_Unsplash_Revoke(callback)

	request = Utils_API_PrepHttp()
	request.headers["Authorization"] = "Bearer " + m.userManager.user.token
    request.type = "DELETE"
	request.requestId = "integrations-unsplash-revoke"
	request.url = "/v1/ua/integrations/unsplash/revoke"

    API_Utils_SendRequest(callback, request)
End Sub