'-------------------------------------------------------------------------------
' API_Cloudfront_Sign
'-------------------------------------------------------------------------------
Sub API_Cloudfront_Sign(callback, file)

	request = Utils_API_PrepHttp()
	request.requestId = "music-sign"
	request.type = "POST"
	request.url = "/v1/ua/powertv/cf/sign"
	request.params = "file=" + file

    API_Utils_SendRequest(callback, request)
End Sub
