'-------------------------------------------------------------------------------
' Utils_Screensaver_CollectionIdx
'-------------------------------------------------------------------------------
Function Utils_Screensaver_CollectionIdx(screensaver as Object, collectionId as Integer) as Integer

    idx = -1
    if TYPE_isArray(screensaver)
    
        for i=0 to screensaver.Count() - 1

            if screensaver[i].id = collectionId

                idx = i
                exit for
            end if
        end for
    end if
    return idx
End Function

'-------------------------------------------------------------------------------
' Utils_Screensaver_Get
'-------------------------------------------------------------------------------
Function Utils_Screensaver_Get() as Object

    screensaver = []

    if TYPE_isArray(m.global.screensaver)

        screensaver = m.global.screensaver
    end if

    return screensaver
End Function

'-------------------------------------------------------------------------------
' Utils_Screensaver_Save
'-------------------------------------------------------------------------------
Sub Utils_Screensaver_Save(screensaver as Object)

    if TYPE_isArray(m.global.screensaver)

        m.global.SetField("screensaver", screensaver)
    else

        m.global.AddFields({screensaver:screensaver})
    end if
End Sub

'-------------------------------------------------------------------------------
' Utils_Screensaver_Remove
'-------------------------------------------------------------------------------
Sub Utils_Screensaver_Remove()

    if TYPE_isArray(m.global.screensaver)

        m.global.screensaver = invalid
    end if
End Sub

'-------------------------------------------------------------------------------
' Utils_Screensaver_GetLocalPhotos
'-------------------------------------------------------------------------------
Function Utils_Screensaver_GetLocalPhotos() as object

	photos = []
	for x=1 to 3

		 photos.Push({
			  "id": 0,
			  "isInternal": 1,
			  "isActive": 1,
			  "url": "pkg:/assets/images/photo" + x.toStr() + ".jpg",
			  "urlThumb": "pkg:/assets/images/photo" + x.toStr() + "-thumb.jpg",
			  "name": "",
			  "scaledWidth":1280,
			  "scaledHeight":720
		})
	end for
	return photos
End Function

'-------------------------------------------------------------------------------
' Utils_Screensaver_PhotoGetId
'-------------------------------------------------------------------------------
Function Utils_Screensaver_PhotoGetId(photo as Object) as Integer

    id = 0

    if TYPE_isValid(photo.photoId)

        id = TYPE_toInteger(photo.photoId)
    else if TYPE_isValid(photo.id)

        id = TYPE_toInteger(photo.id)
    end if

    return id
End Function