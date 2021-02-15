#INCLUDE "rwmake.ch"
////////////////////////////////////////////////////////////////////////////////////////////////
// Processo GDP007 - Importa Ponto e Farmacia para a folha de Pagamento
// Criado em 30-11-09 por Nilson                                                              //
// Utiliza tabelas na pasta \DATA para interface com os funcionários
////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////
/////////////////////
User Function GDP007
/////////////////////
/////////////////////
local cPerg := "GDP007"

CriaPerg(cPerg)
pergunte(cPerg,.t.)

DbSelectArea("SRA")
dbSetOrder(1)


@ 200,1 TO 320,400 DIALOG oImpFol TITLE OemToAnsi("Importa informacoes da Ponto")
@ 02,10 TO 030,200
@ 10,018 Say " Este programa Importara os registros de Ponto"

@ 40,098 BmpButton Type 05 ACTION pergunte(cPerg,.t.)
@ 40,128 BMPBUTTON TYPE 01 ACTION Processa({|| OkImp() },"Processando...")
@ 40,158 BMPBUTTON TYPE 02 ACTION Close(oImpFol)

Activate Dialog oImpFol Centered

DbSelectArea("SRA")

Return nil

/////////////////////////
Static Function OkImp()
/////////////////////////


Close(oImpFol)

_cArqPon  := upper(alltrim(mv_par01))
_cArqFar  := upper(alltrim(mv_par02))

/*
if ! file("\DATA\CPFFUNC"+ GetDbExtension())
alert(" Nao existe arquivo: "+"\DATA\CPFFUNC"+ GetDbExtension())
return nil
Else
*/
procregua(4)

Incproc(" Gerando Tabelas Auxiliares ")
//dbUseArea(.t.,"CTREECDX","\DATA\CPFFUNC"+ GetDbExtension(),"ARQFUN",.f.)

aStru     :={}
aadd(aStru , {"_PONTO" ,"C" ,100,00})
_cArqMov1 := CriaTrab(aStru,.t.)
dbUseArea(.t.,,_cArqMov1,"ARQPON",.f.)

//	aStru :={}
//	aadd(aStru , {"_FARMA" ,"C" ,100,00})

//	_cArqMov2 := CriaTrab(aStru,.t.)
//	dbUseArea(.t.,,_cArqMov2,"ARQFAR",.f.)


Incproc(" Processando Funcionarios ")


//dbselectarea("ARQFUN")
//dbGotop()

/*
_aFun := {}

Do While ! eof()
	
	dbselectarea("SRA")
	dbsetorder(5)
	dbgotop()
	
	if dbseek(xfilial("SRA")+ALLTRIM(ARQFUN->CPF))
		dbselectarea("ARQFUN")
		aadd(_aFun,{ PADL(ALLTRIM(MAT),6,"0") , NOME , ALLTRIM(CPF) , SRA->RA_MAT, SRA->RA_CC })
	Else
		//			alert("Nao encontrado matricula para o CPF: "+ALLTRIM(ARQFUN->CPF))
	Endif
	
	dbselectarea("ARQFUN")
	dbskip()
	
Enddo

*/

Incproc(" Processando Ponto ")

if ! empty(_cArqPon)
	
	if ! file(_cArqPon)
		alert(" Arquivo de ponto nao encontrado !")
	Else
		
		dbselectarea("ARQPON")
		append from &_cArqPon SDF
		dbgotop()
		
		Do While ! eof()
			
			_cMat := substr(_ponto,08,6)
			
			//_nMat := aScan(_aFun,{ |X| X[1] == _cMat })
			
			//if _nMat == 0
			//	Alert("Ponto: Nao encontrada matricula: "+_cMat)
			//Else
			
			dbselectarea("SRA")
			dbsetorder(1)
			dbgotop()
			
			if dbseek(xfilial("SRA")+_cMat)
				
				
				_cCC  := SRA->RA_CC
				_cVer := substr(ARQPON->_ponto,14,3)
				//010 - adic noturno
				//012 - faltas
				//032 - he 50%
				//072 - he 100%
				
				if _cVer == "010"
					_cVer := "116"
				Elseif  _cVer == "012"
					_cVer := "401"
				Elseif  _cVer == "022"
					_cVer := "130"
				Elseif  _cVer == "032"
					_cVer := "120"
				Elseif  _cVer == "072"
					_cVer := "121"
				Else
					alert("Falta integracao para o evento: "+_cVer)
					_cVer := "000"
				Endif
				
				_cQtd := substr(ARQPON->_ponto,17,3)+"."+substr(ARQPON->_ponto,20,2)
				
				if _cVer <> "000"
					_cPeriod:=strzero(year(DDATABASE),4)+strzero(Month(ddatabase),2)
					dbselectarea("RGB")
					dbsetorder(1)
					if !dbseek(xfilial("RGB")+_cMat+_cVer+_cPeriod)
						_lLanca:=.T.
					else
						_lLanca:=.F.
					Endif
					
					IF reclock("RGB",_lLanca)
						RGB->RGB_FILIAL := xfilial("RGB")
						RGB->RGB_PROCES := "00001"
						RGB->RGB_PERIOD := _cPeriod
						RGB->RGB_SEMANA := "01"
						RGB->RGB_ROTEIR := "FOL"
						RGB->RGB_MAT    := _cMat
						RGB->RGB_PD     := _cVer
						RGB->RGB_CC     := _cCC
						RGB->RGB_TIPO1  := "H"
						RGB->RGB_HORAS  := val(_cQtd)
						RGB->RGB_TIPO2  := "I"
						msunlock()
					Endif
					/*
					IF reclock("SRC",.T.)
					SRC->RC_FILIAL := xfilial("SRC")
					SRC->RC_MAT    := _cMat
					SRC->RC_PD     := _cVer
					SRC->RC_CC     := _cCC
					SRC->RC_TIPO1  := "H"
					SRC->RC_HORAS  := val(_cQtd)
					SRC->RC_TIPO2  := "I"
					msunlock()
					Endif
					Endif
					*/
					
				Endif
				
			Endif
			
			dbselectarea("ARQPON")
			dbskip()
			
		Enddo
		
		
	Endif
Endif

/*
Incproc(" Processando Farmacia ")

if ! empty(_cArqFar)
if ! file(_cArqFar)
alert(" Arquivo de Farmacia nao encontrado !")
Else
dbselectarea("ARQFAR")
append from &_cArqFar SDF
dbgotop()

Do While ! eof()

_cMat := substr(_farma,03,6)

//_nMat := aScan(_aFun,{ |X| X[1] == _cMat })
//if _nMat == 0
//_cMat := _afun[_nMat,4]
//_cCC  := _afun[_nMat,5]

dbselectarea("SRA")
dbsetorder(1)
dbgotop()

if dbseek(xfilial("SRA")+_cMat)


_cCC  := SRA->RA_CC
_cVer := "456"

dbselectarea("ARQFAR")

_cQtd := substr(_farma,55,3)+"."+substr(_farma,59,2)

dbselectarea("SRC")
dbsetorder(1)
dbgotop()

if ! dbseek(xfilial("SRC")+_cMat+_cVer)
IF reclock("SRC",.T.)
SRC->RC_FILIAL := xfilial("SRC")
SRC->RC_MAT    := _cMat
SRC->RC_PD     := _cVer
SRC->RC_CC     := _cCC
SRC->RC_TIPO1  := "V"
SRC->RC_VALOR  := val(_cQtd)
SRC->RC_TIPO2  := "I"
msunlock()
Endif
Endif
Else
Alert("Farmacia: Nao encontrada matricula: "+_cMat)
Endif

dbselectarea("ARQFAR")
dbskip()

Enddo

Endif
Endif
*/

//dbselectarea("ARQFUN")
//dbclosearea()
dbselectarea("ARQPON")
dbclosearea()
//	dbselectarea("ARQFAR")
//	dbclosearea()

_cArqMov := _cArqMov1+'.DTC'
DELE FILE &_cArqMov
//	_cArqMov := _cArqMov2 + GetDbExtension()
//	DELE FILE &_cArqMov

//Endif

return nil


///////////////////////////////
///////////////////////////////
Static Function CriaPerg(cPerg)
///////////////////////////////
///////////////////////////////

Local i:= 0
Local j:=0
Private aSvAlias:={Alias(),IndexOrd(),Recno()}


Private cPerg := (cPerg)
Private aRegistros:={}
//                                                                           1                                                                                          2                                                          3                               4
//               1      2    3                      4   5   6        7  8  9 0  1   2                        3         4                 5  6  7  8  9                  0  1  2  3  4                  5  6  7  8  9               0  1  2  3  4  5  6  7  8    9  0  1  2
AADD(aRegistros,{cPerg,"01","Arquivo do Ponto   ?",".",".","mv_ch1","C",60,0,0,"G",""                      ,"mv_par01","            "   ,"","","","","            "    ,"","","","","               " ,"","","","",""             ,"","","","","","","","","  ","","","",""})
AADD(aRegistros,{cPerg,"02","Arquivo da Farmacia?",".",".","mv_ch2","C",60,0,0,"G",""                      ,"mv_par02","            "   ,"","","","","            "    ,"","","","","               " ,"","","","",""             ,"","","","","","","","","  ","","","",""})
cPerg := PADR(cPerg,10)

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
