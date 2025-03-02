' Stegman Company LLC.  V4.1

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.scene = m.top.GetScene()
	m.style = {
		border:"#FFFFFF",
		bak:"#1a1a1a",
		fontColor:"#FFFFFF"
	}

    m.top.id = "ModalMessaging"
	m.top.color = m.style.border
	m.top.width = 600
	m.top.height= 250

	cords = UI_Screen_Center(m.top.width, m.top.height)
	m.top.translation = [cords.x, cords.y]

	m.containerInner = m.top.findNode("containerInner")
	m.containerInner.color = m.style.bak
	m.containerInner.width = m.top.width - 10
	m.containerInner.height= m.top.height - 10
	m.containerInner.translation = [5, 5]

	m.message = m.top.findNode("message")
	m.message.color = m.style.fontColor
	m.message.width = m.containerInner.width
	m.message.height= m.containerInner.height

	m.buttons = m.top.findNode("buttons")
	m.buttons.ObserveFieldScoped("itemSelected", "onButtonSelected")
End Sub

'-------------------------------------------------------------------------------
' onKeyEvent
'-------------------------------------------------------------------------------
Function onKeyEvent(key as String, press as Boolean) as Boolean
	
	return true
End Function

'-------------------------------------------------------------------------------
' onButtonSelected
'-------------------------------------------------------------------------------
Sub onButtonSelected(evt as Object)

	button = m.buttons.content.getChild(evt.getData())
	m.top.btnSelected = button.id
End Sub

'-------------------------------------------------------------------------------
' createButtons
'-------------------------------------------------------------------------------
Sub createButtons()

	content = CreateObject("roSGNode", "ContentNode")

	if m.top.btnCancelShow
		
		item = content.createChild("ContentNode")
		item.id = "cancel"
		item.title = m.top.btnCancelText
	end if

	item = content.createChild("ContentNode")
	item.id = "ok"
	item.title = m.top.btnOkText

	m.buttons.content = content
End Sub

'-------------------------------------------------------------------------------
' show
'-------------------------------------------------------------------------------
Sub show(message as String)

	createButtons()

	if m.buttons.content.getChildCount() = 1

		UI_Node_PlaceInsideBottomRight(m.buttons, m.containerInner, {xOffset:18})
	else

		spacing = m.top.width - (100*2) - (5*2)
		m.buttons.itemSpacing = [spacing, spacing]

		UI_Node_PlaceInsideBottomLeft(m.buttons, m.containerInner)
	end if

	m.message.text = message.Replace("\n", chr(10))

	m.scene.appendChild(m.top)
	m.buttons.setFocus(true)
End Sub

'-------------------------------------------------------------------------------
' close
'-------------------------------------------------------------------------------
Sub close()

	m.scene.removeChild(m.top)
End Sub