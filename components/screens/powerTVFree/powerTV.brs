'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()
    m.channelStore = m.userManager.callFunc("getChannelStore")

    m.menu = m.top.findNode("menu")
    createMenu()

    m.messageContainer = m.top.findNode("messageContainer")
    m.messageContainer.SetFields({
        width:resolution.width,
        height:150,
        translation:[0, resolution.height - 150]
    })

    m.messageLabel = m.top.findNode("messageLabel")
    m.messageLabel.SetFields({
        height:m.messageContainer.height,
        width:m.messageContainer.width
    })
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.menu.ObserveFieldScoped("itemSelected", "onMenu")
    m.userManager.ObserveFieldScoped("purchase", "onPurchase")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.menu.UnObserveFieldScoped("itemSelected")
    m.userManager.UnObserveFieldScoped("purchase")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'
' @description - Called when the screen becomes active
' @param refresh Boolean - Tells the screen that it should refresh all data.
' This is set by the user when switching screens.
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    m.messageContainer.visible = false

    appInit = m.global.AppInit
    if TYPE_isValid(appInit)

        if appInit.HomeMessage.text <> ""

            m.messageLabel.text = appInit.HomeMessage.text
            m.messageContainer.visible = true
        end if
    end if

    baseFocusNode(m.menu.id)
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
' onMenu
'-------------------------------------------------------------------------------
Sub onMenu(evt as Object)

    item = m.menu.content.getChild(evt.getData())
    if item.id = "subscribe"

        m.userManager.callFunc("makePurchase")
    else

        baseShowScreen(m.global.screens[item.id])
    end if
End Sub

'-------------------------------------------------------------------------------
' onPurchase
'-------------------------------------------------------------------------------
Sub onPurchase(evt as Object)

    if TYPE_isValid(evt.getData())

        m.router.callFunc("popHistory")
        baseShowScreen(m.global.screens.StartupScreen)
    else

        baseFocusNode(m.menu.id)
    end if
End Sub

'-------------------------------------------------------------------------------
' createMenu
'-------------------------------------------------------------------------------
Sub createMenu()

    content = CreateObject("RoSGNode","ContentNode")

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"subscribe",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/menu/subscribe.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("RemoveAds")
    })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"PhotosCollectionsScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/menu/collections.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("PhotoCollections")
    })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"MusicScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/menu/music.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("Music")
    })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"WidgetsScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/menu/widgets.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("Widgets")
    })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"VideosScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/menu/videos.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("Videos")
    })

    ' item = content.createChild("ContentNode")
    ' item.SetFields({
    '     id:"LinkedScreen",
    '     HDGRIDPOSTERURL:"pkg:/assets/images/icons/menu/chain.jpg",
    '     SHORTDESCRIPTIONLINE1:Locale_String("Linked")
    ' })

    ' item = content.createChild("ContentNode")
    ' item.SetFields({
    '     id:"USBScreen",
    '     HDGRIDPOSTERURL:"pkg:/assets/images/icons/menu/usb.jpg",
    '     SHORTDESCRIPTIONLINE1:Locale_String("USBStick")
    ' })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"FeedbackScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/menu/feedback.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("Feedback")
    })

    m.menu.content = content
End Sub