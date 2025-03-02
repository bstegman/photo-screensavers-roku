'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()

    m.sessionManager = m.scene.findNode("SessionManager")

    title = m.top.findNode("title")
    title.text = Locale_String("SelectSound")
    UI_Screen_PlaceNodeTopCenter(title)

    m.labelGrid = m.top.findNode("labelGrid")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.labelGrid.ObserveFieldScoped("itemSelected", "onGridSelected")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.labelGrid.UnObserveFieldScoped("itemSelected")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'
' @description - Called when the screen becomes active
' @param refresh Boolean - Tells the screen that it should refresh all data.
' This is set by the user when switching screens.
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    API_Sounds_Get(callbackSoundsGet)
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
' callbackSoundsGet
'-------------------------------------------------------------------------------
Sub callbackSoundsGet(response as Object)

    if API_Utils_Response_isSuccess(response)

        content = CreateObject("roSGNode", "ContentNode")
        
        item = content.createChild("ContentNode")
        item.SetFields({
            id:"none",
            title:Locale_String("None")
        })

        results = response.data.results
        for i=0 to results.Count() - 1

            result = results[i]

            item = content.createChild("ContentNode")
            item.AddFields({url:result.url})
            item.SetFields({
                id:result.id,
                title:result.title
            })
        end for
        m.labelGrid.content = content
        UI_Screen_PlaceNodeCenter(m.labelGrid, {yOffset:60})
        m.labelGrid.visible = true

        baseFocusNode(m.labelGrid.id)
    end if
End Sub

'-------------------------------------------------------------------------------
' onGridSelected
'-------------------------------------------------------------------------------
Sub onGridSelected(evt as Object)

    m.sessionManager.sound = m.labelGrid.content.getChild(evt.getData())

    none = CreateObject("roSGNode", "ContentNode")
    none.SetFields({
        id:"none",
        title:Locale_String("None")
    })
    m.sessionManager.musicGenre = none

    baseHistoryBack()
End Sub