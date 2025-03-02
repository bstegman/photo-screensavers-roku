' Stegman Company LLC v3.0

'-------------------------------------------------------------------------------
' String_Capitalize
'
' @description - Capitalizes first letter in string
'-------------------------------------------------------------------------------
Function String_Capitalize(str as String) as String

    newStr = ""
    if str <> ""

        newStr = UCase(Left(str, 1))
        newStr = newStr + LCase(Right(str, Len(str) - 1))
    end if
    return newStr
End Function

'-------------------------------------------------------------------------------
' String_Pad
'
' @description - Pads the string num times
'-------------------------------------------------------------------------------
Function String_Pad(str as String, num as Integer) as String

    newStr = str
    for i=0 to num

        newStr += " "
    end for
    return newStr
End Function

'-------------------------------------------------------------------------------
' String_PadToWidth
'
' @description - Pads the string until it matches the width
'-------------------------------------------------------------------------------
Function String_PadToWidth(str as String, width as Integer) as String

    label = CreateObject("roSGNode", "Label")
    label.text = str

    while(label.boundingRect().width <= width)

        label.text += " "
    end while
    return label.text
End Function

'-------------------------------------------------------------------------------
' String_Len
'
' @description - Determines the strings length
'-------------------------------------------------------------------------------
Function String_Len(str as String, component="Label" as String) as Integer

    label = CreateObject("roSGNode", component)
    label.text = str
    return label.boundingRect().width
End Function

'-------------------------------------------------------------------------------
' String_Quote
'
' @description - Wraps the string with quotes
'-------------------------------------------------------------------------------
Function String_Quote(str as String) as String

    chars = String_Chars()
    return chars.DQ + str + chars.DQ
End Function

'-------------------------------------------------------------------------------
' String_Chars
'
' supported values:
'   DQ = Double Quote
'   NL = New Line
'-------------------------------------------------------------------------------
Function String_Chars() as Object

    return {
        DQ:Chr(34),
        NL:Chr(10)
    }
End Function

'-------------------------------------------------------------------------------
' String_IntPos
'-------------------------------------------------------------------------------
Function String_IntPos(str as String) as Integer

    idx = -1
    for i=0 to Len(str) - 1

        char = Mid(str, i,1)

        if char.toInt() > 0

            idx = i
            exit for
        end if
    end for

    return idx
End Function

'-------------------------------------------------------------------------------
' String_MD5
'-------------------------------------------------------------------------------
Function String_MD5(str as string)

    ba = CreateObject("roByteArray")
    ba.FromAsciiString(str)

    digest = CreateObject("roEVPDigest")
    digest.Setup("md5")
    digest.Update(ba)

    return digest.Final()
End Function