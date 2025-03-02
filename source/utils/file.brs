'-------------------------------------------------------------------------------
' Utils_File_IsVideo
'-------------------------------------------------------------------------------
Function Utils_File_IsVideo(filename as String) as Boolean

    ext = Right(filename, 4)
    return ext = ".mp4" OR ext = ".mov" OR ext = ".m4v"
End Function

'-------------------------------------------------------------------------------
' Utils_File_IsPhoto
'-------------------------------------------------------------------------------
Function Utils_File_IsPhoto(filename as String) as Boolean

    return Right(filename, 5) = ".jpeg" OR Right(filename, 4) = ".jpg"
End Function

'-------------------------------------------------------------------------------
' Utils_File_IsJson
'-------------------------------------------------------------------------------
Function Utils_File_IsJson(filename as String) as Boolean

    return Right(filename, 5) = ".json"
End Function

'-------------------------------------------------------------------------------
' Utils_File_isPhotoToLarge
'-------------------------------------------------------------------------------
Function Utils_File_isPhotoToLarge(filesize as Integer) as Boolean

    return filesize > 2000000 ' 2 megs
End Function

'-------------------------------------------------------------------------------
' Utils_File_GetFilename
'-------------------------------------------------------------------------------
Function Utils_File_GetFilename(path as String) as String

    filename = ""
    
    fileAry = path.split("/")
    if fileAry.Count() > 0

        filename = fileAry[fileAry.Count() - 1]
    end if

    return filename
End function