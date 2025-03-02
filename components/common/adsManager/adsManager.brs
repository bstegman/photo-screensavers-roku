'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    scene = m.top.GetScene()
    m.apiRequestManager = scene.findNode("ApiRequestManager")

	m.rafPlayer = m.top.findNode("rafPlayer")
    m.rafPlayer.ObserveFieldScoped("adPlaySuccessful", "onAdPlayed")

    m.adTimer = m.top.findNode("adTimer")
    m.adTimer.ObserveFieldScoped("fire", "onTimer")

    m.videoPlayer = invalid
End Sub

'-------------------------------------------------------------------------------
' onAdPlayed
'-------------------------------------------------------------------------------
Sub onAdPlayed(evt as Object)

    completed = evt.getData()

	Utils_Log("ad played: {0}", [completed])

    data = {
    	context:m.top.context,
    	shown:completed
    }
    NewRelic_LogEvent("PowerTV", "VideoAds", data)

    m.top.completed = completed
End Sub

'-------------------------------------------------------------------------------
' onTimer
'-------------------------------------------------------------------------------
Sub onTimer()

    Utils_Log("timer play ad fired")

    play()
End Sub

'-------------------------------------------------------------------------------
' play
'-------------------------------------------------------------------------------
Sub play()

    if TYPE_isValid(m.top.settings)

        m.rafPlayer.setFocus(true)
        m.top.starting = true

        if m.top.settings.url <> ""

            RAF_PlayUrl(m.top.settings.url, m.videoPlayer)
        else

            RAF_GoogleAdManager_Play(m.top.settings, m.videoPlayer)
        end if
        ' RAF_RunTestAds(m.player)
    end if
End Sub

'-------------------------------------------------------------------------------
' playAd
'-------------------------------------------------------------------------------
Sub playAd(videoPlayer=invalid as Object)

    if TYPE_isValid(m.top.settings)

        m.videoPlayer = videoPlayer
        play()
    end if
End Sub

'-------------------------------------------------------------------------------
' startTimer
'-------------------------------------------------------------------------------
Sub startTimer(videoPlayer=invalid as Object)

    if TYPE_isValid(m.top.settings)

        m.videoPlayer = videoPlayer
        m.adTimer.control = "start"
    end if
End Sub

'-------------------------------------------------------------------------------
' stopManager
'-------------------------------------------------------------------------------
Sub stopManager()

    m.adTimer.control = "stop"
End Sub