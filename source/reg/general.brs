'-------------------------------------------------------------------------------
' REG_General_Get
'-------------------------------------------------------------------------------
Sub REG_General_Get(callback)

	request = {
		requestId:"general-get",
		action:"GetSection",
		section:"General"
	}

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_General_Save
'-------------------------------------------------------------------------------
Sub REG_General_Save(callback, general as Object)

	request = {
		requestId:"general-save",
		action:"SaveSection",
		section:"General",
        value:general
	}

    Registry_SendRequest(callback, request)
End Sub
