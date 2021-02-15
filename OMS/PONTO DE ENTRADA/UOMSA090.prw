#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  UOMSA090 º Autor ³ RAFAEL ALMEIDA - SIGACORP º Data ³30/03/17º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Inserir ou alterar informações no na roterização da venda  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OMSA090 - Pontos por setores                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function UOMSA090(_cCli, _cLoj, _cVdd, _cRota, _cOpcA, _cVend, _cRotAnt)
Local _lRet   := .T.
Local _CntDA5 := 0
Local _CntDA6 := 0
Local _CodCli := _cCli
Local _LjCli  := _cLoj
Local _CoVnd  := _cVdd
Local _CoRot  := _cRota
Local _VdndAt := _cVend
Local _ZonAlt := Space(6)
Local _Zona   := Space(6)
Local _cOpc   := _cOpcA
Local _cQry   := ""
Local _cSeq   := Space(6)
Local _AntRot := _cRotAnt



If ExistCpo("DA5", _CoVnd,2)
	_Zona   := GetAdvFVal("DA5", "DA5_COD",xFilial("DA5")+_CoVnd,2)
	_ZonAlt := GetAdvFVal("DA5", "DA5_COD",xFilial("DA5")+_VdndAt,2)
	If ExistCpo("DA6", _Zona + _CoRot, 1)
		_cQry := "  "
		_cQry += " SELECT	"
		If _cOpc == "ALT"
			_cQry += " TOP 1  REPLICATE('0', 6 - LEN(DA7_SEQUEN+1))+CAST(DA7_SEQUEN+1 AS NVARCHAR(6)) AS DA7_SEQUEN	"
		ElseIf _cOpc == "ROT"
			_cQry += " DA7_SEQUEN	"
		EndIf
		_cQry += " FROM " + RetSqlName("DA7") +"  "
		_cQry += " WHERE D_E_L_E_T_ = ''	"
		_cQry += " AND DA7_FILIAL = '"+xfilial("SF2")+"' "
		If _cOpc == "ALT"
			_cQry += " AND DA7_PERCUR = '"+Alltrim(_Zona)+"' "
		ElseIf _cOpc == "ROT"
			_cQry += " AND DA7_PERCUR = '"+Alltrim(_ZonAlt)+"' "
			_cQry += " AND DA7_CLIENT = '"+Alltrim(_cCli)+"' "
			_cQry += " AND DA7_LOJA = '"+Alltrim(_cLoj)+"' "
		EndIf
		_cQry += " ORDER BY 1 DESC	"
		_cQry := ChangeQuery(_cQry )
		dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQry), "TMPDA7", .F., .T.)
		
		DbSelectArea("TMPDA7")
		TMPDA7->(DbGoTop())
		Do While !TMPDA7->(Eof())
			_cSeq := TMPDA7->DA7_SEQUEN
			TMPDA7->(dbSkip())
		Enddo
		TMPDA7->(DBCLOSEAREA())
		If _cOpc == "INC"
			dbSelectArea("DA7")
			dbSetOrder(2)
			If !dbSeek(xFilial("DA7") + _cCli  + _cLoj + _Zona + _CoRot )
				RecCLock("DA7",.T.)
				DA7->DA7_FILIAL	:= xFilial("DA7")
				DA7->DA7_PERCUR := _Zona
				DA7->DA7_ROTA   := _CoRot
				DA7->DA7_SEQUEN := Alltrim(_cSeq)
				DA7->DA7_CLIENT := _cCli
				DA7->DA7_LOJA  	:= _cLoj
				DA7->(MSUNLOCK())
			eNDiF
		ElseIf _cOpc == "ALT"
			dbSelectArea("DA7")
			dbSetOrder(2)
			If dbSeek(xFilial("DA7") + _cCli  + _cLoj + _ZonAlt + _CoRot )
				RECLOCK("DA7",.F.)
				DA7->DA7_FILIAL	:= xFilial("DA7")
				DA7->DA7_PERCUR := _Zona
				DA7->DA7_ROTA   := _CoRot
				DA7->DA7_SEQUEN := _cSeq
				DA7->DA7_CLIENT := _cCli
				DA7->DA7_LOJA  	:= _cLoj
				MSUNLOCK()
			EndIf
		ElseIf _cOpc == "ROT"
			dbSelectArea("DA7")
			dbSetOrder(2)
			If dbSeek(xFilial("DA7") + _cCli  + _cLoj + _ZonAlt + _AntRot )
				RECLOCK("DA7",.F.)
				DA7->DA7_FILIAL	:= xFilial("DA7")
				DA7->DA7_PERCUR := _ZonAlt
				DA7->DA7_ROTA   := _CoRot
				DA7->DA7_SEQUEN := _cSeq
				DA7->DA7_CLIENT := _cCli
				DA7->DA7_LOJA  	:= _cLoj
				MSUNLOCK()
			EndIf
		EndIf
	Else
		_lRet := .F.
		MsgAlert("Atenção! Esta ROTA não está vinculado a zona do Vendedor!")
	EndIf
Else
	_lRet := .F.
	MsgAlert("Atenção! Vendedor não vinculado a uma ZONA de atendimento!")
EndIf

Return(_lRet)
