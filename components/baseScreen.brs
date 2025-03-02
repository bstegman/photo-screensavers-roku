'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.scene = m.top.GetScene()
	m.apiRequestManager = m.scene.findNode("ApiRequestManager")
	m.registryManager = m.scene.findNode("RegistryManager")
    m.router = m.scene.findNode("Router")
    m.spinner = m.scene.findNode("Spinner")
    m.userManager = m.scene.findNode("UserManager")

    m.usageTimer = invalid

    m.__lastFocusedNodeId = ""
End Sub

'-------------------------------------------------------------------------------
' onScreenWillShow
'-------------------------------------------------------------------------------
Sub onScreenWillShow(params as object)

    screen = m.global.screens[m.top.id]
    if TYPE_isValid(screen) AND TYPE_isValid(screen.backgroundColor)

        m.scene.backgroundColor = screen.backgroundColor
    else

        m.scene.backgroundColor = "#000000"
    end if

	_onScreenWillShow()
End Sub

'-------------------------------------------------------------------------------
' onScreenWillHide
'-------------------------------------------------------------------------------
Sub onScreenWillHide(params as object)

    if TYPE_isValid(m.usageTimer)
        
        m.usageTimer.control = "stop"
    end if

	_onScreenWillHide()
End Sub

'-------------------------------------------------------------------------------
' onUsageTimer
'-------------------------------------------------------------------------------
Sub onUsageTimer()

	NewRelic_LogEvent("PowerTV", "Components", {component:m.top.id})
End Sub

'-------------------------------------------------------------------------------
' isActive - Called when the screen becomes active
'-------------------------------------------------------------------------------
Sub isActive(refresh=false as object)

	_isActive(refresh)
End Sub

'-------------------------------------------------------------------------------
' baseShowScreen
'-------------------------------------------------------------------------------
Sub baseShowScreen(screen as object, params=invalid as object)

	if params = invalid

		params = {}
	end if
	params.screen = screen
	m.router.callFunc("showScreen", params)
End Sub

'-------------------------------------------------------------------------------
' baseHistoryBack
'-------------------------------------------------------------------------------
Sub baseHistoryBack(backTo=invalid)

    history = m.router.callFunc("getHistory")
    if history.screens.Count() > 0

        if m.top.id <> history.screens[0]

            m.router.callFunc("historyBack", {backTo:backTo})
        end if
    end if
End Sub

'-------------------------------------------------------------------------------
' baseFocusNode
' @param nodeId String - The id of the node you want to set focus on
'-------------------------------------------------------------------------------
Sub baseFocusNode(nodeId as String)

    node = m.top.findNode(nodeId)
    if TYPE_isValid(node)

        node.setFocus(true)
        m.__lastFocusedNodeId = nodeId
    end if
End Sub

'-------------------------------------------------------------------------------
' baseFocusLastNode
' @param nodeId String - The nodeId to focus on if there is no last focused node
'-------------------------------------------------------------------------------
Sub baseFocusLastNode(nodeId as String)

    node = baseGetLastFocusedNode()
    if TYPE_isValid(node)

        node.setFocus(true)
    else

        baseFocusNode(nodeId)
    end if
End Sub

'-------------------------------------------------------------------------------
' baseGetLastFocusedNode
' @return The node object if found otherwise invalid if not found
'-------------------------------------------------------------------------------
Function baseGetLastFocusedNode() as Object

    return m.top.findNode(m.__lastFocusedNodeId)
End Function

'-------------------------------------------------------------------------------
' baseStartUsageAnalytics
'-------------------------------------------------------------------------------
Function baseStartUsageAnalytics() as Object

    if NOT TYPE_isValid(m.usageTimer)

        m.usageTimer = CreateObject("roSGNode", "Timer")
        m.usageTimer.ObserveFieldScoped("fire", "onUsageTimer")
        m.usageTimer.SetFields({
            duration:120,
            repeat:false
        })
    end if
    m.usageTimer.control = "start"
    m.top.appendChild(m.usageTimer)
End Function