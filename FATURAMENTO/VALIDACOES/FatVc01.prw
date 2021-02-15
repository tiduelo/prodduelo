#include "Rwmake.ch"
#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATVC01   ³Autor  ³Henio Brasil        ³ Data ³ 06/11/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao na coluna especifica do pedido para tratar lote   º±±
±±º          ³de Prdutos Acabados.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Totvs Para                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FATVC01(nIt)

Local aArea		 := GetArea()
Local cField 	 := ReadVar()	// Para perguntar em qual campo estou!
Local aAreaF4	 := SF4->(GetArea())
Local nPItem	 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"    })
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
Local nPLocal	 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"   })
Local nPLoteCtl := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTENEW" })		// "C6_LOTECTL"
Local nPLoteOri := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL" })
Local nPNumLote := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE" })
Local nPDtValid := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DTVALID" })
Local nPQtdLib	 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"  })
Local nPQtdVen	 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"  })
Local nPTes		 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"     })
Local nPPrcVen	 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"  })
Local nPPrcLis  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"  })
Local nPDescon	 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT" })

Local nVlrTabela:= 0
Local aAreaSB8	:= {}
Local cProduto	:= aCols[n][nPProduto]
Local cLocal	:= aCols[n][nPLocal]
Local cNumLote	:= ""
Local cLoteCtl := ""
Local cCliTab  := ""
Local cLojaTab := ""
Local nQtdLib	:= aCols[n,nPQtdLib]
Local lRetorna := .T.
Local nSaldo	:= 0
Local lGrade 	:= MaGrade()
Local lTabCli  := (SuperGetMv("MV_TABCENT",.F.,"2") == "1")

//ALERT(ReadVar())
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Valida se a chamada da funcao foi efetuada da coluna C6_LOTENEW         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
// MsgAlert("FATVC01 - Campo acionado no momento: "+cField)
If Left(cField,5)=="M->C5"
	Return(.T.)
Endif

If cField <> "M->C6_LOTENEW" 		// aCols[n][nPLoteCtl]
	// MsgAlert("Estou em outro Campo do item: "+cField)
	Return(.T.)
Endif

IF EMPTY(aCols[n][nPTes])
     alert("Obrigatorio informar a Tes")
	  Return(.T.)
Endif


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Variaveis Privates utilizadas na  funcao  F4Lote                        ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
nPosLote        := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"})
nPosLotOri      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
nPosLotCtl      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTENEW"})
nPosDValid      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DTVALID"})
nPosPotenc      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_POTENCI"})

// F4Lote(,,,"A440",cProduto,cLocal)

Vc01LoteShow(,,,"A440",cProduto,cLocal)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem conteudo do Lote e do Sub-Lote                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Upper(ALLTRIM(Readvar())) == "M->C6_LOTENEW"	// C6_LOTECTL"
	cNumLote	:= aCols[n][nPNumLote]
	cLoteCtl 	:= &(ReadVar())
ElseIf Upper(ALLTRIM(Readvar())) == "M->C6_NUMLOTE"
	cNumLote	:= &(ReadVar())
	cLoteCtl 	:= aCols[n][nPLoteCtl]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se Movimenta Estoque                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


dbSelectArea("SF4")
dbSetOrder(1)

If ( MsSeek(xFilial("SF4")+aCols[n][nPTes]) .And. SF4->F4_ESTOQUE=="N" )

	If !Empty(aCols[n][nPLoteCtl]+aCols[n][nPNumLote])
		Help(" ",1,"A410TEEST")
		lRetorna := .F.
	EndIf

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o Produto eh uma referencia                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  ( lRetorna .And. lGrade )
	If ( MatGrdPrrf(cProduto) )
		Help(" ",1,"A410NGRADE")
		lRetorna := .F.
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o Produto possui rastreabilidade                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lRetorna .And. !Rastro(cProduto) )
	If (!Empty(&(ReadVar())))
		Help( " ", 1, "NAORASTRO" )
		aCols[n,nPNumLote] 	:= CriaVar( "C6_NUMLOTE" )
		aCols[n,nPLoteCtl]	:= CriaVar( "C6_LOTENEW" )		// "C6_LOTECTL"
		aCols[n,nPDtValid]	:= CriaVar( "C6_DTVALID" )
		lRetorna := .F.
	Else
		aCols[n,nPNumLote]	:= CriaVar( "C6_NUMLOTE" )
		aCols[n,nPLoteCtl]	:= CriaVar( "C6_LOTENEW" )		// "C6_LOTECTL"
		aCols[n,nPDtValid]	:= CriaVar( "C6_DTVALID" )
	EndIf
Else
	If ( lRetorna ) .And. (!Empty(ReadVar()))
		nSaldo := SldAtuEst(cProduto,cLocal,nQtdLib,cLoteCtl)
		
		If ALTERA .And. AtIsRotina("MATA410")
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+M->C5_NUM+aCols[n,nPItem]+aCols[n,nPProduto])
			nSaldo += SC6->C6_QTDEMP
		Endif
		
		If ( nQtdLib > nSaldo )
			Help(" ",1,"A440ACILOT")
			lRetorna  := .F.
		EndIf
		
		If lRetorna
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso lote exista, obtem a data de validade                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAreaSB8 := GetArea()
			SB8->(dbSetOrder(3))
			If SB8->(dbSeek(xFilial("SB8")+cProduto+cLocal+cLoteCtl+IF(Rastro(cProduto,"S"),cNumLote,"")))
				If aCols[n, nPDtValid] # SB8->B8_DTVALID
					If Type('lMSErroAuto') <> 'L'
						Help(" ",1,"A240DTVALI")
					EndIf
					M->C6_DTVALID		:= SB8->B8_DTVALID
					aCols[n,nPDtValid]	:= SB8->B8_DTVALID
				EndIf
				// Verifica se a posicao da quantidade esta alimentada, caso NAO preenche agora:
				If Empty(aCols[n][nPQtdVen])
					aCols[n][nPQtdVen]:= SB8->B8_SALDO
				Endif
			Endif
			RestArea(aAreaSB8)
		EndIf
	EndIf
EndIf

If lRetorna
	If lTabCli
		Do Case
			Case !Empty(M->C5_LOJAENT) .And. !Empty(M->C5_CLIENT)
				cCliTab   := M->C5_CLIENT
				cLojaTab  := M->C5_LOJAENT
			Case Empty(M->C5_CLIENT)
				cCliTab   := M->C5_CLIENTE
				cLojaTab  := M->C5_LOJAENT
			OtherWise
				cCliTab   := M->C5_CLIENTE
				cLojaTab  := M->C5_LOJACLI
		EndCase
	Else
		cCliTab   := M->C5_CLIENTE
		cLojaTab  := M->C5_LOJACLI
	Endif
	
	nVlrTabela := A410Tabela(cProduto,M->C5_TABELA,n,aCols[n][nPQtdVen],cCliTab,cLojaTab,cLoteCtl,cNumLote,.T.)
	If nVlrTabela <> 0
		aCols[n][nPPrcVen] := A410Arred(FtDescCab(nVlrTabela,{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4})*(1-(aCols[n][nPDescon]/100)),"C6_PRCVEN")
		aCols[n][nPPrcLis] := nVlrTabela
		A410MultT("C6_PRCVEN",aCols[n][nPPrcVen])
	Endif
	// msgalert(" Vai dar ENTER ")
	// WinExec(CHR(10)+CHR(13))
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Entrada da Rotina                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaF4)
RestArea(aArea)
Return(lRetorna)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Vc01LoteShow³Autor  ³Henio Brasil       ³ Data ³ 03/10/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Programa para apresentar tela de Saldos por Lote conforme   º±±
±±º          ³programa padrao Protheus: F4Lote()                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Totvs Para                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Vc01LoteShow(a,b,c,cProg,cCod,cLocal,lParam,cLocaliz,nLoteCtl,cOP) 	// F4Lote(a,b,c,cProg,cCod,cLocal,lParam,cLocaliz,nLoteCtl,cOP)

Local aStruSB8	:={}
Local aArrayF4	:={}
Local aHeaderF4	:={}
Local aRetPE	:= {}
Local nOpt1 	:= 1,nX, cVar, cSeek, cWhile, nEndereco
Local cAlias	:= Alias(), nOrdem := IndexOrd(), nRec := RecNo(), nValA440 :=	0
Local nHdl  	:= GetFocus(),cCpo
Local oDlg2,cCadastro,nOpca
Local cLoteAnt	:="",cLoteFor:="",dDataVali:="",dDataCria:=""
Local lAdd		:=.F.,nSalLote:=0, nSalLote2:=0,nPotencia:=0
Local nPos2		:=7,nPos3:=5,nPos4:=9,nPos5:=10,nPos6:=11,nPos7:=12,nPos8:=13
Local aTamSX3	:={}, nOAT
Local aCombo1	:= {"Lote ","Validade ","Lote Fornecedor"} 		// {STR0018,STR0016,STR0017}
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := MsAdvSize(.F.)
Local cCombo1	:= ""
Local oCombo1
Local lRastro 	:= Rastro(cCod,"S")
Local aAreaSBF	:={}
Local cQuery    := ""
Local lQuery    := .F.
Local cAliasSB8 := "SB8"
Local nLoop     := 0
Local aUsado    := {}
Local cLote241  := ''
Local cSLote241 := ''
Local lLote     := .F.
Local lSLote    := .F.
Local nPos      := 0
Local nPCod241  := 0
Local nPLoc241  := 0
Local nPLote241 := 0
Local nPSLote241:= 0
Local nQuant241 := 0
Local nPQuant241:= 0
Local nPCod261  := 0
Local nPLoc261  := 0
Local nPosLt261 := 0
Local nPSlote261:= 0
Local nQuant261 := 0
Local nPosQuant := 0
Local nPosQtdLib:= 0
Local nMultiplic:= 1
Local lRet 		:= .T.
Local lSelLote 	:= (SuperGetMV("MV_SELLOTE") == "1")
Local lExistNF 	:= SB7->(FieldPos("B7_NUMDOC")) <> 0
Local lMTF4Lote	:= .T.
Local cNumDoc  	:= ""
Local cSerie   	:= ""
Local cFornece 	:= ""
Local cLoja    	:= ""
Local lEmpPrev 	:= If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
Local nSaldoCons:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MV_VLDLOTE - Utilizado para visualizar somente os lotes que  |
//| possuem o campo B8_DATA com o valor menor ou igual a database|
//| do sistema                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lVldDtLote:= SuperGetMV("MV_VLDLOTE",.F.,.T.)

Default cLocaliz:= ""
Default nLoteCtl:= 1
Default cOP     := ""

cCpo 	:= ReadVar()
lParam 	:= IIf(lParam== NIL, .T., lParam)
SB1->(dbSetOrder(1))
SB1->(MsSeek(xFilial("SB1")+cCod))
lLote  	:= Rastro(cCod)
lSLote 	:= Rastro(cCod, 'S')
If !lLote
	Help(" ",1,"NAORASTRO")
	Return nil
Endif
If !lRastro
	nPos2:=1;nPos3:=5;nPos4:=8;nPos5:=9;nPos6:=10;nPos7:=11;nPos8:=12
EndIf
If (cProg == "A240" .Or. cProg == "A241") .And. cCpo != "M->D3_NUMLOTE" .And. cCpo != "M->D3_LOTECTL"
	Return nil
Endif
If cProg == "A100"
	If cTipo != "D"
		Return Nil
	Endif
Endif
If cProg == "A440" .And. cCpo != "M->C6_NUMLOTE" .And. cCpo != "M->C6_LOTENEW"		// "M->C6_LOTECTL"
	Return Nil
Endif
If cProg == "A240"
	IF  M->D3_TM <= "500" .and. SF5->F5_APROPR != "S" .And. SB1->B1_APROPRI == "I"
		cLocal := GETMV("MV_LOCPROC")
	Endif
Endif
If cProg == "A241"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o array aUsado com os Lotes ja digitados no aCols ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nMultiplic := If(cTM<='500',1,-1)
	For nX := 1 To Len(aHeader)
		If '_COD'         == Right(AllTrim(aHeader[nX, 2]), 4)
			nPCod241   := nX
		ElseIf '_LOCAL'   == Right(AllTrim(aHeader[nX, 2]), 6)
			nPLoc241   := nX
		ElseIf '_LOTECTL' == Right(AllTrim(aHeader[nX, 2]), 8)
			cLote241   := aCols[n, nX]
			nPLote241  := nX
		ElseIf '_NUMLOTE' == Right(AllTrim(aHeader[nX, 2]), 8)
			cSLote241  := aCols[n, nX]
			nPSlote241 := nX
		ElseIf '_QUANT'   == Right(AllTrim(aHeader[nX, 2]), 6)
			nQuant241  := aCols[n, nX]
			nPQuant241 := nX
		EndIf
	Next nX
	For nX := 1 To Len(aCols)
		If !(nX==n) .And. If(ValType(aCols[nX,Len(aCols[nX])])=='L', !aCols[nX,Len(aCols[nX])], .T.)
			If aCols[nX, nPCod241] == cCod .And. aCols[nX,nPLoc241] == cLocal
				If (nPos:=aScan(aUsado, {|x| x[1] == aCols[nX,nPLote241] .And. If(lSLote, x[2]==aCols[nX, nPSlote241], .T.)})) == 0
					aAdd(aUsado, {aCols[nX, nPLote241], aCols[nX, nPSlote241], (aCols[nX, nPQuant241]*nMultiplic)})
				Else
					aUsado[nPos, 3] += (aCols[nX, nPQuant241]*nMultiplic)
				EndIf
			EndIf
		EndIf
	Next nX
	IF  cTm <= "500" .and. SF5->F5_APROPR != "S" .And. SB1->B1_APROPRI == "I"
		cLocal := GETMV("MV_LOCPROC")
	Endif
Endif
If cProg == "A261" // Transferencia interna mod. II
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o array aUsado com os Lotes ja digitados no aCols ³
	//³ Importante: A rotina MATA261 utiliza posicoes fixas no aCols ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	// Localiza as saidas do lote
	nPCod261   := 1  // Produto origem
	nPLoc261   := 4  // Local origem
	nPosLt261  := 12 // Lote
	nPSlote261 := 13 // Sub-lote
	nQuant261  := 16 // Quantidade
	For nX := 1 To Len(aCols)
		If !(nX==n) .And. If(ValType(aCols[nX,Len(aCols[nX])])=='L', !aCols[nX,Len(aCols[nX])], .T.)
			If aCols[nX, nPCod261] == cCod .And. aCols[nX,nPLoc261] == cLocal
				If (nPos:=aScan(aUsado, {|x| x[1] == aCols[nX,nPosLt261] .And. If(lSLote, x[2]==aCols[nX, nPSlote261], .T.)})) == 0
					aAdd(aUsado, {aCols[nX, nPosLt261], aCols[nX, nPSlote261], (aCols[nX, nQuant261]*-1)})
				Else
					aUsado[nPos, 3] += (aCols[nX, nQuant261]*-1) // Saida do lote
				EndIf
			EndIf
		EndIf
	Next nX
	
	// Localiza as entradas no lote
	nPCod261   := 6  // Produto destino
	nPLoc261   := 9  // Local destino
	nPosLt261  := 20 // Lote destino
	nQuant261  := 16 // Quantidade
	For nX := 1 To Len(aCols)
		If !(nX==n) .And. If(ValType(aCols[nX,Len(aCols[nX])])=='L', !aCols[nX,Len(aCols[nX])], .T.)
			If aCols[nX, nPCod261] == cCod .And. aCols[nX,nPLoc261] == cLocal
				If (nPos:=aScan(aUsado, {|x| x[1] == aCols[nX,nPosLt261]})) == 0
					aAdd(aUsado, {aCols[nX, nPosLt261], Nil, (aCols[nX, nQuant261])})
				Else
					aUsado[nPos, 3] += (aCols[nX, nQuant261]) // Entrada no lote
				EndIf
			EndIf
		EndIf
	Next nX
Endif
If cProg == "A270" .And. cCpo != "M->B7_NUMLOTE" .And. cCpo != "M->B7_LOTECTL"
	Return Nil
Endif
If cProg == "A380" .And. cCpo != "M->D4_NUMLOTE" .And. cCpo != "M->D4_LOTECTL"
	Return Nil
Endif
If cProg == "A381" .And. cCpo != "M->D4_NUMLOTE" .And. cCpo != "M->D4_LOTECTL"
	Return Nil
Endif
If cProg == "A275" .And. cCpo != "M->DD_NUMLOTE" .And. cCpo != "M->DD_LOTECTL"
	Return Nil
Endif

If cPaisLoc $ "ARG|POR|EUA"
	If cProg == "A465" .And. ;
		cCpo != "M->D2_NUMLOTE" .and. cCpo != "M->D2_LOTECTL" .and.;
		cCpo != "M->CN_NUMLOTE" .And. cCpo != "M->CN_LOTECTL" .and.;
		cCpo != "M->D1_NUMLOTE" .And. cCpo != "M->D1_LOTECTL"
		Return Nil
	EndIf
Endif

If cProg == "A440"
	nPosQuant := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
	nPosQtdLib:= Ascan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"})
Endif

// Verifica se o arquivo que chamou a consulta tem potencia para informar no lote
If Type("nPosPotenc") != "N"
	nPosPotenc := 0
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o arquivo a ser pesquisado                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB8")
dbSetOrder(1)
cSeek := cCod+cLocal
dbSeek(xFilial("SB8")+cSeek)
If !Found()
	HELP(" ",1,"F4LOTE")
	dbSelectArea(cAlias)
	dbSetOrder(nOrdem)
	dbGoto(nRec)
	Return nil
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtem o numero de casas decimais que dever ser utilizado na  ³
//³ consulta.                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamSX3:=TamSX3(Substr(cCpo,4,3)+"QUANT")
If Empty(aTamSX3)
	aTamSX3:=TamSX3("B8_SALDO")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso utilize controle de enderecamento e tenha endereco      ³
//³ preenchido.                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Localiza(cCod) .And. !Empty(cLocaliz)
	dbSelectArea("SB8")
	dbSetOrder(3)
	dbSelectArea("SBF")
	aAreaSBF:=GetArea()
	dbSetOrder(1)
	cSeek:=xFilial("SBF")+cLocal+cLocaliz+cCod
	dbSeek(cSeek)
	Do While !Eof() .And. cSeek == BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO
		If SB8->(dbSeek(xFilial("SB8")+SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOTECTL+If(!Empty(SBF->BF_NUMLOTE),SBF->BF_NUMLOTE,"")))
			If lVldDtLote .And. SB8->B8_DATA > dDataBase
				SBF->(dbSkip())
				Loop
			EndIf
			If !Empty(SBF->BF_NUMLOTE) .And. lRastro
				AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SBF", "SBF", {SBF->BF_NUMLOTE,SBF->BF_PRODUTO,Str(SBFSaldo(),14,aTamSX3[2]),Str(SBFSaldo(,,,.T.),14,aTamSX3[2]),SB8->B8_DTVALID,SB8->B8_LOTEFOR,SBF->BF_LOTECTL,SB8->B8_DATA,SB8->B8_POTENCI,SBF->BF_LOCALIZ,SBF->BF_NUMSERI}))
			Else
				AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SBF", "SBF", {SBF->BF_LOTECTL,SBF->BF_PRODUTO,Str(SBFSaldo(),14,aTamSX3[2]),Str(SBFSaldo(,,,.T.),14,aTamSX3[2]),SB8->B8_DTVALID,SB8->B8_LOTEFOR,SB8->B8_DATA,SB8->B8_POTENCI,SBF->BF_LOCALIZ,SBF->BF_NUMSERI}))
			EndIf
		EndIf
		dbSelectArea("SBF")
		dbSkip()
	EndDo
	RestArea(aAreaSBF)
ElseIf lSLote
	
	#IFDEF TOP
		
		SB8->( dbSetOrder( 1 ) )
		
		lQuery := .T.
		
		cAliasSB8 := GetNextAlias()
		
		aStruSB8 := SB8->( dbStruct() )
		
		cQuery := "SELECT * FROM " + RetSqlName( "SB8" ) + " SB8 "
		cQuery += "WHERE "
		cQuery += "B8_FILIAL='"  + xFilial( "SB8" )	+ "' AND "
		cQuery += "B8_PRODUTO='" + cCod            	+ "' AND "
		cQuery += "B8_LOCAL='"   + cLocal          	+ "' AND "
		cQuery += IIf(lVldDtLote,"B8_DATA <= '" + DTOS(dDataBase) 	+ "' AND ","")
		cQuery += "D_E_L_E_T_=' ' "
		cQuery += "ORDER BY " + SqlOrder( SB8->( IndexKey() ) )
		
		cQuery := ChangeQuery( cQuery )
		
		dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), cAliasSB8, .f., .t. )
		
		For nLoop := 1 To Len( aStruSB8 )
			If aStruSB8[ nLoop, 2 ] <> "C"
				TcSetField( cAliasSB8, aStruSB8[nLoop,1],	aStruSB8[nLoop,2],aStruSB8[nLoop,3],aStruSB8[nLoop,4])
			EndIf
		Next nLoop
		
	#ENDIF
	
	While !( cAliasSB8 )->(Eof()) .And. xFilial("SB8")+cSeek == ( cAliasSB8 )->B8_FILIAL+( cAliasSB8 )->B8_PRODUTO+( cAliasSB8 )->B8_LOCAL
		If !(cProg $ "A100/A240/A440/A241/A270/A465/A685/AT460")
			If SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.,IIf(cProg=="A380",dDataBase,Nil)) > 0
				AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SB8", cAliasSB8, {( cAliasSB8 )->B8_NUMLOTE, ( cAliasSB8 )->B8_PRODUTO, Str(SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.),14,aTamSX3[2]), Str(SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.),14,aTamSX3[2]), ( cAliasSB8 )->B8_DTVALID, ( cAliasSB8 )->B8_LOTEFOR, ( cAliasSB8 )->B8_LOTECTL, ( cAliasSB8 )->B8_DATA,( cAliasSB8 )->B8_POTENCI}))
			Endif
		ElseIf cProg == "A240" .Or. cProg == "A241" .Or. cProg == "A261"
			nSalLote  := SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.)
			nSalLote2 := SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.)
			If cProg == 'A241' .Or. cProg == "A261"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza o Saldo com as quantidades ja digitadas no aCols ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If QtdComp(nSalLote) > QtdComp(0)
					If (nPos:=aScan(aUsado, {|x| x[1] == ( cAliasSB8 )->B8_LOTECTL .And. x[2] == ( cAliasSB8 )->B8_NUMLOTE})) > 0
						nSalLote  += aUsado[nPos, 3]
						nSalLote2 += ConvUM(cCod, aUsado[nPos, 3], 0, 2)
					EndIf
				EndIf
			EndIf
			IF SF5->F5_TIPO == "D" .or. nSalLote > 0
				AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SB8", cAliasSB8, {( cAliasSB8 )->B8_NUMLOTE, ( cAliasSB8 )->B8_PRODUTO, Str(nSalLote,14,aTamSX3[2]), Str(nSalLote2,14,aTamSX3[2]), ( cAliasSB8 )->B8_DTVALID, ( cAliasSB8 )->B8_LOTEFOR, ( cAliasSB8 )->B8_LOTECTL, ( cAliasSB8 )->B8_DATA,( cAliasSB8 )->B8_POTENCI}))
			Endif
		ElseIf cProg $ "A100/A270"
			AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SB8", cAliasSB8, {( cAliasSB8 )->B8_NUMLOTE, ( cAliasSB8 )->B8_PRODUTO, Str(SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.),14,aTamSX3[2]), Str(SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.),14,aTamSX3[2]), ( cAliasSB8 )->B8_DTVALID, ( cAliasSB8 )->B8_LOTEFOR, ( cAliasSB8 )->B8_LOTECTL, ( cAliasSB8 )->B8_DATA,( cAliasSB8 )->B8_POTENCI}))
		ElseIf cProg == "A440" .Or. cProg == "AT460"
			nValA440 := QtdLote(( cAliasSB8 )->B8_PRODUTO,( cAliasSB8 )->B8_LOCAL,( cAliasSB8 )->B8_NUMLOTE,.F.,( cAliasSB8 )->B8_LOTECTL)
			If SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.)-nValA440 > 0
				AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SB8", cAliasSB8, {( cAliasSB8 )->B8_NUMLOTE, ( cAliasSB8 )->B8_PRODUTO, Str(SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.)-nValA440,14,aTamSX3[2]), Str(SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.)-ConvUM(( cAliasSB8 )->B8_PRODUTO,nValA440,0,2),14,aTamSX3[2]), ( cAliasSB8 )->B8_DTVALID, ( cAliasSB8 )->B8_LOTEFOR, ( cAliasSB8 )->B8_LOTECTL, ( cAliasSB8 )->B8_DATA,( cAliasSB8 )->B8_POTENCI}))
			Endif
		ElseIf cProg == "A685"
			If (SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.) > 0 .And. lParam) .Or. (!lParam)
				AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SB8", cAliasSB8, {( cAliasSB8 )->B8_NUMLOTE, ( cAliasSB8 )->B8_PRODUTO, Str(SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.),14,aTamSX3[2]), Str(SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.),14,aTamSX3[2]), ( cAliasSB8 )->B8_DTVALID, ( cAliasSB8 )->B8_LOTEFOR, ( cAliasSB8 )->B8_LOTECTL, ( cAliasSB8 )->B8_DATA,( cAliasSB8 )->B8_POTENCI}))
			ElseIf !Empty(cOP) .And. ( SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.,,,cOP) > 0 .And. lParam )
				AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SB8", cAliasSB8, {( cAliasSB8 )->B8_NUMLOTE, ( cAliasSB8 )->B8_PRODUTO, Str(SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.),14,aTamSX3[2]), Str(SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.),14,aTamSX3[2]), ( cAliasSB8 )->B8_DTVALID, ( cAliasSB8 )->B8_LOTEFOR, ( cAliasSB8 )->B8_LOTECTL, ( cAliasSB8 )->B8_DATA,( cAliasSB8 )->B8_POTENCI}))
			EndIf
		ElseIf cProg $ "A465"
			AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SB8", cAliasSB8, {( cAliasSB8 )->B8_NUMLOTE, ( cAliasSB8 )->B8_PRODUTO, Str((SB8SALDO(,,,,cAliasSB8,lEmpPrev,,,.T.)-(SB8SALDO(.T.,,,,cAliasSB8,lEmpPrev,,,.T.)+nValA440)),14,aTamSX3[2]), ;
			Str((SB8SALDO(,,,.T.,cAliasSB8,lEmpPrev,,,.T.)-(SB8SALDO(.T.,,,.T.,cAliasSB8,lEmpPrev,,,.T.)+ConvUM(( cAliasSB8 )->B8_PRODUTO,nValA440,0,2))),14,aTamSX3[2]), ;
			( cAliasSB8 )->B8_DTVALID, ( cAliasSB8 )->B8_LOTEFOR, ( cAliasSB8 )->B8_LOTECTL, ( cAliasSB8 )->B8_DATA,( cAliasSB8 )->B8_POTENCI}))
		Endif
		( cAliasSB8 )->( dbSkip() )
	EndDo
	
	If lQuery
		( cAliasSB8 )->( dbCloseArea() )
		dbSelectArea( "SB8" )
	EndIf
	
Else
	#IFDEF TOP
		
		SB8->( dbSetOrder( 3 ) )
		
		lQuery := .T.
		
		cAliasSB8 := GetNextAlias()
		
		aStruSB8 := SB8->( dbStruct() )
		
		cQuery := "SELECT * FROM " + RetSqlName( "SB8" ) + " SB8 "
		cQuery += "WHERE "
		cQuery += "B8_FILIAL='"  + xFilial( "SB8" )	+ "' AND "
		cQuery += "B8_PRODUTO='" + cCod            	+ "' AND "
		cQuery += "B8_LOCAL='"   + cLocal          	+ "' AND "
		cQuery += IIf(lVldDtLote,"B8_DATA <= '" + DTOS(dDataBase) 	+ "' AND ","")
		cQuery += "D_E_L_E_T_=' ' "
		cQuery += "ORDER BY " + SqlOrder( SB8->( IndexKey() ) )
		
		cQuery := ChangeQuery( cQuery )
		
		dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), cAliasSB8, .f., .t. )
		
		For nLoop := 1 To Len( aStruSB8 )
			If aStruSB8[ nLoop, 2 ] <> "C"
				TcSetField( cAliasSB8, aStruSB8[nLoop,1],	aStruSB8[nLoop,2],aStruSB8[nLoop,3],aStruSB8[nLoop,4])
			EndIf
		Next nLoop
		
	#ELSE
		dbSetOrder(3)
		dbSeek(xFilial("SB8")+cSeek)
	#ENDIF
	
	While !( cAliasSB8 )->( Eof()) .And. xFilial("SB8")+cSeek == ( cAliasSB8 )->B8_FILIAL+( cAliasSB8 )->B8_PRODUTO+( cAliasSB8 )->B8_LOCAL
		cLoteAnt:=( cAliasSB8 )->B8_LOTECTL
		cLoteFor:=( cAliasSB8 )->B8_LOTEFOR
		dDataVali:=( cAliasSB8 )->B8_DTVALID
		dDataCria:=( cAliasSB8 )->B8_DATA
		nPotencia:=( cAliasSB8 )->B8_POTENCI
		If lExistNF
			cNumDoc  := ( cAliasSB8 )->B8_DOC
			cSerie   := ( cAliasSB8 )->B8_SERIE
			cFornece := ( cAliasSB8 )->B8_CLIFOR
			cLoja    := ( cAliasSB8 )->B8_LOJA
		EndIF
		//-- Filtra lotes com data superior a database
		If lVldDtLote .And. !lQuery .And. (cAliasSB8)->B8_DATA > dDataBase
			( cAliasSB8 )->( dbSkip() )
			Loop
		EndIf
		lAdd	  :=.F.
		nSalLote  :=0
		nSalLote2 :=0
		If cProg == "A440" .Or. cProg == "AT460"
			nValA440 := QtdLote(( cAliasSB8 )->B8_PRODUTO,( cAliasSB8 )->B8_LOCAL,"",.F.,cLoteAnt)
		EndIf
		While !( cAliasSB8 )->( Eof() ) .And. xFilial("SB8")+cSeek+cLoteAnt == ( cAliasSB8 )->B8_FILIAL+( cAliasSB8 )->B8_PRODUTO+( cAliasSB8 )->B8_LOCAL+( cAliasSB8 )->B8_LOTECTL
			If !(cProg $ "A100/A240/A440/A241/A242/A270/AT460/A685")
				nSalLote += SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.,IIf(cProg == "A380",dDataBase,Nil))
				nSalLote2+= SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.,IIf(cProg == "A380",dDataBase,Nil))
			ElseIf cProg == "A240" .Or. cProg == "A241" .Or. cProg == "A242"
				nSalLote += SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.)
				nSalLote2+= SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.)
			ElseIf cProg $ "A100/A270"
				nSalLote += SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.)
				nSalLote2+= SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.)
			ElseIf cProg == "A440" .Or. cProg == "AT460"
				nSalLote  += SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.) - nValA440
				nSalLote2 += SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.) - ConvUM(cCod,nValA440,0,2)
				nValA440 :=0
			ElseIf cProg == "A685"
				If Empty(cOP)
					nSalLote += SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.,IIf(cProg == "A380",dDataBase,Nil))
					nSalLote2+= SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.,IIf(cProg == "A380",dDataBase,Nil))
				Else
					nSalLote += SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.,IIf(cProg == "A380",dDataBase,Nil),,cOP)
					nSalLote2+= SB8Saldo(NIL,NIL,NIL,.T.,cAliasSB8,lEmpPrev,.T.,IIf(cProg == "A380",dDataBase,Nil),,cOP)
				EndIf
			EndIf
			( cAliasSB8 )->( dbSkip() )
		EndDo
		If cProg == 'A241' .Or. cProg == "A261"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o Saldo com as quantidades ja digitadas no aCols ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If QtdComp(nSalLote) > QtdComp(0)
				If (nPos:=aScan(aUsado, {|x| x[1] == cLoteAnt})) > 0
					nSalLote  += aUsado[nPos, 3]
					nSalLote2 += ConvUM(cCod, aUsado[nPos, 3], 0, 2)
				EndIf
			EndIf
		EndIf
		If QtdComp(nSalLote) > QtdComp(0) .Or. ((cProg == "A270" .And. !lParam) .Or. (cProg == "A685" .And. !lParam) .Or. ((cProg == "A240" .Or. cProg == "A241") .And. SF5->F5_TIPO == "D") .Or. (cProg == "A242" .And. cCpo == "M->D3_LOTECTL"))
			If lExistNF
				AADD(aArrayF4, F4LoteArray(cProg, lSLote, "", "", {cLoteAnt,cCod,Str(nSalLote,14,aTamSX3[2]),Str(nSalLote2,14,aTamSX3[2]), (dDataVali), cLoteFor, dDataCria,nPotencia,cNumDoc,cSerie,cFornece,cLoja}))
			Else
				AADD(aArrayF4, F4LoteArray(cProg, lSLote, "", "", {cLoteAnt,cCod,Str(nSalLote,14,aTamSX3[2]),Str(nSalLote2,14,aTamSX3[2]), (dDataVali), cLoteFor, dDataCria,nPotencia}))
			EndIF
		EndIf
	EndDo
	
	If lQuery
		( cAliasSB8 )->( dbCloseArea() )
		dbSelectArea( "SB8" )
	EndIf
	
EndIf

If ExistBlock("F4LOTIND")
	aRetPE:= ExecBlock("F4LOTIND",.F.,.F.,{aArrayF4})
	If ValType(aRetPE) == "A" .And. Len(aRetPE) > 0
		aArrayF4:= aClone(aRetPE)
	EndIf
EndIf

If lMTF4Lote
	If !Empty(aArrayF4)
		
		AAdd( aObjects, { 100, 100, .t., .t.,.t. } )
		AAdd( aObjects, { 100, 30, .t., .f. } )
		
		aSize[ 3 ] -= 50
		aSize[ 4 ] -= 50
		
		aSize[ 5 ] -= 100
		aSize[ 6 ] -= 100
		
		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )
		
		cCadastro := OemToAnsi("Saldos por Lote")	//
		nOpca := 0
		
		DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],00 To  aSize[6],aSize[5] OF oMainWnd PIXEL
		@ 7.1,.4 Say OemToAnsi("Pesquisa Por: ") //
		If lSLote
			If lExistNF
				// aHeaderF4 := {STR0011,STR0015,STR0005,STR0041,STR0016,STR0017,STR0018,STR0024,STR0029,STR0042,STR0003,STR0043,STR0044}
				aHeaderF4 := {"Sub-Lote","Produto","Saldo Atual","Saldo Atual 2aUM","Validade","Lote Fornecedor","Lote","Dt Emissao","Potencia",;
				"Nota Fiscal","Serie","Cliente/Fornecedor","Loja"}
			Else
				// aHeaderF4 := {STR0011,STR0015,STR0005,STR0041,STR0016,STR0017,STR0018,STR0024,STR0029}
				aHeaderF4 := {"Sub-Lote","Produto","Saldo Atual","Saldo Atual 2aUM","Validade","Lote Fornecedor","Lote","Dt Emissao","Potencia"}
			EndIf
			aHeaderF4 := RetExecBlock("F4LoteHeader", {cProg, lSLote, aHeaderF4}, "A", aHeaderF4)
			oQual := VAR := cVar := TWBrowse():New( aPosObj[1][1], aPosObj[1][2], aPosObj[1][3], aPosObj[1][4],,aHeaderF4,,,,,,,{|nRow,nCol,nFlags|(nOpca := 1,oDlg2:End())},,,,,,, .F.,, .T.,, .F.,,, )
			oQual:SetArray(aArrayF4)
			oQual:bLine := { || aArrayF4[oQual:nAT] }
		Else
			If lExistNF
				// aHeaderF4 := {STR0018,STR0015,STR0005,STR0041,STR0016,STR0017,STR0024,STR0029,STR0042,STR0003,STR0043,STR0044}
				aHeaderF4 := {"Lote","Produto","Saldo Atual","Saldo Atual 2aUM","Validade","Lote Fornecedor","Dt Emissao","Potencia","Nota Fiscal",;
				"Serie","Cliente/Fornecedor","Loja"}
			Else
				// aHeaderF4 := {STR0018,STR0015,STR0005,STR0041,STR0016,STR0017,STR0024,STR0029}
				aHeaderF4 := {"Lote","Produto","Saldo Atual","Saldo Atual 2aUM","Validade","Lote Fornecedor","Dt Emissao","Potencia"}
			EndIf
			aHeaderF4 := RetExecBlock("F4LoteHeader", {cProg, lSLote, aHeaderF4}, "A", aHeaderF4)
			oQual := VAR := cVar := TWBrowse():New( aPosObj[1][1], aPosObj[1][2], aPosObj[1][3], aPosObj[1][4],,aHeaderF4,,,,,,,{|nRow,nCol,nFlags|(nOpca := 1,oDlg2:End())},,,,,,, .F.,, .T.,, .F.,,, )
			oQual:SetArray(aArrayF4)
			oQual:bLine := { || aArrayF4[oQual:nAT] }
		EndIf
		@ aPosObj[2][1]+10,aPosObj[2][2] Say OemToAnsi("Pesquisa Por: ") PIXEL //
		@ aPosObj[2][1]+10,aPosObj[2][2]+50 MSCOMBOBOX oCombo1 VAR cCombo1 ITEMS aCombo1 SIZE 100,44  VALID F4LotePesq(cCombo1,aArrayF4,oQual,oCombo1) OF oDlg2 FONT oDlg2:oFont PIXEL
		
		DEFINE SBUTTON FROM aPosObj[2][1]+10 ,aPosObj[2][4]-58  TYPE 1 ACTION (nOpca := 1,oDlg2:End()) ENABLE OF oDlg2
		DEFINE SBUTTON FROM aPosObj[2][1]+10 ,aPosObj[2][4]-28   TYPE 2 ACTION oDlg2:End() ENABLE OF oDlg2
		
		ACTIVATE MSDIALOG oDlg2 VALID (nOAT := oQual:nAT,.t.) CENTERED
		
		If nOpca ==1
			If cProg == "A260" .Or. cProg == "A242"
				If !(Substr(cCpo,7) == "LOTECTL" .Or. Substr(cCpo,7) == "_LOTECT")
					If lSLote
						cNumLote := aArrayF4[nOAT][1]
					EndIf
					cLoteDigi:= aArrayF4[nOAT][nPos2]
					dDtValid := aArrayF4[nOAT][nPos3]
					nPotencia:= aArrayF4[nOAT][nPos4]
				EndIf
				If cProg == "A242"
					If Substr(cCpo,7) == "LOTECTL" .Or. Substr(cCpo,7) == "_LOTECT"
						&(ReadVar()) :=  aArrayF4[nOAT][nPos2]
						If Type('aCols') == 'A'
							If lSLote
								aCols[n][nPosLote]:=aArrayF4[nOAT][1]
							EndIf
							If nLoteCtl == 1
								aCols[n][nPosLotCTL] :=aArrayF4[nOAT][nPos2]
								aCols[n][nPosDValid] :=aArrayF4[nOAT][nPos3]
							EndIf
							If nPosPotenc > 0
								aCols[n][nPosPotenc] :=aArrayF4[nOAT][nPos4]
							EndIf
						Endif
					EndIf
				EndIf
				If cPaisLoc $ "ARG|POR|EUA"
					If cProg == "A260"
						nQuant260D := 0.00
						nQuant260  := Val(aArrayF4[nOAT][3])
						nQuant260D := ConvUm(aArrayF4[nOAT][2],nQuant260,nQuant260D,2)
					EndIf
				EndIf
				
			ElseIf cProg == "A240"
				If lSLote
					nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_NUMLOTE" } )
					If nEndereco > 0
						aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][1]
						M->D3_NUMLOTE := aArrayF4[nOAT][1]
					EndIf
				EndIf
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_LOTECTL" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos2]
					M->D3_LOTECTL := aArrayF4[nOAT][nPos2]
				EndIf
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_DTVALID" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos3]
					M->D3_DTVALID := aArrayF4[nOAT][nPos3]
				EndIf
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_POTENCI" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos4]
					M->D3_POTENCI := aArrayF4[nOAT][nPos4]
				EndIf
			ElseIf cProg == "A270"
				If lSLote
					nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "B7_NUMLOTE" } )
					If nEndereco > 0
						aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][1]
						M->B7_NUMLOTE := aArrayF4[nOAT][1]
					EndIf
				EndIf
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "B7_LOTECTL" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos2]
					M->B7_LOTECTL := aArrayF4[nOAT][nPos2]
				EndIf
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "B7_DTVALID" } )
				If nEndereco > 0
					M->B7_DTVALID := aArrayF4[nOAT][nPos3]
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos3]
				EndIf
				If lExistNF
					nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "B7_NUMDOC " } )
					If nEndereco > 0
						aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos5]
						M->B7_NUMDOC:=SB8->B8_DOC
					EndIf
					
					nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "B7_SERIE  " } )
					If nEndereco > 0
						aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos6]
						M->B7_SERIE:=SB8->B8_SERIE
					EndIf
					
					nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "B7_FORNECE" } )
					If nEndereco > 0
						aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos7]
						M->B7_FORNECE:=SB8->B8_CLIFOR
					EndIf
					
					nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "B7_LOJA   " } )
					If nEndereco > 0
						aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos8]
						M->B7_LOJA:=SB8->B8_LOJA
					EndIf
				EndIF
			ElseIf cProg == "A380"
				If lSLote
					nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D4_NUMLOTE" } )
					If nEndereco > 0
						aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][1]
						M->D4_NUMLOTE := aArrayF4[nOAT][1]
					EndIf
				EndIf
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D4_LOTECTL" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos2]
					M->D4_LOTECTL := aArrayF4[nOAT][nPos2]
				EndIf
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D4_DTVALID" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos3]
					M->D4_DTVALID :=  aArrayF4[nOAT][nPos3]
				EndIf
			ElseIf cProg == "A275"
				If lSLote
					nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "DD_NUMLOTE" } )
					If nEndereco > 0
						aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][1]
						M->DD_NUMLOTE := aArrayF4[nOAT][1]
					EndIf
				EndIf
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "DD_LOTECTL" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos2]
					M->DD_LOTECTL := aArrayF4[nOAT][nPos2]
				EndIf
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "DD_DTVALID" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := aArrayF4[nOAT][nPos3]
					M->DD_DTVALID :=  aArrayF4[nOAT][nPos3]
				EndIf
			ElseIf cProg == "A465"
				If lRastro
					aCols[n][nPosLote] := aArrayF4[nOAT][1]
					aCols[n][nPosLotCTL] := aArrayF4[nOAT][nPos2]
				Else
					aCols[n][nPosLotCTL] := aArrayF4[nOAT][1]
				EndIf
				aCols[n][nPosDValid] := aArrayF4[nOAT][5]
				If Substr(cCpo,7) == "LOTECTL"
					If lRastro
						&(ReadVar()) :=  aArrayF4[nOAT][nPos2]
					Else
						&(ReadVar()) :=  aArrayF4[nOAT][1]
					EndIf
				Else
					If lRastro
						&(ReadVar()) :=  aArrayF4[nOAT][1]
					EndIf
				EndIf
			ElseIf cProg == "AT460"
				If lSLote
					If SubStr(cCpo,8) == "NUMLOT"
						&(ReadVar()) := aArrayF4[nOAT][1]
					Else
						GDFieldPut("ABA_NUMLOT",aArrayF4[nOAT][1],n)
					EndIf
				EndIf
				If SubStr(cCpo,8) == "LOTECT"
					&(ReadVar()) := aArrayF4[nOAT][nPos2]
				Else
					GDFieldPut("ABA_LOTECT",aArrayF4[nOAT][nPos2],n)
				EndIf
			Else
				lRet := .T.
				If lSelLote .and. nPosQuant > 0
					SB8->(DbSetOrder(3))
					If lSLote
						cSeek:=xFilial("SB8")+cCod+cLocal+aArrayF4[nOAT][nPos2]+aArrayF4[nOAT][1]
						cWhile:="SB8->(B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE)"
					Else
						cSeek:=xFilial("SB8")+cCod+cLocal+aArrayF4[nOAT][nPos2]
						cWhile:="SB8->(B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL)"
					EndIf
					dbSeek(cSeek)
					nSaldoCons:=0
					While !EOF() .And. cSeek == &(cWhile)
						nSaldoCons+=SB8SALDO(,,,,,lEmpPrev,,,.T.)
						dbSkip()
					End
					If IIf(cProg == "A440",aCols[n][nPosQtdLib] > nSaldoCons,aCols[n][nPosQuant] > nSaldoCons)
						If cProg == "A440"
							cAviso := "Quantidade informada e maior que a quantidade do lote selecionado, modifique a quantidade do item"
							Aviso("Atenção",cAviso,{"Ok"}) //
						Else
							cAviso := "Quantidade informada e maior que a quantidade disponivel do lote selecionado, modifique a quantidade liberada do item"
							Aviso("Atenção",cAviso,{"Ok"}) //
						EndIf
						lRet := .F.
					EndIf
				EndIf
				If lRet
					If !Empty(cProg) .And. Type('aCols') == 'A'
						If lSLote
							aCols[n][nPosLote]:=aArrayF4[nOAT][1]
						EndIf
						If nLoteCtl == 1
							aCols[n][nPosLotCTL]:= aArrayF4[nOAT][nPos2]
							aCols[n][nPosLotOri]:= aArrayF4[nOAT][nPos2]
							aCols[n][nPosDValid]:= aArrayF4[nOAT][nPos3]
						EndIf
						If nPosPotenc > 0
							aCols[n][nPosPotenc] :=aArrayF4[nOAT][nPos4]
						EndIf
					Endif
					If Substr(cCpo,7) == "LOTECTL" .Or. Substr(cCpo,7) == "_LOTECT" .Or. Substr(cCpo,7) == "LOTENEW"
						&(ReadVar()) :=  aArrayF4[nOAT][nPos2]
					Else
						If lSLote
							&(ReadVar()) :=  aArrayF4[nOAT][1]
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		HELP(" ",1,"F4LOTE")
	Endif
EndIf

dbSelectArea(cAlias)
dbSetOrder(nOrdem)
dbGoto(nRec)

SetFocus(nHdl)

Return Nil
