#INCLUDE "rwmake.ch"

User Function GDP002


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private oLeTxt
_lzera    := .f.
_lcusto   := .f.
_linv01   := .f.
_linv02   := .t.
_lSB2     := .f.

DbSelectArea("SB9")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 320,400 DIALOG oLeTxt TITLE OemToAnsi("Reseta saldo Inicial")
@ 02,10 TO 030,200

@ 10,018 Say " Este programa ira zerar o saldo inicial."

//Criaparam()

//@ 40,098 BmpButton Type 05 ACTION _Param()
@ 40,128 BMPBUTTON TYPE 01 ACTION Processa({|| OkLeTxt() },"Processando...")
@ 40,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return NIL


////////////////////////
////////////////////////
Static Function OkLeTxt
////////////////////////
////////////////////////

_dData  := CTOD("31/12/2008")
//_cGrupo := mv_par02

_cInv01 := "\DATA\INVENT2" + GetDbExtension()
_cInv02 := "\DATA\INVENT" + GetDbExtension()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Close(oLeTxt)



if _lzera
	
	cQuery := "DELETE FROM SB9040"
	TCSQLEXEC(cQuery)
	
	Dbselectarea("SB1")
	set filter to
	dbsetorder(1)
	dbgotop()
	
	procregua(reccount())
	
	Do While ! eof()
		
		INCPROC()
		
		Dbselectarea("SB9")
		set filter to
		dbsetorder(1)
		dbgotop()
		
		if ! dbseek(SB1->B1_FILIAL+SB1->B1_COD+SB1->B1_LOCPAD+dtos(_dData),.F.)
			
			if RECLOCK("SB9",.T.)
				SB9->B9_FILIAL := SB1->B1_FILIAL
				SB9->B9_COD    := SB1->B1_COD
				SB9->B9_LOCAL  := SB1->B1_LOCPAD
				SB9->B9_DATA   := _dData
				SB9->B9_QINI   := 0
				SB9->B9_VINI1  := 0
				msunlock()
			Endif
			
		Endif
		
		
		Dbselectarea("SB1")
		dbskip()
		
	Enddo
Endif

_lalert := .t.

if	_linv01
	
	dbUseArea(.t.,,_cInv01,"TMPIMP",.f.)
	
	procregua(reccount())
	
	Dbselectarea("TMPIMP")
	dbgotop()
	
	Do While ! eof()
		
		INCPROC()
		
		_cCod := "01"+PADR("0"+alltrim(TMPIMP->COD),15)+"01"
		
		if _lAlert
			alert(_cCod)
			_lalert := .F.
		Endif
		
		Dbselectarea("SB9")
		dbsetorder(1)
		dbgotop()
		
		if dbseek(_cCod+dtos(_dData),.F.)
			
			if RECLOCK("SB9",.F.)
				SB9->B9_QINI   := VAL(TMPIMP->QTD)
				SB9->B9_VINI1  := VAL(TMPIMP->VALOR)
				msunlock()
			Endif
			
		Endif
		
		
		Dbselectarea("TMPIMP")
		dbskip()
		
	Enddo
	
	
	Dbselectarea("TMPIMP")
	dbclosearea()
Endif

if	_linv02

	dbUseArea(.t.,,_cInv02,"TMPIMP",.f.)
	
	procregua(reccount())
	
	Dbselectarea("TMPIMP")
	dbgotop()
	
	Do While ! eof()
		
		INCPROC()
		
		_cCod := "02"+PADR("0"+alltrim(SUBSTR(TMPIMP->COD,2)),15)+"04"
		
		Dbselectarea("SB9")
		dbsetorder(1)
		dbgotop()
		
		if dbseek(_cCod+dtos(_dData),.F.)
			
			if RECLOCK("SB9",.F.)
				SB9->B9_QINI   := VAL(TMPIMP->QTD)
				SB9->B9_VINI1  := VAL(TMPIMP->VALOR)*VAL(TMPIMP->QTD)
				msunlock()
			Endif
			
		Endif
		
		
		Dbselectarea("TMPIMP")
		dbskip()
		
	Enddo
	
	
	Dbselectarea("TMPIMP")
	dbclosearea()
	
	Dbselectarea("SB9")
	
	
endif

if _lsb2
	
	Dbselectarea("SB2")
	set filter to
	dbgotop()
	procregua(reccount())
	
	Do While ! eof()
		
		INCPROC()
		
		if RECLOCK("SB2",.F.)
			
			SB2->B2_VATU2   := 0
			SB2->B2_VATU3   := 0
			SB2->B2_VATU4   := 0
			SB2->B2_VATU5   := 0
			SB2->B2_CM2     := 0
			SB2->B2_CM3     := 0
			SB2->B2_CM4     := 0
			SB2->B2_CM5     := 0
			SB2->B2_QFIM    := 0
			SB2->B2_QFIM2   := 0
			SB2->B2_VFIM1   := 0
			SB2->B2_VFIM2   := 0
			SB2->B2_VFIM3   := 0
			SB2->B2_VFIM4   := 0
			SB2->B2_VFIM5   := 0
			SB2->B2_QEMP    := 0
			SB2->B2_QEMPN   := 0
			SB2->B2_QTSEGUM := 0
			SB2->B2_RESERVA := 0
			SB2->B2_QPEDVEN := 0
			SB2->B2_SALPEDI := 0
			SB2->B2_QTNP    := 0
			SB2->B2_QNPT    := 0
			SB2->B2_QTER    := 0
			
			SB2->B2_CMFF1   := 0
			SB2->B2_CMFF2   := 0
			SB2->B2_CMFF3   := 0
			SB2->B2_CMFF4   := 0
			SB2->B2_CMFF5   := 0
			SB2->B2_VFIMFF1 := 0
			SB2->B2_VFIMFF2 := 0
			SB2->B2_VFIMFF3 := 0
			SB2->B2_VFIMFF4 := 0
			SB2->B2_VFIMFF5 := 0
			SB2->B2_QEMPSA  := 0
			SB2->B2_QEMPPRE := 0
			SB2->B2_SALPPRE := 0
			SB2->B2_QEMP2   := 0
			SB2->B2_QEMPN2  := 0
			SB2->B2_QEPRE2  := 0
			SB2->B2_QFIMFF  := 0
			SB2->B2_QPEDVE2 := 0
			SB2->B2_RESERV2 := 0
			SB2->B2_SALPED2 := 0
			SB2->B2_QEMPPRJ := 0
			SB2->B2_QEMPPR2 := 0
			
			msunlock()
		Endif
		
		dbskip()
		
	Enddo
	
	
Endif

if _lcusto
	
	Dbselectarea("SB9")
	dbsetorder(1)
	dbgotop()
	
	procregua(reccount())
	
	Do While ! eof()
		
		INCPROC()
		
		if b9_data == _data
			
			RECLOCK("SB9",.f.)
			
			if b9_qini > 0
				
				cValCus := 0
				
				dbselectarea("SD1")
				dbsetorder(7)
				
				if dbseek(xfilial("SD1")+sb9->b9_cod+sb9->b9_local,.f.)
					
					Do While ! eof() .and. D1_COD+D1_LOCAL == sb9->b9_cod+sb9->b9_local
						if d1_quant > 0
							cValCus := (d1_total+d1_valipi)/d1_quant
						Endif
						dbskip()
					Enddo
					
				Endif
				
				dbselectarea("SB9")
				SB9->B9_VINI1  := ROUND(SB9->B9_QINI*cValCus,2)
				
			Else
				SB9->B9_VINI1  := 0
			Endif
			
			
			dbselectarea("SB9")
			msunlock()
			
		Endif
		
		Dbselectarea("SB9")
		dbskip()
		
	Enddo
endif

return nil




// *****************************************************************************
Static Function _param()

pergunte("MEP008",.T.)

return nil






///////////////////////////
///////////////////////////
Static Function CriaParam()
///////////////////////////
///////////////////////////

Local i:=0
Local j:=0
Local aSvAlias:={Alias(),IndexOrd(),Recno()}


cPerg := PADR("MEP008",10)
aRegistros:={}
//                                                                           1                                                                                          2                                                          3                               4
//               1      2    3                      4   5   6        7  8  9 0  1   2                        3         4                 5  6  7  8  9                  0  1  2  3  4                  5  6  7  8  9               0  1  2  3  4  5  6  7  8    9  0  1  2
AADD(aRegistros,{cPerg,"01","Data do zeramento  ?",".",".","mv_ch1","D",08,0,0,"G",""                      ,"mv_par01",""               ,"","","","",""                ,"","","","",""                ,"","","","",""             ,"","","","","","","","","  ","","","",""})
AADD(aRegistros,{cPerg,"02","Grupo de Produto   ?",".",".","mv_ch2","C",50,0,0,"G",""                      ,"mv_par02",""               ,"","","","",""                ,"","","","",""                ,"","","","",""             ,"","","","","","","","","  ","","","",""})

dbSelectArea("SX1")
dbsetorder(1)

For i := 1 to Len(aRegistros)
	dbgotop()
	dbSeek(aRegistros[i,1]+aRegistros[i,2])
	if eof()
		if RecLock("SX1",.T.)
			For j:=1 to 41//42
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
