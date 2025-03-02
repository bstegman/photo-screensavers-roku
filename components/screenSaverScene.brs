'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.top.backgroundUri = ""
	m.top.backgroundColor = "#000000"

    m.photos = []
    m.photoIdx = 0

	m.apiRequestManager = m.top.findNode("ApiRequestManager")
	m.apiRequestManager.control = "RUN"

    m.viewPhoto = m.top.findNode("viewPhoto")
    m.viewPhoto.ObserveFieldScoped("loadStatus", "onPhotoLoadStatusChange")

    m.photoTimer = m.top.findNode("photoTimer")
    m.photoTimer.ObserveFieldScoped("fire", "onPhotoTimerFire")

    API_Collections_GetS3PhotosForIds(callbackGetPhotos, Device_GetManifestValue("collectionId"))
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
' callbackGetPhotos
'-------------------------------------------------------------------------------
Sub callbackGetPhotos(response as Object)

    if API_Utils_Response_isSuccess(response)

        if response.data.results.Count() > 0

            ' FOR DEV
            ' p = [
            '     response.data.results[0],
            '     response.data.results[1],
            '     response.data.results[2]
            ' ]
            ' m.photos = p

            m.photos = response.data.results

            showPhoto()
        end if
    end if
End Sub

'-------------------------------------------------------------------------------
' showPhoto
'-------------------------------------------------------------------------------
Sub showPhoto()

    photo = m.photos[m.photoIdx]
    if m.photoIdx + 1 < m.photos.Count()

        m.photoIdx++
    else

        m.photoIdx = 0
    end if

    m.viewPhoto.photoURL = photo.url
End Sub