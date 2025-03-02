'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()
    m.adsManager = m.scene.findNode("AdsManager")
    m.sessionManager = m.scene.findNode("SessionManager")

    m.buttons = m.top.findNode("buttons")
    m.buttons.SetFields({
        itemSize:[resolution.width - 300, 75],
        style:m.global.styles.buttonBlack
    })
    m.buttons.callFunc("create", [
        {id:"start", title:Locale_String("Start")},
        {id:"AddOnsMusicScreen", title:Locale_String("Music")},
        {id:"AddOnsSoundsScreen", title:Locale_String("Sounds")}
    ])
    UI_Screen_PlaceNodeTopCenter(m.buttons, {xOffset:20})
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.adsManager.ObserveFieldScoped("completed", "onAdCompleted")
    m.buttons.ObserveFieldScoped("itemSelected", "onButtons")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

	m.adsManager.UnObserveFieldScoped("completed")
    m.buttons.UnObserveFieldScoped("itemSelected")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'
' @description - Called when the screen becomes active
' @param refresh Boolean - Tells the screen that it should refresh all data.
' This is set by the user when switching screens.
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    if TYPE_isValidPath("input.collectionIds", m.top)

        m.collectionIds = m.top.input.collectionIds
    end if

    item = m.buttons.content.getChild(1)
    item.title = Locale_String("Music") + ": " + m.sessionManager.musicGenre.title

    item = m.buttons.content.getChild(2)
    item.title = Locale_String("Sounds") + ": " + m.sessionManager.sound.title

    baseFocusNode(m.buttons.id)
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

    baseShowScreen(m.global.screens[m.top.input.widgetScreen])
End Sub

'-------------------------------------------------------------------------------
' onButtons
'-------------------------------------------------------------------------------
Sub onButtons(evt as Object)

    button = m.buttons.content.getChild(evt.getData())
    if TYPE_isValid(button)

        if button.id = "start"

            if TYPE_isValid(m.adsManager.settings)

                m.adsManager.callFunc("playAd")
            else

                baseShowScreen(m.global.screens[m.top.input.widgetScreen])
            end if
        else

            baseShowScreen(m.global.screens[button.id], {persists:true})
        end if
    end if
End Sub