' Stegman Company LLC.  V2.6

'-------------------------------------------------------------------------------
' Registry_SaveItem
'-------------------------------------------------------------------------------
Function Registry_SaveItem(section as string, key as string, value as string) as Boolean

    regSection = CreateObject("roRegistrySection", section)
    regSection.Write(key, value)
    return regSection.Flush()
End Function

'-------------------------------------------------------------------------------
' Registry_GetItem
'-------------------------------------------------------------------------------
Function Registry_GetItem(section as string, key as string) as Dynamic

    value = invalid
    regSection = CreateObject("roRegistrySection", section)
    if regSection.Exists(key)

         value = regSection.Read(key)
     end if
    return value
End Function

'-------------------------------------------------------------------------------
' Registry_DeleteItem
'-------------------------------------------------------------------------------
Function Registry_DeleteItem(section as String, key as String) as Boolean

    RegistrySection = CreateObject("roRegistrySection", section)
    RegistrySection.Delete(key)
    return RegistrySection.Flush()
End Function

'-------------------------------------------------------------------------------
' Registry_Get
'-------------------------------------------------------------------------------
Function Registry_Get() as Object

	regObj = {}
	Registry = CreateObject("roRegistry")
	for each section in Registry.GetSectionList()

		  regObj[section] = {
				vals:{}
		  }
		  RegistrySection = CreateObject("roRegistrySection", section)
		  for each key in RegistrySection.GetKeyList()

				regObj[section].vals[key] = RegistrySection.Read(key)
		  end for
		end for
		return regObj
End Function

'-------------------------------------------------------------------------------
' Registry_GetSection
'-------------------------------------------------------------------------------
Function Registry_GetSection(section as String) as Object

	regSection = CreateObject("roRegistrySection", section)
    return regSection.ReadMulti(regSection.GetKeyList())
End Function

'-------------------------------------------------------------------------------
' Registry_SaveSection
'-------------------------------------------------------------------------------
Function Registry_SaveSection(sectionName as string, sectionObj as Object) as Boolean

    regSection = CreateObject("roRegistrySection", sectionName)
    success = regSection.WriteMulti(sectionObj)
    regSection.Flush()
    return success
End Function

'-------------------------------------------------------------------------------
' Registry_DeleteSection
'-------------------------------------------------------------------------------
Function Registry_DeleteSection(section) as Boolean

    RegistrySection = CreateObject("roRegistrySection", section)
    for each key in RegistrySection.GetKeyList()

        RegistrySection.Delete(key)
    end for
    return RegistrySection.Flush()
End Function

'-------------------------------------------------------------------------------
' Registry_Print
'-------------------------------------------------------------------------------
Sub Registry_Print()

    Registry = CreateObject("roRegistry")
    print "### number of registry sections: " + Registry.GetSectionList().Count().toStr() + " ###"
    for each section in Registry.GetSectionList()

        print "--- registry section: " + section + " ---"
        RegistrySection = CreateObject("roRegistrySection", section)
        for each key in RegistrySection.GetKeyList()

            print key + ":" + RegistrySection.Read(key)
        end for
    end for
End Sub

'-------------------------------------------------------------------------------
' Registry_Empty
'-------------------------------------------------------------------------------
Sub Registry_Empty()

    print "Start Empty Registry"
    Registry = CreateObject("roRegistry")
    i = 0
    for each section in Registry.GetSectionList()

        RegistrySection = CreateObject("roRegistrySection", section)
        for each key in RegistrySection.GetKeyList()
            i = i+1
            print "Deleting " section + ":" key
            RegistrySection.Delete(key)
        end for
        RegistrySection.flush()
    end for
    print i.toStr() " Registry Keys Deleted"
End Sub

'-------------------------------------------------------------------------------
' Registry_SendRequest
'-------------------------------------------------------------------------------
Sub Registry_SendRequest(callback as Object, request as Object)

	if m.__registryRequests = invalid

		Registry_SendRequest_Initialize()
	end if

	if m.registryManager <> invalid

		if callback <> invalid

			m.__registryRequests[request.requestId.toStr()] = callback
		end if

		m.registryManager.request = request
	end if
End Sub

'-------------------------------------------------------------------------------
' Registry_SendRequest_Initialize
'-------------------------------------------------------------------------------
Sub Registry_SendRequest_Initialize()

	m.__registryRequests = {}
	m.registryManager.ObserveFieldScoped("response", "__onRegistryResponse")
End Sub

'-------------------------------------------------------------------------------
' Registry_GetSpaceAvailable
'-------------------------------------------------------------------------------
Function Registry_GetSpaceAvailable() as Integer

    registry = CreateObject("roRegistry")
    return registry.GetSpaceAvailable()
End Function

'-------------------------------------------------------------------------------
' Registry_GetSize
'
' @description - Returns the size in bytes.  The registry has a maximum size
' of 16k which is bytes/1024
'-------------------------------------------------------------------------------
Function Registry_GetSize() as Integer

    size = 0

    byteArray = CreateObject("roByteArray")
    Registry = CreateObject("roRegistry")
    for each section in Registry.GetSectionList()

        RegistrySection = CreateObject("roRegistrySection", section)
        for each key in RegistrySection.GetKeyList()
            
            byteArray.FromAsciiString(RegistrySection.Read(key))
            size += byteArray.Count()
        end for
    end for
    
    return size
End Function

'-------------------------------------------------------------------------------
' __onRegistryResponse
'-------------------------------------------------------------------------------
Sub __onRegistryResponse(evt as Object)

	response = evt.getData()
	callback = m.__registryRequests[response.requestId.toStr()]
	if m.__registryRequests <> invalid AND callback <> invalid

		m.__registryRequests.Delete(response.requestId.toStr())
		callback(response)
	end if
End Sub
