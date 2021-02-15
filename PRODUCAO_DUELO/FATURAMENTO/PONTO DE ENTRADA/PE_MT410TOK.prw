#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"


User Function MT410TOK()
	Local lRet         := .T.			// Conteudo de retorno
	Local cMsg         := ""			// Mensagem de alerta
	Local cMsg2         := ""			// Mensagem de alerta
	Local nOpc         := PARAMIXB[1]	// Opcao de manutencao
	Local _cCdPag      := M->C5_CONDPAG 
	Local _cPedido     := M->C5_NUM 
	Local _cCodCli     := M->C5_CLIENTE
	Local _cDesCdPag   := ""
	Local _nVlrLmt	   := 0
	Local _nTotPed     := 0
	Local _aItens      := aCols
	Local _nX
	Local _cMotBonif   := M->C5_MOTBONI
	Local _cTipoPV     := M->C5_TIPO
	Local _cFormBonif  := M->C5_FORMPAG

	local _CVend	   := M->C5_VEND1
	Local _CSit        := 0

	_cSit := GetAdvFVal ("SA3", "A3_MSBLQL", xFilial("SA3")+_CVend,1)

	If nOpc == 4
		If Val(_cSit) == 1
			cMsg := "Vendedor bloqueado!! Favor verificar qual o vendedor correto deste pedido de venda."
			lRet := .F.
		else
			lRet := .T.
		EndIf
	EndIf
	
	If Upper(Alltrim(_cFormBonif)) == "BON" .And. Empty(_cMotBonif) .And. _cTipoPV =="N"
		cMsg := "Motivo de Bonificação!! Quando a Forma de Pagamento é Bonificação, faz necessario informar o Motivo."
		lRet := .F.
	EndIf

	If !lRet
		Aviso("A T E N Ç Ã O",cMsg,{"OK"}) 
	EndIf



/*
	_nVlrLmt   := GetAdvFVal("SE4", "E4_INFER" ,xFilial("SE4")+_cCdPag,1)
	_cDesCdPag := GetAdvFVal("SE4", "E4_DESCRI",xFilial("SE4")+_cCdPag,1)

	For _nX := 1 To Len(_aItens)
		_nTotPed += aCols[_nX][11]
	Next _nX

	If nOpc == 3 .Or. nOpc == 4
		If Val(_cCdPag) == 901 //.And. Val(_cCdPag) <= 999
			If _nVlrLmt > _nTotPed
				cMsg2 := "Condição de Pagamento:"+Alltrim(_cCdPag)+" - "+Alltrim(_cDesCdPag)+" - Limite: "+cValToChar(_nVlrLmt)+Chr(10)+Chr(13)
				cMsg2 += Chr(10)+Chr(13)
				cMsg2 += "Total do Pedido é inferior ao limite da Codição de Pagamento"
				//cMsg2 += "Total do Pedido "+cValToChar(_nTotPed)+"é inferior ao limite da Codição de Pagamento"

				//If U_LOG("14" , transform(round(_nVlrLmt,2),"@E 99,999,999.99") , transform(round(_nTotPed,2),"@E 99,999,999.99"), ,"C",_cCodCli,,,"PED",_cPedido)
				lRet := .F.
			Else
				lRet := .T.
				//Msg := "Condição de Pagamento NÃO AUTORIZADO!!!"

			EndIF
		EndIf
	EndIF

	If !lRet
		Aviso("A T E N Ç Ã O",cMsg2,{"OK"}) 
	EndIf
*/

Return(lRet)
