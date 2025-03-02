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

        group = CreateObject("roSGNode", "Group")

        ' Day of week
        date = CreateObject("roDateTime")
        date.FromSeconds(fDay.date_epoch)

        dayOfWeek = CreateObject("roSGNode", "Label")
        dayOfWeek.SetFields({
            font:"font:SmallSystemFont",
            text:DateTime_GetCurrent("D", date)
        })
        group.appendChild(dayOfWeek)

        ' Day
        day = CreateObject("roSGNode", "Label")
        day.SetFields({
            font:"font:SmallSystemFont",
            translation:[0, 40],
            text:"Day: " + TYPE_toString(Int(fDay.day.maxtemp_f)) + "°"
        })
        group.appendChild(day)

        dayPoster = CreateObject("roSGNode", "Poster")
        dayPoster.SetFields({
            width:65,
            height:65,
            translation:[165, 20],
            uri:"https:" + fDay.day.condition.icon
        })
        group.appendChild(dayPoster)

        dayDesc = CreateObject("roSGNode", "Label")
        dayDesc.SetFields({
            font:"font:SmallSystemFont",
            translation:[0, 80],
            width:400,
            text:fDay.day.condition.text
        })
        group.appendChild(dayDesc)

        ' Night
        fNight = fDay.hour[fDay.hour.Count() - 1]
        if TYPE_isValid(fNight)

            night = CreateObject("roSGNode", "Label")
            night.SetFields({
                font:"font:SmallSystemFont",
                translation:[0, 140],
                text:"Night: " + TYPE_toString(Int(fNight.temp_f)) + "°"
            })
            group.appendChild(night)

            nightPoster = CreateObject("roSGNode", "Poster")
            nightPoster.SetFields({
                width:50,
                height:50,
                translation:[165, 130],
                uri:"https:" + fNight.condition.icon
            })
            group.appendChild(nightPoster)

            nightDesc = CreateObject("roSGNode", "Label")
            nightDesc.SetFields({
                font:"font:SmallSystemFont",
                translation:[0, 180],
                width:400,
                text:fNight.condition.text
            })
            group.appendChild(nightDesc)
        end if

        m.containerForecast.appendChild(group)
        UI_Screen_PlaceNodeBottomLeft(m.containerForecast)
    end for
End Sub
