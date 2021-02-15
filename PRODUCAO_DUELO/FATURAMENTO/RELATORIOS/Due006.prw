#INCLUDE "rwmake.ch"

User Function DUE006
Local j := 0
Local i := 0

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  DUE006  ¦ Autor ¦ Geovani S. Mauricio   ¦ Data ¦ 06/04/01 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Demonstrativo Saidas por Produto                           ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Vinhos Duelo                               ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦          ¦  														  ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
cPerg := "DUE006    "
aRegistros := {}
AADD(aRegistros,{cPerg,"01","Da Emissao         ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cPerg,"02","Ate Emissao        ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
dbSeek(cPerg)
If !Found()
	dbSeek(cPerg)
	While SX1->X1_GRUPO==cPerg.and.!Eof()
		Reclock("SX1",.f.)
		dbDelete()
		MsUnlock("SX1")
		dbSkip()
	End
	For i:=1 to Len(aRegistros)
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock("SX1")
	Next
Endif

//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
tamanho	:="P"
limite	:=132
titulo 	:="Demonstr. das Saidas por Produto"
cDesc1 	:=PADC("Demonstrativo das Saidas por Produto           ",74)
cDesc2 	:=PADC("em Quantidade e Litros.                         ",74)
cDesc3 	:=""
aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="DUE006"
cPerg	:="DUE006    "
nLastKey:= 0
lContinua := .T.
nLin	:= 70
wnrel   := "DUE006"
aFatura := {}
nPliq 	:= 0.00
nVez  	:= 0
nTotal	:= 0
nQuant	:= 0
m_pag 	:= 1
//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SD2"

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|| RptDetail() })
Return

Static Function RptDetail()

Cabec1 := " *** Periodo de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
Cabec2 := "Codigo   Descricao                                   Quant.      Litros  % Part."

aCAMPOS:={}
Aadd(aCampos,{ "CODIGO" ,"C",08,0 } )
Aadd(aCampos,{ "DESCRI" ,"C",40,0 } )
Aadd(aCampos,{ "QUANTI" ,"N",10,2 } )
Aadd(aCampos,{ "LITROS" ,"N",15,2 } )
Aadd(aCampos,{ "CFOP"   ,"C",4,2 } )

cNomArq := CriaTrab(aCampos)
If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
End
dbUseArea(.T.,,cNomArq,"TRB",nil,.F.)
IndRegua("TRB",cNomArq,"CODIGO+CFOP",,,"Selecionando Registros...")

DBSELECTAREA("SD2") ; DBSETORDER(5) ; DBGOTOP()
DBSELECTAREA("SB1") ; DBSETORDER(1) ; DBGOTOP()

SETREGUA(MV_PAR02-MV_PAR01)

SD2->(DBSEEK(xFILIAL("SD2")+DTOS(MV_PAR01),.T.))

WHILE !SD2->(EOF()) .AND. xFILIAL("SD2")==SD2->D2_FILIAL ;
	.AND. SD2->D2_EMISSAO <= MV_PAR02
	
	INCREGUA()
	
	IF SD2->D2_TIPO # "N"
		SD2->(DBSKIP())
		LOOP
	ENDIF
	
	IF SD2->D2_TP # "PA"
		SD2->(DBSKIP())
		LOOP
	ENDIF
	
	//IF SD2->D2_TES == "507"
	//	SD2->(DBSKIP())
	//	LOOP
	//ENDIF
	
	SB1->(dbseek(xfilial("SB1")+sd2->d2_cod))
	
	nPliq := sd2->d2_quant * sb1->b1_peso
	nVez  := 0
	nTotal:= nPliq + nTotal
	nQuant:= nQuant+ sd2->d2_quant
	
	IF TRB->(DBSEEK( SUBSTR(SD2->D2_COD,1,8)+SUBSTR(SD2->D2_CF,1,4) ) )
		RECLOCK("TRB",.F.)
		TRB->QUANTI := TRB->QUANTI + SD2->D2_QUANT
		TRB->LITROS := TRB->LITROS + nPLIQ
	ELSE
		RECLOCK("TRB",.T.)
		TRB->CODIGO := SD2->D2_COD
		TRB->CFOP   := SD2->D2_CF
		TRB->DESCRI := SB1->B1_DESC
		TRB->QUANTI := SD2->D2_QUANT
		TRB->LITROS := NPLIQ
	ENDIF
	MSUNLOCK("TRB")
	
	SD2->(DBSKIP())
	
END

TRB->(DBGOTOP())
SETREGUA(RECCOUNT("TRB"))

TRB->(DBGOTOP())   

WHILE !TRB->(EOF())
	
	if nLin > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //Impressao do cabecalho
		nLin := PROW()
	endif
	
	@ PROW()+1,000 PSAY TRB->CODIGO
	@ PROW()  ,009 PSAY TRB->CFOP   
	@ PROW()  ,014 PSAY SUBSTR(TRB->DESCRI,1,35)
	@ PROW()  ,051 PSAY TRANSFORM(TRB->QUANTI,"@E 999,999")
	@ PROW()  ,061 PSAY TRANSFORM(TRB->LITROS,"@E 999,999.99")
	@ PROW()  ,072 PSAY TRANSFORM((TRB->LITROS*100)/nTOTAL, "999.99")
	               
	nLin ++
	
	TRB->(DBSKIP())
	
END

if nLin > 60
	Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //Impressao do cabecalho
	nLin := PROW()
endif

@ PROW()+1 ,000 PSAY REPLICATE("-",80)
@ PROW()+1 ,009 PSAY "**** TOTAL GERAL............."
@ PROW()   ,051 PSAY TRANSFORM(nQUANT ,"@E 999,999")
@ PROW()   ,061 PSAY TRANSFORM(nTOTAL ,"@E 9999,999.99")
@ PROW()+1 ,000 PSAY REPLICATE("-",80)

dbselectarea("TRB")
dbclosearea()

Roda(0,"","P")
Set Filter To

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

Return
