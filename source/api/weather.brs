'-------------------------------------------------------------------------------
' API_Weather_Get
'-------------------------------------------------------------------------------
Sub API_Weather_Get(callback as Object, location as String)

    request = Utils_API_PrepHttp()
    request.requestId = "weather-forecast-get"
    request.url = "/v2/ua/powertv/weather/forecast"
    request.params = "location=" + location
    request.type = "POST"

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_Weather_Search
'-------------------------------------------------------------------------------
Sub API_Weather_Search(callback as Object, location as String)

    request = Utils_API_PrepHttp()
    request.requestId = "weather-forecast-search"
    request.url = "/v2/ua/powertv/weather/search"
    request.params = "location=" + location
    request.type = "POST"

    API_Utils_SendRequest(callback, request)
End Sub
