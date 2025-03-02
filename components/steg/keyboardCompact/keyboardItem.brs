'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.itemText = m.top.findNode("itemText")
End Sub

'-------------------------------------------------------------------------------
' onContentChanged
'-------------------------------------------------------------------------------
Sub onContentChanged(evt as Object)

    data = evt.getData()
    if data.id = "delete" OR data.id = "empty" OR data.id = "enter"

        icons  = CreateObject("roSGNode", "Font")
	    icons.uri = "pkg:/components/steg/keyboardCompact/icons.ttf"
	    icons.size = 24
        m.itemText.font = icons
    end if

    m.itemText.text = data.title
End Sub

'-------------------------------------------------------------------------------
' itemPercentChanged
'-------------------------------------------------------------------------------
Sub itemPercentChanged(evt as Object)

    if m.top.gridHasFocus AND m.top.focusPercent >= .85

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

    m.itemText.color = "#D68910"
End Sub

'-------------------------------------------------------------------------------
' setNotFocused
'-------------------------------------------------------------------------------
Sub setNotFocused()

    m.itemText.color = "#FFFFFF"
End Sub