'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.top.backgroundUri = ""
	m.top.backgroundColor = "#000000"

    m.foundPhotos = false
    m.photos = []

	m.apiRequestManager = m.top.findNode("ApiRequestManager")
	m.apiRequestManager.control = "RUN"

    m.viewPhoto = m.top.findNode("viewPhoto")
    m.viewPhoto.ObserveFieldScoped("loadStatus", "onPhotoLoadStatusChange")

    m.photoTimer = m.top.findNode("photoTimer")
    m.photoTimer.ObserveFieldScoped("fire", "onPhotoTimerFire")

    API_Collections_GetS3PhotosForIds(callbackGetPhotos, Device_GetManifestValue("collectionId"))
End Sub

'-------------------------------------------------------------------------------
' callbackGetPhotos
'-------------------------------------------------------------------------------
Sub callbackGetPhotos(response as Object)

    if API_Utils_Response_isSuccess(response)

        if response.data.results.Count() <> 0

            m.photos = response.data.results
            Track_Init("increment", m.photos.Count())

            showPhoto()
        end if
    end if
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

        m.photoTimer.control = "start"
	end if
End Sub

'-------------------------------------------------------------------------------
' showPhoto
'-------------------------------------------------------------------------------
Sub showPhoto()

    idx = Track_GetNextIdx()
    print "idx: ";idx

    photo = m.photos[idx]
    if m.viewPhoto.photoURL = photo.url

        showPhoto()
    else

        m.viewPhoto.photoURL = photo.url
    end if
End Sub