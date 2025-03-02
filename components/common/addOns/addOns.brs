'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    scene = m.top.getScene()
	m.apiRequestManager = scene.findNode("ApiRequestManager")
	m.registryManager = scene.findNode("RegistryManager")
    m.sessionManager = scene.findNode("SessionManager")
	m.userManager = scene.findNode("UserManager")

	resolution = UI_Resolution()
	m.clock = invalid
    m.opacities = [0.55, 0.65, 0.75, 0.85]
    m.opacityIdx = 1
    m.weatherSettings = invalid
    m.weatherTemplate = invalid

    m.overlay = m.top.findNode("overlay")
	m.overlay.SetFields({
    	width:resolution.width,
    	height:resolution.height,
        opacity:m.opacities[m.opacityIdx]
	})

    m.animationFalling = m.top.findNode("animationFalling")

	m.audio = m.top.findNode("audio")
	m.audio.ObserveFieldScoped("currentSong", "onCurrentSong")

    m.keepAlive = m.top.findNode("keepAlive")

    m.weatherTimer = m.top.findNode("weatherTimer")
    m.weatherTimer.ObserveFieldScoped("fire", "onWeatherTimer")
End Sub

'-------------------------------------------------------------------------------
' onCurrentSong
'-------------------------------------------------------------------------------
Sub onCurrentSong(evt as Object)

    song = evt.getData()
    if song.urlSigned = ""

        API_Cloudfront_Sign(callbackSignUrl, "https://d2yoxo0oaqccy2.cloudfront.net" + song.url)
    end if
End Sub

'-------------------------------------------------------------------------------
' onWeatherTimer
'-------------------------------------------------------------------------------
Sub onWeatherTimer()

    API_Weather_Get(callbackGetWeather, m.weatherSettings.zipCode)
End Sub

'-------------------------------------------------------------------------------
' callbackGenreSongs
'-------------------------------------------------------------------------------
Sub callbackGenreSongs(response as Object)

    if API_Utils_Response_isSuccess(response)

        playAudio(response.data.results)
    else if m.top.keepAliveEnabled

        m.keepAlive.callFunc("start", "video")
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackGetWeather
'-------------------------------------------------------------------------------
Sub callbackGetWeather(response as Object)

    if API_Utils_Response_isSuccess(response)

        m.overlay.visible = true

        if NOT TYPE_isValid(m.weatherTemplate)

            templates = Utils_Weather_GetTemplates()
            template = templates[0]
            if TYPE_isValid(m.weatherSettings.template)

                template = Utils_Weather_GetTemplateByKey(m.weatherSettings.template)
            end if

            m.weatherTemplate = CreateObject("roSGNode", template.componentName)
            m.weatherTemplate.callFunc("set", response.data.results[0])
            m.top.appendChild(m.weatherTemplate)

            m.weatherTimer.control = "start"
        else

            m.weatherTemplate.callFunc("set", response.data.results[0])
        end if
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackRegGetClock
'-------------------------------------------------------------------------------
Sub callbackRegGetClock(response as Object)

    if TYPE_isValid(response.value.enabled) AND response.value.enabled = "true"

        m.clock = CreateObject("roSGNode", "ClockText")
        m.clock.id = "clock"

        config = m.clock.config

        if TYPE_isValid(response.value.style)

            config.style = response.value.style
        end if

        if TYPE_isValid(response.value.format)

            config.format = response.value.format
        end if

        m.clock.config = config
        UI_Screen_PlaceNodeTopRight(m.clock)
        m.top.appendChild(m.clock)

        m.overlay.visible = true
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackRegGetGeneral
'-------------------------------------------------------------------------------
Sub callbackRegGetGeneral(response as Object)

    if TYPE_isValidPath("value.opacityIdx", response)

        m.overlay.opacity = m.opacities[response.value.opacityIdx.toInt()]
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackRegGetWeather
'-------------------------------------------------------------------------------
Sub callbackRegGetWeather(response as Object)

    if NOT TYPE_isAssocArrayEmpty(response.value)

        m.weatherSettings = response.value

        if TYPE_isValid(m.weatherSettings.zipCode)

            m.weatherTimer.control = "start"
            API_Weather_Get(callbackGetWeather, m.weatherSettings.zipCode)
        end if
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackSignUrl
'-------------------------------------------------------------------------------
Sub callbackSignUrl(response as Object)

    if API_Utils_Response_isSuccess(response)

        m.audio.callFunc("playSignedUrl", response.data.results[0].url)
    end if
End Sub

'-------------------------------------------------------------------------------
' changeOpacity
'-------------------------------------------------------------------------------
Sub changeOpacity(direction as String)

    if direction = "right"

        if m.opacityIdx + 1 < m.opacities.Count()

            m.opacityIdx++
        else

            m.opacityIdx = 0
        end if
    else

        if m.opacityIdx - 1 >= 0

            m.opacityIdx--
        else

            m.opacityIdx = m.opacities.Count() - 1
        end if
    end if

    m.overlay.opacity = m.opacities[m.opacityIdx]
    REG_General_Save(invalid, {opacityIdx:m.opacityIdx.toStr()})
End Sub

'-------------------------------------------------------------------------------
' load
'-------------------------------------------------------------------------------
Sub load()

    REG_General_Get(callbackRegGetGeneral)
    REG_Clock_Get(callbackRegGetClock)
    REG_Weather_Get(callbackRegGetWeather)

    if TYPE_isValid(m.sessionManager.musicGenre) AND m.sessionManager.musicGenre.id <> "none"

        API_Music_GenreSongs(callbackGenreSongs, m.sessionManager.musicGenre.id)
    else if TYPE_isValid(m.sessionManager.sound) AND m.sessionManager.sound.id <> "none"

        songs = [
            {
                url:m.sessionManager.sound.url
            }
        ]
        playAudio(songs)
    else

        m.keepAlive.callFunc("start", "video")
    end if

    startAnimation()
End Sub

'-------------------------------------------------------------------------------
' loadFree
'-------------------------------------------------------------------------------
Sub loadFree()

    REG_General_Get(callbackRegGetGeneral)
    REG_Clock_Get(callbackRegGetClock)

    startAnimation()

    m.keepAlive.callFunc("start", "video")
End Sub

'-------------------------------------------------------------------------------
' loadMusic
'-------------------------------------------------------------------------------
Sub loadMusic()

    API_Music_GenreSongs(callbackGenreSongs, m.sessionManager.musicGenre.id)    
End Sub

'-------------------------------------------------------------------------------
' loadWidget
'-------------------------------------------------------------------------------
Sub loadWidget()

    if TYPE_isValid(m.sessionManager.musicGenre) AND m.sessionManager.musicGenre.id <> "none"

        API_Music_GenreSongs(callbackGenreSongs, m.sessionManager.musicGenre.id)
    else if TYPE_isValid(m.sessionManager.sound) AND m.sessionManager.sound.id <> "none"

        songs = [
            {
                url:m.sessionManager.sound.url
            }
        ]
        playAudio(songs)
    else

        m.keepAlive.callFunc("start", "video")
    end if
End Sub

'-------------------------------------------------------------------------------
' pause
'-------------------------------------------------------------------------------
Sub pause(resume=false as Boolean)

    if resume

        if m.audio.content <> invalid

            m.audio.control = "resume"
        else if m.top.keepAliveEnabled

            m.keepAlive.callFunc("start", "video")
        end if
    else

        if m.audio.content <> invalid

            m.audio.control = "pause"
        else if m.top.keepAliveEnabled

            m.keepAlive.callFunc("stopKeepAlive")
        end if
    end if
End Sub

'-------------------------------------------------------------------------------
' playAudio
'-------------------------------------------------------------------------------
Sub playAudio(songs as Object)

    playlist = CreateObject("RoSGNode", "ContentNode")
    for i=0 to songs.Count() - 1

        song = songs[i]

        item = playlist.createChild("AudioSongNode")
        item.url = song.url
    end for

    m.audio.content = playlist
    m.audio.control = "play"
End Sub

'-------------------------------------------------------------------------------
' startAnimation
'-------------------------------------------------------------------------------
Sub startAnimation()

    if TYPE_isValid(m.sessionManager.animation) AND m.sessionManager.animation <> "none"

        if m.sessionManager.animation = "snow"

            m.animationFalling.images = [
                "pkg:/assets/animations/snowflakes/snowflake1.png", 
                "pkg:/assets/animations/snowflakes/snowflake2.png", 
                "pkg:/assets/animations/snowflakes/snowflake3.png", 
                "pkg:/assets/animations/snowflakes/snowflake4.png", 
                "pkg:/assets/animations/snowflakes/snowflake5.png"
            ]
            m.animationFalling.control = "start"
        else if m.sessionManager.animation = "leaves"

            m.animationFalling.images = [
                "pkg:/assets/animations/leaves/leaf1.png"
                "pkg:/assets/animations/leaves/leaf2.png"
                "pkg:/assets/animations/leaves/leaf3.png"
                "pkg:/assets/animations/leaves/leaf4.png"
                "pkg:/assets/animations/leaves/leaf5.png"
            ]
            m.animationFalling.control = "start"
        end if
    end if
End Sub