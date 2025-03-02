' Stegman Company LLC.  V1.0

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.top.ObserveFieldScoped("focusedChild", "onFocusChanged")

    m.itemTextInput = m.top.findNode("itemTextInput")

    m.keyGrid = m.top.findNode("keyGrid")
    m.keyGrid.ObserveFieldScoped("itemSelected", "onKeySelected")
    buildKeys()
End Sub

'-------------------------------------------------------------------------------
' onFocusChanged
'-------------------------------------------------------------------------------
Sub onFocusChanged(evt as Object)

    if TYPE_isValid(evt.getData())

        m.keyGrid.setFocus(true)
    end if
End Sub

'-------------------------------------------------------------------------------
' onKeySelected
'-------------------------------------------------------------------------------
Sub onKeySelected(evt as Object)

    item = m.keyGrid.content.getChild(evt.getData())
    if item.id = "delete"

        m.itemTextInput.text = Left(m.itemTextInput.text, Len(m.itemTextInput.text) - 1)
    else if item.id = "empty"

        m.itemTextInput.text = ""
    else if item.id = "space"

        m.itemTextInput.text += " "
    else if item.id <> "enter"

        m.itemTextInput.text += item.title
    end if

    m.top.inputText = m.itemTextInput.text
    m.top.keypressed = item.id
End Sub

'-------------------------------------------------------------------------------
' buildKeys
'-------------------------------------------------------------------------------
Sub buildKeys()

    content = CreateObject("roSGNode", "ContentNode")

    for i=0 to 9

        item = content.createChild("ContentNode")
        item.id = i
        item.title = i.toStr()
    end for

    item = content.createChild("ContentNode")
    item.id = "delete"
    item.title = "b"

    item = content.createChild("ContentNode")
    item.id = "empty"
    item.title = "a"

    item = content.createChild("ContentNode")
    item.id = "enter"
    item.title = "c"

    if m.top.type = "alphaNumeric"

        m.keyGrid.SetFields({
            numRows:3
        })
        letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "space"]
        for i=0 to letters.Count() - 1

            item = content.createChild("ContentNode")
            item.id = letters[i]
            item.title = letters[i]
        end for
    end if

    m.keyGrid.content = content
End Sub

'-------------------------------------------------------------------------------
' isFocused
'-------------------------------------------------------------------------------
Function isFocused() as Boolean

    return m.keyGrid.hasFocus()
End Function

'-------------------------------------------------------------------------------
' clearInput
'-------------------------------------------------------------------------------
Function clearInput() as Boolean

    m.itemTextInput.text = ""
End Function