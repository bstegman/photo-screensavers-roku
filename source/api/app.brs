'-------------------------------------------------------------------------------
' API_App_Init
'-------------------------------------------------------------------------------
Sub API_App_Init(callback)

	request = Utils_API_PrepHttp()
	request.requestId = "app-init"
	request.url = "/v3/ua/ssphotos/init"

    API_Utils_SendRequest(callback, request)
End Sub
