' Stegman Company LLC.  V2.1

'-------------------------------------------------------------------------------
' NewRelic_LogEvent
'
' @description - this method uses the new relic api directly
'-------------------------------------------------------------------------------
Sub NewRelic_LogEvent(category as String, action as String, data=invalid as Object)

    environment = m.global.environment
    if TYPE_isValid(environment) AND TYPE_isValid(environment.newRelic) AND TYPE_isBooleanEqualTo(environment.newRelic.enabled, true)

        app = CreateObject("roAppInfo")
        
        appid = app.GetID().ToInt()
        if appid = 0 then appid = 1

        appbuild = app.GetValue("build_version").ToInt()
        if appbuild = 0 then appbuild = 1
        
        hdmi = CreateObject("roHdmiStatus")
        dev = CreateObject("roDeviceInfo")
        
        osVersion = dev.GetOsVersion()

        params = {
            "eventType":category,
            "actionName":action,
            "newRelicAgent":"RokuAgent",
            "hdmiIsConnected":hdmi.IsConnected(),
            "hdmiHdcpVersion":hdmi.GetHdcpVersion(),
            "uuid":dev.GetChannelClientId(),
            "device":dev.GetModelDisplayName(),
            "deviceGroup":"Roku",
            "deviceManufacturer":"Roku",
            "deviceModel":dev.GetModel(),
            "deviceType":dev.GetModelType(),
            "osName":"RokuOS",
            "osVersionString":osVersion.major + "." + osVersion.minor + "." + osVersion.revision,
            "osVersion":osVersion.major + "." + osVersion.minor,
            "osBuild":osVersion.build,
            "countryCode":dev.GetUserCountryCode(),
            "timeZone":dev.GetTimeZone(),
            "locale":dev.GetCurrentLocale(),
            "memoryLevel":dev.GetGeneralMemoryLevel(),
            "connectionType":dev.GetConnectionType(),
            "displayType":dev.GetDisplayType(),
            "displayMode":dev.GetDisplayMode(),
            "displayAspectRatio":dev.GetDisplayAspectRatio(),
            "videoMode":dev.GetVideoMode(),
            "graphicsPlatform":dev.GetGraphicsPlatform(),
            "timeSinceLastKeypress":(dev.TimeSinceLastKeypress() * 1000),
            "appId":appid,
            "appVersion":app.GetValue("major_version") + "." + app.GetValue("minor_version"),
            "appName":app.GetTitle(),
            "appDevId":app.GetDevID(),
            "appIsDev":app.IsDev(),
            "appBuild":appbuild,
            "uptime":Uptime(0)
        }

        if data <> invalid

            params.Append(data)
        end if

        request = {
            headers:{
                "Content-Type":"application/json",
                "X-Insert-Key":environment.newRelic.apiKey
            },
            requestId:"new-relic-log-event" + "-" + Mid(RND(0).toStr(), 3),
            type:"POST",
            host:"https://insights-collector.newrelic.com",
            url:"/v1/accounts/" + environment.newRelic.accountID + "/events",
            params:FormatJson(params)
        }

        API_Utils_SendRequest(invalid, request)
    end if
End Sub