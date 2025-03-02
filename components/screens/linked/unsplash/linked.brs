'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()
    m.apiErrorCodes = Enums_Api_ErrorCodes()
    m.integration = invalid
    m.sessionManager = m.scene.findNode("SessionManager")

    width = resolution.width - 200

    ' link
    m.linkContainer = m.top.findNode("linkContainer")

    m.linkLabel = m.top.findNode("linkLabel")
    m.linkLabel.SetFields({
        text:Locale_String("UnsplashLink"),
        width:width
    })
    UI_Screen_PlaceNodeTopLeft(m.linkLabel, {yOffset:200})

    m.linkButtons = m.top.findNode("linkButtons")
    m.linkButtons.SetFields({
        style:m.global.styles.buttonBlack,
        itemSize:[width, 75]
    })

    items = [
		{id:"link", title:Locale_String("Refresh")},
	]
	m.linkButtons.callFunc("create", items)
    UI_Node_PlaceBottomLeft(m.linkButtons, m.linkLabel, {yOffset:40})

    ' linked
    m.linkedContainer = m.top.findNode("linkedContainer")

    m.linkedButtons = m.top.findNode("linkedButtons")
    m.linkedButtons.SetFields({
        style:m.global.styles.buttonBlack,
        itemSize:[width, 75]
    })

    items = [
        {id:"LinkedUnsplashViewScreen", title:Locale_String("Start")},
        {id:"AddOnsAnimationsScreen", title:Locale_String("Animations")}
        {id:"AddOnsClockScreen", title:Locale_String("Clock")},
        {id:"AddOnsMusicScreen", title:Locale_String("Music")},
        {id:"AddOnsSoundsScreen", title:Locale_String("Sounds")},
        {id:"AddOnsWeatherScreen", title:Locale_String("Weather")}
		{id:"unlink", title:Locale_String("UnLink")}
	]
	m.linkedButtons.callFunc("create", items)
    UI_Screen_PlaceNodeTopCenter(m.linkedButtons, {xOffset:20})

    proTip = m.top.findNode("proTip")
    proTip.text = Locale_String("ProTip1")
    UI_Screen_PlaceNodeBottomCenter(proTip)
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.linkButtons.ObserveFieldScoped("itemSelected", "onLinkButtons")
    m.linkedButtons.ObserveFieldScoped("itemSelected", "onLinkedButtons")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.linkButtons.UnObserveFieldScoped("itemSelected")
    m.linkedButtons.UnObserveFieldScoped("itemSelected")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    Utils_Spinner_Show()

    item = m.linkedButtons.content.getChild(3)
    item.title = Locale_String("Music") + ": " + m.sessionManager.musicGenre.title

    item = m.linkedButtons.content.getChild(4)
    item.title = Locale_String("Sounds") + ": " + m.sessionManager.sound.title

    API_Integrations_Unsplash_Get(callbackIntegrationGet)
End Sub

'-------------------------------------------------------------------------------
' _onKeyEvent
'-------------------------------------------------------------------------------
Function onKeyEvent(key as String, press as Boolean) as Boolean

    handled = true
    if press

        keycodes = enum_keycodes()
        if key = keycodes.BACK

            baseHistoryBack()
        else if key = keycodes.RIGHT

            if m.nav.callFunc("isFocused")

                if m.linkContainer.visible
                    
                    baseFocusNode(m.linkButtons.id)
                else if m.linkedContainer.visible

                    baseFocusNode(m.linkedButtons.id)
                end if
            end if
        else if key = keycodes.LEFT

            if m.linkButtons.hasFocus() OR m.linkedButtons.hasFocus()

                baseFocusNode(m.nav.id)
            end if
        end if
    end if

    return handled
End Function

'-------------------------------------------------------------------------------
' onLinkButtons
'-------------------------------------------------------------------------------
Sub onLinkButtons(evt as Object)

    Utils_Spinner_Show()

    API_Integrations_Unsplash_Get(callbackIntegrationGet)
End Sub

'-------------------------------------------------------------------------------
' onLinkedButtons
'-------------------------------------------------------------------------------
Sub onLinkedButtons(evt as Object)

    item = m.linkedButtons.content.getChild(evt.getData())
    if item.id = "unlink"

        Utils_Spinner_Show()

        API_Integrations_Unsplash_Revoke(callbackIntegrationRemove)
    else

        baseShowScreen(m.global.screens[item.id])
    end if
End Sub

'-------------------------------------------------------------------------------
' onModalUnlinkConfirm
'-------------------------------------------------------------------------------
Sub onModalUnlinkConfirm(evt as Object)

    ModalMessaging_Close()

    if evt.getData() = "ok"

        if TYPE_isValid(m.integration)

            API_Integrations_Unsplash_Revoke(callbackRevoke, m.integration.access_token)
        else

            baseFocusNode(m.nav.id)
        end if
    else

        baseFocusLastNode(m.nav.id)
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackRevoke
'-------------------------------------------------------------------------------
Sub callbackRevoke(response as Object)

    if API_Utils_Response_isSuccess(response)

        m.linkContainer.visible = true
        m.linkedContainer.visible = false
        
        if TYPE_isBooleanEqualTo(m.isCurrent, true)

            REG_ScreenSaver_SaveCurrent(invalid, m.global.screensavers.aquarium.key)
        end if
    end if

    baseFocusNode(m.nav.id)
End Sub

'-------------------------------------------------------------------------------
' callbackIntegrationGet
'-------------------------------------------------------------------------------
Sub callbackIntegrationGet(response as Object)

    if API_Utils_Response_isSuccess(response)

        m.integration = response.data.results[0]

        m.linkContainer.visible = false
        m.linkedContainer.visible = true

        baseFocusNode(m.linkedButtons.id)
    else if API_Utils_IsErrorWithCode(response, m.apiErrorCodes.NOT_FOUND)

        m.linkContainer.visible = true
        m.linkedContainer.visible = false

        baseFocusNode(m.linkButtons.id)
    end if

    Utils_Spinner_Hide()
End Sub

'-------------------------------------------------------------------------------
' callbackIntegrationRemove
'-------------------------------------------------------------------------------
Sub callbackIntegrationRemove(response as Object)

    Utils_Spinner_Hide()
    baseHistoryBack()
End Sub