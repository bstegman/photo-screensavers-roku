' Stegman Company LLC.  V4.0

'-------------------------------------------------------------------------------
' Returns a random integer between minimum and maximum
'-------------------------------------------------------------------------------
Function MATH_Random(min as Integer, max as Integer) as Integer

	rndNum = rnd((max - min) + 1) - 1
	return min + rndNum
End Function

'-------------------------------------------------------------------------------
' MATH_DegreeToRadian
'-------------------------------------------------------------------------------
Function MATH_DegreeToRadian(degree as Float) as Float

	' degree*(pi/180)
	return degree*(3.14159265359/180)
End Function

'-------------------------------------------------------------------------------
' Steg_Math_GetScaledSize
'-------------------------------------------------------------------------------
Function Steg_Math_GetScaledSize(num as integer, percent as float) as Integer

	return num - (num*percent)
End Function

'-------------------------------------------------------------------------------
' Steg_Math_GetPercent
'
' @param num1 Integer - larger number
' @param num2 Integer - smaller number
'-------------------------------------------------------------------------------
Function Steg_Math_GetPercent(num1 as integer, num2 as integer) as float

	return (num1 - num2)/num1
End Function