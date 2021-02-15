#Include "rwmake.ch"

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

//////////////////////////////////////////////////////////////////////////
// Processo:  GDR003     - Manifesto de Vendas
// Criado  :  18-03-2010 - Claudenilson Dias
//////////////////////////////////////////////////////////////////////////

/////////////////////
User Function GDR003()
/////////////////////
Local _aArea 	:= Getarea()
Local cPerg		:= "" 		// Monta a pergunta = "GDR003    "
//CriaPerg(cPerg)						...retirada a pesquisa em parametros, agora so via SZM

Local Titulo  	:= PadC("Manifesto de Vendas - Vr. 1",30)
Local cDesc1  	:= PadC("Este programa ira emitir o manifesto de vendas do dia. ",74)
Local cDesc2  	:= " "
Local cDesc3  	:= " "
Local Cabec1  	:= " "
Local Cabec2  	:= " "

//               999999  BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB     999999     999999,99   999999999-000  00  (AA)-AAAAAAAAAAAAAAAAAAA
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                    1         2         3         4         5         6         7         8         9         0         1         2         3
//                                                                                                              1
// Local aReturn	:= { "Especial", 1,"Administracao", 1, 1, 1," ",1 }
Local aOrd  	:= {} //{"Por Matricula","Por Nome"}
Local cPict   	:= ""
Local nLin    	:= 80
Local lContinua	:= .T.

Private m_pag    	:= 01
Private CbTxt    	:= ""
Private nTipo    	:= 15
Private nLastKey 	:= 0
Private cbcont   	:= 00
Private ContFl   	:= 01
Private nomeprog  	:= "GDR003"
Private wnrel     	:= "GDR003"
Private Tamanho  	:= "M"
Private Limite   	:= 130
Private lEnd     	:= .F.
Private lAbortPrint := .F.
Private cString		:= "SD2"
Private aReturn		:= { "Especial", 1,"Administracao", 1, 1, 1," ",1 }

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+
/*
DbSelectArea("SX1")
If !DbSeek(cPerg,.F.)
RecLock("SX1", .F.)
SX1->X1_CNT01:= SCJ->CJ_NUM
MsUnlock()
DbSkip()
Next
*/

// Pergunte(cPerg,.F.)               // Pergunta no SX1

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
// wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.f.)

wnrel	:= SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.," ",.F.,tamanho,,.f.,,,,.t.,"LPT1")

If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif
RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	RptStatus({|| Execute(RptDetail)})

Return nil


///////////////////////////////
///////////////////////////////
Static Function RptDetail()
///////////////////////////////
///////////////////////////////

Local xL, xP, xC
Local aLocEntr   	:= {}
Local aProdut 		:= {}
Local aCliente 		:= {}
Local cTransp    	:= ""
Local cMotorista 	:= ""
Local cCodAjd1       := ""
Local cCodAjd2       := ""
Local cCodAjd3       := ""
Local cAjuda1       := ""
Local cAjuda2       := ""
Local cAjuda3       := ""
Local lHasLote		:= .F.
Local lSameProd	:= .F.
Local lFirst		:= .F.
Local _nX := 0 

SetRegua(2)

//                 voltar linhas 1
DbSelectArea("SZM")
cManifes   	:= ZM_MANIFES
cVeiculo   	:= ZM_VEICULO
cMotorista	:= ZM_MOTORIS
/*
cManifes   	:= "000101"
cVeiculo   	:= "000001"
cMotorista	:= "000001" 	*/

IncRegua("Gerando Dados")

Titulo  := "MANIFESTO DE CARGA - "+cManifes+ ' - '+dtoc(ZM_DATA)

_cQry := " "

//_cQry += " SELECT SD2.*, SB1.*, SF2.*, SA1.*, DA3.*, DA4.*  "
_cQry += " SELECT 	SF2.F2_CARGA,SD2.D2_QUANT, SD2.D2_TOTAL, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_LOTECTL, SB1.B1_COD, SB1.B1_DESC, SB1.B1_UM,"
_cQry += " 			SB1.B1_PESBRU, SF2.F2_VLBON, SF2.F2_VLDUP, SF2.F2_VLDIN, SF2.F2_VLCHQ, SA1.A1_BAIRRO, SA1.A1_NOME, DA3.DA3_DESC, DA3_PLACA, DA4.DA4_NOME "
_cQry += " 			FROM "+retsqlname("SD2")+ " AS SD2, "+retsqlname("SB1")+ " AS SB1, "+retsqlname("SF2")+ " AS SF2, "+retsqlname("DA3")+ " AS DA3, "+retsqlname("DA4")+ " AS DA4, "+retsqlname("SA1")+ " AS SA1 "
_cQry += "  WHERE  	SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND DA3.D_E_L_E_T_ <> '*' AND DA4.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' "
_cQry += " 	  		AND SD2.D2_FILIAL  = '"+xfilial("SD2")+"' "
_cQry += " 			AND SB1.B1_FILIAL  = '"+xfilial("SB1")+"' "
_cQry += " 			AND SF2.F2_FILIAL  = '"+xfilial("SF2")+"' "
_cQry += " 			AND SA1.A1_FILIAL  = '"+xfilial("SA1")+"' "
_cQry += " 			AND DA4.DA4_FILIAL = '"+xfilial("DA4")+"' "
_cQry += " 			AND DA3.DA3_FILIAL = '"+xfilial("DA3")+"' "
//_cQry += " AND  SD2.D2_EMISSAO = '" +dtos(_dData) +"' "
//_cQry += " AND  SD2.D2_EMISSAO >= '" +dtos(_dDataDe) +"' "
//_cQry += " AND  SD2.D2_EMISSAO <= '" +dtos(_dDataAte)+"' "
_cQry += " 			AND SA1.A1_COD     = SF2.F2_CLIENTE "
_cQry += " 			AND SA1.A1_LOJA    = SF2.F2_LOJA "
_cQry += " 			AND DA3.DA3_COD    = '"+cVeiculo+"' "
_cQry += " 			AND DA4.DA4_COD    = '"+cMotorista+"' "
_cQry += " 			AND SB1.B1_COD     = SD2.D2_COD "
_cQry += " 			AND SF2.F2_DOC     = SD2.D2_DOC  "
_cQry += " 			AND SF2.F2_SERIE   = SD2.D2_SERIE "
_cQry += " 			AND SF2.F2_EMISSAO = SD2.D2_EMISSAO "
_cQry += " 			AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "
_cQry += " 			AND SF2.F2_MANIFES = '"+cManifes+"' "

_cQry += " ORDER BY SF2.F2_SAIDA, SF2.F2_MANIFES "
// _cQry += " ORDER BY SF2.F2_DTDIGIT, SF2.F2_MANIFES "		// voltar linhas 4
//Else
//	_cQry += " ORDER BY SF2.F2_VEND12.D2_EMISSAO, SB1.B1_FABRIC , SB1.B1_COD "
//Endif
_cQry := ChangeQuery(_cQry)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cqRY), "TSD2", .F., .T.)

_aStrutmp1 := SB1->(dbStruct())

For _nX := 1 To Len(_aStrutmp1)
	If _aStrutmp1[_nX,2] $ "DN"
		TcSetField("TSD2",_aStrutmp1[_nX,1],_aStrutmp1[_nX,2],_aStrutmp1[_nX,3],_aStrutmp1[_nX,4])
	EndIf
Next nX

_aStrutmp1 := SD2->(dbStruct())

For _nX := 1 To Len(_aStrutmp1)
	If _aStrutmp1[_nX,2] $ "DN"
		TcSetField("TSD2",_aStrutmp1[_nX,1],_aStrutmp1[_nX,2],_aStrutmp1[_nX,3],_aStrutmp1[_nX,4])
	EndIf
Next nX

_aStrutmp1 := SF2->(dbStruct())

For _nX := 1 To Len(_aStrutmp1)
	If _aStrutmp1[_nX,2] $ "DN"
		TcSetField("TSD2",_aStrutmp1[_nX,1],_aStrutmp1[_nX,2],_aStrutmp1[_nX,3],_aStrutmp1[_nX,4])
	EndIf
Next nX

IncRegua("Consolidando")
DbSelectarea("TSD2")
DbGotop()

// aLocEntr   	:= {}
// aProdut	 	:= {}
// aCliente 	:= {}
cTransp    := Upper(alltrim(DA3_DESC))+" - "+ DA3_PLACA
cMotorista := Upper(alltrim(DA4_NOME))
cCodAjd1 := GetAdvFVal("DAK","DAK_AJUDA1",xFilial("DAK")+cManifes+"01",1)
cCodAjd2 := GetAdvFVal("DAK","DAK_AJUDA2",xFilial("DAK")+cManifes+"01",1)
cCodAjd3 := GetAdvFVal("DAK","DAK_AJUDA3",xFilial("DAK")+cManifes+"01",1)
cAjuda1 := Upper(Alltrim(GetAdvFVal("DAU","DAU_NOME",xFilial("DAU")+cCodAjd1,1)))
cAjuda2 := Upper(Alltrim(GetAdvFVal("DAU","DAU_NOME",xFilial("DAU")+cCodAjd2,1)))
cAjuda3 := Upper(Alltrim(GetAdvFVal("DAU","DAU_NOME",xFilial("DAU")+cCodAjd3,1)))

Do While !Eof()
	
	_cBairro:= Upper(alltrim(a1_bairro))
	_nBai 	:= Ascan( aLocEntr , { |X| upper(alltrim(X[1]))  == _cBairro  })
	
	If _nBai == 0
		aadd(aLocEntr,{_cBairro,1})
	Else
		aLocEntr[_nBai,2] ++
	Endif
	
	cProdut := alltrim(b1_cod)+'-'+upper(alltrim(b1_desc))
	_nPro 	:= Ascan( aProdut, { |X| upper(alltrim(X[1]))  == cProdut})
	
	If _nPro == 0
		Aadd(aProdut,{cProdut,D2_QUANT,D2_TOTAL,B1_UM,D2_QUANT*B1_PESBRU,D2_LOTECTL,D2_DOC+D2_SERIE})
	Else
		aProdut[_nPro,2] += D2_QUANT
		aProdut[_nPro,3] += D2_TOTAL
		aProdut[_nPro,5] += D2_QUANT*B1_PESBRU
		aProdut[_nPro,6] := D2_LOTECTL
		aProdut[_nPro,7] := D2_DOC+D2_SERIE
	Endif
	
	_cCLiente  := upper(alltrim(a1_nome))
	_cNF       := upper(alltrim(d2_doc))+'-'+upper(alltrim(d2_serie))+'-'+upper(alltrim(f2_carga))
	_cCliLoj   := D2_CLIENTE+D2_LOJA
	
	_nCli :=  Ascan( aCliente , { |x| upper(alltrim(X[1]))+upper(alltrim(X[2]))  == _cCliente+_cNF  })
	
	If _nCli == 0
		Aadd(aCliente, {_cCLiente,_cNF,D2_QUANT,_cCliLoj})
	Else
		aCliente[_nCli,3] += D2_QUANT
	Endif
	
	Dbselectarea("TSD2")
	DbSkip()
Enddo


If Len(aLocEntr) > 0 .Or. Len(aProdut) > 0 .Or. Len(aCliente) > 0
	
	aLocEntr   	:= aSort( aLocEntr 	,,, {|x,y| X[1]      < Y[1]      } )
	aProdut 	:= aSort( aProdut 	,,, {|x,y| X[1]    	  < Y[1]      } )
	aCliente 	:= aSort( aCliente 	,,, {|x,y| X[2]+X[1] < Y[2]+Y[1] } )
	
	SetRegua(Len(aLocEntr)+Len(aProdut)+Len(aCliente))
	
	nLin 	:= 80
	If !Empty(cCodAjd1) .Or. !Empty(cCodAjd2) .Or. !Empty(cCodAjd3)
		Cabec1 	:= 'VEICULO:   '+cTransp 
		Cabec2 	:= 'MOTORISTA: '+cMotorista + Space(25) + 'AJUDANTES:   '+cAjuda1+' / '+cAjuda2+' / '+cAjuda3
	Else
		Cabec1 	:= 'VEICULO:   '+cTransp
		Cabec2 	:= 'MOTORISTA: '+cMotorista
	EndIf

	
	
	If nLin > 70
		Cabec(Titulo,cabec1,cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	If len(aLocEntr) > 0
		
		_nCol := 0
		
		//nLin ++
		
		@nLin,00 PSAY PADC("LOCAIS DE ENTREGA",130)
		
		nLin ++
		@nLin,00 PSAY REPLICATE("_",130)
		nLin ++
		
		For xL := 1 to Len(aLocEntr)
			
			If nLin > 70
				Cabec(Titulo,cabec1,cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			IncRegua()
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			@ nLin, _nCol PSAY aLocEntr[xL,1]
			_nCol += 35
			If _nCol > 70
				_nCol := 0
				nLin  ++
			Endif
		Next
		nLin  ++
		@nLin,00 PSAY Replicate("_",130)
	Endif
	
	// Inicia a impressao do 1o Grupo = Relacao de Produtos
	
	If Len(aProdut) > 0
		
		lFirst 	:= .T. 		// desativado
		_nTotQtd:= 0
		_nTotPes:= 0
		cNumDoc	:= ""
		
		nLin ++
		@ nLin,01 Psay "PRODUTOS                                                    UM           QUANTIDADE               PESO BRUTO       LOTE "
		nLin ++
		@ nLin,00 Psay REPLICATE("_",130)
		nLin ++
		
		For xP := 1 to Len(aProdut)
			
			If nLin > 70
				Cabec(Titulo,cabec1,cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			lHasLote := !Empty(aProdut[xP][6])
			lSameProd := (aProdut[xP][1]==cNumDoc)
			cNumDoc	 := aProdut[xP][1]
			
			IncRegua()
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			// Pesquisa se e produto com Rastreabilidade
			If lHasLote
				If !lSameProd
					@ nLin, 01 PSAY Substr(aProdut[xP,1],1,50)
					@ nLin, 61 PSAY aProdut[xP,4]
				Endif
			Else
				@ nLin, 01 PSAY Substr(aProdut[xP,1],1,50)
				@ nLin, 61 PSAY aProdut[xP,4]
			Endif
			@ nLin, 77 Psay aProdut[xP,2] 	Picture "@e 999,999"
			@ nLin, 99 Psay aProdut[xP,5] 	Picture "@e 999,999.99"
			@ nLin,116 Psay aProdut[xP,6] 			// Picture "@e 999,999.99"
			_nTotQtd+=  aProdut[xP,2]
			_nTotPes+=  aProdut[xP,5]
			lFirst 	:= .F.
			nLin  ++
		Next
		
		@ nLin,77 PSAY REPLICATE("_",07)
		@ nLin,99 PSAY REPLICATE("_",10)
		
		nLin  ++
		@ nLin,77 PSAY _nTotQtd picture "@e 999,999"
		@ nLin,99 PSAY _nTotPes picture "@e 999,999.99"
		
		nLin  ++
		@ nLin,00 PSAY REPLICATE("_",130)
		//nLin  ++
		//@nLin,01 PSAY "PESO LIQ.  : "+ transform(szm->zm_pesol,"@e 999,999,999.99")
		//@nLin,61 PSAY "PESO BRT.  : "+ transform(szm->zm_pesoB,"@e 999,999,999.99")
		nLin += 2
		@ nLin,00 PSAY PADC("DADOS FINANCEIROS",130)
		
		nLin ++
		@ nLin,00 PSAY REPLICATE("_",130)
		
		nLin  ++
		@ nLin,001 PSAY "BONIFICACAO"
		@ nLin,015 PSAY "     BOLETO"
		@ nLin,030 PSAY "   DINHEIRO"
		@ nLin,045 PSAY "     CHEQUE"
		@ nLin,111 PSAY "      TOTAL"
		
		nLin  ++
		//			voltar linahs 2
		@ nLin,01  PSAY transform(szm->zm_vlbon,"@e 9999,999.99")
		@ nLin,15  PSAY transform(szm->zm_vldup,"@e 9999,999.99")
		@ nLin,30  PSAY transform(szm->zm_vldin,"@e 9999,999.99")
		@ nLin,45  PSAY transform(szm->zm_vlchq,"@e 9999,999.99")
		@ nLin,111 PSAY transform(szm->zm_vldup+szm->zm_vldin+szm->zm_vlchq,"@e 9,999,999.99")
		
		nLin  ++
		@ nLin,00 PSAY REPLICATE("_",130)
	Endif
	
	If Len(aCliente) > 0
		nLin += 2
		@ nLin,00 PSAY PADC("INFORMACOES POR CLIENTE",130)
		nLin ++
		@ nLin,00 PSAY REPLICATE("_",130)
		nLin ++
		@ nLin,01 PSAY "CLIENTES                                  NF         QTDE.  BONIFICACAO      BOLETO    DINHEIRO      CHEQUE          TOTAIS"
		//                      1         2         3         4         5         6         7         8         9         0         1         2
		//             1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
		nLin ++
		@ nLin,00 PSAY REPLICATE("_",130)
		nLin ++
		
		_nTotQtd := 0
		_nTotDup := 0
		_nTotDin := 0
		_nTotChq := 0
		_nTotBon := 0
		
		For xC :=1 to Len(aCliente)
			
			IncRegua()
			
			If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,cabec1,cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			@ nLin, 01 PSAY substr(aCliente[xC,1],1,40)
			@ nLin, 43 PSAY substr(aCliente[xC,2],1,9)
			@ nLin, 53 PSAY aCliente[xC,3] picture "@e 99,999"
			
			dbselectarea('SF2')
			dbsetorder(1)
			dbgotop()
			
			If dbseek(xfilial('SF2')+substr(aCliente[xC,2],1,9)+substr(aCliente[xC,2],11,3)+aCliente[xC,4],.f.)
				@ nLin, 061 PSAY f2_vlbon picture "@e 9999,999.99"
				@ nLin, 073 PSAY f2_vldup picture "@e 9999,999.99"
				@ nLin, 085 PSAY f2_vldin picture "@e 9999,999.99"
				@ nLin, 097 PSAY f2_vlchq picture "@e 9999,999.99"
				@ nLin, 112 PSAY f2_vlbon+f2_vldup+f2_vldin+f2_vlchq picture "@e 9,999,999.99"
				
				_nTotDup += f2_vldup
				_nTotDin += f2_vldin
				_nTotChq += f2_vlchq
				_nTotBon += f2_vlBon
			Endif
			
			DbSelectarea('SZM')				// voltar linhas 3
			_nTotQtd +=  aCliente[xC,3]
			
			nLin  ++
			
		Next
		
		@nLin,54 PSAY REPLICATE("_",70)
		
		nLin  ++
		@nLin, 053 PSAY _nTotQtd picture "@e 99,999"
		@nLin, 061 PSAY _nTotBon picture "@e 9999,999.99"
		@nLin, 073 PSAY _nTotDup picture "@e 9999,999.99"
		@nLin, 085 PSAY _nTotDin picture "@e 9999,999.99"
		@nLin, 097 PSAY _nTotChq picture "@e 9999,999.99"
		
		@nLin, 112 PSAY	_nTotDup+_nTotDIN+_nTotChq picture "@e 9,999,999.99"
		
		
		nLin  ++
		@nLin,00 PSAY REPLICATE("_",130)
		
	Endif
	
	nLin += 6
	
	@nLin,20 PSAY REPLICATE("_",30)
	@nLin,70 PSAY REPLICATE("_",30)
	
	nLin  ++
	@nLin,20 PSAY "ASSISTENTE RESPONSAVEL - CARGA"
	@nLin,70 PSAY PADC("TESOURARIA",30)
	
Else
	Alert("Sem dados para o relatorio !!")
Endif



Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

SetPgEject(.F.)

MS_FLUSH()

dbselectarea("TSD2")
dbclosearea()
dbselectarea("SD2")

return nil



///////////////////////////////
///////////////////////////////
Static Function CriaPerg(cPerg)
///////////////////////////////
///////////////////////////////
Local i := 0
Local j := 0

aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0

cPerg := PADR(cPerg,10)   // PADR("EXPORT",10) para Protheus 10
aRegistros:={}
//                                                                                      1                                                                                2                                                         3                               4
//               1      2    3                                4   5   6        7   8  9 0 1   2            3          4                  5  6  7  8  9                   0  1  2  3  4                5  6  7  8  9               0  1  2  3  4  5  6  7  8    9  0  1  2
Aadd(aRegistros,{cPerg,"01","Data                         ?",".",".","mv_ch1","D",08,0,0,"G",""          ,"mv_par01","               " ,"","","","","               "  ,"","","","","               ","","","","",""              ,"","","","","","","","","   ","","","",""})
//AADD(aRegistros,{cPerg,"02","Data Final                   ?",".",".","mv_ch2","D",08,0,0,"G",""          ,"mv_par02","               " ,"","","","","               "  ,"","","","","               ","","","","",""              ,"","","","","","","","","   ","","","",""})
//AADD(aRegistros,{cPerg,"03","Vendedor de                  ?",".",".","mv_ch3","C",03,0,0,"G",""          ,"mv_par03","               " ,"","","","","               "  ,"","","","","               ","","","","",""              ,"","","","","","","","","SA3","","","",""})
//AADD(aRegistros,{cPerg,"04","Vendedor Ate                 ?",".",".","mv_ch4","C",03,0,0,"G",""          ,"mv_par04","               " ,"","","","","               "  ,"","","","","               ","","","","",""              ,"","","","","","","","","SA3","","","",""})
//AADD(aRegistros,{cPerg,"05","Ordenado Por                 ?",".",".","mv_ch5","N",01,0,0,"C",""          ,"mv_par05","Emissao        " ,"","","","","Emissao + Vend."  ,"","","","","Emissao + Prod.","","","","","              ","","","","","","","","","   ","","","",""})
//AADD(aRegistros,{cPerg,"06","Imprime Resumo do Periodo    ?",".",".","mv_ch6","N",01,0,0,"C",""          ,"mv_par06","Sim            " ,"","","","","Nao            "  ,"","","","","So Resumo      ","","","","","              ","","","","","","","","","   ","","","",""})
//AADD(aRegistros,{cPerg,"07","Tipo                         ?",".",".","mv_ch7","N",01,0,0,"C",""          ,"mv_par07","Analitico      " ,"","","","","Sintetico      "  ,"","","","","               ","","","","","              ","","","","","","","","","   ","","","",""})
//AADD(aRegistros,{cPerg,"03","Fabricante                   ?",".",".","mv_ch3","C",20,0,0,"G",""          ,"mv_par03","               " ,"","","","","               "  ,"","","","",""               ,"","","","",""              ,"","","","","","","","","   ","","","",""})
//AADD(aRegistros,{cPerg,"05","Local                        ?",".",".","mv_ch6","C",02,0,0,"G",""          ,"mv_par06",""                ,"","","","",""                 ,"","","","",""               ,"","","","",""              ,"","","","","","","","","   ","","","",""})

dbSelectArea("SX1")
dbsetorder(1)


For i := 1 to Len(aRegistros)
	dbgotop()
	dbSeek(aRegistros[i,1]+aRegistros[i,2])
	if eof()
		if RecLock("SX1",.T.)
			For j:=1 to 42
				FieldPut(j,aRegistros[i,j])
			Next
			MsUnlock()
		Endif
	Endif
Next i

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

Return(nil)


