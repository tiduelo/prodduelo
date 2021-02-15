#INCLUDE "rwmake.ch"

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

//////////////////////////////////////////////////////////////////////////
// Processo:  GDR002     - Produtos Vendidos
// Criado  :  18-08-2009 - Claudenilson Dias
//////////////////////////////////////////////////////////////////////////

/////////////////////
User Function GDR002()
/////////////////////
_aArea := Getarea()

cPerg:= "GDR002    "   //--> monta a pergunta.
CriaPerg(cPerg)

titulo  := PADC("Vendas efetuadas no Periodo",74)

cDesc1  := PADC("Este programa ira emitir o relatorio de Posicao do estoque",74)
cDesc2  := " "
cDesc3  := " "

Cabec1  := "     CODIGO  DESCRICAO                                QUANTIDADE   PRECO VENDA   NOTA FISCAL    LC  VENDEDOR"
Cabec2  := " "

//               999999  BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB     999999     999999,99   999999999-000  00  (AA)-AAAAAAAAAAAAAAAAAAA
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                    1         2         3         4         5         6         7         8         9         0         1         2         3
//                                                                                                              1
aReturn      := { "Especial", 1,"Administracao", 1, 1, 1     ," ",1 }
aOrd         := {} //{"Por Matricula","Por Nome"}

lEnd         := .F.
lAbortPrint  := .F.
lContinua    := .T.

CbTxt        := ""
tamanho      := "M"
limite       := 130
nTipo        := 15
nLastKey     := 0

cbcont       := 00
CONTFL       := 01
m_pag        := 01

cPict   := ""
nLin    := 80

nomeprog  := "GDR002"
wnrel     := "GDR002"

cString   := "SD2"

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+

if Pergunte(cPerg,.t.)               // Pergunta no SX1
	
	
	//+--------------------------------------------------------------+
	//¦ Envia controle para a funcao SETPRINT                        ¦
	//+--------------------------------------------------------------+
	
	//wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.f.)
	
	wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.," ",.F.,tamanho,,.f.,,,,.t.,"LPT1")
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	RptStatus({|| Execute(RptDetail)})
	
Endif


Return nil

///////////////////////////////
///////////////////////////////
Static Function RptDetail()
///////////////////////////////
///////////////////////////////

Local _nX := 0 
Local _x := 0 

_dDataDe      := mv_par01
_dDataAte     := mv_par02
_cVendDe      := mv_par03
_cVendAte     := mv_par04
_nOrdem       := mv_par05
_nResumo      := mv_par06
_nTipo        := mv_par07

titulo  :=PADC("Vendas no Periodo - "+dtoc(_dDataDe)+ " a "+dtoc(_dDataAte),74)

_cQry := " "

_cQry += " SELECT SD2.*, SB1.*, SF2.*, SA3.*,SA2.*  FROM "+retsqlname("SD2")+ " AS SD2, "+retsqlname("SB1")+ " AS SB1, "+retsqlname("SF2")+ " AS SF2, "+retsqlname("SA3")+ " AS SA3, "+retsqlname("SA1")+ " AS SA1 "
_cQry += " WHERE  SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' "
_cQry += " AND  SD2.D2_FILIAL = '"+xfilial("SD2")+"' "
_cQry += " AND  SF2.F2_FILIAL = '"+xfilial("SF2")+"' "
_cQry += " AND  SA3.A3_FILIAL = '"+xfilial("SA3")+"' "
_cQry += " AND  SA1.A1_FILIAL = '"+xfilial("SA1")+"' "
_cQry += " AND  SD2.D2_EMISSAO >= '" +dtos(_dDataDe) +"' "
_cQry += " AND  SD2.D2_EMISSAO <= '" +dtos(_dDataAte)+"' "


_cQry += " AND  SA1.A1_COD     = SF2.F2_CLIENTE "
_cQry += " AND  SA1.A1_LOJA    = SF2.F2_LOJA "
_cQry += " AND  SA3.A3_COD     = SF2.F2_VEND1  "
_cQry += " AND  SB1.B1_COD     = SD2.D2_COD "
_cQry += " AND  SF2.F2_DOC     = SD2.D2_DOC  "
_cQry += " AND  SF2.F2_SERIE   = SD2.D2_SERIE "
_cQry += " AND  SF2.F2_EMISSAO = SD2.D2_EMISSAO "
_cQry += " AND  SF2.F2_CLIENTE = SD2.D2_CLIENTE "



//if  _nOrdem == 3
_cQry += " ORDER BY SF2.F2_EMISSAO, SF2.F2_VEND1  , SD2.D2_QUANT              "
//Else
//	_cQry += " ORDER BY SF2.F2_VEND12.D2_EMISSAO, SB1.B1_FABRIC , SB1.B1_COD "
//Endif

_cQry := ChangeQuery(_cQry)

//alert(_cQry)


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

//SetRegua( len(_aContas) )
dbselectarea("TSD2")
dbgotop()

_nTotIte := 0
_nTotQtd := 0
_nTotVal := 0

_lChave = ".t."

_aRelDados := {}

// Emissao
// Vendedor
// Produto
// NF
// Serie
// Cliente
// Qtd
// Valor
// Periodo
// tipo

Do While ! eof()
	
	_cEmissao := dtos(f2_emissao)
	_cVende   := f2_vend1
	_cProd    := alltrim(upper(b1_desc))+" - "+alltrim(b1_cod)
	_cNF      := f2_doc
	_cserie   := f2_serie
	_cCLiente := alltrim(upper(a1_nome))+" - "+alltrim(a1_cod)
	_nQtd     := d2_quant
	_nValor   := d2_total
	_cTipo    := "2"
	
	_n1 :=  aScan( _aRelDados , { |X| X[1]+X[2]+X[3] == _cEmissao+_cVende+_cProd  })
	
	if _n1 == 0
		aadd(_aRelDados,{_cEmissao,_cVende,_cProd,_cNF,_cSerie,_cCLiente,_nQtd,_nValor_cTipo})
	Else
		_aRelDados[_n1,7] += _nQtd
		_aRelDados[_n1,8] += _nValor
	Endif
	
	dbselectarea("TSD2")
	dbskip()
	
Enddo

if len(_aRelDados) > 0
	
	
	_aResumo := {}
	
	IF _nOrdem == 1
		_aRelDados := aSort( _aRelDados,,, {|x,y| X[1] < Y[1]} )
		_cChave := _aRelDados[1,1]
	Elseif _nOrdem == 2
		_aRelDados := aSort( _aRelDados,,, {|x,y| X[1]+X[2] < Y[1]+Y[2]} )
		_cChave := _aRelDados[1,1]+_aRelDados[1,2]
	Else
		_aRelDados := aSort( _aRelDados,,, {|x,y| X[1]+X[3] < Y[1]+Y[3]} )
		_cChave := _aRelDados[1,1]+_aRelDados[1,3]
	Endif
	
	
	_nQtd     := 0
	_nTotal   := 0

	_cPriLin  := _aRelDados[1,1]
	
	For _x :=1 to len(_aRelDados)
		
		//procregua()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		nLin ++
		
		
		IF _nOrdem == 1
			
			_cChave2  := _aRelDados[_x,1]
			
			if _cChave2 <> _cChave  .or. _x == len(_aRelDados)
				
				@ nLin, 01 PSAY _dData
				@ nLin, 12 PSAY transform(_nQtd,"@e 999,999,999.99")
				@ nLin, 27 PSAY transform(_nTotal,"@e 999,999,999.99")
				
				nLin += 2
				
				_dData    := _aRelDados[_x,1]
				
				_nQtd    := 0
				_nTotal  := 0
				
			Else
				_dData    := _aRelDados[_x,1]
				_nQtd    += _aRelDados[_y,7]
				_nTotal  += _aRelDados[_y,8]
			Endif
			
			
			
		Endif
		
		IF _nOrdem == 2
			
			_cChave2  := _aRelDados[_x,1]+_aRelDados[_x,2]
			
			if _cChave2 <> _cChave  .or. _x == len(_aRelDados)
				
				if 	_cPriLin  == _aRelDados[_x,1]

					@ nLin, 01 PSAY _dData
					_lPriLin  := .f.
				Endif

				@ nLin, 12 PSAY _cVend
				@ nLin, 24 PSAY transform(_nQtd,"@e 999,999,999.99")
				@ nLin, 39 PSAY transform(_nTotal,"@e 999,999,999.99")
				
				nLin += 1
				
				_dData    := _aRelDados[_x,1]
				
				_nQtd    := 0
				_nTotal  := 0
				
			Else
				_dData    := _aRelDados[_x,1]
				_nQtd    += _aRelDados[_y,7]
				_nTotal  += _aRelDados[_y,8]
			Endif
			
			
			
		Endif
		
		
		_nDatIte := 0
		_nDatQtd := 0
		_nDatVal := 0
		
		
		
		
		Do While ! eof() .and. D2_EMISSAO == _dData
			
			dbselectarea("SA3")
			dbsetorder(1)
			dbgotop()
			
			_cNomVen := "(XX) SEM VENDEDOR"
			
			if dbseek(xfilial("SA3")+TSD2->F2_VEND1)
				_cNomVen := UPPER(SUBSTR("("+alltrim(TSD2->F2_VEND1)+")-"+ALLTRIM(A3_NOME) ,1,20))
			Endif
			
			dbselectarea("TSD2")
			
			If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				
				@ nLin, 01 PSAY _dData
				nLin += 2
				
				IF _nordem == 4
					
					@ nLin, 01 PSAY replicate("-",50)
					nLin ++
					@ nLin, 01 PSAY _cNomVen
					nLin ++
					@ nLin, 01 PSAY replicate("-",50)
					nLin += 1
					
					_cCodVen := F2_VEND1
					
				Endif
				
			Else
				
				IF _nordem == 4 .and. _cCodVen <> F2_VEND1
					
					@ nLin, 01 PSAY replicate("-",50)
					nLin ++
					@ nLin, 01 PSAY _cNomVen
					nLin ++
					@ nLin, 01 PSAY replicate("-",50)
					nLin += 1
					
					_cCodVen := F2_VEND1
					
				Endif
				
			Endif
			
			_nVenIte := 0
			_nVenQtd := 0
			_nVenVal := 0
			
			Do While !eof() .and. &(_lChave)
				
				_cCodFab := B1_FABRIC
				
				@ nLin, 03 PSAY iif(empty(_cCodFab),"FABRICANTE NAO IDENTIFICADO",_cCodFab)
				nLin += 2
				
				_nFabIte := 0
				_nFabQtd := 0
				_nFabVal := 0
				
				Do While ! eof() .and. D2_EMISSAO == _dData .and. _cCodFab == B1_FABRIC
					
					
					dbselectarea("SA3")
					dbsetorder(1)
					dbgotop()
					
					_cNomVen := "(XX) SEM VENDEDOR"
					
					if dbseek(xfilial("SA3")+TSD2->F2_VEND1)
						_cNomVen := UPPER(SUBSTR("("+alltrim(TSD2->F2_VEND1)+")-"+ALLTRIM(A3_NOME) ,1,20))
					Endif
					
					dbselectarea("TSD2")
					
					If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
						
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
						@ nLin, 01 PSAY _dData
						nLin += 2
						
						IF _nordem == 4
							@ nLin, 01 PSAY replicate("-",50)
							nLin ++
							@ nLin, 01 PSAY _cNomVen
							nLin ++
							@ nLin, 01 PSAY replicate("-",50)
							nLin += 1
						Endif
						
						@ nLin, 03 PSAY _cCodFab
						nLin += 2
						
					Endif
					
					@ nLin,05 PSAY SUBSTR(D2_COD,1,6)
					@ nLin,13 PSAY SUBSTR(B1_DESC,1,40)
					@ nLin,58 PSAY D2_QUANT    PICTURE "@E 999999"
					@ nLin,69 PSAY D2_TOTAL    PICTURE "@E 999999.99"
					@ nLin,81 PSAY F2_DOC+"-"+F2_SERIE
					@ nLin,96 PSAY D2_LOCAL
					
					if _nordem <> 4
						@ nLin,100 PSAY _cNomVen
					Endif
					
					nLin := nLin + 1 // Avanca a linha de impressao
					
					_nDatIte ++
					_nDatQtd += D2_QUANT
					_nDatVal += D2_TOTAL
					
					_nFabIte ++
					_nFabQtd += D2_QUANT
					_nFabVal += D2_TOTAL
					
					
					_nVenIte ++
					_nVenQtd += D2_QUANT
					_nVenVal += D2_TOTAL
					
					_nTotIte ++
					_nTotQtd += D2_QUANT
					_nTotVal += D2_TOTAL
					
					dbselectarea("TSD2")
					dbskip()
					
					if  eof() .or. B1_FABRIC <> _cCodFab .or. D2_EMISSAO <> _dData .or. (_nordem == 4 .and. F2_VEND1 <> _ccodven)
						
						
						if  B1_FABRIC <> _cCodFab
							@ nLin,05 PSAY REPLICATE("-",120)
							nLin := nLin + 1
							
							@ nLin, 005  PSAY "Listados do Fabricante: "+ transform(_nFabIte,"@E 9999") + " itens"
							@ nLin, 058  PSAY  _nFabQtd PICTURE "@E 999999"
							@ nLin, 069  PSAY  _nFabVal PICTURE "@E 999999.99"
							nLin := nLin + 2
						Endif
						
						if  _nordem == 4 .and. F2_VEND1 <> _ccodven
							@ nLin,05 PSAY REPLICATE("-",120)
							nLin := nLin + 1
							
							@ nLin, 005  PSAY "Listados do Vendedor:   "+ transform(_nVenIte,"@E 9999") + " itens"
							@ nLin, 058  PSAY  _nVenQtd PICTURE "@E 999999"
							@ nLin, 069  PSAY  _nVenVal PICTURE "@E 999999.99"
							nLin := nLin + 2
						Endif
						
						if  D2_EMISSAO <> _dData
							
							@ nLin,00 PSAY REPLICATE("-",120)
							nLin := nLin + 1
							
							@ nLin, 000  PSAY "Listados no dia : "+dtoc(_dData)+" - "+ transform(_nDatIte,"@E 9999") + " itens"
							@ nLin, 058  PSAY  _nDatQtd PICTURE "@E 999999"
							@ nLin, 069  PSAY  _nDatVal PICTURE "@E 999999.99"
							nLin := nLin + 2
						Endif
						
						
					Endif
					
				Enddo
				
			Enddo
			
		Enddo
		
	Next
Else
	Alert("Sem dados para o relatorio !!")
Endif


nLin := nLin + 1
@ nLin,0 PSAY REPLICATE("_",120)
nLin := nLin + 1

@ nLin, 000  PSAY "Resumo Geral: "+ transform(_nTotIte,"@E 9999") + " Itens"
@ nLin, 058  PSAY  _nTotQtd PICTURE "@E 999999"
@ nLin, 069  PSAY  _nTotVal PICTURE "@E 999999.99"
nLin := nLin + 1


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

Local j := 0
Local i := 0

aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0

cPerg := PADR(cPerg,10) //PADR("EXPORT",10) para Protheus 10
aRegistros:={}
//                                                                                      1                                                                                2                                                         3                               4
//               1      2    3                                4   5   6        7   8  9 0 1   2            3          4                  5  6  7  8  9                   0  1  2  3  4                5  6  7  8  9               0  1  2  3  4  5  6  7  8    9  0  1  2
AADD(aRegistros,{cPerg,"01","Data Inicial                 ?",".",".","mv_ch1","D",08,0,0,"G",""          ,"mv_par01","               " ,"","","","","               "  ,"","","","","               ","","","","",""              ,"","","","","","","","","   ","","","",""})
AADD(aRegistros,{cPerg,"02","Data Final                   ?",".",".","mv_ch2","D",08,0,0,"G",""          ,"mv_par02","               " ,"","","","","               "  ,"","","","","               ","","","","",""              ,"","","","","","","","","   ","","","",""})
AADD(aRegistros,{cPerg,"03","Vendedor de                  ?",".",".","mv_ch3","C",03,0,0,"G",""          ,"mv_par03","               " ,"","","","","               "  ,"","","","","               ","","","","",""              ,"","","","","","","","","SA3","","","",""})
AADD(aRegistros,{cPerg,"04","Vendedor Ate                 ?",".",".","mv_ch4","C",03,0,0,"G",""          ,"mv_par04","               " ,"","","","","               "  ,"","","","","               ","","","","",""              ,"","","","","","","","","SA3","","","",""})
AADD(aRegistros,{cPerg,"05","Ordenado Por                 ?",".",".","mv_ch5","N",01,0,0,"C",""          ,"mv_par05","Emissao        " ,"","","","","Emissao + Vend."  ,"","","","","Emissao + Prod.","","","","","              ","","","","","","","","","   ","","","",""})
AADD(aRegistros,{cPerg,"06","Imprime Resumo do Periodo    ?",".",".","mv_ch6","N",01,0,0,"C",""          ,"mv_par06","Sim            " ,"","","","","Nao            "  ,"","","","","So Resumo      ","","","","","              ","","","","","","","","","   ","","","",""})
AADD(aRegistros,{cPerg,"07","Tipo                         ?",".",".","mv_ch7","N",01,0,0,"C",""          ,"mv_par07","Analitico      " ,"","","","","Sintetico      "  ,"","","","","               ","","","","","              ","","","","","","","","","   ","","","",""})
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


