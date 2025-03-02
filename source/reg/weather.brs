'-------------------------------------------------------------------------------
' REG_Weather_SaveTransactionId
'-------------------------------------------------------------------------------
Sub REG_Weather_SaveTransactionId(callback, transactionId)

    request = {
        requestId:"weather-save-transaction-id",
        action: "SaveItem",
        section: "weather",
        key: "transactionId",
        value: transactionId
    }

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_Weather_Get
'-------------------------------------------------------------------------------
Sub REG_Weather_Get(callback)

    request = {
        requestId:"weather-get",
        action: "GetSection",
        section: "weather"
    }

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_Weather_Save
'-------------------------------------------------------------------------------
Sub REG_Weather_Save(callback, settings as Object)

    request = {
        requestId:"weather-save",
        action: "SaveSection",
        section: "weather",
        value:settings
    }

    Registry_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' REG_Weather_Delete
'-------------------------------------------------------------------------------
Sub REG_Weather_Delete(callback)

    request = {
        requestId:"weather-save",
        action: "DeleteSection",
        section: "weather"
    }

    Registry_SendRequest(callback, request)
End Sub