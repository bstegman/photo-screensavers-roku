'-------------------------------------------------------------------------------
' REG_Collections_Get
'-------------------------------------------------------------------------------
Sub REG_Collections_Get(callback)

    request = {
        requestId:"collections-get",
        action: "GetSection",
        section: "Collections"
    }

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_Collections_Save
'-------------------------------------------------------------------------------
Sub REG_Collections_Save(callback, collectionIds as Object)

    request = {
        requestId:"collections-save",
        action: "SaveItem",
        section: "Collections",
        key: "collectionIds",
        value: collectionIds.join(",")
    }

    Registry_SendRequest(callback, request)
End Sub
