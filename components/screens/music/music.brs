'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()
    m.adsManager = m.scene.findNode("AdsManager")

    title = m.top.findNode("title")
    title.text = Locale_String("Music")
    UI_Screen_PlaceNodeTopCenter(title)

    m.grid = m.top.findNode("grid")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

	m.adsManager.ObserveFieldScoped("completed", "onAdCompleted")
    m.grid.ObserveFieldScoped("itemSelected", "onGridSelected")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

	m.adsManager.UnObserveFieldScoped("completed")
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
        end if
    end if
    return handled
End Function

'-------------------------------------------------------------------------------
' onAdCompleted
'-------------------------------------------------------------------------------
Sub onAdCompleted(evt as Object)

    Utils_Log("ad completed")
    item = m.grid.content.getChild(m.grid.itemSelected)
    baseShowScreen(m.global.screens.MusicScreensaverScreen, {input:{genre:item.genre}})
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
        UI_Screen_PlaceNodeCenter(m.grid)

        baseFocusNode(m.grid.id)
	end if

    Utils_Spinner_Hide()
End Sub

'-------------------------------------------------------------------------------
' onGridSelected
'-------------------------------------------------------------------------------
Sub onGridSelected(evt as Object)

    if TYPE_isValid(m.adsManager.settings)

        m.adsManager.callFunc("playAd")
    else

        item = m.grid.content.getChild(evt.getData())
        baseShowScreen(m.global.screens.MusicScreensaverScreen, {input:{genre:item.genre}})
    end if
End Sub