#include "rwmake.ch"
#include "protheus.ch"
#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120TEL ³ Alexandre R. Bento ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campo no cabecalho do pedido ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT120TEL()
	Local oNewDialog := PARAMIXB[1]
	Local aPosGet    := PARAMIXB[2]
	Local aObj       := PARAMIXB[3]
	Local nOpcx      := PARAMIXB[4]
	Local _lAtvPA    := GetMv("US_PACOMP")
	Public _nVlrPA   := SC7->C7_VLRPA
	Public _nDtpgPA  := SC7->C7_DTPGTPA


	If nOpcx == 6
		_nVlrPA  := 0
		_nDtpgPA := CtoD("  /  /  ")
	EndIf

	If _lAtvPA
		AAdd( aTitles, 'Desconto no Boleto' )
		AAdd( aTitles, 'Transportadora:' )
		@ 64,aPosGet[1,5]-12 SAY "Vlr Adiantamento" OF oNewDialog PIXEL SIZE 060,006
		@ 61,aPosGet[1,6]-25 MSGET _nVlrPA PICTURE PesqPict("SC7","C7_VLRPA") VALID U_VldCondPA(CCONDICAO,_nVlrPA,oNewDialog) OF oNewDialog PIXEL SIZE 050,006

		@ 64,aPosGet[2,5]+120 SAY "Dt. Pgto PA" OF oNewDialog PIXEL SIZE 060,006
		@ 61,aPosGet[2,6]+85 MSGET _nDtpgPA PICTURE PesqPict("SC7","C7_DTPGTPA") VALID U_VldCdpgPA(CCONDICAO,_nDtpgPA,oNewDialog) OF oNewDialog PIXEL SIZE 050,006		

	EndIf

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120fol ³ Rafael Almeida - sigacorp    ³ Data ³ 30/11/18  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir folder no pedido de compra    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120FOL()

	Local nOpc    := PARAMIXB[1]
	Local aPosGet := PARAMIXB[2]
	Local _lAtvPA  := GetMv("US_PACOMP")
	Public _cDesctMot := SC7->C7_MOTDESC
	Public _nDesctBol := SC7->C7_VLRDESC
	Public _cC7CDTRANS := SC7->C7_CDTRANS
	Public _cC7NMTRANS := SC7->C7_NMTRANS


	If _lAtvPA
		@ 006,aPosGet[3,1] SAY OemToAnsi('Valor de Desconto :') OF oFolder:aDialogs[7] PIXEL SIZE 070,009
		@ 005,aPosGet[3,2] MSGET _nDesctBol PICTURE PesqPict('SC7','C7_VLRDESC') OF oFolder:aDialogs[7] PIXEL SIZE 080,009 HASBUTTON
		@ 020,aPosGet[3,1] SAY OemToAnsi('Motivo do Desconto :') OF oFolder:aDialogs[7] PIXEL SIZE 070,009
		@ 019,aPosGet[3,2] MSGET _cDesctMot PICTURE '@!' OF oFolder:aDialogs[7] PIXEL SIZE 205,009 HASBUTTON

		@ 006,aPosGet[3,1] SAY OemToAnsi('Código da Transportadora :') OF oFolder:aDialogs[8] PIXEL SIZE 070,009
		@ 005,aPosGet[3,2] MSGET _cC7CDTRANS F3 "SA2" PICTURE PesqPict('SC7','C7_CDTRANS') OF oFolder:aDialogs[8] PIXEL SIZE 080,009 HASBUTTON
		@ 020,aPosGet[3,1] SAY OemToAnsi('Razão Transportadora :') OF oFolder:aDialogs[8] PIXEL SIZE 070,009
		@ 019,aPosGet[3,2] MSGET _cC7NMTRANS := GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+ _cC7CDTRANS ,1) PICTURE PesqPict('SC7','C7_NMTRANS') OF oFolder:aDialogs[8] PIXEL WHEN .F. SIZE 205,009 HASBUTTON 	
	EndIf

Return Nil

/*Utilizar este ponto para gravar o campo adicionado no cabeçalho do pedido
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120TEL ³ Alexandre R. Bento ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campo no cabecalho do pedido ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function VldCondPA(CCONDICAO,_nVlrPA,oNewDialog)
	Local _lRet    := .T.
	Local _cCondPA := GetAdvFVal("SE4", "E4_CTRADT",xFilial("SE4")+CCONDICAO,1)

	If _cCondPA == "1" .And. _nVlrPA = 0  
		MsgInfo("A condição de Pagamento escolhida para esse PEDIDO requer um valor para adiantamento, Por Favor Informe o Valor do Adiantamento para o sistema.","Aviso..")
		_lRet := .F.
	EndIf
Return(_lRet)

/*Utilizar este ponto para gravar o campo adicionado no cabeçalho do pedido
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120TEL ³ Alexandre R. Bento ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campo no cabecalho do pedido ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function VldCdpgPA(CCONDICAO,_nDtpgPA,oNewDialog)
	Local _lRet    := .T.
	Local _cCondPA := GetAdvFVal("SE4", "E4_CTRADT",xFilial("SE4")+CCONDICAO,1)

	If _cCondPA == "1" .and. EMPTY(_nDtpgPA)  
		MsgInfo("A condição de Pagamento escolhida para esse PEDIDO requer uma data de pagamento, Por Favor Informe a data de pagamento ao sistema.","Aviso..")
		_lRet := .F.
	EndIf
Return(_lRet)



/*Utilizar este ponto para gravar o campo adicionado no cabeçalho do pedido
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120TEL ³ Alexandre R. Bento ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campo no cabecalho do pedido ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT120OK()
	Local _lRet := .T.
	Local _cCondPA := GetAdvFVal("SE4", "E4_CTRADT",xFilial("SE4")+CCONDICAO,1)
	Local _lAtvPA  := GetMv("US_PACOMP")

	Local _cAtvPE := SuperGetMv("US_MT110L",.T.,.T.)// Parametro Logico que valida se o ponto de entrada será utilizado.
	Local nItem
	Local nItens		:= Len( aCols )
	Local nQtdCnt		:= 0
	Local nRat	     	:= GdFieldPos( "C7_RATEIO" 	)
	Local _aItens 		:= {}
	Local _cMsgm        := ""
	Local nX            := 0 
	Local _nTotPC       := 0
	Local nPosTot       := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_TOTAL'})
	Local _nPecAdnt     := 0
	Local _aTp8Gp2      := {}
	Local _cTp8Gp2      := ""
	Local _cTp8Gp1      := ""
	Local _n22PosArra   := 0
	Local _n21PosArra   := 0
	Local _cMsg         := ""
	



	If _lAtvPA
		If INCLUI .or. ALTERA
			If _cCondPA == "1" .And. _nVlrPA = 0 .And. EMPTY(_nDtpgPA)
				MsgInfo("A condição de Pagamento escolhida para esse PEDIDO requer um valor e uma data depagamento para adiantamento, Por Favor Informe o Valor e data de pagamento do Adiantamento para o sistema.","Aviso..")
				_lRet := .F.
			ElseIf _cCondPA # "1" .And. _nVlrPA > 0 .And. !EMPTY(_nDtpgPA)
				MsgInfo("A condição de Pagamento escolhida para esse PEDIDO NÃO requer um valor e nem data de pagamento para adiantamento, Por Favor RETIRE o valor informado no campo Valor e data de pagamento do Adiantamento.","Aviso..")
				_lRet := .F.
			Else
				_lRet := .T.
			EndIf
		EndIf

		If _lRet
			If _nVlrPA > aValores[6]
				MsgInfo("O Valor do adiantamento não pode ser maior que o Valor total do Pedido.","Aviso..")
				_lRet := .F.
			EndIf
		EndIf
	EndIF


	If INCLUI .or. ALTERA
		If _cAtvPE
			If _lRet
				For nItem := 1 To nItens
					n := nItem
					If aCols[ n ][ nRat ]  == "1"  .AND. FieldPos("SCX->CXPERC")==0
						_cMsgm := "Rateio não Informado!!!"
						_lRet := .F.
					EndIf
				Next nItem

				If !_lRet
					MsgStop(_cMsgm,"Rateio")
				EndIf
			EndIf
		EndIf
	EndIf

	If INCLUI .or. ALTERA
		If _cCondPA == "1"
			_nPecAdnt := ((_nVlrPA * 100)/aValores[6])			
			_cTipCond   := GetAdvFVal("SE4", "E4_TIPO",xFilial("SE4")+CCONDICAO,1)

   			If  _cTipCond == "1" //Cond. Pagto. TIPO 1 - indica o deslocamento em dias a partir da data base

		        _aQtdPacl   := Strtokarr (GetAdvFVal("SE4", "E4_COND",xFilial("SE4")+CCONDICAO,1),",")
				_nQtdPacl   := len(_aQtdPacl)
				_nPecParcl  := (100/_nQtdPacl)

				If !(_nPecParcl == _nPecAdnt)
					_lRet := .F.
					_cMsg := "ATENÇÃO! O valor da PA difere do percentual da primeira parcela"+CRLF
					_cMsg += "da condição de pagamento."+CRLF
					_cMsg += "Por favor "+CRLF
					_cMsg += "Utilize a condição de pagamento correta."
					MsgBox(_cMsg,"Atenção","STOP")
				EndIf				

    		ElseIf _cTipCond == "2"     
		    ElseIf _cTipCond == "3"    
		    ElseIf _cTipCond == "4"    
    		ElseIf _cTipCond == "5"//Cond. Pagto. TIPO 5 - representa a carência, a quantidade de duplicatas e os vencimentos, nesta ordem, representado por valores numéricos

				_aQtdPacl   := Strtokarr (GetAdvFVal("SE4", "E4_COND",xFilial("SE4")+CCONDICAO,1),",")
				_nPecParcl  := (100/Val(_aQtdPacl[2]))

				If !(_nPecParcl == _nPecAdnt)
					_lRet := .F.
					_cMsg := "ATENÇÃO! O valor da PA difere do percentual da primeira parcela"+CRLF
					_cMsg += "da condição de pagamento."+CRLF
					_cMsg += "Por favor "+CRLF
					_cMsg += "Utilize a condição de pagamento correta."
					MsgBox(_cMsg,"Atenção","STOP")
				EndIf

    		ElseIf _cTipCond == "6"
    		ElseIf _cTipCond == "7"
    		ElseIf _cTipCond == "8"

				_cTp8Gp1    := SubStr(GetAdvFVal("SE4", "E4_COND",xFilial("SE4")+CCONDICAO,1),2)
		        _n21PosArra := AT( "[", _cTp8Gp1 )
		        _n22PosArra := RAt("]",_cTp8Gp1) 
		        _cTp8Gp2    := SubStr( _cTp8Gp1, (_n21PosArra+1) , ((_n22PosArra-1) - _n21PosArra))
		        _aTp8Gp2    := Strtokarr (_cTp8Gp2,",") 

				If !(Val(_aTp8Gp2[1]) == _nPecAdnt)
					_lRet := .F.
					_cMsg := "ATENÇÃO! O valor da PA difere do percentual da primeira parcela"+CRLF
					_cMsg += "da condição de pagamento."+CRLF
					_cMsg += "Por favor "+CRLF
					_cMsg += "Utilize a condição de pagamento correta."
					MsgBox(_cMsg,"Atenção","STOP")
				EndIf

    		ElseIf _cTipCond == "9"
    		EndIf 

		EndIf

	EndIf
Return(_lRet) 


/*Utilizar este ponto para gravar o campo adicionado no cabeçalho do pedido
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120TEL ³ Alexandre R. Bento ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campo no cabecalho do pedido ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßrafaeßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT120FIM()
	Local nOpcao    := PARAMIXB[1]      // Opção Escolhida pelo usuario  //4 - Alterar
	Local cNumPC    := PARAMIXB[2]      // Numero do Pedido de Compras
	Local nOpcA     := PARAMIXB[3]      // Indica se a ação foi Cancelada = 0  ou Confirmada = 1
	Local _cCondPA  := GetAdvFVal("SE4", "E4_CTRADT",xFilial("SE4")+CCONDICAO,1)
	Local _cCodForn := SA2->A2_COD
	Local _cLojForn := SA2->A2_LOJA
	Local _lAtvPA  := GetMv("US_PACOMP")


	If _lAtvPA
		If nOpcA == 1 .And. (nOpcao == 3 .or. nOpcao == 4 .or. nOpcao == 9)
			If _cCondPA == "1"
				DbSelectArea("SC7")
				Dbsetorder(3)
				Dbgotop()
				If DbSeek(xFilial("SC7")+ _cCodForn + _cLojForn + cNumPC,.F.)   //C7_FILIAL, C7_FORNECE, C7_LOJA, C7_NUM,
					Do While !eof() .AND. SC7->C7_FORNECE = _cCodForn .AND. SC7->C7_LOJA = _cLojForn .AND. SC7->C7_NUM = cNumPC
						RecLock("SC7",.F.)
						If _cCondPA == "1"
							SC7->C7_VLRPA   := _nVlrPA
							SC7->C7_DTPGTPA  := _nDtpgPA
							SC7->C7_VLRDESC := _nDesctBol
							SC7->C7_MOTDESC := _cDesctMot
						EndIf
						MsUnlock("SC7")
						dbskip()
					Enddo
				Endif
			Else
				DbSelectArea("SC7")
				Dbsetorder(3)
				Dbgotop()
				If DbSeek(xFilial("SC7")+ _cCodForn + _cLojForn + cNumPC,.F.)   //C7_FILIAL, C7_FORNECE, C7_LOJA, C7_NUM,
					Do While !eof() .AND. SC7->C7_FORNECE = _cCodForn .AND. SC7->C7_LOJA = _cLojForn .AND. SC7->C7_NUM = cNumPC
						RecLock("SC7",.F.)
						SC7->C7_VLRDESC := _nDesctBol
						SC7->C7_MOTDESC := _cDesctMot
						SC7->C7_VLRPA   := 0
						SC7->C7_DTPGTPA := CtoD("  /  /  ")						
						MsUnlock("SC7")
						dbskip()
					Enddo
				Endif
			EndIf
		EndIf
	EndIf
Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120TEL ³ Alexandre R. Bento ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campo no cabecalho do pedido ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT094LOK()
	Local aArea := GetArea()
	Local _lRt      := .T.
	Local _cCondPg  := ""
	Local _cNumPc   := SCR->CR_NUM
	Local _UsrCod   := UsrFullName(RetCodUsr())
	Local _cSE4PA   := ""
	Local _cUsrSol  := ""
	Local _nValorPA := ""
	Local _nYesNo   := 0
	Local _CdAprod  := RetCodUsr()
	Local _lAtvPA  := GetMv("US_PACOMP")

	If _lAtvPA
		dbSelectArea("SC7")
		dbSetOrder(1)
		MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))

		_cSE4PA   := SC7->C7_COND
		_cUsrSol  := UsrFullName(SC7->C7_USER)
		_nValorPA := SC7->C7_VLRPA
		_cNumSC   := SC7->C7_NUMSC
		_cItemSC  := SC7->C7_ITEMSC

		_cCondPg  := GetAdvFVal("SE4", "E4_CTRADT",xFilial("SE4")+_cSE4PA,1)

		If _cCondPg == "1"
			_nYesNo := MessageBox("Prezado Sr. "+ Alltrim(_UsrCod)  +", para este PEDIDO - "+Alltrim(_cNumPc)+", existe uma solicitação de PAGAMENTO ANTECIPADO no valor de R$"+ Transform(_nValorPA, "@E 99,999.99" )  +"."+ Chr(13)+Chr(10),"Solicitação PA",0)
			/*
			If _nYesNo == 7
			_lRt := .F.
			U_WFNoPA(_cNumPc,_CdAprod)
			EndIf
			*/
		EndIf
	EndIf
	RestArea(aArea)
Return(_lRt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120TEL ³ Alexandre R. Bento ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campo no cabecalho do pedido ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120TEL ³ Alexandre R. Bento ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campo no cabecalho do pedido ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT094END()
Local cDocto    := PARAMIXB[1]
Local cTipoDoc  := PARAMIXB[2]
Local nOpcao    := PARAMIXB[3]
Local cFilDoc   := PARAMIXB[4]
Local _cFornec  := ""  //GetAdvFVal("SC7", "C7_FORNECE",xFilial("SC7") + cDocto + "0001" + Space(4),1)//SA2->A2_COD
Local _cLojFor  := ""  //GetAdvFVal("SC7", "C7_LOJA"   ,xFilial("SC7") + cDocto + "0001" + Space(4),1)//SA2->A2_LOJA
Local _cNaturez := ""  //GetAdvFVal("SA2", "A2_NATUREZ",xFilial("SA2") + _cFornec + _cLojFor,1)
Local _HistSE2  := ""
Local aArray    := {}
//Local _dDtEmis  := Date()
Local _dDtEmis  := dDataBase
Local _nDtpgPA  := "" //GetAdvFVal("SC7", "C7_DTPGTPA",xFilial("SC7") + cDocto + "0001" + Space(4),1)
Local _nVlrPA   := 0  // GetAdvFVal("SC7", "C7_VLRPA",  xFilial("SC7") + cDocto + "0001" + Space(4),1)
Local _cCoddPg  := "" // GetAdvFVal("SC7", "C7_COND",   xFilial("SC7") + cDocto + "0001" + Space(4),1)
Local _cCondPg  := "" //GetAdvFVal("SE4", "E4_CTRADT", xFilial("SE4") + _cCoddPg,1)
Local _cCodApro := RetCodUsr()
Local _lAtvPA  := GetMv("US_PACOMP")
Local _cObsSCR := ""
Local _vldSC7 := .T.
Private lMsErroAuto := .F.

If _lAtvPA

	cQrySC7 := " "
	cQrySC7 += " 	SELECT "
	cQrySC7 += " 	 C7_FORNECE "
	cQrySC7 += " 	,C7_LOJA "
	cQrySC7 += " 	,A2_NATUREZ "
	cQrySC7 += " 	,C7_DTPGTPA "
	cQrySC7 += " 	,C7_VLRPA "
	cQrySC7 += " 	,C7_COND "
	cQrySC7 += " 	,E4_CTRADT "						
	cQrySC7 += " 	FROM "+ RETSQLNAME("SC7")+" C7  "
	cQrySC7 += " 	INNER JOIN "+ RETSQLNAME("SA2")+" A2  "
	cQrySC7 += " 	ON A2_COD+A2_LOJA = C7_FORNECE+C7_LOJA AND A2.D_E_L_E_T_ = '' "								
	cQrySC7 += " 	INNER JOIN "+ RETSQLNAME("SE4")+" E4  "
	cQrySC7 += " 	ON E4_CODIGO = C7_COND AND E4.D_E_L_E_T_ = '' "
	cQrySC7 += " 	WHERE C7.D_E_L_E_T_ <> '*'      "
	cQrySC7 += " 	AND C7_FILIAL = '"+ xFilial("SC7") +"'	"
	cQrySC7 += " 	AND C7_NUM = '"+ Alltrim(cDocto) +"'	"
	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQrySC7) , "DOCSC7" , .T. , .F.)


	DBSelectArea("DOCSC7")
	DOCSC7->(DbGoTop())
	While !DOCSC7->(Eof())
		If _vldSC7
		_cFornec  := DOCSC7->C7_FORNECE
		_cLojFor  := DOCSC7->C7_LOJA 
		_cNaturez := DOCSC7->A2_NATUREZ
		_nDtpgPA  := StoD(DOCSC7->C7_DTPGTPA)
		_nVlrPA   := DOCSC7->C7_VLRPA
		_cCoddPg  := DOCSC7->C7_COND
		_cCondPg  := DOCSC7->E4_CTRADT
		_vldSC7 := .F.
		EndIf		
		DOCSC7->(DbSkip())
	EndDo
	DOCSC7->( DBCloseArea())


	
	cQuery := " "
	cQuery += " 	SELECT "
	cQuery += " 	CONVERT(VARCHAR(1000),CR_OBS)  AS CR_OBS "
	cQuery += " 	FROM "+ RETSQLNAME("SCR")+"  "
	cQuery += " 	WHERE D_E_L_E_T_ <> '*'      "
	cQuery += " 	AND CR_FILIAL = '"+ xFilial("SCR") +"'	"
	cQuery += " 	AND CR_NUM = '"+ Alltrim(cDocto) +"'	"
	If cValToChar(nOpcao)$"1/3/"
		cQuery += " 	AND CR_STATUS = '03' "
	ElseIf cValToChar(nOpcao)$"2/5/6/"
		cQuery += " 	AND CR_STATUS = '04' "
	EndIf
	cQuery += " 	ORDER BY R_E_C_N_O_ DESC      "
	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "DOC" , .T. , .F.)
	
	//CR_STATUS = '3' - APROVADO
	//CR_STATUS = '4' - REPROVADO
	
	DBSelectArea("DOC")
	DOC->(DbGoTop())
	While !DOC->(Eof())
		
		_cObsSCR := DOC->CR_OBS
		
		DOC->(DbSkip())
	EndDo
	DOC->( DBCloseArea())
	
	
	
	
	If _cCondPg == "1"
		If cValToChar(nOpcao)$"1/3/"
			aAdd(aArray,{ "E2_PREFIXO" , "ANT" , NIL })
			aAdd(aArray,{ "E2_NUM"     , cTipoDoc+cDocto , NIL })
			aAdd(aArray,{ "E2_TIPO"    , "PA"      , NIL })
			aAdd(aArray,{ "E2_NATUREZ" , _cNaturez , NIL })
			aAdd(aArray,{ "E2_FORNECE" , _cFornec  , NIL })
			aAdd(aArray,{ "E2_LOJA"    , _cLojFor  , NIL })
			aAdd(aArray,{ "E2_EMISSAO" , _dDtEmis  , NIL })
			aAdd(aArray,{ "E2_VENCTO"  , _nDtpgPA  , NIL })
			aAdd(aArray,{ "E2_VENCREA" , _nDtpgPA  , NIL })
			aAdd(aArray,{ "E2_VALOR"   , _nVlrPA   , NIL })
			aAdd(aArray,{ "AUTBANCO"   , "PA"      , NIL })
			aAdd(aArray,{ "AUTAGENCIA" , "00000"   , NIL })
			aAdd(aArray,{ "AUTCONTA"   , "0000000000" , NIL })
			
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
			
			
			If lMsErroAuto
				MostraErro()
			Else
				DbSelectArea("FIE")
				ReClock("FIE", .T.)
				FIE->FIE_FILIAL :=  xFilial("FIE")   // Retorna a filial de acordo com as configurações do ERP Protheus
				FIE->FIE_CART   := "P"
				FIE->FIE_PEDIDO := cDocto
				FIE->FIE_PREFIX := "ANT"
				FIE->FIE_NUM    := cTipoDoc+cDocto
				FIE->FIE_PARCEL := ""
				FIE->FIE_TIPO   := "PA"
				FIE->FIE_CLIENT := ""
				FIE->FIE_FORNEC := _cFornec
				FIE->FIE_LOJA   := _cLojFor
				FIE->FIE_VALOR  := _nVlrPA
				FIE->FIE_SALDO  := _nVlrPA
				MsUnlock()
				MsgInfo("Título de adiantamento incluído com sucesso! PA: "+ Alltrim(cTipoDoc+cDocto) )
				
				U_WFYesPA(cDocto,_cCodApro,_cObsSCR,_cCoddPg)
				
			Endif
		ElseIf cValToChar(nOpcao)$"2/5/6/"
			U_WFNoPA(cDocto,_cCodApro,_cObsSCR,_cCoddPg)
		EndIf
	Else
		If cValToChar(nOpcao)$"1/3/"
			U_WFYesPC(cDocto,_cCodApro,_cObsSCR,_cCoddPg)
		ElseIf cValToChar(nOpcao)$"2/5/6/"
			U_WFNoPC(cDocto,_cCodApro,_cObsSCR,_cCoddPg)
		EndIf
	EndIf
EndIf
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120TEL ³ Alexandre R. Bento ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campo no cabecalho do pedido ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FA100ROT()
	Local aRotina := aClone(PARAMIXB[1])
	Local _lAtvPA  := GetMv("US_PACOMP")

	If _lAtvPA
		aAdd( aRotina, { 'Transf. Bco. PA' ,'U_TRANSBCOPA', 0 , 7 })
	EndIf

Return(aRotina)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120TEL ³ Alexandre R. Bento ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campo no cabecalho do pedido ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TRANSBCOPA()
	Local oFont1 := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
	Local oFont3 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
	Local oGet1
	Local dDtPg := Date()
	Local oGet2
	Local cBco := Space(3)
	Local oGet3
	Local cAge := Space(5)
	Local oGet4
	Local cCta := Space(10)
	Local oGet5
	Local cNome := Space(15)
	Local oGet6
	Local cTip := E5_TIPO
	Local oGet7
	Local cPrx := E5_PREFIXO
	Local oGet8
	Local cTit := E5_NUMERO
	Local oGroup1
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSay7
	Local oSay8
	Local oSButton1
	Local aTFINA100 := {}
	Local _cLojSe2 := E5_LOJA
	Local _cForSe2 := E5_CLIFOR
	Local _cParSe2 := E5_PARCELA
	Local _cNumSe2 := E5_NUMERO
	Local _cPrfSe2 := E5_PREFIXO
	Local _nVlrSe2 := E5_VALOR
	Local _cTipSe2 := E5_TIPO
	Local _cBenSe2 := E5_BENEF
	Local _cBcoSe5 := E5_BANCO
	Local _cAgeSe5 := E5_AGENCIA
	Local _cCtbSe5 := E5_CONTA
	Local _cNatSe5 := E5_NATUREZ
	Local _cFlagPA := E5_FLAGPA
	Local _lOk := .F.
	Static oDlg
	Private lMsErroTAuto := .F.


	If Alltrim(_cTipSe2) == 'PA'
		If _cFlagPA=="S"
			Alert("Para título PA ("+ Alltrim(_cNumSe2) +" já foi realizado a Manutenção PA","Alerta")
			Return()
		EndIf

		DbSelectArea("SE2")
		Dbsetorder(1)
		Dbgotop()
		If DbSeek(xFilial("SE2")+ _cPrfSe2 + _cNumSe2 + _cParSe2 + _cTipSe2 + _cForSe2 + _cLojSe2 ,.F.)

			If !Empty(SE2->E2_BAIXA)
				Alert("O título PA ("+ Alltrim(_cNumSe2) +" já encontra-se Compensado no dia "+ DTOC(SE2->E2_BAIXA) +", Impossível realizar essa operação.","Alerta")
				Return()
			Else

				DEFINE MSDIALOG oDlg TITLE "Manutenção de PA" FROM 000, 000  TO 250, 300 COLORS 0, 16777215 PIXEL

				@ 004, 006 GROUP oGroup1 TO 118, 142 PROMPT "  INFO. PAGAMENTO  " OF oDlg COLOR 16711680, 16777215 PIXEL
				@ 015, 012 SAY oSay6 PROMPT "PREFIX" SIZE 024, 007 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
				@ 015, 040 SAY oSay7 PROMPT "TITULO" SIZE 025, 007 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
				@ 015, 103 SAY oSay8 PROMPT "TIPO" SIZE 019, 007 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
				@ 040, 011 SAY oSay4 PROMPT "DATA DE PAGAMENTO" SIZE 063, 007 OF oDlg FONT oFont3 COLORS 16711680, 16777215 PIXEL
				@ 052, 011 SAY oSay1 PROMPT "BANCO" SIZE 023, 007 OF oDlg FONT oFont3 COLORS 16711680, 16777215 PIXEL
				@ 052, 038 SAY oSay2 PROMPT "AGENCIA" SIZE 025, 007 OF oDlg FONT oFont3 COLORS 16711680, 16777215 PIXEL
				@ 052, 070 SAY oSay3 PROMPT "CONTA" SIZE 020, 007 OF oDlg FONT oFont3 COLORS 16711680, 16777215 PIXEL
				@ 077, 011 SAY oSay5 PROMPT "NOME" SIZE 020, 007 OF oDlg FONT oFont3 COLORS 16711680, 16777215 PIXEL
				@ 023, 012 MSGET oGet7 VAR cPrx SIZE 022, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
				@ 023, 040 MSGET oGet8 VAR cTit SIZE 053, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
				@ 023, 103 MSGET oGet6 VAR cTip SIZE 022, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
				@ 038, 076 MSGET oGet1 VAR dDtPg SIZE 055, 010 OF oDlg COLORS 0, 16777215 PIXEL
				@ 062, 011 MSGET oGet2 VAR cBco F3 "SA6PA" PICTURE "@!" VALID CodSA6(cBco,@cAge,@cCta,@cNome) SIZE 019, 010 OF oDlg COLORS 0, 16777215 PIXEL
				@ 062, 038 MSGET oGet3 VAR cAge SIZE 031, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
				@ 062, 070 MSGET oGet4 VAR cCta SIZE 062, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
				@ 085, 011 MSGET oGet5 VAR cNome SIZE 120, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
				DEFINE SBUTTON oSButton1 FROM 102, 108 TYPE 01 ACTION (_lOk:=.T.,oDlg:End())OF oDlg ENABLE

				ACTIVATE MSDIALOG oDlg CENTERED





				If _lOk

					RecLock("SE5",.F.)
					SE5->E5_FLAGPA := "S"
					MsUnlock("SE5")


					aTFINA100 := { {"CBCOORIG" ,cBco ,Nil},;
					{"CAGENORIG"  ,cAge ,Nil},;
					{"CCTAORIG"   ,cCta ,Nil},;
					{"CNATURORI"  ,_cNatSe5 ,Nil},;
					{"CBCODEST"   ,_cBcoSe5 ,Nil},;   //_cBcoSe5
					{"CAGENDEST"  ,_cAgeSe5 ,Nil},;   //_cAgeSe5
					{"CCTADEST"   ,_cCtbSe5 ,Nil},;      //_cCtbSe5
					{"CNATURDES"  ,_cNatSe5 ,Nil},;
					{"CTIPOTRAN"  ,"R$" ,Nil},;
					{"CDOCTRAN"   ,_cNumSe2 ,Nil},;
					{"NVALORTRAN" ,_nVlrSe2 ,Nil},;
					{"CHIST100"   ,"TRANSF BANCARIA REF. TIT."+ Alltrim(_cPrfSe2)+"/"+Alltrim(_cNumSe2) ,Nil},;
					{"CBENEF100"  ,_cBenSe2 ,Nil} }

					MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aTFINA100,7)

					If lMsErroTAuto
						MostraErro()
					Else
						MsgAlert("Transferência executada com sucesso !!!")

						RecLock("SE2",.F.)
						SE2->E2_FLAGPA := "S"
						MsUnlock("SE2")
					EndIf

				EndIf
			EndIf
		EndIf
	Else
		Alert("O título selecionado não é um Pagamento antecipado (PA)","Alerta")
	EndIf

Return()


//+--------------------------------------------------------------------+
//| Rotina | Mod2Vend | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar o código do vendedor. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
Static Function CodSA6( cBco, cAge, cCta, cNome)

	If ExistCpo("SA6",cBco)
		//	cAge  := Posicione("SA6",1,xFilial("SA6")+cBco,"A6_AGENCIA")
		//	cCta  := Posicione("SA6",1,xFilial("SA6")+cBco,"A6_NUMCON")
		cNome := Posicione("SA6",1,xFilial("SA6")+cBco+cAge+cCta,"A6_NREDUZ")
	Endif

Return(!Empty( cBco, cAge, cCta, cNome))


//+--------------------------------------------------------------------+
//| Rotina | Mod2Vend | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar o código do vendedor. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacitação. |
//+--------------------------------------------------------------------+
User Function  FC030ROT()
	Local _lAtvPA  := GetMv("US_PACOMP")

	If _lAtvPA
		aadd(aRotina,{"Impressao P.A.","U_Fc030IpPA", 0 , 4})
	EndIf

Return aRotina


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ MT120TEL ³ Alexandre R. Bento ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campo no cabecalho do pedido ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe ³ Chamada padrao para programas em RDMake. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FA100VET()
	//Local _aArea := GetArea()
	Local _lRet := .T.
	Local _cBcoSe5 := E5_BANCO
	Local _cAgeSe5 := E5_AGENCIA
	Local _cCtbSe5 := E5_CONTA
	Local _cNatSe5 := E5_NATUREZ
	Local _DocmSE5 := E5_DOCUMEN
	Local _nvlrSE5 := E5_VALOR
	Local _ParcSE5 := E5_PARCELA



	If _lRet
		BEGIN TRANSACTION
			cUpdate := " "
			cUpdate += " UPDATE "+RetSQLName("SE5")+" "
			cUpdate += " 	SET E5_FLAGPA = '' "
			cUpdate += " WHERE 	E5_FILIAL  = '"+ xFilial("SE5")   +"'  "
			cUpdate += " 	AND	E5_NUMERO  = '"+Alltrim(_DocmSE5) +"'  "
			cUpdate += " 	AND	E5_PREFIXO = 'ANT'  "
			cUpdate += " 	AND	E5_TIPO    = 'PA'  "
			cUpdate += " 	AND	E5_BANCO   = '"+Alltrim(_cBcoSe5) +"'  "
			cUpdate += " 	AND	E5_AGENCIA = '"+Alltrim(_cAgeSe5) +"'  "
			cUpdate += " 	AND	E5_CONTA   = '"+Alltrim(_cCtbSe5) +"'  "
			cUpdate += " 	AND	E5_FLAGPA  = 'S'  "
			cUpdate += " 	AND	D_E_L_E_T_ <> '*'             "
			TcSqlExec(cUpdate)
			TcSqlExec("COMMIT")
		END TRANSACTION

		BEGIN TRANSACTION
			cUpdate := " "
			cUpdate += " UPDATE "+RetSQLName("SE2")+" "
			cUpdate += " 	SET E2_FLAGPA = '' "
			cUpdate += " WHERE 	E2_FILIAL  = '"+ xFilial("SE2")   +"'  "
			cUpdate += " 	AND	E2_NUM  = '"+Alltrim(_DocmSE5) +"'  "
			cUpdate += " 	AND	E2_PREFIXO = 'ANT'  "
			cUpdate += " 	AND	E2_TIPO    = 'PA'  "
			cUpdate += " 	AND	E2_FLAGPA  = 'S'  "
			cUpdate += " 	AND	D_E_L_E_T_ <> '*'             "
			TcSqlExec(cUpdate)
			TcSqlExec("COMMIT")
		END TRANSACTION
	EndIf
	//ResetArea(_aArea)

Return (_lRet)
