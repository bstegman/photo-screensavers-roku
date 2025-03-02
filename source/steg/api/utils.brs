' Stegman Company LLC v3.0

'-------------------------------------------------------------------------------
' API_Utils_Response_isSuccess
'
' @description - Helper function that validates if a response is successful
'-------------------------------------------------------------------------------
Function API_Utils_Response_isSuccess(response as Dynamic) AS Boolean

    success = false
    
    if TYPE_isValid(response) 
        
        ' test for valid http response
        if (TYPE_isValid(response.httpResponse) AND TYPE_isBoolean(response.httpResponse.success) AND response.httpResponse.success)

            ' test the response data type is anything other than an associate array or 
            ' if it is and there isn't an error or errors object on the response data object
            if ( (NOT TYPE_isAssocArray(response.data)) OR (NOT TYPE_isValid(response.data.error) AND NOT TYPE_isValid(response.data.errors)) )

                success = true
            end if
        end if
    end if
    
    return success
End Function

'-------------------------------------------------------------------------------
' API_Utils_SendRequest
'
' @description - Helper function that allows you to make api requests with a callback
'-------------------------------------------------------------------------------
Sub API_Utils_SendRequest(callback as Object, request as Object)

	if m.__apiRequests = invalid

		API_Utils_SendRequest_Initialize()
	end if

	if m.apiRequestManager <> invalid

        request.requestId = request.requestId + "-" + Mid(RND(0).toStr(), 3)
		if callback <> invalid

			m.__apiRequests[request.requestId.toStr()] = callback
		end if

		m.apiRequestManager.request = request
	end if
End Sub

'-------------------------------------------------------------------------------
' API_Utils_SendRequest_Cleanup
'
' @description - Helper function that cleans up requests observers
'-------------------------------------------------------------------------------
Sub API_Utils_SendRequest_Cleanup()

	m.apiRequestManager.UnObserveFieldScoped("response")
	m.__apiRequests = invalid
End Sub

'-------------------------------------------------------------------------------
' API_Utils_SendRequest_Initialize
'
' @description - Helper function that initializes the send request env.
'-------------------------------------------------------------------------------
Sub API_Utils_SendRequest_Initialize()

	m.__apiRequests = {}
	m.apiRequestManager.ObserveFieldScoped("response", "__onApiResponse")
End Sub

'-------------------------------------------------------------------------------
' __onApiResponse
'
' @description - Private function used in conjunction with the request function
'-------------------------------------------------------------------------------
Sub __onApiResponse(evt as Object)

	response = evt.getData()
	callback = m.__apiRequests[response.requestId.toStr()]
	if m.__apiRequests <> invalid AND callback <> invalid

		success = m.__apiRequests.Delete(response.requestId.toStr())
		callback(response)
	end if
End Sub

'-------------------------------------------------------------------------------
' API_Utils_GenBadResponseObjectForRequest
'
' @description - Utility for mocking a bad response
'-------------------------------------------------------------------------------
Function API_Utils_GenBadResponseObjectForRequest(requestId as String) as Object

    return  {
            requestId:requestId,
            data:invalid,
            httpResponse:{
                code:400
                success:false
            }
        }
End Function

'-------------------------------------------------------------------------------
' API_Utils_IsErrorWithCode
'-------------------------------------------------------------------------------
Function API_Utils_IsErrorWithCode(response as Object, code as Integer) as Boolean

    return TYPE_isValid(response.data) AND TYPE_isValid(response.data.error) AND response.data.error.code = code
End Function