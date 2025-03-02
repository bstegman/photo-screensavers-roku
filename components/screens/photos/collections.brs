'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution =  UI_Resolution()
    m.collectionIds = []
    m.sessionManager = m.scene.findNode("SessionManager")

    m.title = m.top.findNode("title")
    m.title.SetFields({
        text:Locale_String("CollectionsMessage")
    })

    m.grid = m.top.findNode("grid")
    UI_Node_PlaceBottomLeft(m.grid, m.title, {yOffset:20})

    m.titleCollections = m.top.findNode("titleCollections")

    m.grid1 = m.top.findNode("grid1")
    m.grid1.content = CreateObject("RoSGNode","ContentNode")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow
'
' @description - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.grid.ObserveFieldScoped("itemSelected", "onGridSelected")
    m.grid1.ObserveFieldScoped("itemSelected", "onGrid1Selected")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide
'
' @description - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.sessionManager.callFunc("clearAll")

    m.grid.UnObserveFieldScoped("itemSelected")
    m.grid1.UnObserveFieldScoped("itemSelected")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'
' @description - Called when the screen becomes active
' @param refresh Boolean - Tells the screen that it should refresh all data.
' This is set by the user when switching screens.
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    if NOT TYPE_isValid(m.grid.content)

        Utils_Spinner_Show()

        REG_Collections_Get(callbackRegCollectionsGet)
    else

        baseFocusLastNode(m.grid.id)
    end if
End Sub

'-------------------------------------------------------------------------------
' onKeyEvent
'
' @description - Called when there is a key event
'-------------------------------------------------------------------------------
Function onKeyEvent(key as String, press as Boolean) as Boolean

    handled = true
    if press

        keycodes = enum_keycodes()
		if key = keycodes.BACK

			baseHistoryBack()
        else if key = keycodes.LEFT

            if m.grid1.hasFocus()

                baseFocusNode(m.grid.id)
            end if
        else if key = keycodes.PLAY

            if m.collectionIds.Count() > 0

                baseShowScreen(m.global.screens.PhotosAddOnsScreen, {input:{collectionIds:m.collectionIds}, persists:true})
            end if
        else if key = keycodes.RIGHT

            if TYPE_isValid(m.grid1.content) AND m.grid1.content.getChildCount() > 0

                baseFocusNode(m.grid1.id)
            end if
		end if
    end if
    return handled
End Function

'-------------------------------------------------------------------------------
' onGridSelected
'-------------------------------------------------------------------------------
Sub onGridSelected(evt as Object)

    item = m.grid.content.getChild(evt.getData())
    if m.collectionIds.Count() < 5 AND NOT TYPE_isInArray(m.collectionIds, item.id, false)

        m.collectionIds.Push(item.id)
        REG_Collections_Save(invalid, m.collectionIds)

        _item = m.grid1.content.createChild("ContentNode")
        _item.SetFields({
            id:item.id,
            HDGRIDPOSTERURL:item.hdgridposterurl,
            SHORTDESCRIPTIONLINE1:item.shortdescriptionline1
        })
    end if

    updatePlaylist()
End Sub

'-------------------------------------------------------------------------------
' onGrid1Selected
'-------------------------------------------------------------------------------
Sub onGrid1Selected(evt as Object)

    item = m.grid1.content.getChild(evt.getData())
    idx = -1
    for i=0 to m.collectionIds.Count() - 1

        if item.id = m.collectionIds[i]

            m.grid1.content.removeChild(item)

            m.collectionIds.Delete(i)
            REG_Collections_Save(invalid, m.collectionIds)
            exit for
        end if
    end for

    if m.grid1.content.getChildCount() <= 0

        baseFocusNode(m.grid.id)
    end if

    updatePlaylist()
End Sub

'-------------------------------------------------------------------------------
' callbackGetCollections
'-------------------------------------------------------------------------------
Sub callbackGetCollections(response as Object)

	if API_Utils_Response_isSuccess(response)

        content = CreateObject("RoSGNode","ContentNode")
        for each collection in response.data.results

			item = content.createChild("ContentNode")
			item.SetFields({
				id:collection.id,
				HDGRIDPOSTERURL:collection.urlThumb,
				SHORTDESCRIPTIONLINE1:collection.name
			})
            ' item.AddFields({collection:collection})

            if TYPE_isInArray(m.collectionIds, item.id, false)

                item = m.grid1.content.createChild("ContentNode")
                item.SetFields({
                    id:collection.id,
                    HDGRIDPOSTERURL:collection.urlThumb,
                    SHORTDESCRIPTIONLINE1:collection.name
                })
            end if
        end for
        m.grid.content = content

        baseFocusLastNode(m.grid.id)
	end if

    updatePlaylist()

    Utils_Spinner_Hide()
End Sub

'-------------------------------------------------------------------------------
' callbackRegCollectionsGet
'-------------------------------------------------------------------------------
Sub callbackRegCollectionsGet(response as Object)

    if TYPE_isValidPath("value.collectionIds", response) AND NOT TYPE_isStringEmpty(response.value.collectionIds)

        m.collectionIds = response.value.collectionIds.split(",")
    end if

    API_Collections_Get(callbackGetCollections)
End Sub

'-------------------------------------------------------------------------------
' updatePlaylist
'-------------------------------------------------------------------------------
Sub updatePlaylist()

    if m.collectionIds.Count() > 0

        m.titleCollections.text = Locale_String("CollectionsMessagePlay")
        UI_Node_PlaceBottomLeft(m.grid1, m.titleCollections, {yOffset:20})
    else

        m.titleCollections.text = ""
    end if
End Sub