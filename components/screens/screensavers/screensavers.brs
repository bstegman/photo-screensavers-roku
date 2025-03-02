'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    title = m.top.findNode("title")
    title.text = Locale_String("Screensavers")
    UI_Screen_PlaceNodeTopLeft(title)

    m.catalog = m.top.findNode("catalog")
    UI_Node_PlaceBottomLeft(m.catalog, title, {yOffset:20})
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

    request = {
        host:m.global.environment.website.host,
        url:"/feeds/screensavers.json",
        requestId:"get-catalog",
        validate:false,
        log:false
    }
    API_Utils_SendRequest(callbackGetCataLog, request)
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
' callbackGetCataLog
'-------------------------------------------------------------------------------
Sub callbackGetCataLog(response as Object)

    if API_Utils_Response_isSuccess(response)

        content = CreateObject("RoSGNode","ContentNode")

        for i=0 to response.data.roku.Count() - 1

			app = response.data.roku[i]

			item = content.createChild("ContentNode")
            item.HDGRIDPOSTERURL = app.icon
			item.SHORTDESCRIPTIONLINE1 = app.title
		end for

        m.catalog.content = content
    end if

    baseFocusNode(m.catalog.id)
End Sub