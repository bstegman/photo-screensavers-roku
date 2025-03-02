'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()
    m.sessionManager = m.scene.findNode("SessionManager")

    m.title = m.top.findNode("title")
    m.title.text = Locale_String("Widgets")
    UI_Screen_PlaceNodeTopCenter(m.title)

    m.grid = m.top.findNode("grid")
    createGrid()
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

    m.sessionManager.callFunc("clearAll")

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
    baseShowScreen(m.global.screens.WidgetsAddOnsScreen, {input:{widgetScreen:item.id}, persists:true})
End Sub

'-------------------------------------------------------------------------------
' createGrid
'-------------------------------------------------------------------------------
Sub createGrid()

    content = CreateObject("RoSGNode","ContentNode")

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"WidgetAquariumScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/widgets/aquarium.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("Aquarium")
    })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"WidgetBinaryScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/widgets/binary.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("Binary")
    })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"WidgetFallingLeavesScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/widgets/falling-leaves.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("FallingLeaves")
    })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"WidgetHalloweenScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/widgets/halloween.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("Halloween")
    })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"WidgetPongScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/widgets/pong.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("Pong")
    })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"WidgetDVDLogoScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/widgets/dvd-logo.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("DVDLogo")
    })

    m.grid.content = content
    UI_Screen_PlaceNodeCenter(m.grid, {yOffset:20})
End Sub