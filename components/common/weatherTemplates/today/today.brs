'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    ' current
    m.tempIcon = m.top.findNode("tempIcon")
    m.temp = m.top.findNode("temp")
    m.tempToday = m.top.findNode("tempToday")
    m.tempHour = m.top.findNode("tempHour")
End Sub

'-------------------------------------------------------------------------------
' set
'-------------------------------------------------------------------------------
Sub set(weather as Object)

    updateCurrent(weather)
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

    ' hourText = ""
    ' ct = 0
    ' timestamp = DateTime_GetTimestamp(true) + 1800
    ' for i=0 to weather.forecast.forecastday[0].hour.Count() - 1

    '     hour = weather.forecast.forecastday[0].hour[i]
    '     if timestamp < hour.time_epoch

    '         date = DateTime_InitLocal(hour.time_epoch, true)
    '         hourText += TYPE_toString(Int(hour.temp_f)) + "° " + DateTime_GetCurrent("HH:MM", date) + "   "
    '         if ct + 1 < 3

    '             ct++

    '             hourText += "|  "
    '         else

    '             exit for
    '         end if
    '     end if
    ' end for

    ' m.tempHour.text = hourText
End Sub
