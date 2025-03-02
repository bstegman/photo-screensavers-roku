'-------------------------------------------------------------------------------
' API_Collections_Get
'-------------------------------------------------------------------------------
Sub API_Collections_Get(callback, context=invalid as Object)

	request = Utils_API_PrepHttp()
	request.requestId = "collections-get"
	request.url = "/v1/ua/powertv/collections"
	request.context = context

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_Collections_GetPhotosForIds
'-------------------------------------------------------------------------------
Sub API_Collections_GetPhotosForIds(callback, collectionIds as String)

	request = Utils_API_PrepHttp()
	request.requestId = "collections-getallforids"
	request.url = "/v1/ua/powertv/collections/photos"
	request.params = "ids=" + collectionIds

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_Collections_GetS3PhotosForIds
'-------------------------------------------------------------------------------
Sub API_Collections_GetS3PhotosForIds(callback, collectionIds as String)

	request = Utils_API_PrepHttp()
	request.requestId = "collections-getallforids"
	request.url = "/v1/ua/powertv/collections/photos/s3"
	request.params = "ids=" + collectionIds

    API_Utils_SendRequest(callback, request)
End Sub
