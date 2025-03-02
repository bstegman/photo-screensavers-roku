'-------------------------------------------------------------------------------
' API_User_Me
'-------------------------------------------------------------------------------
Sub API_User_Me(callback)

	request = Utils_API_PrepHttp()
	request.requestId = "user-me"
	request.url = "/v1/ua/me"

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_User_ConfirmEmail
'-------------------------------------------------------------------------------
Sub API_User_ConfirmEmail(callback, email as String, source as String)

	request = Utils_API_PrepHttp()
	request.type = "POST"
	request.headers["Authorization"] = "Bearer " + m.global.environment.api.tokenServer
	request.requestId = "user-confirm-email"
	request.url = "/v1/user/confirm/email"
	request.params = "email=" + email + "&source=" + source

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_User_Subscription_Validate
'-------------------------------------------------------------------------------
Sub API_User_Subscription_Validate(callback, email as String, confirmationCode as String)

	request = Utils_API_PrepHttp()
	request.type = "POST"
	request.headers["Authorization"] = "Bearer " + m.global.environment.api.tokenServer
	request.requestId = "user-subscription-validate"
	request.url = "/v1/user/device/subscription/validate"
	request.params = "email=" + email + "&confirmationCode=" + confirmationCode + "&subscriptionCode=screensavers"

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_User_Subscriptions
'-------------------------------------------------------------------------------
Sub API_User_Subscriptions(callback)

	request = Utils_API_PrepHttp()
	request.requestId = "user-subscriptions"
	request.url = "/v1/ua/subscriptions"

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_User_Validate_EmailAndCode
'-------------------------------------------------------------------------------
Sub API_User_Validate_EmailAndCode(callback, email as String, code as String)

	request = Utils_API_PrepHttp()
	request.type = "POST"
	request.headers["Authorization"] = "Bearer " + m.global.environment.api.tokenServer
	request.requestId = "user-validate-code"
	request.url = "/v1/user/device/validate/code"
	request.params = "email=" + email + "&code=" + code

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_User_Validate_TransactionId
'-------------------------------------------------------------------------------
Sub API_User_Validate_TransactionId(callback, transactionId as String)

	request = Utils_API_PrepHttp()
	request.type = "POST"
	request.headers["Authorization"] = "Bearer " + m.global.environment.api.tokenServer
	request.requestId = "user-validate-transaction-id"
	request.url = "/v1/user/roku-transaction/" + transactionId + "/validate"

    API_Utils_SendRequest(callback, request)
End Sub
