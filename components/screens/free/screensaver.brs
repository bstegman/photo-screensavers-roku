'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()
    m.photos = m.global.photos
    m.photosIdx = 0

    m.background = m.top.findNode("background")
    m.background.width = resolution.width
    m.background.height= resolution.height

    m.viewPhoto = m.top.findNode("viewPhoto")
    m.addons = m.top.findNode("addons")
    m.photoTimer = m.top.findNode("photoTimer")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.photoTimer.ObserveFieldScoped("fire", "onPhotoTimerFire")
    m.viewPhoto.ObserveFieldScoped("loadStatus", "onPhotoLoadStatusChange")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

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

    showPhoto()

    m.addons.callFunc("loadFree")
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
	if status = "ready" OR status = "failed"

        m.photoTimer.control = "start"
	end if
End Sub

'-------------------------------------------------------------------------------
' onPhotoTimerFire
'-------------------------------------------------------------------------------
Sub onPhotoTimerFire()

    showPhoto()
End Sub

'-------------------------------------------------------------------------------
' showPhoto
'-------------------------------------------------------------------------------
Sub showPhoto()

    photo = m.photos[m.photosIdx]
    m.viewPhoto.photoURL = "pkg:/assets/photos/" + photo

    if (m.photosIdx + 1 < m.photos.Count())

        m.photosIdx++
    else

        m.photosIdx = 0
    end if
End Sub
