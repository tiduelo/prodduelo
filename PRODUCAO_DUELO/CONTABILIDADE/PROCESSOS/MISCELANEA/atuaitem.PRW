#Include "RwMake.Ch"
#Include "TopConn.Ch"

User function atuaitem()  

Processa( {|lEnd| ImpCad() 		} , "Por favor aguarde, Atualizando itens ...")

RETURN

Static Function ImpCad()

cQuery:= " ALTER VIEW ITEMCON AS "
cQuery+= " SELECT '2'+A2_COD+A2_LOJA AS CODIGO, A2_NOME AS NOME  FROM "+RETSQLNAME("SA2")+" WHERE D_E_L_E_T_ <> '*' AND NOT EXISTS (SELECT 1 FROM "+RETSQLNAME("CTD")+" WHERE "
cQuery+= " D_E_L_E_T_ <> '*' AND '2'+A2_COD+A2_LOJA = CTD_ITEM) "
cQuery+= " UNION ALL "
cQuery+= " SELECT '1'+A1_COD+A1_LOJA AS CODIGO,A1_NOME AS NOME  FROM "+RETSQLNAME("SA1")+ " WHERE D_E_L_E_T_ <> '*' AND NOT EXISTS (SELECT 1 FROM "+RETSQLNAME("CTD")+" WHERE "
cQuery+= " D_E_L_E_T_ <> '*' AND '1'+A1_COD+A1_LOJA = CTD_ITEM) " 
TCSQLEXEC(cquerY)

cQuery := " SELECT * FROM ITEMCON "

TCQUERY cQuery NEW ALIAS "TRBSA1"

DBGOTOP()
Do while !eof()

	DBSELECTAREA("CTD")
	CTD->(DBSETORDER(1))   
	IF !CTD->(DBSEEK(XFILIAL("CTD") + TRBSA1->(CODIGO)))
		WHILE !RECLOCK("CTD",.T.);ENDDO 		 
		CTD->CTD_FILIAL 	:= XFILIAL("CTD")
		CTD->CTD_ITEM		:= TRBSA1->(CODIGO)
		CTD->CTD_CLASSE	:= "2"
		CTD->CTD_DESC01	:= TRBSA1->(NOME)
		CTD->CTD_BLOQ		:= "2"
		CTD->CTD_DTEXIS	:= CTOD("01/01/1980")
		CTD->CTD_CLOBRG	:= "2"
		CTD->CTD_ACCLVL	:= "2"
		CTD->CTD_ITSUP		:= LEFT(TRBSA1->(CODIGO),1)
		
		CTD->(MSUNLOCK())
		CTD->(DBCOMMITALL())
	ENDIF

   dbselectarea("TRBSA1")
   dbskip()

ENddo


alert("Atualizacao concluida")

Return()



