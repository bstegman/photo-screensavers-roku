'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

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

    m.viewPhoto.ObserveFieldScoped("loadStatus", "onPhotoLoadStatusChange")
    m.photoTimer.ObserveFieldScoped("fire", "onPhotoTimer")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.viewPhoto.UnObserveFieldScoped("loadStatus")
    m.photoTimer.UnObserveFieldScoped("fire")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    m.componentTimespan.Mark()
    m.freeTimespan.Mark()

    API_Integrations_GooglePhotos_Get(callbackIntegrationGet)
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

    if (m.componentTimespan.TotalSeconds() >= 14400 OR (NOT TYPE_isValid(m.userManager.purchase) AND m.freeTimespan.TotalSeconds() > 60))

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
        
        Steg_Api_Google_Photos_Get(callbackGooglePhotosGet, m.integration.access_token)
    else

        message = "Could not retrieve your Google Photos"
        if TYPE_isValidPath("data.error.code", response) AND response.data.error.code = 101

            message = "Please link your Google Photos account"
        end if

        m.notification.SetFields({
            type:"error",
            timeout:0,
            message:message
        })
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackGooglePhotosGet
'-------------------------------------------------------------------------------
Sub callbackGooglePhotosGet(response as Object)

    print FormatJSON(response)
    if API_Utils_Response_isSuccess(response)

        if TYPE_isValid(response.data) AND NOT TYPE_isAssocArrayEmpty(response.data)

            m.addons.callFunc("load")

            m.photos = response.data.mediaItems
            Track_Init("randomAll", m.photos.Count())
            
            showPhoto()
        else

            m.notification.SetFields({
                type:"error",
                timeout:0,
                message:"No photos found in your Google Photos library"
            })
        end if
    else if response.httpResponse.code = 401 AND TYPE_isValid(m.integration.refresh_token)

        API_Integrations_GooglePhotos_Refresh(callbackRefreshToken, m.integration.refresh_token)
    else

        m.notification.SetFields({
            type:"error",
            timeout:0,
            message:"There was a problem talking with Google Photos. Try unlinking and linking your account again."
        })
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackRefreshToken
'-------------------------------------------------------------------------------
Sub callbackRefreshToken(response as Object)

    if API_Utils_Response_isSuccess(response)

        m.integration = response.data.results[0]

        Steg_Api_Google_Photos_Get(callbackGooglePhotosGet, m.integration.access_token)
    else

        m.notification.SetFields({
            type:"error",
            timeout:0,
            message:"There was a problem talking with Google. Try unlinking and linking your account again."
        })
    end if
End Sub

'-------------------------------------------------------------------------------
' showPhoto
'-------------------------------------------------------------------------------
Sub showPhoto()
	
    idx = Track_GetNextIdx()
    photo = m.photos[idx]
    if photo.mimeType = "image/jpeg"

        m.viewPhoto.width = TYPE_toInteger(photo.mediaMetadata.width)
        m.viewPhoto.height= TYPE_toInteger(photo.mediaMetadata.height)
	    m.viewPhoto.photoURL = photo.baseUrl' + "?w1280-h720"
    else

        showPhoto()
    end if
End Sub