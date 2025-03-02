'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()

    m.title = m.top.findNode("title")
    m.title.text = Locale_String("Linked")
    UI_Screen_PlaceNodeTopCenter(m.title)

    m.grid = m.top.findNode("grid")
    createGrid()

    notification = m.top.findNode("notification")
    notification.SetFields({
        type:"success",
        timeout:0,
        message:Locale_String("GoogleMessage")
    })
    UI_Screen_PlaceNodeBottomCenter(notification)
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.grid.ObserveFieldScoped("itemSelected", "onGrid")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.grid.UnObserveFieldScoped("itemSelected")
End Sub

'-------------------------------------------------------------------------------
' __isActive
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    baseFocusNode(m.grid.id)
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
' onGrid
'-------------------------------------------------------------------------------
Sub onGrid(evt as Object)

    item = m.grid.content.getChild(evt.getData())
    if NOT TYPE_isValid(m.userManager.user)

        baseShowScreen(m.global.screens.AccountLinkScreen, {input:{appName:item.SHORTDESCRIPTIONLINE1, screen:item.id}})
    else

        baseShowScreen(m.global.screens[item.id])
    end if
End Sub

'-------------------------------------------------------------------------------
' createGrid
'-------------------------------------------------------------------------------
Sub createGrid()

    content = CreateObject("RoSGNode","ContentNode")

    ' item = content.createChild("ContentNode")
    ' item.SetFields({
    '     id:"LinkedGooglePhotosScreen",
    '     HDGRIDPOSTERURL:"pkg:/assets/images/icons/linked/google-photos.png",
    '     SHORTDESCRIPTIONLINE1:"Google Photos"
    ' })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"LinkedUnsplashScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/linked/unsplash.png",
        SHORTDESCRIPTIONLINE1:"Unsplash"
    })

    m.grid.content = content
    UI_Screen_PlaceNodeCenter(m.grid, {yOffset:20})
End Sub