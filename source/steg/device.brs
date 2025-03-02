' Stegman Company LLC.  V1.7

'-------------------------------------------------------------------------------
' Device_GetId
'-------------------------------------------------------------------------------
Function Device_GetId() as String

    deviceInfo = CreateObject("roDeviceInfo")
    return deviceInfo.GetChannelClientId()
End Function

'-------------------------------------------------------------------------------
' Device_GetIPAddrs
'
' https://developer.roku.com/docs/references/brightscript/interfaces/ifdeviceinfo.md#getipaddrs-as-object
'-------------------------------------------------------------------------------
Function Device_GetIPAddrs() as String

    ip = ""

    deviceInfo = CreateObject("roDeviceInfo")
    
    connections = deviceInfo.GetIPAddrs()
    if TYPE_isValid(connections)
    
        for each k in connections

            ip = connections[k]
            exit for
        end for
    end if

    return ip
End Function

'-------------------------------------------------------------------------------
' Device_GetModel
'-------------------------------------------------------------------------------
Function Device_GetModel() as String

    deviceInfo = CreateObject("roDeviceInfo")
    return deviceInfo.GetModel()
End Function

'-------------------------------------------------------------------------------
' Device_GetModelType
'-------------------------------------------------------------------------------
Function Device_GetModelType() as String

    deviceInfo = CreateObject("roDeviceInfo")
    return deviceInfo.GetModelType()
End Function

'-------------------------------------------------------------------------------
' Device_GetFriendlyName
'-------------------------------------------------------------------------------
Function Device_GetFriendlyName() as String

    deviceInfo = CreateObject("roDeviceInfo")
    return deviceInfo.GetFriendlyName()
End Function

'-------------------------------------------------------------------------------
' Device_GetManifestValue
'-------------------------------------------------------------------------------
Function Device_GetManifestValue(key as String) as Dynamic

    appInfo = CreateObject("roAppInfo")
    return appInfo.GetValue(key)
End Function

'-------------------------------------------------------------------------------
' Device_GetModelDisplayName
'-------------------------------------------------------------------------------
Function Device_GetModelDisplayName() as String

    deviceInfo = CreateObject("roDeviceInfo")
    return deviceInfo.GetModelDisplayName()
End Function

'-------------------------------------------------------------------------------
' Device_GetRandomUUID
'-------------------------------------------------------------------------------
Function Device_GetRandomUUID() as String

    deviceInfo = CreateObject("roDeviceInfo")
    return deviceInfo.GetRandomUUID()
End Function

'-------------------------------------------------------------------------------
' Device_GetWIFI
'
' https://developer.roku.com/docs/references/brightscript/interfaces/ifdeviceinfo.md#getconnectioninfo-as-object
'-------------------------------------------------------------------------------
Function Device_GetWIFI() as Object

    connection = invalid

    deviceInfo = CreateObject("roDeviceInfo")

    conn = deviceInfo.GetConnectionInfo()
    if TYPE_isValid(conn) AND conn.type = "WiFiConnection"

        connection = conn
    end if

    return connection
End Function

'-------------------------------------------------------------------------------
' Device_GetConnection
'
' https://developer.roku.com/docs/references/brightscript/interfaces/ifdeviceinfo.md#getconnectioninfo-as-object
'-------------------------------------------------------------------------------
Function Device_GetConnection() as Object

    connection = invalid

    deviceInfo = CreateObject("roDeviceInfo")

    conn = deviceInfo.GetConnectionInfo()
    if TYPE_isValid(conn)

        connection = conn
    end if

    return connection
End Function