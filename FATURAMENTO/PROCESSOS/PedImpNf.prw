#INCLUDE "rwmake.ch"
#INCLUDE "MATA410.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"       
#INCLUDE "FWADAPTEREAI.CH"     


User Function PedImpNf()

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aFisGet	:= {}
Local aFisGetSC5:= {}
Local aTitles   := {STR0044,STR0045,STR0080} //"Nota Fiscal"###"Duplicatas"###"Rentabilidade"
Local aDupl     := {}
Local aVencto   := {}
Local aFlHead   := { STR0046,STR0047,STR0063 } //"Vencimento"###"Valor"
Local aEntr     := {}
Local aDuplTmp  := {}
Local aNfOri    := {}
Local aRFHead   := { RetTitle("C6_PRODUTO"),RetTitle("C6_VALOR"),STR0081,STR0082,STR0083,STR0084} //"C.M.V"###"Vlr.Presente"###"Lucro Bruto"###"Margem de Contribui?o(%)"
Local aRentab   := {}
Local nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local nPTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPDtEntr  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"})
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPCodRet  := Iif(cPaisLoc=="EQU",aScan(aHeader,{|x| AllTrim(x[2])=="C6_CONCEPT"}),"")
Local nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})
Local nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})
Local nPItemOri := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})
Local nPIdentB6 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_IDENTB6"})
Local nPItem    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
Local nPProvEnt := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PROVENT"})
Local nPosCfo	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
Local nPAbatISS := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ABATISS"})
Local nPLote    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
Local nPSubLot	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"})
Local nPClasFis := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})
Local nPSuframa := 0      
Local nUsado    := Len(aHeader)
Local nX        := 0
Local nX1       := 0
Local nAcerto   := 0
Local nPrcLista := 0
Local nValMerc  := 0
Local nDesconto := 0
Local nAcresFin := 0	// Valor do acrescimo financeiro do total do item
Local nQtdPeso  := 0
Local nRecOri   := 0
Local nPosEntr  := 0
Local nItem     := 0
Local nY        := 0 
Local nPosCpo   := 0
Local nPropLot  := 0
Local lDtEmi    := SuperGetMv("MV_DPDTEMI",.F.,.T.)
Local dDataCnd  := C5_EMISSAO   
Local nOpc      := 1
Local oDlg
Local oDupl
Local oFolder
Local oRentab
Local lCondVenda := .F. // Template GEM
Local aRentabil := {}
Local cProduto  := ""
Local nTotDesc  := 0
Local lSaldo    := MV_PAR04 == 1 .And. !INCLUI
Local nQtdEnt   := 0
Local lM410Ipi	:= ExistBlock("M410IPI")
Local lM410Icm	:= ExistBlock("M410ICM")
Local lM410Soli	:= ExistBlock("M410SOLI")
Local lUsaVenc  := .F.
Local lIVAAju   := .F.
Local lRastro	 := ExistBlock("MAFISRASTRO")
Local lRastroLot := .F.
Local lPParc	:=.F.
Local aSolid	:= {}
Local nLancAp	:=	0
Local aHeadCDA		:=	{}
Local aColsCDA		:=	{}
Local aTransp	:= {"",""}
Local aSaldos	:= {}
Local aInfLote	:= {}
Local a410Preco := {}  // Retorno da Project Function P_410PRECO com os novos valores das variaveis {nValMerc,nPrcLista}
Local nAcresUnit:= 0	// Valor do acrescimo financeiro do valor unitario
Local nAcresTot := 0	// Somatoria dos Valores dos acrescimos financeiros dos itens
Local dIni		:= Ctod("//") 
Local cEstado	:= SuperGetMv("MV_ESTADO") 
Local cTesVend  :=  SuperGetMv("MV_TESVEND",,"")
Local cCliPed   := "" 
Local lCfo      := .F.
Local nlValor	:= 0
Local nValRetImp:= 0
Local cImpRet 	:= ""
Local cNatureza :="" 
Local lM410FldR := .T.
Local aTotSolid := {}            
Local nValTotal := 0 //Valor total utilizado no retorno quando lRetTotal for .T.
Local nTotal	:= 0
Local nValIpiTrf	:= 0
Local nPIPITrf		:= Ascan(aHeader,{|x| Trim(x[2]) == "C6_IPITRF"})
Local aValMerc	:= {}
Local lRent      := AllTrim(FunName()) $ "MATA851|MATA852|MATA853" //Verifica se ?executado pelos programas de rentabilidade
Local lContinua  := .F. 
Local aIcms	:= {}  
Local aRefRentab  := {}


Default lRetTotal := .F.
Default aRefRentab := {}

PRIVATE oLancApICMS
PRIVATE _nTotOper_ := 0		//total de operacoes (vendas) realizadas com um cliente - calculo de IB - Argentina
Private _aValItem_ := {}

//????????????????????????
//?usca referencias no SC6                     ?
//????????????????????????
aFisGet	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC6")
While !Eof().And.X3_ARQUIVO=="SC6"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGet,,,{|x,y| x[3]<y[3]})

//????????????????????????
//?usca referencias no SC5                     ?
//????????????????????????
aFisGetSC5	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")
While !Eof().And.X3_ARQUIVO=="SC5"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})

SA4->(dbSetOrder(1))
If SA4->(dbSeek(xFilial("SA4")+C5_TRANSP)) 
	aTransp[01] := SA4->A4_EST
	aTransp[02] := Iif(SA4->(FieldPos("A4_TPTRANS")) > 0,SA4->A4_TPTRANS,"")
Endif
//????????????????????????
//?nicializa a funcao fiscal                   ?
//???????????????????????? 

//???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
//? Consultoria Tribut?ia, por meio da Resposta ?Consulta n?268/2004, determinou a aplica?o das seguintes al?uotas nas Notas Fiscais de venda emitidas pelo vendedor remetente:                                                                         ?
//?) no caso previsto na letra "a" (venda para SP e entrega no PR) - aplica?o da al?uota interna do Estado de S? Paulo, visto que a opera?o entre o vendedor remetente e o adquirente origin?io ?interna;                                              ?
//?) no caso previsto na letra "b" (venda para o DF e entrega no PR) - aplica?o da al?uota interestadual prevista para as opera?es com o Paran? ou seja, 12%, visto que a circula?o da mercadoria se d?entre os Estado de S? Paulo e do Paran?       ?
//?) no caso previsto na letra "c" (venda para o RS e entrega no SP) - aplica?o da al?uota interna do Estado de S? Paulo, uma vez que se considera interna a opera?o, quando n? se comprovar a sa?a da mercadoria do territ?io do Estado de S? Paulo,?
//?conforme previsto no art. 36, ?4?do RICMS/SP                                                                                                                                                                                                            ?
//???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
If len(aCols) > 0
	If cEstado == 'SP'
		If !Empty(C5_CLIENT) .And. C5_CLIENT <> C5_CLIENTE
			For nX := 1 To Len(aCols)
					If Alltrim(aCols[nX][nPTES])$ Alltrim(cTesVend)
					lCfo:= .T.
				EndIf
				Next		   	
				If lCfo		
				dbSelectArea(IIF(C5_TIPO$"DB","SA2","SA1"))
				dbSetOrder(1)           
				MsSeek(xFilial()+C5_CLIENTE+C5_LOJAENT)
				If Iif(C5_TIPO$"DB", SA2->A2_EST,SA1->A1_EST) == 'SP'
					cCliPed := C5_CLIENTE
				Else
					cCliPed := C5_CLIENT
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

MaFisSave()
MaFisEnd()
aEval(aCols,{|x| nTotal += a410Arred( If(x[Len(x)],0,x[nPTotal]+(x[nPTotal]*C5_ACRSFIN/100)),"D2_TOTAL")})
nTotal+= (C5_FRETE+C5_DESPESA+C5_SEGURO)
MaFisIni(IIf(!Empty(cCliPed),cCliPed,Iif(Empty(C5_CLIENT),C5_CLIENTE,C5_CLIENT)),;// 1-Codigo Cliente/Fornecedor
	C5_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
	IIf(C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	C5_TIPO,;				// 4-Tipo da NF
	C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461",;
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	aTransp,,, C5_NUM, C5_CLIENTE, C5_LOJACLI,nTotal,, C5_TPFRETE)

//??????????????????????????
//?ealiza alteracoes de referencias do SC5         ?
//??????????????????????????
If Len(aFisGetSC5) > 0
	dbSelectArea("SC5")
	For nY := 1 to Len(aFisGetSC5)
		If !Empty(&(" "+Alltrim(aFisGetSC5[ny][2])))
			MaFisAlt(aFisGetSC5[ny][1],&(" "+Alltrim(aFisGetSC5[ny][2])),,.F.)
		EndIf
	Next nY
Endif

If SuperGetMV("MV_ISSXMUN",.F.,.F.)
	If !Empty( C5_MUNPRES)
		MaFisLoad("NF_CODMUN",AllTrim( C5_MUNPRES))
	EndIf
	
	If !Empty( C5_ESTPRES)
		MaFisLoad("NF_UFPREISS",AllTrim( C5_ESTPRES))
	EndIf
EndIf
//Na argentina o calculo de impostos depende da serie.

//????????????????????????
//?ndica os valores do cabecalho               ?
//????????????????????????
If ( ( cPaisLoc == "PER" .Or. cPaisLoc == "COL" ) .And.  C5_TPFRETE == "F" ) .Or. ( cPaisLoc != "PER" .And. cPaisLoc != "COL" )
	MaFisAlt("NF_FRETE", C5_FRETE)
EndIf
MaFisAlt("NF_VLR_FRT", C5_VLR_FRT)
MaFisAlt("NF_SEGURO", C5_SEGURO)
MaFisAlt("NF_AUTONOMO", C5_FRETAUT)
MaFisAlt("NF_DESPESA", C5_DESPESA)                 
If cPaisLoc == "PTG"
	MaFisAlt("NF_DESNTRB", C5_DESNTRB)
	MaFisAlt("NF_TARA", C5_TARA)	
Endif
//????????????????????????
//?ndenizacao por valor                        ?
//????????????????????????
If  C5_PDESCAB > 0
	MaFisAlt("NF_DESCONTO",A410Arred((MaFisRet(,"NF_VALMERC")-nTotDesc)* C5_PDESCAB/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))	
EndIf

If  C5_DESCONT > 0
	MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nTotDesc+ C5_DESCONT),/*nItem*/,/*lNoCabec*/,/*nItemNao*/,GetNewPar("MV_TPDPIND","1")=="2" )
EndIf

If lM410Ipi .Or. lM410Icm .Or. lM410Soli
	nItem := 0
	aTotSolid := {}
	For nX := 1 To Len(aCols)
		nItem++
		//??????????????????????????????????????????????????
		//?onto de Entrada M410IPI para alterar os valores do IPI referente a palnilha financeira           ?
		//??????????????????????????????????????????????????
		If lM410Ipi 
			VALORIPI    := MaFisRet(nItem,"IT_VALIPI")
			BASEIPI     := MaFisRet(nItem,"IT_BASEIPI")
			QUANTIDADE  := MaFisRet(nItem,"IT_QUANT")
			ALIQIPI     := MaFisRet(nItem,"IT_ALIQIPI")
			BASEIPIFRETE:= MaFisRet(nItem,"IT_FRETE")
			MaFisAlt("IT_VALIPI",ExecBlock("M410IPI",.F.,.F.,{ nItem }),nItem,.T.)
			MaFisLoad("IT_BASEIPI",BASEIPI ,nItem)
			MaFisLoad("IT_ALIQIPI",ALIQIPI ,nItem)
			MaFisLoad("IT_FRETE"  ,BASEIPIFRETE,nItem,"11")
			MaFisEndLoad(nItem,1)
		EndIf
		//??????????????????????????????????????????????????
		//?onto de Entrada M410ICM para alterar os valores do ICM referente a palnilha financeira           ?
		//??????????????????????????????????????????????????
		If lM410Icm
			_BASEICM    := MaFisRet(nItem,"IT_BASEICM")
			_ALIQICM    := MaFisRet(nItem,"IT_ALIQICM")
			_QUANTIDADE := MaFisRet(nItem,"IT_QUANT")
			_VALICM     := MaFisRet(nItem,"IT_VALICM")
			_FRETE      := MaFisRet(nItem,"IT_FRETE")
			_VALICMFRETE:= MaFisRet(nItem,"IT_ICMFRETE")
			_DESCONTO   := MaFisRet(nItem,"IT_DESCONTO")
			ExecBlock("M410ICM",.F.,.F., { nItem } )
			MaFisLoad("IT_BASEICM" ,_BASEICM    ,nItem)
			MaFisLoad("IT_ALIQICM" ,_ALIQICM    ,nItem)
			MaFisLoad("IT_VALICM"  ,_VALICM     ,nItem)
			MaFisLoad("IT_FRETE"   ,_FRETE      ,nItem)
			MaFisLoad("IT_ICMFRETE",_VALICMFRETE,nItem)
			MaFisLoad("IT_DESCONTO",_DESCONTO   ,nItem)
			MaFisEndLoad(nItem,1)
		EndIf
		//??????????????????????????????????????????????????
		//?onto de Entrada M410SOLI para alterar os valores do ICM Solidario referente a palnilha financeira?
		//??????????????????????????????????????????????????
		If lM410Soli
			ICMSITEM    := MaFisRet(nItem,"IT_VALICM")		// variavel para ponto de entrada
			QUANTITEM   := MaFisRet(nItem,"IT_QUANT")		// variavel para ponto de entrada
			BASEICMRET  := MaFisRet(nItem,"IT_BASESOL")	    // criado apenas para o ponto de entrada
			MARGEMLUCR  := MaFisRet(nItem,"IT_MARGEM")		// criado apenas para o ponto de entrada
			aSolid := ExecBlock("M410SOLI",.f.,.f.,{nItem}) 
			aSolid := IIF(ValType(aSolid) == "A" .And. Len(aSolid) == 2, aSolid,{})
			If !Empty(aSolid)
				MaFisLoad("IT_BASESOL",NoRound(aSolid[1],2),nItem)
				MaFisLoad("IT_VALSOL" ,NoRound(aSolid[2],2),nItem)
				MaFisEndLoad(nItem,1)
					 AAdd(aTotSolid, { nItem , NoRound(aSolid[1],2) , NoRound(aSolid[2],2)} )
			Endif
		EndIf
	Next
EndIf

//??????????????????????????
//?ealiza alteracoes de referencias do SC6         ?
//??????????????????????????
dbSelectArea("SC6")
If Len(aFisGet) > 0
	For nX := 1 to Len(aCols)
		If Len(aCols[nX])==nUsado .Or. !aCols[nX][Len(aHeader)+1]
			For nY := 1 to Len(aFisGet)
				nPosCpo := aScan(aHeader,{|x| AllTrim(x[2])==Alltrim(aFisGet[ny][2])})
				If nPosCpo > 0
					If !Empty(aCols[nX][nPosCpo])					  
						MaFisAlt(aFisGet[ny][1],aCols[nX][nPosCpo],nX,.F.)
						//??????????????????????????????????????????????????
						//?uando o ponto de Entrada M410SOLI retornar valores forcar o recalculo pois o MaFisAlt acima      ?
						//?ecalculava os valores retornados pelo ponto anulando a sua acao.                                 ?
						//??????????????????????????????????????????????????
						If lM410Soli .And. !Empty(aTotSolid) 
							nPosSolid := Ascan(aTotSolid,{|x| x[1] == nX })
							 If nPosSolid > 0
								MaFisLoad("IT_BASESOL", aTotSolid[nPosSolid,02] ,nX )
								MaFisLoad("IT_VALSOL" , aTotSolid[nPosSolid,03] ,nX )
								MaFisEndLoad(nX,1)
									 EndIf
						Endif
					Endif
				EndIf
			Next nY
		Endif
			MaFisAlt("IT_VALMERC",aValMerc[nX],nX)
	Next nX
EndIf
//??????????????????????????
//?ealiza alteracoes de referencias do SC5 Suframa ?
//??????????????????????????
nPSuframa:=aScan(aFisGetSC5,{|x| x[1] == "NF_SUFRAMA"})
If !Empty(nPSuframa)
	dbSelectArea("SC5")
	If !Empty(&(" "+Alltrim(aFisGetSC5[nPSuframa][2])))
		MaFisAlt(aFisGetSC5[nPSuframa][1],Iif(&(" "+Alltrim(aFisGetSC5[nPSuframa][2])) == "1",.T.,.F.),nItem,.F.)
	EndIf
Endif
If ExistBlock("M410PLNF")
	ExecBlock("M410PLNF",.F.,.F.)
EndIf
MaFisWrite(1)
//
// Template GEM - Gestao de Empreendimentos Imobiliarios
//
// Verifica se a condicao de pagamento tem vinculacao com uma condicao de venda
//
If ExistTemplate("GMCondPagto")
	lCondVenda := .F.
	lCondVenda := ExecTemplate("GMCondPagto",.F.,.F.,{ C5_CONDPAG,} )
EndIf
//??????????????????????????
//?alcula os venctos conforme a condicao de pagto  ?
//??????????????????????????
If ! C5_TIPO == "B"
	If lDtEmi
		dbSelectarea("SE4")
		dbSetOrder(1)
		MsSeek(xFilial("SE4")+ C5_CONDPAG)
		
		If (Type("INCLUI") <> "U" .AND. Type("ALTERA") <> "U")
			lContinua := !(INCLUI.OR.ALTERA)
		endif

		If (SE4->E4_TIPO=="9".AND.(lContinua .OR. lRent)) ;
			.OR. SE4->E4_TIPO<>"9"
		
			If SFB->FB_JNS == 'J' .And. cPaisLoc == 'COL'
				 dbSelectArea("SFC")
				dbSetOrder(2)
				If dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RV0" )
					nValRetImp 	:= MaFisRet(,"NF_VALIV2")
					Do Case
						Case FC_INCDUPL == '1'
							nlValor := MaFisRet(,"NF_BASEDUP") - nValRetImp
						Case FC_INCDUPL == '2'
							nlValor :=MaFisRet(,"NF_BASEDUP") + nValRetImp
						Otherwise
							nlValor :=MaFisRet(,"NF_BASEDUP")
					EndCase
				Elseif dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RF0" )
					nValRetImp 	:= MaFisRet(,"NF_VALIV4")
					Do Case
						Case FC_INCDUPL == '1'
							nlValor := MaFisRet(,"NF_BASEDUP") - nValRetImp
						Case FC_INCDUPL == '2'
							nlValor :=MaFisRet(,"NF_BASEDUP") + nValRetImp
						Otherwise
							nlValor :=MaFisRet(,"NF_BASEDUP")
					EndCase
				Elseif dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RC0" )
					nValRetImp 	:= MaFisRet(,"NF_VALIV7")
					Do Case
						Case FC_INCDUPL == '1'
							nlValor := MaFisRet(,"NF_BASEDUP") - nValRetImp
						Case FC_INCDUPL == '2'
							nlValor :=MaFisRet(,"NF_BASEDUP") + nValRetImp
						Otherwise
							nlValor :=MaFisRet(,"NF_BASEDUP")
					EndCase
				Endif
			Else
				nlValor := MaFisRet(,"NF_BASEDUP")
			EndIf				
		
			aDupl := Condicao(nlValor, C5_CONDPAG,MaFisRet(,"NF_VALIPI"),dDataCnd,MaFisRet(,"NF_VALSOL"),,,nAcresTot)
			If Len(aDupl) > 0
				If ! lCondVenda
					For nX := 1 To Len(aDupl)
						nAcerto += aDupl[nX][2]
					Next nX
					aDupl[Len(aDupl)][2] += MaFisRet(,"NF_BASEDUP") - nAcerto
				EndIf
	
				aVencto := aClone(aDupl)
				For nX := 1 To Len(aDupl)
					aDupl[nX][2] := TransForm(aDupl[nX][2],PesqPict("SE1","E1_VALOR"))
				Next nX
			Endif
		Else
			aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
			aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
		EndIf
	Else
		nItem := 0	
		For nX := 1 to Len(aCols)
			If Len(aCols[nX])==nUsado .Or. !aCols[nX][nUsado+1]
				If nPDtEntr > 0
					nItem++
					nPosEntr := Ascan(aEntr,{|x| x[1] == aCols[nX][nPDtEntr]})
					If nPosEntr == 0
						Aadd(aEntr,{aCols[nX][nPDtEntr],MaFisRet(nItem,"IT_BASEDUP"),MaFisRet(nItem,"IT_VALIPI"),MaFisRet(nItem,"IT_VALSOL")})
					Else    
						aEntr[nPosEntr][2]+= MaFisRet(nItem,"IT_BASEDUP")
						aEntr[nPosEntr][3]+= MaFisRet(nItem,"IT_VALIPI")
						aEntr[nPosEntr][4]+= MaFisRet(nItem,"IT_VALSOL")
					EndIf
				Endif
			Endif
		 Next
		dbSelectarea("SE4")
		dbSetOrder(1)
		MsSeek(xFilial("SE4")+ C5_CONDPAG)
		If !(SE4->E4_TIPO=="9")
			For nY := 1 to Len(aEntr)
				nAcerto  := 0
				
				If SFB->FB_JNS $ 'J/S' .And. cPaisLoc == 'COL'
					 
					 dbSelectArea("SFC")
					dbSetOrder(2)
					If dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RV0" )
						nValRetImp 	:= MaFisRet(,"NF_VALIV2")
						Do Case
							Case FC_INCDUPL == '1'
								nlValor := aEntr[nY][2] - nValRetImp
							Case FC_INCDUPL == '2'
								nlValor :=aEntr[nY][2] + nValRetImp
							Otherwise
								nlValor :=aEntr[nY][2]
						EndCase
					Elseif dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RF0" )
						nValRetImp 	:= MaFisRet(,"NF_VALIV4")
						Do Case
							Case FC_INCDUPL == '1'
								nlValor := aEntr[nY][2] - nValRetImp
							Case FC_INCDUPL == '2'
								nlValor :=aEntr[nY][2] + nValRetImp
							Otherwise
								nlValor :=aEntr[nY][2]
						EndCase
					Elseif dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RC0" )
						nValRetImp 	:= MaFisRet(,"NF_VALIV7")
						Do Case
							Case FC_INCDUPL == '1'
								nlValor := aEntr[nY][2] - nValRetImp
							Case FC_INCDUPL == '2'
								nlValor :=aEntr[nY][2] + nValRetImp
							Otherwise
								nlValor :=aEntr[nY][2]
						EndCase
					Endif
				ElseIf cPaisLoc=="EQU" .And. lPParc
					DbSelectArea("SFC")
					SFC->(dbSetOrder(2))
					If DbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RIR") //Reten?o IVA
						cImpRet		:= SFC->FC_IMPOSTO
						DbSelectArea("SFB")
						SFB->(dbSetOrder(1))
						If SFB->(DbSeek(xFilial("SFB")+AvKey(cImpRet,"FB_CODIGO")))
							nValRetImp 	:= MaFisRet(,"NF_VALIV"+SFB->FB_CPOLVRO)
						 Endif       
						 DbSelectArea("SFC")
						If SFC->FC_INCDUPL == '1'
							nlValor	:=aEntr[nY][2] - nValRetImp				
						ElseIf SFC->FC_INCDUPL == '2'
							nlValor :=aEntr[nY][2] + nValRetImp
						EndIf   
					 Endif
				Else
					nlValor := aEntr[nY][2]
				EndIf
				
				
				aDuplTmp := Condicao(nlValor, C5_CONDPAG,aEntr[nY][3],aEntr[nY][1],aEntr[nY][4],,,nAcresTot)
				If Len(aDuplTmp) > 0
					If ! lCondVenda
						If cPaisLoc=="EQU"
							For nX := 1 To Len(aDuplTmp)
								If nX==1                            
									If SFC->FC_INCDUPL == '1'
										aDuplTmp[nX][2]+= nValRetImp
									ElseIf SFC->FC_INCDUPL == '2'
										aDuplTmp[nX][2]-= nValRetImp
									Endif										
								Endif	
							Next nX
						Else
							For nX := 1 To Len(aDuplTmp)
								nAcerto += aDuplTmp[nX][2]
							Next nX
							aDuplTmp[Len(aDuplTmp)][2] += aEntr[nY][2] - nAcerto
						Endif
					EndIf
	
					aVencto := aClone(aDuplTmp)
					For nX := 1 To Len(aDuplTmp)
						aDuplTmp[nX][2] := TransForm(aDuplTmp[nX][2],PesqPict("SE1","E1_VALOR"))
					Next nX
					aEval(aDuplTmp,{|x| Aadd(aDupl,{aEntr[nY][1],x[1],x[2]})})
				EndIf
			Next
		Else
			aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
			aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
		EndIf
	EndIf
Else
	aDupl := {{Ctod(""),TransForm(0,PesqPict("SE1","E1_VALOR"))}}
	aVencto := {{dDataBase,0}}
EndIf
//
// Template GEM - Gestao de empreendimentos Imobiliarios
// Gera os vencimentos e valores das parcelas conforme a condicao de venda
//
If lCondVenda 
	If ExistBlock("GMMA410Dupl")
		aVencto := ExecBlock("GMMA410Dupl",.F.,.F.,{ C5_NUM , C5_CONDPAG,dDataCnd,,MaFisRet(,"NF_BASEDUP") ,aVencto}, .F., .F.) 
	ElseIf ExistTemplate("GMMA410Dupl")
		aVencto := ExecTemplate("GMMA410Dupl",.F.,.F.,{ C5_NUM , C5_CONDPAG,dDataCnd,,MaFisRet(,"NF_BASEDUP") ,aVencto}) 
	Endif	
	aDupl := {}
	aEval(aVencto ,{|aTitulo| aAdd( aDupl ,{transform(aTitulo[1],x3Picture("E1_VENCTO")) ,transform(aTitulo[2],x3Picture("E1_VALOR"))}) })
EndIf

If Len(aDupl) == 0
	aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
	aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
EndIf
//????????????????????????
//?nalise da Rentabilidade - Valor Presente    ?
//????????????????????????
aRentabil := a410RentPV( aCols ,nUsado ,@aRenTab ,@aVencto ,nPTES,nPProduto,nPLocal,nPQtdVen,  C5_EMISSAO )

If cPaisLoc=="BRA" .And. AliasIndic("CDA")
	aAdd(aTitles,STR0114)	//"Lan?mentos da Apura?o de ICMS"
	nLancAp	:=	Len(aTitles)
EndIf

//lRetTotal quando .T. n? exibe a planilha mas retorna o NF_TOTAL de MafisRet
If !lRetTotal

	//????????????????????????
	//?onta a tela de exibicao dos valores fiscais ?
	//????????????????????????
	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0043) FROM 09,00 TO 28,80 //"Planilha Financeira"
	oFolder := TFolder():New(001,001,aTitles,{"HEADER"},oDlg,,,, .T., .F.,315,140)
	//????????????????????????
	//?older 1                                     ?
	//????????????????????????
	MaFisRodape(1,oFolder:aDialogs[1],,{005,001,310,60},Nil,.T.)
	If cPaisLoc <> "PTG"
		@ 070,005 SAY RetTitle("F2_FRETE")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 070,105 SAY RetTitle("F2_SEGURO")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 070,205 SAY RetTitle("F2_DESCONT")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 085,005 SAY RetTitle("F2_FRETAUT")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 085,105 SAY RetTitle("F2_DESPESA")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 085,205 SAY RetTitle("F2_VALFAT")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 070,050 MSGET MaFisRet(,"NF_FRETE")		PICTURE PesqPict("SF2","F2_FRETE",16,2)		SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 070,150 MSGET MaFisRet(,"NF_SEGURO")  	PICTURE PesqPict("SF2","F2_SEGURO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 070,250 MSGET MaFisRet(,"NF_DESCONTO")	PICTURE PesqPict("SF2","F2_DESCONTO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 085,050 MSGET MaFisRet(,"NF_AUTONOMO")	PICTURE PesqPict("SF2","F2_FRETAUT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 085,150 MSGET MaFisRet(,"NF_DESPESA")		PICTURE PesqPict("SF2","F2_DESPESA",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 085,250 MSGET MaFisRet(,"NF_BASEDUP")		PICTURE PesqPict("SF2","F2_VALFAT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 105,005 TO 106,310 PIXEL OF oFolder:aDialogs[1]
		@ 110,005 SAY OemToAnsi(STR0048)   SIZE 40,10 PIXEL OF oFolder:aDialogs[1] //"Total da Nota"
		@ 110,050 MSGET MaFisRet(,"NF_TOTAL")      PICTURE Iif(cPaisLoc=="CHI",TM(0,16,NIL),PesqPict("SF2","F2_VALBRUT",16,2))                   	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 110,270 BUTTON OemToAnsi(STR0049)			SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[1] PIXEL		//"Sair"
	Else 
		@ 070,005 SAY RetTitle("F2_DESCONT")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 070,105 SAY RetTitle("F2_FRETE")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 070,205 SAY RetTitle("F2_SEGURO")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 085,005 SAY RetTitle("F2_DESPESA")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 085,105 SAY RetTitle("F2_DESNTRB")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 085,205 SAY RetTitle("F2_TARA")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 110,005 SAY RetTitle("F2_VALFAT")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
		@ 070,050 MSGET MaFisRet(,"NF_DESCONTO")	PICTURE PesqPict("SF2","F2_DESCONTO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 070,150 MSGET MaFisRet(,"NF_FRETE")		PICTURE PesqPict("SF2","F2_FRETE",16,2)		SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 070,250 MSGET MaFisRet(,"NF_SEGURO")  	PICTURE PesqPict("SF2","F2_SEGURO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 085,050 MSGET MaFisRet(,"NF_DESPESA")		PICTURE PesqPict("SF2","F2_DESPESA",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 085,150 MSGET MaFisRet(,"NF_DESNTRB")		PICTURE PesqPict("SF2","F2_DESNTRB",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 085,250 MSGET MaFisRet(,"NF_TARA")		PICTURE PesqPict("SF2","F2_TARA",16,2)		SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 110,050 MSGET MaFisRet(,"NF_BASEDUP")		PICTURE PesqPict("SF2","F2_VALFAT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 105,005 TO 106,310 PIXEL OF oFolder:aDialogs[1]
		@ 110,105 SAY OemToAnsi(STR0048)   SIZE 40,10 PIXEL OF oFolder:aDialogs[1] //"Total da Nota"
		@ 110,150 MSGET MaFisRet(,"NF_TOTAL")      PICTURE Iif(cPaisLoc=="CHI",TM(0,16,NIL),PesqPict("SF2","F2_VALBRUT",16,2))                   	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
		@ 110,270 BUTTON OemToAnsi(STR0049)			SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[1] PIXEL		//"Sair"
	Endif
	//????????????????????????
	//?older 2                                     ?
	//????????????????????????                                                                                                     
	If lDtEmi
		@ 005,001 LISTBOX oDupl FIELDS TITLE aFlHead[1],aFlHead[2] SIZE 310,095 	OF oFolder:aDialogs[2] PIXEL
	Else	
		@ 005,001 LISTBOX oDupl FIELDS TITLE aFlHead[3],aFlHead[1],aFlHead[2] SIZE 310,095 	OF oFolder:aDialogs[2] PIXEL
	Endif	
	oDupl:SetArray(aDupl)
	oDupl:bLine := {|| aDupl[oDupl:nAt] }
	@ 105,005 TO 106,310 PIXEL OF oFolder:aDialogs[2]
	If cPaisLoc == "BRA"
		@ 110,005 SAY RetTitle("F2_VALFAT")		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
	Else
		@ 110,005 SAY OemToAnsi(STR0051)	    SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
	Endif	
	@ 110,050 MSGET MaFisRet(,"NF_BASEDUP")		PICTURE PesqPict("SF2","F2_VALFAT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[2]
	
	//
	// Template GEM - Gestao de empreendimentos imobiliarios
	// Manutencao dos itens da condicao de venda 
	//
	If ExistBlock("GMMA410CVND",,.T.)
		If ExistBlock("GMMA410Dupl")
			@ 110,170 BUTTON OemToAnsi("Cond. de Venda") SIZE 050,11 FONT oFolder:aDialogs[1]:oFont ;
						 ACTION ( ExecBlock("GMMA410CVND",.F.,.F.,{nOpc , C5_NUM , C5_CONDPAG ,dDataCnd ,MaFisRet(,"NF_BASEDUP")}) ;
									,aVencto := ExecBlock("GMMA410Dupl",.F.,.F.,{ C5_NUM , C5_CONDPAG,dDataCnd,,MaFisRet(,"NF_BASEDUP"),aVencto}) ;
									,( aDupl := {} ,aEval(aVencto ,{|aTitulo| aAdd( aDupl ,{transform(aTitulo[1],x3Picture("E1_VENCTO")) ,transform(aTitulo[2],x3Picture("E1_VALOR"))})}) ;
									,aRentabil := a410RentPV( aCols ,nUsado ,@aRenTab ,@aVencto ,nPTES,nPProduto,nPLocal,nPQtdVen,  C5_EMISSAO ) );
									,(oDupl:SetArray(aDupl),	oDupl:bLine := {|| aDupl[oDupl:nAt] }) ;
									,(oRentab:SetArray(aRentabil) ,oRentab:bLine := {|| aRentabil[oRenTab:nAt] }) ) ;
						 OF oFolder:aDialogs[2] PIXEL
		EndIf
	Else
		If ExistTemplate("GMMA410CVND",,.T.) .AND. HasTemplate("LOT")
			If ExistTemplate("GMMA410Dupl")
				@ 110,170 BUTTON OemToAnsi("Cond. de Venda") SIZE 050,11 FONT oFolder:aDialogs[1]:oFont ;
							 ACTION ( ExecTemplate("GMMA410CVND",.F.,.F.,{nOpc , C5_NUM , C5_CONDPAG ,dDataCnd ,MaFisRet(,"NF_BASEDUP")}) ;
										,aVencto := ExecTemplate("GMMA410Dupl",.F.,.F.,{ C5_NUM , C5_CONDPAG,dDataCnd,,MaFisRet(,"NF_BASEDUP"),aVencto}) ;
										,( aDupl := {} ,aEval(aVencto ,{|aTitulo| aAdd( aDupl ,{transform(aTitulo[1],x3Picture("E1_VENCTO")) ,transform(aTitulo[2],x3Picture("E1_VALOR"))})}) ;
										,aRentabil := a410RentPV( aCols ,nUsado ,@aRenTab ,@aVencto ,nPTES,nPProduto,nPLocal,nPQtdVen,  C5_EMISSAO ) );
										,(oDupl:SetArray(aDupl),	oDupl:bLine := {|| aDupl[oDupl:nAt] }) ;
										,(oRentab:SetArray(aRentabil) ,oRentab:bLine := {|| aRentabil[oRenTab:nAt] }) ) ;
							 OF oFolder:aDialogs[2] PIXEL
			EndIf
		EndIf
	Endif
	@ 110,270 BUTTON OemToAnsi(STR0049)			SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[2] PIXEL	//"Sair"
	//????????????????????????
	//?older 3                                     ?
	//????????????????????????
	@ 005,001 LISTBOX oRentab FIELDS TITLE aRFHead[1],aRFHead[2],aRFHead[3],aRFHead[4],aRFHead[5],aRFHead[6] SIZE 310,095 	OF oFolder:aDialogs[3] PIXEL
	@ 110,270 BUTTON OemToAnsi(STR0049)			SIZE 040,11 FONT oFolder:aDialogs[3]:oFont ACTION oDlg:End() OF oFolder:aDialogs[3] PIXEL		//"Sair"
	If Empty(aRentabil)
		aRentabil   := {{"",0,0,0,0,0}}
	EndIf
	oRentab:SetArray(aRentabil)
	oRentab:bLine := {|| aRentabil[oRentab:nAt] }
	
	If cPaisLoc=="BRA" .And. AliasIndic("CDA")
		oLancApICMS := A410LAICMS(oFolder:aDialogs[nLancAp],{005,001,310,095},@aHeadCDA,@aColsCDA,.T.,.F.)
		@ 110,270 BUTTON OemToAnsi(STR0049)			SIZE 040,11 FONT oFolder:aDialogs[nLancAp]:oFont ACTION oDlg:End() OF oFolder:aDialogs[nLancAp] PIXEL		//"Sair"
	EndIf
	 
	//???????????????????????????
	//?onto de entrada para inibir o Folder Rentabilidade ?
	//???????????????????????????
	If ExistBlock("M410FLDR") 
		lM410FldR := ExecBlock("M410FLDR",.F.,.F.)
		If ValType(lM410FldR) == "L" 
			oFolder:aDialogs[3]:lActive:= lM410FldR  
		EndIf
	EndIf

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT CursorArrow()
Else
	nValTotal := MaFisRet(,"NF_TOTAL")
EndIf

MaFisEnd()
MaFisRestore()

RestArea(aAreaSA1)
RestArea(aArea)

aRefRentab := aRentabil

If SuperGetMv("MV_RSATIVO",.F.,.F.)
	lPlanRaAtv := .T.
EndIf

If !lRetTotal
	Return(.T.)
Else
	Return(nValTotal)
EndIf
