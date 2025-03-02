'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.top.lineSpacing = -20
End Sub

'-------------------------------------------------------------------------------
' onSizeChange
'-------------------------------------------------------------------------------
Sub onSizeChange(evt as Object)

    fonts = m.global.fonts
    if fonts <> invalid
    
        size = "avenirBlack20"
        if m.top.size <> invalid

            sizeStr = "avenirBlack" + m.top.size.toStr()
            if fonts.text[sizeStr] <> invalid

                size = sizeStr
            end if
        end if

        m.top.font = fonts.text[size]
    end if
End Sub