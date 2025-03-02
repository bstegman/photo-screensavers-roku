'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	resolution = UI_Resolution()
	m.adsManager = m.scene.findNode("AdsManager")
	m.sessionManager = m.scene.findNode("SessionManager")
	m.video = invalid
	m.videoContent = invalid
	m.videoPosition = 0

    m.title = m.top.findNode("title")
    m.title.text = Locale_String("Videos")
    UI_Screen_PlaceNodeTopCenter(m.title)

    m.grid = m.top.findNode("grid")
	m.videoPlayer = m.top.findNode("videoPlayer")

	m.componentTimer = m.top.findNode("componentTimer")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

	m.componentTimer.duration = m.sessionManager.timeout

	m.adsManager.ObserveFieldScoped("completed", "onAdCompleted")
	m.adsManager.ObserveFieldScoped("starting", "onAdStarting")
	m.componentTimer.ObserveFieldScoped("fire", "onComponentTimer")
	m.grid.ObserveFieldScoped("itemSelected", "onGrid")
	m.videoPlayer.ObserveFieldScoped("bufferingStatus", "onBufferStatus")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

	m.adsManager.UnObserveFieldScoped("completed")
	m.adsManager.UnObserveFieldScoped("starting")
	m.componentTimer.UnObserveFieldScoped("fire")
	m.grid.UnObserveFieldScoped("itemSelected")
	m.videoPlayer.ObserveFieldScoped("bufferingStatus")
End Sub

'-------------------------------------------------------------------------------
' __isActive
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

	Utils_Spinner_Show()

	API_Videos_Streams_Get(callbackGetVideos)
End Sub

'-------------------------------------------------------------------------------
' onKeyEvent - Called when there is a key event
'-------------------------------------------------------------------------------
Function onKeyEvent(key as String, press as Boolean) as Boolean

    handled = true
    if press

        keycodes = enum_keycodes()
        if key = keycodes.BACK

			if m.videoPlayer.visible

				m.adsManager.callFunc("stopManager")

				m.videoPosition = 0
				m.componentTimer.control = "stop"
				m.videoPlayer.control = "stop"
				m.videoPlayer.visible = false

				if TYPE_isValid(m.usageTimer)
					
					m.usageTimer.control = "stop"
				end if
				baseFocusNode(m.grid.id)
			else

				baseHistoryBack()
			end if
        end if
    end if
    return handled
End Function

'-------------------------------------------------------------------------------
' onAdCompleted
'-------------------------------------------------------------------------------
Sub onAdCompleted(evt as Object)

	if m.videoPosition = 0

		item = m.grid.content.getChild(m.grid.itemSelected)
		API_Videos_SignByCode(callbackSignByCode, item.video.code)
	else

		content = CreateObject("roSGNode", "ContentNode")
		content.PlayStart = m.videoPosition
		content.url = m.videoContent.url
		m.videoPlayer.content = content
		m.videoPlayer.control = "prebuffer"

		m.adsManager.callFunc("startTimer")
		baseFocusNode(m.title.id)
	end if
End Sub

'-------------------------------------------------------------------------------
' onAdStarting
'-------------------------------------------------------------------------------
Sub onAdStarting()

	if m.videoPlayer.control <> "stop"

		m.videoPlayer.control = "stop"
		m.videoPosition = m.videoPlayer.position
	end if
End Sub

'-------------------------------------------------------------------------------
' onBufferStatus
'-------------------------------------------------------------------------------
Sub onBufferStatus(evt as Object)

	status = evt.getData()
	if status <> invalid 
	
		if status.prebufferDone AND m.videoPlayer.control = "prebuffer"

			m.videoPlayer.control = "play"
		end if
	end if
End Sub

'-------------------------------------------------------------------------------
' onComponentTimer
'-------------------------------------------------------------------------------
Sub onComponentTimer()

	m.videoPlayer.control = "stop"
	m.videoPlayer.visible = false

	if TYPE_isValid(m.userManager.purchase)

		baseFocusNode(m.grid.id)
	else

		m.router.callFunc("popHistory", 2)
		baseShowScreen(m.global.screens.PowerTVScreen)
	end if
End Sub

'-------------------------------------------------------------------------------
' onGrid
'-------------------------------------------------------------------------------
Sub onGrid(evt as Object)

	if TYPE_isValid(m.adsManager.settings)

		m.adsManager.callFunc("playAd")
	else

		item = m.grid.content.getChild(evt.getData())
		API_Videos_SignByCode(callbackSignByCode, item.video.code)
	end if
End Sub

'-------------------------------------------------------------------------------
' callbackGetVideos
'-------------------------------------------------------------------------------
Sub callbackGetVideos(response as Object)

	if API_Utils_Response_isSuccess(response)

		content = CreateObject("RoSGNode","ContentNode")
        for i=0 to response.data.results.Count() - 1

			video = response.data.results[i]

			item = content.createChild("ContentNode")
			item.SetFields({
				id:video.id,
				HDGRIDPOSTERURL:video.collection.thumbnail,
				SHORTDESCRIPTIONLINE1:video.title
			})
			item.AddFields({video:video})
        end for
        m.grid.content = content
		UI_Screen_PlaceNodeTopCenter(m.grid, {xOffset:20, yOffset:100})

        baseFocusLastNode(m.grid.id)
	end if

	Utils_Spinner_Hide()
End Sub

'-------------------------------------------------------------------------------
' callbackSignByCode
'-------------------------------------------------------------------------------
Sub callbackSignByCode(response as Object)

	if API_Utils_Response_isSuccess(response)

		m.videoContent = CreateObject("roSGNode","ContentNode")
		m.videoContent.url = response.data.results[0]
		m.videoContent.streamformat = "HLS"

		m.videoPlayer.content = m.videoContent
		m.videoPlayer.control = "play"
		m.videoPlayer.visible = true

		m.componentTimer.control = "start"
		m.adsManager.callFunc("startTimer")
		baseStartUsageAnalytics()

		baseFocusNode(m.title.id)
	else

		baseFocusNode(m.grid.id)
	end if
End Sub