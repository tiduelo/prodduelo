#include "Rwmake.ch"
#include "Protheus.ch"                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTPC01   ³Autor  ³Henio Brasil        ³ Data ³ 02/10/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do valor total da Producao para os PAs gerados na   º±±
±±º          ³Fabrica                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Vinhos Duelo Ltda                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ESTPC01(cTipPrd,dMesCal,dAnoCal) 		// cAlmox) 

Local nVlrPrdPa := 0.0 
Local nVlrEstPa := 0.0 
Local cQryPrd	:= "" 
Local cQryEst	:= ""  
Local dPeriod	:= ""                         
Local aAreaPrd	:= GetArea() 
Local cAlsPrd1	:= "QryPrd"	
Local cAlsPrd2	:= "QryEst"	            
Local cAnoCal 	:= Alltrim(Str(dAnoCal))        
Local cAnoPer	:= Left(Str(Year(dDataBase),4),2)
                                           
Default cTipPrd := "PA" 
Default dMesCal := Str(Month(dData),2)      
// Default cAlmox 	:= '01' 

// Tratamento do Ano de Vigencia: 
dMesCal 	:= If(ValType(dMesCal)=="N", Strzero(dMesCal,2) , dMesCal) 
dAnoCal 	:= If(Len(cAnoCal)==2, cAnoPer+cAnoCal, dAnoCal) 
dPeriod		:= dAnoCal+dMesCal
// Valida qdo o for Ano Novo: 
If Year(dDataBase) > Val(dAnoCal) 
   dAnoCal := Str(Year(dDataBase),4) 
Endif 
DbSelectArea("SD3")
DbSetOrder(1)  

/*  
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Monta Consulta para gerar valor acumuado de Producao  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
If Select("QryPrd") > 0 
	QryPrd->(DbCloseArea()) 
Endif 	                                                                                          
// cQryPrd := "SELECT D3_FILIAL, D3_CF, D3_COD, SUM(D3_QUANT) AS QTDPRD FROM "+RetSqlName("SD3")+" "
cQryPrd := "SELECT D3_FILIAL, D3_CF, B1_TIPO, SUM(D3_QUANT) AS QTDPRD FROM "+RetSqlName("SD3")+" D3 "
cQryPrd += " INNER	JOIN "+RetSqlName("SB1")+" B1 ON (B1.B1_FILIAL = D3.D3_FILIAL "
cQryPrd += "		AND B1.B1_COD = D3.D3_COD AND B1.B1_LOCPAD = D3.D3_LOCAL) " 
cQryPrd += " WHERE	D3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQryPrd += "	AND B1.B1_FILIAL = '"+xFilial("SB1")+"' " 
cQryPrd += "	AND LEFT(D3.D3_EMISSAO,6) = '"+dPeriod+"' "  
cQryPrd += "	AND B1.B1_TIPO = '"+cTipPrd+"' " 
cQryPrd += "	AND D3.D3_LOCAL IN ('01','02') " 
cQryPrd += "	AND D3.D3_CF   = 'PR0' " 
cQryPrd += "	AND D3.D_E_L_E_T_ = ' ' "
cQryPrd += "	AND B1.D_E_L_E_T_ = ' ' " 
cQryPrd += " GROUP	BY D3_FILIAL, D3_CF, B1_TIPO  " 	

cQryPrd := ChangeQuery(cQryPrd)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryPrd),cAlsPrd1,.T.,.T.)
nVlrPrdPa:= If(!Eof(), (cAlsPrd1)->QTDPRD, 0) 

/*  
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Monta Consulta para gerar valor acumuado de Estornos  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
If Select("QryEst") > 0 
	QryEst->(DbCloseArea()) 
Endif 	                                                                                          
// cQryEst := "SELECT D3_FILIAL, D3_CF, D3_COD, SUM(D3_QUANT) AS QTDPRD FROM "+RetSqlName("SD3")+" "
cQryEst := "SELECT D3_FILIAL, D3_CF, B1_TIPO, SUM(D3_QUANT) AS QTDPRD FROM "+RetSqlName("SD3")+" D3 "
cQryEst += " INNER	JOIN "+RetSqlName("SB1")+" B1 ON (B1.B1_FILIAL = D3.D3_FILIAL "
cQryEst += "		AND B1.B1_COD = D3.D3_COD AND B1.B1_LOCPAD = D3.D3_LOCAL) " 
cQryEst += " WHERE	D3.D3_FILIAL = '"+xFilial("SD3")+"' " 
cQryEst += "	AND B1.B1_FILIAL = '"+xFilial("SB1")+"' " 
cQryEst += "	AND LEFT(D3.D3_EMISSAO,6) = '"+dPeriod+"' "  
cQryEst += "	AND B1.B1_TIPO = '"+cTipPrd+"' " 
cQryEst += "	AND D3.D3_LOCAL IN ('01','02') " 
cQryEst += "	AND D3.D3_CF   = 'ER0' " 
cQryEst += "	AND D3.D_E_L_E_T_ = ' ' "
cQryEst += "	AND B1.D_E_L_E_T_ = ' ' " 
cQryEst += " GROUP	BY D3_FILIAL, D3_CF, B1_TIPO  " 	

cQryEst := ChangeQuery(cQryEst)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryEst),cAlsPrd2,.T.,.T.)
nVlrEstPa:= If(!Eof(), (cAlsPrd2)->QTDPRD, 0) 

RestArea(aAreaPrd) 
Return(nVlrPrdPa-nVlrEstPa) 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Pc01Ctb1GG³Autor  ³Henio Brasil        ³ Data ³ 02/10/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Busca valores em tabelas Contabeis que representam Gastos   º±±
±±º          ³Gerais de Fabrica.                                          º±±
±±º          ³U_Pc01CtbGGF("4410204" ,"4410205" ,Ctod("28/08/12"))        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Vinhos Duelo Ltda                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Pc01Ctb1GG(cGrpIni,cGrpFim,dData) 

// Analisa movimentos para contas do grupo: 4410204 e 4410205                 
Local nVlrGgf 	:= 0.0                     
Local dDataMov	:= Ctod(dData) 
Local dLstData	:= LastDay(dDataMov,0)            
Local cMoeda 	:= '01' 
Local cTipSal	:= '1'
Local nHowSald	:= 3		// 1 
Local nLenCta	:= 0 
Local dDataIni	:= Ctod("01/"+Strzero(Month(dDataMov),2)+"/"+Right(Str(Year(dDataMov),4),2) ) 


// cConta	:= '441020401' 
DbSelectArea("CT1") 
DbSetOrder(1) 
If DbSeek(xFilial("CT1")+cGrpIni) 
	nLenCta	:= Len(cGrpIni) 
	While Left(CT1_CONTA,nLenCta) == cGrpIni  
			cCtaCtb := CT1_CONTA 
			If CT1_CLASSE = '1'   
			   CT1->(DbSkip()) 
			   Loop 
			Endif 
			// Pega apenas saldos das contas: 
			// nVlrGGF	+= SaldoConta(cCtaCtb,dLstData,cMoeda,cTipSal,nHowSald)	
			nVlrGGF	+= MovConta(cCtaCtb,dDataIni,dLstData,cMoeda,cTipSal,nHowSald)	
			CT1->(DbSkip()) 
	Enddo 
Endif 	
// Sumariza com o 2o grupo 
// DbSelectArea("CT1") 
// DbSetOrder(1) 
If DbSeek(xFilial("CT1")+cGrpFim) 
	nLenCta	:= Len(cGrpFim) 
	While Left(CT1_CONTA,nLenCta) == cGrpFim  
			cCtaCtb := CT1_CONTA 
			If CT1_CLASSE = '1'   
			   CT1->(DbSkip()) 
			   Loop 
			Endif 
			// nVlrGGF	+= SaldoConta(cCtaCtb,dLstData,cMoeda,cTipSal,nHowSald)			
			nVlrGGF	+= MovConta(cCtaCtb,dDataIni,dLstData,cMoeda,cTipSal,nHowSald)				
			CT1->(DbSkip()) 
	Enddo 
Endif 	

Return(nVlrGgf*-1)  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Pc01Ctb2GG³Autor  ³Henio Brasil        ³ Data ³ 03/10/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Busca valores em tabelas Contabeis que representam Gastos   º±±
±±º          ³Gerais de Fabrica.                                          º±±
±±º          ³U_Pc01CtbGGF("4410204" ,"4410205" ,Ctod("28/08/12"))        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Vinhos Duelo Ltda                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Pc01Ctb2GG(cGrpCtb,dData) 

// Analisa movimentos para contas do grupo: 4410204 e 4410205                 
Local nVlrGgf 	:= 0.0                     
Local dDataMov	:= Ctod(dData) 
Local dLstData	:= LastDay(dDataMov,0)            
Local cMoeda 	:= '01' 
Local cTipSal	:= '1'
Local nHowSald	:= 3		// 1 
Local nLenCta	:= 0 
Local dDataIni	:= Ctod("01/"+Strzero(Month(dDataMov),2)+"/"+Right(Str(Year(dDataMov),4),2) ) 

DbSelectArea("CT1") 
DbSetOrder(1) 
If DbSeek(xFilial("CT1")+cGrpCtb) 
	nLenCta	:= Len(cGrpCtb) 
	While Left(CT1_CONTA,nLenCta) == cGrpCtb 
			cCtaCtb := CT1_CONTA 
			If CT1_CLASSE = '1' .Or. (CT1_CLASSE = '2' .And. CT1_BLOQ = '1') 
			   CT1->(DbSkip()) 
			   Loop 
			Endif 
			// Pega apenas saldos das contas: 
			// nVlrGGF	+= SaldoConta(cCtaCtb,dLstData,cMoeda,cTipSal,nHowSald)	
			nVlrGGF	+= MovConta(cCtaCtb,dDataIni,dLstData,cMoeda,cTipSal,nHowSald)	
			CT1->(DbSkip()) 
	Enddo 
Endif 	
Return(nVlrGgf*-1) 