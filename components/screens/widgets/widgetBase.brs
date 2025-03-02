'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()

    m.adsManager = m.scene.findNode("AdsManager")
    m.router = m.scene.findNode("Router")
    m.sessionManager = m.scene.findNode("SessionManager")
    m.userManager = m.scene.findNode("UserManager")

    m.bak = m.top.findNode("bak")
    m.bak.SetFields({
        width:resolution.width
        height:resolution.height
    })

    m.addons = m.top.findNode("addons")
    m.componentTimer = m.top.findNode("componentTimer")
End Sub

'-------------------------------------------------------------------------------
' __onScreenWillShow
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.componentTimer.duration = m.sessionManager.timeout

	m.adsManager.ObserveFieldScoped("completed", "onAdCompleted")
	m.adsManager.ObserveFieldScoped("starting", "onAdStarting")
    m.componentTimer.ObserveFieldScoped("fire", "onTimer")

    __onScreenWillShow()
End Sub

'-------------------------------------------------------------------------------
' __onScreenWillHide
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.adsManager.callFunc("stopManager")

	m.adsManager.UnObserveFieldScoped("completed")
	m.adsManager.UnObserveFieldScoped("starting")
    m.componentTimer.UnObserveFieldScoped("fire")

    __onScreenWillHide()
End Sub

'-------------------------------------------------------------------------------
' _isActive
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    m.componentTimer.control = "start"

    __isActive()

    m.addons.callFunc("loadWidget")
    m.adsManager.callFunc("startTimer")

    baseFocusNode(m.bak.id)
    baseStartUsageAnalytics()
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

    baseFocusNode(m.bak.id)
End Sub

'-------------------------------------------------------------------------------
' onAdStarting
'-------------------------------------------------------------------------------
Sub onAdStarting()

    Utils_Log("ad starting")

    m.addons.callFunc("pause", false)
End Sub

'-------------------------------------------------------------------------------
' onTimer
'-------------------------------------------------------------------------------
Sub onTimer()

    if TYPE_isValid(m.userManager.purchase)

        baseHistoryBack()
    else

        m.sessionManager.callFunc("clearAll")
        m.router.callFunc("popHistory", 2)
		baseShowScreen(m.global.screens.PowerTVScreen)
    end if
End Sub