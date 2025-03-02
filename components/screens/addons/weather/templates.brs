'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()
    m.weatherJSON = ParseJson(ReadAsciiFile("pkg:/assets/weatherapi-forecast.json"))
    m.weatherSettings = invalid

    m.cache = {}
    m.templates = Utils_Weather_GetTemplates()

    m.buttons = m.top.findNode("buttons")
    m.buttons.SetFields({
        style:m.global.styles.buttonBlack,
        itemSize:[500, 50]
    })
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow - Called when the screen is about to be shown.  This is
' where you typically want to attach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillShow()

    m.buttons.ObserveFieldScoped("itemFocused", "onButtonsFocus")
    m.buttons.ObserveFieldScoped("itemSelected", "onButtons")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide - Called when the screen is about to be hidden.  This is
' where you typically want to detach your observers
'-------------------------------------------------------------------------------
Sub _onScreenWillHide()

    m.buttons.UnObserveFieldScoped("itemFocused")
    m.buttons.UnObserveFieldScoped("itemSelected")
End Sub

'-------------------------------------------------------------------------------
' _isActive
'
' @description - Called when the screen becomes active
' @param refresh Boolean - Tells the screen that it should refresh all data.
' This is set by the user when switching screens.
'-------------------------------------------------------------------------------
Sub _isActive(refresh=false as Boolean)

    buttons = []
    for i=0 to m.templates.Count() - 1

        template = m.templates[i]
        buttons.push({id:i, title:Locale_String(template.name)})
    end for
    m.buttons.callFunc("create", buttons)
    UI_Screen_PlaceNodeTopRight(m.buttons)

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
	    end if
    end if
    return handled
End Function

'-------------------------------------------------------------------------------
' onButtons
'-------------------------------------------------------------------------------
Sub onButtons(evt as Object)

    button = m.buttons.content.getChild(evt.getData())
    template = m.templates[TYPE_toInteger(button.id)]
    if TYPE_isValid(template)

        m.weatherSettings.template = template.key

        REG_Weather_Save(invalid, m.weatherSettings)

        baseHistoryBack()
    end if
End Sub

'-------------------------------------------------------------------------------
' onButtonsFocus
'-------------------------------------------------------------------------------
Sub onButtonsFocus(evt as Object)

    button = m.buttons.content.getChild(evt.getData())
    loadTemplate(TYPE_toInteger(button.id))
End Sub

'-------------------------------------------------------------------------------
' callbackRegGetWeather
'-------------------------------------------------------------------------------
Sub callbackRegGetWeather(response as Object)

    m.weatherSettings = response.value

    baseFocusNode(m.buttons.id)
End Sub

'-------------------------------------------------------------------------------
' loadTemplate
'-------------------------------------------------------------------------------
Sub loadTemplate(templateIdx as Integer)

    template = m.templates[templateIdx]
    if TYPE_isValid(template)

        for each k in m.cache

            m.cache[k].visible = false
        end for

        _template = m.cache[template.key]
        if NOT TYPE_isValid(_template)

            _template = CreateObject("roSGNode", template.componentName)
            _template.callFunc("set", m.weatherJSON)
            m.top.appendChild(_template)

            m.cache[template.key] = _template
        else

            _template.visible = true
        end if
    end if
End Sub