' Stegman Company LLC.  V1.0

'-------------------------------------------------------------------------------
' Utils_Log
'-------------------------------------------------------------------------------
Sub Utils_Log(message as String, params=invalid as Object)

    TRY

        ' it can be expensive to keep calling m.global so we cache it and reuse it
        if m.__loggingEnabled = invalid

            m.__loggingEnabled = m.global.loggingEnabled
        end if

        if m.__loggingEnabled

                dt = CreateObject("roDateTime")
                dt.ToLocalTime()

                ' month
                mt = dt.getMonth().toStr()
                if mt.Len() = 1

                    mt = "0" + mt
                end if

                ' day
                d = dt.GetDayOfMonth().toStr()
                if d.Len() = 1

                    d = "0" + d
                end if

                ' minutes
                min = dt.GetMinutes().toStr()
                if min.Len() = 1

                    min = "0" + min
                end if

                component = ""
                if m <> invalid AND m.top <> invalid

                    component = m.top.subtype()
                end if

                if params <> invalid

                    for i=0 to params.Count() - 1

                        message = message.Replace("{" + i.toStr() + "}", TYPE_toString(params[i]))
                    end for
                end if

                dtStr = mt + "-" + d + " " + dt.GetHours().toStr() + ":" + min + ":" + dt.GetSeconds().toStr()
                print "LOG1: " + dtStr + ": " + component + ": " + message
        end if

    CATCH e
        ' error
        print e
    END TRY
End Sub
