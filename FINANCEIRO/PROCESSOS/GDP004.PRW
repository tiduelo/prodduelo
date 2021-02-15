#include "rwmake.ch"
#include "colors.ch"

User Function gdp004()
/*
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Rotina  :  ALTERAÇÃO DE NATUREZAS CONTAS A PAGAR E FORNECEDOR DE PA
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Descrica:  Controle de ocorrencias internas                             ++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Uso     :  Todos os sistemas                                            ++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++ Alterado:                                                               ++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
_cSE2Area := alias()
_cSE2Ind  := indexord()
_cSE2Rec  := recno()

_lRotina  := .f.

dbSelectArea("SE2")
dbSetOrder(1)
dbgotop()

aRotina := { { "Procurar"      ,'AXPESQUI'     , 0, 1 } ,;
{ "Visualisar"    ,'AXVISUAL' , 0, 2 } ,;
{ "Alterar"       ,'U_ALTNATP()' , 0, 4 }}

cCadastro := "Contas a PAGAR"

mBrowse(01, 01, 30, 70, "SE2")

dbselectarea(_cSE2Area)
dbsetorder(_cSE2Ind)
dbgoto(_cSE2Rec)

Return(.T.)


/*************************/
user function ALTNATP()
/*************************/

if alltrim(upper(se2->e2_tipo)) <> "PA"
	alert("Rotina nao autorizada para tipo diferente de PA")
	return nil
Endif

dbselectarea("SE2")
_nSE2Recno := recno()

_cNatur   := E2_NATUREZ
_cNaturOl := E2_NATUREZ

_cFornece := E2_FORNECE
_cLoja    := E2_LOJA

_cOldForne:= E2_FORNECE
_cOldLoja := E2_LOJA

_cHisEmi   := E2_HIST
_cHisEmiOl := E2_HIST

_cHisBx    := ""
_cHisBxOl  := ""

_cAltFor := iif(alltrim(upper(SE2->E2_TIPO)) == "PA",.t.,.f.)

@ 030,050 To 180,470 Dialog oLib_Sit Title "NATUREZA"

@ 010,004 Say "Fornecedor: "
@ 010,035 GET _cFornece   SIZE 35,15 F3 "SA2" when(_cAltFor) valid (existcpo("SA2")) // .AND. SED->ED_TIPO == "A")
@ 010,075 GET _cLoja      SIZE 10,15          when(_cAltFor)                        // .AND. SED->ED_TIPO == "A")
@ 025,004 Say "Natureza : "
@ 025,035 GET _cNatur   SIZE 35,15 F3 "SED" valid (existcpo("SED")) // .AND. SED->ED_TIPO == "A")
@ 040,004 Say "Hist.Emis: "
@ 040,035 GET _cHisEmi  SIZE 150,15

@ 05,02 to 55,200

@ 60,100 BMPBUTTON TYPE 1 ACTION okpg()
@ 60,140 BMPBUTTON TYPE 2 ACTION CLOSE(oLib_Sit)

ACTIVATE DIALOG oLib_sit CENTERED

IF LastKey() == 27
	Close(oLib_sit)
	_lOkLib := .F.
Endif

return(nil)




//*************************************//
static function okpg()
//*************************************//

Close(oLib_Sit)

dbselectarea("SE2")

_lNatur := .f.
_lHisto := .f.
_lForne := .f.


if _cNatur  <> _cNaturOl
	_lNatur := .t.
Endif

If _cHisEmi <> _cHisEmiOl
	_lHisto := .t.
Endif

If _cFornece+_cLoja <> _cOldForne+_cOldLoja

	_lForne := .t.

	_cNomred := SE2->E2_NOMFOR
	_cNomBen := SE2->E2_NOMFOR
	
	dbselectarea("SA2")
	dbsetorder(1)
	dbgotop()
	
	if dbseek(xfilial("SA2")+_cFornece+_cLoja,.F.)
		_cNomred := A2_NREDUZ
	    _cNomBen := A2_NOME
	Endif

Endif

dbselectarea("SE2")


IF _nSE2Recno == recno()
	
	if _lNatur .or. _lHisto .or. _lForne
		
		IF RecLock("SE2",.F.)
			
			
			if _lNatur .or. _lForne
				
				dbselectarea("SE5")
				dbsetorder(7)
				dbgotop()
				dbseek(xfilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA,.F.)
				
				IF EOF()
					MSGBOX("Este título nao sofreu baixa","Atencao")
				Else
					Do While !EOF() .AND. SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
						
						if _lNatur
							IF E5_NATUREZ == _cNaturOl
								IF RecLock("SE5",.F.)
									SE5->E5_NATUREZ := _cNatur
									MsUnLock()
								Endif
							Endif
						Endif
						
						if _lForne
							IF E5_CLIFOR == _cOldForne .AND. E5_LOJA == _cOldLoja
								IF RecLock("SE5",.F.)
									SE5->E5_CLIFOR  := _cFornece
									SE5->E5_LOJA    := _cLoja
									SE5->E5_FORNECE := _cFornece
									SE5->E5_BENEF   := _cNomBen
									MsUnLock()
								Endif
							Endif
						Endif
						dbskip()
					Enddo
				Endif
				
				if _lForne
					
					dbselectarea("SEF")
					dbsetorder(3)
					dbgotop()
					if dbseek(xfilial("SEF")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO,.f.)
						Do While ! eof() .and. EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO == SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
							IF EF_FORNECE == _cOldForne .AND. EF_LOJA == _cOldLoja
								IF RecLock("SEF",.F.)
									SEF->EF_FORNECE := _cFornece
									SEF->EF_LOJA    := _cLoja
									SEF->EF_BENEF   := _cNomBen
									MsUnLock()
								Endif
							Endif
							dbskip()
						Enddo
					Endif
				Endif
			Endif
			
			if _lHisto
				SE2->E2_HIST    := _cHisEmi
			Endif
			
			if _lForne
				SE2->E2_FORNECE := _cFornece
				SE2->E2_LOJA    := _cLoja
				SE2->E2_NOMFOR  := _cNomred

			Endif
			
			if _lNatur
				SE2->E2_NATUREZ := _cNatur
			Endif
			
			
			dbselectarea("SE2")
			MsUnLock()
		Else
			alert("!!! Problemas no registro do contas a PAGAR !!!")
		Endif
	Endif
	
Endif

Return(NIL)
