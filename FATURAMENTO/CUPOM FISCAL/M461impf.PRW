#INCLUDE "protheus.ch"
User Function M461ImpF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local i:= 0
Local _i:= 0
SetPrvt("_AAREA,_AAREASC9,_AAREATRB")
SetPrvt("_CGRUPOANT,_CPEDANT,_CTIPANT,_CCLIANT,_CREAJANT,_CVENDANT")
SetPrvt("_CCONDANT,_CISSANT,_NRECANT,_LRETBEMA,_CPORTA")
SetPrvt("_CIMPRESSORA,_NDESCONTO,_NTOTAL,_NTOTDESC,_AICMS")
SetPrvt("_CNUMCUPFIS,_CNUMNOTA,_CAGREGANT,_NREG,LFIM")
SetPrvt("LMUDOUPED,_CALIQUOTA,_NALIQUOTA")
SetPrvt("I,_NEL,_CPROD,_CQUANT,_CUNIT")
SetPrvt("_CDESCONTO,_CPEDIDO,_CMENSAGEM,_CNUMPDV,_CNUMCUPFIS")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M461IMPF ³ Autor ³ Aline Correa do Vale  ³ Data ³18.07.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Cupom Fiscal na impressora de cupom fiscal       	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Verifica se e possivel imprimir cupom fiscal atraves do    	³±±
±±³          ³ MATA460 / MATA460A (SIGAFAT PADRAO)                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
iRetorno   	:= 0
cRetorno	:= ' '
_aPvlSd2   	:= ParamIXB

//+-------------------------------------------------+
//| Salva ambiente atual                            |
//+-------------------------------------------------+
_aArea:=GetArea()
dbSelectArea("SC9")
_aAreaSC9:=GetArea()
//+-------------------------------------------------+
//| Salva variavel lfim                             |
//+-------------------------------------------------+
//_lFimBack	:= lFim
_cGrupoAnt	:= SC9->C9_GRUPO
_cTipAnt	:= SC5->C5_TIPO
_cCliAnt	:= SC5->C5_CLIENTE+SC5->C5_LOJACLI
_cReajant 	:= SC5->C5_REAJUST
_cVendant 	:= SC5->C5_VEND1+SC5->C5_VEND2+SC5->C5_VEND3+SC5->C5_VEND4+SC5->C5_VEND5
_cCondAnt 	:= SC5->C5_CONDPAG
_cIssAnt	:= SC5->C5_INCISS
_nRecAnt	:= SC5->(Recno())
_cNumCupFis := Space(6)
_cNumPdv	:= Space(10)
_lRetBema 	:= .T.
_cPorta     := GetMv("MV_PORTFIS")
_cImpressora:= GetMv("MV_IMPFIS")
_nDesconto	:=	0
_nTotal   	:=	0
_nTotDesc 	:=	0
_aIcms    	:=	{}
_nRet		:=	""

If Type("nHdlECF") == "U" .Or. nHdlEcf == -1
	Public nhdlecf
	nhdlecf := IFAbrir( _cImpressora,_cPorta )
EndIf

iRet := IFStatus( nhdlecf, '5', @cRetorno )

if iRet = 7
	iRet := IFCancCup( nhdlecf )
	Inkey(8)   // dá um tempo para a impressora fazer a impressao do cancelamento
Endif

nRet := IfAbrECF( nhdlecf )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³se exitir cupom aberto, faz o cancelamento e abre um novo.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nRet <> 0
	MsgStop("Falha na comunicação com o ECF")
	Return({Space(6),.F.,""})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre o cupom fiscal                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
iRetorno := IFAbreCup(nhdlecf)
If iRetorno <> 0
	Return({Space(6),.F.,""})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tenta pegar o n£mero do cupom       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cNumCupFis := Space(6)
iRetorno := IFPegCupom( nhdlecf, @_cNumCupFis)
_cNumCupFis := StrZero(Val(_cNumCupFis),6)
_cNumNota := _cNumCupFis

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tenta pegar o n£mero do PDV         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cNumPdv  := Space(6)
iRetorno := IFPegPDV(nhdlecf, @_cNumPdv)

// Seta os indices das areas utilizadas
dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SC5")
dbSetOrder(1)

dbSelectArea("SC6")
dbSetOrder(2)

dbSelectArea("SF4")
dbSetOrder(1)

dbSelectArea("SC9")
dbGoto(_aPvlSd2[1][8])
_cPedAnt	:= SC9->C9_PEDIDO

For _i:= 1 To len(_aPvlSd2)

	If _aPvlSd2[_i][1] != _cPedAnt
		Exit
	Endif

	dbSelectArea("SB1")
	dbGoto(_aPvlSd2[_i][12])
	
	dbSelectArea("SC5")
	dbGoto(_aPvlSd2[_i][9])
	
	dbSelectArea("SF4")
	dbGoto(_aPvlSd2[_i][14])
	
	dbSelectArea("SC6")
	dbGoto(_aPvlSd2[_i][10])

	dbSelectArea("SC9")
	dbGoto(_aPvlSd2[_i][8])

   // Insere e verifica Aliquota de ICMS
	If SC6->(dbSeek(xFilial("SC6")+SC9->C9_PRODUTO+SC9->C9_PEDIDO+SC9->C9_ITEM))
		
		If SF4->F4_ISS == "S"
    		_cAliquota := 'S' + AllTrim (Str( Iif(SB1->B1_ALIQISS>0,SB1->B1_ALIQISS,GetMv("MV_ALIQISS")),5,2 ))
    		
		ElseIf SF4->F4_LFICM == "I"
			//SF4->F4_LFICM == "I"
        	_cAliquota:= "I"    // Isento
        	
		Elseif SF4->F4_LFICM == "N" .or. SF4->F4_LFICM == "O"
			_cAliquota:= "N"    // Nao sujeito a ICMS ou coluna OUTROS do livro
			
		ElseIf SB1->B1_PICMRET > 0 .And. SC5->C5_TIPOCLI == "S"
			_cAliquota:= "F"     // Substituicao tributaria (Icms Solidario)
			
		Else
			_nAliquota := AliqIcms(SC5->C5_TIPO,'S',SC5->C5_TIPOCLI)
			If SF4->F4_BASEICM > 0 .And. SF4->F4_BASEICM < 100	 // com reducao de Icms na Base
				_nAliquota:= NoRound(_nAliquota *( SF4->F4_BASEICM / 100),2)
			EndIf
			_cAliquota := StrZero(_nAliquota,5,2)
			_cAliquota := Subs(_cAliquota,1,2) + Subs(_cAliquota,4,2)
			_nAliquota := Val(StrZero(Val(_cAliquota)/1000*10,5,2))
			If Len(_aIcms) == 0
				_nRet := IfLeAliq(nhdlecf,@_cAliquota)
				For i:=1 to Len(_cAliquota)
					_nEl := At("|",_cAliquota)
					If !(_nEl > 0)
						Exit
					EndIf
					Aadd(_aIcms,Val(Substr(_cAliquota,1,_nEl-1)))
					_cAliquota := Subs(_cAliquota,_nEl+1,len(_cAliquota)-_nEl)
				Next
			EndIf
			_nEl := Ascan( _aIcms, _nAliquota )
			If _nEl == 0
				If Len(_aIcms) >= 16
					Help(" ",1,"LJ250LIMIT")
					_lRetBema:=.F.
					Exit
				Else
					Aadd(_aIcms, { _nAliquota , StrZero(Len(_aIcms)+1,2) } )
					_nRet := IfAdicAliq(nhdlecf,_cAliquota,"1")
				EndIf	
			EndIf
			// Posicao da aliquota do ICMS
			_cAliquota:= "T"+Alltrim(Str(_nAliquota,5,2))
		EndIf
	EndIf	
   	
	_cProd 	:= C9_PRODUTO
	_cQuant	:= StrZero(C9_QTDLIB,8,3)

	// Valor Unitario
	If SF4->F4_INCIDE == "F"
		_cUnit 	:= Str(C9_PRCVEN+SB1->B1_VLR_IPI,9,2)
	Else
		_cUnit 	:= Str(C9_PRCVEN,9,2)
	EndIf
	
	If (SC5->C5_TIPOCLI == "S") .And. (SF4->F4_INCSOL != "N")
		aIcmsSol := u_MODISOLI()//LjIcmsSol(C9_PRCVEN*C9_QTDLIB,C9_QTDLIB,C9_PRCVEN)
		_cUnit   := Str(Val(_cUnit) + (aIcmsSol[2]/Val(_cQuant)),9,2)
	EndIf
	
	_nTotal  := _nTotal+Round(val(_cUnit) * val(_cQuant),2)						                                                        
	
	_nDesconto := SC6->C6_VALDESC
	// Valor Unitario Desconto
	_cDesconto:= Str(_nDesconto,8,2)

	// Verifica se impressora esta ativa. para continuar e envia os comandos
	iRetorno := IFRegItem( nhdlecf,_cProd,SB1->B1_DESC,_cQuant,_cUnit,_cDesconto,_cAliquota)

Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Desconto e o Acrescimo   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*If _nTxJuros > 0
_nAcrescimo := _nValorTotal * _nTxJuros
cAcrescimo := Alltrim(Str(_nAcrescimo,14,2))
iRetorno := IFAcresTot( nHdlECF, cAcrescimo )
EndIf
*/
_cDesconto:= Alltrim(Str(0,14,2))
_nRet := IfDescTot(nhdlecf,_cDesconto)

_cPagoTotal := 'VALOR PAGO|'+Alltrim(Str(_nTotal - _nTotDesc,14,2))+ '|'

iRet := IFPagto( nhdlecf, _cPagoTotal )

//+-------------------------------------------------+
//| Obtem a Mensagem padrao a ser impressa no Cupom |
//+-------------------------------------------------+
_cPedido   := "Pedido: " + SC5->C5_NUM + CHR(10)
_cMensagem := GetMv("MV_LJFISMS")
_cMensagem := _cPedido + Substr(_cMensagem,1,480)

//+-------------------------------------------------+
//| Fecha o cupom e imprime a mensagem promocional  |
//+-------------------------------------------------+
cEstacao := _cNumPDV
IfFechaCup(nhdlecf,_cMensagem)

//+-------------------------------------------------+
//| Restaura ambiente anterior                      |
//+-------------------------------------------------+
RestArea(_aAreaSC9)
RestArea(_aArea)
//+-------------------------------------------------+
//| Restaura variavel lfim                          |
//+-------------------------------------------------+
//lFim:=_lFimBack
//	nRet := IFFechar( nhdlecf, _cPorta )

//No _cSeriePDV deve ser retornada a serie que sera gravada para este
//cupom fiscal/pdv, caso nao informe nada sera gravada a serie escolhida
//na preparacao do Cupom Fiscal
Return({_cNumNota,_lRetBema,_cNumPdv}) //,_cSeriePdv})

User Function MODISOLI()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MODISOLI  ºAutor  ³Miche Moy			 º Data ³  03/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Modificará o valor da substituição Tributária de acordo    º±±
±±º          ³ com o TES (Calculo retirado do M460SOLI)                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vinho Duelo                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
SetPrvt("_xProduto, _aIcmRet, _nSB1Ord, _nSB1Reg, _nAliqIpi, _nB1margem, _nSF7Ord")
SetPrvt("_nSF7Reg, _nAliqIcm, _nAliqExt, _nSF4Ord, _nSF4Reg, _cIncide, _nRedSub")
SetPrvt("_nPrcVen, _nQtdLib, _nValMerc, _nValTot, _nValIcm, _nBaseRet, _nValRet, _nValSubs")
SetPrvt("_cAlias, _nSA1Ord, NSA1Reg")

_cAlias := Alias()
_xProduto := SC6->C6_PRODUTO
_aIcmRet  := ""

dbSelectArea("SB1")
_nSB1Ord := IndexOrd()
_nSB1Reg := RecNo()
dbSetOrder(1)
IF dbSeek(xFilial("SB1")+_xProduto) // Procura pelo produto
	
	_lVlrIpi := .F.
   	
   	If SB1->B1_VLR_IPI > 0   //B1_VLR_IPI
    		_nIpi    := SB1->B1_VLR_IPI
    	  	_lVlrIpi := .T.
   	Else
    	  	_nIpi    := Round(SB1->B1_IPI/100,2)    
   	EndIf
	
	_nAliqIpi := SB1->B1_IPI		
	_nB1margem:= SB1->B1_PICMRET
	_lCalcRet := (_nB1margem > 0)
	
	dbSelectArea("SF7")
	_nSF7Ord := IndexOrd()
	_nSF7Reg := RecNo()
	dbSetOrder(1)
	_nAliqIcm := GETMV("MV_ICMPAD") // Retorna o Icm Padrão
	_nAliqExt := 12
	
	IF !Empty(SB1->B1_GRTRIB) .And. dbSeek(xFilial("SF7")+SB1->B1_GRTRIB+"   12") 
	                                        // Busca no arquivo de grupo de tribu
		_nAliqIcm := SF7->F7_ALIQINT        // tações aquele ao qual o produto 
		_nAliqExt := SF7->F7_ALIQEXT        // se enquadra e retorna valor do ICM
	ENDIF
	
	dbSetOrder(_nSF7Ord)
	dbGoTo(_nSF7Reg)
EndIf

dbSelectArea("SB1")
dbSetOrder(_nSB1Ord)
dbGoTo(_nSB1Reg)

dbSelectArea("SF4")
_nSF4Ord := IndexOrd()
_nSF4Reg := RecNo()
dbSetOrder(1)
_cIncide := ""
_nRedSub := 0

IF dbSeek(xFilial("SF4")+SC6->C6_TES)  // Verifica se o TES possui incidência
	_cIncide := SF4->F4_INCIDE         // de IPI na base do ICM e se existe re
	_nRedSub := SF4->F4_REDSUB         //ducao do substituto tributário
ENDIF

dbSetOrder(_nSF4Ord)
dbGoTo(_nSF4Reg)

If _lVlrIpi
	xIpi    := ROUND(SC6->C6_QTDEMP * _nIpi,2)
Else
	xIpi    := ROUND(SC6->C6_VALOR * _nIpi,2)    
EndIf    



_nPrcVen  := SC6->C6_PRCVEN
_nQtdLib  := SC6->C6_QTDEMP
_nValMerc := Round(SC6->C6_PRCVEN * SC6->C6_QTDEMP , 2)
_nValTot  := _nValMerc + (Round(IF(_cIncide == "S", xIpi, 0) , 2))
_nValIcm  := Round(_nValTot * _nAliqIcm / 100, 2)
_nBaseRet := _nValMerc + (Round(xIpi, 2))
_nBaseRet += Round(_nBaseRet * _nB1margem / 100, 2)
_nValRet  := Round(_nBaseRet * _nAliqIcm / 100, 2)
_nCrePre  := Round((_nValTot + IF(_cIncide # "S", xIpi, 0)) * _nRedSub / 100, 2)
_nValSubs := _nValRet - _nCrePre
	
If _lCalcRet
	_aIcmRet := {_nBaseRet, _nValSubs}
EndIf    
	
Return(_aIcmRet)

