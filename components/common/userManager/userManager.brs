'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.validCodes = ["photos-screensaver", "lazelife-weather-forecast1"]

    scene = m.top.getScene()
	m.router = scene.findNode("Router")
	m.registryManager = scene.findNode("RegistryManager")
    m.apiRequestManager = scene.findNode("ApiRequestManager")

    m.defaultToken = m.global.environment.api.token
    m.top.token = "Bearer " + m.defaultToken

    m.channelStore = invalid 
    if scene.subtype() = "AppScene"

        m.channelStore = CreateObject("roSGNode", "ChannelStore")
        m.channelStore.ObserveFieldScoped("purchases", "onGetPurchases")
        m.channelStore.ObserveFieldScoped("orderStatus", "onOrderStatus")
        m.channelStore.ObserveFieldScoped("userData", "onUserData")
        m.channelStore.ObserveFieldScoped("userRegionData", "onUserRegionData")

        m.channelStore.command = "getUserRegionData"
    end if
End Sub

'-------------------------------------------------------------------------------
' onGetPurchases
'-------------------------------------------------------------------------------
Sub onGetPurchases(evt as Object)

    result = evt.getData()
    if result.status = 1

        purchase = invalid
        for i=0 to result.Count() - 1

            item = result.getChild(i)
            if TYPE_isValid(item)

                if LCase(item.status) = "valid" AND TYPE_isInArray(m.validCodes, item.code, false)

                    purchase = item
                    exit for
                end if
            end if
        end for

        m.top.purchase = purchase
    end if
End Sub

'-------------------------------------------------------------------------------
' onUserData
'-------------------------------------------------------------------------------
Sub onUserData(evt as Object)

    m.top.userRoku = evt.getData()
End Sub

'-------------------------------------------------------------------------------
' onUserRegionData
'-------------------------------------------------------------------------------
Sub onUserRegionData(evt as Object)

    m.channelStore.UnObserveFieldScoped("userRegionData")

    region = evt.getData()
    if TYPE_isValid(region)

        m.global.AddFields({region:region})
    end if
End Sub

'-------------------------------------------------------------------------------
' onOrderStatus
'-------------------------------------------------------------------------------
Sub onOrderStatus(evt as Object)

    ' order statuses: https://sdkdocs.roku.com/display/sdkdoc/ChannelStore#ChannelStore-doOrder

	result = evt.getData()
	if result.status = 1

		order = result.getChild(0)
		if TYPE_isValid(order) AND TYPE_isString(order.purchaseId) AND order.purchaseId <> ""

            NewRelic_LogEvent("SSPhotos", "Checkout", {status:"completed"})
            m.top.purchase = order
		else

            NewRelic_LogEvent("SSPhotos", "Checkout", {status:"invalid-order"})
            m.top.purchase = invalid
		end if
	else

        NewRelic_LogEvent("SSPhotos", "Checkout", {status:result.status})
        m.top.purchase = invalid
	end if
End Sub

'-------------------------------------------------------------------------------
' callbackGetUser
'-------------------------------------------------------------------------------
Sub callbackGetUser(response as Object)

    if API_Utils_Response_isSuccess(response)

        m.top.user = response.data.results[0]
    end if

    m.channelStore.command = "getAllPurchases"
End Sub

'-------------------------------------------------------------------------------
' callbackRegUserGetToken
'-------------------------------------------------------------------------------
Sub callbackRegUserGetToken(response as Object)

	if TYPE_isValid(response.value) AND NOT TYPE_isStringEmpty(response.value)

        API_User_Me(callbackGetUser)
    else

        m.channelStore.command = "getAllPurchases"
	end if
End Sub

'-------------------------------------------------------------------------------
' load
'-------------------------------------------------------------------------------
Sub load()

    REG_User_GetToken(callbackRegUserGetToken)
End Sub

'-------------------------------------------------------------------------------
' logout
'-------------------------------------------------------------------------------
Sub logout()

	m.router.callFunc("clearHistory")
	m.router.callFunc("removeAllScreens")

	m.top.token = "Bearer " + m.defaultToken

    REG_User_Remove(invalid)
	' REG_ScreenSaver_SaveCurrent(invalid, "aquarium")
End Sub

'-------------------------------------------------------------------------------
' getChannelStore
'-------------------------------------------------------------------------------
Function getChannelStore() as Object

    return m.channelStore
End Function

'-------------------------------------------------------------------------------
' loadRokuUser
'-------------------------------------------------------------------------------
Sub loadRokuUser()

    m.channelStore.command = "GetUserData"
End Sub

'-------------------------------------------------------------------------------
' makePurchase
'-------------------------------------------------------------------------------
Sub makePurchase()

    myOrder = CreateObject("roSGNode", "ContentNode")
    item = myOrder.CreateChild("ContentNode")
    item.AddFields({ "code": m.validCodes[0], "qty": 1 })

    m.channelStore.order = myOrder
    m.channelStore.command = "doOrder"
End Sub