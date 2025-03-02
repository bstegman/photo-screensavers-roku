' Stegman Company LLC.  V4.12

'-------------------------------------------------------------------------------
' DateTime_InitLocal
'-------------------------------------------------------------------------------
Function DateTime_InitLocal(from=invalid as Dynamic, toLocal=true as Boolean) as Object

    dt = CreateObject("roDateTime")

    if TYPE_isInteger(from)

        dt.FromSeconds(from)
    else if TYPE_isString(from)

        dt.FromISO8601String(from)
    end if

    if toLocal

        dt.ToLocalTime()
    end if

    return dt
End Function

'-------------------------------------------------------------------------------
' DateTime_IsBefore
'-------------------------------------------------------------------------------
Function DateTime_IsBefore(dt1 as Object, dt2 as Object) as Boolean

    return dt1.AsSeconds() < dt2.AsSeconds()
End Function

'-------------------------------------------------------------------------------
' DateTime_GetMonthForIdx
'-------------------------------------------------------------------------------
Function DateTime_GetMonthForIdx(idx as Integer) as String

    monthStr = ""
    
    months = DateTime_GetMonths()
    if idx < months.Count()

        monthStr = months[idx]
    end if

    return monthStr
End Function

'-------------------------------------------------------------------------------
' DateTime_GetMonths
'-------------------------------------------------------------------------------
Function DateTime_GetMonths() as Object

    deviceInfo = CreateObject("roDeviceInfo")
    lang = LCase(Left(deviceInfo.getCurrentLocale(), 2))
    
    months = {
        "de":["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"],
        "en":["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
        "es":["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
        "fr":["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"],
        "it":["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"]
        "pt":["janeiro", "fevereiro", "março", "abril", "maio", "junho", "julho", "agosto", "setembro", "outubro", "novembro", "dezembro"]
    }
    
    if months[lang] <> invalid

        return months[lang]
    else

        return months["en"]
    end if
End Function

'-------------------------------------------------------------------------------
' DateTime_GetMonthsAbrv
'-------------------------------------------------------------------------------
Function DateTime_GetMonthsAbrv() as Object

    return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]
End Function

'-------------------------------------------------------------------------------
' DateTime_GetDaysOfWeek
'-------------------------------------------------------------------------------
Function DateTime_GetDaysOfWeek() as Object

    return ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
End Function

'-------------------------------------------------------------------------------
' DateTime_GetHours
'-------------------------------------------------------------------------------
Function DateTime_GetHours() as Object

    return [
        "12:00 am", "12:30 am", "1:00 am", "1:30 am", "2:00 am", "2:30 am", "3:00 am", "3:30 am", "4:00 am", "4:30 am", "5:00 am", "5:30 am", "6:00 am", "6:30 am", "7:00 am", "7:30 am", "8:00 am", "8:30 am", "9:00 am", "9:30 am", "10:00 am", "10:30 am", "11:00 am", "11:30 am",
        "12:00 pm", "12:30 pm", "1:00 pm", "1:30 pm", "2:00 pm", "2:30 pm", "3:00 pm", "3:30 pm", "4:00 pm", "4:30 pm", "5:00 pm", "5:30 pm", "6:00 pm", "6:30 pm", "7:00 pm", "7:30 pm", "8:00 pm", "8:30 pm", "9:00 pm", "9:30 pm", "10:00 pm", "10:30 pm", "11:00 pm", "11:30 pm"
    ]
End Function

'-------------------------------------------------------------------------------
' DateTime_GetCurrent
'
' @params format String - current formats supported:
'   MM/DD/YYYY HH:MM    - 08/02/2020 5:32 pm
'   MM/DD/YYYY          - 08/02/2020
'   YYYY-MM-DD          - 2020-08-02
'   dddd                - Monday
'   HH:MM               - 5:32 pm
'   HH:MM dddd          - 5:32 pm Monday
'   dddd HH:MM          - Monday 5:32 pm
'   MMMM D YYYY         - January 23, 2021
'   dddd MMMM D YYYY    - Monday January 23, 2021
' @prams date Object
'-------------------------------------------------------------------------------
Function DateTime_GetCurrent(format as String, date=invalid as Dynamic) as String

    ' FOR DEV
    ' date = "2023-11-11T12:00:08Z"

    fString = ""

    if TYPE_isString(date)

        dt = CreateObject("roDateTime")
        dt.FromISO8601String(date)
        date = dt
    else if TYPE_isInteger(date)

        dt = CreateObject("roDateTime")
        dt.FromSeconds(date)
        date = dt
    else if NOT TYPE_isValid(date)
        
        date = DateTime_InitLocal()
    end if
    
    ' month
    mt = date.getMonth().toStr()
    if mt.Len() = 1

        mt = "0" + mt
    end if

    ' day
    d = date.GetDayOfMonth().toStr()
    if d.Len() = 1

        d = "0" + d
    end if

    ' hours
    amPM = ""
    h = date.GetHours()
    if h >= 12

        h = (h - 12)
        if h = 0

            h = "12"
        else

            h = h.toStr()
        end if
        amPM = "pm"
    else

        if h = 0

            h = "12"
        else

            h = h.toStr()
        end if
        amPM = "am"
    end if

    ' minutes
    m = date.GetMinutes().toStr()
    if m.Len() = 1

        m = "0" + m
    end if

    if format = "MM/DD/YYYY HH:MM"

        fString = mt + "/" + d + "/" + date.GetYear().toStr() + " " + h + ":" + m + " " + amPM
    else if format = "MM/DD/YYYY"


        fString = mt + "/" + d + "/" + date.GetYear().toStr()
    else if format = "YYYY-MM-DD"

        fString = date.GetYear().tostr() + "-" + mt + "-" + d
    else if format = "dddd"

        daysOfWeek = DateTime_GetDaysOfWeek()
        fString = daysOfWeek[date.GetDayOfWeek()]
    else if format = "HH:MM"

        fString = h + ":" + m + " " + amPM
    else if format = "HH:MM dddd"

        daysOfWeek = DateTime_GetDaysOfWeek()
        fString = h + ":" + m + " " + amPM + " " + daysOfWeek[date.GetDayOfWeek()]
    else if format = "dddd HH:MM"

        daysOfWeek = DateTime_GetDaysOfWeek()
        fString = daysOfWeek[date.GetDayOfWeek()] + " " + h + ":" + m + " " + amPM
    else if format = "MMMM D YYYY"

        months = DateTime_GetMonths()
        fString = months[date.getMonth() - 1] + " " + d + ", " + date.GetYear().toStr()
    else if format = "dddd MMMM D YYYY"

        months = DateTime_GetMonths()
        daysOfWeek = DateTime_GetDaysOfWeek()
        fString = daysOfWeek[date.GetDayOfWeek()] + " " + months[date.getMonth() - 1] + " " + d + ", " + date.GetYear().toStr()
    else if format = "D"

        daysOfWeek = DateTime_GetDaysOfWeek()
        fString = daysOfWeek[date.GetDayOfWeek()]
    end if

    return fString
End Function

'-------------------------------------------------------------------------------
' DateTime_SecondsTo
'
' @params seconds Integer - seconds to evaluate
' @params toType String - current values supported:
'   days - number of days in seconds
'   hours- number of hours in seconds
'   minutes- number of minutes in seconds
'-------------------------------------------------------------------------------
Function DateTime_SecondsTo(seconds as Integer, toType as String) as Integer

    value = -1
    if toType = "days"

        value = seconds / (24 * 3600)
    else if toType = "hours"

        value = seconds / 3600
    else if toType = "minutes"

        value = seconds / 60
    end if
    return value
End Function

'-------------------------------------------------------------------------------
' DateTime_GetTimestamp
'-------------------------------------------------------------------------------
Function DateTime_GetTimestamp(toLocalTime=false as Boolean) as LongInteger

    dateTime = CreateObject("roDateTime")

    ' if you run toLocalTime the timestamp comes back as UTC not the local time
    ' therefore we do the opposite code wise of what the user asks
    if NOT toLocalTime

        dateTime.ToLocalTime()
    end if

    ' we need to have 64-bit data type to store such large number
    seconds = CreateObject("roLongInteger")
    seconds.SetLongInt(dateTime.AsSeconds())
    return seconds
End Function

'-------------------------------------------------------------------------------
' DateTime_GetTimestampFromDate
'-------------------------------------------------------------------------------
Function DateTime_GetTimestampFromDate(dateTime as Object) as LongInteger

    ' we need to have 64-bit data type to store such large number
    seconds = CreateObject("roLongInteger")
    seconds.SetLongInt(dateTime.AsSeconds())
    return seconds
End Function

'-------------------------------------------------------------------------------
' DateTime_GetTimestampAsMilliseconds
'-------------------------------------------------------------------------------
Function DateTime_GetTimestampAsMilliseconds(toLocalTime=false as Boolean) as LongInteger

    dateTime = CreateObject("roDateTime")

    if toLocalTime

        dateTime.ToLocalTime()
    end if

    ' we need to have 64-bit data type to store such large number
    seconds = CreateObject("roLongInteger")
    milliseconds = CreateObject("roLongInteger")
    epoch = CreateObject("roLongInteger")

    seconds.SetLongInt(dateTime.AsSeconds())
    milliseconds.SetLongInt(dateTime.GetMilliseconds())

    epoch.SetLongInt(seconds * 1000 + milliseconds)

    return epoch.GetLongInt()
End Function