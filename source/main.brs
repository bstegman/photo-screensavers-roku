'-------------------------------------------------------------------------------
' Main
'-------------------------------------------------------------------------------
Sub Main(externalParams as object)

    ' Registry_Empty()
    ' Registry_SaveItem("weather", "zipCode", "80126")
    ' Registry_DeleteSection("laze-product")
    ' Registry_SaveItem("subscription", "transactionId", "acfac270-7fe4-11ee-8abd-0a58a9feac1b") 

    ' Cleanup unused registry
    Registry_DeleteSection("Music")

    appInfo = CreateObject("roAppInfo")
    appManager = CreateObject("roAppManager")
    deviceInfo = CreateObject("roDeviceInfo")
    fileSystem = CreateObject("roFileSystem")
    screen = CreateObject("roSGScreen")

    port = CreateObject("roMessagePort")
	screen.setMessagePort(port)

	m.scene = screen.CreateScene("AppScene")
	m.global = screen.getGlobalNode()

	environments = ParseJson(ReadAsciiFile("pkg:/configs/environments.json"))

    m.global.AddFields({
        deviceId:deviceInfo.GetChannelClientId(),
        deviceLang:LCase(Left(deviceInfo.getCurrentLocale(), 2)),
        environment:environments[environments.current],
        loggingEnabled:appInfo.IsDev(),
        photos:fileSystem.GetDirectoryListing("pkg:/assets/photos").ToArray(),
        product:appInfo.GetValue("product"),
        screens:ParseJson(ReadAsciiFile("pkg:/configs/screens.json")),
        screensaverTimeout:appManager.GetScreensaverTimeout(),
        strings:ParseJson(ReadAsciiFile("pkg:/locale/strings.json"))
    })

	if appInfo.IsDev()

		Registry_Print()
	end if

	screen.show()

	while(true)

        message = wait(0, port)
        if message <> invalid

            messageType = type(message)
            ' print "messageType: ";messageType

            if messageType = "roInputEvent"

                if message.isInput()

                    data = message.GetInfo()
                    if TYPE_isValid(data.contentID) AND TYPE_isValid(data.mediaType)

						m.global.AddFields({externalParams:data})
                        m.scene.callFunc("deepLinkRequestReceived")
                    end if
                end if
            else if messageType = "roSGScreenEvent"

            	if message.isScreenClosed() then exit while
            end if
        end if
	end while
End Sub
