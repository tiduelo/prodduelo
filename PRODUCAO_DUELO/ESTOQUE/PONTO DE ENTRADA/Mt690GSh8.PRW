#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออออัออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณMT690GSH8 ณAutor  ณ                      ณ Data ณ10/10/2012 บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออออฯออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para tratar correcoes na programacao da    บฑฑ
ฑฑบ          ณCarga Maquina                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณVinhos Duelo Ltda                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MT690GSH8()
                                       
/* 
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณDeclaracao de Variaveis                                              ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/  
Local cTimeSet	:= 0 
Local cSetupSG2:= 0 
Local aEnvCarg	:= GetArea()             
Local cSetupSH8:= SH8->H8_SETUP 
Local cRoteiro := SH8->H8_ROTEIRO
Local cOperaca := SH8->H8_OPER  
Local nPrecisao:= 60 / GetMV("MV_PRECISA")  

aSetMaq	:= If(Type("aSetMaq")=="U", {}, aSetMaq)  

/* 
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณTrava a condicao de mudar o conceito de Tipo de Hora                 ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/  
If GetMV("MV_TPHR")<>"C"    
	MsgAlert("MT690GSH8 - O parametro MV_TPHR nใo estแ configurado para Centesimal, por isso as regras de manuten็ใo na Carga Maquina serใo desativadas!") 
	Return 
Endif 
If CARGA->H8_SETUP == 0 
	nMaquina := Len(aSetMaq) 
	If nMaquina > 0        
		cSetupSH8:= aSetMaq[nMaquina][7] 
		cTimeSet	:= (cSetupSH8 * nPrecisao)/60   
		cHoraFim := Val(Left(SH8->H8_HRFIM,2)) 
		cMinuFim	:= Right(SH8->H8_HRFIM,2) 
		cTimeNew	:= StrZero(cHoraFim + cTimeSet,2)+":"+cMinuFim 
		If aSetMaq[nMaquina][2]==SH8->H8_RECURSO 
			CARGA->H8_SETUP:= cSetupSH8 
			CARGA->H8_HRFIM:= cTimeNew  
			SH8->H8_SETUP	:= cSetupSH8   
			SH8->H8_HRFIM	:= cTimeNew  
		 Else                       
		 	cProduto := SB1->B1_COD 
		   DbSelectArea("SG2") 
		   DbSetorder(1)		// Produto + Roteiro + Operacao 
		   If DbSeek(xFilial("SG2")+cProduto+cRoteiro+cOperaca)     
		   	lSetupInt:= Int(SG2->G2_SETUP) >= 1
		   	cSetupSG2:= Tempo2Bit(SG2->G2_SETUP) 
				cSetupDec:= (cSetupSG2 * nPrecisao) 
				If lSetupInt 
					cTimeNew	:= StrZero(cHoraFim + cSetupSG2,2)+":"+cMinuFim
				 Else                                             
					nMinutos	:= ConverTime(Val(cMinuFim),cSetupDec) 
				 	cMinuFim := If(nMinutos == 0, "00", Strzero(nMinutos,2))
				 	cHoraFim	:= If(nMinutos == 0, cHoraFim+1, cHoraFim)
					cTimeNew	:= StrZero(cHoraFim,2)+":"+cMinuFim
      		Endif 
				CARGA->H8_SETUP:= cSetupSH8 
				CARGA->H8_HRFIM:= cTimeNew  
				SH8->H8_SETUP	:= cSetupSH8   
				SH8->H8_HRFIM	:= cTimeNew  
		   Endif 		   
			RestArea(aEnvCarg)
		Endif 	
	Endif 
Endif 
			   // 1			   2					 3					 4					5				  6				  7 
Aadd(aSetMaq, {SH8->H8_OP,SH8->H8_RECURSO,SH8->H8_DTINI,SH8->H8_HRINI,SH8->H8_DTFIM,SH8->H8_HRFIM,SH8->H8_SETUP}) 
Return()                                    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออออัออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณConverTimeณAutor  ณHenio Brasil          ณ Data ณ11/10/2012 บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออออฯออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para tratar correcoes na programacao da    บฑฑ
ฑฑบ          ณCarga Maquina                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณVinhos Duelo Ltda                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ConverTime(nTime1,nTime2) 
                     
Local nValor 

nResult := nTime1+nTime2 
If nResult >= 60 
	nResto := nResult - 60 
	nValor := If(nResto > 1, 1 + (nResto/100), 0) 
 Else 
 	nValor := nResult 
Endif 
Return(nValor) 