#INCLUDE "rwmake.ch"
////////////////////////////////////////////////////////////////////////////////////////////////
// Processo GDP001 - Executado corrigir vendedores em faturas geradas
// Criado em 20-10-08 por Nilson                                                              //
////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////
/////////////////////
User Function GDP001
/////////////////////
/////////////////////
local cPerg := "GDP001"


//PswOrder(1)

//If PswSeek("000000",.T.)
//	_VetUs := PswRet(1)
//	for t:=1 to len(_VetUs[1])
//		alert(_VetUs[1][t])
//	Next
//Else
//	Alert("Nao encontrado")
//Endif


CriaPerg(cPerg)
pergunte(cPerg,.t.)

DbSelectArea("SE1")
dbSetOrder(1)


@ 200,1 TO 380,400 DIALOG oFatVend TITLE OemToAnsi("Atualiza os Vendendores de Faturas Geradas")
@ 02,10 TO 030,200
@ 10,018 Say " Este programa gerar os vendendores para as faturas geradas."

@ 40,098 BmpButton Type 05 ACTION pergunte(cPerg,.t.)
@ 40,128 BMPBUTTON TYPE 01 ACTION Processa({|| OkVend() },"Processando...")
@ 40,158 BMPBUTTON TYPE 02 ACTION Close(oFatVend)

Activate Dialog oFatVend Centered

Return nil

/////////////////////////
Static Function OkVend()
/////////////////////////

_dDatade  := mv_par01
_dDataAte := mv_par02

_dDataIni := _dDatade

Close(oFatVend)

Dbselectarea("SE1")
DbSetorder(6)
DbGotop()

dbseek(xfilial("SE1")+dtos(_dDatade),.T.)

procregua(_dDataAte-_dDatade+1)

Do While ! eof() .and. e1_emissao <= _dDataAte
	
	if _dDataIni <> e1_emissao
		_dDataIni := e1_emissao
		incproc()
	Endif
	
	if upper(alltrim(e1_fatura)) == 'NOTFAT'
		
		_nSE1Ind := indexord()
		_nSE1Reg := recno()
		
		_dEmissao:= E1_EMISSAO
		_cFatPrf := E1_PREFIXO
		_cFatNum := E1_NUM
		_cFatCli := E1_CLIENTE
		_cFatLoj := E1_LOJA
		_cVend1  := space(6)
		_cVend2  := space(6)
		_cVend3  := space(6)
		_cVend4  := space(6)
		_cVend5  := space(6)
		
		DbSetorder(21)
		DbGotop()
		
		if dbseek(xfilial("SE1")+_cFatPrf+_cFatNum+_cFatCli+_cFatLoj,.F.)
			if _dEmissao == e1_baixa
				_cVend1  := E1_VEND1
				_cVend2  := E1_VEND2
				_cVend3  := E1_VEND3
				_cVend4  := E1_VEND4
				_cVend5  := E1_VEND5
			Else
				Alert("Emissao da Fatura ("+_cFatPrf+"-"+_cFatNum+") diverge da baixa do titulo ("+e1_prefixo+"-"+e1_num+"-"+e1_parcela+" !")
				_cVend1  := space(6)
				_cVend2  := space(6)
				_cVend3  := space(6)
				_cVend4  := space(6)
				_cVend5  := space(6)
			Endif
		Endif
		
		dbsetorder(_nSE1Ind)
		dbgoto(_nSE1Reg)
		
		if ! empty(_cVend1)
			if reclock("SE1",.F.)
				SE1->E1_VEND1 := _cVend1
				SE1->E1_VEND2 := _cVend2
				SE1->E1_VEND3 := _cVend3
				SE1->E1_VEND4 := _cVend4
				SE1->E1_VEND5 := _cVend5
				msunlock()
			Endif
		Endif
	Endif
	
	dbskip()
	
Enddo

return nil


///////////////////////////////
///////////////////////////////
Static Function CriaPerg(cPerg)
///////////////////////////////
///////////////////////////////
Local j,i := 0
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0

cPerg := PADR(cPerg,10)
aRegistros:={}
//                                                                           1                                                                                          2                                                          3                               4
//               1      2    3                      4   5   6        7  8  9 0  1   2                        3         4                 5  6  7  8  9                  0  1  2  3  4                  5  6  7  8  9               0  1  2  3  4  5  6  7  8    9  0  1  2
AADD(aRegistros,{cPerg,"01","Faturas geradas De ?",".",".","mv_ch1","D",08,0,0,"G",""                      ,"mv_par01","            "   ,"","","","","            "    ,"","","","","               " ,"","","","",""             ,"","","","","","","","","  ","","","",""})
AADD(aRegistros,{cPerg,"02","Faturas geradas Ate?",".",".","mv_ch2","D",08,0,0,"G",""                      ,"mv_par02","            "   ,"","","","","            "    ,"","","","","               " ,"","","","",""             ,"","","","","","","","","  ","","","",""})
//AADD(aRegistros,{cPerg,"02","Pasta Origem/Desti.?",".",".","mv_ch2","C",60,0,0,"G","u_valdir('MV_PAR02',2)","mv_par02",""               ,"","","","",""                ,"","","","",""                ,"","","","",""             ,"","","","","","","","","  ","","","",""})


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
