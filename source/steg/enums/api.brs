' Stegman Company LLC.  V1.0

'-------------------------------------------------------------------------------
' Enums_Api_ErrorCodes
'-------------------------------------------------------------------------------
Function Enums_Api_ErrorCodes() as Object

    return {
        INVALID_DATA:100,
        NOT_FOUND:101,
        EXISTS:102,
        COULD_NOT_COMPLETE:103,
        PERMISSION_DENIED:104,
        EXPIRED:105,
        MAX_LIMIT_REACHED:106
    }
End Function