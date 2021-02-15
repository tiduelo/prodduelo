#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F100TOK ºAutor  Rafael Almeida - SIGACORPº Data ³16/08/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ executado para validar os dados da movimentacao bancaria.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F100TOK()
Local aAreaSE5   := SE5->(GetArea()) //Guarda a posiçao inicial
Local _lActivRot  := GetNewPar("US_F100TOK",.T.) // ATIVA E DESATIVA ROTINA DE TRANSFERENCIA
Local _lRet		 := .T.
Local _cRgCTT   := ""
Local _cRgCT1   := ""
Local _cContaD   := M->E5_DEBITO
Local _cCCustD   := M->E5_CCD
Local _cContaC   := M->E5_CREDITO
Local _cCCustC   := M->E5_CCC
Local _Msg        := ""
Local _cCC      := ""
Local _cCta     := ""
Local _cRgNvCC1  := ""
Local _cRgNvCC2  := ""
Local _cRgNvCC3  := ""
Local _cRgNv1Cta := ""
Local _cRgNv2Cta := ""
Local _cRgNv3Cta := ""
Private _cCodUsr  := RetCodUsr()
Private _cGrpUsr  := GetNewPar("US_USRCT1","/000107/000029/000049/000122/000124/000069/000127/000047/")

If _lActivRot
	If    cRecPag =="P"    // !Empty(_cCCustD) .And. Empty(_cCCustC) // Cta a Pagar
		
		_cCC  :=  M->E5_CCD   // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
		_cCta :=  M->E5_DEBITO       // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
		
		If !Empty(_cCta) .And. SubStr(Alltrim(_cCta),1,1)=="4" .And. Empty(_cCC)
			_lRet := .F.
			MSGInfo("Atenção!!! Centro de Custo é obrigatorio para Conta Contábil.")
		ElseIf !Empty(_cCC) .And. Empty(_cCta)
			_lRet := .F.
			MSGInfo("Atenção!!! Conta Contábil é obrigatorio para quando Centro de Custo estiver preenchido.")
		ElseIf Empty(_cCC) .And. Empty(_cCta)
			_lRet := .F.
			MSGInfo("Atenção!!! Conta Contábil e Centro de Custo são Obrigatorios.")					
		Elseif !Empty(_cCta) .And. SubStr(Alltrim(_cCta),1,1)=="4" .And. !Empty(_cCC)
			_cRgNvCC1   := GetAdvFVal("CTT","CTT_CRGNV1",xFilial("CTT")+_cCC,1)
			_cRgNvCC2   := GetAdvFVal("CTT","CTT_RGNV2",xFilial("CTT")+_cCC,1)
			_cRgNvCC3   := GetAdvFVal("CTT","CTT_RGNV3",xFilial("CTT")+_cCC,1)
			_cRgNv1Cta  := GetAdvFVal("CT1","CT1_RGNV1",xFilial("CT1")+_cCta,1)
			_cRgNv2Cta  := GetAdvFVal("CT1","CT1_RGNV2",xFilial("CT1")+_cCta,1)
			_cRgNv3Cta  := GetAdvFVal("CT1","CT1_RGNV3",xFilial("CT1")+_cCta,1)
			
			If     !Empty(_cRgNvCC1)
				If Alltrim(_cRgNvCC1) <>  Alltrim(_cRgNv1Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						_lRet := .T.
					Else
						_lRet := .F.
						MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
					EndIf
				Else
					Conout("Primeiro IF _cAtvPE - MT110LOK")
				EndIf
				
				If !Empty(_cRgNvCC2)
					If Alltrim(_cRgNvCC2) <>  Alltrim(_cRgNv2Cta)
						If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
							_lRet := .T.
						Else
							_lRet := .F.
							MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
						EndIf
					Else
						Conout("Primeiro IF _cAtvPE - MT110LOK")
						_lRet := .T.
					EndIf
				EndIf
				
				If !Empty(_cRgNvCC3)
					If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
						If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
							lRet := .T.
						Else
							_lRet := .F.
							MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
						EndIf
					Else
						Conout("Primeiro IF _cAtvPE - MT110LOK")
						_lRet := .T.
					EndIf
				EndIf
				
			ElseIf !Empty(_cRgNvCC2)
				If Alltrim(_cRgNvCC2) <>  Alltrim(_cRgNv2Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						lRet := .T.
					Else
						_lRet := .F.
						MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
					EndIf
				EndIf
				
				If !Empty(_cRgNvCC3)
					If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
						If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
							_lRet := .T.
						Else
							_lRet := .F.
							MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
						EndIf
					Else
						Conout("Primeiro IF _cAtvPE - MT110LOK")
						_lRet := .T.
					EndIf
				EndIf
				
			ElseIf !Empty(_cRgNvCC3)
				If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						_lRet := .T.
					Else
						_lRet := .F.
						MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
					EndIf
				EndIf
			EndIf
		EndIf
		
		
	ElseIf cRecPag =="R"  //!Empty(_cCCustC) .And. Empty(_cCCustD) // Cta a Receber
		
		_cCC  :=  M->E5_CCC   // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
		_cCta :=  M->E5_CREDITO       // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
		
		If !Empty(_cCta) .And. SubStr(Alltrim(_cCta),1,1)=="4" .And. Empty(_cCC)
			_lRet := .F.
			MSGInfo("Atenção!!! Centro de Custo é obrigatorio para Conta Contábil.")
		ElseIf !Empty(_cCC) .And. Empty(_cCta)
			_lRet := .F.
			MSGInfo("Atenção!!! Conta Contábil é obrigatorio para quando Centro de Custo estiver preenchido.")
		ElseIf Empty(_cCC) .And. Empty(_cCta)
			_lRet := .F.
			MSGInfo("Atenção!!! Conta Contábil e Centro de Custo são Obrigatorios.")								
		Elseif !Empty(_cCta) .And. SubStr(Alltrim(_cCta),1,1)=="4" .And. !Empty(_cCC)
			_cRgNvCC1   := GetAdvFVal("CTT","CTT_CRGNV1",xFilial("CTT")+_cCC,1)
			_cRgNvCC2   := GetAdvFVal("CTT","CTT_RGNV2",xFilial("CTT")+_cCC,1)
			_cRgNvCC3   := GetAdvFVal("CTT","CTT_RGNV3",xFilial("CTT")+_cCC,1)
			_cRgNv1Cta  := GetAdvFVal("CT1","CT1_RGNV1",xFilial("CT1")+_cCta,1)
			_cRgNv2Cta  := GetAdvFVal("CT1","CT1_RGNV2",xFilial("CT1")+_cCta,1)
//			_cRgNv3Cta  := GetAdv_lRetFVal("CT1","CT1_RGNV3",xFilial("CT1")+_cCta,1)
			_cRgNv3Cta  := GetAdvFVal("CT1","CT1_RGNV3",xFilial("CT1")+_cCta,1)
			
			If     !Empty(_cRgNvCC1)
				If Alltrim(_cRgNvCC1) <>  Alltrim(_cRgNv1Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						_lRet := .T.
					Else
						_lRet := .F.
						MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
					EndIf
				Else
					Conout("Primeiro IF _cAtvPE - MT110LOK")
					_lRet := .T.
				EndIf
				
				If !Empty(_cRgNvCC2)
					If Alltrim(_cRgNvCC2) <>  Alltrim(_cRgNv2Cta)
						If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
							_lRet := .T.
						Else
							_lRet := .F.
							MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
						EndIf
					Else
						Conout("Primeiro IF _cAtvPE - MT110LOK")
						_lRet := .T.
					EndIf
				EndIf
				
				If !Empty(_cRgNvCC3)
					If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
						If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
							_lRet := .T.
						Else
							_lRet := .F.
							MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
						EndIf
					Else
						Conout("Primeiro IF _cAtvPE - MT110LOK")
						_lRet := .T.
					EndIf
				EndIf
				
			ElseIf !Empty(_cRgNvCC2)
				If Alltrim(_cRgNvCC2) <>  Alltrim(_cRgNv2Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						_lRet := .T.
					Else
						_lRet := .F.
						MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
					EndIf
				EndIf
				
				If !Empty(_cRgNvCC3)
					If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
						If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
							_lRet := .T.
						Else
							_lRet := .F.
							MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
						EndIf
					Else
						Conout("Primeiro IF _cAtvPE - MT110LOK")
						_lRet := .T.
					EndIf
				EndIf
				
			ElseIf !Empty(_cRgNvCC3)
				If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						_lRet := .T.
					Else
						_lRet := .F.
						MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
					EndIf
				EndIf
				
			EndIf
		EndIf		
	Else
	
		_lRet := .T.
	EndIf
	
EndIf



_lFA100Pag := .F.
_lFA100Rec := .F.
RestArea(aAreaSE5) // Volta a posicaodo arquivo

Return _lRet



/*
If !Empty(_cContaD)
_cRgCT1 := GetAdvFVal("CT1", "CT1_RGNV1",xFilial("CT1") + _cContaD,1)
If !Empty(_cRgCT1)
If !Empty(_cCCusto)
_cRgCTT := GetAdvFVal("CTT", "CTT_CRGNV1",xFilial("CTT") + _cCCusto ,1)
If  _cRgCT1 = _cRgCTT
_lRet := .T.
Else
_lRet := .F.
_Msg := "ACESSO NEGADO!!!"+Chr(13)+Chr(10)
_Msg += "Centro de Custo informado, NÃO está amarrado a CONTA CONTÁBIL."+Chr(13)+Chr(10)
_Msg += "Por favor, informar CENTRO DE CUSTO correto."
EndIf
Else
_lRet := .F.
_Msg := "ACESSO NEGADO!!!"+Chr(13)+Chr(10)
_Msg += "CONTA CONTÁBIL informada é amarrada há um CENTRO DE CUSTO."+Chr(13)+Chr(10)
_Msg += "Por favor, informar CENTRO DE CUSTO."
EndIf
EndIf
EndIF
If!_lRet
MsgStop(_Msg,"A T E N Ç Ã O")
EndIf

*/
