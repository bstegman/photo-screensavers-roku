'-------------------------------------------------------------------------------
' REG_GooglePhotos_Get
'-------------------------------------------------------------------------------
Sub REG_GooglePhotos_Get(callback)

	request = {
		requestId:"reg-google-photos-get",
		action:"GetSection",
		section:"GooglePhotos"
	}

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_GooglePhotos_Save
'-------------------------------------------------------------------------------
Sub REG_GooglePhotos_Save(callback, settings as Object)

	request = {
		requestId:"reg-google-photos-save",
		action:"SaveSection",
		section:"GooglePhotos",
        value:settings
	}

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_GooglePhotos_Delete
'-------------------------------------------------------------------------------
Sub REG_GooglePhotos_Delete(callback)

	request = {
		requestId:"reg-google-photos-delete",
		action:"DeleteSection",
		section:"GooglePhotos"
	}

    Registry_SendRequest(callback, request)
End Sub