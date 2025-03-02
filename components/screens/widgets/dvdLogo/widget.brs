'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    resolution = UI_Resolution()

    m.bounce = m.top.findNode("bounce")
    m.bounce.setFields({
        width:resolution.width,
        height:resolution.height
    })
End Sub

'-------------------------------------------------------------------------------
' __onScreenWillShow
'-------------------------------------------------------------------------------
Sub __onScreenWillShow()
End Sub

'-------------------------------------------------------------------------------
' __onScreenWillHide
'-------------------------------------------------------------------------------
Sub __onScreenWillHide()
End Sub

'-------------------------------------------------------------------------------
' __isActive
'-------------------------------------------------------------------------------
Sub __isActive(refresh=false as Boolean)

    poster = CreateObject("roSGNode", "Poster")
    poster.setFields({
        loadSync:true,
        id:"logo",
        width:200,
        height:130,
        uri:"pkg:/assets/widgets/dvdLogo/dvd-logo.jpg"
    })
    m.bounce.callFunc("add", poster)
End Sub
