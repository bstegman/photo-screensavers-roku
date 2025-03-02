'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()

    m.sessionManager = m.scene.findNode("SessionManager")

    title = m.top.findNode("title")
    title.text = Locale_String("SelectMusic")
    UI_Screen_PlaceNodeTopCenter(title)

    m.buttons = m.top.findNode("buttons")
    m.buttons.SetFields({
        itemSize:[1100, 75],
        style:m.global.styles.buttonBlack
    })
    m.buttons.callFunc("create", [
        {id:"none", title:Locale_String("None")},
    ])
    UI_Screen_PlaceNodeTopCenter(m.buttons, {yOffset:150})

    m.grid = m.top.findNode("grid")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.buttons.ObserveFieldScoped("itemSelected", "onButtons")
    m.grid.ObserveFieldScoped("itemSelected", "onGridSelected")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.buttons.UnObserveFieldScoped("itemSelected")
    m.grid.UnObserveFieldScoped("itemSelected")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'
' @description - Called when the screen becomes active
' @param refresh Boolean - Tells the screen that it should refresh all data.
' This is set by the user when switching screens.
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    Utils_Spinner_Show()

    API_Music_Genres(callbackGetGenres)
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
        else if key = keycodes.DOWN

            if m.buttons.hasFocus()

                baseFocusNode(m.grid.id)
            end if
        else if key = keycodes.UP

            if m.grid.hasFocus()

                baseFocusNode(m.buttons.id)
            end if
        end if
    end if
    return handled
End Function

'-------------------------------------------------------------------------------
' onButtons
'-------------------------------------------------------------------------------
Sub onButtons()

    m.sessionManager.callFunc("clearMusic")

    baseHistoryBack()
End Sub

'-------------------------------------------------------------------------------
' callbackGetGenres
'-------------------------------------------------------------------------------
Sub callbackGetGenres(response as Object)

	if API_Utils_Response_isSuccess(response)

        content = CreateObject("RoSGNode","ContentNode")
        for i=0 to response.data.results.Count() - 1

            genre = response.data.results[i]

			item = content.createChild("ContentNode")
			item.SetFields({
				id:genre.key,
				HDGRIDPOSTERURL:genre.coverPhotoUrl,
				SHORTDESCRIPTIONLINE1:genre.title
			})
            item.AddFields({genre:genre})
        end for
        m.grid.content = content
        UI_Screen_PlaceNodeTopCenter(m.grid, {xOffset:10, yOffset:275})

        baseFocusNode(m.grid.id)
	end if

    Utils_Spinner_Hide()
End Sub

'-------------------------------------------------------------------------------
' onGridSelected
'-------------------------------------------------------------------------------
Sub onGridSelected(evt as Object)

    genre = m.grid.content.getChild(evt.getData()).genre

    item = CreateObject("roSGNode", "ContentNode")
    item.SetFields({
        id:genre.key,
        title:genre.title
    })
    m.sessionManager.musicGenre = item

    m.sessionManager.callfunc("clearSound")

    baseHistoryBack()
End Sub