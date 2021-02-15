#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FolxFinº Autor ³ AP6 IDE            º Data ³  27/02/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function HtFolxFin(_cSE2Prx, _cSE2Num, _cSE2Tip, _cSE2Forn, _cSECLoj, _cSE2Fil, _dSE2Ems)
//U_HtFolxFin(SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_TIPO, SE2->E2_FORNECE, SE2->E2_LOJA,SE2->E2_FILIAL, SE2->E2_EMISSAO )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _cNumTit := _cSE2Num
Local _cPrxTit := _cSE2Prx
Local _cTipTit := _cSE2Tip
Local _cFrcTit := _cSE2Forn
Local _cLjFTit := _cSECLoj
Local _cFiltit := _cSE2Fil  
Local _dDtEmis := _dSE2Ems
Local _cCodTit := ""
Local _cHstCtb := ""
Local _cCtbRC0 := ""
Local _cDtTit  := ""
local _aCodRC0 := {}

										   //RC1_FILIAL,   RC1_FILTIT, RC1_PREFIX, RC1_NUMTIT, RC1_TIPO, RC1_FORNEC
_cCodTit := GetAdvFVal("RC1", "RC1_CODTIT",xFilial("RC1") + _cFiltit + _cPrxTit + _cNumTit + _cTipTit + _cFrcTit,2)

_cDtTit := SubStr(DtoC(_dDtEmis),4)

 
If _cCodTit == "001"    // LIQUIDO DA FOLHA  
	_cHstCtb := "PGTO.SALARIO "+Alltrim(_cDtTit)+" "
ElseIf _cCodTit == "002"// LIQUIDO PRO-LABORE            
	_cHstCtb := "PGTO.PRO-LABORE  "+Alltrim(_cDtTit)+" "
ElseIf _cCodTit == "003"// LIQUIDO RESCISAO              
	_cHstCtb := "PGTO.RESCISAO"
ElseIf _cCodTit == "004"// LIQUIDO FERIAS                
	_cHstCtb := "PGTO.FERIAS"
ElseIf _cCodTit == "005"// PENSAO ALIMENTICIA            
	_cHstCtb := "PGTO.PENSAO ALIMENTICIA"
ElseIf _cCodTit == "006"// IRRF - MENSAL DA FOLHA        
	_cHstCtb := "PGTO.IRRF ASSALARIADO"
ElseIf _cCodTit == "007"// INSS - MENSAL DA FOLHA        
	_cHstCtb := "PGTO.INSS-GFIP "+Alltrim(_cDtTit)+" "
ElseIf _cCodTit == "008"// FGTS - MENSAL DA FOLHA        
	_cHstCtb :=  "PGTO.FGTS -SEFIP "+Alltrim(_cDtTit)+" "
ElseIf _cCodTit == "009"// MENSALIDADE SINDICAL          
	_cHstCtb :=  "PGTO.SINDICATO "+Alltrim(_cDtTit)+" "
Else
	_cHstCtb := "PGTO. NF. "+SE2->E2_NUM+"  "+SA2->A2_NREDUZ 
EndIf

/*
"	L IQUIDO DA FOLHA -  PGTO.SALARIO (MÊS DE REFERENCIA: 01/2017 )          
"	LIQUIDO PRO-LABORE     PGTO.PRO-LABORE   (MÊS DE REFERENCIA: 01/2017 )          
   
"	LIQUIDO RESCISAO-  PGTO.RESCISAO   
"	LIQUIDO FÉRIAS-   PGTO.FERIAS        
"	PENSAO ALIMENTICIA -PGTO.PENSAO ALIMENTICIA           
"	IRRF - MENSAL DA FOLHA  -PGTO.IRRF ASSALARIADO      
"	INSS - MENSAL DA FOLHA    -PGTO.INSS-GFIP  (MÊS DE REFERENCIA: 01/2017 )           
"	FGTS - MENSAL DA FOLHA  -PGTO.FGTS -SEFIP(MÊS DE REFERENCIA: 01/2017 )               
"	MENSALIDADE SINDICAL   -PGTO.SINDICATO (MÊS DE REFERENCIA: 01/2017 )                

*/

Return(_cHstCtb)