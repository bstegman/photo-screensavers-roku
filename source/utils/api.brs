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

'-------------------------------------------------------------------------------
' Utils_API_GoTo
'-------------------------------------------------------------------------------
Sub Utils_API_GoTo(trackHistory=false as Boolean, collection="" as String)

    feed = Device_GetManifestValue("feed")
    if feed <> ""

        _type = Device_GetManifestValue("type")
        if _type = "bounce"

            baseShowScreen(m.global.screens.DisplaysBounceScreen, {input:{url:feed}, trackHistory:trackHistory})
        else if _type = "montage"

            baseShowScreen(m.global.screens.DisplaysMontageScreen, {input:{url:feed}, trackHistory:trackHistory})
        end if
    else

        if collection <> ""

            m._modal = CreateObject("roSGNode", "ModalMessaging")
            m._modal.SetFields({
                btnCancelText:Locale_String("No")
                btnOkText:Locale_String("Yes"),
                data:{
                    collectionId:collection,
                    trackHistory:trackHistory
                }
            })
            m._modal.ObserveFieldScoped("btnSelected", "_Utils_API_OnModal")

            r = CreateObject("roRegex", "{nl}", "i")
            title = Locale_String("MessageIncludePhotos", [Device_GetManifestValue("title")])
            title = r.ReplaceAll(title, Chr(10))
            m._modal.callFunc("show", title)
        else

            baseShowScreen(m.global.screens.DisplaysScreensaverScreen, {input:{localPhotos:true}, trackHistory:trackHistory})
        end if
    end if
End Sub

'-------------------------------------------------------------------------------
' _Utils_API_OnModal
'-------------------------------------------------------------------------------
Sub _Utils_API_OnModal(evt as Object)

    data = m._modal.data

    m.top.getScene().removeChild(m._modal)
    m._modal = invalid

    action = evt.getData()
    NewRelic_LogEvent("SSPhotos", "ModalIncludePhotos", {action:action})

    if action = "ok"

        baseShowScreen(m.global.screens.DisplaysScreensaverScreen, {input:{localPhotos:false, collectionId:data.collectionId}, persists:true})
    else

        baseShowScreen(m.global.screens.DisplaysScreensaverScreen, {input:{localPhotos:true}, trackHistory:data.trackHistory})
    end if
End Sub