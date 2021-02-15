#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA261LIN บAutor Rafael Almeida - SIGACORPบ Data ณ27/10/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ VALIDA LINHA DA ROTINA MATA261 (TRANSF. MOD. 2)            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESTOQUE / CUSTOS                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA261LIN( )
Local _lRet := .T.
Local _nL := PARAMIXB[1]  // numero da linha do aCols
Local _pLocal := aScan(aHeader,{|x| AllTrim(x[1])=="Armazem Orig."})
Local _pLocDest := aScan(aHeader,{|x| AllTrim(x[1])=="Armazem Destino"})
Local LcNoAlco 	  := GetNewPar("US_ARNALC","02") //ARMAZEM NรO ALCOOLICO
Local LcYsAlco 	  := GetNewPar("US_ARSALC","01") //ARMAZEM ALCOOLICO
Local LcNoAlcoFab := GetNewPar("US_ARNALCP","12")//ARMAZEM NรO ALCOOLICO PE DE MAQUINA
Local LcYsAlcoFab := GetNewPar("US_ARSALCP","11")//ARMAZEM ALCOOLICO PE DE MAQUINA
Local _lActivRot  := GetNewPar("US_A261TOK",.T.)
Local _Msg        := ""

_Msg := "ACESSO NEGADO!!!"+Chr(13)+Chr(10)
_Msg += "NรO PODE HAVER TRANSFERสNCIA DE ARMAZษM "

If _lActivRot
	
	If     (aCols[_nL][_pLocal] $ LcYsAlco .AND. aCols[_nL][_pLocDest] $ LcNoAlcoFab)
		_lRet := .F.
		_Msg += "PADRรO ALCOำLICO"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZษM NรO ALCOำLICO CHรO DE FมBRICA"
	ElseIf (aCols[_nL][_pLocal] $ LcNoAlcoFab .AND. aCols[_nL][_pLocDest] $ LcYsAlco)
		_lRet := .F.
		_Msg += "NรO ALCOำLICO CHรO DE FABRICA"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZษM PADRรO ALCOำLICO"
	ElseIf (aCols[_nL][_pLocal] $ LcNoAlco .AND. aCols[_nL][_pLocDest] $ LcYsAlcoFab)
		_lRet := .F.
		_Msg += "PADRรO NรO ALCOำLICO"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZษM ALCOำLICO CHรO DE FมBRICA"
	ElseIf (aCols[_nL][_pLocal] $ LcYsAlcoFab .AND. aCols[_nL][_pLocDest] $ LcNoAlco)
		_lRet := .F.
		_Msg += "ALCOำLICO CHรO DE FมBRICA"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZษM PADRรO NรO ALCOำLICO"
	EndIf
EndIf

If!_lRet
	MsgStop(_Msg,"A T E N ว ร O")
EndIf

Return _lRet
