'-------------------------------------------------------------------------------
' REG_Clock_Get
'-------------------------------------------------------------------------------
Sub REG_Clock_Get(callback)

	request = {
		requestId:"clock-get",
		action:"GetSection",
		section:"ScreenSaverClock"
	}

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_Clock_Save
'
' @param settings Object - {
'	style:String,
'	format:String
' }
'-------------------------------------------------------------------------------
Sub REG_Clock_Save(callback, settings as Object)

	request = {
		requestId:"clock-save",
		action:"SaveSection",
		section:"ScreenSaverClock",
        value:settings
	}

    Registry_SendRequest(callback, request)
End Sub
