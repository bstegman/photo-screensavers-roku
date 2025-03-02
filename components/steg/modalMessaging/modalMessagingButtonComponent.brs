'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()
    
    m.parentNode = m.top.getParent()

    gutter = 5

    m.top.color = "#000000"
    m.top.width = m.parentNode.itemSize[0] - gutter
    m.top.height= m.parentNode.itemSize[1] - gutter

    m.itemText = m.top.findNode("itemText")
    m.itemText.width = m.top.width
    m.itemText.height= m.top.height
    m.itemText.translation = [gutter, gutter]
End Sub

'-------------------------------------------------------------------------------
' itemContentChanged
'-------------------------------------------------------------------------------
Sub itemContentChanged(evt as Object)
    
    m.itemText.text = evt.getData().title
End Sub

'-------------------------------------------------------------------------------
' itemPercentChanged
'-------------------------------------------------------------------------------
Sub itemPercentChanged(evt as Object)

    percent = evt.getData()
    if m.top.gridHasFocus 
        if percent >= .85
        
            setFocused()
        else if percent <= .25

            setNotFocused()
        end if
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

    m.itemText.color = "#f39c12"
End Sub

'-------------------------------------------------------------------------------
' setNotFocused
'-------------------------------------------------------------------------------
Sub setNotFocused()

    m.itemText.color = "#FFFFFF"
End Sub