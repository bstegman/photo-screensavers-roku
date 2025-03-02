' Stegman Company LLC.  V2.0

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

    m.top.color = "0xFFFFFFF00"

    m.maxX = 0
    m.item = invalid
    m.itemHeight = 0
    m.itemWidth = 0

    m.container = m.top.findNode("container")

    m.animation = m.top.findNode("animation")
    m.animation.ObserveFieldScoped("state", "onAnimation")

    m.interp = m.top.findNode("interp")
End Sub

'-------------------------------------------------------------------------------
' onAnimation
'-------------------------------------------------------------------------------
Function onAnimation(evt as Object)

	status = evt.getData()
	if status = "stopped"

		if m.item.translation[0] > 0

			y = MATH_Random(0, m.top.height - m.itemHeight)
			m.interp.keyValue = [ m.item.translation, [0, y] ]
			m.animation.control = "start"
		else

			y = MATH_Random(0, m.top.height - m.itemHeight)
			m.interp.keyValue = [ m.item.translation, [m.maxX, y] ]
			m.animation.control = "start"
		end if
	end if
End Function

'-------------------------------------------------------------------------------
' add
'-------------------------------------------------------------------------------
Sub add(item as Object)

    m.item = item
    m.animation.control = "stop"

    m.container.removeChildrenIndex(m.container.getChildCount(), 0)
    m.container.appendChild(item)

    if item.subtype() = "Poster"

        m.itemHeight = item.height
        m.maxX = m.top.width - item.width
    else

        rect = item.boundingRect()
        m.itemHeight = rect.height
        m.maxX = m.top.width - rect.width
    end if

    y1 = MATH_Random(0, m.top.height - m.itemHeight)
    y2 = MATH_Random(0, m.top.height - m.itemHeight)
    m.interp.keyValue = [ [0, y1], [m.maxX, y2] ]
    m.interp.fieldToInterp = item.id + ".translation"

    m.animation.control = "start"
End Sub