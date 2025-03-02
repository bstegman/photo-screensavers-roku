'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	resolution = UI_Resolution()

	message1 = m.top.findNode("message1")
	message1.text = Locale_String("Message1")
	message1.width = resolution.width - 80
	message1.translation = [40, 60]

	message2 = m.top.findNode("message2")
	message2.text = Locale_String("Message2")
	message2.width = resolution.width - 80
	UI_Node_PlaceBottomLeft(message2, message1, {yOffset:60})

	message3 = m.top.findNode("message3")
	message3.text = Locale_String("Message3")
	message3.width = resolution.width
	message3.translation = [0, resolution.height - 100]
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()
End Sub

'-------------------------------------------------------------------------------
' _isActive
'
' @description - Called when the screen becomes active
' @param refresh Boolean - Tells the screen that it should refresh all data.
' This is set by the user when switching screens.
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)
End Sub

'-------------------------------------------------------------------------------
' onKeyEvent - Called when there is a key event
'-------------------------------------------------------------------------------
Function onKeyEvent(key as String, press as Boolean) as Boolean

    handled = true
    if press

		baseShowScreen(m.global.screens.HomeScreen)
    end if
    return handled
End Function