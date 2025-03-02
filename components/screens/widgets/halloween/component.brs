'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.deviceInfo = CreateObject("roDeviceInfo")

    m.resolution = UI_Resolution()

    background = m.top.findNode("background")
    background.width = m.resolution.width
    background.height= m.resolution.height

    m.spiderTimer = m.top.findNode("spiderTimer")
    m.spiderTimer.ObserveFieldScoped("fire", "onSpiderTimer")

    m.spiderAnimation = m.top.findNode("spiderAnimation")
    m.spiderAnimation.ObserveFieldScoped("state", "onSpiderAnimation")

    m.spiderInterp = m.top.findNode("spiderInterp")

    m.pAnimation = m.top.findNode("pAnimation")
    m.pAnimation.ObserveFieldScoped("state", "onPAnimationState")

    m.animation1 = m.top.findNode("animation1")
    m.animation2 = m.top.findNode("animation2")
    m.animation3 = m.top.findNode("animation3")
    m.animation4 = m.top.findNode("animation4")

    m.inter1 = m.top.findNode("inter1")
    m.inter2 = m.top.findNode("inter2")
    m.inter3 = m.top.findNode("inter3")
    m.inter4 = m.top.findNode("inter4")
    
    m.container = m.top.findNode("container")

    m.images = {
        bat:{
            width:100,
            height:100
        },
        ghost:{
            width:100,
            height:100
        },
        mask:{
            width:100,
            height:100
        },
        skull:{
            width:100,
            height:100
        }
    }

    ' items that float to the right
    m.imagesRight = ["bat", "ghost", "skull"]

    ' items that float to the left
    m.imagesLeft = ["ghost", "skull"]
End Sub

'-------------------------------------------------------------------------------
' pause
'-------------------------------------------------------------------------------
Sub pause()

    m.pAnimation.control = "pause"
End Sub

'-------------------------------------------------------------------------------
' resume
'-------------------------------------------------------------------------------
Sub resume()

    m.pAnimation.control = "resume"
End Sub

'-------------------------------------------------------------------------------
' onSpiderTimer
'-------------------------------------------------------------------------------
Sub onSpiderTimer(evt as Object)

    x = Math_Random(100, 900)
    m.spiderInterp.keyValue = [ [x, -400], [x, 0] ]
    m.spiderInterp.reverse = false
    m.spiderAnimation.control = "start"
End Sub

'-------------------------------------------------------------------------------
' onSpiderAnimation
'-------------------------------------------------------------------------------
Sub onSpiderAnimation(evt as Object)

    state = evt.getData()
    if state = "stopped"

        if NOT m.spiderInterp.reverse
            
            m.spiderInterp.reverse = true
            m.spiderAnimation.control = "start"
        else

            m.spiderTimer.control = "start"
        end if
    end if
End Sub

'-------------------------------------------------------------------------------
' onPAnimationState
'-------------------------------------------------------------------------------
Sub onPAnimationState(evt as Object)

    state = evt.getData()
    if state = "stopped"

        create()
    end if
End Sub

'-------------------------------------------------------------------------------
' create
'-------------------------------------------------------------------------------
Sub create()

    m.container.removeChildrenIndex(m.container.getChildCount(), 0)

    ' float to the right
    image = m.imagesRight[Math_Random(0, m.imagesRight.Count() - 1)]
    id = m.deviceInfo.GetRandomUUID()
    poster = createPoster(image, id)
    m.inter1.fieldToInterp = id + ".translation"
    m.inter1.keyValue =[ [-(poster.width), 50], [m.resolution.width, Math_Random(0, 400)] ]

    image = m.imagesRight[Math_Random(0, m.imagesRight.Count() - 1)]
    id = m.deviceInfo.GetRandomUUID()
    poster = createPoster(image, id)
    m.animation2.delay = 5
    m.inter2.fieldToInterp = id + ".translation"
    m.inter2.keyValue=[ [-(poster.width), 400], [m.resolution.width, Math_Random(0, 400)] ]
    
    ' float to the left
    image = m.imagesLeft[Math_Random(0, m.imagesLeft.Count() - 1)]
    id = m.deviceInfo.GetRandomUUID()
    poster = createPoster(image, id)
    m.inter3.fieldToInterp = id + ".translation"
    m.inter3.keyValue=[ [m.resolution.width, 50], [-(poster.width), Math_Random(0, 400)] ]

    image = m.imagesLeft[Math_Random(0, m.imagesLeft.Count() - 1)]
    id = m.deviceInfo.GetRandomUUID()
    poster = createPoster(image, id)
    m.animation4.delay = 5
    m.inter4.fieldToInterp = id + ".translation"
    m.inter4.keyValue=[ [m.resolution.width, 400], [-(poster.width), Math_Random(0, 400)] ]

    m.pAnimation.control = "start"

    if m.spiderTimer.control <> "start"

        m.spiderTimer.control = "start"
    end if
End Sub

'-------------------------------------------------------------------------------
' createPoster
'-------------------------------------------------------------------------------
Function createPoster(image as String, id as String) as Object

    imageObj = m.images[image]

    poster = CreateObject("roSGNode", "Poster")
    poster.id = id
    poster.width = imageObj.width
    poster.height= imageObj.height
    poster.translation = [-100, -100]
    poster.uri = "pkg:/assets/widgets/halloween/" + image + ".png"

    m.container.appendChild(poster)

    return poster
End Function