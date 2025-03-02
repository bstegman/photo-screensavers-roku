'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.chars = String_Chars()
    ' m.characters = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    m.characters = ["0", "1"]
    m.fontColor = "#008000"

    m.drawingStyles = {
        "h1": {
            "fontUri": "font:SmallestSystemFont"
            "color": "#FFFFFF"
        },
        "default": {
            "fontUri": "font:SmallestSystemFont"
            "color": "#008000"
        }
    }

    m.container = m.top.findNode("container")
    m.animTimer = m.top.findNode("animTimer")

    m.items = []
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillShow
'-------------------------------------------------------------------------------
Sub __onScreenWillShow()

    m.animTimer.ObserveFieldScoped("fire", "onAnimTimer")
End Sub

'-------------------------------------------------------------------------------
' _onScreenWillHide
'-------------------------------------------------------------------------------
Sub __onScreenWillHide()

    m.animTimer.UnObserveFieldScoped("fire")
End Sub

'-------------------------------------------------------------------------------
' __isActive
'-------------------------------------------------------------------------------
Sub __isActive()

    create()
End Sub

'-------------------------------------------------------------------------------
' create
'-------------------------------------------------------------------------------
Sub create()

    x = 10
    for i=0 to 75

        item = CreateObject("roSGNode", "MultiStyleLabel")
        item.id = i
        item.drawingStyles = m.drawingStyles
        item.horizAlign = "center"
        item.translation = [x, 0]

        highlight = Math_Random(0, 25)
        ct = 26
        str = ""
        for j=0 to ct

            if j = highlight

                str += "<h1>" + m.characters[Math_Random(0, m.characters.Count() - 1)] + "</h1>" + m.chars.NL
            else

                str += m.characters[Math_Random(0, m.characters.Count() - 1)] + m.chars.NL
            end if
        end for
        item.text = str
        m.items.push(item)
        m.top.appendChild(item)

        x += 25
    end for

    m.animTimer.control = "start"
End Sub

'-------------------------------------------------------------------------------
' onAnimTimer
'-------------------------------------------------------------------------------
Sub onAnimTimer()

    for i=0 to m.items.Count() - 1

        item = m.items[i]

        highlight = Math_Random(0, 25)
        ct = 26
        str = ""
        for j=0 to ct

            if j = highlight

                str += "<h1>" + m.characters[Math_Random(0, m.characters.Count() - 1)] + "</h1>" + m.chars.NL
            else

                str += m.characters[Math_Random(0, m.characters.Count() - 1)] + m.chars.NL
            end if
        end for
        item.text = str
    end for
End Sub