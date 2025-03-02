' Stegman Company LLC.  V1.1

'-------------------------------------------------------------------------------
' Locale_String
'
' @description - looks the provided string up in strings.json and returns
' the localized version back.  If the params strings array is not empty then
' we will attempt to substitute the values in the original string.
'
' For example: The big {0} dog has {1} legs. ["brown", "4"] 
' Would result in the following sentence: 
'   The big brown dog has 4 legs.
'
' @param key String - the key to lookup in strings.json
' @param strings Array - the strings to substitute
'-------------------------------------------------------------------------------
Function Locale_String(key as String, strings=[] as Object) as String
    
    ' cache it locally if it already hasn't been
    if m._localeStrings = invalid

        if m.global.strings = invalid

            m._localeStrings = {}
        else
            
            m._localeStrings = m.global.strings
        end if
    end if

    strKey = m._localeStrings[key]
    if strKey <> invalid

        str = tr(strKey)
        str = str.Replace("&amp;", "&")

        if strings <> invalid AND strings.Count() > 0

            for i=0 to strings.Count() - 1

                str = str.Replace("{" + i.toStr() + "}", tr(strings[i]))
            end for
        end if
        
        return str
    else

        return key
    end if
End Function