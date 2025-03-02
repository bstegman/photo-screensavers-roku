' Stegman Company LLC v1.1

'-------------------------------------------------------------------------------
' Steg_Api_Google_Photos_Get
'
' @description - gets the users media items
'-------------------------------------------------------------------------------
Sub Steg_Api_Google_Photos_Get(callback, token as String)

    request = {
        headers:{
            "Content-Type":"application/json",
            "Authorization":"Bearer " + token
        },
        type:"GET",
        hostUrl:"https://photoslibrary.googleapis.com/v1/mediaItems",
        requestId:"google-photos-get-items",
        validate:true,
        log:false,
        params:"pageSize=100",
        converResponseToNode:""
    }

    API_Utils_SendRequest(callback, request)
End Sub

