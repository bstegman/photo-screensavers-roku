'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	parent = m.top.getParent()

	m.fontSize = 18
	m.colors = {
		focused:parent.focusColor,
		nonFocused:parent.nonFocusColor
	}

	m.icon = m.top.findNode("itemIcon")		
	m.label = m.top.findNode("itemLabel")

	if m.global.fonts <> invalid

		m.icon.font = m.global.fonts.icons
		m.icon.font.size = m.fontSize
		m.label.font.size = m.fontSize
	end if
End Sub

'-------------------------------------------------------------------------------
' onContentChanged
'-------------------------------------------------------------------------------
Sub onContentChanged(evt as Object)

	data = evt.getData()

	if data.icon <> invalid
		
		m.icon.text = data.icon
	end if

	if data.title <> invalid
		
		m.label.text = Locale_String(data.title)
	end if
End Sub

'-------------------------------------------------------------------------------
' showFocus
'-------------------------------------------------------------------------------
Sub showFocus()

	if m.top.listHasFocus AND m.top.focusPercent >= .85

		m.icon.color = m.colors.focused
		m.label.color = m.colors.focused
	else if m.top.focusPercent = 0

		m.icon.color = m.colors.nonFocused
		m.label.color = m.colors.nonFocused
	end if
End Sub

'-------------------------------------------------------------------------------
' onFocusChange
'-------------------------------------------------------------------------------
Sub onFocusChange()

	if m.top.listHasFocus AND m.top.focusPercent >= .85

		m.icon.color = m.colors.focused
		m.label.color = m.colors.focused
	else

		m.icon.color = m.colors.nonFocused
		m.label.color = m.colors.nonFocused
	end if
End Sub
