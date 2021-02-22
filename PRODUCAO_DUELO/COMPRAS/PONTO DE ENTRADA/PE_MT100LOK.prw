#Include "Protheus.ch"
#Define ENTER  Chr(10) + Chr (13) // SALTO DE LINHA (CARRIAGE RETURN + LINE FEED)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK     ºAutor  ³RAFAEL ALEMIDA   º Data ³  20/04/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na validação da linha de Nota Fiscal       º±±
±±º          ³ Entrada para não permitir que uma TES que não Mov Estoque  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA103                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/////////////////////////
User Function MT100LOK()
/////////////////////////



//////// DECLARANDO AS VARIAVEIS ////////
Local nPOsNcm := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TEC"})  //RAFAEL ALMEIDA - SIGACORP (18/01/2016)
Local nPOsTes := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"})  //RAFAEL ALMEIDA - SIGACORP (18/01/2016)
Local _cEspecie := cEspecie
Local _cFormul  := cFormul
Local lRet := .T.
Local _cUsrLogin := RetCodUsr()
Local _cUsrAdm   := SUPERGETMV("US_ADMT103",.F.,"/000000/")
Local _cMsgInfo  := ""
Local _cAtvPE    := SuperGetMv("US_MT100L",.T.,.T.)// Parametro Logico que valida se o ponto de entrada será utilizado.
Local _lAtvNFS   := SuperGetMv("US_LTENFS",.T.,.T.)// Parametro Logico que valida se o ponto de entrada será utilizado para validar TES de serviços.
Local _cTesNFS   := SuperGetMv("US_TESNFS",.T.,.T.)// Parametro com a relação de TES para Nota Fiscal de Serviço.
Local _cNcm      := ""
Local _cTes      := ""

Local _cCC  := ""
Local _cCta := ""
Local _cRgNvCC1  := ""
Local _cRgNvCC2  := ""
Local _cRgNvCC3  := ""
Local _cRgNv1Cta := ""
Local _cRgNv2Cta := ""
Local _cRgNv3Cta := ""

Local _cAtvCC := SuperGetMv("US_SD1CC",.T.,.T.)// Parametro Logico que valida se o ponto de entrada será utilizado.
Local nPOsCc  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CC"})   //RAFAEL ALMEIDA - SIGACORP (19/10/2016)   -- POSIÇÃO ATUALMENTE E 22
Local nPOsCta := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CONTA"})  //RAFAEL ALMEIDA - SIGACORP (19/10/2016)

Local _cAtvDev   :=  SuperGetMv("US_TIPODEV",.T.,.T.)// Parametro Logico que valida se o ponto de entrada será utilizado.
Local _D1NfOri      := Space(9)    // numero da Nota Fiscal de Origem
Local _ListTpNf     := "/D/" // Listagem dos tipos de Nota Fiscal que Faz necessario  o preechimento da Nota Fiscal de Origem


Private _cCodUsr  := RetCodUsr()
Private _cGrpUsr  := GetNewPar("US_USRCT1","/000107/000029/000049/000122/000124/000069/000127/000047/000027/")

SETPRVT("NCOL,_LRETURN,_CSENHA")
SETPRVT("_D1NFORI,_D1COD,_D1CF,_B1GRUPO,_D1CC")

//////// PROCESSO ////////

If _cAtvPE
	_cNcm := aCols[n][nPOsNcm] // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
	If Alltrim(_cEspecie) == "SPED" .And. Empty(_cNcm)
		lRet := .F.
		MSGInfo("Atenção!!! Para o Tipo de Documento que deseja incluir faz necessário informar a NCM do Produto.")
	EndIf
	
EndIf

If _lAtvNFS
	_cTes :=   aCols[n][nPOsTes] // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
	If Alltrim(_cEspecie) $ "/NFSE/NFS/" .And. !(Alltrim(_cTesNFS) $ Alltrim(_cTes))
		lRet := .F.
		MSGInfo("Atenção!!! Para o Tipo de Documento que deseja incluir faz necessário informar a TES de SERVIÇO.")
	EndIf

EndIf

If _cAtvCC
	_cCC  :=  aCols[n][nPOsCc]  // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
	_cCta :=  aCols[n][nPOsCta] // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
	
	
	If !Empty(_cCta) .And. SubStr(Alltrim(_cCta),1,1)=="4" .And. Empty(_cCC)
		lRet := .F.
		MSGInfo("Atenção!!! Centro de Custo é obrigatorio para Conta Contábil.")
	ElseIf !Empty(_cCC) .And. Empty(_cCta)
		lRet := .F.
		MSGInfo("Atenção!!! Conta Contábil é obrigatorio para quando Centro de Custo estiver preenchido.")
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
					lRet := .T.
				Else
					lRet := .F.
					MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
				EndIf
			Else
				Conout("Primeiro IF _cAtvPE - MT110LOK")
			EndIf
			
			If !Empty(_cRgNvCC2)
				If Alltrim(_cRgNvCC2) <>  Alltrim(_cRgNv2Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						lRet := .T.
					Else
						lRet := .F.
						MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
					EndIf
				Else
					Conout("Primeiro IF _cAtvPE - MT110LOK")
				EndIf
			EndIf
			
			If !Empty(_cRgNvCC3)
				If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						lRet := .T.
					Else
						lRet := .F.
						MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
					EndIf
				Else
					Conout("Primeiro IF _cAtvPE - MT110LOK")
				EndIf
			EndIf
			
		ElseIf !Empty(_cRgNvCC2)
			If Alltrim(_cRgNvCC2) <>  Alltrim(_cRgNv2Cta)
				If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
					lRet := .T.
				Else
					lRet := .F.
					MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
				EndIf
			EndIf
			
			If !Empty(_cRgNvCC3)
				If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
					If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
						lRet := .T.
					Else
						lRet := .F.
						MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
					EndIf
				Else
					Conout("Primeiro IF _cAtvPE - MT110LOK")
				EndIf
			EndIf
			
		ElseIf !Empty(_cRgNvCC3)
			If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
				If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
					lRet := .T.
				Else
					lRet := .F.
					MSGInfo("Atenção!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contábil corretos.")
				EndIf
			EndIf
			
		EndIf
	EndIf
EndIf

If _cAtvDev
	If aCols[n,Len(aHeader)+1] == .F.   // Se .T. a "linha" esta deletada
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le Numero do Pedido                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCol := Ascan( AHeader,{ |X| UPPER( AllTrim(X[2]) )=="D1_NFORI" } )
		
		If nCol > 0
			_D1NfOri := aCols[n,nCol] // L^ numero da Nota Fiscal de Origem
		Endif
		
		
		
		If !Empty(_D1NfOri) .AND. !(Alltrim(CTIPO)$Alltrim(_ListTpNf))
			// Verifica se grupo do produto aceita pedido em branco...
			
			lRet := .F.        // nao valida Inclusão da Nota Fiscal Origem
			_cMsg := "Nota Fiscal trata-se de uma Devolução! "+CRLF
			_cMsg += "Por favor "+CRLF
			_cMsg += "Informar o TIPO correto da Nota Fiscal no cabeçalho da rotina!"
			
			MsgBox(_cMsg,"Atencao","ALERT")
		Endif
	Endif
EndIf

If _cFormul == "S" .And. "SPED"$_cEspecie
	_cMsgInfo := "Seu perfil não tem permissão para incluir a Nota Fiscal como SPED"+ENTER+ENTER
    _cMsgInfo += "SOLUÇÃO:"+ENTER
    _cMsgInfo += "- Realizar a Entrada da NF atraves da Rotina de Importação do XML"+ENTER
    _cMsgInfo += "ou"+ENTER
    _cMsgInfo += "- Seu usuario deverá ter permissão no parametro US_ADMT103"
	
	If !(_cUsrLogin $ _cUsrAdm)
		lReT := .F.
        MsgAlert(_cMsgInfo,"SEM PERMISSÃO")
    EndIf
EndIf

Return(lReT)
