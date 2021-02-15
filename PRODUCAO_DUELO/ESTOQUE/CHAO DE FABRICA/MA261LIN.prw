#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA261LIN �Autor Rafael Almeida - SIGACORP� Data �27/10/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � VALIDA LINHA DA ROTINA MATA261 (TRANSF. MOD. 2)            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA261LIN( )
Local _lRet := .T.
Local _nL := PARAMIXB[1]  // numero da linha do aCols
Local _pLocal := aScan(aHeader,{|x| AllTrim(x[1])=="Armazem Orig."})
Local _pLocDest := aScan(aHeader,{|x| AllTrim(x[1])=="Armazem Destino"})
Local LcNoAlco 	  := GetNewPar("US_ARNALC","02") //ARMAZEM N�O ALCOOLICO
Local LcYsAlco 	  := GetNewPar("US_ARSALC","01") //ARMAZEM ALCOOLICO
Local LcNoAlcoFab := GetNewPar("US_ARNALCP","12")//ARMAZEM N�O ALCOOLICO PE DE MAQUINA
Local LcYsAlcoFab := GetNewPar("US_ARSALCP","11")//ARMAZEM ALCOOLICO PE DE MAQUINA
Local _lActivRot  := GetNewPar("US_A261TOK",.T.)
Local _Msg        := ""

_Msg := "ACESSO NEGADO!!!"+Chr(13)+Chr(10)
_Msg += "N�O PODE HAVER TRANSFER�NCIA DE ARMAZ�M "

If _lActivRot
	
	If     (aCols[_nL][_pLocal] $ LcYsAlco .AND. aCols[_nL][_pLocDest] $ LcNoAlcoFab)
		_lRet := .F.
		_Msg += "PADR�O ALCO�LICO"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZ�M N�O ALCO�LICO CH�O DE F�BRICA"
	ElseIf (aCols[_nL][_pLocal] $ LcNoAlcoFab .AND. aCols[_nL][_pLocDest] $ LcYsAlco)
		_lRet := .F.
		_Msg += "N�O ALCO�LICO CH�O DE FABRICA"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZ�M PADR�O ALCO�LICO"
	ElseIf (aCols[_nL][_pLocal] $ LcNoAlco .AND. aCols[_nL][_pLocDest] $ LcYsAlcoFab)
		_lRet := .F.
		_Msg += "PADR�O N�O ALCO�LICO"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZ�M ALCO�LICO CH�O DE F�BRICA"
	ElseIf (aCols[_nL][_pLocal] $ LcYsAlcoFab .AND. aCols[_nL][_pLocDest] $ LcNoAlco)
		_lRet := .F.
		_Msg += "ALCO�LICO CH�O DE F�BRICA"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZ�M PADR�O N�O ALCO�LICO"
	EndIf
EndIf

If!_lRet
	MsgStop(_Msg,"A T E N � � O")
EndIf

Return _lRet
