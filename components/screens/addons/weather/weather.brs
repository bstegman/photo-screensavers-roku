'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()
    m.weatherSettings = invalid

    m.title = m.top.findNode("title")
    m.title.text = Locale_String("ConfigureWeather")
    UI_Screen_PlaceNodeTopCenter(m.title)

    container = m.top.findNode("container")
    m.currentZip = m.top.findNode("currentZip")

    m.enterZip = m.top.findNode("enterZip")
    m.enterZip.text = Locale_String("EnterZip")

    m.keyboard = m.top.findNode("keyboardNumbers")

    m.results = m.top.findNode("results")
    UI_Node_PlaceTopRight(m.results, m.keyboard, {xOffset:450, yOffset:175})

    m.buttons = m.top.findNode("buttons")
    m.buttons.SetFields({
        style:m.global.styles.buttonBlack,
        itemSize:[650, 75]
    })

    m.notification = m.top.findNode("notification")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.buttons.ObserveFieldScoped("itemSelected", "onButtons")
    m.keyboard.ObserveFieldScoped("keypressed", "onKeyboard")
    m.results.ObserveFieldScoped("itemSelected", "onResultSelected")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.buttons.UnObserveFieldScoped("itemSelected")
    m.keyboard.UnObserveFieldScoped("keypressed")
    m.results.UnObserveFieldScoped("itemSelected")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'
' @description - Called when the screen becomes active
' @param refresh Boolean - Tells the screen that it should refresh all data.
' This is set by the user when switching screens.
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    REG_Weather_Get(callbackRegGetWeather)
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

            if m.buttons.visible AND m.keyboard.callFunc("isFocused")

                baseFocusNode(m.buttons.id)
            end if
        else if key = keycodes.LEFT

            if m.results.hasFocus()

                baseFocusNode(m.keyboard.id)
            end if
        else if key = keycodes.RIGHT

            if m.keyboard.callFunc("isFocused") AND m.results.visible

                baseFocusNode(m.results.id)
            end if
        else if key = keycodes.UP

            if m.buttons.hasFocus()

                baseFocusNode(m.keyboard.id)
            end if
	    end if
    end if
    return handled
End Function

'-------------------------------------------------------------------------------
' onButtons
'-------------------------------------------------------------------------------
Sub onButtons(evt as Object)

    button = m.buttons.content.getChild(evt.getData())
    if button.id = "template"

        baseShowScreen(m.global.screens.AddOnsWeatherTemplatesScreen)
    else if button.id = "disable"

        REG_Weather_Delete(invalid)

        m.weatherSettings = invalid

        m.buttons.visible = false
        baseFocusNode(m.keyboard.id)
    end if
End Sub

'-------------------------------------------------------------------------------
' onKeyboard
'-------------------------------------------------------------------------------
Sub onKeyboard(evt as Object)

    keypressed = evt.getData()
    if keypressed = "enter"

        errorMessage = ""
        if m.keyboard.inputText = ""

            errorMessage = Locale_String("EmptyZip")

        else if errorMessage = "" AND Len(m.keyboard.inputText) <= 3

            errorMessage = Locale_String("InvalidZip")
        end if

        if errorMessage = ""

            Utils_Spinner_Show()

            m.results.visible = false

            API_Weather_Search(callbackSearchZip, TYPE_toString(m.keyboard.inputText))
        else

            m.notification.type = "error"
            m.notification.timeout = 5
            m.notification.message = errorMessage
        end if
    else if keypressed = "empty"

        m.results.visible = false
    end if
End Sub

'-------------------------------------------------------------------------------
' onResultSelected
'-------------------------------------------------------------------------------
Sub onResultSelected(evt as Object)

    item = m.results.content.getChild(evt.getData())

    m.weatherSettings = {
        "code":item.id,
        "locationText":item.title,
        "latLong":TYPE_toString(item.location.lat) + "," + TYPE_toString(item.location.lon),
        "template":"compact",
        "zipCode":TYPE_toString(m.keyboard.inputText)
    }
    REG_Weather_Save(invalid, m.weatherSettings)

    m.keyboard.callFunc("clearInput")   
    m.results.visible = false
    m.results.visible = invalid

    createButtons()
    baseFocusNode(m.buttons.id)
End Sub

'-------------------------------------------------------------------------------
' callbackRegGetWeather
'-------------------------------------------------------------------------------
Sub callbackRegGetWeather(response as Object)

    m.weatherSettings = response.value
    if Utils_Weather_IsConfigured(m.weatherSettings)

        createButtons()
    end if

    baseFocusNode(m.keyboard.id)
End Sub

'-------------------------------------------------------------------------------
' callbackSearchZip
'-------------------------------------------------------------------------------
Sub callbackSearchZip(response as Object)

    if API_Utils_Response_isSuccess(response)

        if response.data.results.Count() > 0

            content = CreateObject("roSGNode", "ContentNode")

            for i=0 to response.data.results.Count() - 1

                location = response.data.results[i]

                item = content.createChild("ContentNode")
                item.id = location.id
                item.title = location.name + " " + location.region
                item.AddFields({location:location})
            end for

            m.results.SetFields({
                content:content
                visible:true
            })
            baseFocusNode(m.results.id)
        else

            m.notification.type = "error"
            m.notification.timeout = 5
            m.notification.message = Locale_String("NoResults")
        end if
    end if

    Utils_Spinner_Hide()
End Sub

'-------------------------------------------------------------------------------
' createButtons
'-------------------------------------------------------------------------------
Sub createButtons()

    template = Utils_Weather_GetTemplateByKey("compact")
    if Utils_Weather_IsConfigured(m.weatherSettings) AND TYPE_isValid(m.weatherSettings.template)

        template = Utils_Weather_GetTemplateByKey(m.weatherSettings.template)
    end if

    if TYPE_isValid(template)

        buttons = [{id:"template", title:Locale_String("WeatherTemplate", [template.name])}]

        if TYPE_isValid(m.weatherSettings) AND TYPE_isValid(m.weatherSettings.zipCode)

            buttons.push({id:"disable", title:Locale_String("WeatherDisable", [m.weatherSettings.zipCode])})
        end if

        m.buttons.callFunc("create", buttons)
        m.buttons.visible = true
    end if
End Sub