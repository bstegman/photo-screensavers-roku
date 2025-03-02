' Stegman Company LLC v4.25

' General Helper Functions

'-------------------------------------------------------------------------------
' UI_Resolution - Returns the resolution of the Roku
'-------------------------------------------------------------------------------
Function UI_Resolution() as Object

	return m.global.getScene().currentDesignResolution
End Function

'-------------------------------------------------------------------------------
' UI_Transparent
'-------------------------------------------------------------------------------
Function UI_Transparent() as String

	return "0xFFFFFFF00"
End Function

'-------------------------------------------------------------------------------
' UI_Boundary - Returns a generic safe zone
'-------------------------------------------------------------------------------
Function UI_Boundary() as Integer
	return 40
End Function

'-------------------------------------------------------------------------------
' UI_Boundary_Tile - Returns the tile safe zone of the screen based on the
'   current screen resolution
'-------------------------------------------------------------------------------
Function UI_Boundary_Tile() as Object
	
	safeZone = {
		x:0,
		y:0
	}
	resolution = UI_Resolution().resolution
	if resolution = "FHD"
		safeZone = {
			x:192,
			y:106
		}
	else if resolution = "HD"
		safeZone = {
			x:128,
			y:70
		}
	else if resolution = "SD"
		safeZone = {
			x:72,
			y:48
		}
	end if
	return safeZone
End Function

'-------------------------------------------------------------------------------
' UI_Boundary_Action - Returns the action safe zone of the screen based on
'   the current screen resolution
'-------------------------------------------------------------------------------
Function UI_Boundary_Action() as Object
	
	safeZone = {
		x:0,
		y:0
	}
	resolution = UI_Resolution().resolution
	if resolution = "FHD"
		safeZone = {
			x:96,
			y:53
		}
	else if resolution = "HD"
		safeZone = {
			x:64,
			y:35
		}
	else if resolution = "SD"
		safeZone = {
			x:36,
			y:24
		}
	end if
	return safeZone
End Function

'-------------------------------------------------------------------------------
' UI_Node_Center - Returns the center cordinates of the node for the screen
'-------------------------------------------------------------------------------
Function UI_Node_Center(node as Object) as Object

	resolution = UI_Resolution()
	boundingRect = node.boundingRect()
	return {
		x:(resolution.width - boundingRect.width)/2,
		y:(resolution.height - boundingRect.height)/2
	}
End Function

'-------------------------------------------------------------------------------
' UI_Node_BottomRight - Returns the bottom right cordinates of the node for
'   the screen
'-------------------------------------------------------------------------------
Function UI_Node_BottomRight(node as Object) as Object

	boundingRect = node.boundingRect()
	return {
		x:boundingRect.x + boundingRect.width,
		y:boundingRect.y + boundingRect.height
	}
End Function

'-------------------------------------------------------------------------------
' UI_Node_BottomLeft - Returns the bottom left cordinates of the node for the screen
'-------------------------------------------------------------------------------
Function UI_Node_BottomLeft(node as Object) as Object

	boundingRect = node.boundingRect()
	return {
		x:boundingRect.x,
		y:boundingRect.y + boundingRect.height
	}
End Function

'-------------------------------------------------------------------------------
' UI_Node_Bottom - Returns the bottom of the node
'------------------------------------------------------------------------------
Function UI_Node_Bottom(node as Object) as Integer

	boundingRect = node.boundingRect()
	return boundingRect.y + boundingRect.height
End Function

'-------------------------------------------------------------------------------
' UI_Node_TopRight - Returns the top right cordinates of the node for the screen
'-------------------------------------------------------------------------------
Function UI_Node_TopRight(node as Object) as Object

	boundingRect = node.boundingRect()
	return {
		x:boundingRect.x + boundingRect.width,
		y:boundingRect.y
	}
End Function

'-------------------------------------------------------------------------------
' UI_Node_TopLeft - Returns the top left cordinates of the node for the screen
'-------------------------------------------------------------------------------
Function UI_Node_TopLeft(node as Object) as Object

	boundingRect = node.boundingRect()
	return {
		x:boundingRect.x,
		y:boundingRect.y
	}
End Function

'-------------------------------------------------------------------------------
' UI_Node_PlaceRight - Places the node to the right of toNode
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceRight(node as Object, toNode as Object, options=invalid as Object)

	toNodeRect = toNode.boundingRect()
	xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if
	end if
	node.translation = [toNodeRect.x + toNodeRect.width + xOffset, toNodeRect.y + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceBottomLeft - Places the node to the bottom left of the toNode
'
' @param toNode - This can be the node to align to or an array of nodes in which
' will scroll through and test if a node is valid and visible.  If so it will align
' to that node.  This is done in the order provided.
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceBottomLeft(node as Object, toNode as Dynamic, options=invalid as Object)

	xOffset = 0
	yOffset = 0
	if options <> Invalid

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if
	end if

	_toNode = invalid
	if type(toNode) = "roSGNode"

		_toNode = toNode
	else if GetInterface(toNode, "ifArray") <> invalid

		for i=0 to toNode.Count() - 1

			_node = m.top.findNode(toNode[i])
			if _node <> invalid AND _node.visible

				_toNode = _node
				exit for
			end if
		end for
	end if

	if _toNode <> invalid
	
		cords = UI_Node_BottomLeft(_toNode)
		node.translation = [cords.x + xOffset, cords.y + yOffset]
	end if
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceBottomCenter - Places the node to the bottom of toNode center of screen
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceBottomCenter(node as Object, toNode as Object, options=invalid as Object)

	cords = UI_Node_BottomLeft(toNode)
    center = UI_Node_Center(node)
	xOffset = 0
	yOffset = 0
	if options <> Invalid

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if
	end if
	node.translation = [center.x + xOffset, cords.y + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceBottomRight - Places the node to the bottom right of toNode
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceBottomRight(node as Object, toNode as Object, options=invalid as Object)

	boundingRect = node.boundingRect()
	cords = UI_Node_BottomRight(toNode)

	if options <> invalid

		' this will position node to align right not start right
		if options.align <> invalid AND options.align = true

			cords.x = cords.x - boundingRect.width
        end if
		
        if options.xOffset <> invalid

			cords.x = cords.x + options.xOffset
		end if

		if options.yOffset <> invalid

			cords.y = cords.y + options.yOffset
		end if
	end if

	node.translation = [cords.x, cords.y]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceTopCenter
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceTopCenter(node as Object, toNode as Object, options=invalid as Object)
	
    xOffset = 0
	yOffset = 0
	if options <> invalid
		
		if options.xOffset <> invalid
			
			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid
			
			yOffset = options.yOffset
		end if
	end if

	toNodeRect = toNode.boundingRect()
    nodeRect = node.boundingRect()
    cords = UI_Node_Center(node)
	node.translation = [cords.x + xOffset, toNodeRect.y - nodeRect.height + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceBottom - Places the node to the bottom
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceBottom(node as Object, toNode as Object, options=invalid as Object)
	
	yOffset = 0
	if options <> invalid
		
		if options.yOffset <> invalid
			
			yOffset = options.yOffset
		end if
	end if

	y = UI_Node_Bottom(toNode)
	node.translation = [UI_Boundary(), y + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceTopLeft - Places the node to the top right of toNode
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceTopLeft(node as Object, toNode as Object, options=invalid as Object)

    xOffset = 0
    yOffset = 0
	if options <> invalid
		
		if options.yOffset <> invalid
			
			yOffset = options.yOffset
		end if

        if options.xOffset <> invalid
			
			xOffset = options.xOffset
		end if
	end if

	cords = UI_Node_TopLeft(toNode)
	node.translation = [cords.x + xOffset, cords.y - node.boundingRect().height + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceTopRight - Places the node to the top right of toNode
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceTopRight(node as Object, toNode as Object, options=invalid as Object)

	xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if
	end if

	cords = UI_Node_TopRight(toNode)
	node.translation = [cords.x + xOffset, cords.y + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceInsideCenter - Places the node inside the center of the toNode
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceInsideCenter(node as Object, toNode as Object, options=invalid as Object)

    xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if
	end if

	boundaryToNode = toNode.BoundingRect()
	boundaryNode = node.BoundingRect()
	node.translation = [((boundaryToNode.width - boundaryNode.width)/2) + xOffset, ((boundaryToNode.height - boundaryNode.height)/2) + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceInsideTopCenter
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceInsideTopCenter(node as Object, toNode as Object, options=invalid as Object)

    xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if
	end if

	boundaryToNode = toNode.BoundingRect()
	boundaryNode = node.BoundingRect()
	node.translation = [((boundaryToNode.width - boundaryNode.width)/2) + xOffset, yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceInsideBottomCenter
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceInsideBottomCenter(node as Object, toNode as Object, options=invalid as Object)

    xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if
	end if

	boundaryToNode = toNode.BoundingRect()
	boundaryNode = node.BoundingRect()
	node.translation = [((boundaryToNode.width - boundaryNode.width)/2) + xOffset, (boundaryToNode.height - boundaryNode.height) + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceInsideBottomCenterNode
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceInsideBottomCenterNode(node as Object, toNode as Object, container as Object, options=invalid as Object)

    xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if
	end if

    boundaryContainerNode = container.BoundingRect()
	boundaryToNode = toNode.BoundingRect()
	boundaryNode = node.BoundingRect()
	node.translation = [((boundaryContainerNode.width - boundaryNode.width)/2) + xOffset, (boundaryToNode.y - boundaryToNode.height + boundaryNode.height) + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceInsideBottomLeft - Places the node inside the bottom left of the toNode
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceInsideBottomLeft(node as Object, toNode as Object)

	boundaryToNode = toNode.BoundingRect()
	boundaryNode = node.BoundingRect()
	node.translation = [0, (boundaryToNode.height - boundaryNode.height)]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceInsideBottomRight - Places the node inside the bottom right of the toNode
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceInsideBottomRight(node as Object, toNode as Object, options=invalid as Object)

	xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if
	end if

	boundaryToNode = toNode.BoundingRect()
	boundaryNode = node.BoundingRect()
	node.translation = [(boundaryToNode.width - boundaryNode.width) + xOffset, (boundaryToNode.height - boundaryNode.height) + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Node_PlaceInsideTopRight - Places the node inside the top right of the toNode
'-------------------------------------------------------------------------------
Sub UI_Node_PlaceInsideTopRight(node as Object, toNode as Object)

	boundaryToNode = toNode.BoundingRect()
	boundaryNode = node.BoundingRect()
	node.translation = [(boundaryToNode.width - boundaryNode.width), 0]
End Sub

'-------------------------------------------------------------------------------
' UI_Screen_PlaceNodeLeftCenter
'-------------------------------------------------------------------------------
Sub UI_Screen_PlaceNodeLeftCenter(node as Object, options=invalid as Object)

    xOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if
	end if

	boundary = UI_Boundary_Action()
	resolution = UI_Resolution()
	boundingRect = node.boundingRect()
	node.translation = [boundary.x + xOffset, (resolution.height-boundingRect.height)/2]
End Sub

'-------------------------------------------------------------------------------
' UI_Screen_PlaceNodeBottomRight - Places the node to the bottom right of the screen
'-------------------------------------------------------------------------------
Sub UI_Screen_PlaceNodeBottomRight(node as Object, options=invalid as Object)

    xOffset = 0
    yOffset = 0
    if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if
    end if

	boundary = UI_Boundary_Action()
	resolution = UI_Resolution()
	boundingRect = node.boundingRect()
	node.translation = [resolution.width - boundingRect.width - boundary.x + xOffset, resolution.height - boundingRect.height - boundary.y + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Screen_PlaceNodeBottomLeft 
'
' @param node Object - the node you would like to position
' @param options Object
'   @param xOffset Integer - move the node via the x axis
'   @param yOffset Integer - mpve the node via the y axis
'   @param offSetBoundary Boolean - by default the node is positioned within
'       the safe areas of the screen accounting for the bezel.  Setting this
'       variable to true will ignore the safe boundaries
'-------------------------------------------------------------------------------
Sub UI_Screen_PlaceNodeBottomLeft(node as Object, options=invalid as Object)

	boundary = UI_Boundary_Action()

	xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if

		if options.offSetBoundary <> invalid AND options.offSetBoundary

			xOffset = -(boundary.x)
			yOffset = boundary.y
		end if
	end if

	resolution = UI_Resolution()
	boundingRect = node.boundingRect()
	node.translation = [boundary.x + xOffset, (resolution.height - boundingRect.height - boundary.y) + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Screen_PlaceNodeBottomCenter - Places the node to the bottom center of the screen
'-------------------------------------------------------------------------------
Sub UI_Screen_PlaceNodeBottomCenter(node as Object, options=invalid as Object)

	xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if
	end if

	boundary = UI_Boundary_Action()
	resolution = UI_Resolution()
	boundingRect = node.boundingRect()
	node.translation = [((resolution.width - boundingRect.width)/2) + xOffset, resolution.height - boundingRect.height - boundary.y + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Screen_PlaceNodeTopRight - Places the node to the top right of the screen
'-------------------------------------------------------------------------------
Sub UI_Screen_PlaceNodeTopRight(node as Object, options=invalid as Object)

	xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if
	end if

	boundary = UI_Boundary_Action()
	resolution = UI_Resolution()
	boundingRect = node.boundingRect()
	node.translation = [(resolution.width - boundingRect.width - boundary.x) + xOffset, boundary.y + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Screen_PlaceNodeTopLeft
'
' @param node Object - the node you would like to position
' @param options Object
'   @param xOffset Integer - move the node via the x axis
'   @param yOffset Integer - mpve the node via the y axis
'   @param offSetBoundary Boolean - by default the node is positioned within
'       the safe areas of the screen accounting for the bezel.  Setting this
'       variable to true will ignore the safe boundaries
'-------------------------------------------------------------------------------
Sub UI_Screen_PlaceNodeTopLeft(node as Object, options=invalid as Object)

	boundary = UI_Boundary_Action()
	
	xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if

		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if

		if options.offSetBoundary <> invalid AND options.offSetBoundary

			xOffset = -(boundary.x)
			yOffset = -(boundary.y)
		end if
	end if

	node.translation = [boundary.x + xOffset, boundary.y + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Screen_PlaceNodeCenter - Places the node to the center of the screen
'-------------------------------------------------------------------------------
Sub UI_Screen_PlaceNodeCenter(node as Object, options=invalid as Object)

	yOffset = 0
	xOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if
		
		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if
	end if

	resolution = UI_Resolution()
	boundingRect = node.boundingRect()
	node.translation = [((resolution.width - boundingRect.width)/2) + xOffset, ((resolution.height - boundingRect.height)/2) + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Screen_PlaceNodeTopCenter - Places the node to the top center of the screen
'-------------------------------------------------------------------------------
Sub UI_Screen_PlaceNodeTopCenter(node as Object, options=invalid as Object)

	xOffset = 0
	yOffset = 0
	if options <> invalid

		if options.xOffset <> invalid

			xOffset = options.xOffset
		end if
		
		if options.yOffset <> invalid

			yOffset = options.yOffset
		end if
	end if

	boundary = UI_Boundary_Action()
	resolution = UI_Resolution()
	boundingRect = node.boundingRect()
	node.translation = [((resolution.width - boundingRect.width)/2) + xOffset, boundary.y + yOffset]
End Sub

'-------------------------------------------------------------------------------
' UI_Screen_Center - Returns the cordinates for the center of the screen
'-------------------------------------------------------------------------------
Function UI_Screen_Center(width as Integer, height as Integer) as Object

	resolution = UI_Resolution()
	return {
		x:(resolution.width - width)/2,
		y:(resolution.height - height)/2
	}
End Function

'-------------------------------------------------------------------------------
' UI_Screen_Bottom - Returns the y position of the bottom of the screen
'-------------------------------------------------------------------------------
Function UI_Screen_Bottom() as Object

	boundary = UI_Boundary_Action()
	return UI_Resolution().height - boundary.y
End Function
