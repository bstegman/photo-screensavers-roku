' Stegman Company LLC.  V1.0

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.timer = m.top.findNode("timer")
    m.timer.ObserveFieldScoped("fire", "onTimer")
End Sub

'-------------------------------------------------------------------------------
' onTimer
'-------------------------------------------------------------------------------
Sub onTimer(evt as Object)

    m.top.current--
    if m.top.current <= 0

        m.timer.control = "stop"
        m.top.text = 0
        m.top.current = 0
    else

        m.top.text = m.top.current
    end if
End Sub

'-------------------------------------------------------------------------------
' onControl
'-------------------------------------------------------------------------------
Sub onControl(evt as Object)

    status = evt.getData()

    if status = "start"
        
        m.top.current = m.top.count
        m.top.text = m.top.current

        m.timer.control = "start"
    else if status = "stop"

        m.timer.control = "stop"
    end if
End Sub
