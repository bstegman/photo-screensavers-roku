'-------------------------------------------------------------------------------
' REG_Unsplash_Get
'-------------------------------------------------------------------------------
Sub REG_Unsplash_Get(callback)

	request = {
		requestId:"unsplash-get",
		action:"GetSection",
		section:"ScreenSaverUnsplash"
	}

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_Unsplash_Save
'
' @param settings Object - {
'	showInfo:Boolean
'   scale:Boolean
' }
'-------------------------------------------------------------------------------
Sub REG_Unsplash_Save(callback, settings as Object)

	request = {
		requestId:"unsplash-save",
		action:"SaveSection",
		section:"ScreenSaverUnsplash",
        value:{
			showInfo:TYPE_toString(settings.showInfo),
			scale:TYPE_toString(settings.scale)
		}
	}

    Registry_SendRequest(callback, request)
End Sub
