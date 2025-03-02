'-------------------------------------------------------------------------------
' API_Videos_Streams_Get
'-------------------------------------------------------------------------------
Sub API_Videos_Streams_Get(callback)

	request = Utils_API_PrepHttp()
	request.type = "GET"
	request.requestId = "videos-get-all"
	request.url = "/v1/ua/powertv/video/streams"

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_Videos_SignByCode
'-------------------------------------------------------------------------------
Sub API_Videos_SignByCode(callback, code)

	request = Utils_API_PrepHttp()
	request.type = "POST"
	request.requestId = "videos-signurl"
	request.url = "/v1/ua/powertv/video/sign/code"
	request.params = "code=" + code

    API_Utils_SendRequest(callback, request)
End Sub