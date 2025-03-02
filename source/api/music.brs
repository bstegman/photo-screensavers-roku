'-------------------------------------------------------------------------------
' API_Music_Genres
'-------------------------------------------------------------------------------
Sub API_Music_Genres(callback)

	request = Utils_API_PrepHttp()
	request.requestId = "music-genres"
	request.url = "/v1/ua/powertv/music/genres"

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_Music_GenreSongs
'-------------------------------------------------------------------------------
Sub API_Music_GenreSongs(callback, genre)

	request = Utils_API_PrepHttp()
	request.requestId = "music-genre-songs"
	request.url = "/v1/ua/powertv/music/genres/" + genre + "/songs"

    API_Utils_SendRequest(callback, request)
End Sub

'-------------------------------------------------------------------------------
' API_Music_SignUrl
'-------------------------------------------------------------------------------
Sub API_Music_SignUrl(callback, file)

	request = Utils_API_PrepHttp()
	request.requestId = "music-"
	request.type = "POST"
	request.url = "/v1/ua/powertv/cloudfront/signurl"
	request.params = "file=" + file

    API_Utils_SendRequest(callback, request)
End Sub
