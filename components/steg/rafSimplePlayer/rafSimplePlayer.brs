' Stegman Company LLC.  V3.4

Library "Roku_Ads.brs"

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.top.functionName = "playAd"
End Sub

'-------------------------------------------------------------------------------
' playAd
'-------------------------------------------------------------------------------
Sub playAd()

	adSettings = m.top.adSettings

	RAF = Roku_Ads()
	RAF.setDebugOutput(m.top.debug)
	RAF.enableAdMeasurements(true)
	RAF.setAdUrl(adSettings.url)
	' RAF.setContentLength(adSettings.contentLength)
	RAF.setContentId(adSettings.contentId)
	RAF.enableNielsenDAR(false)
	' RAF.setNielsenAppId(adSettings.nielsenId)
	RAF.setNielsenGenre(adSettings.genre)
	RAF.setAdExit(false)

	if adSettings.title <> "" OR adSettings.description <> ""

		RAF.enableAdBufferMessaging(true)
		adMessaging = {
			title:adSettings.title,
			description:adSettings.description
		}
		RAF.setAdBufferScreenContent(adMessaging)
	else

		RAF.enableAdBufferMessaging(false, true)
	end if

	m.top.adCount = 0
	adPods = RAF.getAds()
	if adPods <> invalid

		m.top.adCount = adPods.Count()
	end if

	played = false
	if m.top.adCount > 0

		played = RAF.showAds(adPods, invalid, adSettings.view)
	end if

	m.top.SetField("adPlaySuccessful", played)
End Sub
