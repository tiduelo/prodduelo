#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT110LOK     บAutor  ณRAFAEL ALEMIDA   บ Data ณ  19/10/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada na valida็ใo da linha na rotina de         บฑฑ
ฑฑบ          ณ solicitacao de compras                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MATA110                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออBออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/////////////////////////
User Function MT110LOK()
/////////////////////////

//////// DECLARANDO AS VARIAVEIS ////////
Local _cAtvPE := SuperGetMv("US_MT110L",.T.,.T.)// Parametro Logico que valida se o ponto de entrada serแ utilizado.
Local _cAtvCC := SuperGetMv("US_SC1CC",.T.,.T.)// Parametro Logico que valida se o ponto de entrada serแ utilizado.
Local nPOsCc  := aScan(aHeader,{|x| AllTrim(x[2]) == "C1_CC"})   //RAFAEL ALMEIDA - SIGACORP (19/10/2016)    - POSIวรO 10 ATUALMENTE
Local nPOsCta := aScan(aHeader,{|x| AllTrim(x[2]) == "C1_CONTA"})  //RAFAEL ALMEIDA - SIGACORP (19/10/2016)  - POSIวรO 14 ATUALMENTE
Local nPOsRta := aScan(aHeader,{|x| AllTrim(x[2]) == "C1_RATEIO"})  //RAFAEL ALMEIDA - SIGACORP (19/10/2016)  - POSIวรO 14 ATUALMENTE
Local lRet := .T.
Local _cCC      := ""
Local _cCta     := ""
Local _cRgNvCC1  := ""
Local _cRgNvCC2  := ""
Local _cRgNvCC3  := ""
Local _cRgNv1Cta := ""
Local _cRgNv2Cta := ""
Local _cRgNv3Cta := ""
Private _cCodUsr  := RetCodUsr()
Private _cGrpUsr  := GetNewPar("US_USRCT1","/000107/000029/000049/000122/000124/000069/000127/000047/000027/")

If _cAtvPE
	If _cAtvCC
		_cCC  :=  aCols[n][nPOsCc]  // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
		_cCta :=  aCols[n][nPOsCta] // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
		_cRta :=  aCols[n][nPOsRta] // A variavel esta recebendo o conteudo do campo onde a linha esta posicionada.
		
		If _cRta == "1"
			lRet := .T.
		ElseIf !Empty(_cCta) .And. SubStr(Alltrim(_cCta),1,1)=="4" .And. Empty(_cCC)
			lRet := .F.
			MSGInfo("Aten็ใo!!! Centro de Custo ้ obrigatorio para Conta Contแbil.")
		ElseIf !Empty(_cCC) .And. Empty(_cCta)
			lRet := .F.
			MSGInfo("Aten็ใo!!! Conta Contแbil ้ obrigatorio para quando Centro de Custo estiver preenchido.")
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
						MSGInfo("Aten็ใo!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contแbil corretos.")
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
							MSGInfo("Aten็ใo!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contแbil corretos.")
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
							MSGInfo("Aten็ใo!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contแbil corretos.")
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
						MSGInfo("Aten็ใo!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contแbil corretos.")
					EndIf
				EndIf
				
				If !Empty(_cRgNvCC3)
					If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
						If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
							lRet := .T.
						Else
							lRet := .F.
							MSGInfo("Aten็ใo!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contแbil corretos.")
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
						MSGInfo("Aten็ใo!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Contแbil corretos.")
					EndIf
				EndIf
				
			EndIf
		EndIf
	EndIf
endif
Return(lReT)
