'-------------------------------------------------------------------------------
' REG_Message_Save
'-------------------------------------------------------------------------------
Sub REG_Message_Save(callback, shown=true as Boolean)

    request = {
        requestId:"message-save",
        action: "SaveItem",
        section: "Message",
        key: "shownPrice",
        value: shown.toStr()
    }

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_Message_Get
'-------------------------------------------------------------------------------
Sub REG_Message_Get(callback)

    request = {
        requestId:"message-get",
        action: "GetItem",
		section:"Message",
		key:"shownPrice"
    }

    Registry_SendRequest(callback, request)
End Sub
