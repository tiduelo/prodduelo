#INCLUDE "rwmake.ch"

User Function DUE005
Local j := 0
Local i := 0

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  DUE003  ¦ Autor ¦   Clovis Knopp        ¦ Data ¦ 22/06/00 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Nota Fiscal de Entrada                                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Vinhos Duelo                               ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦          ¦ Criar Campos:C5_TEXTO1 C 03, C5_TEXTO2 C 03, C5_TEXTO3 C 03¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
cPerg := PADR("DUE005",10)
aRegistros := {}
AADD(aRegistros,{cPerg,"01","Da Nota Fiscal     ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cPerg,"02","Ate Nota Fiscal    ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cPerg,"03","Da Serie           ","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cPerg,"04","N.F. Produtor      ","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})

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
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦ 
//¦ mv_par03             // Da Serie                             ¦ 
//¦ mv_par04             // Nota Fiscal de Entrada/Saida         ¦ 
//+--------------------------------------------------------------+
CbTxt	:=""
CbCont	:=""
nOrdem 	:=0
Alfa 	:= 0
Z		:=0
M		:=0
tamanho	:="G" 
limite	:=220
titulo 	:=PADC("Nota Fiscal - Vinhos Duelo Ltda.                ",74)
cDesc1 	:=PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2 	:=""
cDesc3 	:=""
cNatureza:="" 
aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="DUE005" 
cPerg	:=PADR("DUE005",10)
nLastKey:= 0 
lContinua := .T.
nLin	:=0
wnrel   := "DUE005"
nTamNf	:=72     // Apenas Informativo 

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF1"

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

setprc(0,0)
@ prow(),000 PSAY char(15)+""

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦ Inicio do Processamento da Nota Fiscal                       ¦
//¦                                                              ¦
//+--------------------------------------------------------------+
RptStatus({|| Imp_Nota()})
Return

Static Function Imp_Nota

	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
   	DbSetOrder(1)
   	dbSeek(xFilial("SF1")+mv_par01+mv_par03,.t.)

   	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
   	dbSetOrder(1)
   	dbSeek(xFilial("SD1")+mv_par01+mv_par03,.T.)

//+-----------------------------------------------------------+
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+
	SetRegua(Val(mv_par02)-Val(mv_par01))

	DbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
   	dbSeek(xFilial("SF1")+mv_par01+mv_par03,.t.)
   	While !sf1->(eof()) .and. SF1->F1_FILIAL == xFILIAL("SF1") ;
   		.and. SF1->F1_DOC <= mv_par02 .and. lContinua

      	If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
         	sf1->(DbSkip())                    // do Parametro Informado !!!
         	Loop
      	Endif

      	IF lAbortPrint
         	@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
         	lContinua := .F.
         	Exit
      	Endif
        
		IncRegua()
		
      	nLinIni:=nLin                         // Linha Inicial da Impressao
      
		SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
      	If sf1->f1_tipo == "D"
         	SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA))
         	xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
         	xNOME_CLI:=SA1->A1_NOME            // Nome
         	xEND_CLI :=alltrim(SA1->A1_END)                       // Endereco
         	xEND_ENT :=iif(empty(SA1->A1_ENDENT),xEnd_Cli,alltrim(SA1->A1_ENDENT))+"-"+alltrim(SA1->A1_mun)+"-"+SA1->A1_est  // Endereco Entrega
         	xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
         	xCEP_CLI :=SA1->A1_CEP             // CEP
         	xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
         	xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
         	xMUN_CLI :=SA1->A1_MUN             // Municipio
         	xEST_CLI :=SA1->A1_EST             // Estado
         	xCGC_CLI :=SA1->A1_CGC             // CGC
         	xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
         	xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
         	xTEL_CLI :=SA1->A1_TEL             // Telefone
         	xFAX_CLI :=SA1->A1_FAX             // Fax
      	Else
         	SA2->(dbSetOrder(1))
         	SA2->(dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA))
         	xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
         	xNOME_CLI:=SA2->A2_NOME               // Nome
         	xEND_CLI :=SA2->A2_END                // Endereco
         	xEND_ENT :=""                         // Endereco Entrega
         	xBAIRRO  :=SA2->A2_BAIRRO             // Bairro
         	xCEP_CLI :=SA2->A2_CEP                // CEP
         	xCOB_CLI :=""                         // Endereco de Cobranca
         	xREC_CLI :=""                         // Endereco de Entrega
         	xMUN_CLI :=SA2->A2_MUN                // Municipio
         	xEST_CLI :=SA2->A2_EST                // Estado
         	xCGC_CLI :=SA2->A2_CGC                // CGC
         	xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
         	xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
         	xTEL_CLI :=SA2->A2_TEL                // Telefone
         	xFAX     :=SA2->A2_FAX                // Fax
         	xTIPORUR :=SA2->A2_TIPORUR            // TIPO FUNRURAL
      	EndIf
      	
		IMPCAB()
		
		nLin 	:= 23
		nTamDet :=11            // Tamanho da Area de Detalhe
		nItens  :=1
		I:=1
		J:=1
		xQtdVol := 0            // Quantidade de Volumes
		xEspecie:= 0
		xPesoLiq:= 0.00
		xPesoBru:= 0.00
		xNFOrigi:=""
		
		IMPDETALHE()

// Realiza Calculo dos Impostos (FUNRURAL)
//--------------------------------------------------------------
		IF SF1->F1_TIPO # "D"
			nPERFUN:=0
			IF xTIPORUR == "F"
          		nPERFUN:=2.20
        	ELSEIF xTIPORUR == "J"  
          		nPERFUN:=2.70
         	ELSEIF xTIPORUR == "L"
          		nPERFUN:=2.30   
			ENDIF                
//			@ 36, 072  PSAY TRANSF((SF1->F1_CONTSOC
   			@ 36, 099  PSAY TRANSF(nPERFUN     ,"@E@Z 99.99")           
   			@ 36, 117  PSAY TRANSF(SF1->F1_CONTSOC ,"@E@Z 999,999,999.99")     
		ENDIF

        @ 39, 008  PSAY Transf(SF1->F1_BASEICM ,"@E@Z 999,999,999.99")  // Valor Base de ICMS
		@ 39, 036  PSAY Transf(SF1->F1_VALICM  ,"@E@Z 999,999,999.99")  // Valor do ICMS         
   		@ 39, 117  PSAY Transf(SF1->F1_VALMERC ,"@E@Z 999,999,999.99")  // Valor Tot. Prod.
   		@ 41, 008  PSAY Transf(SF1->F1_FRETE   ,"@E@Z 999,999,999.99")  // Valor do Frete
   		@ 41, 036  PSAY Transf(SF1->F1_SEGURO  ,"@E@Z 999,999,999.99")  // Valor Seguro
   		@ 41, 063  PSAY Transf(SF1->F1_DESPESA ,"@E@Z 999,999,999.99") // Despesa
   		@ 41, 091  PSAY Transf(SF1->F1_VALIPI  ,"@E@Z 999,999,999.99")  // Valor do IPI
		@ 41, 117  PSAY Transf(SF1->F1_VALBRUT ,"@E@Z 999,999,999.99")  // Valor Total NF
   
      	@ 46, 001 PSAY " O MESMO "
      	@ 46, 079 PSAY "1"                              // Emitente (1)

		IF !EMPTY(xQtdVol)
      		@ 49, 001 PSAY Transf(xQtdVol,"@E@Z 999,999.999")               
  		ENDIF   

   		@ 49, 020 PSAY xEspecie                          
   		@ 49, 067 PSAY ""                            // Marca

		@ 49, 104 PSAY xPesoBru    Picture"@E@Z 999,999.99"      
		@ 49, 122 PSAY xPesoLiq    Picture"@E@Z 999,999.99"      

		if (SF1->F1_CONTSOC # 0.00) .AND. (SF1->F1_VALICM # 0.00)
			xMENSAGEM := "ICMS Isento cfe Anexo II Paragrafo II do RICMS/SC aprovado pelo Decreto 1790/97. Conforme Nota Fiscal de Produtor Num. "+xNForigi
			xMENSAG1 := SUBSTR(xMENSAGEM,01,65)
    	   	xMENSAG2 := SUBSTR(xMENSAGEM,66,65)
       		xMENSAG3 := SUBSTR(xMENSAGEM,131,65)
			@ 053, 001 PSAY UPPER(xMENSAG1)
   			@ 054, 001 PSAY UPPER(xMENSAG2)
   			@ 055, 001 PSAY UPPER(xMENSAG3)
        else
			@ 053, 001 PSAY UPPER(SF1->F1_MENS1)
   			@ 054, 001 PSAY UPPER(SF1->F1_MENS2)
   			@ 055, 001 PSAY UPPER(SF1->F1_MENS3)
		endif
		        	
		@ 61, 120 PSAY sf1->f1_doc            // Numero da Nota Fiscal
  
		@ 62, 000 PSAY ""
		nLin:=0
      	SF1->(DBSKIP())
      	
	EndDo

	dbSelectArea("SF1")
	Retindex("SF1")
	dbSelectArea("SD1")
	Retindex("SD1")

	Set Device To Screen

	If aReturn[5] == 1
   		Set Printer TO
	    dbcommitAll()
 		ourspool(wnrel)
	Endif

	MS_FLUSH()

RETURN

//*-------------------------------------------------------------------
//*   IMPRIME CABECALHO DA NOTA FISCAL
//*-------------------------------------------------------------------
STATIC FUNCTION IMPCAB()
      	@ 01, 125 PSAY SF1->F1_DOC         
		@ 02, 030 PSAY SM0->M0_NOMECOM                               
   		@ 02, 102 PSAY "X"
		@ 03, 030 PSAY ALLTRIM(SM0->M0_ENDCOB)+" - "+SM0->M0_BAIRCOB
		@ 04, 030 PSAY ALLTRIM(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB+" - "+TRANSF(SM0->M0_CEPCOB,"@R 99999-999")
		@ 05, 030 PSAY "Fone/Fax: "+SM0->M0_TEL
		@ 05, 088 PSAY TRANSF(SM0->M0_CGC,"@R 99.999.999/9999-99")
		@ 07, 001 PSAY SF4->F4_TEXTO
		@ 07, 044 PSAY SF4->F4_CF Picture"@R 9.9999" 
		@ 07, 088 PSAY SM0->M0_INSC
		@ 10, 001 PSAY ALLTRIM(xNOME_CLI)+"  ("+SF1->F1_FORNECE+"."+SF1->F1_LOJA+")"
		IF !EMPTY(xCGC_CLI)                  
   			@ 10, 088 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
		ENDIF
		@ 10, 123 PSAY SF1->F1_EMISSAO
		@ 12, 001 PSAY xEND_CLI              
		@ 12, 070 PSAY xBAIRRO               
		@ 12, 101 PSAY xCEP_CLI Picture"@R 99999-999"           
		@ 12, 123 PSAY SF1->F1_EMISSAO
		@ 14, 001 PSAY xMUN_CLI
		@ 14, 055 PSAY xTEL_CLI
		@ 14, 082 PSAY xEST_CLI
		@ 14, 088 PSAY xINSC_CLI
		@ 14, 121 PSAY " "      

RETURN

//*-------------------------------------------------------------------
//*   IMPRIME DETALHES DA NOTA FISCAL
//*-------------------------------------------------------------------
STATIC FUNCTION IMPDETALHE()
                                                                                                        
		SD1->(dbSetOrder(1))
		SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE,.T.))
   		WHILE !SD1->(EOF()) .AND. xFILIAL("SD1") == SD1->D1_FILIAL ;
   			.AND. SF1->F1_DOC 	== SD1->D1_DOC ;
   			.AND. SF1->F1_SERIE == SD1->D1_SERIE
   			
   			IF nItens > nTamDet
				@ nLin, 14 PSAY "CONTINUA..."
                nItens := 0
                nLin   := nLin+1
   				@ 39, 008  PSAY "**************"  // Base do ICMS
   				@ 39, 036  PSAY "**************"  // Valor do ICMS
   				@ 39, 063  PSAY "**************"  // Base ICMS Ret.
				@ 39, 091  PSAY "**************"  // Valor  ICMS Ret.
				@ 39, 117  PSAY "**************"  // Valor Tot. Prod.
				@ 41, 008  PSAY "**************"  // Valor do Frete
				@ 41, 036  PSAY "**************"  // Valor Seguro
				@ 41, 063  PSAY "**************"  // Despesa
				@ 41, 091  PSAY "**************"  // Valor do IPI
				@ 41, 117  PSAY "**************"  // Valor Total NF
   
                ImpCab()

                nLin := 23

                @ nLin, 14 PSAY "CONTINUACAO..."
                nItens := nItens + 1
                nLin   := nLin+1
             
			ENDIF
          
       		IF (SF1->F1_TIPO == "N") .or. (SF1->F1_TIPO == "D") .or. (SF1->F1_TIPO == "B")
          		
          		SB1->(dbSetorder(1))
				SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))		
				
				xEspecie := iif(sd1->d1_um=="KG","Kilos","Volumes")
				xPesoLiq := xPesoLiq + iif(sd1->d1_um=="KG",sd1->d1_quant,(sb1->b1_peso*sd1->d1_quant))
				xPesoBru := xPesoBru + (sb1->b1_pesbru * sd1->d1_quant)
                if !empty(sd1->d1_nfori)
                	xNFOrigi := sd1->d1_nfori
                endif
				@ nLin, 000  PSAY SUBSTR(SD1->D1_COD,1,9)
				@ nLin, 009  PSAY SUBSTR(SB1->B1_DESC,1,55)
          		@ nLin, 066  PSAY SB1->B1_CLASFIS
				IF EMPTY(SB1->B1_ORIGEM)
					@ nLin, 070 PSAY "00"
                ELSE             
             		@ nLin, 070 PSAY SB1->B1_ORIGEM
				ENDIF                   
           		IF SD1->D1_QUANT < 1
             		@ nLin, 074  PSAY SB1->B1_SEGUM
             		@ nLin, 076  PSAY SD1->D1_QTSEGUM               Picture"@E 999,999.99"
             		@ nLin, 086  PSAY SD1->D1_TOTAL/SD1->D1_QTSEGUM  Picture"@E 999,999.9999"
          		ELSE
             		@ nLin, 074  PSAY SB1->B1_UM
					@ nLin, 077  PSAY SD1->D1_QUANT           Picture"@E 99,999.999"
                    @ nLin, 086  PSAY SD1->D1_VUNIT           Picture"@E 999,999.9999"
				ENDIF                                                                       

          		xQTDVOL := xQTDVOL + SD1->D1_QUANT // Qtd. Volumes                        
        
          		@ nLin, 101  PSAY SD1->D1_TOTAL       Picture"@E 99,999,999.99"
          		@ nLin, 117  PSAY SD1->D1_PICM        Picture"99"
          		@ nLin, 121  PSAY SD1->D1_IPI         Picture"99"
          		@ nLin, 127  PSAY SD1->D1_VALIPI      Picture"@E 99999.99"

          		nLin :=nLin+1
          		nItens := nItens + 1                    
               
	   		ENDIF 
   			SD1->(DBSKIP())
		END

RETURN

