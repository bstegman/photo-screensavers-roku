'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()
    m.adsManager = m.scene.findNode("AdsManager")
	m.sessionManager = m.scene.findNode("SessionManager")

    m.photos = []

    m.background = m.top.findNode("background")
    m.background.width = resolution.width
    m.background.height= resolution.height

    m.viewPhoto = m.top.findNode("viewPhoto")
    m.addons = m.top.findNode("addons")

    m.photoTimer = m.top.findNode("photoTimer")
    m.componentTimespan = CreateObject("roTimespan")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

	m.adsManager.ObserveFieldScoped("completed", "onAdCompleted")
	m.adsManager.ObserveFieldScoped("starting", "onAdStarting")
    m.photoTimer.ObserveFieldScoped("fire", "onPhotoTimerFire")
    m.viewPhoto.ObserveFieldScoped("loadStatus", "onPhotoLoadStatusChange")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  
' This is where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.adsManager.callFunc("stopManager")

	m.adsManager.UnObserveFieldScoped("completed")
	m.adsManager.UnObserveFieldScoped("starting")
    m.photoTimer.UnObserveFieldScoped("fire")
    m.viewPhoto.UnObserveFieldScoped("loadStatus")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'
' @description - Called when the screen becomes active
' @param refresh Boolean - Tells the screen that it should refresh all data.
' This is set by the user when switching screens.
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    Utils_Spinner_Show()

    m.componentTimespan.Mark()

    if TYPE_isValidPath("AppInit.posterToken", m.global)

        m.viewPhoto.posterToken = m.global.AppInit.posterToken

        API_Collections_GetS3PhotosForIds(callbackGetPhotos, m.top.input.collectionIds.Join(","))
    else

        API_Collections_GetPhotosForIds(callbackGetPhotos, m.top.input.collectionIds.Join(","))
    end if
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

    m.addons.callFunc("pause", true)
	m.adsManager.callFunc("startTimer")

    baseFocusNode(m.background.id)
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
	if status = "ready" OR status = "failed"

        m.photoTimer.control = "start"
	end if
End Sub

'-------------------------------------------------------------------------------
' onPhotoTimerFire
'-------------------------------------------------------------------------------
Sub onPhotoTimerFire()

    if (m.componentTimespan.TotalSeconds() >= m.sessionManager.timeout)

        m.sessionManager.callFunc("clearAll")
        m.router.callFunc("popHistory", 3)
        baseShowScreen(m.global.screens.PowerTVScreen)
    else

        showPhoto()
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackGetPhotos
'-------------------------------------------------------------------------------
Sub callbackGetPhotos(response as Object)

    if API_Utils_Response_isSuccess(response)

        if response.data.results.Count() <> 0

            m.addons.callFunc("load")

            m.photos = response.data.results
            Track_Init("increment", m.photos.Count())

            showPhoto()

            m.adsManager.callFunc("startTimer")
            baseStartUsageAnalytics()

            baseFocusNode(m.background.id)
        end if
    end if

    Utils_Spinner_Hide()
End Sub

'-------------------------------------------------------------------------------
' showPhoto
'-------------------------------------------------------------------------------
Sub showPhoto()

    photo = m.photos[Track_GetNextIdx()]
    m.viewPhoto.photoURL = photo.url
End Sub
