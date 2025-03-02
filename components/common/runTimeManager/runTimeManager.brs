'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.name = ""

    m.scene = m.top.GetScene()
	m.apiRequestManager = m.scene.findNode("ApiRequestManager")
    m.registryManager = m.scene.findNode("RegistryManager")

    m.pingTimer = m.top.findNode("pingTimer")
    m.pingTimer.ObserveFieldScoped("fire", "onPing")
End Sub

'-------------------------------------------------------------------------------
' onPing
'-------------------------------------------------------------------------------
Sub onPing()

    m.top.minutes++

    REG_RunTime_Save(invalid, m.name, m.top.minutes)
    ' print ">>> ping: ";m.top.minutes;" minutes"
End Sub

'-------------------------------------------------------------------------------
' flush
'-------------------------------------------------------------------------------
Sub flush()

    m.pingTimer.control = "stop"

    if m.top.minutes > 0 AND m.name <> ""

        REG_RunTime_Remove(invalid)
        NewRelic_LogEvent("SSPhotos", "RunTime", {minutes:m.top.minutes, name:m.name})
    end if
    ' print ">>> flush: ";m.top.minutes;" minutes"
End Sub

'-------------------------------------------------------------------------------
' start
'-------------------------------------------------------------------------------
Sub start(name as String)

    m.name = name
    m.top.minutes = 0
    m.pingTimer.control = "start"
    ' print ">>> start: ";name
End Sub