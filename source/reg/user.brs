'-------------------------------------------------------------------------------
' REG_User_GetLastOpened
'-------------------------------------------------------------------------------
Sub REG_User_GetLastOpened(callback)

	request = {
		requestId:"user-get-lastopened",
		action:"GetItem",
		section:"User",
		key:"lastopened"
	}

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_User_SaveLastOpened
'-------------------------------------------------------------------------------
Sub REG_User_SaveLastOpened(callback, dateStr as String)

	request = {
		requestId:"user-save-lastopened",
		action:"SaveItem",
		section:"User",
		key:"lastopened",
		value:dateStr
	}

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_User_GetToken
'-------------------------------------------------------------------------------
Sub REG_User_GetToken(callback)

	request = {
		requestId:"user-get-token",
		action:"GetItem",
		section:"User",
		key:"token"
	}

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_User_SaveToken
'-------------------------------------------------------------------------------
Sub REG_User_SaveToken(callback, token as String)

	request = {
		requestId:"user-save-token",
		action:"SaveItem",
		section:"User",
		key:"token",
		value:token
	}

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_User_Remove
'-------------------------------------------------------------------------------
Sub REG_User_Remove(callback)

	request = {
		requestId:"user-remove",
		action:"DeleteSection",
		section:"User"
	}

    Registry_SendRequest(callback, request)
End Sub