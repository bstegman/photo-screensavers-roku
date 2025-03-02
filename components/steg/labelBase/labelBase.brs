' Stegman Company LLC.  V1.0

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()
    
    m.top.color = "#FFFFFF"
End Sub

'-------------------------------------------------------------------------------
' onTextSpecial
'
' @description - Transforms any special characters if finds to Brightscript
' native language.  Also, transforms to locale
'  currently supported special characters:
'       \n newline character
'-------------------------------------------------------------------------------
Sub OnTextSpecial(evt as Object)

    m.top.text = Locale_String(evt.getData()).Replace("\n", chr(10))
End Sub