'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    clearAll()
End Sub

'-------------------------------------------------------------------------------
' clearAll
'-------------------------------------------------------------------------------
Sub clearAll()

    m.top.animation = ""

    clearMusic()
    clearSound()
End Sub

'-------------------------------------------------------------------------------
' clearMusic
'-------------------------------------------------------------------------------
Sub clearMusic()

    m.top.musicGenre = CreateObject("roSGNode", "ContentNode")
    m.top.musicGenre.SetFields({
        id:"none",
        title:Locale_String("None")
    })
End Sub

'-------------------------------------------------------------------------------
' clearSound
'-------------------------------------------------------------------------------
Sub clearSound()

    m.top.sound = CreateObject("roSGNode", "ContentNode")
    m.top.sound.SetFields({
        id:"none",
        title:Locale_String("None")
    })
End Sub
