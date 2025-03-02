'-------------------------------------------------------------------------------
' initFonts
'-------------------------------------------------------------------------------
Function initFonts() as Object

	fonts = {
		text:{},
		iconsMap:{}
	}

    sizes = [28, 30, 32, 36, 38, 40, 50]
    for each size in sizes

        avenirBlack  = CreateObject("roSGNode", "Font")
	    avenirBlack.uri = "pkg:/assets/fonts/Avenir-Black-03.ttf"
        avenirBlack.size = size
        fonts.text["avenirBlack" + size.toStr()] = avenirBlack
	end for

	return fonts
End Function
