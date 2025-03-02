'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' API_Feedback_Send
'-------------------------------------------------------------------------------
Sub API_Feedback_Send(callback, message as String)

	request = Utils_API_PrepHttp()
	request.type = "POST"
	request.requestId = "feedback-send"
	request.url = "/forms/myfreeapps/feedback"
	request.params = "context=PhotoScreensavers&message=" + message

    API_Utils_SendRequest(callback, request)
End Sub
