' -------------------------------------------------------------------------------
' Main
' -------------------------------------------------------------------------------
Sub Main(externalParams as object)

    InitApp()
End Sub

'-------------------------------------------------------------------------------
' RunScreenSaver
'-------------------------------------------------------------------------------
Sub RunScreenSaver(externalParams as object)

    InitApp()
End Sub

'-------------------------------------------------------------------------------
' InitApp
'-------------------------------------------------------------------------------
Sub InitApp()

    port = CreateObject("roMessagePort")

	screen = CreateObject("roSGScreen")
	screen.setMessagePort(port)

	scene = screen.CreateScene("ScreenSaverScene")

	m.global = screen.getGlobalNode()

    strings = ParseJson(ReadAsciiFile("pkg:/locale/strings.json"))

	environment = {
        "newRelic":{
            "enabled":true,
            "accountID":"2823845",
            "apiKey":"NRII-zRRMsoBQfC8ZfCbCVNKbaAfuTKm5_Id8"
        }
	}
	m.global.AddFields({strings:strings, environment:environment})

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