#INCLUDE "rwmake.ch"

/*/ 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
    PROGRAMA : DUE007						AUTOR : GEOVANI										DATA : 10/05/01
    DESCRICAO : Relacao Movimento Mes a Mes - CC Extra
    USO             : Especifico Vinhos Duelo
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/

User Function DUE007
Local j := 0
Local i := 0


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Private cString := "SI3"
Private aOrd := {}
Private CbTxt        := ""
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "dos movimentos mes a mes - Centro Custo Extracontabil"
Private cDesc3         := ""
Private cPict          := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "DUE007"
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private titulo       	:= "Relacao Movimento Mensal - C.C. Extracontabil"
Private nLin        	:= 80                                                               
//                   1         2         3         4         5         6         7         8         9         0        11        12        13        14        15        16        17        18        19        20        21        22
//         0123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
//         9.9.9.999 xxxxxxxxxxxxxxxxxxxxxxxxx   99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99
Private cabec1  :="C Custo   Descricao                         Janeiro      Fevereiro          Marco          Abril           Maio         Junho        Julho      Agosto      Setembro       Outubro      Novembro      Dezembro     Acumulado"
Private cabec2 	:=""
Private aMeses 	:={"Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro","Acumulado"}
Private cbtxt		:= Space(10)
Private cbcont    := 00
Private CONTFL := 01
Private m_pag    := 01
Private imprime    := .T.
Private wnrel      := "DUE007"
Private cString 	:= "SI3"
Private cPerg   	:="DUE007    "

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ajusta SX1                                                   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("SX1")
If !dbSeek("DUE007    03")
	dbSeek("DUE007    ")
	While SX1->X1_GRUPO=="DUE007    ".and.!Eof()
		Reclock("SX1",.F.,.F.)
		dbDelete()
		MsUnlock()
		dbSkip()
	End
	aRegistros:={}
	AADD(aRegistros,{cPerg,"01","Do C. Custo        ?","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SI3"})
	AADD(aRegistros,{cPerg,"02","Ate o C. Custo     ?","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","SI3"})
	AADD(aRegistros,{cPerg,"03","Data de Referencia ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
	For i:=1 to Len(aRegistros)
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])	
		Next
		MsUnlock()
	Next	
Endif

pergunte("DUE007    ",.F.)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta a interface padrao com o usuario...                           Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

wnrel := SetPrint(cString,NomeProg,CPERG,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processamento. RPTSTATUS monta janela com a regua de processamento. Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCAO : RUNREPORT
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Local  nTam 		:= 1
	Local i := 0
	Private aMovimen	:={}
	Private aTotCC 		:={}
	Private aTotGr1 	:={}
	Private aTotGr2 	:={}
	Private aTotGr3 	:={}
	Private aTotGr9 	:={}
	Private ResNome 	:={}
	Private aTotRes	:={}
	Private lImp 			:= .t.
	Private nTotalGER := 0.00
	Private nMoeda		:= 1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Calcula datas iniciais e finais							           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Private aData1 := {Ctod("  /  /  "),Ctod("  /  /  ")}
	Private aData2 := CalcData(mv_par03,nMoeda)
	Private cPerFim:= SUBS(DTOC(MV_PAR03),4,2)
	Private nTotalMeses := 0 

	aData2 := Periodata(Val(cPerFim),nMoeda)
	If Val(cPerFim) > 12
		nMesIni		:= Val(cPerFim) - 12 + 1
		nTotalMeses := 12
		aData1		:= PerioData(nMesIni,nMoeda)
	Else 
		aData1		:= PerioData(1,nMoeda)
		nTotalMeses := Val(cPerFim)
	End	
	cMesFim := SUBS(DTOC(MV_PAR03),4,2)
	cMesIni := "01"

	nMesIni	:= Month(aData1[1])
// Montagem do cabecalho rotativo

	If GetMv("MV_MESREF") != 31 .And. !(GetMv("MV_MOEDMAT") $ Str(nMoeda,1))
		nPos 		:= nMesIni + 1
		If nPos > 12
			nPos := 1
		End	
	Else
		nPos 		:= nMesIni
	End	

	For nTam := 1 to 12
		AADD(aTotCC, 0)
		AADD(aTotGr1, 0)
		AADD(aTotGr2, 0)
		AADD(aTotGr3, 0)
		AADD(aTotGr9, 0)
	Next

	lEstrang := .F.

	DbSelectArea("SI3") 
	SI3->(DbSetOrder(1))
	SI3->(DbGotop()) // CENTRO DE CUSTO
	SI3->(dbSeek(xFILIAL("SI3")+SUBSTR(mv_par01,1,1),.T. ))

	SetRegua(Reccount())
	While SI3->(!Eof()) .and. SI3->I3_FILIAL==xFILIAL("SI3") .and. SI3->I3_CUSTO <= mv_par02

		IncRegua()

		If Empty(SI3->I3_CUSTO)
    		SI3->(dbSkip())
			Loop
		Endif

		If Val(SI3->I3_MOEDA) <> 1 //Moeda diferente da escolhida
			SI3->(dbSkip())
			loop
		Endif
	
		cGrupo1 := SUBSTR(SI3->I3_CUSTO,1,1)
		cDescr1 := SI3->I3_DESC
		nVEZG1 := 0
		
		While SI3->(!Eof()) .and. SI3->I3_FILIAL==xFILIAL("SI3") .and. SUBSTR(SI3->I3_CUSTO,1,1) == cGRUPO1
	
			IncRegua()
	
			If Val(SI3->I3_MOEDA) <> 1 //Moeda diferente da escolhida
				SI3->(dbSkip())
				loop
			Endif
		
			cGrupo2 := SUBSTR(SI3->I3_CUSTO,1,2)
			cDescr2 := SI3->I3_DESC
	    	nVEZG2 := 0
		
			While SI3->(!Eof()) .and. SI3->I3_FILIAL==xFILIAL("SI3") .and. SUBSTR(SI3->I3_CUSTO,1,2) == cGRUPO2
	
				IncRegua()
	
				If Val(SI3->I3_MOEDA) <> 1 //Moeda diferente da escolhida
					SI3->(dbSkip())
					loop
				Endif
	
				cGrupo3 := SUBSTR(SI3->I3_CUSTO,1,3)
				cDescr3 := SI3->I3_DESC
            	nVEZG3 := 0
            
				While SI3->(!Eof()) .and. SI3->I3_FILIAL==xFILIAL("SI3") .and. SUBSTR(SI3->I3_CUSTO,1,3) == cGRUPO3
	
					IncRegua()
	
					If Val(SI3->I3_MOEDA) <> 1 //Moeda diferente da escolhida
						SI3->(dbSkip())
						loop
					Endif
	
					cCODCC := SI3->I3_CUSTO
					cDESCC := SI3->I3_DESC
					aMovimen := { }
					nVezcc := 0
				
					While SI3->(!Eof()) .and. xFilial("SI3") == SI3->I3_FILIAL .and. cCodCC == SI3->I3_CUSTO
       	        		IncRegua()

						If Val(SI3->I3_MOEDA) <> 1 //Moeda diferente da escolhida
							SI3->(dbSkip())
							loop
						Endif
	                	nCONT  := 1
						nMes	:= Val(cMesIni)
						While nCont <= nTotalMeses
							cMes := StrZero(nMes,2)
            				cCred := "I3_CRE"+ALLTRIM(cMes)
            				cDebi := "I3_DEB"+ALLTRIM(cMes)
            				xSoma := ((&cCred)-(&cDebi)) 
 							AADD(aMovimen,xSoma)
							aTotCC[nCont] := aTotCC[nCont] + xSoma
							aTotGr1[nCont] := aTotGr1[nCont] + xSoma
							aTotGr2[nCont] := aTotGr2[nCont] + xSoma
							aTotGr3[nCont] := aTotGr3[nCont] + xSoma
							aTotGr9[nCont] := aTotGr9[nCont] + xSoma
   	        				nCont := nCont + 1
							nMes  := nMes +1 
							IF XSOMA <> 0.00
								nVEZCC := 1
								nVEZG1 := 1
								nVEZG2 := 1
								nVEZG3 := 1
							ENDIF
						End

						SI3->(DbSkip())
				
					END
				
					IF nVEZCC == 1
					
   						If lAbortPrint
							@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					      	Exit
					   Endif
   						If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
      						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      						nLin := 8
   						Endif

//                   1         2         3         4         5         6         7         8         9         0        11        12        13        14        15        16        17        18        19        20        21        22
//         0123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
//         9.9.9.999 xxxxxxxxxxxxxxxxxxxxxxxxxxx 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99
						@ PROW()+1,000 PSAY Mascara( cCodCC,GetMV("MV_MASCCUS"))
                        @ PROW()   , 010 PSAY SUBSTR(cDesCC,1,25)
                        nColuna := 23
    					nTOTAL  := 0
						For i:= 1 to nTotalMeses
							nColuna := nColuna + 15
							@ PROW() , nColuna PSAY TRANSFORM(aTotCC[i],  "@E 99,999,999.99")
	        				nTOTAL := nTOTAL +aTotCC[i]
							aTotCC[i] := 0
						Next
                                        @ PROW() , 206 PSAY TRANSFORM(nTOTAL , "@E 999,999,999.99")
                        nLin := nLin + 1
                        
                	ENDIF
                
				END

				IF nVEZG3 == 1
					If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
      					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      					nLin := 8
   					Endif
                                        nColuna := 23
					nTotal    := 0
		   			@ PROW()+1 , 000 PSAY Mascara(cGRUPO3,GetMV("MV_MASCCUS"))
		   			@ PROW()     , 010 PSAY SUBSTR(cDESCR3,1,25)
					For i:= 1 to nTotalMeses
						nColuna := nColuna + 15
						@ PROW() , nColuna PSAY TRANSFORM(aTOTGR3[I] , "@E 99,999,999.99")
						nTotal := nTotal + aTotGr3[i]
						aTotGr3[i] := 0
		   			Next     
                                        @ PROW() , 206 PSAY TRANSFORM(nTOTAL , "@E 999,999,999.99")
		   			@ PROW()+1,000 PSAY ""
		   			nlin := nLin + 1
    			ENDIF
    		
			END

			IF nVEZG2 == 1
				If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
      				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      				nLin := 8
   				Endif
				
                                nColuna := 23
				nTOTAL := 0.00
				
	   			@ PROW()+1 , 000 PSAY Mascara(cGRUPO2,GetMV("MV_MASCCUS"))
	   			@ PROW()     , 010 PSAY SUBSTR(cDESCR2,1,25)
				For i:= 1 to nTotalMeses
					nColuna := nColuna + 15
					@ PROW() , nColuna PSAY TRANSFORM(aTOTGR2[I] , "@E 99,999,999.99")
					NTOTAL := NTOTAL + ATOTGR2[I]
					aTotGr2[i] := 0
   				Next     
                                @ PROW() , 206 PSAY TRANSFORM(nTOTAL , "@E 999,999,999.99")
   				@ PROW()+1,000 PSAY ""
   				nLin := nLin + 1
			ENDIF
		
		END

		IF nVEZG1 == 1
                        ntotal := 0.00
                        nColuna := 23
			If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			@ PROW()+1 , 000 PSAY Mascara(cGRUPO1,GetMV("MV_MASCCUS"))
   			@ PROW()     , 010 PSAY SUBSTR(cDESCR1,1,25)
			For i:= 1 to nTotalMeses
				nColuna := nColuna + 15
				@ PROW() , nColuna PSAY TRANSFORM(aTOTGR1[I] , "@E 99,999,999.99")
				nTOTALGER := nTOTALGER + aTOTGR1[i]
                                nTotal := nTotal + aTotGr1[i]
                                aTotGr1[i] := 0
			Next     
                                @ PROW() , 206 PSAY TRANSFORM(nTOTAL , "@E 999,999,999.99")
			@ PROW()+1,000 PSAY REPLICATE("=",220)
			nLin := nLin + 1
		ENDIF
	
	END

    ntotal := 0.00
    nColuna := 23
	If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
	endif
	@ PROW()+1 , 005 PSAY "** TOTAL GERAL ..............."
	For i:= 1 to nTotalMeses
		nColuna := nColuna + 15
		@ PROW() , nColuna PSAY TRANSFORM(aTOTGR9[I] , "@E 99,999,999.99")
		nTOTALGER := nTOTALGER + aTOTGR9[i]
        nTotal := nTotal + aTotGr9[i]
        aTotGr1[i] := 0
	Next     
    @ PROW() , 206 PSAY TRANSFORM(nTOTAL , "@E 999,999,999.99")
	@ PROW()+1,000 PSAY REPLICATE("*",220)
	
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Finaliza a execucao do relatorio...                                 Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	SET DEVICE TO SCREEN

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Se impressao em disco, chama o gerenciador de impressao...          Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	If aReturn[5]==1
   		dbCommitAll()
   		SET PRINTER TO
   		OurSpool(wnrel)
	Endif

	MS_FLUSH()

	Return
