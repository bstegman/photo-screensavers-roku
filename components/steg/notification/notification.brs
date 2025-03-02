' Stegman Company LLC.  V1.3

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.top.visible = false

	resolution = UI_Resolution()
    m.top.width = resolution.width
    m.top.height= m.top.containerHeight

	m.labelMessage = m.top.findNode("labelMessage")
	m.labelMessage.width = m.top.width
	m.labelMessage.height = m.top.height

	m.timer = m.top.findNode("timer")
	m.timer.observeFieldScoped("fire", "onTimerFire")
End Sub

'-------------------------------------------------------------------------------
' onMessageSet
'-------------------------------------------------------------------------------
Sub onMessageSet(evt as Object)

	m.labelMessage.text = evt.getData()

	if m.top.type = "success"

		m.top.color = "#52BE80"
		m.labelMessage.color = "#FFFFFF"
	else if m.top.type = "error"

		m.top.color = "#E74C3C"
		m.labelMessage.color = "#FFFFFF"
	else

		m.top.color = "#FFFFFF"
		m.labelMessage.color = "#000000"
	end if

	m.top.visible = true

	if m.top.timeout <> 0

		m.timer.duration = m.top.timeout
		m.timer.control = "START"
	end if
End Sub

'-------------------------------------------------------------------------------
' onTimerFire
'-------------------------------------------------------------------------------
Sub onTimerFire(evt as Object)

	m.top.visible = false
End Sub

'-------------------------------------------------------------------------------
' onContainerHeight
'-------------------------------------------------------------------------------
Sub onContainerHeight(evt as Object)

    m.top.height = evt.getData()
    m.labelMessage.height = m.top.height
End Sub