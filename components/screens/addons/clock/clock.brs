'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()

    title = m.top.findNode("title")
    title.text = Locale_String("ConfigureClock")
    UI_Screen_PlaceNodeTopLeft(title)

    m.settingsContainer = m.top.findNode("settingsContainer")

    m.clockLabel = m.top.findNode("clockLabel")
	m.clockLabel.text = Locale_String("Settings")

	m.clockChecklist = m.top.findNode("clockChecklist")
	m.clockChecklist.checkedState = [false, false]

	m.clockEnabled = m.top.findNode("clockEnabled")
	m.clockEnabled.title = Locale_String("Enabled")

	m.clockShowDate = m.top.findNode("clockShowDate")
	m.clockShowDate.title = Locale_String("ShowDate")

    UI_Screen_PlaceNodeTopLeft(m.settingsContainer, {xOffset:100, yOffset:150})

    m.stylesContainer = m.top.findNode("stylesContainer")

    m.styleLabel = m.top.findNode("styleLabel")
	m.styleLabel.text = Locale_String("StyleMessage")
    m.styles = m.top.findNode("styles")
    createStyles()
    UI_Node_PlaceBottomLeft(m.stylesContainer, m.settingsContainer, {yOffset:20})

    m.clock = m.top.findNode("clock")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.clockChecklist.ObserveFieldScoped("itemSelected", "onClock")
    m.styles.ObserveFieldScoped("itemFocused", "onStyles")
    m.styles.ObserveFieldScoped("itemSelected", "onStylesSelected")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.clockChecklist.UnObserveFieldScoped("itemSelected")
    m.styles.UnObserveFieldScoped("itemFocused")
    m.styles.UnObserveFieldScoped("itemSelected")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    REG_Clock_Get(callbackRegGet)
End Sub

'-------------------------------------------------------------------------------
' _onKeyEvent
'-------------------------------------------------------------------------------
Function onKeyEvent(key as String, press as Boolean) as Boolean

    handled = true
    if press
	
	    keycodes = enum_keycodes()
        if key = keycodes.BACK

            baseHistoryBack()
        else if key = keycodes.DOWN

            if m.clockChecklist.hasFocus()

                baseFocusNode(m.styles.id)
            end if
        else if key = keycodes.UP

            if m.styles.hasFocus()

                baseFocusNode(m.clockChecklist.id)
            end if        
        end if
    end if
End Function

'-------------------------------------------------------------------------------
' onClock
'-------------------------------------------------------------------------------
Sub onClock(evt as Object)

    config = m.clock.config
    if m.clockChecklist.checkedState[1]

        config.format = "dateTime"
    else

        config.format = "time"
    end if
    m.clock.config = config
    UI_Screen_PlaceNodeTopRight(m.clock)

    saveToRegistry()
End Sub

'-------------------------------------------------------------------------------
' onStyles
'-------------------------------------------------------------------------------
Sub onStyles(evt as Object)

    item = m.styles.content.getChild(evt.getData())

    config = m.clock.config
    config.style = item.id
    m.clock.config = config
    UI_Screen_PlaceNodeTopRight(m.clock)
End Sub

'-------------------------------------------------------------------------------
' onStylesSelected
'-------------------------------------------------------------------------------
Sub onStylesSelected(evt as Object)

    for i=0 to m.styles.content.getChildCount() - 1

        item = m.styles.content.getChild(i)
        item.checked = false
    end for

    item = m.styles.content.getChild(evt.getData())
    item.checked = true

    saveToRegistry()
End Sub

'-------------------------------------------------------------------------------
' callbackRegGet
'-------------------------------------------------------------------------------
Sub callbackRegGet(response as Object)

    checkedState = m.clockChecklist.checkedState
    config = m.clock.config

    if NOT TYPE_isAssocArrayEmpty(response.value)

        if TYPE_isValid(response.value.enabled)

            checkedState[0] = TYPE_toBoolean(response.value.enabled)
        end if

        if TYPE_isValid(response.value.format)

            if response.value.format = "dateTime"

                checkedState[1] = true
            end if

            config.format = response.value.format
        end if

        if TYPE_isValid(response.value.style)

            config.style = response.value.style
        end if
    else

        if config.format = "dateTime"

            checkedState[1] = true
        end if
    end if

    m.clock.config = config
    m.clockChecklist.checkedState = checkedState

    for i=0 to m.styles.content.getChildCount() - 1

        item = m.styles.content.getChild(i)
        if item.id = m.clock.config.style

            item.checked = true
            ' m.styles.jumpToItem = 9
            exit for
        end if
    end for
    UI_Screen_PlaceNodeTopRight(m.clock)

    baseFocusNode(m.clockChecklist.id)
End Sub

'-------------------------------------------------------------------------------
' createStyles
'-------------------------------------------------------------------------------
Sub createStyles()

    content = CreateObject("roSGNode", "ContentNode")

    item = content.createChild("ListItemNode") 
    item.SetFields({
        id:"Bonbon",
        title:"Style 1"
    })

    item = content.createChild("ListItemNode") 
    item.SetFields({
        id:"Dancing",
        title:"Style 2"
    })

    item = content.createChild("ListItemNode") 
    item.SetFields({
        id:"Evert",
        title:"Style 3"
    })

    item = content.createChild("ListItemNode")
    item.SetFields({
        id:"Lexend",
        title:"Style 4"
    })

    item = content.createChild("ListItemNode") 
    item.SetFields({
        id:"Mansalva",
        title:"Style 5"
    })

    item = content.createChild("ListItemNode") 
    item.SetFields({
        id:"MetalMania",
        title:"Style 6"
    })

    item = content.createChild("ListItemNode") 
    item.SetFields({
        id:"Monoton",
        title:"Style 7"
    })

    item = content.createChild("ListItemNode") 
    item.SetFields({
        id:"Nosifer",
        title:"Style 8"
    })

    item = content.createChild("ListItemNode") 
    item.SetFields({
        id:"PressStart2P",
        title:"Style 9"
    })

    item = content.createChild("ListItemNode") 
    item.SetFields({
        id:"Shojumaru",
        title:"Style 10"
    })
    
    m.styles.content = content
End Sub

'-------------------------------------------------------------------------------
' save
'-------------------------------------------------------------------------------
Sub saveToRegistry()

    REG_Clock_Save(invalid, {style:m.clock.config.style, format:m.clock.config.format, enabled:m.clockChecklist.checkedState[0].toStr()})
End Sub
