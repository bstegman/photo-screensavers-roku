'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()

    m.sessionManager = m.scene.findNode("SessionManager")

    title = m.top.findNode("title")
    title.text = Locale_String("Animations")
    UI_Screen_PlaceNodeTopCenter(title)

    m.animations = m.top.findNode("animations")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.animations.ObserveFieldScoped("itemSelected", "onAnimation")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.animations.UnObserveFieldScoped("itemSelected")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'
' @description - Called when the screen becomes active
' @param refresh Boolean - Tells the screen that it should refresh all data.
' This is set by the user when switching screens.
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    content = m.animations.content
    content.getChild(0).title = Locale_String("None")

    checked = [(m.sessionManager.animation = "none")]

    animations = [
        {
            key:"snow",
            title:Locale_String("Snow")
        },
        {
            key:"leaves",
            title:Locale_String("Leaves")
        }
    ]
    for i=0 to animations.Count() - 1

        animation = animations[i]
        checked.Push((m.sessionManager.animation = animation.key))

        item = content.createChild("ContentNode")
        item.SetFields({
            id:animation.key,
            title:animation.title
        })
    end for
    m.animations.content = content
    m.animations.checkedState = checked
    UI_Screen_PlaceNodeCenter(m.animations)
    m.animations.visible = true

    baseFocusNode(m.animations.id)
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
' onAnimation
'-------------------------------------------------------------------------------
Sub onAnimation(evt as Object)

    idx = evt.getData()
    checked = m.animations.checkedState
    for i=0 to m.animations.content.getChildCount() - 1

        checked[i] = (i = idx)
        if checked[i]

            item = m.animations.content.getChild(i)
            m.sessionManager.animation = item.id
        end if
    end for
    m.animations.checkedState = checked
End Sub