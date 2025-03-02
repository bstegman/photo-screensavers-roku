'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()

    m.bakImage = m.top.findNode("bakImage")
    m.bakImage.SetFields({
        height:resolution.height,
        width:resolution.width,
		uri:"pkg:/assets/photos/" + m.global.photos[0]
    })

    m.messageContainer = m.top.findNode("messageContainer")
    m.messageContainer.SetFields({
        width:resolution.width,
        height:75
    })

    m.messageLabel = m.top.findNode("messageLabel")
    m.messageLabel.SetFields({
        height:m.messageContainer.height,
        width:m.messageContainer.width
    })

    m.menu = m.top.findNode("menu")
    createMenu()
    UI_Screen_PlaceNodeCenter(m.menu, {yOffset:20})

    logo = m.top.findNode("logo")
    UI_Screen_PlaceNodeBottomRight(logo, {xOffset:20, yOffset:0})
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.menu.ObserveFieldScoped("itemSelected", "onMenu")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.menu.UnObserveFieldScoped("itemSelected")
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

    baseFocusLastNode(m.menu.id)
End Sub

'-------------------------------------------------------------------------------
' onKeyEvent - Called when there is a key event
'-------------------------------------------------------------------------------
Function onKeyEvent(key as String, press as Boolean) as Boolean

    handled = true
End Function

'-------------------------------------------------------------------------------
' onMenu
'-------------------------------------------------------------------------------
Sub onMenu(evt as Object)

    item = m.menu.content.getChild(evt.getData())
    if TYPE_isValid(item)

        if item.id = "FreeScreen"

            collectionId = Device_GetManifestValue("collection")
            if TYPE_isValid(m.userManager.purchase) AND collectionId <> "0" AND collectionId <> ""

                baseShowScreen(m.global.screens.PhotosAddOnsScreen, {input:{collectionIds:[collectionId]}})
            else

                baseShowScreen(m.global.screens[item.id])
            end if
        else

            baseShowScreen(m.global.screens[item.id])
        end if
    end if
End Sub

'-------------------------------------------------------------------------------
' createMenu
'-------------------------------------------------------------------------------
Sub createMenu()

    content = CreateObject("RoSGNode","ContentNode")

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"FreeScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/homeMenu/play.jpg",
        SHORTDESCRIPTIONLINE1:Device_GetManifestValue("title")
    })

    powerTVScreenId = "PowerTVScreen"
    if NOT TYPE_isValid(m.userManager.purchase) AND TYPE_isValidPath("AppInit.videoAds", m.global)

        powerTVScreenId = "PowerTVFreeScreen"
    end if

    item = content.createChild("ContentNode")
    item.SetFields({
        id:powerTVScreenId,
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/homeMenu/powerTV.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("PowerTV")
    })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"FeedbackScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/homeMenu/feedback.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("Feedback")
    })

    item = content.createChild("ContentNode")
    item.SetFields({
        id:"ScreensaversScreen",
        HDGRIDPOSTERURL:"pkg:/assets/images/icons/homeMenu/screensavers.jpg",
        SHORTDESCRIPTIONLINE1:Locale_String("FreeScreensavers")
    })

    m.menu.content = content
End Sub
