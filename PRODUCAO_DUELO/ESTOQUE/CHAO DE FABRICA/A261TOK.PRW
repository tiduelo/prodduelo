#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A261TOK �Autor  Rafael Almeida - SIGACORP� Data �27/10/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � VALIDA A ROTINA MATA261 (TRANSF. MOD. 2)                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A261TOK()
Local aAreaSB2   := SB2->(GetArea()) //Guarda a posi�ao inicial
Local _lRet       := .T.
Local cNumSeq  	  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_	NUMSEQ"})
Local dDatEmis 	  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_EMISSAO"})
Local nLocal   	  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"})
Local nLocDest 	  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"},nLocal+1)
Local LcNoAlco 	  := GetNewPar("US_ARNALC","02") //ARMAZEM N�O ALCOOLICO
Local LcYsAlco 	  := GetNewPar("US_ARSALC","01") //ARMAZEM ALCOOLICO
Local LcNoAlcoFab := GetNewPar("US_ARNALCP","12")//ARMAZEM N�O ALCOOLICO PE DE MAQUINA
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
_Msg += "N�O PODE HAVER TRANSFER�NCIA DE ARMAZ�M "

If _lActivRot
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1]
			If     (aCols[x][nLocal] $ LcYsAlco .AND. aCols[x][nLocDest] $ LcNoAlcoFab)
				_lRet := .F.
				_Msg += "PADR�O ALCO�LICO"+Chr(13)+Chr(10)
				_Msg += "PARA O ARMAZ�M N�O ALCO�LICO CH�O DE F�BRICA"
			ElseIf (aCols[x][nLocal] $ LcNoAlcoFab .AND. aCols[x][nLocDest] $ LcYsAlco)
				_lRet := .F.
				_Msg += "N�O ALCO�LICO CH�O DE FABRICA"+Chr(13)+Chr(10)
				_Msg += "PARA O ARMAZ�M PADR�O ALCO�LICO"
			ElseIf (aCols[x][nLocal] $ LcNoAlco .AND. aCols[x][nLocDest] $ LcYsAlcoFab)
				_lRet := .F.
				_Msg += "PADR�O N�O ALCO�LICO"+Chr(13)+Chr(10)
				_Msg += "PARA O ARMAZ�M ALCO�LICO CH�O DE F�BRICA"
			ElseIf (aCols[x][nLocal] $ LcYsAlcoFab .AND. aCols[x][nLocDest] $ LcNoAlco)
				_lRet := .F.
				_Msg += "ALCO�LICO CH�O DE F�BRICA"+Chr(13)+Chr(10)
				_Msg += "PARA O ARMAZ�M PADR�O N�O ALCO�LICO"				
			EndIf
		EndIf
	Next
EndIf

If!_lRet
	MsgStop(_Msg,"A T E N � � O")
EndIf

RestArea(aAreaSB2) // Volta a posicaodo arquivo
Return _lRet
