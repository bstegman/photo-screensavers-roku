'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.top.text = "ByteWiseApps.com"
	
    font  = CreateObject("roSGNode", "Font")
	font.uri = "pkg://components/steg/logo/Gluten-Bold.ttf"
	font.size = 40
    m.top.font = font
End Sub