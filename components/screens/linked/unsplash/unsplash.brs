'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.adsManager = m.scene.findNode("AdsManager")
	m.sessionManager = m.scene.findNode("SessionManager")

    m.photos = []
    ' failed continuous photo loads. this will trigger local load photos
	m.failedPhotoLoads = {
		max:10,
		current:0
	}
    m.isPaused = false
    m.integration = invalid

    m.addons = m.top.findNode("addons")

    m.viewPhoto = m.top.findNode("viewPhoto")
    m.viewPhoto.transition = "fade"

    m.notification = m.top.findNode("notification")
    UI_Screen_PlaceNodeCenter(m.notification)

    m.photoTimer = m.top.findNode("photoTimer")

    m.componentTimespan = CreateObject("roTimespan")
    m.freeTimespan = CreateObject("roTimespan")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.adsManager.ObserveFieldScoped("completed", "onAdCompleted")
    m.viewPhoto.ObserveFieldScoped("loadStatus", "onPhotoLoadStatusChange")
    m.photoTimer.ObserveFieldScoped("fire", "onPhotoTimer")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.adsManager.callFunc("stopManager")

    m.adsManager.UnObserveFieldScoped("completed")
    m.viewPhoto.UnObserveFieldScoped("loadStatus")
    m.photoTimer.UnObserveFieldScoped("fire")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    m.componentTimespan.Mark()
    m.freeTimespan.Mark()

    API_Integrations_Unsplash_Get(callbackIntegrationGet)
End Sub

'-------------------------------------------------------------------------------
' onKeyEvent - Called when there is a key event
'-------------------------------------------------------------------------------
Function onKeyEvent(key as String, press as Boolean) as Boolean

    handled = true
    if press

        keycodes = enum_keycodes()
        if key = keycodes.BACK

            baseHistoryBack()
        else if key = keycodes.LEFT OR key = keycodes.RIGHT

            m.addons.callFunc("changeOpacity", key)
        end if
    end if
    return handled
End Function

'-------------------------------------------------------------------------------
' onAdCompleted
'-------------------------------------------------------------------------------
Sub onAdCompleted(evt as Object)

    Utils_Log("ad completed")

	data = {
		context:"unsplash",
		shown:evt.getData()
	}
	NewRelic_LogEvent("PowerTV", "VideoAds", data)

    baseFocusNode(m.viewPhoto.id)

    m.addons.callFunc("pause", true)
	m.adsManager.callFunc("start", false)
End Sub

'-------------------------------------------------------------------------------
' onAdStarting
'-------------------------------------------------------------------------------
Sub onAdStarting()

    Utils_Log("ad starting")

    m.addons.callFunc("pause", false)
End Sub

'-------------------------------------------------------------------------------
' onPhotoLoadStatusChange
'-------------------------------------------------------------------------------
Sub onPhotoLoadStatusChange(evt as object)

	status = evt.getData()

	if status = "loading"
	else if status = "ready"
	
        m.failedPhotoLoads.current = 0
        if NOT m.isPaused

            m.photoTimer.control = "start"
        end if
	else if status = "failed"

		m.failedPhotoLoads.current++
		m.photoTimer.control = "stop"

		m.photoTimer.duration = 10
		m.photoTimer.control = "start"
	end if
End Sub

'-------------------------------------------------------------------------------
' onPhotoTimer
'-------------------------------------------------------------------------------
Sub onPhotoTimer(evt as Object)

    if (m.componentTimespan.TotalSeconds() >= m.sessionManager.timeout)

        m.router.callFunc("popHistory", 3)
        baseShowScreen(m.global.screens.PowerTVScreen)
    else

        showPhoto()
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackIntegrationGet
'-------------------------------------------------------------------------------
Sub callbackIntegrationGet(response as Object)

    if API_Utils_Response_isSuccess(response)

        m.integration = response.data.results[0]

        Steg_Api_Unsplash_Me(callbackUnsplashMe, m.integration.access_token)
    else

        message = "Could not retrieve your Unsplash"
        if TYPE_isValidPath("data.error.code", response) AND response.data.error.code = 101

            message = "Please link your Unsplash account"
        end if

        m.notification.SetFields({
            type:"error",
            timeout:0,
            message:message
        })
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackUnsplashMe
'-------------------------------------------------------------------------------
Sub callbackUnsplashMe(response as Object)

    if API_Utils_Response_isSuccess(response)

        m.unsplashUser = response.data
        
        Steg_Api_Unsplash_User_Photos(callbackUnsplashPhotos, m.unsplashUser.username, m.integration.access_token)
    else

        m.notification.SetFields({
            type:"error",
            timeout:0,
            message:"There was a problem talking with Unsplash. Try unlinking and linking your account again."
        })
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackUnsplashPhotos
'-------------------------------------------------------------------------------
Sub callbackUnsplashPhotos(response as Object)

    if API_Utils_Response_isSuccess(response)

        if response.data.Count() > 0

            m.addons.callFunc("load")

            m.photos = response.data
            Track_Init("randomAll", m.photos.Count())

            showPhoto()

            m.adsManager.callFunc("start", false)
            baseStartUsageAnalytics()
        else

            m.notification.SetFields({
                type:"error",
                timeout:0,
                message:"No photos found in your Unsplash library"
            })
        end if
    else

        m.notification.SetFields({
            type:"error",
            timeout:0,
            message:"There was a problem talking with Unsplash.\nTry unlinking and linking your account again."
        })
    end if
End Sub

'-------------------------------------------------------------------------------
' showPhoto
'-------------------------------------------------------------------------------
Sub showPhoto()

    idx = Track_GetNextIdx()
    photo = m.photos[idx]

    m.viewPhoto.width = photo.width
    m.viewPhoto.height= photo.height
    m.viewPhoto.photoURL = photo.urls.regular
End Sub