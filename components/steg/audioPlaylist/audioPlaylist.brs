' Stegman Company LLC.  V4.0

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.top.visible = false

	m.audio = m.top.findNode("audio")
	m.audio.ObserveFieldScoped("state", "onStateChanged")
	m.audio.ObserveFieldScoped("bufferingStatus", "onBufferStatus")

	m.content = invalid
	m.contentIdx = 0
	m.position = 0
	m.continousErrors = 0
	m.continousErrorsMax = 20
End Sub

'-------------------------------------------------------------------------------
' onBufferStatus
'-------------------------------------------------------------------------------
Sub onBufferStatus(evt as Object)

	status = evt.getData()
	if status <> invalid 
	
		if status.prebufferDone AND m.audio.control = "prebuffer"

			m.audio.control = "play"
		end if
	end if
End Sub

'-------------------------------------------------------------------------------
' onStateChanged
'-------------------------------------------------------------------------------
Sub onStateChanged(evt as Object)

	state = evt.getData()
	if state = "finished"

		if m.continousErrors >= m.continousErrorsMax

			print "AUDIO - hit continous errors max:";m.continousErrorsMax;" stopping...."
			m.audio.control = "stop"
		else

			playNext()
			print "AUDIO - playing next track: ";m.contentIdx;" loop: ";m.top.loop
		end if
	else if state = "error"

		print "AUDIO - error: ";m.audio.errorCode;" / ";m.audio.errorMsg
		m.continousErrors++
	end if
End Sub

'-------------------------------------------------------------------------------
' onPlaylistChange
'-------------------------------------------------------------------------------
Sub onContentChange(evt as Object)

	m.content = evt.getData()
	if m.content <> invalid

		print "AUDIO - playlist loaded with ";m.content.getChildCount();" songs and loop: ";m.top.loop
	end if
End Sub

'-------------------------------------------------------------------------------
' onControlChanged
'-------------------------------------------------------------------------------
Sub onControlChanged(evt as Object)

	action = evt.getData()
	if action = "play"

		play()
	else if action = "stop"
		
		m.audio.control = "stop"
	else if action = "pause"

		m.audio.control = "stop"
		m.position = m.audio.position
	else if action = "resume"

		print "AUDIO - resuming track number: ";m.contentIdx;" and seeking to position: ";m.position

		content = CreateObject("roSGNode", "ContentNode")
		content.PlayStart = m.position
		content.url = m.top.currentSong.url
		if m.top.currentSong.urlSigned <> ""

			content.url = m.top.currentSong.urlSigned
		end if
		m.audio.content = content
		m.audio.control = "prebuffer"
	end if
End Sub

'-------------------------------------------------------------------------------
' isPlaying - interface method
'-------------------------------------------------------------------------------
Function isPlaying(params as Object)
	
	return m.audio.state = "playing" OR m.audio.state = "buffering"
End Function

'-------------------------------------------------------------------------------
' nextSong - interface method
'-------------------------------------------------------------------------------
Sub nextSong(params as Object)
	
	playNext()
End Sub

'-------------------------------------------------------------------------------
' play
'-------------------------------------------------------------------------------
Sub play()

	' print "AUDIO: play"

	if m.content <> invalid AND m.content.getChildCount() > 0

		content = m.content.getChild(m.contentIdx)
		if m.top.signUrls AND content.urlSigned <> ""

			print "AUDIO - playing signed url track number: ";m.contentIdx
			' print ">> ";content.urlSigned

			_content = CreateObject("roSGNode","ContentNode")
			_content.url = content.urlSigned
			_content.streamformat = content.streamformat

			m.audio.content = _content
			m.audio.control = "play"

		else if NOT m.top.signUrls AND content.url <> ""

			print "AUDIO - playing url track number: ";m.contentIdx

			_content = CreateObject("roSGNode","ContentNode")
			_content.url = content.url
			_content.streamformat = content.streamformat

			m.audio.content = _content
			m.audio.control = "play"
		end if

		m.top.currentSong = content
	end if
End Sub

'-------------------------------------------------------------------------------
' playNext
'-------------------------------------------------------------------------------
Sub playNext()
	
	if m.contentIdx + 1 < m.content.getChildCount()

		m.contentIdx++
		play()
	else if m.top.loop
		
		m.contentIdx = 0
		play()
	end if
End Sub

'-------------------------------------------------------------------------------
' playPrevious
'-------------------------------------------------------------------------------
Sub playPrevious()
	
	if m.contentIdx - 1 >= 0
		
		m.contentIdx--
		play()
	else

		m.contextIdx = m.content.getChildCount() - 1
		' play()
	end if
End Sub

'-------------------------------------------------------------------------------
' playSignedUrl
'-------------------------------------------------------------------------------
Sub playSignedUrl(url="" as String)

	' print "AUDIO: playSignedUrl"

	content = m.content.getChild(m.contentIdx)
	content.urlSigned = url

	play()
End Sub

'-------------------------------------------------------------------------------
' previousSong - interface method
'-------------------------------------------------------------------------------
Sub previousSong(params as Object)
	
	playPrevious()
End Sub
