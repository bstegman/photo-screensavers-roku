'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.lastOpenedOn = ""
    m.videoAds = invalid

    m.adsManager = m.scene.findNode("AdsManager")
    m.sessionManager = m.scene.findNode("SessionManager")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.userManager.ObserveFieldScoped("purchase", "onPurchase")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.userManager.UnObserveFieldScoped("purchase")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'
' @description - Called when the screen becomes active
' @param refresh Boolean - Tells the screen that it should refresh all data.
' This is set by the user when switching screens.
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    API_App_Init(callbackAppInit)
End Sub

'-------------------------------------------------------------------------------
' onKeyEvent - Called when there is a key event
'-------------------------------------------------------------------------------
Function onKeyEvent(key as String, press as Boolean) as Boolean

    return true
End Function

'-------------------------------------------------------------------------------
' onPurchase
'-------------------------------------------------------------------------------
Sub onPurchase(evt as Object)

    _purchase = evt.getData()

    ' FOR DEV
    if m.global.environment.name <> "prod"

        ' _purchase = CreateObject("roSGNode", "ContentNode")
        ' m.userManager.purchase = _purchase

        ' _purchase = invalid
        ' m.userManager.purchase = _purchase

        ' m.videoAds = invalid
        ' m.adsManager.settings = invalid
    end if

    isSubscribed = TYPE_isValid(_purchase)
    data = {
        isSubscribed:isSubscribed.toStr(),
        lastOpenedOn:m.lastOpenedOn
    }
	NewRelic_LogEvent("SSPhotos", "AppStarted", data)

    ' subscribed
    if isSubscribed

        m.adsManager.settings = invalid
        m.sessionManager.timeout = 7200 ' 2 hours

    ' free with ads
    else if TYPE_isValid(m.videoAds)

        m.sessionManager.timeout = 14400 ' 4 hours
        m.adsManager.settings = m.videoAds.settings
        m.adsManager.timerInterval = m.videoAds.interval

    ' free with no ads
    else

        m.sessionManager.timeout = 60
    end if

    baseShowScreen(m.global.screens.HomeScreen)
End Sub

'-------------------------------------------------------------------------------
' callbackAppInit
'-------------------------------------------------------------------------------
Sub callbackAppInit(response as Object)

    if API_Utils_Response_isSuccess(response)

        m.videoAds = response.data.results[0].videoAds
        m.global.AddFields({AppInit:response.data.results[0]})
    end if

    REG_User_GetLastOpened(callbackRegGetLastOpened)
End Sub

'-------------------------------------------------------------------------------
' callbackRegGetLastOpened
'-------------------------------------------------------------------------------
Sub callbackRegGetLastOpened(response as Object)

    if TYPE_isValid(response.value)

        m.lastOpenedOn = response.value
    end if

    today = DateTime_InitLocal(invalid, false)
    REG_User_SaveLastOpened(invalid, today.ToISOString())

    m.userManager.callFunc("load")
End Sub
