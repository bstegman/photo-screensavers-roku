'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.resolution = UI_Resolution()

    m.deviceInfo = CreateObject("roDeviceInfo")

    m.background = m.top.findNode("background")
    m.background.width = m.resolution.width
    m.background.height= m.resolution.height

    m.pAnimation = m.top.findNode("pAnimation")
    m.pAnimation.ObserveFieldScoped("state", "onPAnimationState")

    m.animation1 = m.top.findNode("animation1")
    m.animation2 = m.top.findNode("animation2")
    m.animation3 = m.top.findNode("animation3")
    m.animation4 = m.top.findNode("animation4")
    m.animation5 = m.top.findNode("animation5")
    m.animation6 = m.top.findNode("animation6")

    m.inter1 = m.top.findNode("inter1")
    m.inter2 = m.top.findNode("inter2")
    m.inter3 = m.top.findNode("inter3")
    m.inter4 = m.top.findNode("inter4")
    m.inter5 = m.top.findNode("inter5")
    m.inter6 = m.top.findNode("inter6")
    
    m.fishContainer = m.top.findNode("fishContainer")

    m.fishImages = {
        fish1:{
            width:100,
            height:71
        },
        fish2:{
            width:82,
            height:62
        },
        fish3:{
            width:96,
            height:86
        }
        fish4:{
            width:100,
            height:71
        }
        fish5:{
            width:100,
            height:66
        }
        fish6:{
            width:76,
            height:52
        }
        fish7:{
            width:80,
            height:68
        }
        fish8:{
            width:84,
            height:70
        }
        fish9:{
            width:84,
            height:77
        }
        fish10:{
            width:76,
            height:52
        },
        fish11:{
            width:80,
            height:79
        },
        fish12:{
            width:80,
            height:77
        }
    }

    m.fishRight = ["fish1", "fish2", "fish3", "fish4", "fish5", "fish6"]
    m.fishLeft = ["fish7", "fish8", "fish9", "fish10", "fish11", "fish12"]
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
' onPAnimationState
'-------------------------------------------------------------------------------
Sub onPAnimationState(evt as Object)

    state = evt.getData()
    if state = "stopped"

        createFishTank()
    end if
End Sub

'-------------------------------------------------------------------------------
' createFishTank
'-------------------------------------------------------------------------------
Sub createFishTank()

    m.fishContainer.removeChildrenIndex(m.fishContainer.getChildCount(), 0)

    ' left
    fish = m.fishRight[Math_Random(0, m.fishRight.Count() - 1)]
    fishId = m.deviceInfo.GetRandomUUID()
    poster = createFishPoster(fish, fishId)
    m.inter1.fieldToInterp = fishId + ".translation"
    m.inter1.keyValue =[ [-(poster.width), Math_Random(50, 400)], [m.resolution.width, Math_Random(0, m.resolution.height)] ]

    fish = m.fishRight[Math_Random(0, m.fishRight.Count() - 1)]
    fishId = m.deviceInfo.GetRandomUUID()
    poster = createFishPoster(fish, fishId)
    m.animation2.delay = 5
    m.inter2.fieldToInterp = fishId + ".translation"
    m.inter2.keyValue=[ [-(poster.width), Math_Random(425, 600)], [m.resolution.width, Math_Random(0, m.resolution.height)] ]

    ' top
    fish = m.fishRight[Math_Random(0, m.fishRight.Count() - 1)]
    fishId = m.deviceInfo.GetRandomUUID()
    poster = createFishPoster(fish, fishId)
    m.animation5.delay = 10
    m.animation5.duration = 40
    m.inter5.fieldToInterp = fishId + ".translation"
    m.inter5.keyValue=[ [Math_Random(100, 300), -(poster.width)], [Math_Random(640, m.resolution.width), m.resolution.height] ]
    
    ' right
    fish = m.fishLeft[Math_Random(0, m.fishLeft.Count() - 1)]
    fishId = m.deviceInfo.GetRandomUUID()
    poster = createFishPoster(fish, fishId)
    m.inter3.fieldToInterp = fishId + ".translation"
    m.inter3.keyValue=[ [m.resolution.width, Math_Random(50, 400)], [-(poster.width), Math_Random(0, m.resolution.height)] ]

    fish = m.fishLeft[Math_Random(0, m.fishLeft.Count() - 1)]
    fishId = m.deviceInfo.GetRandomUUID()
    poster = createFishPoster(fish, fishId)
    m.animation4.delay = 5
    m.inter4.fieldToInterp = fishId + ".translation"
    m.inter4.keyValue=[ [m.resolution.width, Math_Random(425, 600)], [-(poster.width), Math_Random(0, m.resolution.height)] ]

    ' bottom
    fish = m.fishLeft[Math_Random(0, m.fishLeft.Count() - 1)]
    fishId = m.deviceInfo.GetRandomUUID()
    poster = createFishPoster(fish, fishId)
    m.animation6.delay = 10
    m.animation6.duration = 40
    m.inter6.fieldToInterp = fishId + ".translation"
    m.inter6.keyValue=[ [Math_Random(640, m.resolution.width), m.resolution.height], [Math_Random(-(poster.width), 640), -(poster.width)] ]

    m.pAnimation.control = "start"
End Sub

'-------------------------------------------------------------------------------
' createFishPoster
'-------------------------------------------------------------------------------
Function createFishPoster(fish as String, id as String) as Object

    fishObj = m.fishImages[fish]

    poster = CreateObject("roSGNode", "Poster")
    poster.id = id
    poster.width = fishObj.width
    poster.height= fishObj.height
    poster.translation = [-100, -100]
    poster.uri = "pkg:/assets/widgets/aquarium/" + fish + ".png"

    m.fishContainer.appendChild(poster)

    return poster
End Function