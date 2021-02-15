#include "TOPCONN.CH"
#INCLUDE "rwmake.ch"

/////////////////////////
/////////////////////////
User Function GDR001()
/////////////////////////
/////////////////////////


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local   cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2       := "de acordo com os parametros informados pelo usuario."
Local   cDesc3       := "RELACAO DE CLIENTES"
Local   cPict        := ""
Local   titulo       := "RELACAO DE CLIENTES"
Local   nLin         := 80

Local   Cabec1       := ""
Local   Cabec2       := ""
Local   imprime      := .T.
Local   aOrd         := {"Por Municipio","Por Bairro","Por Estado","Por Regiao","Por Vendedor"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 130
Private tamanho      := "M"
Private nomeprog     := "GDR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "GDR001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SA1"
Private cDrive       := "EPSON.DRV"
Private lServer      := .T.
Private cNomeImp     := nil // "LPT1"

Private cPerg        := padr("GDR001",10)

dbSelectArea("SA1")
dbSetOrder(1)

criaperg(cPerg)

Do While .t.
	
	if pergunte(cPerg,.t.)
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta a interface padrao com o usuario...                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,nil,.F.,nil,nil,.F.,lServer,cNomeImp)
		//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,nil,.T.,nil,cDrive,.T.,lServer,cNomeImp)
		
		//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
		
		
		If nLastKey == 27
			Return
		Endif
		
		SetDefault(aReturn,cString)
		
		If nLastKey == 27
			Return
		Endif
		
		nTipo := 15 //If(aReturn[4]==1,15,18)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
		
	endif
	
	if ! msgyesno("Gera novo relatório ?")
		exit
	Endif
	
Enddo

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  08/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local i := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SA1")

setregua(RecCount())

_cEst    := mv_par01
_cMun    := mv_par02
_cReg    := mv_par03
_cCli    := mv_par04
_nBlq    := mv_par05
_cVen    := mv_par06
//_nMov    := mv_par07
_dMovDe  := mv_par07
_dMovAte := mv_par08
_nValde  := mv_par09
_nValAte := mv_par10
_cBairro := mv_par11
//_nMovim  := mv_par12
nOrdem   := aReturn[8]


//Local   aOrd         := {"Por Municipio","Por Bairro","Por Estado","Por Regiao","Por Vendedor"}

IF nOrdem == 1
	_cOrd   := " ORDER BY A1_EST, A1_MUN , A1_NOME "
	_cChave := " A1_MUN AS CHAVE "
	titulo  := "RELACAO DE CLIENTES - MUNICIPIO "
ElseIF nOrdem == 2
	_cOrd   := " ORDER BY A1_EST, A1_MUN ,A1_BAIRRO, A1_NOME "
	_cChave := " A1_BAIRRO AS CHAVE "
	titulo  := "RELACAO DE CLIENTES - BAIRRO "
ElseIF nOrdem == 3
	_cOrd   := " ORDER BY A1_EST,  A1_NOME "
	_cChave := " A1_EST AS CHAVE "
	titulo  := "RELACAO DE CLIENTES - ESTADO "
ElseIF nOrdem == 4
	_cOrd   := " ORDER BY A1_REGIAO, A1_NOME "
	_cChave := " A1_REGIAO AS CHAVE "
	titulo  := "RELACAO DE CLIENTES - REGIAO "
ElseIF nOrdem == 5
	_cOrd   := " ORDER BY A1_VEND, A1_NOME  "
	_cChave := " A1_VEND AS CHAVE "
	titulo  := "RELACAO DE CLIENTES - VENDEDOR "
Else
	_cOrd   := " ORDER BY A1_EST, A1_MUN , A1_NOME "
	_cChave := " A1_NOME AS CHAVE "
	titulo  := "RELACAO DE CLIENTES - MUNICIPIO "
Endif


_cQuery := " SELECT *, "+_cChave
_cQuery += " FROM  " + RetSqlName("SA1") + " SA1 "
_cQuery += " WHERE  SA1.D_E_L_E_T_ <> '*' "
_cQuery += " AND  A1_FILIAL = '"+XFILIAL("SA1")+"' "

If ! empty(_cEst)
	_cQuery += " AND  A1_EST = '"+UPPER(_cEst)+"' "
Endif

If ! empty(_cMun)
	_cQuery += " AND  A1_COD_MUN = '"+UPPER(_cMun)+"' "
Endif

If !empty(_cReg  )
	_cQuery += " AND  ( A1_REGIAO = '"+UPPER(_cReg)+"') "
Endif

If !empty(_cCli)
	if substr(_cCli,1,1) = "-"
		_cQuery += " AND  UPPER(A1_NOME) LIKE '%"+UPPER(ALLTRIM(substr(_cCli,2)))+"%' "
	Elseif substr(_cCli,1,1) $ "0123456789" .and. len(alltrim(_cCli)) <=6
		_cCli := strzero(val(_cCli),6)
		_cQuery += " AND  A1_COD = '"+_cCli+"' "
	Else
		_cCli     := alltrim(upper(_cCli))
		_nTamCli  :=  str(len(_cCli),2,0)
		_cQuery += " AND  UPPER(SUBSTRING(A1_NOME,1,"+_nTamCli+" )) = '"+_cCli+"' "
	Endif
Endif

If ! empty(_nBlq) .and. _nBlq <> 3
	_cQuery += " AND  A1_MSBLQL = '"+str(_nBlq,1)+"' "
Endif

If !empty(_cVen)
	_cQuery += " AND  ( A1_VEND = '"+UPPER(_cVen)+"') "
Endif

//If _nMov == 1 .and. !empty(_dMovDe) .and. !empty(_dMovAte)
//	_cQuery += " AND  ( A1_ULTCOM >= '"+dtos(_dMovDe)+"' AND  A1_ULTCOM <= '"+dtos(_dMovAte)+"') "
//Endif

//If _nMov == 2
//	_cQuery += " AND  A1_ULTCOM <= '"+dtos(_dMovDe)+"' "
//Endif

//If !empty(_nValde) .or. !empty(_nValAte)
//	_cQuery += " AND  ( A1_VACUM >= '"+STR(_nValde,12,2)+"' AND  A1_VACUM <= '"+STR(_nValde,12,2)+"' ) "
//Endif

If !empty(_cBairro)
	_cQuery += " AND  A1_BAIRRO LIKE '%"+UPPER(ALLTRIM(_cbairro))+"%' "
Endif

_cQuery += _cOrd

//ALERT(_cQuery)


TCQUERY _cQuery NEW ALIAS "TRBSA1"

TcSetField("TRBSA1", "A1_ULTCOM","D",8,0)
TcSetField("TRBSA1", "A1_LC    ","N",12,2)
TcSetField("TRBSA1", "A1_VACUM ","N",12,2)
TcSetField("TRBSA1", "A1_SALDUP","N",12,2)

dbSelectArea("TRBSA1")
dbGoTop()

_nCtdCLi := 0

If ! eof()
	
	While !EOF()
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		//           1         2         3         4         5         6         7         8         9         0         1         2         3
		// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		// 999999 NOME_AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ENDERECO_BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB BAIRRO_DDDDDDDDDDDDD MUNICIPIO_CCCCC    PA
		//        GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
		//        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE          99.999.999.9999.99          999.999.999,99
		//        999.999.999.99         999.999.999.999.99 999.99          999999  999999  999.999.999.99 999999
		
		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
		
		//02  a1_cod   ,6
		//04  a1_nome  ,40
		//08  a1_end   ,40
		//11  a1_mun   ,15
		//12  a1_bairro,30
		//19  a1_tel,   15
		//24  a1_cgc, 14
		//24  a1_est, 14
		//34  a1_endcob, 40
		//43  a1_msaldo        , 40
		//51  a1_mcompra
		//52  a1_metr
		//53  a1_saldup
		//54  a1_vacum
		//55  a1_matr
		//58  a1_ultcom
		//A6  aq_lc
		//A7
		
		_cChave := CHAVE
		
		IF nOrdem == 1
			@nLin,02 PSAY "MUNICIPIO:  "+ _cChave
		ElseIF nOrdem == 2
			@nLin,02 PSAY "BAIRRO:  "+ _cChave
		ElseIF nOrdem == 3
			@nLin,02 PSAY "ESTADO:  "+ _cChave
		ElseIF nOrdem == 4
			@nLin,02 PSAY "REGIAO:  "+ _cChave
		ElseIF nOrdem == 5
			@nLin,02 PSAY "VENDEDOR:  "+ _cChave
		Endif
		
		nLin ++
		
		@nLin,00 PSAY REPLICATE("-",130)
		nLin ++
		
		
		Do While ! eof() .and. 	_cChave == CHAVE
			
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			procregua()
			
			
			_dVenPri   := ctod("")
			_dVenUlt   := ctod("")
			_nVenAcmA  := 0
			_nVenAcmt  := 0
			_nVenNumA  := 0
			_nVenNumt  := 0
			
			_nVenMai   := 0
			
			_nDupMai   := 0
			_nDupSal   := 0
			_nDupAtr   := 0
			_nDupAtrM  := 0
			_aMedAtr   := {}
			_aMedVal   := {}
			
			_nDupAtrq  := 0
			
			_lMov := .t.
			
			DbSelectarea("SF2")
			DbSetorder(9)
			dbgotop()
			
			dbseek(xfilial("SF2")+TRBSA1->A1_COD+TRBSA1->A1_LOJA,.F.)
			
			Do While ! eof() .and. F2_FILIAL+F2_CLIENTE+F2_LOJA == xfilial("SF2")+TRBSA1->A1_COD+TRBSA1->A1_LOJA
				
				if empty(_dVenPri)
					_dVenPri := f2_emissao
				Endif
				
				if _dVenUlt < f2_emissao
					_dVenUlt :=  f2_emissao
				Endif
				
				_nVenNumt  ++
				_nVenAcmt  += f2_valbrut
				
				if f2_valbrut > _nVenMai
					_nVenMai    := f2_valbrut
				Endif
				
				if f2_emissao >=  _dMovDe .and. f2_emissao <= _dMovAte
					_nVenAcmA  += f2_valbrut
					_nVenNumA  ++
				Endif
				
				dbskip()
				
			Enddo
			
			If !empty(_nValde) .or. !empty(_nValAte)
				if _nVenAcmA < _nValde .or.  _nVenAcmA > _nValAte
					DbSelectarea("TRBSA1")
					dbskip()
					loop
				Endif
			Endif
			
			
			DbSelectarea("SE1")
			DbSetorder(22)
			dbgotop()
			
			dbseek(xfilial("SE1")+TRBSA1->A1_COD+TRBSA1->A1_LOJA,.F.)
			
			Do While ! eof() .and. E1_FILIAL+E1_CLIENTE+E1_LOJA == xfilial("SE1")+TRBSA1->A1_COD+TRBSA1->A1_LOJA
				
				aadd(_aMedVal,e1_valor)
				
				if e1_valor > _nDupMai
					_nDupMai   := e1_valor
				Endif
				
				_nDupSal   += e1_saldo
				
				
				if ( e1_saldo == 0  .and. e1_baixa > e1_vencrea ) .or.  (e1_saldo > 0 .and. e1_vencrea < ddatabase)
					
					if e1_saldo == 0  .and. e1_baixa > e1_vencrea
						_nDiaAtr   := e1_baixa - e1_vencrea
					Else
						_nDiaAtr   := ddatabase - e1_vencrea
					Endif
					
					
					_nDupAtrq  ++
					aadd(_aMedAtr,_nDiaAtr)
					
					if	_nDiaAtr > _nDupAtrM
						_nDupAtrM  := _nDiaAtr
					Endif
					
					_nDupAtr += e1_saldo
					
				Endif
				
				
				dbskip()
				
			Enddo
			
			_nMedAtr := 0
			_nMedVal := 0
			
			if len(_aMedAtr) > 0
				
				for i:=1 to len(_aMedAtr)
					_nMedAtr +=  _aMedAtr[i]
				Next
				
				_nMedAtr := int(_nMedAtr/len(_aMedAtr))
				
			Endif
			
			if len(_aMedVal) > 0
				
				for i:=1 to len(_aMedVal)
					_nMedVal +=  _aMedVal[i]
				Next
				
				_nMedVal := int(_nMedVal/len(_aMedVal))
				
			Endif
			
			
			DbSelectarea("TRBSA1")
			
			@nLin,02 PSAY A1_COD+" "+A1_NOME+" "+A1_END+" "+SUBSTR(A1_BAIRRO,1,20)+" "+A1_MUN+" "+A1_EST
			nLin ++
			
			@nLin,02 PSAY SPACE(6)+" "+"Compra (Primeira/Ultima): "+dtoc(_dVenPri)+" - "+dtoc(_dVenUlt)+space(18)+"Telefone: "+a1_tel+space(08)+"CNPJ:"+iif(len(alltrim(A1_CGC))==14,transform(a1_cgc,"@r 99.999.999/999-99"),transform(a1_cgc,"@r 999.999.999-99"))
			nLin ++
			
			if _nVenNumt > 0
				@nLin,02 PSAY SPACE(6)+" "+"Compras Total: "+padr(str(_nVenNumt,3)+" - "+alltrim(transform(_nVenAcmt,"@e 999,999,999.99")),22)+space(12)+"Media..........: "+alltrim(transform(_nVenAcmt/_nVenNumt,"@e 999,999,999.99"))
				nLin ++
			Endif
			
			if _nVenNumA > 0
				@nLin,02 PSAY SPACE(6)+" "+"Compras Ano..: "+padr(str(_nVenNumA,3)+" - "+alltrim(transform(_nVenAcmA,"@e 999,999,999.99")),22)+space(12)+"Media..........: "+alltrim(transform(_nVenAcmA/_nVenNumA,"@e 999,999,999.99"))
				nLin ++
			Endif
			
			@nLin,02 PSAY SPACE(6)+" "+"Maior Compra.:     - "+padr(alltrim(transform(_nVenMai,"@e 999,999,999.99")),22)+space(6)+"Saldo Duplicata: "+padr(alltrim(transform(_nDupSal,"@e 999,999,999.99")),15)+space(5)+"Lim.Credito: "+alltrim(transform(a1_lc,"@e 999,999,999.99"))
			nLin ++
			
			@nLin,02 PSAY SPACE(6)+" "+"Saldo Atr....: "+padr(str(_nDupAtrq,3)+" - "+alltrim(transform(_nDupAtr,"@e 999,999,999.99")),22)+space(12)+"Atraso - Media/Maior (dias): "+transform(_nMedAtr,"999")+" / "+transform(_nDupAtrM,"999")
			nLin ++
			
			nLin ++
			
			
			
			//43  a1_msaldo        , 40
			//51  a1_mcompra
			//52  a1_metr
			//53  a1_saldup
			//54  a1_vacum
			//55  a1_matr
			//58  a1_ultcom
			//A6  aq_lc
			
			dbSkip() // Avanca o ponteiro do registro no arquivo
			
			_nCtdCLi ++
			
		Enddo
		
		@nLin,00 PSAY REPLICATE("-",130)
		nLin ++
		
	EndDo
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@nLin,00 PSAY "TOTAL DE CLIENTES : "+strzero(_nCtdCLi,6)
	nLin ++
	
	dbclosearea()
	dbselectarea("SA1")
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Else
	alert("Nao existem dados para o relatorio")
Endif

Return




/**************************/
Static Function CriaPerg(cPerg)
/**************************/
Local j := 0
Local i := 0

aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0

aRegistros:={}
//               1      2   3                       4   5     6      7  8  9  10 11  12     13         14                15 16 17 18 19                20 21 22 23 24      25 26 27 28 29 30 31 32 33 34 35 36 37  38   39 40 41 42 43
AADD(aRegistros,{cPerg,"01","Estado             ?",".",".","mv_ch1","C",02,00,00,"G","    ","mv_par01",""               ,"","","","",""               ,"","","","",""     ,"","","","","","","","","","","","","","12 ","","","","",""})
AADD(aRegistros,{cPerg,"02","Municipio          ?",".",".","mv_ch2","C",05,00,00,"G","    ","mv_par02",""               ,"","","","",""               ,"","","","",""     ,"","","","","","","","","","","","","","MUN","","","","",""})
AADD(aRegistros,{cPerg,"03","Regiao             ?",".",".","mv_ch3","C",03,00,00,"G","    ","mv_par03",""               ,"","","","",""               ,"","","","",""     ,"","","","","","","","","","","","","","A4 ","","","","",""})
AADD(aRegistros,{cPerg,"04","Cliente            ?",".",".","mv_ch4","C",60,00,00,"G","    ","mv_par04",""               ,"","","","",""               ,"","","","",""     ,"","","","","","","","","","","","","","SA1","","","","",""})
AADD(aRegistros,{cPerg,"05","Bloqueado          ?",".",".","mv_ch5","N",01,00,00,"C","    ","mv_par05","Sim"            ,"","","","","Nao"            ,"","","","","Ambos","","","","","","","","","","","","","","   ","","","","",""})
AADD(aRegistros,{cPerg,"06","Vendedor           ?",".",".","mv_ch6","C",06,00,00,"G","    ","mv_par06",""               ,"","","","",""               ,"","","","",""     ,"","","","","","","","","","","","","","SA3","","","","",""})
//AADD(aRegistros,{cPerg,"07","Movimento          ?",".",".","mv_ch7","N",01,00,00,"C","    ","mv_par07","Com Movimento"  ,"","","","","Sem Movimento"  ,"","","","","Ambos","","","","","","","","","","","","","","   ","","","","",""})
AADD(aRegistros,{cPerg,"07","Movimento De       ?",".",".","mv_ch7","D",08,00,00,"G","    ","mv_par07",""               ,"","","","",""               ,"","","","",""     ,"","","","","","","","","","","","","","   ","","","","",""})
AADD(aRegistros,{cPerg,"08","Movimento Ate      ?",".",".","mv_ch8","D",08,00,00,"G","    ","mv_par08",""               ,"","","","",""               ,"","","","",""     ,"","","","","","","","","","","","","","   ","","","","",""})
AADD(aRegistros,{cPerg,"09","Valor Vend. De     ?",".",".","mv_ch9","N",12,02,00,"G","    ","mv_par09",""               ,"","","","",""               ,"","","","",""     ,"","","","","","","","","","","","","","   ","","","","",""})
AADD(aRegistros,{cPerg,"10","Valor Vend. Ate    ?",".",".","mv_chA","N",12,02,00,"G","    ","mv_par10",""               ,"","","","",""               ,"","","","",""     ,"","","","","","","","","","","","","","   ","","","","",""})
AADD(aRegistros,{cPerg,"11","Bairro             ?",".",".","mv_chB","C",60,00,00,"G","    ","mv_par11",""               ,"","","","",""               ,"","","","",""     ,"","","","","","","","","","","","","","   ","","","","",""})
//AADD(aRegistros,{cPerg,"12","Sem Movimento      ?",".",".","mv_chC","N",01,00,00,"C","    ","mv_par12","Sim"            ,"","","","","Nao"            ,"","","","","Ambos","","","","","","","","","","","","","","   ","","","","",""})

dbSelectArea("SX1")
For i := 1 to Len(aRegistros)
	if ! dbSeek(aRegistros[i,1]+aRegistros[i,2])
		IF RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegistros[i,j])
			Next
			MsUnlock()
		Endif
	Endif
Next i

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])


//1-BLOQUEADO -SIM OU NÃO
//2-VENDEDOR DIFERENTE DE    000001  ( CLIENTES DESATIVADOS)
//3-Nº DE COMPRAS DIFERENTE DE 0  (ZERO)  ( SIGNIFICA CLIENTES QUE ESTÃO CADASTRADOS MAS NUNCA COMPRARAM )
//9-CLIENTES
//10-FILTRAR POR DATA DA ULTIMA COMPRA
//11-FILTRAR POR MAIOR COMPRA ( valores em reais) quero filtrar os maiores clientes por um valor)


//4-POR MUNICÍPIO
//5-POR BAIRRO
//6-POR ESTADO
//7- POR REGIÃO
//8- POR VENDEDOR
