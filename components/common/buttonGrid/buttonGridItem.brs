'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.style = {
		buttonFocusedColor:"#ffffff",
		buttonUnFocusedColor:"#585858",
		textFocusedColor:"#000000",
		textUnFocusedColor:"#ffffff"
	}

	m.bak = m.top.findNode("bak")
	m.title = m.top.findNode("title")

	m.bak.color = m.style.buttonUnFocusedColor
	m.title.color = m.style.textUnFocusedColor
End Sub

'-------------------------------------------------------------------------------
' onItemContent
'-------------------------------------------------------------------------------
Sub onItemContent(evt as Object)

	content = evt.getData()

	m.title.text = content.title
End Sub

'-------------------------------------------------------------------------------
' onFocus
'-------------------------------------------------------------------------------
Sub onFocus()

	if m.top.gridHasFocus AND m.top.focusPercent >= .85

		m.bak.color = m.style.buttonFocusedColor
		m.title.color = m.style.textFocusedColor
	else

		m.bak.color = m.style.buttonUnFocusedColor
		m.title.color = m.style.textUnFocusedColor
	end if
End Sub

'-------------------------------------------------------------------------------
' onHeight
'-------------------------------------------------------------------------------
Sub onHeight(evt as Object)

	height = evt.getData()
	m.bak.height = height
	m.title.height = height
End Sub

'-------------------------------------------------------------------------------
' onWidth
'-------------------------------------------------------------------------------
Sub onWidth(evt as Object)

	width = evt.getData()
	m.bak.width = width
	m.title.width = width
End Sub
