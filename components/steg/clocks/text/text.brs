' Stegman Company LLC.  V4.0

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.yOffset = 0

    m.clockText = m.top.findNode("clockText")
	m.line1 = m.top.findNode("line1")
	m.line2 = m.top.findNode("line2")

    m.timer = m.top.findNode("timer")
    m.timer.ObserveFieldScoped("fire", "onTimer")
	m.timer.control = "start"

	m.top.config = CreateObject("roSGNode", "ClockTextNode")
End Sub

'-------------------------------------------------------------------------------
' onConfig
'-------------------------------------------------------------------------------
Sub onConfig(evt as Object)

	setStyle()
	setClock()
End Sub

'-------------------------------------------------------------------------------
' onTimer
'-------------------------------------------------------------------------------
Sub onTimer(evt as Object)

    setClock()
End Sub

'-------------------------------------------------------------------------------
' setStyle
'-------------------------------------------------------------------------------
Sub setStyle()

	sizeDefault = 52

	font  = CreateObject("roSGNode", "Font")
	if m.top.config.style = "Bonbon"

		font.uri = "pkg:/components/steg/clocks/text/fonts/Bonbon-Regular.ttf"
		font.size = sizeDefault
		m.yOffset = 0
	else if m.top.config.style = "Dancing"

		font.uri = "pkg:/components/steg/clocks/text/fonts/DancingScript-Regular.ttf"
		font.size = sizeDefault
		m.yOffset = 0
	else if m.top.config.style = "Evert"

		font.uri = "pkg:/components/steg/clocks/text/fonts/Ewert-Regular.ttf"
		font.size = 46
		m.yOffset = 0
	else if m.top.config.style = "Lexend"

		font.uri = "pkg:/components/steg/clocks/text/fonts/Lexend-Regular.ttf"
		font.size = sizeDefault
		m.yOffset = 0
	else if m.top.config.style = "Mansalva"

		font.uri = "pkg:/components/steg/clocks/text/fonts/Mansalva-Regular.ttf"
		font.size = sizeDefault
		m.yOffset = -20
	else if m.top.config.style = "MetalMania"

		font.uri = "pkg:/components/steg/clocks/text/fonts/MetalMania-Regular.ttf"
		font.size = sizeDefault
		m.yOffset = -10
	else if m.top.config.style = "Monoton"

		font.uri = "pkg:/components/steg/clocks/text/fonts/Monoton-Regular.ttf"
		font.size = 46
		m.yOffset = -20
	else if m.top.config.style = "Nosifer"

		font.uri = "pkg:/components/steg/clocks/text/fonts/Nosifer-Regular.ttf"
		font.size = 40
		m.yOffset = -20
	else if m.top.config.style = "PressStart2P"

		font.uri = "pkg:/components/steg/clocks/text/fonts/PressStart2P-Regular.ttf"
		font.size = 34
		m.yOffset = 10
	else if m.top.config.style = "Shojumaru"

		font.uri = "pkg:/components/steg/clocks/text/fonts/Shojumaru-Regular.ttf"
		font.size = 46
		m.yOffset = -10
	end if

	m.line1.font = font
	m.line2.font = font

	m.line1.color = m.top.config.color
	m.line2.color = m.top.config.color
	m.line2.visible = (m.top.config.format = "dateTime")
End Sub

'-------------------------------------------------------------------------------
' setClock
'-------------------------------------------------------------------------------
Sub setClock()

	dt = CreateObject("roDateTime")
	dt.ToLocalTime()

	if m.line2.visible

		m.line1.text = DateTime_GetCurrent("MMMM D YYYY", dt)

		m.line2.text = DateTime_GetCurrent("dddd HH:MM", dt)
		UI_Node_PlaceBottomLeft(m.line2, m.line1, {yOffset:m.yOffset})
	else

		m.line1.text = DateTime_GetCurrent("HH:MM", dt)
	end if
End Sub
