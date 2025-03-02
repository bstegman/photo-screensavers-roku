' Stegman Company LLC.  V2.1

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.top.ObserveFieldScoped("content", "onContentChanged")
    setOrientationFields(m.top.orientation)
    m.top.SetFields({
        itemComponentName:"ButtonStandardComponent",
        horizFocusAnimationStyle:"floatingFocus",
        vertFocusAnimationStyle:"floatingFocus",
        drawFocusFeedback:false
        wrapDividerBitmapUri:""
    })
End Sub

'-------------------------------------------------------------------------------
' onContentChanged
'-------------------------------------------------------------------------------
Sub onContentChanged(evt as Object)

    if m.top.orientation = "vertical"
        
        m.top.numColumns = 1
        m.top.numRows = evt.getData().getChildCount()
    else

        m.top.numColumns = evt.getData().getChildCount()
        m.top.numRows = 1
    end if
End Sub

'-------------------------------------------------------------------------------
' setOrientationFields
' @param orientation - The layout directions of the buttons
'-------------------------------------------------------------------------------
Sub setOrientationFields(orientation)

    m.top.SetFields({
        itemSize:[500, 100],
        itemSpacing:[10, 10],
        rowHeights:[100]
    })
End Sub

'-------------------------------------------------------------------------------
' create
'-------------------------------------------------------------------------------
Sub create(items as Object)

    content = CreateObject("roSGNode", "ContentNode")
    for i=0 to items.Count() - 1

        item = items[i]

        btn = content.createChild("ButtonStandardNode")
        btn.id = item.id
        btn.title = item.title
        btn.icon = item.icon
    end for
    m.top.content = content
End Sub