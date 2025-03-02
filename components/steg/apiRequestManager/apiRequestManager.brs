' Stegman Company LLC.  V2.2

'-------------------------------------------------------------------------------
' init
'-------------------------------------------------------------------------------
Sub init()

	m.top.functionName = "startListener"
	m.port = createObject("roMessagePort")
	m.top.ObserveFieldScoped("request", m.port)

	m.timerCleanup = m.top.findNode("timerCleanup")
	m.timerCleanup.ObserveFieldScoped("fire", m.port)

	m.pendingTransfers = {}
	m.pool = []
End Sub

'-------------------------------------------------------------------------------
' startListener
'-------------------------------------------------------------------------------
Sub startListener()

    createPool()

	while true

		msg = wait(0, m.port)
		msgType = type(msg)

		if msgType = "roSGNodeEvent"

			if msg.getField() = "request"

				request = msg.GetData()

				urlTransfer = getFromPool()
				if urlTransfer <> invalid

					sendRequest(urlTransfer, request)
				else

					if request.log <> invalid and request.log

						print "adding a UrlTransfer object to the pool!"
					end if
					urlTransfer = createConnectionAndAddToPool()
					sendRequest(urlTransfer, request)

					if m.timerCleanup.control = "stop"

						m.timerCleanup.control = "start"
					end if
				end if
			else if msg.getNode() = "timerCleanup"

				cleanupExcessConnections()
			end if
		else if msgType = "roUrlEvent"

			requestId = msg.GetSourceIdentity().ToStr()
			userRequest = m.pendingTransfers[requestId]
			if userRequest.requestId <> invalid

				responseHeaders = msg.GetResponseHeadersArray()
				contentType = ""
				for each key in responseHeaders

					value = key.Lookup("Content-Type")
					if value <> invalid

						contentType = value
					end if
				end for

				responseProcessed = invalid
				responseStr = msg.GetString()

				' process response
				if responseStr <> invalid and responseStr <> ""

					if contentType.Instr("application/json") <> -1
						
						responseProcessed = ParseJson(responseStr)
					else if contentType.Instr("text/xml") <> -1

						responseProcessed = responseStr
					else

						responseProcessed = responseStr
					end if

					if userRequest.convertResponseToNode <> invalid AND userRequest.convertResponseToNode <> ""

						node = CreateObject("roSGNode", userRequest.convertResponseToNode)
						if node <> invalid
							
							node.update(responseProcessed, true)
							responseProcessed = node
						end if
					end if
				end if

				response = {
                    context:userRequest.context,
					requestId:userRequest.requestId,
					data:responseProcessed,
					httpResponse:{
						code:msg.GetResponseCode()
						success:false
					}
				}

				if response.httpResponse.code >= 200 and response.httpResponse.code < 300

					response.httpResponse.success = true
				else

					m.top.responseErrorCode = response.httpResponse.code
				end if

				m.top.setField("response", response)
		  		m.pendingTransfers.Delete(requestId)

				if request.log <> invalid and request.log

					print ">>> response (" + msg.GetSourceIdentity().toStr() + ")"
					' print "responseHeaders: ";responseHeaders
					print "response: ";response
					print "response httpResponse: ";response.httpResponse
				end if
			end if
		end if
	end while
End Sub

'-------------------------------------------------------------------------------
' createPool
'-------------------------------------------------------------------------------
Sub createPool()

	for i=0 to m.top.poolSize - 1

		urlTransfer = createConnection()
		m.pool.Push(urlTransfer)
	end for
End Sub

'-------------------------------------------------------------------------------
' getFromPool
'-------------------------------------------------------------------------------
Function getFromPool() as Object

	urlTransfer = invalid
	for each urlTransferPool in m.pool

		if m.pendingTransfers[urlTransferPool.GetIdentity().toStr()] = invalid

			urlTransfer = urlTransferPool
			exit for
		end if
	end for
	return urlTransfer
End Function

'-------------------------------------------------------------------------------
' createConnectionAndAddToPool
'-------------------------------------------------------------------------------
Function createConnectionAndAddToPool() as Object

	urlTransfer = createConnection()
	m.pool.Push(urlTransfer)
	return urlTransfer
End Function

'-------------------------------------------------------------------------------
' createConnection
'-------------------------------------------------------------------------------
Function createConnection() as Object

	urlTransfer = CreateObject("roUrlTransfer")
	urlTransfer.setMessagePort(m.port)
	urlTransfer.SetCertificatesFile(m.top.certificatesFile)
	urlTransfer.InitClientCertificates()
    urlTransfer.RetainBodyOnError(true)

    if m.top.httpVersion <> invalid AND m.top.httpVersion <> ""

        urlTransfer.SetHttpVersion(m.top.httpVersion)
    end if

	return urlTransfer
End Function

'-------------------------------------------------------------------------------
' sendRequest
'-------------------------------------------------------------------------------
Sub sendRequest(urlTransfer as Object, request as Object)

	if request.certificatesFile <> invalid

		urlTransfer.SetCertificatesFile(request.certificatesFile)
	else

		urlTransfer.SetCertificatesFile(m.top.certificatesFile)
	end if

	if request.requestId = invalid OR request.requestId = ""

		request.requestId = "request-" + Mid(RND(0).toStr(), 3)
	end if

	if request.type = invalid

		request.type = "GET"
	end if

	if request.params = invalid

		request.params = ""
	end if

	requestId = urlTransfer.GetIdentity().ToStr()
	m.pendingTransfers[requestId] = request

	if request.headers = invalid

		request.headers = {}
	end if
	urlTransfer.SetHeaders(request.headers)

	validateHttp = true
	if request.validate <> invalid and request.validate = false

		validateHttp = false
	end if

	urlTransfer.EnablePeerVerification(validateHttp)
	urlTransfer.EnableHostVerification(validateHttp)
    urlTransfer.SetRequest(request.type)

	url = ""
	if request.hostUrl <> invalid

		url = request.hostUrl
	else

		url = request.host + request.url
	end if

	if request.type = "POST" OR request.type = "PUT" OR request.type = "DELETE"

		urlTransfer.setUrl(url)
		urlTransfer.asyncPostFromString(request.params)
	else if request.type = "GET"

		getUrl = url
		if request.params <> invalid and request.params <> ""

			getUrl = getUrl + "?" + request.params
		end if

		urlTransfer.setUrl(getUrl)
		urlTransfer.asyncGetToString()
	end if

	if request.log <> invalid and request.log

		print "<<< request (" + requestId + ") ";request
	end if
End Sub

'-------------------------------------------------------------------------------
' cleanupExcessConnections
'-------------------------------------------------------------------------------
Sub cleanupExcessConnections()

	for i=m.pool.Count() - 1 to m.top.poolSize step -1

		requestId = m.pool[i].GetIdentity().ToStr()
		if m.pendingTransfers[requestId] = invalid

			m.pool[i] = invalid
			m.pool.Delete(i)
		end if
	end for

	if m.pool.Count() > m.top.poolSize and m.timerCleanup.control = "stop"

		m.timerCleanup.control = "start"
	end if
End Sub
