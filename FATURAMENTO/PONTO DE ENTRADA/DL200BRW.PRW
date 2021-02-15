user function DL200BRW()
Local _x := 0

_aCampos := paramixb

AAdd( _aCampos ,{"PED_BAIRRO" , ,"Bairro"} )
AAdd( _aCampos ,{"PED_MUN"    , ,"Cidade"} )

_aCpoFin := {}

_cCpoNao := "PED_VOLUM,PED_CARGA,PED_CEP,PED_SEQLIB,PED_CODPRO,PED_DESPRO"

if valtype(_aCampos) == "A"
	
	For _x := 1 to len(_aCampos)
		
		//alert( "Campo: "+_aCampos[_x][1]+" Tam: "+alltrim(str(_aCampos[_x][3],3,0)) )
		
		if alltrim(upper(_aCampos[_x][1])) == "PED_SEQLIB"
			_aCampos[_x][3] := "Seq"
		Endif
		
		if ! alltrim(upper(_aCampos[_x][1])) $ _cCpoNao
			aadd(_aCpoFin,_aCampos[_x])
		Endif
		
	Next
	
endif

IF len(_aCpoFin) > 0
	
	If	mv_par06 == 2
		AAdd( _aCpoFin ,{"PED_CODPRO" , ,"Codigo"} )//"Codigo"
		AAdd( _aCpoFin ,{"PED_DESPRO" , ,"Produto"} )//"Produto"
	EndIf
	
	AAdd( _aCpoFin ,{"PED_SEQLIB" , ,"Seq"} ) //"Seq. Liberacao"
	
Endif

return( iif(len(_aCpoFin) > 0,_aCpoFin,_aCampos))
