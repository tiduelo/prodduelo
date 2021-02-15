#include "protheus.ch"
/*/
+-----------------------------------------------------------------------------
| Função | MBRWENCH | Autor | ARNALDO RAYMUNDO JR.|Data | |
+-----------------------------------------------------------------------------
| Descrição | Programa que demonstra a utilização da função Enchoice() |
+-----------------------------------------------------------------------------
| Uso | Curso ADVPL |
+-----------------------------------------------------------------------------
/*/
User Function MrbwZD3()
Local aCores := {	{'ZD3_STATUS == "1"' ,"BR_VERDE"   },;
					{'ZD3_STATUS == "2"' ,"BR_AMARELO" },;
					{'ZD3_STATUS == "3"' ,"BR_AZUL"    },;
					{'ZD3_STATUS == "4"' ,"BR_VERMELHO" }}
Private cCadastro := " Cadastro de Clientes"
Private aRotina := {{"Pesquisar"  , "axPesqui" , 0, 1},;
{"Visualizar" , "axvisual" , 0, 2},;
{"Aprovar"    , "U_AprZD3" , 0, 3},;
{"Rejeitar"   , "U_RejZD3" , 0, 4},;
{"Legenda"    , "U_LegZD3" , 0, 6}}





DbSelectArea("ZD3")
DbSetOrder(1)

MBrowse(6,1,22,75,"ZD3",,,,,,aCores)

Return (.T.)

//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function LegZD3()
Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE"      ,"Transferencia - Aberto" })
AADD(aLegenda,{"BR_AMARELO"    ,"Devolução - Aberto" })
AADD(aLegenda,{"BR_AZUL"       ,"Transf/Devol - Aprovada"  })
AADD(aLegenda,{"BR_VERMELHO"   ,"Transf/Devol - Rejeitado" })

BrwLegenda(cCadastro, "Legenda", aLegenda)
Return (.T.)

//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function AprZD3()
Local _cCdUser := Alltrim(RETCODUSR())
Local _cNmUser := Alltrim(USRFULLNAME(RETCODUSR()))


IF ALLTRIM(ZD3->ZD3_STATUS) == "1" .Or.  ALLTRIM(ZD3->ZD3_STATUS) == "2"
	IF MsgYesNo("Confirma Aprovação?")
		DBSELECTAREA("ZD3")
		DBSETORDER(1)
		IF DBSEEK(xFilial("ZD3")+ZD3->ZD3_NUMSEQ)
			RECLOCK("ZD3",.F.)
			ZD3_STATUS := "3"
			ZD3_DTAPRJ := Date()
			ZD3_IDAPRJ := _cCdUser
			ZD3_NMAPRJ := _cNmUser
			ZD3->(MSUNLOCK())
		ENDIF
		//			U_SenfMail(cTitulo, cCodSolic, cStatus)
		ZD3->(dbCloseArea())
		MSGINFO("Aprovação gerada com sucesso!")
	ELSE
		Return
	ENDIF
ELSE
	ALERT("Não é possivel aprovar o documento! Verifique seu STATUS", "A T E N Ç Ã O")
ENDIF

Return()



//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function RejZD3()
Local _cCdUser := Alltrim(RETCODUSR())
Local _cNmUser := Alltrim(USRFULLNAME(RETCODUSR()))
Local _cNumSeq := ZD3->ZD3_NUMSEQ
Local _cDoc	   := ZD3->ZD3_DOC 
Local aAuto    := {} 
PRIVATE lMsHelpAuto := .T.

PRIVATE lMsErroAuto := .F.	


IF ALLTRIM(ZD3->ZD3_STATUS) == "1" .Or.  ALLTRIM(ZD3->ZD3_STATUS) == "2"
	IF MsgYesNo("Confirma Rejeição?")
		DBSELECTAREA("ZD3")
		DBSETORDER(1)
		IF DBSEEK(xFilial("ZD3")+ZD3->ZD3_NUMSEQ)
			RECLOCK("ZD3",.F.)
			ZD3_STATUS := "4"
			ZD3_DTAPRJ := Date()
			ZD3_IDAPRJ := _cCdUser
			ZD3_NMAPRJ := _cNmUser
			ZD3->(MSUNLOCK())  

			
			BEGIN TRANSACTION			
				aadd(aAuto,{_cDoc,_cNumSeq})
				DBSELECTAREA("SD3")
				DBSETORDER(8)
				DbSeek(xFilial("SD3") + _cDoc + _cNumSeq )  // procura na SD3 passando o documento da Transferência realizada			
				Processa( {|| MSExecAuto({|x,y| mata261(x,y)},aAuto,6)}, "Estornando Transferências... ")     

					If!lMsErroAuto			
	
						MsgInfo("Estorno com sucesso! " + _cDoc, "OK")			
					
Else			
	
						MsgStop("Erro no Estorno!" + _cDoc,"A T E N Ç Ã O")			
	
						MostraErro()		
					
EndIf	
				
			END TRANSACTION
			
		ENDIF
		//			U_SenfMail(cTitulo, cCodSolic, cStatus)
		ZD3->(dbCloseArea())
		MSGINFO("Rejeição gerada com sucesso!")
	ELSE
		Return
	ENDIF
ELSE
	ALERT("Não é possivel Rejeitar o documento! Verifique seu STATUS", "A T E N Ç Ã O")
ENDIF

Return()       

//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function AtuZD3(_aSD3)
Local _aZD3 := _aSD3

DBSELECTAREA("ZD3")

	RECLOCK("ZD3",.T.)
		ZD3_FILIAL := xFilial("ZD3")
		ZD3_STATUS := _aZD3[1][1]
		ZD3_NUMSEQ := _aZD3[1][2]		
		ZD3_DTTRDV := _aZD3[1][3]
		ZD3_IDTRDV := _aZD3[1][4]
		ZD3_NMTRDV := _aZD3[1][5]
		ZD3_MSG	   := _aZD3[1][6]
		ZD3_DOC    := _aZD3[1][7]
		ZD3->(MSUNLOCK())
	ZD3->(dbCloseArea())
Return(.T.)