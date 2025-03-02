' Stegman Company LLC.  V1.0

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.numAnimationsProcessed = 0
	m.resolution = UI_Resolution()

    m.animationContainer = m.top.findNode("animationContainer")
    m.posterContainer = m.top.findNode("posterContainer")

    m.timer = m.top.findNode("timer")
    m.timer.ObserveFieldScoped("fire", "onTimer")
End Sub

'-------------------------------------------------------------------------------
' onAnimation
'-------------------------------------------------------------------------------
Sub onAnimation(evt as Object)

    if evt.getData() = "stopped"

        m.numAnimationsProcessed++
        if m.numAnimationsProcessed >= m.top.numItems

            start()
        end if
    end if
End Sub

'-------------------------------------------------------------------------------
' onControl
'-------------------------------------------------------------------------------
Sub onControl(evt as Object)

    state = evt.getData()
    if state = "start"

        start()
    else if state = "stop"

        m.timer.control = "stop"
        clearAll()
    end if
End Sub

'-------------------------------------------------------------------------------
' onTimer
'-------------------------------------------------------------------------------
Sub onTimer()

    if m.posterContainer.getChildCount() < m.top.numItems

        createAnimation()
    else

        m.timer.control = "stop"
    end if
End Sub

'-------------------------------------------------------------------------------
' createAnimation
'-------------------------------------------------------------------------------
Sub createAnimation()

    id = m.posterContainer.getChildCount()
    if id MOD 2

        translation = [Math_Random(100, m.resolution.width/2), -125]
    else

        translation = [Math_Random(m.resolution.width/2, m.resolution.width - 100), -125]
    end if
    id = id.toStr()

    sizeAry = m.top.imageSize.split("x")

    ' poster
    poster = CreateObject("roSGNode", "Poster")
    poster.SetFields({
        id:"poster-" + id,
        width:sizeAry[0],
        height:sizeAry[1],
        loadSync:true,
        translation:translation,
        uri:m.top.images[Math_Random(0, m.top.images.Count() - 1)]
    })
    m.posterContainer.appendChild(poster)

    ' animation
    animation = CreateObject("roSGNode", "Animation")
    animation.ObserveFieldScoped("state", "onAnimation")
    animation.SetFields({
        id:"animation-" + id,
        duration:45,
        repeat:false,
        easeFunction:"linear"
    })

    ' interp
    interp = CreateObject("roSGNode", "Vector2DFieldInterpolator")
    interp.SetFields({
        id:"interp-" + id,
        key:[0.0, 1.0],
        fieldToInterp:poster.id + ".translation",
        keyValue:[ [poster.translation[0], poster.translation[1]], [poster.translation[0], m.resolution.height] ]
    })
    animation.appendChild(interp)
    m.animationContainer.appendChild(animation)
    animation.control = "start"
End Sub

'-------------------------------------------------------------------------------
' start
'-------------------------------------------------------------------------------
Sub start()

    m.timer.control = "stop"

    m.numAnimationsProcessed = 0
    clearAll()
    createAnimation()

    m.timer.control = "start"
End Sub

'-------------------------------------------------------------------------------
' clearAll
'-------------------------------------------------------------------------------
Sub clearAll()

    m.posterContainer.removeChildrenIndex(m.posterContainer.getChildCount(), 0)
    m.animationContainer.removeChildrenIndex(m.animationContainer.getChildCount(), 0)
End Sub