#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110END  º Autor³ RAFAEL ALMEIDA SIGACORP ºData ³ 12/05/17 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Após o acionamento dos botões Solicitação Aprovada,        º±±
±±º          ³ Rejeita ou Bloqueada, deve ser utilizado para validações   º±±
±±º          ³ do usuario após a execução das ações dos botões.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA110                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/       
User Function MT110END()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

 Local nNumSC := PARAMIXB[1]       // Numero da Solicitação de compras
 Local nOpca  := PARAMIXB[2]       // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear 
 Local cUpdate := ""


	BEGIN TRANSACTION
		cUpdate := " "
		cUpdate += " UPDATE "+RetSQLName("SC1")+" "
		cUpdate += " 	SET C1_SITSC  = '"+ cValToChar(nOpca)   +"'  "
		cUpdate += " 	,   C1_DTAPRO = '"+ DtoS(Date()) +"'  "
		cUpdate += " 	,   C1_NMAPRO1 = '"+ Alltrim(UsrFullName(RetCodUsr())) +"'  "				
		cUpdate += " WHERE 	C1_FILIAL  = '"+ xFilial("SC1")   +"'  "
		cUpdate += " 	AND	C1_NUM  = '"+Alltrim(nNumSC) +"'  "
		cUpdate += " 	AND	D_E_L_E_T_ = ''             "
		TcSqlExec(cUpdate)
		TcSqlExec("COMMIT")
	END TRANSACTION


/*
DbSelectArea("SC1")
DbSetOrder(1)
Set Filter To SC1->C1_NUM == nNumSC

While !Eof() .And. SC1->C1_NUM == nNumSC

	RECLOCK("SC1",.F.)
		SC1->C1_SITSC  := cValToChar(nOpca)
		SC1->C1_DTAPRO := Date()
	MSUNLOCK() 
	
Dbskip()
Enddo
*/
    
Return ()
