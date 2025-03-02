' Stegman Company LLC. V3.1

'-------------------------------------------------------------------------------
' RAF_Play
'
' deprecated 1/5/2025
'-------------------------------------------------------------------------------
Sub RAF_Play(adType="preroll", videoPlayer=invalid as Object, url="" as String)

    if TYPE_isValid(m.rafPlayer)

        environment = m.global.environment
        deviceInfo = CreateObject("roDeviceInfo")

        if environment.videoAds.runTestAds

           url = ""
        else if url <> ""

            ' IP
            url = url.Replace("{ip}", deviceInfo.GetConnectionInfo().ip)

            ' User Agent
            osVersion = deviceInfo.GetOsVersion()
            url = url.Replace("{ua}", ("Roku " + deviceInfo.GetModelDisplayName() + " " + osVersion.major + "." + osVersion.minor + "." + osVersion.revision).Escape())

            ' Do not Track
            url = url.Replace("{dnt}", deviceInfo.IsRIDADisabled().toStr())

            ' Device Id
            url = url.Replace("{uuid}", deviceInfo.GetChannelClientId())

            ' Width / Height
            display = deviceInfo.GetDisplaySize()
            url = url.Replace("{width}", display.w.toStr())
            url = url.Replace("{height}", display.h.toStr())
        else

            ' Google Ad Manager Glossary

            ' A resettable device identifier that can be updated by the user at any time. 
            ' For example, a Google AdID, an Apple IDFA, an Amazon AFAI, a Roku RIDA, or an Xbox MSAI.
            rida = deviceInfo.GetRIDA()

            ' "Limit Ad Tracking" (LAT) enables users to opt-out and therefore restrict advertisers from targeting based on user behavior.
            ' It is a requirement of Google and Google Marketing Platform policies to ensure that user choices are accurately adhered to when data is passed on ad requests
            isLat = "0"
            if deviceInfo.IsRIDADisabled()

                isLat = "1"
            end if

            ' A value passed in ad requests, handled automatically by the GPT libraries and the GMA/IMA SDKs. The correlator is common to all ads on a page, 
            ' but unique across page views. Ad requests with the same correlator value received close together in time are considered a single Page View for serving purposes.
            date = CreateObject("roDateTime")
            correlator = date.AsSeconds().toStr()

            ' url = "https://pubads.g.doubleclick.net/gampad/ads?iu=/1027552/myfreeapps-video&description_url=&tfcd=0&npa=0&sz=1280x720%7C1920x1080&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&correlator=" + correlator + "&vpmute=0&vpa=0&vad_type=linear&url=" + environment.videoAds.url + "&vpos=" + adTYPE + "&rdid=" + rida + "&is_lat=" + isLat + "&idtype=rida&an=" + environment.videoAds.appName
            url = "https://pubads.g.doubleclick.net/gampad/ads?iu=/1027552/myfreeapps-video&description_url=&tfcd=0&npa=0&sz=1280x720%7C1920x1080&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&correlator=" + correlator + "&vpmute=0&vpa=0&vad_type=linear&url=" + environment.videoAds.url + "&vpos=" + adTYPE + "&rdid=" + rida + "&is_lat=" + isLat + "&idtype=rida&an=" + environment.videoAds.appName
        end if

        adSettings = CreateObject("roSGNode", "RAFSimplePlayerNode")
        adSettings.url = url
        adSettings.view = m.top
        ' print adSettings

        if TYPE_isValid(videoPlayer)

            if TYPE_isString(videoPlayer.content.categories)
                
                adSettings.genre = videoPlayer.content.categories
            end if
            adSettings.contentLength = videoPlayer.content.length
        end if

        m.rafPlayer.adSettings = adSettings
        m.rafPlayer.control = "run"
    end if
End Sub

'-------------------------------------------------------------------------------
' RAF_PlayUrl
'-------------------------------------------------------------------------------
Sub RAF_PlayUrl(url as String, videoPlayer=invalid as Object)

    if TYPE_isValid(m.rafPlayer)

        adSettings = CreateObject("roSGNode", "RAFSimplePlayerNode")
        adSettings.url = url
        adSettings.view = m.top
        ' print adSettings

        if TYPE_isValid(videoPlayer)

            if TYPE_isString(videoPlayer.content.categories)

                adSettings.genre = videoPlayer.content.categories
            end if
            adSettings.contentLength = videoPlayer.content.length
        end if

        m.rafPlayer.adSettings = adSettings
        m.rafPlayer.control = "run"
    end if
End Sub

'-------------------------------------------------------------------------------
' RAF_RunTestAds
'-------------------------------------------------------------------------------
Sub RAF_RunTestAds(videoPlayer=invalid as Object)

    if TYPE_isValid(m.rafPlayer)

        adSettings = CreateObject("roSGNode", "RAFSimplePlayerNode")
        adSettings.url = ""
        adSettings.view = m.top
        ' print adSettings

        if TYPE_isValid(videoPlayer)

            if TYPE_isString(videoPlayer.content.categories)
                
                adSettings.genre = videoPlayer.content.categories
            end if
            adSettings.contentLength = videoPlayer.content.length
        end if

        m.rafPlayer.adSettings = adSettings
        m.rafPlayer.control = "run"
    end if
End Sub

'-------------------------------------------------------------------------------
' RAF_GoogleAdManager_Play
'-------------------------------------------------------------------------------
Sub RAF_GoogleAdManager_Play(settings as Object, videoPlayer=invalid as Object)

    if TYPE_isValid(m.rafPlayer)

        deviceInfo = CreateObject("roDeviceInfo")

        ' Google Ad Manager Glossary

        ' A resettable device identifier that can be updated by the user at any time. 
        ' For example, a Google AdID, an Apple IDFA, an Amazon AFAI, a Roku RIDA, or an Xbox MSAI.
        rida = deviceInfo.GetRIDA()

        ' "Limit Ad Tracking" (LAT) enables users to opt-out and therefore restrict advertisers from targeting based on user behavior.
        ' It is a requirement of Google and Google Marketing Platform policies to ensure that user choices are accurately adhered to when data is passed on ad requests
        isLat = "0"
        if deviceInfo.IsRIDADisabled()

            isLat = "1"
        end if

        ' A value passed in ad requests, handled automatically by the GPT libraries and the GMA/IMA SDKs. The correlator is common to all ads on a page, 
        ' but unique across page views. Ad requests with the same correlator value received close together in time are considered a single Page View for serving purposes.
        date = CreateObject("roDateTime")
        correlator = date.AsSeconds().toStr()

        adSettings = CreateObject("roSGNode", "RAFSimplePlayerNode")
        adSettings.url = "https://pubads.g.doubleclick.net/gampad/ads?iu=" + settings.adUnit + "&description_url=&tfcd=0&npa=0&sz=1280x720%7C1920x1080&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&correlator=" + correlator + "&vpmute=0&vpa=0&vad_type=linear&url=&vpos=" + settings.type + "&rdid=" + rida + "&is_lat=" + isLat + "&idtype=rida&an=" + settings.appName + "&cust_params=app_id%3D" + settings.appId
        adSettings.view = m.top
        ' print adSettings
        ' print adSettings.url

        if TYPE_isValid(videoPlayer)

            if TYPE_isString(videoPlayer.content.categories)
                
                adSettings.genre = videoPlayer.content.categories
            end if
            adSettings.contentLength = videoPlayer.content.length
        end if

        m.rafPlayer.adSettings = adSettings
        m.rafPlayer.control = "run"
    end if
End Sub
