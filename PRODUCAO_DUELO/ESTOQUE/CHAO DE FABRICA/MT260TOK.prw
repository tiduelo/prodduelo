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
User Function MT260TOK()
Local _lRet		 := .T.
Local aAreaSB2   := SB2->(GetArea()) //Guarda a posi�ao inicial
Local LcNoAlco 	  := GetNewPar("US_ARNALC","02") //ARMAZEM N�O ALCOOLICO  PADRAO
Local LcYsAlco 	  := GetNewPar("US_ARSALC","01") //ARMAZEM ALCOOLICO PADRAO
Local LcNoAlcoFab := GetNewPar("US_ARNALCP","12")//ARMAZEM N�O ALCOOLICO CHAO DE FABRICA
Local LcYsAlcoFab := GetNewPar("US_ARSALCP","11")//ARMAZEM ALCOOLICO CHAO DE FABRICA
Local _lActivRot  := GetNewPar("US_A261TOK",.T.) // ATIVA E DESATIVA ROTINA DE TRANSFERENCIA 
Local _Msg        := ""
Local _MsgTrans   := ""
Local lMail := .F.
Local _aMail := {}  //Array(1,6)
Local _cCdUser := Alltrim(RETCODUSR())
Local _cNmUser := Alltrim(USRFULLNAME(RETCODUSR()))
Local _cNumSeq := cvaltochar(Val(ProxNum())+1)    
Local _cTpTransf := "" 
Local _cDocSD3   := cDocto

_Msg := "ACESSO NEGADO!!!"+Chr(13)+Chr(10)
_Msg += "N�O PODE HAVER TRANSFER�NCIA DE ARMAZ�M "

If _lActivRot
	If     (cLocOrig $ LcYsAlco .AND. cLocDest $ LcNoAlcoFab)
		_lRet := .F.
		_Msg += "PADR�O ALCO�LICO"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZ�M N�O ALCO�LICO CH�O DE F�BRICA"
	ElseIf (cLocOrig$ LcNoAlcoFab .AND. cLocDest $ LcYsAlco)
		_lRet := .F.
		_Msg += "N�O ALCO�LICO CH�O DE FABRICA"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZ�M PADR�O ALCO�LICO"
	ElseIf (cLocOrig $ LcNoAlco .AND. cLocDest $ LcYsAlcoFab)
		_lRet := .F.
		_Msg += "PADR�O N�O ALCO�LICO"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZ�M ALCO�LICO CH�O DE F�BRICA"
	ElseIf (cLocOrig $ LcYsAlcoFab .AND. cLocDest $ LcNoAlco)
		_lRet := .F.
		_Msg += "ALCO�LICO CH�O DE F�BRICA"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZ�M PADR�O N�O ALCO�LICO"
	ElseIf ((cLocOrig $ LcYsAlco .AND. cLocDest $ LcYsAlcoFab)   .Or. (cLocOrig $ LcNoAlco .AND. cLocDest $ LcNoAlcoFab))  //Requisi��o do Almoxarifado para Ch�o de Fabrica
		_lRet := .T.
		_MsgTrans := "TRANSFER�NCIA DO ARMAZ�M: "+ cLocOrig +", PARA O ARMAZ�M: "+cLocDest    
		_cTpTransf := "PROD"  		
		If !lMail
			Aadd(_aMail,{"1",; 				// Status - Transferencia
			Alltrim(_cNumSeq),;  // D3_NUMSEQ
			DATE(),; // D3_EMISSAO
			Alltrim(_cCdUser),;   // Codigo do Usuario
			Alltrim(_cNmUser),;   // Nome do Usuario
			Alltrim(_MsgTrans),;
			Alltrim(cDocto)})          // Armazem
			lMail := .T.
		EndIf
	ElseIf ((cLocOrig $ LcYsAlcoFab .AND. cLocDest $ LcYsAlco)   .or. (cLocOrig $ LcNoAlcoFab .AND. cLocDest $ LcNoAlco))  //Devolu��o do Ch�o de Fabrica para Almoxarifado
		_lRet := .T.
		_MsgTrans := "DEVOLU��O DO ARMAZ�M: "+ cLocOrig +", PARA O ARMAZ�M: "+cLocDest
		_cTpTransf := "ALMX" 		
		If !lMail
			Aadd(_aMail,{"2",; 			  // Status - Devolu��o
			Alltrim(_cNumSeq),;  // D3_NUMSEQ
			DATE(),; // D3_EMISSAO
			Alltrim(_cCdUser),; // Codigo do Usuario
			Alltrim(_cNmUser),; // Nome do Usuario
			Alltrim(_MsgTrans),;
			Alltrim(cDocto)})          // Armazem
			lMail := .T.
		EndIf
	EndIf
EndIf

If!_lRet
	MsgStop(_Msg,"A T E N � � O")
EndIf  

If lMail
	U_AtuZD3(_aMail)  
	U_WFMT261(_cDocSD3,_cCdUser,_cTpTransf)	
EndiF


RestArea(aAreaSB2) // Volta a posicaodo arquivo

Return _lRet
