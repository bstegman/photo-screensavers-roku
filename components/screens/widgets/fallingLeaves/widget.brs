'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

        m.scenes = [
        {
            bak:"https://images.unsplash.com/photo-1604093882750-3ed498f3178b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzMzA5fDB8MXxhbGx8fHx8fHx8fHwxNjY3NzQwOTMx&ixlib=rb-4.0.3&q=80&w=1080",
            leaf:"pkg:/assets/widgets/fallLeaves/leaf3.png",
            lanes:[
                {
                    duration:10,
                    opacity:.75,
                    start:[360, 316],
                    end:[360, 900]
                    size:{
                        width:22,
                        height:22
                    }
                },
                {
                    duration:10,
                    opacity:.75,
                    start:[490, 448],
                    end:[490, 900]
                    size:{
                        width:12,
                        height:12
                    }
                },
                {
                    duration:8,
                    opacity:.75,
                    start:[635, 400],
                    end:[635, 950]
                    size:{
                        width:24,
                        height:24
                    }
                },
                {
                    duration:8,
                    opacity:.75,
                    start:[1200, 500],
                    end:[1200, 900]
                    size:{
                        width:16,
                        height:16
                    }
                },
                {
                    duration:8,
                    opacity:.75,
                    start:[500, 500],
                    end:[500, 900]
                    size:{
                        width:12,
                        height:12
                    }
                }
            ]
        },
        {
            bak:"https://images.unsplash.com/photo-1523712999610-f77fbcfc3843?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzMzA5fDB8MXxhbGx8fHx8fHx8fHwxNjY3NzQyODQ4&ixlib=rb-4.0.3&q=80&w=1080",
            leaf:"pkg:/assets/widgets/fallLeaves/leaf3.png",
            lanes:[
                {
                    duration:10,
                    opacity:.75,
                    start:[300, 100],
                    end:[300, 900]
                    size:{
                        width:18,
                        height:18
                    }
                },
                {
                    duration:10,
                    opacity:.75,
                    start:[140, 100],
                    end:[140, 850]
                    size:{
                        width:14,
                        height:14
                    }
                },
                {
                    duration:10,
                    opacity:.75,
                    start:[550, 190],
                    end:[550, 830]
                    size:{
                        width:20,
                        height:20
                    }
                },
                {
                    duration:10,
                    opacity:.75,
                    start:[1180, 75],
                    end:[1180, 815]
                    size:{
                        width:20,
                        height:20
                    }
                },
                {
                    duration:10,
                    opacity:.75,
                    start:[1700, 0],
                    end:[1700, 900]
                    size:{
                        width:32,
                        height:32
                    }
                }
            ]
        },
        {
            bak:"https://images.unsplash.com/photo-1476820865390-c52aeebb9891?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzMzA5fDB8MXxhbGx8fHx8fHx8fHwxNjcyMTgxMjQ2&ixlib=rb-4.0.3&q=80&w=1080",
            leaf:"pkg:/assets/widgets/fallLeaves/leaf3.png",
            lanes:[
                {
                    duration:10,
                    opacity:.75,
                    start:[700, 240],
                    end:[700, 635]
                    size:{
                        width:16,
                        height:16
                    }
                },
                {
                    duration:5,
                    opacity:.75,
                    start:[850, 425],
                    end:[850, 635]
                    size:{
                        width:12,
                        height:12
                    }
                },
                {
                    duration:5,
                    opacity:.75,
                    start:[1500, 150],
                    end:[1500, 650]
                    size:{
                        width:20,
                        height:20
                    }
                },
                {
                    duration:5,
                    opacity:.75,
                    start:[850, 80],
                    end:[850, 625]
                    size:{
                        width:24,
                        height:24
                    }
                },
                {
                    duration:5,
                    opacity:.75,
                    start:[1100, 250],
                    end:[1100, 630]
                    size:{
                        width:18,
                        height:18
                    }
                }
            ]
        }
    ]

    m.sceneIdx = 0
    m.poster = invalid
    m.animations = []
    m.interps = []

    m.animation1 = invalid
    m.interp1 = invalid

    m.animation2 = invalid
    m.interp2 = invalid

    m.poster = CreateObject("roSGNode", "Poster")
    m.top.appendChild(m.poster)

    m.viewPhoto = m.top.findNode("viewPhoto")

    m.pAnimation = m.top.findNode("pAnimation")
    m.animTimer = m.top.findNode("animTimer")
    m.timerChangeScene = m.top.findNode("timerChangeScene")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow
'-------------------------------------------------------------------------------
Sub __onScreenWillShow()

    m.viewPhoto.ObserveFieldScoped("loadStatus", "onPhoto")
    m.animTimer.ObserveFieldScoped("fire", "onAnimTimer")
    m.timerChangeScene.ObserveFieldScoped("fire", "onTimerChangeScene")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide
'-------------------------------------------------------------------------------
Sub __onScreenWillHide()

    m.viewPhoto.UnObserveFieldScoped("loadStatus")
    m.animTimer.UnObserveFieldScoped("fire")
    m.timerChangeScene.UnObserveFieldScoped("fire")
End Sub

'-------------------------------------------------------------------------------
' __isActive
'-------------------------------------------------------------------------------
Sub __isActive()

    m.sceneIdx = Math_Random(0, 2)

    create()
    setScene(m.scenes[m.sceneIdx])

    m.timerChangeScene.control = "start"
End Sub

'-------------------------------------------------------------------------------
' onAnimation
'-------------------------------------------------------------------------------
Sub onAnimation(evt as Object)

    state = evt.getData()
    if state = "stopped"

        if TYPE_isValid(m.poster)

            m.poster.visible = false
        end if
        m.animTimer.control = "start"
    end if
End Sub

'-------------------------------------------------------------------------------
' onPhoto
'-------------------------------------------------------------------------------
Sub onPhoto(evt as Object)

    status = evt.getData()
    if status = "ready"

        m.animTimer.control = "start"
    end if
End Sub

'-------------------------------------------------------------------------------
' onAnimTimer
'-------------------------------------------------------------------------------
Sub onAnimTimer(evt as Object)

    dropLeaf()
End Sub

'-------------------------------------------------------------------------------
' onTimerChangeScene
'-------------------------------------------------------------------------------
Sub onTimerChangeScene(evt as Object)

    m.pAnimation.control = "pause"
    m.animTimer.control = "stop"

    if m.sceneIdx + 1 < m.scenes.Count()

        m.sceneIdx++
    else

        m.sceneIdx = 0
    end if

    setScene(m.scenes[m.sceneIdx])
End Sub

'-------------------------------------------------------------------------------
' dropLeaf
'-------------------------------------------------------------------------------
Sub dropLeaf()

    lanes = m.scenes[m.sceneIdx].lanes
    lane = lanes[Math_Random(0, lanes.Count() - 1)]
    ' lane = lanes[4]

    m.animations[0].duration = lane.duration
    m.interps[0].keyValue = [ lane.start, lane.end ]

    m.poster.SetFields({
        width:lane.size.width,
        height:lane.size.height,
        opacity:lane.opacity,
        scaleRotateCenter:[lane.size.width/2, lane.size.height/2],
        visible:true
    })

    m.pAnimation.control = "start"
End Sub

'-------------------------------------------------------------------------------
' create
'-------------------------------------------------------------------------------
Sub create()

    ' falling
    animation = CreateObject("roSGNode", "Animation")
    animation.id = "animation1"
    animation.repeat = false
    animation.easeFunction = "linear"
    animation.ObserveFieldScoped("state", "onAnimation")

    interp = CreateObject("roSGNode", "Vector2DFieldInterpolator")
    interp.id = "interp1"
    interp.key = [0.0, 1.0]
    interp.fieldToInterp = "leaf.translation"
    animation.appendChild(interp)

    m.pAnimation.appendChild(animation)

    m.animations.push(animation)
    m.interps.push(interp)

    ' spinning
    animation = CreateObject("roSGNode", "Animation")
    animation.id = "animation2"
    animation.duration = 5
    animation.repeat = true
    animation.easeFunction = "linear"

    interp = CreateObject("roSGNode", "FloatFieldInterpolator")
    interp.id = "interp2"
    interp.key = [0.0, 0.5, 1.0]
    interp.fieldToInterp = "leaf.rotation"

    deg1 = MATH_DegreeToRadian(-180)
    deg2 = MATH_DegreeToRadian(180)
    interp.keyValue = [deg1, deg2, deg1]
    animation.appendChild(interp)

    m.pAnimation.appendChild(animation)

    m.animations.push(animation)
    m.interps.push(interp)
End Sub

'-------------------------------------------------------------------------------
' setScene
'-------------------------------------------------------------------------------
Sub setScene(scene as Object)

    m.viewPhoto.photoURL = scene.bak

    m.poster.SetFields({
        id:"leaf",
        uri:scene.leaf,
        visible:false
    })
End Sub