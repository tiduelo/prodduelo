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
User Function MT261TDOK()  		  

Local aAreaSB2   := SB2->(GetArea()) //Guarda a posiçao inicial
Local _lRet       := .T.
Local nLocal   	  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"})
Local nLocDest 	  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"},nLocal+1)
Local nProd       := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_COD"})
Local LcNoAlco 	  := GetNewPar("US_ARNALC","02") //ARMAZEM NÃO ALCOOLICO
Local LcYsAlco 	  := GetNewPar("US_ARSALC","01") //ARMAZEM ALCOOLICO
Local LcNoAlcoFab := GetNewPar("US_ARNALCP","12")//ARMAZEM NÃO ALCOOLICO PE DE MAQUINA
Local LcYsAlcoFab := GetNewPar("US_ARSALCP","11")//ARMAZEM ALCOOLICO PE DE MAQUINA
Local _lActivRot  := GetNewPar("US_A261TOK",.T.)
Local _Msg        := ""
Local _MsgTrans   := ""
Local lMail := .F.
Local _aMail := {}  //Array(1,6)
Local _AGRVSD3 := {}
Local _cCdUser := Alltrim(RETCODUSR())
Local _cNmUser := Alltrim(USRFULLNAME(RETCODUSR()))
Local _cTpTransf := "" 
Local _cDocSD3   := ""
Local x := 0
Local nI := 0


If _lActivRot
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1]
			If ((aCols[x][nLocal] $ LcYsAlco .AND. aCols[x][nLocDest] $ LcYsAlcoFab)   .Or. (aCols[x][nLocal] $ LcNoAlco .AND. aCols[x][nLocDest] $ LcNoAlcoFab))  //Requisição do Almoxarifado para Chão de Fabrica
				_lRet := .T.			
				_MsgTrans := "TRANSFERÊNCIA DO ARMAZÉM: "+ Alltrim(aCols[x][nLocal]) +", PARA O ARMAZÉM: "+Alltrim(aCols[x][nLocDest]) 
				_cTpTransf := "PROD"   
				_cDocSD3   := SD3->D3_DOC				
				Aadd(_aGrvSD3,{SD3->D3_DOC,aCols[x][nProd]})
				conout("If lMail: .F.")				
				If !lMail
					Aadd(_aMail,{"1",; 				// Status - Transferencia
					Alltrim(SD3->D3_NUMSEQ),;  // D3_NUMSEQ
					DATE(),; // D3_EMISSAO
					Alltrim(_cCdUser),;   // Codigo do Usuario
					Alltrim(_cNmUser),;   // Nome do Usuario
					Alltrim(_MsgTrans),;
					Alltrim(SD3->D3_DOC)})          // Armazem
					lMail := .T.                              
					conout("Entrou If lMail: .T.  ")									
				EndIf								                				
			ElseIf ((aCols[x][nLocal] $ LcYsAlcoFab .AND. aCols[x][nLocDest] $ LcYsAlco)   .or. (aCols[x][nLocal] $ LcNoAlcoFab .AND. aCols[x][nLocDest] $ LcNoAlco))  //Devolução do Chão de Fabrica para Almoxarifado
				_lRet := .T.
				_MsgTrans := "DEVOLUÇÃO DO ARMAZÉM: "+ Alltrim(aCols[x][nLocal]) +", PARA O ARMAZÉM: "+Alltrim(aCols[x][nLocDest]) 
				_cTpTransf := "ALMX" 
				_cDocSD3   := SD3->D3_DOC
				Aadd(_aGrvSD3,{SD3->D3_DOC,aCols[x][nProd]})  
				conout("ElseIf lMail: .f.")
				If !lMail
					Aadd(_aMail,{"2",; 			  // Status - Devolução
					Alltrim(SD3->D3_NUMSEQ),;  // D3_NUMSEQ
					DATE(),; // D3_EMISSAO
					Alltrim(_cCdUser),; // Codigo do Usuario
					Alltrim(_cNmUser),; // Nome do Usuario
					Alltrim(_MsgTrans),;
					Alltrim(SD3->D3_DOC)})          // Armazem
					lMail := .T.
					conout("Entrou ElseIf lMail: .t.")													
				EndIf											
			EndIf
		EndIf
	Next
EndIf

conout("Antes Enviar E-mail: ")				
If lMail
	U_AtuZD3(_aMail)
	SD3->( dbSetOrder( 2 ))
	For nI := 1 To Len(_aGrvSD3) 
		If SD3->(MsSeek(xFilial("SD3")+_aGrvSD3[nI,1]+_aGrvSD3[nI,2])) .And. Empty(SD3->D3_PROJPMS)	
   			While !SD3->(eof()) .and. xFilial("SD3") == SD3->D3_FILIAL .AND. SD3->D3_DOC == _aGrvSD3[nI,1] .AND. SD3->D3_COD == _aGrvSD3[nI,2]
				RecLock("SD3",.F.)		
		   			//SD3->D3_PROJPMS :=  "TRANS_PROD"
				MsUnLock()
			 SD3->(dbskip())
			EnddO
		EndIf
	Next nI
conout("Preparando o Envio:: ")
	U_WFMT261(_cDocSD3,_cCdUser,_cTpTransf)
conout("Fim do Envio do E-mail: ")	
EndiF
conout("Fim da rotina de E-mail: ")	

RestArea(aAreaSB2) // Volta a posicaodo arquivo
Return _lRet

Return(.t.)