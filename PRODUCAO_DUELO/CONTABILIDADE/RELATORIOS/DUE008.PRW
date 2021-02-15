#include "rwmake.ch" 

User Function DUE008()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local j := 0
Local i := 0
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,TITULO,CDESC1,CDESC2,CDESC3,CSTRING")
SetPrvt("ARETURN,NOMEPROG,NLASTKEY,CPERG,CBTEXT,LI")
SetPrvt("M_PAG,ASTRU,CARQC,DDATA,DEBDIA,CREDIA")
SetPrvt("DEBGERAL,CREGERAL,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DUE008   ³ Autor ³ GEOVANI S. MAURICIO     ³ Data ³ 10/05/01                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Lancamentos                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ VINHOS DUELO                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
Private nOrdem:=0
Private tamanho:="M"  //M=132 colunas, P=80 colunas, G=220 colunas
Private titulo :="Relacao de lancamentos"
Private cDesc1 :="Este relatorio emite a Relacao de Lancamentos Contabeis conforme parametros"
Private cDesc2 :="especificados pelo usuario."
Private CDesc3 :=""
Private cString:="SI2"
Private aReturn:={ "Especial", 1,"Administracao", 1, 2, 1, "",1 }
Private nomeprog:="DUE008"
Private nLastKey:= 0
Private cPerg   :="DUE008    "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta SX1                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX1")
If !dbSeek("DUE008    03")
	dbSeek("DUE008    ")
	While SX1->X1_GRUPO=="DUE008    ".and.!Eof()
		Reclock("SX1",.F.,.F.)
		dbDelete()
		MsUnlock()
		dbSkip()
	End
	aRegistros:={}
	AADD(aRegistros,{cPerg,"01","Da Data            ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SI3"})
	AADD(aRegistros,{cPerg,"02","Ate a Data        ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","SI3"})
	AADD(aRegistros,{cPerg,"03","Do Lote            ?","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
	AADD(aRegistros,{cPerg,"04","Ate Lote           ?","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
	For i:=1 to Len(aRegistros)
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])	
		Next
		MsUnlock()
	Next	
Endif

pergunte("DUE008    ",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                       ³
//³ mv_par01            // do Centro do Custo                  ³
//³ mv_par02            // at‚ o Centro de Custo               ³
//³ mv_par03            // ATE A DATA                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1   := " NUMERO         DEBITO         CREDITO                 VALOR           H I S T O R I C O                     CC Deb.    CC.Cred  "
cabec2   := ""
cCancel:= "***** CANCELADO PELO OPERADOR *****"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="DUE008"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|| IMP008()})

Return 

Static Function IMP008()

	aStru:={}
	Aadd(aStru,{"DTMOV   ","D",08,0})
	Aadd(aStru,{"CREDITO","C",15,0})
	Aadd(aStru,{"DEBITO"  ,"C",15,0})
	Aadd(aStru,{"NUM    "  ,"C",07,0})
	Aadd(aStru,{"LINHA  "  ,"C",02,0})
	Aadd(aStru,{"VALOR  ","N",17,2})
	Aadd(aStru,{"HISTPAD","C",03,0})
	Aadd(aStru,{"HIST   ","C",40,0})
	Aadd(aStru,{"CCD    ","C",09,0})
	Aadd(aStru,{"CCC    ","C",09,0})
	cArqc:=CriaTrab(aStru)
	Use &cArqc Alias tr1 New
	INDEX ON dtos(tr1->dtmov) + tr1->num + tr1->linha to tr11

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva posicoes para movimento da regua de processamento      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	titulo :="Relacao dos Lancamentos Contabeis de "+DTOC(mv_par01)+" a "+DTOC(mv_par02)

	DBSELECTAREA("SI2") 
	DBSETORDER(3)  //LANCAMENTOS CONTABEIS   -    DATA + NUM + LINHA
	DBGOTOP()
	SetRegua(SI2->(RECCOUNT()))

	SI2->(DBSEEK(XFILIAL("SI2") + DTOS(MV_PAR01) + MV_PAR03,.T.))
	While !SI2->(Eof()) .and. XFILIAL("SI2") == SI2->I2_FILIAL .and. SI2->I2_DATA <= MV_PAR02
		IncRegua()
		IF SI2->I2_NUM < MV_PAR03 .OR. SI2->I2_NUM > MV_PAR04    
	    	SI2->(DBSKIP())
	    	LOOP
	 	ENDIF
	 	
		RECLOCK("TR1",.T.)
		TR1->DTMOV	:= SI2->I2_DATA
		TR1->NUM     	:= SI2->I2_NUM
		TR1->LINHA   	:= SI2->I2_LINHA
		TR1->DEBITO  	:= SI2->I2_DEBITO
		TR1->CREDITO := SI2->I2_CREDITO
		TR1->VALOR   	:= SI2->I2_VALOR
		TR1->HISTPAD := SI2->I2_HP
		TR1->HIST    		:= SI2->I2_HIST
		TR1->CCD     	:= SI2->I2_CCD
		TR1->CCC     	:= SI2->I2_CCC
		MSUNLOCK("TR1")
		
		SI2->(DBSKIP())

	END

	TR1->(dbGoTop())
	SetRegua(TR1->(RECCOUNT()))

	LI       := 80
	DDATA     := TR1->DTMOV
	DEBDIA   := 0.00
	CREDIA   := 0.00
	DEBGERAL := 0.00
	CREGERAL := 0.00

	While  !TR1->(Eof())
	
		DDTMOV	:= TR1->DTMOV        

		IF li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			LI  := PROW()
		EndIF

		@ PROW()+1 , 001 PSAY "Lancamentos do Dia :" 
		@ PROW()     , 022 PSAY TR1->DTMOV
		@ PROW()+1 ,000 PSAY ""
	
		DEBDIA   := 0.00
		CREDIA   := 0.00
	
		While  !TR1->(Eof()) .AND. DDTMOV == TR1->DTMOV
			IncRegua()
		
			IF li > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
				LI  := PROW()
			EndIF
			@ PROW()+1, 001 PSAY SUBSTR(TR1->NUM,1,4)+"-"+Substr(TR1->NUM,5,3)+"-"+TR1->LINHA
			@ PROW()    ,015 PSAY alltrim(TR1->DEBITO)
			@ PROW()    ,030 PSAY alltrim(TR1->CREDITO)
			@	PROW()    ,046 PSAY TRANSFORM(TR1->VALOR ,"@E 999,999,999.99")
			@ PROW()    ,062 PSAY TR1->HISTPAD
			@ PROW()    ,066 PSAY ALLTRIM(TR1->HIST)
			@ PROW()    ,109 PSAY TR1->CCD
			@ PROW()    ,120 PSAY TR1->CCC
			IF !EMPTY(TR1->DEBITO)
				DEBDIA   := DEBDIA + TR1->VALOR
				DEBGERAL := DEBGERAL + TR1->VALOR
			ENDIF
			IF !EMPTY(TR1->CREDITO)
				CREDIA   := CREDIA + TR1->VALOR
				CREGERAL := CREGERAL + TR1->VALOR
			ENDIF
			li:=li+1
			TR1->(DBSKIP())
		END
			IF li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			LI  := PROW()
		EndIF
		@ PROW()+1, 01 PSAY "Debitos do Dia :"
		@ PROW()    , 25 PSAY TRANSFORM( debdia , "@E 999,999,999.99")
		@ PROW()    , 60 PSAY "Creditos do Dia :"
		@ PROW()    , 85 PSAY TRANSFORM(  credia , "@E 999,999,999.99")
		li:=li+1
		IF li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			LI  := PROW()
		EndIF
		@ PROW()+1 ,01 PSAY REPLICATE("-",132)
		li  := li + 1

		TR1->(DBSKIP())
	
	END

	IF li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		LI  := PROW()
	EndIF

	@ PROW()+1, 01 PSAY "Debitos no Periodo :"
	@ PROW()    , 25 PSAY TRANSFORM(debgeral,"@E 999,999,999.99")
	@ PROW()    , 60 PSAY "Creditos no Periodo :"
	@ PROW()    , 85 PSAY TRANSFORM(cregeral,"@E 999,999,999.99")
	li:=li+1
	IF li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		LI  := PROW()
	EndIF
	@ PROW()+1 ,01 PSAY REPLICATE("-",132)

	TR1->(DBCLOSEAREA())
	
	Set Device To Screen
	If aReturn[5] == 1
   		Set Printer TO 
		dbcommitAll()
   		ourspool(wnrel)
	EndIf

	MS_FLUSH()
	