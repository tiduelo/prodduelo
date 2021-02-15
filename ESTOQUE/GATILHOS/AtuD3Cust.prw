#INCLUDE "MATR910k.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR910  ³ Autor ³ Nereu Humberto Junior ³ Data ³ 11.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Kardex fisico - financeiro                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AtuD3Cust()
                  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declarando as Variaveis                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cQry := " "
Local nCustAlmox := 0    
Local aCustAlmox := {}
Private nLastKey := 0
Private cPerg    := "ATUD3CST"


If !Pergunte(cPerg, .T. )
	Return nil
Endif

If nLastKey==27
	Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processo - Realizando Filtro                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQry := " "
cQry += " 	SELECT
cQry += " 		D3_FILIAL	"
cQry += " 		,D3_DOC		"
cQry += " 		,D3_COD		"
cQry += " 		,D3_LOCAL	"
cQry += " 		,D3_CUSTO1	"
cQry += " 		,D3_EMISSAO	"
cQry += " 		,B1_LOCPAD	"
cQry += " 		,D3_QUANT	"      
cQry += " 		,ISNULL((SELECT TOP 1 B9_CM1 FROM SB9040 WHERE D_E_L_E_T_ = '' AND B9_COD = D3_COD AND B9_CM1 > 0 AND B9_LOCAL = B1_LOCPAD AND B9_FILIAL = '01' AND B9_DATA = CONVERT(VARCHAR(10), dateadd(dd,-day(D3_EMISSAO),D3_EMISSAO) , 112) ORDER BY B9_DATA DESC),0) B9_CM1	"
cQry += " 		,ISNULL((SELECT TOP 1 B2_CM1 FROM SB2040 WHERE D_E_L_E_T_ = '' AND B2_COD = D3_COD AND B2_CM1 > 0 AND B2_LOCAL = D3_LOCAL AND B2_FILIAL = '01' ),0) B2_CM1	"
cQry += " 	FROM "+ RETSQLNAME("SD3")+" D3 "
cQry += " 	INNER JOIN "+ RETSQLNAME("SB1")+" B1 "
cQry += " 		ON B1_COD = D3_COD	"
cQry += " 		AND B1.D_E_L_E_T_ = ''	"
cQry += " 		AND B1_FILIAL = '"+xFilial("SB1")  +"' "
cQry += " 	WHERE D3.D_E_L_E_T_ = ''	"
cQry += " 		AND D3_FILIAL = '"+xFilial("SD3")  +"' "
cQry += " 		AND D3_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) + "' AND '"+ DTOS(MV_PAR02) + "' "
cQry += " 		AND D3_COD     BETWEEN '"+ ALLTRIM(MV_PAR03) + "' AND '"+ ALLTRIM(MV_PAR04) + "' "
cQry += " 		AND D3_LOCAL IN ('11','12')	"
//cQry += " 		AND D3_CUSTO1  <=  0        "
cQry += " 		AND D3_ESTORNO <> 'S'       "
cQry := ChangeQuery(cQry)
MsgRun("Selecionando Movimentação...","",{|| dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TOC" , .T. , .F.) })


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processo - Atualizando Registro                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DBSelectArea("TOC")
TOC->(DbGoTop())
While !TOC->(Eof())
	
	dbSelectArea("SD3")
	dbSetOrder(2)
	dbSeek(xFilial("SD3")+TOC->D3_DOC+TOC->D3_COD)
	While !Eof() .And. D3_FILIAL+D3_DOC+D3_COD == xFilial("SD3")+TOC->D3_DOC+TOC->D3_COD
		//If D3_CUSTO1 <= 0
			aCustAlmox := CalcEst(TOC->D3_COD,TOC->B1_LOCPAD,StoD(TOC->D3_EMISSAO)+1)

			If aCustAlmox[1]==0
				nCustAlmox := ((aCustAlmox[2]/1)*TOC->D3_QUANT)
			Else
				nCustAlmox := ((aCustAlmox[2]/aCustAlmox[1])*TOC->D3_QUANT)
			EndIf						
			
			If TOC->B9_CM1 > 0				
				nCustAlmox := TOC->B9_CM1*TOC->D3_QUANT							
			ElseIf TOC->B2_CM1 > 0
				nCustAlmox := TOC->B2_CM1*TOC->D3_QUANT 				
			ElseIf nCustAlmox > 0
				nCustAlmox := nCustAlmox			
			Else
				nCustAlmox := 0			
			EndIf
							
			RECLOCK("SD3",.F.)
			    	D3_CUSTO1  := nCustAlmox
			MSUNLOCK()     
		//EndIF
	dbSkip()
	End
	SD3->( DBCloseArea())	

	TOC->(DbSkip())
EndDo
TOC->( DBCloseArea())

Return()