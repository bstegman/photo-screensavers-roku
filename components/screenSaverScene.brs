'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.foundPhotos = false
    m.photos = []

	m.apiRequestManager = m.top.findNode("ApiRequestManager")
	m.apiRequestManager.control = "RUN"

    m.mediaManager = m.top.findNode("mediaManager")
    m.mediaManager.ObserveFieldScoped("photos", "onPhotos")
    m.mediaManager.callFunc("scan")

    m.container = m.top.findNode("container")

    m.title = m.top.findNode("title")
    m.title.text = Locale_String("title")
    UI_Screen_PlaceNodeTopLeft(m.title)

    m.viewPhoto = m.top.findNode("viewPhoto")
    m.viewPhoto.ObserveFieldScoped("loadStatus", "onPhotoLoadStatusChange")

    m.photoTimer = m.top.findNode("photoTimer")
    m.photoTimer.ObserveFieldScoped("fire", "onPhotoTimerFire")

    m.top.signalBeacon("AppLaunchComplete")
    NewRelic_LogEvent("USBScreensaver", "AppStarted")
End Sub

'-------------------------------------------------------------------------------
' onPhotos
'-------------------------------------------------------------------------------
Sub onPhotos(evt as Object)

    m.photos = evt.getData()

    if m.photos.Count() > 0

        m.foundPhotos = true

        Track_Init("randomAll", m.photos.Count())
    else

        m.photos = [
            "pkg:/assets/photos/photo1.jpg",
            "pkg:/assets/photos/photo2.jpg",
            "pkg:/assets/photos/photo1.jpg",
            "pkg:/assets/photos/photo3.jpg"
        ]
        Track_Init("increment", m.photos.Count())
    end if

    NewRelic_LogEvent("USBScreensaver", "Run", {withPhotos:m.foundPhotos.toStr()})

    showPhoto()
End Sub

'-------------------------------------------------------------------------------
' onPhotoTimerFire
'-------------------------------------------------------------------------------
Sub onPhotoTimerFire()

    showPhoto()
End Sub

'-------------------------------------------------------------------------------
' onPhotoLoadStatusChange
'-------------------------------------------------------------------------------
Sub onPhotoLoadStatusChange(evt as object)

	status = evt.getData()
	if status = "ready" OR status = "failed"

        if NOT m.foundPhotos

            if m.container.visible

                m.photoTimer.duration = 45
            else

                m.photoTimer.duration = 5
            end if
        end if

        m.photoTimer.control = "start"
	end if
End Sub

'-------------------------------------------------------------------------------
' showPhoto
'-------------------------------------------------------------------------------
Sub showPhoto()

    if NOT m.foundPhotos

        m.container.visible = NOT m.container.visible
    end if

    idx = Track_GetNextIdx()
    print "idx: ";idx

    if m.viewPhoto.photoURL = m.photos[idx]

        showPhoto()
    else

        m.viewPhoto.photoURL = m.photos[idx]
    end if
End Sub