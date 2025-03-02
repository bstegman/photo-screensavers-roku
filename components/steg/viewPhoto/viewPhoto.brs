' Stegman Company LLC.  V2.3

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.resolution = UI_Resolution()

	bak = m.top.findNode("bak")
	bak.color = "#000000"
	bak.width = m.resolution.width
	bak.height= m.resolution.height

    ' photo
	m.photoContainer = m.top.findNode("photoContainer")
	m.photo = invalid

	' Transitions
	m.fadeInAnimation = m.top.findNode("fadeInAnimation")
	m.fadeInAnimation.ObserveFieldScoped("state", "onFadeInState")
	m.fadeInAnimationInterp = m.fadeInAnimation.getChild(0)

	m.fadeOutAnimation = m.top.findNode("fadeOutAnimation")
	m.fadeOutAnimation.ObserveFieldScoped("state", "onFadeOutState")
	m.fadeOutAnimationInterp = m.fadeOutAnimation.getChild(0)

	' loading timer
	m.loadingTimer = m.top.findNode("loadingTimer")
	m.loadingTimer.ObserveFieldScoped("fire", "onLoadingTimerFire")

	' photos primary/secondary which allows us to swap out the photos behind the scenes and the
	' developer doesn't have to keep track of which photo is which during a slideshow/screensaver.
	' This is set onPhotoSet
	m.photos = invalid
End Sub

'-------------------------------------------------------------------------------
' onLoadingTimerFire
'
' @description - Prevents photos getting stuck in a loading state
'-------------------------------------------------------------------------------
Sub onLoadingTimerFire(evt as Object)

	' print "ViewPhoto: photo timer: ";m.photo.uri
	m.top.loadStatus = "failed"
End Sub

'-------------------------------------------------------------------------------
' onFadeInState
'-------------------------------------------------------------------------------
Sub onFadeInState(evt as Object)

	state = evt.getData()
	' print "ViewPhoto: photo fadeIn state: ";state;" > ";m.photoContainer.getChild(0).loadStatus
	if state = "stopped"

		if TYPE_isValid(m.photoContainer)

			photo = m.photoContainer.getChild(0)
			if TYPE_isValid(photo)

				m.top.loadStatus = photo.loadStatus
			end if
		end if
	end if
End Sub

'-------------------------------------------------------------------------------
' onFadeOutState
'-------------------------------------------------------------------------------
Sub onFadeOutState(evt as Object)

	state = evt.getData()
	' print "ViewPhoto: photo fadeOut state: ";state
	if state = "stopped"

		if TYPE_isValid(m.photoContainer)

			m.photoContainer.removeChildrenIndex(m.photoContainer.getChildCount(), 0)
			if TYPE_isValid(m.photo)

				m.photoContainer.appendChild(m.photo)

				m.fadeInAnimationInterp.fieldToInterp = m.photo.id + ".opacity"
				print "ViewPhoto: photo fadeIn: ";m.photo.id
			end if
			m.fadeInAnimation.control = "start"
		end if
	end if
End Sub

'-------------------------------------------------------------------------------
' onPhotoStatusChange
'-------------------------------------------------------------------------------
Sub onPhotoStatusChange(evt as object)

	status = evt.getData()
	print "ViewPhoto: photo status: ";status;" > ";m.photo.uri
	if status = "loading"

		' start the loading timer to prevent us from getting stuck
		m.loadingTimer.control = "start"
	else if status = "ready"

		' stop the loading timer and stop listening to any photo changes
		m.loadingTimer.control = "stop"
		m.photo.UnObserveFieldScoped("loadStatus")

		processPhoto()
		if m.top.transition <> "" AND m.photoContainer.getChildCount() = 1

			transitionToNewPhoto()
		else

			m.photoContainer.removeChildrenIndex(m.photoContainer.getChildCount(), 0)
			m.photo.opacity = 1
			m.photoContainer.appendChild(m.photo)
			m.top.loadStatus = status
		end if
	else if status = "failed"

		' stop the loading timer and stop listening to any photo changes
		m.loadingTimer.control = "stop"
		m.photo.UnObserveFieldScoped("loadStatus")

		m.photo.translation = [0,0]
		m.photo.width = m.resolution.width
		m.photo.height= m.resolution.height

		m.photoContainer.removeChildrenIndex(m.photoContainer.getChildCount(), 0)
		m.photo.opacity = 1
		m.photoContainer.appendChild(m.photo)
		m.top.loadStatus = status
	end if
End Sub

'-------------------------------------------------------------------------------
' onPhoto
'-------------------------------------------------------------------------------
Sub onPhoto(evt as Object)

	' stop any timers or animations that may be running
	m.loadingTimer.control = "stop"

	photoURL = evt.getData()

	m.photo = invalid
	m.photo = CreateObject("roSGNode", "Poster")
	m.photo.loadDisplayMode = "noScale"
	m.photo.id = CreateObject("roDateTime").AsSeconds().toStr()
	m.photo.opacity = 0
	' m.photo.failedBitmapUri = "pkg:/assets/images/404-large.jpg"
	m.photo.ObserveFieldScoped("loadStatus", "onPhotoStatusChange")

	if m.top.posterToken <> invalid AND m.top.posterToken <> ""

		agent = m.photo.getHttpAgent()
		agent.AddHeader("Referer", m.top.posterToken)
	end if

	m.photo.uri = photoURL
	print "ViewPhoto: URL: ";photoURL
End Sub

'-------------------------------------------------------------------------------
' transitionToNewPhoto
'-------------------------------------------------------------------------------
Sub transitionToNewPhoto()

	photoId = m.photoContainer.getChild(0).id
	print "ViewPhoto: photo fadeOut: ";photoId
	m.fadeOutAnimationInterp.fieldToInterp = photoId + ".opacity"
	m.fadeOutAnimation.control = "start"
End Sub

'-------------------------------------------------------------------------------
' isCurrentPhoto
'-------------------------------------------------------------------------------
Function isCurrentPhoto(params as object) as Boolean

	photoObj = params.photo

	url = ""
	if photoObj.adUrl <> invalid

		url = photoObj.adUrl
	else if photoObj.photo <> invalid

		url = photoObj.photo.url
	else

		url = photoObj.url
	end if

	return m.photos <> invalid AND m.photos.primary.url = url
End Function

'-------------------------------------------------------------------------------
' processPhoto
'
' @description - This will correctly resize the photo based on the meta data
' and set, enable, and disable the correct data
'-------------------------------------------------------------------------------
Sub processPhoto()

	print "ViewPhoto: photo size: ";m.top.width;"x";m.top.height
	print "ViewPhoto: scale: ";m.top.photoScale

	' will scale the photo to fit the screen
	if m.top.photoScale = "resolution"

		m.photo.loadDisplayMode = "scaleToFit"
		m.photo.width = m.resolution.width
		m.photo.height= m.resolution.height

	else if m.top.photoScale = "tv"

		' print "> ";m.photo.bitmapWidth;" x ";m.photo.bitmapHeight
		r = m.photo.bitmapHeight/m.photo.bitmapWidth
		h = Int(m.resolution.width*r)
		' print ">> ";m.resolution.width;" x ";h

		m.photo.loadDisplayMode = "scaleToFit"
		m.photo.width = m.resolution.width
		m.photo.height = h
	else if m.top.width > m.resolution.width OR m.top.height > m.resolution.height

		' landscape
		if m.top.width > m.top.height

			print "ViewPhoto: landscape"
			ratio = Steg_Math_GetPercent(m.top.width, m.resolution.width)
			height = Steg_Math_GetScaledSize(m.top.height, ratio)
			if height > m.resolution.height

				ratio = Steg_Math_GetPercent(m.top.height, m.resolution.height)
				m.photo.width = Steg_Math_GetScaledSize(m.top.width, ratio)
				m.photo.height = m.resolution.height
			else

				m.photo.width = m.resolution.width
				m.photo.height = height
			end if

		' portrait
		else if m.top.height > m.top.width

			print "ViewPhoto: portrait"
			ratio = Steg_Math_GetPercent(m.top.height, m.resolution.height)
			width = Steg_Math_GetScaledSize(m.top.width, ratio)
			if width > m.resolution.width

				m.photo.width = m.resolution.width
				ratio = Steg_Math_GetPercent(m.top.width, m.resolution.width)
				m.photo.height = Steg_Math_GetScaledSize(m.top.height, ratio)
			else

				m.photo.width = width
				m.photo.height = m.resolution.height
			end if
		end if
	else

		print "ViewPhoto: not scaled"
		m.photo.width = m.top.width
		m.photo.height= m.top.height
	end if

	print "ViewPhoto: photo scaled size: ";m.photo.width;"x";m.photo.height
	UI_Screen_PlaceNodeCenter(m.photo)
End Sub
