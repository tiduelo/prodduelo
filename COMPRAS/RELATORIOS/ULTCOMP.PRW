#include "rwmake.ch"        

User Function ULTCOMP()        

/*/
ฑฑบPrograma  ณ ULTCOMP  บ Autor ณ Sandro Ulisses     บ Data ณ     04/04/02บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime  Ultima Compra de Produtos                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especกfico para MADENORTE SA                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบArquivos  ณ SB1 -> Descricao Generica de Produtos                      บฑฑ
ฑฑบ          ณ SD1 -> Itens das Notas Fiscais de Entrada                  บฑฑ
ฑฑบ          ณ SA2 -> Cadastro de Fornecedores                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Local I := 0
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("NLASTKEY,LI,WNREL,aPerg,I,cPerg,NomeProg,M_Pag,lRet,cAlias")
SetPrvt("CABEC1,CABEC2,aMovim,cProd")

Private cProd := ""
Private nReg  := ""
Private dDataMov := CtoD("")
Private dUltData := CtoD("")         
Private cIndex   := ""
Private cNomeInd := ""
Private cChave   := ""
Private nIndex   := 0
Private tamanho := "M" 
Private limite  := 132
Private titulo  := "ULTIMA(S) COMPRA(S)" 
//          123456789012345678901234567890123456789013245678901234567890123456789012345678901234567901346579801324567890132456789013456798013245678901234657980
//                   1         2         3         4         5         6         7         8        9        10        11        12       13        14        15         
Private Cabec1  := "Codigo Nome Fornecedor                NF/Serie      Emissao    Quantid UM   Vlr.Unit     Vlr.Total Digitado Pedido  Arm  Comprador Aprovador"       
//									72, 75, 85, 95, 115, 123  

Private Cabec2  := ""
Private cDesc1  := "Este programa ira permitir consultar todos os movimentos"
Private cDesc2  := "relativos as entradas por compra dos produtos em um de- "
Private cDesc3  := "terminado tempo, conforme os parametros informados.     "
Private cString := "SB1"
Private aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
Private nLastKey:= 0
Private NomeProg:= "ULTCOMP"  
Private li      := 0
Private M_Pag   := 1
Private cPerg   := "ULTCOM    "
Private aMovim  := {}
Private aPerg   := {}
                         
Aadd(aPerg,{"Produto De         ?","C",15})
Aadd(aPerg,{"Produto Ate        ?","C",15})
Aadd(aPerg,{"Data De            ?","D",8})
Aadd(aPerg,{"Data Ate           ?","D",8})
Aadd(aPerg,{"Considera Data de  ?","N",1})
Aadd(aPerg,{"Listar Movimentos  ?","N",1})
Aadd(aPerg,{"Itens s/ Movimentos?","N",1})

dbSelectArea("SX1")

For I :=1 to 6
    If !DbSeek(cPerg+StrZero(I,2))
       RecLock("SX1",.T.)
       Replace X1_GRUPO   with cPerg
       Replace X1_ORDEM   with StrZero(I,2)
       Replace X1_PERGUNT with aPerg[I][1]
       Replace X1_VARIAVL with "mv_ch"+Str(I,1)
       Replace X1_TIPO    with aPerg[I][2]
       Replace X1_TAMANHO with aPerg[I][3]
       Replace X1_PRESEL  with 1
       Replace X1_GSC     with "G"
       Replace X1_VAR01   with "mv_par"+Strzero(I,2)
       Replace X1_DEF01   with ""
       Replace X1_DEF02   with "" 
       If I==1 .Or. I==2
          Replace X1_F3 With "SB1"
       EndIf
       If I==2
          Replace X1_CNT01 With "ZZZZZZZZZZZZZZZ"
       EndIf
       If I==3
          Replace X1_CNT01 With DTOC(dDataBase - 365)
       EndIf
       If I==4
          Replace X1_CNT01 With DTOC(dDataBase)
       EndIf
       If I==5
          Replace X1_GSC With "C"
          Replace X1_DEF01 With "Emissao  "
          Replace X1_DEF02 With "Digitacao"
          Replace X1_CNT01 With X1_DEF01
       EndIf
       If I==6
          Replace X1_GSC With "C"
          Replace X1_DEF01 With "Todos        "
          Replace X1_DEF02 With "Ultimo       "
          Replace X1_DEF03 With "Tres Ultimos "
          Replace X1_DEF04 With "Sem Entradas "
          Replace X1_CNT01 With X1_DEF01
       EndIf
       MsUnlock()                              
   Endif
   
Next I

Pergunte(cPerg,.T.)

If MV_PAR06 == 1
   Titulo := "RELACAO DE COMPRAS POR PRODUTOS"
ElseIf MV_PAR06 == 2
   Titulo := "ULTIMA COMPRA DE PRODUTO"
ElseIf MV_PAR06 == 3
   Titulo := "RELACAO DAS 3 ULTIMAS COMPRAS"
Else
   Titulo := "RELACAO DE PRODUTOS SEM NF/ENTRADA"
EndIf                                            

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)

If LastKey() == 27 .Or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .Or. nLastKey == 27
   Return
Endif

For I:=1 to 3
    aAdd(aMovim,{CtoD(""),""})
Next I         

DbSelectArea("SD1")

cNomeArq := CriaTrab(Nil,.F.)

DbSelectArea("SD1")

If MV_PAR05 == 1
   cChave:= "D1_FILIAL+D1_COD+DTOS(D1_EMISSAO)"
   cCond := "DtoS(D1_EMISSAO) <= DtoS(MV_PAR04) .And. D1_COD == SB1->B1_COD"
Else
   cChave:= "D1_FILIAL+D1_COD+DTOS(D1_DTDIGIT)"
   cCond := "DtoS(D1_DTDIGIT) <= DtoS(MV_PAR04) .And. D1_COD == SB1->B1_COD"
EndIf

IndRegua("SD1",cNomeArq,cChave,,Nil,"Selecionando Registros")

nIndex := RetIndex("SD1")

#IFNDEF TOP
	DbSetIndex(cNomeArq+OrdBagExt())      //cArquivo+OrdBagExt()
#ENDIF
DbSetOrder(nIndex+1)
//DbSetIndex(cNomeArq+OrdBagExt())
//DbSetOrder(nIndex+1)

RptStatus({|| Impressao(Cabec1,Cabec2,Titulo,Li) },"Ultima Compra")

Return

Static Function Impressao(Cabec1,Cabec2,Titulo,Li)
Local   X       := 0
Local   I := 0

Private lExiste := .F.
Private cCabec3 := ""           
Private cCond   := ""
Private Contador:= 0


DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial()+MV_PAR01,.T.)

SetRegua(RecCount())

While !EOF() .And. B1_COD <= MV_PAR02 .And. B1_FILIAL == xFilial("SB1")

      lExiste := .F.
      
      IncRegua()

      If MV_PAR06 != 4
         cCabec3 := "Codigo : "+B1_COD+" Descricao : "+SubStr(B1_DESC,1,58)
      Else
         cCabec3 := "Codigo           Descricao do Produto"
      EndIf
      
      dUltData:= CtoD("")
      nReg    := 0

      DbSelectArea("SD1")    
      DbSetOrder(nIndex+1)
      DbSeek(xFilial()+SB1->B1_COD+DtoS(MV_PAR03),.T.)
      
      While !EOF() .And. D1_COD == SB1->B1_COD 

            If D1_QUANT == 0
               DbSkip()
               Loop
            EndIf

            dDataMov := If(MV_PAR05 == 1,D1_EMISSAO,D1_DTDIGIT)

            If dDataMov < MV_PAR03
               DbSkip()
               Loop
            EndIf                    
            
            If dDataMov > MV_PAR04
               Exit
            EndIf
            
            lExiste := .T.
                        
            If MV_PAR06 == 1 
               ImprimeDetalhe()           
               Contador := Contador + 1
               DbSelectArea("SD1")
               DbSkip()
               Loop
            EndIf

            If MV_PAR06 == 2
               If dDataMov > dUltData
                  dUltData := dDataMov
                  nReg     := RecNo()
               EndIf
            EndIf

            If MV_PAR06 == 3
               For I := 3 to 1 Step -1
                   If dDataMov > aMovim[I][1]
                      If I != 1
                         For X:=2 to I
                             aMovim[X-1][1] := aMovim[X][1]
                             aMovim[X-1][2] := aMovim[X][2]
                         Next X
                      EndIf
                      aMovim[I][1]:=dDataMov
                      aMovim[I][2]:=D1_COD+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
                      Exit
                   EndIf
               Next I
            EndIf

            DbSelectArea("SD1")
            DbSkip()
      Enddo

      If MV_PAR06 == 2
         If nReg != 0
            DbGoTo(nReg)
            ImprimeDetalhe()
            Contador := Contador + 1
         EndIf
      EndIf

      If MV_PAR06 == 3
         X := 0
         For I := 1 to 3
             If !Empty(aMovim[I][2])
                DbSelectArea("SD1")
                DbSetOrder(2)
                DbSeek(xFilial("SD1")+aMovim[I][2],.T.)
                ImprimeDetalhe()
                aMovim[I][1]:=CtoD("")
                aMovim[I][2]:=""
                X := I
             EndIf
         Next I
         If X != 0
            Contador := Contador + 1
         EndIf                      
      EndIf
      
      If MV_PAR06 == 4
         If !lExiste
            ImprimeProduto()
            Contador := Contador + 1
         EndIf
      EndIf                   
      
      DbSelectArea("SB1")
      DbSkip()

EndDo

If Contador != 0
   @ Prow()+3,18 PSay "Total de Produtos processados "+Trans(Contador,"@E 99,999")
   Roda(0,"","P")
EndIf

Set Device to Screen      
//+------------------------------------------------------------------+
//ฆ Se impressao em Disco, chama Spool.                              ฆ
//+------------------------------------------------------------------+
If aReturn[5] == 1
   Set Printer To 
   dbCommitAll()
   ourspool(wnrel)
Endif

FT_PFLUSH()        

Return
Static Function ImprimeProduto()
If Empty(cProd)
   cProd := SB1->B1_COD
   Cabec1 := cCabec3
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,18)
   li := 9
EndIf
If li > 55
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,18)
   li := 9
EndIf
@ li,0 PSay SB1->B1_COD
@ li,17 PSay SB1->B1_DESC

li := li + 1

Return

Static Function ImprimeDetalhe()
cMailComp :=""     
cNomeComp :=""
cMailAp :=""     
cNomeAp :=""
InfoCp := {} 
InfoAp := {} 

If Empty(cProd)
   cProd  := SB1->B1_COD
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,18)
   li := 9
   @ li,0 PSay cCabec3
   li := li + 2
EndIf

If SB1->B1_COD != cProd
   li := li + 2
   @ li,0 PSay cCabec3
   li := li + 2
   cProd  := SB1->B1_COD
EndIf

If Li > 55
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,18)
   li := 9
   @ li,0 PSay cCabec3
   li := li + 2
EndIf             

_numPed := SD1->D1_PEDIDO
_codProd:= SD1->D1_COD
_fornece:= SD1->D1_FORNECE
DbSelectArea("SA2")
DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,.T.)
   
@ li,00  PSay SD1->D1_FORNECE
@ li,07  PSay SubStr(A2_NOME,1,30)
@ li,38  PSay SD1->D1_DOC+IF(Empty(SD1->D1_SERIE),"",""+SD1->D1_SERIE)
@ li,52  PSay DtoC(SD1->D1_EMISSAO)
@ li,61  PSay Trans(SD1->D1_QUANT,"@E 999,999.99")   
@ li,72  PSay SD1->D1_UM
@ li,75  PSay Trans(SD1->D1_VUNIT,"@E 999,999.99")
@ li,86  PSay Trans(SD1->D1_TOTAL,"@E 999,999.99")
@ li,100  PSay DtoC(SD1->D1_DTDIGIT)
@ li,109 PSay SD1->D1_PEDIDO
@ li,118 PSay SD1->D1_LOCAL 

// ######### RETORNA NOME E EMAIL DO COMPRADOR ############ GAMA #################
	_cQryC7 =""
	_cQryC7 :="SELECT C7_USER,C7_APROV,C7_NUM,D_E_L_E_T_"
	_cQryC7 +=" FROM "+RetSqlName("SC7")+ " "
	_cQryC7 +=" WHERE D_E_L_E_T_ <> '*' AND C7_NUM = '"+_numPed+"' AND RTRIM(C7_PRODUTO) = '"+Alltrim(_codProd)+"' "
	_cQryC7 := ChangeQuery ( _cQryC7 )                                                  
	_cAliasQryC7 := CriaTrab(,.F.)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQryC7), _cAliasQryC7, .F., .T.)

		// Recupera nome e email do comprador
		PswOrder(1)
		IF PswSeek((_cAliasQryC7)->C7_USER,.T.)
			aInfoCp   := PswRet(1)
			cMailComp := alltrim(aInfoCp[1,14]) //email 
			cNomeComp := aInfoCp[1,2]
		ENDIF 

	(_cAliasQryC7)->(DBCLOSEAREA()) 	
	// FIM ######### RETORNA NOME E EMAIL DO COMPRADOR ############## GAMA ###############   

	// ######### RETORNA NOME E EMAIL DO APROVADOR ############ GAMA #################             
	_cQryCR =""
	_cQryCR :="SELECT CR_NUM,CR_USER,D_E_L_E_T_"
	_cQryCR +=" FROM "+RetSqlName("SCR")+ " "
	_cQryCR +=" WHERE CR_FILIAL='"+SM0->M0_CODFIL+"' AND CR_STATUS ='03' AND CR_TIPO='PC' AND D_E_L_E_T_ <> '*' AND CR_NUM = '"+_numPed+"' "
	_cQryCR := ChangeQuery ( _cQryCR )                                                  
	_cAliasQryCR := CriaTrab(,.F.)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQryCR), _cAliasQryCR, .F., .T.)

	// Recupera nome e email do aprovador
		PswOrder(1)
		IF PswSeek((_cAliasQryCR)->CR_USER,.T.)
			aInfoAp   := PswRet(1)
			cMailAp := alltrim(aInfoAp[1,14]) //email 
			cNomeAp := aInfoAp[1,2]
		ENDIF 

	(_cAliasQryCR)->(DBCLOSEAREA()) 
	//###################################################################################  

@ li,123 PSay cNomeComp 
@ li,132 PSay cNomeAp


li:=li+1

Return
