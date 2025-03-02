' Stegman Company LLC.  V3.0

Sub init()

	m.top.functionName = "startListener"

	m.port = createObject("roMessagePort")
	m.top.observeField("request", m.port)
End Sub

Sub startListener()

	while true
		msg = wait(0, m.port)
		msgType = type(msg)
		if msgType = "roSGNodeEvent" AND msg.getField() = "request"

			request = msg.getData()
			response = invalid
			if request.action = "SaveItem"

				success = Registry_SaveItem(request.section, request.key, request.value)
				response = {
					action:request.action,
					section:request.section,
					key:request.key,
					value:request.value,
					success:success
				}
			else if request.action = "GetItem"

				value = Registry_GetItem(request.section, request.key)
				response = {
					action:request.action,
					section:request.section,
					key:request.key,
					value:value
				}
			else if request.action = "DeleteItem"

				Registry_DeleteItem(request.section, request.key)
				response = {
					action:request.action,
					section:request.section,
					key:request.key
				}
            else if request.action = "SaveSection"

				success = Registry_SaveSection(request.section, request.value)
				response = {
					action:request.action,
					section:request.section,
					value:request.value,
					success:success
				}
            else if request.action = "GetSection"

				value = Registry_GetSection(request.section)

				response = {
					action:request.action,
					section:request.section,
					value:value
				}
			else if request.action = "DeleteSection"

				success = Registry_DeleteSection(request.section)
				response = {
					action:request.action,
					section:request.section,
					success:success
				}
			else if request.action = "Get"

				response = {
					action:request.action,
					registry:Registry_Get()
				}
			else if request.action = "Print"

				Registry_Print()
				response = {
					action:request.action,
					success:true
				}
			else if request.action = "Empty"

				Registry_Empty()
				response = {
					action:request.action,
					completed:true
				}
			end if

            if request.requestId <> invalid

                response.requestId = request.requestId
            end if

            if request.log <> invalid AND request.log

                print "request: ";request
                print "response: ";response
                print "response value: ";response.value
            end if

            if request.print <> invalid AND request.print

                Registry_Print()
            end if

			response.context = request.context
            m.top.setField("response", response)
		end if
	end while
End Sub
