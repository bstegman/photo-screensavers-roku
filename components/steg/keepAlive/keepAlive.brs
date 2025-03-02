' Stegman Company LLC.  V5.0

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    scene = m.top.GetScene()
    m.apiRequestManager = scene.findNode("ApiRequestManager")

    m.aliveType = ""

    m.videoPlayer = m.top.findNode("videoPlayer")
    m.videoPlayer.ObserveFieldScoped("state", "onState")

    node = CreateObject("roSGNode","KeepAliveNode")
    content = CreateObject("roSGNode","ContentNode")
    content.url = node.url
    content.streamformat = node.streamformat
    m.videoPlayer.content = content

    device = CreateObject("roDeviceInfo")
    ip = ""
    ipObj = device.GetIPAddrs()
    for each k in ipObj.Keys()

        if ipObj[k] <> ""

            ip = ipObj[k]
            exit for
        end if
    end for
    m.host = "http://" + ip
    m.port = ":8060"
    m.url = "/input?contentId=123&mediaType=episode"

    m.timer = m.top.findNode("timer")
    m.timer.ObserveFieldScoped("fire", "onTimer")
    if TYPE_isValid(m.global.screensaverTimeout) AND m.global.screensaverTimeout > 0

        m.timer.duration = ((m.global.screensaverTimeout*60) - 15)
    else

        m.timer.duration = 45
    end if
End Sub

'-------------------------------------------------------------------------------
' onTimer
'-------------------------------------------------------------------------------
Sub onTimer(evt as Object)

    runKeepAlive()
End Sub

'-------------------------------------------------------------------------------
' onState
'-------------------------------------------------------------------------------
Sub onState(evt as Object)

    state = evt.getData()
    if state = "finished"

        m.timer.control = "start"
    end if
End Sub

'-------------------------------------------------------------------------------
' callback
'-------------------------------------------------------------------------------
Sub callback(response as Object)

    m.timer.control = "start"
End Sub

'-------------------------------------------------------------------------------
' runKeepAlive
'-------------------------------------------------------------------------------
Sub runKeepAlive()

    if m.aliveType = "video"

        m.videoPlayer.control = "play"
    else if m.aliveType = "launch"

        request = {
            type:"POST",
            requestId:"keep-alive",
            host:m.host + m.port,
            url:m.url
        }
        API_Utils_SendRequest(callback, request)
    end if
End Sub

'-------------------------------------------------------------------------------
' start
'-------------------------------------------------------------------------------
Sub start(aliveType="launch" as String, runAlive=false as Boolean)

    m.aliveType = aliveType
    m.timer.control = "start"

    if runAlive

        runKeepAlive()
    end if
End Sub

'-------------------------------------------------------------------------------
' stopKeepAlive
'-------------------------------------------------------------------------------
Sub stopKeepAlive()

    m.timer.control = "stop"
    m.videoPlayer.control = "stop"
End Sub