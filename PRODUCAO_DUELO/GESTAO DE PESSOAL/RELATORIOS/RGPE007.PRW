#include "rwmake.ch"

User Function Rgpe007()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CAREA,NIND,CSTRING,CDESC1,CDESC2,CDESC3,CRELATO,NLIN,CABEC1")
SetPrvt("TAMANHO,AORD,ARETURN,NOMEPROG,ALINHA,NLASTKEY")
SetPrvt("TITULO,CCANCEL,CPERG,M_PAG,WNREL")
SetPrvt("CCUSTINI,CCUSTFIM,_NTCC,_CCUSTO,WDSIT,_NTOT")
SetPrvt("_NMENS,_NSEMA,_NLABO,_NAUTO,_NEST,_NOUT,_NMASC,_NFEM")

/*
Descricao: Resumo de Pessoal por centro de custo, por categoria funcional, por sexo, faixa etaria e sexo, função e por grau de instrução.
*/

cArea   := Alias()
nInd    := IndexOrd()
cString := "SRA"
cDesc1  := OemToAnsi("Esta rotina ir  imprimir o Resumo de Pessoal, considerando somente os ")
cDesc2  := OemToAnsi("Ativos e os de Ferias, descartando Autonomos")
cDesc3  := OemToAnsi("")
tamanho := "P"
limite  := 80
aOrd    := {}
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog:= "RGPE007"
aLinha  := { }
nLastKey:= 0
Titulo  := "Resumo de Pessoal"
cCancel := "***** CANCELADO PELO OPERADOR *****"
cPerg   := ""
m_pag   := 1
wnrel   :="RGPE007"

//wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho)
//Pergunte(cPerg,.F.)

wnrel:= SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

dbSelectArea("CTT")
dbSetOrder(1)

dbSelectArea("SRJ")
dbSetOrder(1)

dbSelectArea("SRH")
dbSetOrder(2)

dbSelectArea("SRC")
dbSetOrder(1)

dbSelectArea("SRA")
dbSetOrder(2)  //" Por CCusto + Matricula"

//-----------------------------------------//
// EXECUTA ROTINA DE IMPRESSAO DO RELATORIO//
//-----------------------------------------//
RptStatus({|| RptDetail() })

dbSelectArea( cArea )

DBSELECTAREA("SRH")
Retindex("SRH")

dbSelectArea("SRA")
Retindex("SRA")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RptDetail()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do corpo do relatorio                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RptDetail()
Local _nPos := 0

//------------------------------------------------//
// INICIALIZA VARIAVEIS UTILIZADAS NA FUNCAO      //
//------------------------------------------------//
nReg    := 1
nLin    := 0
m_pag   := 1
cCabec1 := ' '
cCabec2 := ' '
aFuncao := {}
aInstruc := {}

Store 0 to _NTOT,_nTCC,_nMENS,_nSEMA,_nLABO,_nAUTO,_nEST,_nOUT,_nMasc,_nFem
Store 0 to _Id18M,_Id18F,_Id23M,_Id23F,_Id28M,_Id28F,_Id33M,_Id33F
Store 0 to _Id38M,_Id38F,_Id43M,_Id43F,_Id48M,_Id48F,_Id53M,_Id53F
Store 0 to _Id58M,_Id58F,_Id59M,_Id59F

Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
nLinha := 6
@ nLinha,008 Psay "--> QUADRO DE FUNCIONARIOS POR CENTRO DE RESULTADOS:"
nLinha := nLinha + 1
_cCusto := ""
_cDescCC:= ""
SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios
dbSelectArea("SRA")
dbSeek(xFilial("SRA"),.T.)

Do While !Eof() .and. SRA->RA_FILIAL == SM0->M0_CODFIL
	If SRA->RA_SITFOLH == "D"  // Descarta os demitidos
		dbSkip()
		Loop
	EndIf

	If SRA->RA_CATFUNC == "A"  // Descarta Autonomos
		dbSkip()
		Loop
	EndIf
	
	_cCusto := SRA->RA_CC
	
	Do While !Eof() .and. SRA->RA_FILIAL == SM0->M0_CODFIL .and. SRA->RA_CC == _cCusto
		If SRA->RA_SITFOLH == "D"  // Descarta os demitidos
			dbSkip()
			Loop
		EndIf

	    If SRA->RA_CATFUNC == "A"  // Descarta Autonomos
		   dbSkip()
		   Loop
	    EndIf

		// Totaliza por Funcao
		_cFuncao := UPPER(ALLTRIM(SRA->RA_CODFUNC))
		_nPos  := ASCAN( aFuncao , {|X| UPPER(ALLTRIM(X[1])) == _cFuncao })
		If _nPos == 0
			AADD(aFuncao,{_cFuncao,1})
		Elseif _nPos <> 0
			aFuncao[_nPos][2] := aFuncao[_nPos][2] + 1
		EndIf

		// Totaliza por Grau Instrucao
		_cInstruc := UPPER(ALLTRIM(SRA->RA_GRINRAI))
		_nPos  := ASCAN( aInstruc , {|X| UPPER(ALLTRIM(X[1])) == _cInstruc })
		If _nPos == 0
			AADD(aInstruc,{_cInstruc,1})
		Elseif _nPos <> 0
			aInstruc[_nPos][2] := aInstruc[_nPos][2] + 1
		EndIf

		_cCusto := SRA->RA_CC
		_nTCC := _nTCC + 1          // TOTAL DO CENTRO DE CUSTO

		
		IncRegua() //Incrementa a posicao da regua de relatorios
		
		CTT->(dbSeek(xFilial("CTT")+SRA->RA_CC))
	    _cDescCC:=LEFT(CTT->CTT_DESC01,25)
	    
		dbSelectArea("SRA")
		
		SRJ->(dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
		If SRA->RA_CATFUNC=="S"       // Se Semanalista
			_nSEMA:=_nSEMA + 1
		ElseIf SRA->RA_CATFUNC=="M"   // Se Mensalista
			_nMENS:=_nMENS + 1
		ElseIf SRA->RA_CATFUNC=="P"   // Se Pro-Labore
			_nLABO:=_nLABO + 1
		ElseIf SRA->RA_CATFUNC=="A"   // Se Autonomo
			_nAUTO:=_nAUTO + 1
		ElseIf SRA->RA_CATFUNC=="E"   // Se Estagiario
			_nEST :=_nEST  + 1
		Else
			_nOUT :=_nOUT  + 1
		EndIf
		
		dbSelectArea("SRA")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Testa a idade a do Funcionario(considerando apenas o mes nasc) ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		cDataNas := dtos(SRA->RA_NASC)
		cDataAtu := dtos(DDATABASE)
		
		cAnoNas  := Substr(cDataNas,1,4)
		cAnoAtu  := Substr(cDataAtu,1,4)
		
		cMesNas  := Substr(cDataNas,5,4)
		cMesAtu  := Substr(cDataAtu,5,4)
		
		_idade := val(cAnoAtu)-val(cAnoNas)
		
		If cMesNas > cMesAtu
			_idade := _idade - 1
		Endif
		
		If _idade <= 18
			IF SRA->RA_SEXO == "M"
				_id18M := _id18M + 1
			ELSEIF SRA->RA_SEXO == "F"
				_id18F := _id18F + 1
			ENDIF
		Elseif _idade > 18 .and. _idade <= 23
			IF SRA->RA_SEXO == "M"
				_id23M := _id23M + 1
			ELSEIF SRA->RA_SEXO == "F"
				_id23F := _id23F + 1
			ENDIF
		Elseif _idade > 23 .and. _idade <= 28
			IF SRA->RA_SEXO == "M"
				_id28M := _id28M + 1
			ELSEIF SRA->RA_SEXO == "F"
				_id28F := _id28F + 1
			ENDIF
		Elseif _idade > 28 .and. _idade <= 33
			IF SRA->RA_SEXO == "M"
				_id33M := _id33M + 1
			ELSEIF SRA->RA_SEXO == "F"
				_id33F := _id33F + 1
			ENDIF
		Elseif _idade > 33 .and. _idade <= 38
			IF SRA->RA_SEXO == "M"
				_id38M := _id38M + 1
			ELSEIF SRA->RA_SEXO == "F"
				_id38F := _id38F + 1
			ENDIF
		Elseif _idade > 38 .and. _idade <= 43
			IF SRA->RA_SEXO == "M"
				_id43M := _id43M + 1
			ELSEIF SRA->RA_SEXO == "F"
				_id43F := _id43F + 1
			ENDIF
		Elseif _idade > 43 .and. _idade <= 48
			IF SRA->RA_SEXO == "M"
				_id48M := _id48M + 1
			ELSEIF SRA->RA_SEXO == "F"
				_id48F := _id48F + 1
			ENDIF
		Elseif _idade > 48 .and. _idade <= 53
			IF SRA->RA_SEXO == "M"
				_id53M := _id53M + 1
			ELSEIF SRA->RA_SEXO == "F"
				_id53F := _id53F + 1
			ENDIF
		Elseif _idade > 53 .and. _idade <= 58
			IF SRA->RA_SEXO == "M"
				_id58M := _id58M + 1
			ELSEIF SRA->RA_SEXO == "F"
				_id58F := _id58F + 1
			ENDIF
		Elseif _idade > 58
			If SRA->RA_SEXO == "M"
				_id59M := _id59M + 1
			ElseIf SRA->RA_SEXO == "F"
				_id59F := _id59F + 1
			EndIf
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Testa o sexo do Funcionario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If SRA->RA_SEXO == "M"
			_nMasc := _nMasc + 1
		ElseIf SRA->RA_SEXO == "F"
			_nFem := _nFem + 1
		EndIf
		
		dbSelectArea("SRA")
		dbSkip()
		
	EndDo
	
	@ nLinha,012 Psay _cDescCC + "  -> " + STRZERO(_nTCC,3)
	nLinha:=nLinha+1
	_nTot:=_nTot + _nTCC
	_nTCC:=0
	
EndDo
@ nLinha,012 Psay "--------------- T O T A L  -> " + STRZERO(_nTot,3)
nLinha:=nLinha+1
@ nLinha,000 PSAY __PrtThinLine()
nLinha:=nLinha+1
@ nLinha,008 Psay "--> RESUMO POR CATEGORIA FUNCIONAL: "
nLinha:=nLinha+1
@ nLinha,008 PSAY "    MENSALISTAS                -> " + STRZERO(_nMENS,3)
nLinha:=nLinha+1
@ nLinha,008 PSAY "    SEMANALISTAS               -> " + STRZERO(_nSEMA,3)
nLinha:=nLinha+1
@ nLinha,008 PSAY "    PRO-LABORE                 -> " + STRZERO(_nLABO,3)
nLinha:=nLinha+1
//@ nLinha,008 PSAY "    AUTONOMOS                  -> " + STRZERO(_nAUTO,3)
//nLinha:=nLinha+1
@ nLinha,008 PSAY "    ESTAGIARIOS                -> " + STRZERO(_nEST,3)
nLinha:=nLinha+1
@ nLinha,008 PSAY "    OUTROS                     -> " + STRZERO(_nOUT,3)
nLinha:=nLinha+1
@ nLinha,000 PSAY __PrtThinLine()
nLinha:=nLinha+1
@ nLinha,008 Psay "--> RESUMO POR SEXO: "
nLinha:=nLinha+1
@ nLinha,008 PSAY "--> EMPREG.SEXO MASCULINO      -> " + STRZERO(_nMASC,3)
nLinha:=nLinha+1
@ nLinha,008 PSAY "--> EMPREG.SEXO FEMININO       -> " + STRZERO(_nFEM,3)
nLinha:=nLinha+1

@ nLinha,000 PSAY __PrtThinLine()                                      //
//***********************************************************************
nLinha:=nLinha+1                                           
@ nLinha,008 Psay "--> RESUMO POR FAIXA ETARIA E SEXO: "
nLinha:=nLinha+1
@ nLinha,040 PSAY "-MASCULINO-  -FEMININO-"
nLinha:=nLinha+1
@ nLinha,040 PSAY "QTD    %      QTD   %"
nLinha:=nLinha+1
@ nLinha,040 PSAY "-----------  -----------"
nLinha:=nLinha+1
@ nLinha,008 PSAY "     0 A 18 ANOS             -> " + STRZERO(_Id18M,3) + SPACE(2) + Str((_Id18M/_nTot)*100,5,2) + "%"
@ nLinha,054 PSAY STRZERO(_Id18F,3) + SPACE(1) + Str((_Id18F/_nTot)*100,5,2)  + "%"
nLinha:=nLinha+1
@ nLinha,008 PSAY "    19 A 23 ANOS             -> " + STRZERO(_Id23M,3) + SPACE(2) + Str((_Id23M/_nTot)*100,5,2) + "%"
@ nLinha,054 PSAY STRZERO(_Id23F,3) + SPACE(1) + Str((_Id23F/_nTot)*100,5,2)  + "%"
nLinha:=nLinha+1
@ nLinha,008 PSAY "    24 A 28 ANOS             -> " + STRZERO(_Id28M,3) + SPACE(2) + Str((_Id28M/_nTot)*100,5,2) + "%"
@ nLinha,054 PSAY STRZERO(_Id28F,3) + SPACE(1) + Str((_Id28F/_nTot)*100,5,2)  + "%"
nLinha:=nLinha+1
@ nLinha,008 PSAY "    29 A 33 ANOS             -> " + STRZERO(_Id33M,3) + SPACE(2) + Str((_Id33M/_nTot)*100,5,2) + "%"
@ nLinha,054 PSAY STRZERO(_Id33F,3) + SPACE(1) + Str((_Id33F/_nTot)*100,5,2)  + "%"
nLinha:=nLinha+1
@ nLinha,008 PSAY "    34 A 38 ANOS             -> " + STRZERO(_Id38M,3) + SPACE(2) + Str((_Id38M/_nTot)*100,5,2) + "%"
@ nLinha,054 PSAY STRZERO(_Id38F,3) + SPACE(1) + Str((_Id38F/_nTot)*100,5,2)  + "%"
nLinha:=nLinha+1
@ nLinha,008 PSAY "    39 A 43 ANOS             -> " + STRZERO(_Id43M,3) + SPACE(2) + Str((_Id43M/_nTot)*100,5,2) + "%"
@ nLinha,054 PSAY STRZERO(_Id43F,3) + SPACE(1) + Str((_Id43F/_nTot)*100,5,2)  + "%"
nLinha:=nLinha+1
@ nLinha,008 PSAY "    44 A 48 ANOS             -> " + STRZERO(_Id48M,3) + SPACE(2) + Str((_Id48M/_nTot)*100,5,2) + "%"
@ nLinha,054 PSAY STRZERO(_Id48F,3) + SPACE(1) + Str((_Id48F/_nTot)*100,5,2)  + "%"
nLinha:=nLinha+1
@ nLinha,008 PSAY "    49 A 53 ANOS             -> " + STRZERO(_Id53M,3) + SPACE(2) + Str((_Id53M/_nTot)*100,5,2) + "%"
@ nLinha,054 PSAY STRZERO(_Id53F,3) + SPACE(1) + Str((_Id53F/_nTot)*100,5,2)  + "%"
nLinha:=nLinha+1
@ nLinha,008 PSAY "    54 A 58 ANOS             -> " + STRZERO(_Id58M,3) + SPACE(2) + Str((_Id58M/_nTot)*100,5,2) + "%"
@ nLinha,054 PSAY STRZERO(_Id58F,3) + SPACE(1) + Str((_Id58F/_nTot)*100,5,2)  + "%"
nLinha:=nLinha+1
@ nLinha,008 PSAY "    59 ANOS OU MAIS          -> " + STRZERO(_Id59M,3) + SPACE(2) + Str((_Id59M/_nTot)*100,5,2) + "%"
@ nLinha,054 PSAY STRZERO(_Id59F,3) + SPACE(1) + Str((_Id59F/_nTot)*100,5,2)  + "%"
nLinha:=nLinha+1
@ nLinha,000 PSAY __PrtThinLine()
nLinha:=nLinha+1

//---------------------------------//
// FUNÇÃO                         //
//---------------------------------//
_nPos := 0
@ nLinha,008 PSAY "--> RESUMO POR FUNÇÃO:" 
nLinha ++
For _nPos := 1 to Len(aFuncao)
	If nLinha > 55
        Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
        nLinha := 6
        @ nLinha,001 Psay "--> FUNCAO: "
        nLinha ++
	Endif

    _cFuncao :=	""
    dbSelectArea("SRJ")
   	dbSeek(xFILIAL("SRJ")+aFuncao[_nPos][1],.F.)
    IF !EOF()
        _cFuncao := SRJ->RJ_DESC
    ELSE
	    _cFuncao := "Nao Cadastrada"
	ENDIF   	
  	@ nLinha,12 PSAY Substr(_cFuncao,1,18)
	@ nLinha,33 PSay "-> "+Transform(aFuncao[_nPos][2],"@E ###") + SPACE(1) + Str((aFuncao[_nPos][2]/_nTot)*100,5,2)  + "%"
	nLinha := nLinha + 1
Next _nPos
nLinha ++
@ nLinha,000 PSAY __PrtThinLine()
nLinha:=nLinha+1
                
//---------------------------------//
// GRAU DE INSTRUCAO              //
//---------------------------------//
_nPos := 0
@ nLinha,008 PSAY "--> RESUMO POR GRAU DE INSTRUCAO:            QTD    %" 
nLinha ++
For _nPos := 1 to Len(aInstruc)
	If nLinha > 55
        Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
        nLinha := 6
        @ nLinha,008 PSAY "--> RESUMO POR GRAU DE INSTRUCAO:            QTD    %" 
        nLinha ++
	Endif

    _cInstruc := ""
    _cDscInst := Tabela("26",aInstruc[_nPos][1])
  	@ nLinha,12 PSAY SUBSTR(_cDscInst,1,35)
	@ nLinha,50 PSay "-> "+Transform(aInstruc[_nPos][2],"@E ###") + SPACE(3) + Str((aInstruc[_nPos][2]/_nTot)*100,5,2)  + "%"
	nLinha := nLinha + 1
Next _nPos
nLinha ++


dbClearFilter()

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return
