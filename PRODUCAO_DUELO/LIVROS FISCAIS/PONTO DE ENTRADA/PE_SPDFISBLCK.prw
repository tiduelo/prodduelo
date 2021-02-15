#INCLUDE "PROTHEUS.CH"
User Function SPDFISBLCK()

Local aRet := {}
Local dDtIni   := PARAMIXB[1]
Local dDtFin   := PARAMIXB[2]
Local cAliasK200 := ''
Local _cQry      := " "

//-----------------------------------------------------------------
//Cria alias e tabelas temporárias do bloco K
//-----------------------------------------------------------------
u_TmpBlcK(@cAliasK200)


//----------------------------------------------------------------
//Adicionando informações no arquivo temporário para registro K200
//----------------------------------------------------------------
_cQry := " "
_cQry += " SELECT "
_cQry += "  B9_FILIAL "
_cQry += " ,B9_DATA  "
_cQry += " ,RTRIM(LTRIM(B9_COD))+'        '+RTRIM(LTRIM(B9_LOCAL)) AS B9_COD    "
_cQry += " ,B9_QINI    "
_cQry += "  FROM " + RetSqlName("SB9") +" B9 "
_cQry += "  INNER JOIN " + RetSqlName("SB1") +" B1 "   
_cQry += " ON B1_COD = B9_COD "
_cQry += " WHERE B9.D_E_L_E_T_ <> '*'  "
_cQry += " AND   B1.D_E_L_E_T_ <> '*'  "
_cQry += " AND B9_DATA BETWEEN '"+ DtoS(dDtIni) + "' AND '"+ DtoS(dDtFin) + "' "
_cQry += " AND B1_TIPO IN ('PA', 'PI', 'PP', 'ME', 'SP', 'MP') "
_cQry := ChangeQuery(_cQry )
dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQry), "TMPSB9", .F., .T.)

DbSelectArea("TMPSB9")
TMPSB9->(DbGoTop())

Do While !TMPSB9->(Eof())
	
	RecLock (cAliasK200, .T.)
		(cAliasK200)->FILIAL   := TMPSB9->B9_FILIAL
		(cAliasK200)->REG      := 'K200'
		(cAliasK200)->DT_EST   := StoD(TMPSB9->B9_DATA)
		(cAliasK200)->COD_ITEM := TMPSB9->B9_COD
		(cAliasK200)->QTD      := TMPSB9->B9_QINI
		(cAliasK200)->IND_EST  := '0'
		(cAliasK200)->COD_PART := ''
	MsUnLock ()
	
	TMPSB9->(dbSkip())
Enddo
TMPSB9->(DBCLOSEAREA())


//Adiciona alias das tabelas temporárias criadas
aAdd(aRet,cAliasK200)
Return aRet

//-------------------------------------------------------------------
/*/{Protheus.doc} TmpBlcK
Função para criação das tabelas temporárias para geração do bloco K
/*/
//-------------------------------------------------------------------
User Function TmpBlcK(cAliasK200)

Local aCampos   := {}
Local nTamFil   := TamSX3("D1_FILIAL")[1]
Local nTamDt    := TamSX3("D1_DTDIGIT")[1]
Local aTamQtd   := TamSX3("B2_QATU")
Local nTamOP    := TamSX3("D3_OP")[1]
Local nTamCod   := TamSX3("B1_COD")[1]
Local nTamChave := TamSX3("D1_COD")[1] + TamSX3("D1_SERIE")[1] + TamSX3("D1_FORNECE")[1] + TamSX3("D1_LOJA")[1]
Local nTamPar   := TamSX3("A1_COD")[1]
Local nTamReg   := 4
Local cArqK200  := ''


//--------------------------------------------
//Criacao do Arquivo de Trabalho - BLOCO K200
//--------------------------------------------
aCampos := {}
AADD(aCampos,{"FILIAL"   ,"C",nTamFil ,0})
AADD(aCampos,{"REG"      ,"C",nTamReg ,0}) //Campo 01 do registro K200
AADD(aCampos,{"DT_EST"   ,"D",nTamDt ,0}) //Campo 02 do registro K200
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Campo 03 do registro K200
AADD(aCampos,{"QTD" ,"N" ,aTamQtd[1],aTamQtd[2]}) //Campo 04 do registro K200
AADD(aCampos,{"IND_EST"  ,"C",1 ,0}) //Campo 05 do registro K200
AADD(aCampos,{"COD_PART" ,"C",nTamPar,0}) //Campo 06 do registro K200

cAliasK200 := 'K200'
cArqK200 := CriaTrab(aCampos)
dbUseArea(.T.,__LocalDriver,cArqK200, cAliasK200, .F., .F. )
IndRegua(cAliasK200,cArqK200,"FILIAL+DTOS(DT_EST)+COD_ITEM")
DbSelectArea(cAliasK200)
DbSetOrder(1)

Return
