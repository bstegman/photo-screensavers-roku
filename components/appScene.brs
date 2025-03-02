'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.top.backgroundColor = "#000000"
	m.top.backgroundUri = ""

	data = {
		fonts:initFonts(),
    	styles:{
			button:{
        		buttonFocusedColor:"#ffffff",
        		buttonUnFocusedColor:"#585858",
        		textFocusedColor:"#000000",
        		textUnFocusedColor:"#ffffff"
			},
			buttonBlack:{
        		buttonFocusedColor:"#ffffff",
        		buttonUnFocusedColor:"#000000",
        		textFocusedColor:"#000000",
        		textUnFocusedColor:"#ffffff"
			}
    	}
	}
	m.global.AddFields(data)

	m.apiRequestManager = m.top.findNode("ApiRequestManager")
	m.apiRequestManager.control = "RUN"

	m.registryManager = m.top.findNode("RegistryManager")
	m.registryManager.control = "RUN"

	m.router = m.top.findNode("router")
	m.router.ObserveFieldScoped("screenChange", "onScreenChange")
	m.router.callFunc("setScreens", {screens:m.global.screens})

	m.spinner = m.top.findNode("Spinner")
	m.spinner.poster.ObserveFieldScoped("loadStatus", "onSpinner")
	m.spinner.poster.uri = "pkg:/assets/spinner.png"

	m.top.signalBeacon("AppLaunchComplete")

	REG_RunTime_Get(callbackGetRunTime)
End Sub

'-------------------------------------------------------------------------------
' onKeyEvent - Called when there is a key event
'-------------------------------------------------------------------------------
Function onKeyEvent(key as String, press as Boolean) as Boolean

	return false
End Function

'-------------------------------------------------------------------------------
' onScreenChange
'-------------------------------------------------------------------------------
Sub onScreenChange(evt as Object)

    data = evt.getData()
    if TYPE_isValid(data)

        fromScreenId = ""
        if TYPE_isValid(data.from)

            fromScreenId = data.from.id
        end if

		' NewRelic_LogEvent("SSPhotos", "ScreenView", {fromScreen:fromScreenId, toScreen:data.to.id})
		print "from: ";fromScreenId;" to: ";data.to.id
    end if
End Sub

'-------------------------------------------------------------------------------
' onSpinner
'-------------------------------------------------------------------------------
Sub onSpinner(evt as Object)

	if evt.getData() = "ready"

		UI_Screen_PlaceNodeCenter(m.spinner)
	end if
End Sub

'-------------------------------------------------------------------------------
' callbackGetRunTime
'-------------------------------------------------------------------------------
Sub callbackGetRunTime(response as Object)

	if TYPE_isValidPath("value.item", response)

        REG_RunTime_Remove(invalid)
        NewRelic_LogEvent("SSPhotos", "RunTime", ParseJson(response.value.item))
	end if

	m.router.callFunc("showScreen", {screen:m.global.screens.StartupScreen})
End Sub

'-------------------------------------------------------------------------------
' deepLinkRequestReceived
'
' @description - see xml <function> comments
'-------------------------------------------------------------------------------
Sub deepLinkRequestReceived()
End Sub