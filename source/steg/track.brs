' Stegman Company LLC v2.1

'-------------------------------------------------------------------------------
' Track_Page_Init
'
' @description - Initializes the track page object
'-------------------------------------------------------------------------------
Sub Track_Page_Init(numItems as Integer, itemsPerPage as Integer)

    ' subsctract one so it can be used with zero based
    numItems--
    itemsPerPage--

    m.__trackPage = {
        numItems:numItems,
        itemsPerPage:itemsPerPage,
        startIdx:0,
        endIdx:0
    }
    ' print ">>> ";m.__trackPage
End Sub

'-------------------------------------------------------------------------------
' Track_Page_GetNext
'-------------------------------------------------------------------------------
Function Track_Page_GetNext() as Object

    track = m.__trackPage
    
    result = {
        startIdx:0,
        endIdx:0
    }

    if track.endIdx = 0

        result.endIdx = track.itemsPerPage
        if result.endIdx > track.numItems

            result.endIdx = track.numItems
        end if
        
        m.__trackPage.endIdx = result.endIdx
    else

        result.startIdx = track.endIdx + 1
        if result.startIdx > track.numItems

            result.startIdx = 0
            result.endIdx = track.itemsPerPage
            if result.endIdx > track.numItems

                result.endIdx = track.numItems
            end if
        else

            result.endIdx = result.startIdx + track.itemsPerPage
            if result.endIdx > track.numItems

                result.endIdx = result.startIdx + (track.numItems - result.startIdx)
            end if
        end if
        
        m.__trackPage.startIdx = result.startIdx
        m.__trackPage.endIdx = result.endIdx
    end if

    ' print result
    return result
End Function

'-------------------------------------------------------------------------------
' Track_Init
'
' @description - Initializes the track object
' @param stepType String - How to determine the next index (idx)
' possible values:
'           randomAll - This will randomly go through all the items in the array
'                       while ensuring each item is seen
'           random    - This will randomly go through all the items but items
'                       may be repeated
'           increment - This will go through each item one by one
' @param numItems Integer - The number of items you want to track
' @param curidx Integer - Set the index to start with minus 1 since the code is
' going to increment to the next index.  For example, if you want to start with 0
' you would provide -1
'-------------------------------------------------------------------------------
Sub Track_Init(stepType as String, numItems as Integer, curIdx=-1 as Integer)

    numItems--

    m.__track = {
        stepType:stepType,
        numItems:numItems
    }

    if stepType = "randomAll"

        idxsAry = []
        for i=0 to numItems

            idxsAry.Push(i)
        end for
        m.__track.idxsAry = idxsAry
    else if stepType = "increment"

        m.__track.curIdx = curIdx
    end if
End Sub

'-------------------------------------------------------------------------------
' Track_GetPrevIdx
'-------------------------------------------------------------------------------
Function Track_GetPrevIdx() as Integer

    idx = -1
    if TYPE_isValid(m.__track)

        if m.__track.stepType = "increment"

            idx = _Track_Get_Decrement()
        end if
    end if

    return idx
End Function

'-------------------------------------------------------------------------------
' Track_GetNextIdx
'-------------------------------------------------------------------------------
Function Track_GetNextIdx() as Integer

    idx = -1
    if TYPE_isValid(m.__track)

        if m.__track.stepType = "randomAll"

            idx = _Track_Get_RandomAll()
        else if m.__track.stepType = "random"

            idx = _Track_Get_Random()
        else if m.__track.stepType = "increment"

            idx = _Track_Get_Increment()
        end if
    end if

    return idx
End Function

'-------------------------------------------------------------------------------
' _Track_Get_RandomAll
'-------------------------------------------------------------------------------
Function _Track_Get_RandomAll() as Integer

    idxsAry = m.__track.idxsAry
    aryIdx = MATH_Random(0, idxsAry.Count() - 1)

    idx = idxsAry[aryIdx]

    idxsAry.Delete(aryIdx)
    if idxsAry.Count() = 0

        idxsAry = []
        for i=0 to m.__track.numItems

            idxsAry.Push(i)
        end for
    end if
    m.__track.idxsAry = idxsAry

    return idx
End Function

'-------------------------------------------------------------------------------
' _Track_Get_Random
'-------------------------------------------------------------------------------
Function _Track_Get_Random() as Integer

    idx = MATH_Random(0, m.__track.numItems)

    ' make sure we don't use the existing idx
    if TYPE_isInteger(m.__track.lastIndex) AND idx = m.__track.lastIndex

        if idx + 1 <= m.__track.numItems

            idx++
        else if idx - 1 >= 0

            idx--
        end if
    end if

    m.__track.lastIndex = idx
    return idx
End Function

'-------------------------------------------------------------------------------
' _Track_Get_Decrement
'-------------------------------------------------------------------------------
Function _Track_Get_Decrement() as Integer

    idx = m.__track.curIdx
    if idx - 1 > 0

        idx = idx - 1
    else

        idx = 0
    end if
    m.__track.curIdx = idx
    return idx
End Function

'-------------------------------------------------------------------------------
' _Track_Get_Increment
'-------------------------------------------------------------------------------
Function _Track_Get_Increment() as Integer

    idx = m.__track.curIdx
    if idx + 1 <= m.__track.numItems

        idx = idx + 1
    else

        idx = 0
    end if
    m.__track.curIdx = idx
    return idx
End Function