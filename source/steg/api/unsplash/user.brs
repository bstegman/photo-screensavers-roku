' Stegman Company LLC v1.1

'-------------------------------------------------------------------------------
' Steg_Api_Unsplash_Me
'-------------------------------------------------------------------------------
Sub Steg_Api_Unsplash_Me(callback, token as String)

    request = {
        headers:{
            "Content-Type":"application/json",
            "Authorization":"Bearer " + token
        },
        type:"GET",
        hostUrl:"https://api.unsplash.com/me",
        requestId:"unsplash-me",
        validate:true,
        log:false,
        converResponseToNode:""
    }

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' Steg_Api_Unsplash_User_Photos
'
' @description - get all the users photos
'-------------------------------------------------------------------------------
Sub Steg_Api_Unsplash_User_Photos(callback, username as String, token as String)

    request = {
        headers:{
            "Content-Type":"application/json",
            "Authorization":"Bearer " + token
        },
        type:"GET",
        hostUrl:"https://api.unsplash.com/users/" + username + "/photos",
        requestId:"unsplash-get-user-photos",
        validate:true,
        log:false,
        params:"per_page=100",
        converResponseToNode:""
    }

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' Steg_Api_Unsplash_TriggerDownload
'
' @description - Unsplash has a requirement to trigger a download for each photo
'-------------------------------------------------------------------------------
Sub Steg_Api_Unsplash_TriggerDownload(callback, token as String, downloadString as String)

    request = {
        headers:{
            "Content-Type":"application/json",
            "Authorization":"Bearer " + token
        },
        type:"GET",
        hostUrl:downloadString,
        requestId:"unsplash-trigger-download",
        validate:true,
        log:false
    }

    API_Utils_SendRequest(callback, request)
End Sub
