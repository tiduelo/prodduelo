user function DL200TRB()
Local _x := 0

_aCampos := paramixb

if valtype(_aCampos) == "A"
	
	For _x := 1 to len(_aCampos)
		
		if alltrim(upper(_aCampos[_x][1])) == "PED_CODPRO"
			_aCampos[_x][3] := 9
		Endif
		//alert( "Campo: "+_aCampos[_x][1]+" Tam: "+alltrim(str(_aCampos[_x][3],3,0)) )
	Next
	
endif

return(_aCampos)

