' -------------------------------------------------------------------------------
' Main
' -------------------------------------------------------------------------------
Sub Main(externalParams as object)

    InitApp()
End Sub

'-------------------------------------------------------------------------------
' RunScreenSaver
'-------------------------------------------------------------------------------
' Sub RunScreenSaver(externalParams as object)

'     InitApp()
' End Sub

'-------------------------------------------------------------------------------
' InitApp
'-------------------------------------------------------------------------------
Sub InitApp()

	deviceInfo = CreateObject("roDeviceInfo")

    port = CreateObject("roMessagePort")

	screen = CreateObject("roSGScreen")
	screen.setMessagePort(port)

	scene = screen.CreateScene("ScreenSaverScene")

	m.global = screen.getGlobalNode()

	environments = ParseJson(ReadAsciiFile("pkg:/configs/environments.json"))
	environment = {
		deviceLang:LCase(Left(deviceInfo.getCurrentLocale(), 2)),
		environment:environments[environments.current]
	}
	m.global.AddFields(environment)

	screen.show()

	while(true)
   		message = wait(0, port)
	 	if message <> invalid
			messageType = type(msg)
			if messageType = "roSGScreenEvent"
				if message.isScreenClosed() then return
			end if
		end if
 	end while
End Sub