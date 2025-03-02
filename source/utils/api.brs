'-------------------------------------------------------------------------------
' Utils_API_PrepHttp
' @return Object - http object
'-------------------------------------------------------------------------------
Function Utils_API_PrepHttp(params=invalid as Object) as Object

	environment = m.global.environment

    headers = {
        rokuDeviceLang:m.global.deviceLang
    }
    if TYPE_isValidPath("userManager.token", m) AND NOT TYPE_isStringEmpty(m.userManager.token)

        headers["Authorization"] = m.userManager.token
    else if TYPE_isValidPath("top.token", m) AND NOT TYPE_isStringEmpty(m.top.token)

        headers["Authorization"] = m.top.token
    else

        headers["Authorization"] = "Bearer " + environment.api.token
    end if

	http = {
		headers:headers,
		validate:environment.api.validate,
		log:environment.api.log,
        host:environment.api.url,
		converResponseToNode:""
	}

    if TYPE_isValid(params)

        paramsStr = ""
        for each key in params.Keys()

            if paramsStr <> ""
                
                paramsStr += "&"
            end if

            paramsStr += key + "=" + TYPE_toString(params[key]).Escape()
        end for

        if paramsStr <> ""

            http.params = paramsStr
        end if
    end if

	return http
End Function
