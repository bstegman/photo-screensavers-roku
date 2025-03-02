'-------------------------------------------------------------------------------
' API_Collections_GetS3PhotosForIds
'-------------------------------------------------------------------------------
Sub API_Collections_GetS3PhotosForIds(callback, collectionIds as String)

	request = Utils_API_PrepHttp()
	request.requestId = "collections-getallforids"
	request.url = "/v1/ua/ssphotos/collections/photos/s3"
	request.params = "ids=" + collectionIds

    API_Utils_SendRequest(callback, request)
End Sub
