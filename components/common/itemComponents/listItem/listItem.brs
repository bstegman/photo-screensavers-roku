'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.title = m.top.findNode("title")
    m.subtitle = m.top.findNode("subtitle")
    m.checkmark = m.top.findNode("checkmark")
End Sub

'-------------------------------------------------------------------------------
' onContentChanged
'-------------------------------------------------------------------------------
Sub onContentChanged(evt as Object)

    data = evt.getData()
    
    m.title.text = tr(data.title)

    if TYPE_isValid(data.subtitle)

        m.subtitle.text = tr(data.subtitle)
        m.subtitle.visible = true
    end if

    if TYPE_isBooleanEqualTo(data.checked, true)
        
        m.checkmark.visible = false
        
        if m.subtitle.visible AND data.subtitle <> ""
            
            m.checkmark.translation = [0, 10]
            m.title.translation = [30, 10]
        else

            m.checkmark.translation = [0, 15]
            m.title.translation = [30, 15]
        end if

        m.checkmark.visible = true
    else 

        m.checkmark.visible = false

        if m.subtitle.visible AND data.subtitle <> ""
            
            m.title.translation = [0, 5]
        else

            m.title.translation = [0, 15]
        end if
    end if
End Sub

'-------------------------------------------------------------------------------
' onFocusChanged
'-------------------------------------------------------------------------------
Sub onFocusChanged(evt as Object)

	if m.top.focusPercent >= .85

		showFocus()
	else if m.top.focusPercent = 0

		showUnFocus()
	end if
End Sub

'-------------------------------------------------------------------------------
' showFocus
'-------------------------------------------------------------------------------
Sub showFocus()

    m.title.color = "#000000"
    m.subtitle.color = "#000000"
End Sub

'-------------------------------------------------------------------------------
' showUnFocus
'-------------------------------------------------------------------------------
Sub showUnFocus()

    m.title.color = "#FFFFFF"
    m.subtitle.color = "#FFFFFF"
End Sub