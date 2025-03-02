'-------------------------------------------------------------------------------
' API_Sounds_Get
'-------------------------------------------------------------------------------
Sub API_Sounds_Get(callback)

	request = Utils_API_PrepHttp()
	request.requestId = "sounds-get"
	request.url = "/v1/ua/powertv/sounds"

    API_Utils_SendRequest(callback, request)
End Sub
