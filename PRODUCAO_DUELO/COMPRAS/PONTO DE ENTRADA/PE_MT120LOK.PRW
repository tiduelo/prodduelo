#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120LOK     �Autor  �RAFAEL ALEMIDA   � Data �  19/10/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na valida��o da linha na rotina de         ���
���          � PEDIDO DE  compras                                         ���
�������������������������������������������������������������������������͹��
���Uso       � MATA120                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/////////////////////////
User Function MT120LOK()
/////////////////////////

//////// DECLARANDO AS VARIAVEIS ////////
Local _cAtvPE := SuperGetMv("US_MT120L",.T.,.T.)// Parametro Logico que valida se o ponto de entrada ser� utilizado.
Local _cAtvCC := SuperGetMv("US_SC7CC",.T.,.T.)// Parametro Logico que valida se o ponto de entrada ser� utilizado.
Local nPOsCc  := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_CC"})   //RAFAEL ALMEIDA - SIGACORP (19/10/2016)    - POSI��O 16 ATUALMENTE
Local nPOsCta := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_CONTA"})  //RAFAEL ALMEIDA - SIGACORP (19/10/2016)
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
		
		If !Empty(_cCta) .And. SubStr(Alltrim(_cCta),1,1)=="4" .And. Empty(_cCC)
			lRet := .F.
			MSGInfo("Aten��o!!! Centro de Custo � obrigatorio para Conta Cont�bil.")
		ElseIf !Empty(_cCC) .And. Empty(_cCta)
			lRet := .F.
			MSGInfo("Aten��o!!! Conta Cont�bil � obrigatorio para quando Centro de Custo estiver preenchido.")						
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
						MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
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
							MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
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
							MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
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
						MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
					EndIf
				EndIf
				
				If !Empty(_cRgNvCC3)
					If Alltrim(_cRgNvCC3) <>  Alltrim(_cRgNv3Cta)
						If Alltrim(_cCodUsr) $  Alltrim(_cGrpUsr)
							lRet := .T.
						Else
							lRet := .F.
							MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
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
						MSGInfo("Aten��o!!! Favor verificar o preenchimento do Centro de Custo e/ou Conta Cont�bil corretos.")
					EndIf
				EndIf
				
			EndIf
		EndIf
	EndIf
EndIf

Return(lReT)
