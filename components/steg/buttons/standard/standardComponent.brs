'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()
    
    parent = m.top.getParent()

    m.bakColors = {
        focusedColor:"#000000",
        unFocusedColor:"#FFFFFF"
    }

    m.fontColors = {
        focusedColor:"#FFFFFF",
        unFocusedColor:"#000000",
    }

    ' apply provided styles
    if TYPE_isAssocArray(parent.style)

        if TYPE_isString(parent.style.buttonFocusedColor)

            m.bakColors.focusedColor = parent.style.buttonFocusedColor
        end if

        if TYPE_isString(parent.style.buttonUnFocusedColor)

            m.bakColors.unFocusedColor = parent.style.buttonUnFocusedColor
        end if

        if TYPE_isString(parent.style.textFocusedColor)

            m.fontColors.focusedColor = parent.style.textFocusedColor
        end if

        if TYPE_isString(parent.style.textUnFocusedColor)

            m.fontColors.unFocusedColor = parent.style.textUnFocusedColor
        end if
    end if

    m.bak = m.top.findNode("bak")
    m.itemText = m.top.findNode("itemText")

    m.icon = m.top.findNode("icon")

    setNotFocused()
End Sub

'-------------------------------------------------------------------------------
' itemContentChanged
'-------------------------------------------------------------------------------
Sub itemContentChanged(evt as Object)
    
    data = evt.getData()

    if TYPE_isValid(data)

        if TYPE_isString(data.title)
            
            m.itemText.text = data.title
        end if

        if TYPE_isString(data.icon) AND NOT TYPE_isStringEmpty(data.icon)

            if data.iconPos = "left"

                m.icon.translation = [50, m.icon.translation[1]]
            else if data.iconPos = "right"

                m.icon.translation = [m.top.width - m.icon.width - 10, m.icon.translation[1]]
            end if

            m.icon.uri = data.icon
            m.icon.visible = true
        else

            m.icon.uri = ""
            m.icon.visible = false
        end if
    end if
End Sub

'-------------------------------------------------------------------------------
' itemPercentChanged
'-------------------------------------------------------------------------------
Sub itemPercentChanged(evt as Object)

    if m.top.gridHasFocus AND evt.getData() AND m.top.focusPercent >= .85

        setFocused()
    else

        setNotFocused()
    end if
End Sub

'-------------------------------------------------------------------------------
' onGridHasFocus
'-------------------------------------------------------------------------------
Sub onGridHasFocus(evt as Object)

    if evt.getData() AND m.top.focusPercent >= .85

        setFocused()
    else

        setNotFocused()
    end if
End Sub

'-------------------------------------------------------------------------------
' setFocused
'-------------------------------------------------------------------------------
Sub setFocused()

    m.itemText.color = m.fontColors.focusedColor
    m.bak.color = m.bakColors.focusedColor
End Sub

'-------------------------------------------------------------------------------
' setNotFocused
'-------------------------------------------------------------------------------
Sub setNotFocused()

    m.itemText.color = m.fontColors.unFocusedColor
    m.bak.color = m.bakColors.unFocusedColor
End Sub

'-------------------------------------------------------------------------------
' onWidthChanged
'-------------------------------------------------------------------------------
Sub onWidthChanged(evt as Object)

    width = evt.getData()
    m.bak.width = width
    m.itemText.width = width
End Sub

'-------------------------------------------------------------------------------
' onHeightChanged
'-------------------------------------------------------------------------------
Sub onHeightChanged(evt as Object)

    height = evt.getData()
    m.bak.height = height
    m.itemText.height = height
    m.icon.translation = [m.icon.translation[0], (height-m.icon.height)/2]
End Sub