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
User Function MT260TOK()
Local _lRet		 := .T.
Local aAreaSB2   := SB2->(GetArea()) //Guarda a posiçao inicial
Local LcNoAlco 	  := GetNewPar("US_ARNALC","02") //ARMAZEM NÃO ALCOOLICO  PADRAO
Local LcYsAlco 	  := GetNewPar("US_ARSALC","01") //ARMAZEM ALCOOLICO PADRAO
Local LcNoAlcoFab := GetNewPar("US_ARNALCP","12")//ARMAZEM NÃO ALCOOLICO CHAO DE FABRICA
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
_Msg += "NÃO PODE HAVER TRANSFERÊNCIA DE ARMAZÉM "

If _lActivRot
	If     (cLocOrig $ LcYsAlco .AND. cLocDest $ LcNoAlcoFab)
		_lRet := .F.
		_Msg += "PADRÃO ALCOÓLICO"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZÉM NÃO ALCOÓLICO CHÃO DE FÁBRICA"
	ElseIf (cLocOrig$ LcNoAlcoFab .AND. cLocDest $ LcYsAlco)
		_lRet := .F.
		_Msg += "NÃO ALCOÓLICO CHÃO DE FABRICA"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZÉM PADRÃO ALCOÓLICO"
	ElseIf (cLocOrig $ LcNoAlco .AND. cLocDest $ LcYsAlcoFab)
		_lRet := .F.
		_Msg += "PADRÃO NÃO ALCOÓLICO"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZÉM ALCOÓLICO CHÃO DE FÁBRICA"
	ElseIf (cLocOrig $ LcYsAlcoFab .AND. cLocDest $ LcNoAlco)
		_lRet := .F.
		_Msg += "ALCOÓLICO CHÃO DE FÁBRICA"+Chr(13)+Chr(10)
		_Msg += "PARA O ARMAZÉM PADRÃO NÃO ALCOÓLICO"
	ElseIf ((cLocOrig $ LcYsAlco .AND. cLocDest $ LcYsAlcoFab)   .Or. (cLocOrig $ LcNoAlco .AND. cLocDest $ LcNoAlcoFab))  //Requisição do Almoxarifado para Chão de Fabrica
		_lRet := .T.
		_MsgTrans := "TRANSFERÊNCIA DO ARMAZÉM: "+ cLocOrig +", PARA O ARMAZÉM: "+cLocDest    
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
	ElseIf ((cLocOrig $ LcYsAlcoFab .AND. cLocDest $ LcYsAlco)   .or. (cLocOrig $ LcNoAlcoFab .AND. cLocDest $ LcNoAlco))  //Devolução do Chão de Fabrica para Almoxarifado
		_lRet := .T.
		_MsgTrans := "DEVOLUÇÃO DO ARMAZÉM: "+ cLocOrig +", PARA O ARMAZÉM: "+cLocDest
		_cTpTransf := "ALMX" 		
		If !lMail
			Aadd(_aMail,{"2",; 			  // Status - Devolução
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
	MsgStop(_Msg,"A T E N Ç Ã O")
EndIf  

If lMail
	U_AtuZD3(_aMail)  
	U_WFMT261(_cDocSD3,_cCdUser,_cTpTransf)	
EndiF


RestArea(aAreaSB2) // Volta a posicaodo arquivo

Return _lRet
