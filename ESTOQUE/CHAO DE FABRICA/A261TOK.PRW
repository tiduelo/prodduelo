#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A261TOK ºAutor  Rafael Almeida - SIGACORPº Data ³27/10/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDA A ROTINA MATA261 (TRANSF. MOD. 2)                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A261TOK()
Local aAreaSB2   := SB2->(GetArea()) //Guarda a posiçao inicial
Local _lRet       := .T.
Local cNumSeq  	  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_	NUMSEQ"})
Local dDatEmis 	  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_EMISSAO"})
Local nLocal   	  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"})
Local nLocDest 	  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"},nLocal+1)
Local LcNoAlco 	  := GetNewPar("US_ARNALC","02") //ARMAZEM NÃO ALCOOLICO
Local LcYsAlco 	  := GetNewPar("US_ARSALC","01") //ARMAZEM ALCOOLICO
Local LcNoAlcoFab := GetNewPar("US_ARNALCP","12")//ARMAZEM NÃO ALCOOLICO PE DE MAQUINA
Local LcYsAlcoFab := GetNewPar("US_ARSALCP","11")//ARMAZEM ALCOOLICO PE DE MAQUINA
Local _lActivRot  := GetNewPar("US_A261TOK",.T.)
Local _Msg        := ""
Local _MsgTrans   := ""
Local lMail := .F.
Local _aMail := {}  //Array(1,6)
Local _cCdUser := Alltrim(RETCODUSR())
Local _cNmUser := Alltrim(USRFULLNAME(RETCODUSR()))
Local x := 0
_Msg := "ACESSO NEGADO!!!"+Chr(13)+Chr(10)
_Msg += "NÃO PODE HAVER TRANSFERÊNCIA DE ARMAZÉM "

If _lActivRot
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1]
			If     (aCols[x][nLocal] $ LcYsAlco .AND. aCols[x][nLocDest] $ LcNoAlcoFab)
				_lRet := .F.
				_Msg += "PADRÃO ALCOÓLICO"+Chr(13)+Chr(10)
				_Msg += "PARA O ARMAZÉM NÃO ALCOÓLICO CHÃO DE FÁBRICA"
			ElseIf (aCols[x][nLocal] $ LcNoAlcoFab .AND. aCols[x][nLocDest] $ LcYsAlco)
				_lRet := .F.
				_Msg += "NÃO ALCOÓLICO CHÃO DE FABRICA"+Chr(13)+Chr(10)
				_Msg += "PARA O ARMAZÉM PADRÃO ALCOÓLICO"
			ElseIf (aCols[x][nLocal] $ LcNoAlco .AND. aCols[x][nLocDest] $ LcYsAlcoFab)
				_lRet := .F.
				_Msg += "PADRÃO NÃO ALCOÓLICO"+Chr(13)+Chr(10)
				_Msg += "PARA O ARMAZÉM ALCOÓLICO CHÃO DE FÁBRICA"
			ElseIf (aCols[x][nLocal] $ LcYsAlcoFab .AND. aCols[x][nLocDest] $ LcNoAlco)
				_lRet := .F.
				_Msg += "ALCOÓLICO CHÃO DE FÁBRICA"+Chr(13)+Chr(10)
				_Msg += "PARA O ARMAZÉM PADRÃO NÃO ALCOÓLICO"				
			EndIf
		EndIf
	Next
EndIf

If!_lRet
	MsgStop(_Msg,"A T E N Ç Ã O")
EndIf

RestArea(aAreaSB2) // Volta a posicaodo arquivo
Return _lRet
