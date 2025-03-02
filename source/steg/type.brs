' Stegman Company LLC v1.21

'-------------------------------------------------------------------------------
' TYPE_isValid
'-------------------------------------------------------------------------------
Function TYPE_isValid(value as Dynamic) as Boolean

    ' this is constructed like this because of <UNINITIALIZED>
	valid = true

    if type(value) = "<uninitialized>"

        valid = false
    else if value = invalid

        valid = false
    end if

    return valid
End Function

'-------------------------------------------------------------------------------
' TYPE_isValidPath
'-------------------------------------------------------------------------------
Function TYPE_isValidPath(value as String, obj as Object) as Boolean

    valid = true

    if NOT TYPE_isValid(obj)

        valid = false
    else

        curObj = obj
        valAry = value.Split(".")

        ct = valAry.Count() - 1
        for i=0 to ct

            curVal = valAry[i]

            if i = ct

                if NOT TYPE_isValid(curObj[curVal])

                    valid = false
                    exit for
                end if
            else

                if NOT TYPE_isAssocArray(curObj[curVal])

                    valid = false
                    exit for
                end if

                curObj = curObj[curVal]
            end if
        end for
    end if

    return valid
End Function

'-------------------------------------------------------------------------------
' TYPE_isXMLElement
'-------------------------------------------------------------------------------
Function TYPE_isXMLElement(value as Dynamic) as Boolean

	return TYPE_isValid(value) AND GetInterface(value, "ifXMLElement") <> invalid
End Function

'-------------------------------------------------------------------------------
' TYPE_isFunction
'-------------------------------------------------------------------------------
Function TYPE_isFunction(value as Dynamic) as Boolean

	return TYPE_isValid(value) AND GetInterface(value, "ifFunction") <> invalid
End Function

'-------------------------------------------------------------------------------
' TYPE_isBoolean
'-------------------------------------------------------------------------------
Function TYPE_isBoolean(value as Dynamic) as Boolean

	return TYPE_isValid(value) AND GetInterface(value, "ifBoolean") <> invalid
End Function

'-------------------------------------------------------------------------------
' TYPE_isBooleanEqualTo
'-------------------------------------------------------------------------------
Function TYPE_isBooleanEqualTo(value as Dynamic, _toBoolean) as Boolean

	return TYPE_isValid(value) AND GetInterface(value, "ifBoolean") <> invalid AND value = _toBoolean
End Function

'-------------------------------------------------------------------------------
' TYPE_isInteger
'-------------------------------------------------------------------------------
Function TYPE_isInteger(value as Dynamic) as Boolean

	return TYPE_isValid(value) AND GetInterface(value, "ifInt") <> invalid AND (type(value) = "roInt" OR type(value) = "roInteger" OR type(value) = "Integer")
End Function

'-------------------------------------------------------------------------------
' TYPE_isFloat
'-------------------------------------------------------------------------------
Function TYPE_isFloat(value as Dynamic) as Boolean

	return TYPE_isValid(value) AND (GetInterface(value, "ifFloat") <> invalid OR (type(value) = "roFloat" OR type(value) = "Float"))
End Function

'-------------------------------------------------------------------------------
' TYPE_isDouble
'-------------------------------------------------------------------------------
Function TYPE_isDouble(value as Dynamic) as Boolean

	return TYPE_isValid(value) AND ((type(value) = "Double" OR type(value) = "roDouble" OR type(value) = "roIntrinsicDouble") OR GetInterface(value, "ifDouble") <> invalid)
End Function

'-------------------------------------------------------------------------------
' TYPE_isArray
'-------------------------------------------------------------------------------
Function TYPE_isArray(value as Dynamic) as Boolean

	return TYPE_isValid(value) AND GetInterface(value, "ifArray") <> invalid
End Function

'-------------------------------------------------------------------------------
' TYPE_isInArray
'-------------------------------------------------------------------------------
Function TYPE_isInArray(ary as Object, value as Dynamic, checkType=true as Boolean) as Boolean

	found = false

    for i=0 to ary.Count() - 1

        item = ary[i]
        if (checkType AND type(item) = type(value) AND item = value) OR (NOT checkType AND item = value)

            found = true
            exit for
        end if
    end for

    return found
End Function

'-------------------------------------------------------------------------------
' TYPE_isArrayInArray
'
' @aray1 - values to check if they exist in ary2
' @aray2 - the array to check if values exist in it
'-------------------------------------------------------------------------------
Function TYPE_isArrayInArray(ary1 as Object, ary2 as Object) as Boolean

	found = false

    for i=0 to ary1.Count() - 1

        for j=0 to ary2.Count() - 1

            if ary1[i] = ary2[j]

                found = true
                exit for
            end if
        end for

        if found

            exit for
        end if
    end for

    return found
End Function

'-------------------------------------------------------------------------------
' TYPE_isArrayEmpty
' Note: invalid is treated as empty therefore returns true
'-------------------------------------------------------------------------------
Function TYPE_isArrayEmpty(value as Dynamic) as Boolean

	return ( NOT TYPE_isValid(value) OR (TYPE_isArray(value) AND value.Count() = 0) )
End Function

'-------------------------------------------------------------------------------
' TYPE_isArrayWithLength
'-------------------------------------------------------------------------------
Function TYPE_isArrayWithLength(value as Dynamic, ct as Integer) as Boolean

	return TYPE_isArray(value) AND value.Count() = ct
End Function

'-------------------------------------------------------------------------------
' TYPE_isAssocArray
'-------------------------------------------------------------------------------
Function TYPE_isAssocArray(value as Dynamic) as Boolean

	return TYPE_isValid(value) AND GetInterface(value, "ifAssociativeArray") <> invalid
End Function

'-------------------------------------------------------------------------------
' TYPE_isAssocArrayEmpty
' Note: invalid is treated as empty therefore returns true
'-------------------------------------------------------------------------------
Function TYPE_isAssocArrayEmpty(value as Dynamic) as Boolean

	return ( NOT TYPE_isValid(value) OR (TYPE_isAssocArray(value) AND value.Count()) ) = 0
End Function

'-------------------------------------------------------------------------------
' TYPE_isInAssocArray
'-------------------------------------------------------------------------------
Function TYPE_isInAssocArray(assocAry as Object, value as Dynamic) as Boolean

    return TYPE_isValid(assocAry[value])
End Function

'-------------------------------------------------------------------------------
' TYPE_isNode
'-------------------------------------------------------------------------------
Function TYPE_isNode(value as Dynamic) as Boolean

	return TYPE_isValid(value) AND type(value) = "roSGNode"
End Function

'-------------------------------------------------------------------------------
' TYPE_isNodeSubType
'-------------------------------------------------------------------------------
Function TYPE_isNodeSubType(value as Dynamic, nodeName as String) as Boolean

	isNode = TYPE_isValid(value) AND type(value) = "roSGNode"
    if isNode

        isNode = value.subtype() = nodeName
    end if
    return isNode
End Function

'-------------------------------------------------------------------------------
' TYPE_isString
'-------------------------------------------------------------------------------
Function TYPE_isString(value as Dynamic) as Boolean

	return TYPE_isValid(value) AND GetInterface(value, "ifString") <> invalid
End Function

'-------------------------------------------------------------------------------
' TYPE_isStringEmpty
'-------------------------------------------------------------------------------
Function TYPE_isStringEmpty(value as Dynamic) as Boolean

	return TYPE_isString(value) AND value = ""
End Function

'-------------------------------------------------------------------------------
' TYPE_isStringEqualTo
'-------------------------------------------------------------------------------
Function TYPE_isStringEqualTo(value as Dynamic, _toString as String) as Boolean

	return TYPE_isString(value) AND value = _toString
End Function

'-------------------------------------------------------------------------------
' TYPE_toFloat
'-------------------------------------------------------------------------------
Function TYPE_toFloat(value, default=0.0 as Float) as Float

    if TYPE_isString(value)

        value = value.toFloat()
    else if NOT TYPE_isFloat(value)

        value = default
    end if

    return value
End Function

'-------------------------------------------------------------------------------
' TYPE_toInteger
'-------------------------------------------------------------------------------
Function TYPE_toInteger(value, default=0 as Integer) as Integer

    if TYPE_isString(value)

        value = value.toInt()
    else if NOT TYPE_isInteger(value)

        value = default
    end if

    return value
End Function

'-------------------------------------------------------------------------------
' TYPE_toString
'-------------------------------------------------------------------------------
Function TYPE_toString(value, default="" as String) as String

    if TYPE_isInteger(value) OR TYPE_isBoolean(value) OR TYPE_isFloat(value) OR TYPE_isDouble(value)

        value = value.toStr()
    else if NOT TYPE_isString(value)

        value = default
    end if

    return value
End Function

'-------------------------------------------------------------------------------
' TYPE_toBoolean
'-------------------------------------------------------------------------------
Function TYPE_toBoolean(value) as Boolean

    if NOT TYPE_isBoolean(value)

        value = TYPE_isStringEqualTo(value, "true")
    end if

    return value
End Function

'-------------------------------------------------------------------------------
' TYPE_stringUCaseFirstLetter
'-------------------------------------------------------------------------------
Function TYPE_stringUCaseFirstLetter(value) as String

    firstLeter = UCase(Left(value, 1))
    endString = Mid(value, 2, value.Len())
    return firstLeter + endString
End Function