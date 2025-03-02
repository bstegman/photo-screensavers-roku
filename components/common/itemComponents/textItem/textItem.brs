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
    
    m.itemText.text = tr(data.title)

    if data.large <> invalid

        m.itemText.font = "font:LargeBoldSystemFont"
    else

        m.itemText.font = "font:MediumBoldSystemFont"
    end if
End Sub

'-------------------------------------------------------------------------------
' onPercentChanged
'-------------------------------------------------------------------------------
Sub onPercentChanged(evt as Object)

    percent = evt.getData()
    if m.top.gridHasFocus AND percent >= 0.85

        m.itemText.color = "#D68910"
    else if percent = 0

        m.itemText.color = "#FFFFFF"
    end if
End Sub

'-------------------------------------------------------------------------------
' onFocusChange
'-------------------------------------------------------------------------------
Sub onFocusChange()

	if m.top.gridHasFocus and m.top.focusPercent >= 0.85

        m.itemText.color = "#D68910"
	else

        m.itemText.color = "#FFFFFF"
	end if
End Sub
