' Stegman Company LLC.  V1.2

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()
    
    m.top.color = "0xFFFFFF00"

    m.borderTop = m.top.findNode("borderTop")
    m.borderRight = m.top.findNode("borderRight")
    m.borderBottom = m.top.findNode("borderBottom")
    m.borderLeft = m.top.findNode("borderLeft")
End Sub

'-------------------------------------------------------------------------------
' draw
'-------------------------------------------------------------------------------
Sub draw()

    ' top
    m.borderTop.width = m.top.width
    m.borderTop.height= m.top.borderSize
    m.borderTop.color = m.top.borderColor
    
    ' right
    m.borderRight.height = m.top.height
    m.borderRight.width = m.top.borderSize
    m.borderRight.color = m.top.borderColor
    m.borderRight.translation = [m.top.width - m.top.borderSize, 0]

    ' bottom
    m.borderBottom.width = m.top.width
    m.borderBottom.height = m.top.borderSize
    m.borderBottom.color = m.top.borderColor
    m.borderBottom.translation = [0, m.top.height - m.top.borderSize]

    ' left
    m.borderLeft.height = m.top.height
    m.borderLeft.width = m.top.borderSize
    m.borderLeft.color = m.top.borderColor
End Sub