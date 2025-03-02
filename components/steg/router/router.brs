' Stegman Company LLC.  V4.1

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.routerOut = m.top.findNode("routerOut")
	m.curScreenId = ""
	m.history = []
	m.historyData = []
	m.screens = []
End Sub

'-------------------------------------------------------------------------------
' setScreens
'-------------------------------------------------------------------------------
Sub setScreens(params as Object)

    if m.top.loggingEnabled

        print "ROUTER: set ";params.screens.Count();" screens"
    end if
	m.screens = params.screens
End Sub

'-------------------------------------------------------------------------------
' historyBack
'
' @params Object {
'	backTo Integer - Number of items to jump back to.  If set to zero then go
'					 to the last item in the stack and do not remove from history
' }
'-------------------------------------------------------------------------------
Sub historyBack(params as Object)

	if m.history.Count() > 0

		backTo = 1
		if TYPE_isInteger(params.backTo)
			
			backTo = params.backTo
		end if

		' if backTo is set to zero then go to the last item 
		' and do not remove it from the history stack
		if backTo <> 0
		
			for i = 1 to backTo

				m.history.Pop()
				m.historyData.Pop()
			end for
		else

			' set to 1 so we get the correct history item
			backTo = 1
		end if

		historyIdx = m.history.Count() - backTo
		screenId = m.history[historyIdx]
		if TYPE_isString(screenId) AND TYPE_isValid(m.screens[screenId])

			showScreen({screen:m.screens[screenId], trackHistory:false, input:m.historyData[historyIdx]})
		end if
	end if
End Sub

'-------------------------------------------------------------------------------
' showScreen
'-------------------------------------------------------------------------------
Sub showScreen(params as Object)

	screen = params.screen
	newScreenObj = m.screens[screen.id]
	curScreenId = m.curScreenId

	' don't try to load the same screen
	if NOT TYPE_isValid(curScreenId) OR curScreenId <> screen.id
	
		' fire screenChange event
		curScreenObj = invalid
		if TYPE_isValid(curScreenId)

			curScreenObj = m.screens[curScreenId]
		end if
		
		m.top.SetField("screenChange", {
			from:curScreenObj,
			to:newScreenObj, 
			toInput:params.input
		})

		' history
		' 1) passing a parameter should override any screen settings
		' 2) we default to screen settings if no parameters
		' 3) if no screen settings then we should track history
		
		' for some reason this execution is not stopping after the 1st or statement so for now only supporting params track history
		if params.trackHistory = invalid OR (params.trackHistory <> invalid AND params.trackHistory)

			m.history.Push(screen.id)
			if TYPE_isValid(params) AND TYPE_isValid(params.input)
				m.historyData.push(params.input)
			else
				m.historyData.push(invalid)
			end if
			
			if m.history.Count() > m.top.trackHistoryCount

				m.history.Shift()
				m.historyData.Shift()
			end if
		end if

		' get the screen or create if it does not exist
		newScreenNode = m.routerOut.findNode(screen.id)
		if newScreenNode = invalid

			newScreenNode = CreateObject("roSGNode", screen.id)
			newScreenNode.id = screen.id
			m.routerOut.appendChild(newScreenNode)
		end if

		' pass on data to screen
		if TYPE_isValid(params)

			' pass along any input data to the screen
			if TYPE_isValid(params.input)
				
				if newScreenNode.hasField("input")

					newScreenNode.setField("input", params.input)
				else

					newScreenNode.AddFields({input:params.input})
				end if
			end if
		end if

		' pass along screen state
		if TYPE_isValid(newScreenObj) AND TYPE_isValid(newScreenObj.state)

			newScreenNode.AddFields({state:newScreenObj.state})
			m.screens[screen.id].Delete("state")
		end if

		newScreenNode.setFocus(true)
		newScreenNode.callFunc("onScreenWillShow", {})
		newScreenNode.visible = true

		newScreenNode.callFunc("isActive", TYPE_isBooleanEqualTo(params.refresh, true))
		m.curScreenId = screen.id

		' cleanup existing screen
		if curScreenId <> invalid and curScreenId <> ""

			curScreenNode = m.routerOut.findNode(curScreenId)
			if curScreenNode <> invalid

				curScreenNode.callFunc("onScreenWillHide", {})
					
				curScreen = m.screens[curScreenId]
				if curScreen <> invalid

					if curScreen.persists or (params.persists <> invalid and params.persists)

						curScreenNode.visible = false
					else if params.keepAlive = invalid OR NOT params.keepAlive

						m.routerOut.removeChild(curScreenNode)
					end if
				end if
			end if
		end if

        if m.top.loggingEnabled

            print "ROUTER: to screen ";screen.id
            print "ROUTER: params ";params
            printHistory()
        end if
	end if
End Sub

'-------------------------------------------------------------------------------
' getScreen
'
' @description - gets the screen object from the screens.json config file
'-------------------------------------------------------------------------------
Function getScreen(screenId as String) as Object

	return m.screens[screenId]
End Function

'-------------------------------------------------------------------------------
' getActiveScreen
'
' @description - gets the screen node that is currently active/showing
'-------------------------------------------------------------------------------
Function getActiveScreen() as Object

	screen = invalid

	for i=0 to m.routerOut.getChildCount() - 1

		curScreen = m.routerOut.getChild(i)
		if curScreen.visible
			
			screen = curScreen
			exit for
		end if
	end for

	return screen
End Function

'-------------------------------------------------------------------------------
' getHistory
'-------------------------------------------------------------------------------
Function getHistory() as Object
	return {screens:m.history, data:m.historyData}
End Function

'-------------------------------------------------------------------------------
' printHistory
'-------------------------------------------------------------------------------
Sub printHistory()
	
    print "ROUTER: --- HISTORY ---"
    print "ROUTER: num items: ";m.history.Count()
    print "ROUTER: num data items: ";m.historyData.Count()
    print "ROUTER: ";m.history
End Sub

'-------------------------------------------------------------------------------
' popHistory
'
' @description - removes n number of items from the end of the history stack
'-------------------------------------------------------------------------------
Sub popHistory(numItems=1 as Integer)
	
    for i=1 to numItems

        m.history.pop()
        m.historyData.pop()
    end for
End Sub

'-------------------------------------------------------------------------------
' clearHistory
'
' @description - remove all history items
'-------------------------------------------------------------------------------
Sub clearHistory()

    m.history = []
    m.historyData = []
End Sub

'-------------------------------------------------------------------------------
' removeScreen
'
' @description - removes the screen node
'-------------------------------------------------------------------------------
Sub removeScreen(screenId as String)

    for i=0 to m.routerOut.getChildCount() - 1

        screen = m.routerOut.getChild(i)
        if screen <> invalid AND screen.id = screenId

            m.routerOut.removeChild(screen)
            exit for
        end if
    end for
End Sub

'-------------------------------------------------------------------------------
' removeAllScreens
'
' @description - removes all the screens nodes
'-------------------------------------------------------------------------------
Sub removeAllScreens()

	toRemove = [] ' list of screen ids
	for i=0 to m.routerOut.getChildCount() - 1

		screen = m.routerOut.getChild(i)
		if screen <> invalid AND screen.id <> m.curScreenId

			toRemove.Push(screen.id)
		end if
    end for

	for each screenId in toRemove

		screen = m.top.findNode(screenId)
		m.routerOut.removeChild(screen)
	end for
End Sub

'-------------------------------------------------------------------------------
' setScreenState
'-------------------------------------------------------------------------------
Sub setScreenState(screenId as String, state as Object)

	screen = m.screens[screenId]
	if TYPE_isValid(screen)

		screen.state = state
		m.screens[screenId] = screen
	end if
End Sub
