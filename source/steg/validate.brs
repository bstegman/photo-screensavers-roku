' Stegman Company LLC v1.0

'-------------------------------------------------------------------------------
' Validate_isEmail
'-------------------------------------------------------------------------------
Function Validate_isEmail(email as String) as Boolean

    regex = CreateObject("roRegex", "^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", "")
    return regex.MatchAll(email).Count() > 0
End Function