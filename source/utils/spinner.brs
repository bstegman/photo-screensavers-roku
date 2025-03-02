'-------------------------------------------------------------------------------
' Utils_Spinner_Show
'-------------------------------------------------------------------------------
Sub Utils_Spinner_Show()

    if TYPE_isValid(m.spinner)

        m.spinner.control = "start"
        m.spinner.visible = true
    end if
End Sub

'-------------------------------------------------------------------------------
' Utils_Spinner_Hide
'-------------------------------------------------------------------------------
Sub Utils_Spinner_Hide()

    if TYPE_isValid(m.spinner)
        
        m.spinner.control = "stop"
        m.spinner.visible = false
    end if
End Sub