'-------------------------------------------------------------------------------
' REG_RunTime_Get
'-------------------------------------------------------------------------------
Sub REG_RunTime_Get(callback)

    request = {
        requestId:"runtime-get",
        action: "GetSection",
        section: "RunTime",
        kye:"item"
    }

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_RunTime_Remove
'-------------------------------------------------------------------------------
Sub REG_RunTime_Remove(callback)

	request = {
		requestId:"runtime-remove",
		action:"DeleteSection",
		section:"RunTime"
	}

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_RunTime_Save
'-------------------------------------------------------------------------------
Sub REG_RunTime_Save(callback, name as String, minutes as Integer)

    request = {
        requestId:"runtime-save",
        action: "SaveItem",
        section: "RunTime",
        key: "item",
        value: FormatJSON({name:name, minutes:minutes})
    }

    Registry_SendRequest(callback, request)
End Sub