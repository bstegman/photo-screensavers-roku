'-------------------------------------------------------------------------------
' Utils_Weather_GetTemplates
'-------------------------------------------------------------------------------
Function Utils_Weather_GetTemplates() as Object

    return [
        {
            componentName:"WeatherCompact",
            name:"Compact",
            key:"compact"
        },
        {
            componentName:"WeatherDetailed",
            name:"Detailed",
            key:"detailed"
        },
        {
            componentName:"WeatherToday",
            name:"Today",
            key:"today"
        }
    ]
End Function

'-------------------------------------------------------------------------------
' Utils_Weather_GetTemplateByKey
'-------------------------------------------------------------------------------
Function Utils_Weather_GetTemplateByKey(key as String) as Object

    template = invalid

    templates = Utils_Weather_GetTemplates()
    for i=0 to templates.Count() - 1

        _template = templates[i]
        if _template.key = key

            template = _template
            exit for
        end if
    end for

    return template
End Function

'-------------------------------------------------------------------------------
' Utils_Weather_IsConfigured
'-------------------------------------------------------------------------------
Function Utils_Weather_IsConfigured(weatherSettings as Object) as Boolean

    return TYPE_isValid(weatherSettings) AND NOT TYPE_isAssocArrayEmpty(weatherSettings)
End Function
