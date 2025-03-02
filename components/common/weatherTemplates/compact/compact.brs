'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    ' current
    m.tempIcon = m.top.findNode("tempIcon")
    m.temp = m.top.findNode("temp")
    m.tempToday = m.top.findNode("tempToday")

    ' forecast
    m.containerForecast = m.top.findNode("containerForecast")
End Sub

'-------------------------------------------------------------------------------
' set
'-------------------------------------------------------------------------------
Sub set(weather as Object)

    updateCurrent(weather)
    updateForecast(weather)
End Sub

'-------------------------------------------------------------------------------
' updateCurrent
'-------------------------------------------------------------------------------
Sub updateCurrent(weather as Object)

    m.tempIcon.uri = "https:" + weather.current.condition.icon
    m.temp.text = TYPE_toString(Int(weather.current.temp_f)) + "° " + weather.current.condition.text

    today = weather.forecast.forecastday[0]
    if TYPE_isValid(today)

        m.tempToday.text = Locale_String("Today") + ": " + TYPE_toString(Int(today.day.maxtemp_f)) + "° / " + TYPE_toString(Int(today.day.mintemp_f)) + "°"
    end if
End Sub

'-------------------------------------------------------------------------------
' updateForecast
'-------------------------------------------------------------------------------
Sub updateForecast(weather as Object)

    m.containerForecast.removeChildrenIndex(m.containerForecast.getChildCount(), 0)

    for i=1 to weather.forecast.forecastday.Count() - 1

        fDay = weather.forecast.forecastday[i]

        date = CreateObject("roDateTime")
        date.FromSeconds(fDay.date_epoch)

        group = CreateObject("roSGNode", "Group")

        dayOfWeek = CreateObject("roSGNode", "Label")
        dayOfWeek.SetFields({
            font:"font:MediumSystemFont",
            text:DateTime_GetCurrent("D", date)
        })
        group.appendChild(dayOfWeek)

        poster = CreateObject("roSGNode", "Poster")
        poster.SetFields({
            width:75,
            height:75,
            translation:[-20, 30],
            uri:"https:" + fDay.day.condition.icon
        })
        group.appendChild(poster)

        temp = CreateObject("roSGNode", "Label")
        temp.SetFields({
            font:"font:SmallSystemFont",
            translation:[60, 50],
            width:200,
            text:(TYPE_toString(Int(fDay.day.maxtemp_f)) + "° / " + TYPE_toString(Int(fDay.day.mintemp_f)) + "°")
        })
        group.appendChild(temp)

        m.containerForecast.appendChild(group)
        UI_Screen_PlaceNodeBottomLeft(m.containerForecast)
    end for
End Sub
