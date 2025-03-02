'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()

    m.title = m.top.findNode("title")
    m.title.text = Locale_String("FreeMessage")
    UI_Screen_PlaceNodeTopCenter(m.title)

    m.buttons = m.top.findNode("buttons")
    m.buttons.SetFields({
        itemSize:[resolution.width - 300, 75],
        style:m.global.styles.button
    })
    m.buttons.callFunc("create", [
        {id:"FreeScreensaverScreen", title:Locale_String("Start")},
        {id:"AddOnsClockScreen", title:Locale_String("Clock")},
        {id:"AddOnsAnimationsScreen", title:Locale_String("Animations")}
    ])
    UI_Screen_PlaceNodeCenter(m.buttons, {xOffset:20})
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.buttons.ObserveFieldScoped("itemSelected", "onButtons")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

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
' onButtons
'-------------------------------------------------------------------------------
Sub onButtons(evt as Object)

    button = m.buttons.content.getChild(evt.getData())
    if TYPE_isValid(button)

        baseShowScreen(m.global.screens[button.id])
    end if
End Sub