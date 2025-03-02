'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.feedbackInProgress = false
    m.KeyManager = KeyManager(["down", "down", "down", "left", "right"])

	feedbackTitle = m.top.findNode("feedbackTitle")
	feedbackTitle.text = Locale_String("feedbackTitle")
	UI_Screen_PlaceNodeTopLeft(feedbackTitle)

	m.keyboard = m.top.findNode("keyboard")
	m.keyboard.textEditBox.SetFields({
		voiceEnabled:false,
		maxTextLength:500
	})
	UI_Node_PlaceBottomLeft(m.keyboard, feedbackTitle, {yOffset:20})

    m.buttons = m.top.findNode("buttons")
    m.buttons.style = m.global.styles.button
	m.buttons.callFunc("create", [
		{id:"send", title:Locale_String("Send")}
	])
    UI_Node_PlaceBottomLeft(m.buttons, m.keyboard, {yOffset:20})

	feedbackMessage = m.top.findNode("feedbackMessage")
	feedbackMessage.text = Locale_String("FeedbackMessage")
	UI_Node_PlaceBottomLeft(feedbackMessage, m.buttons, {xOffset:20})

	versionNumber = m.top.findNode("versionNumber")
	versionNumber.text = Locale_String("Version") + ": " + Device_GetManifestValue("major_version") + "." + Device_GetManifestValue("minor_version")
	UI_Node_PlaceBottomLeft(versionNumber, feedbackMessage, {yOffset:20})

	m.notification = m.top.findNode("notification")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

	m.buttons.ObserveFieldScoped("itemSelected", "onButton")
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

	m.keyboard.setFocus(true)
End Sub

'-------------------------------------------------------------------------------
' onKeyEvent - Called when there is a key event
'-------------------------------------------------------------------------------
Function onKeyEvent(key as String, press as Boolean) as Boolean

    handled = true
    if press

	    keycodes = enum_keycodes()
		if m.KeyManager.matches(key)

			if TYPE_isValid(m.userManager.purchase)

				' DEBUGGING
				bk = CreateObject("roSGNode", "Rectangle")
				bk.SetFields({
					width:1280,
					height:720,
					color:"#000000"
				})
				m.top.appendChild(bk)

				txt = ""
				fields = m.userManager.purchase.getFields()
				for each k in fields

					txt += k + " > " + TYPE_toString(fields[k]) + chr(10)
				end for

				lbl = CreateObject("roSGNode", "Label")
				lbl.font = "font:SmallestSystemFont"
				lbl.translation = [100, 20]
				lbl.width = 1280
				lbl.wrap = true
				lbl.text = txt
				m.top.appendChild(lbl)
			end if
	    else if key = keycodes.BACK

		    baseHistoryBack()
		else if key = keycodes.DOWN

			if NOT m.buttons.hasFocus()

				baseFocusNode(m.buttons.id)
			end if
		else if key = keycodes.UP

			if m.buttons.hasFocus()

				baseFocusNode(m.keyboard.id)
			end if
	    end if
    end if
    return handled
End Function

'-------------------------------------------------------------------------------
' onButton
'-------------------------------------------------------------------------------
Sub onButton(evt as Object)

    button = m.buttons.content.getChild(evt.getData())
    if button.id = "send"

		if Len(m.keyboard.text) < 3

			m.notification.SetFields({
				type:"error",
				timeout:10,
				message:Locale_String("FeedbackEmpty")
			})
		else

			if NOT m.feedbackInProgress

				m.feedbackInProgress = true

				message = m.keyboard.text
				message += " / " + Device_GetManifestValue("title")
				message += " / " + Device_GetManifestValue("major_version") + "." + Device_GetManifestValue("minor_version")

				API_Feedback_Send(callbackFeedback, message)
			end if
		end if
    end if
End Sub

'-------------------------------------------------------------------------------
' callbackFeedback
'-------------------------------------------------------------------------------
Sub callbackFeedback(response as Object)

	if API_Utils_Response_isSuccess(response)

		m.notification.SetFields({
			type:"success",
			timeout:10,
			message:Locale_String("FeedbackSent")
		})

		m.keyboard.text = ""
	else

		m.notification.SetFields({
			type:"error",
			timeout:10,
			message:Locale_String("FeedbackNotSent")
		})
	end if

	m.feedbackInProgress = false
End Sub