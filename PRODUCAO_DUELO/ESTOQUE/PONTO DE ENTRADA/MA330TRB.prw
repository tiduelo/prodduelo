/*
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


User Function MA330TRB( )
//User Function MA330TRB()
Local aArea     := GetArea()
Local aAreaSD3  := SD3->(GetArea())
Local cAltera   := '000001'  

cQry := " "
cQry += " 	SELECT 	"
cQry += " 	R_E_C_N_O_ AS D3_RECNO, *	 "
cQry += " 	FROM "+ RETSQLNAME("SD3")+"  "
cQry += " 	WHERE D_E_L_E_T_ = ''	"
cQry += " 		AND D3_FILIAL = '"+xfilial("SD3")  +"' "
cQry += " 		AND D3_EMISSAO BETWEEN '20180219' AND '20180228'	"   //     '"+ DTOS(MV_PAR01) + "' AND '"+ DTOS(MV_PAR02) + "' "
cQry += " 	ORDER BY D3_FILIAL, D3_COD, D3_LOCAL, D3_EMISSAO, D3_TM	"
cQry:= ChangeQuery(cQry)
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TMPSD3" , .T. , .F.)

DBSelectArea("TMPSD3")
TMPSD3->(DbGoTop())
While !(TMPSD3->(EOF()))
	dbselectarea("TRB")
	dbgoto(TMPSD3->D3_RECNO)
	If TMPSD3->D3_CF $ 'DE4'
		RecLock("TRB",.F.)
		TRB_ORDEM := '100'
		TRB_SEQ   := cAltera
		TRB_CHAVE := cAltera+TMPSD3->D3_EMISSAO+ALLTRIM(TMPSD3->D3_COD)+ALLTRIM(D3_LOCAL)+'100'
		MsUnlock()
	ElseIf TMPSD3->D3_CF $ 'RE4'
		RecLock("TRB",.F.)
		TRB_ORDEM := '500'
		TRB_SEQ   := cAltera
		TRB_CHAVE := cAltera+TMPSD3->D3_EMISSAO+ALLTRIM(TMPSD3->D3_COD)+ALLTRIM(D3_LOCAL)+'500'
		MsUnlock()
	EndIf
	If TMPSD3->D3_CF $ 'DE0/PR0'
		RecLock("TRB",.F.)
		TRB_ORDEM := '300'
		TRB_SEQ   := cAltera
		TRB_CHAVE := cAltera+TMPSD3->D3_EMISSAO+ALLTRIM(TMPSD3->D3_COD)+ALLTRIM(D3_LOCAL)+'300'
		MsUnlock()
	EndIf
	If TMPSD3->D3_CF $ 'RE0/RE1'
		RecLock("TRB",.F.)
		TRB_ORDEM := '999'
		TRB_SEQ   := cAltera
		TRB_CHAVE := cAltera+TMPSD3->D3_EMISSAO+ALLTRIM(TMPSD3->D3_COD)+ALLTRIM(D3_LOCAL)+'999'
		MsUnlock()
	EndIf
	cAltera := soma1(cAltera)
	DbSelectArea("TRB")
	TMPSD3->(DbSkip())
End
RestArea(aAreaSD3)
RestArea(aArea)
Return Nil

*/

/*
Local aArea     := GetArea()
Local aAreaSD3  := SD3->(GetArea())
Local cAltera       := '000001'
Local nQtdeReg                := 0
Local nQtdeAlt  := 0
Local aMatCF     := {}

DbSelectArea("TRB")
dbGoTop()
While !(TRB->(EOF()))
nQtdeReg++

If  TRB->TRB_ALIAS == 'SD3' .and. Alltrim(TRB->TRB_CF) $ 'DE4/RE4'

dbselectarea("SD3")
dbgoto(TRB->TRB_RECNO)

If SD3->D3_TM <= "499"
RecLock("TRB",.F.)
TRB_NIVEL  := ''
TRB_SEQPRO := ''
TRB_ORDEM := '100'
TRB_SEQ   := cAltera
MsUnlock()
Else
RecLock("TRB",.F.)
TRB_NIVEL  := ''
TRB_SEQPRO := ''
TRB_ORDEM  := '500'
TRB_SEQ    := cAltera
MsUnlock()
EndIf
cAltera := soma1(cAltera)
ElseIf  TRB->TRB_ALIAS == 'SD3' .and. Alltrim(TRB->TRB_CF) $ 'RE0/RE1'

dbselectarea("SD3")
dbgoto(TRB->TRB_RECNO)

If SD3->D3_CF $ 'RE0/RE1'
RecLock("TRB",.F.)
TRB_ORDEM := '999'
MsUnlock()
EndIf
Endif

DbSelectArea("TRB")
DbSkip()

EndDo

RestArea(aAreaSD3)
RestArea(aArea)

Return Nil
*/
