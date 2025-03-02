' Stegman Company LLC.  V1.0

'-------------------------------------------------------------------------------
' KeyManager
'-------------------------------------------------------------------------------
Function KeyManager(keyCombos as Object) as Object

	return {
		keyCombo:keyCombos.join(""),
		keys:[],
		lastkeyEvent:CreateObject("roTimespan"),
		matches:Function(key as String) as Boolean

			' if the user hasn't pressed any keys in a while or if we've logged more 
			' keys then necessary then empty and start over
			if m.lastkeyEvent.TotalSeconds() >= 2 or m.keys.Count() > 100

				m.keys = []
			end if

			m.lastkeyEvent.Mark()
			m.keys.push(key)

			return m.keys.join("") = m.keyCombo
		End Function
	}
End Function
