#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Exec_SENF ºAutor  ³Microsiga           º Data ³  05/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa o Relatório                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RelatZCF()

Local cQuery := ""
Local oExcel:= FWMSEXCEL():New()
Local cTipo := "*.xml | *.xmls |"
Private cPerg  := "ZCFZCG"

	If !Pergunte(cPerg,.T.)
		Return Nil
	endif

cQuery := " " 
cQuery += " SELECT 
cQuery += "  ZCF_CLIENT +' / '+ ZCF_LOJA AS ZCF_CLIENT	"
cQuery += " , E1_NOMCLI                                 "
cQuery += " , ZCG_TITULO                                "
cQuery += " , ZCG_PARCEL                                "
cQuery += " , SUBSTRING(E1_EMISSAO,7,2)+'/'+SUBSTRING(E1_EMISSAO,5,2)+'/'+SUBSTRING(E1_EMISSAO,1,4) AS E1_EMISSAO	"
cQuery += " , SUBSTRING(E1_VENCTO,7,2)+'/'+SUBSTRING(E1_VENCTO,5,2)+'/'+SUBSTRING(E1_VENCTO,1,4) AS E1_VENCTO       "
cQuery += " , SUBSTRING(E1_VENCALT,7,2)+'/'+SUBSTRING(E1_VENCALT,5,2)+'/'+SUBSTRING(E1_VENCALT,1,4) AS E1_VENCALT   "
cQuery += " , ZCG_VALOR	"
cQuery += " , E1_SALDO  "
cQuery += " , DATEDIFF(day,E1_VENCTO,convert(varchar, GetDate(),112)) AS E1_DATRASO		"
cQuery += " , SUBSTRING(ZCF_DATA,7,2)+'/'+SUBSTRING(ZCF_DATA,5,2)+'/'+SUBSTRING(ZCF_DATA,1,4) AS ZCF_DATA 	"
cQuery += " , CASE 	"
cQuery += " 	WHEN '001' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)		"
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' )))  "
cQuery += " 	WHEN '002' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)       "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+ 	"
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' )))          "
cQuery += " 	WHEN '003' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)               "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' )))          "
cQuery += " 	WHEN '004' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)	            "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' )))          "
cQuery += " 	WHEN '005' = (SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)             "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '005' )))          "
cQuery += " 	WHEN '006' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)               "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '005' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '006' )))          "
cQuery += " 	WHEN '007' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)               "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '005' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '006' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '007' )))          "
cQuery += " 	WHEN '008' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)               "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '005' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '006' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '007' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '008' )))          "
cQuery += " 	WHEN '009' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)               "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '005' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '006' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '007' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '008' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '009' )))          "
cQuery += " 	WHEN '010' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)               "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '005' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '006' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '007' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '008' ))) +' '+	"
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '009' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '010' )))          "
cQuery += " 	WHEN '011' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)               "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '005' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '006' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '007' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '008' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '009' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '010' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '011' )))          "
cQuery += " 	WHEN '012' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)               "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '005' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '006' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '007' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '008' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '009' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '010' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '011' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '012' )))          "
cQuery += " 	WHEN '013' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)               "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '005' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '006' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '007' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '008' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '009' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '010' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '011' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '012' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '013' )))          "
cQuery += " 	WHEN '014' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)               "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '005' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '006' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '007' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '008' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '009' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '010' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '011' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '012' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '013' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '014' )))          "
cQuery += " 	WHEN '015' = (SELECT TOP 1 YP_SEQ FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS ORDER BY YP_CHAVE, YP_SEQ DESC)               "
cQuery += " 			THEN RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '001' ))) +' '+    "
cQuery += " 		         RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '002' ))) +' '+    "
cQuery += " 			     RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '003' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '004' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '005' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '006' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '007' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '008' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '009' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '010' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '011' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '012' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '013' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '014' ))) +' '+    "
cQuery += " 				 RTRIM(LTRIM((SELECT TOP 1 YP_TEXTO FROM SYP060 WHERE D_E_L_E_T_ = '' AND YP_CHAVE = ZCF_CODOBS AND YP_SEQ = '015' )))			"
cQuery += " END AS YP_TEXTO	"
cQuery += " , CASE          "
cQuery += " 	WHEN ZCF_REGCOB = 'A' "
cQuery += " 		THEN 'ALTO'       "
cQuery += " 	WHEN ZCF_REGCOB = 'B' "
cQuery += " 		THEN 'MEDIO'      "
cQuery += " 	WHEN ZCF_REGCOB = 'C' "
cQuery += " 		THEN 'BAIXO'      "
cQuery += " 	WHEN ZCF_REGCOB = 'D' "
cQuery += " 		THEN 'CRITICO'    "
cQuery += " 	ELSE ''               "
cQuery += " END AS ZCF_REGCOB         "
cQuery += " FROM "+RetSQLName("ZCF")+" ZCF "
cQuery += " INNER JOIN "+RetSQLName("ZCG")+" ZCG "
cQuery += " ON  ZCG_CODIGO = ZCF_CODIGO "
cQuery += " AND ZCG_FILIAL = ZCF_FILIAL "
cQuery += " AND ZCG.D_E_L_E_T_ = ''     "
cQuery += " INNER JOIN "+RetSQLName("SE1")+" SE1 "
cQuery += " ON  E1_NUM = ZCG_TITULO      "
cQuery += " AND E1_PREFIXO = ZCG_PREFIX  "
cQuery += " AND E1_PARCELA = ZCG_PARCEL  "
cQuery += " AND E1_TIPO   = ZCG_TIPO     "
cQuery += " AND E1_CLIENTE = ZCF_CLIENT  "
cQuery += " AND E1_LOJA = ZCF_LOJA       "
cQuery += " AND SE1.D_E_L_E_T_ = ''      "
cQuery += " WHERE ZCF.D_E_L_E_T_ = ''    "
cQuery += " AND ZCG_TITULO BETWEEN '"+Alltrim(MV_PAR01)+"' AND '"+Alltrim(MV_PAR02)+"' "
cQuery += " AND ZCF_CLIENT BETWEEN '"+Alltrim(MV_PAR03)+"' AND '"+Alltrim(MV_PAR04)+"' "
cQuery += " AND ZCF_LOJA  BETWEEN  '"+Alltrim(MV_PAR05)+"' AND '"+Alltrim(MV_PAR06)+"' "
cQuery += " AND E1_EMISSAO BETWEEN '"+DtoS(MV_PAR07)+"' AND '"+DtoS(MV_PAR08)+"' "
cQuery += " AND E1_VENCTO BETWEEN  '"+DtoS(MV_PAR09)+"' AND '"+DtoS(MV_PAR10)+"' "
cQuery += " AND ZCF_DATA  BETWEEN  '"+DtoS(MV_PAR11)+"' AND '"+DtoS(MV_PAR12)+"' "
cQuery += " ORDER BY 1,3,4	"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'TMP', .T., .T.)},"Selecionado registros")

DbSelectArea("TMP")
DBGoTop()

cWorkSheet := "Relatório de Cobrança"
cTable := "Dados"

//Nome da Worksheet
oExcel:AddworkSheet(cWorkSheet)
//Nome da Tabela
oExcel:AddTable (cWorkSheet,cTable)

//Nome das Colunas
oExcel:AddColumn(cWorkSheet, cTable, "COD.CLIENTE"		  ,1,1) 
oExcel:AddColumn(cWorkSheet, cTable, "NOME.CLIENTE"		  ,1,1)
oExcel:AddColumn(cWorkSheet, cTable, "NUM.NF"	  ,1,1)
oExcel:AddColumn(cWorkSheet, cTable, "PARCELA.NF"	 	  ,1,1)
oExcel:AddColumn(cWorkSheet, cTable, "EMISSAO",1,1)
oExcel:AddColumn(cWorkSheet, cTable, "VENCIMENTO"             ,1,1)
oExcel:AddColumn(cWorkSheet, cTable, "VENCTO.ALTERADO"	  ,1,1)
oExcel:AddColumn(cWorkSheet, cTable, "VALOR"	  ,1,2)
oExcel:AddColumn(cWorkSheet, cTable, "LIQ.RECEBER" ,1,2)
oExcel:AddColumn(cWorkSheet, cTable, "DIAS.ATRASO"	  ,1,1)
oExcel:AddColumn(cWorkSheet, cTable, "COBRANÇA"	  ,1,1)
oExcel:AddColumn(cWorkSheet, cTable, "HISTORICO.COB"	  ,1,1)
oExcel:AddColumn(cWorkSheet, cTable, "PROB.RECUPERAÇÃO"	  ,1,1)



Do While !EOF()
	INCPROC("Aguarde... ")

	oExcel:AddRow(cWorkSheet,cTable,{	TMP->ZCF_CLIENT,;
										TMP->E1_NOMCLI,;
										TMP->ZCG_TITULO,;
										TMP->ZCG_PARCEL,;
										TMP->E1_EMISSAO,;
										TMP->E1_VENCTO,;
										TMP->E1_VENCALT,;
										TMP->ZCG_VALOR,;
										TMP->E1_SALDO,;
										TMP->E1_DATRASO,;
										TMP->ZCF_DATA,;
										TMP->YP_TEXTO,;
										TMP->ZCF_REGCOB})	
	DBSkip()
EndDo
TMP->(DBCloseArea())


Arquivo := cGetFile(cTipo,OemToAnsi("Selecione o Diretorio do arquivo de atualização"),,'C:\ABCDE',.T.)
Arquivo := Alltrim(Arquivo)

If RIGHT(Arquivo,4) <> ".xml" .Or. RIGHT(Arquivo,4) <> ".XML" .Or. RIGHT(Arquivo,4) <> ".Xml"
Arquivo := Alltrim(Arquivo+".xml")
EndIf


oExcel:Activate()
//oExcel:GetXMLFile("C:\RELATO\Relatorio SENF.xml")
oExcel:GetXMLFile(Arquivo)
MSGINFO("Planilha gravada Sucesso: "+Arquivo)

	
return