#INCLUDE "rwmake.ch"  

User Function DUE012A()

/*
+----------------------------------------------------------------------------+
| Programa  : DUE012A  | Autor : Anderson Luis Barbosa     | Data: 20.11.01  |
+----------------------------------------------------------------------------+
| Descricao : Exportador de Arquivos de integracao entre Filiais             |
+----------------------------------------------------------------------------+
| Uso       : Generico                                                       |
+----------------------------------------------------------------------------+
| Obs.      :                                                                |
+----------------------------------------------------------------------------+
*/
                         
cNomeArq := ''
aEstru   := {}          
cPerg    := "DUE012    " 

Pergunte(cPerg,.F.)

@ 096, 042  To  300, 400 Dialog oDlg1 Title "Integracao entre Filiais - Exportacao de Dados"

@ 020, 030  Say "Esta rotina ira exportar os dados para realizacao"
@ 030, 030  Say "da Integracao entre Filiais dos arquivos definidos"
@ 040, 030  Say "nas Configuracoes de Integracao."

@ 075, 080 BmpButton Type 05 Action MontaSX1()
@ 075, 110 BmpButton Type 01 Action Processa({|lEnd| Gerar(@lEnd)},"Gerando Arquivos...",OemToAnsi(""),.T.)        
@ 075, 140 BmpButton Type 02 Action Close(oDlg1)

Activate Dialog oDlg1 Centered

Return Nil

//------------------------------------------------------------------------------------//
/*								Monta Parametros de Selecao						     */

Static Function Gerar()
                 
Close(oDlg1)

dbSelectArea("SZN")
SZN->(dbSetOrder(1))
SZN->(dbGoTop())

While SZN->(!EOF())
         
   If SZN->ZN_ATIVO == "N"
      SZN->(dbSkip())
      Loop   
   EndIf      
            
   cArq := "\SIGAINT01\" + SZN->ZN_ALIAS + GetDbExtension()
   
   If File(cArq)   			// Elimina os Arquivos existentes no diretorio
	  fErase(cArq)
   EndIf    
                        
   CriaWF(SZN->ZN_ALIAS)  	// Funcao para criacao do Arquivo de Trabalho baseado no SX3
   GeraWF(SZN->ZN_ALIAS)  	// Funcao para gravacao do Arquivo de Trabalho 
   uExport(SZN->ZN_ALIAS)   	// Funcao para exportacao do Arquivo
                  
   cNomeArq := "\SIGAADV01\" + cNomeArq + GetDbExtension()
   
   If File(cNomeArq)
	  fErase(cNomeArq)
   EndIf    
   
   SZN->(dbSkip())                                                               

EndDo       

MsgBox('Exportacao de dados finalizada com sucesso!','Aviso','INFO')

Return                       

//------------------------------------------------------------------------------------//
/*								Exporta Arquivos 									  */

Static Function uExport(cAlias)                                                          
                       
    cArq := "\SIGAINT01\" + cAlias + GetDbExtension()

	Set Century On
	Select TRBEXP
	Copy To &cArq //SDF //Delimited

Return

//------------------------------------------------------------------------------------//
/*						Gera Arquivo de Trabalho com dados selecionados				  */

Static Function GeraWF(cAlias)                                                       

dbSelectArea(cAlias)

cIndice := 1

If Val(SZN->ZN_INDICE) > 0
   
   cIndice := Val(SZN->ZN_INDICE)

EndIf

(cAlias)->(dbSetOrder(cIndice))
(cAlias)->(dbGoTop())       

If Val(SZN->ZN_INDICE) > 0

   (cAlias)->(dbSeek(xFilial(cAlias) + DTOS(mv_par01),.T.))
     
EndIf

cAlias1 := 'TRBEXP'  

(cAlias)->(ProcRegua(RecCount()))              

FlgExit := .F.

While (cAlias)->(!EOF()) .And. (FlgExit == .F.)            
                                  
    IncProc("Gerando arquivo do Alias: " + cAlias + "... ")
    
    If (Val(SZN->ZN_INDICE) > 0)
       
       If (&((cAlias)->(SZN->ZN_FILTRO)) > mv_par02) 
  
          FlgExit := .T.
          (cAlias)->(dbSkip())
          Loop       

       EndIf
    
    EndIf

//------------------------------------------------------------------------------------//
/*							Filtragens de Registros									  */
                              
	If Empty(SZN->ZN_ALIASFI) .And. (!Empty(SZN->ZN_FILTRO)) // Filtro na propria Tabela
                              
       If (&((cAlias)->(SZN->ZN_FILTRO)) < mv_par01) .Or. (&((cAlias)->(SZN->ZN_FILTRO)) > mv_par02)
          (cAlias)->(dbSkip())
          Loop       
       EndIf
		
	EndIf
	
	If !Empty(SZN->ZN_ALIASFI) .And. (!Empty(SZN->ZN_FILTRO))  // Filtro em Tabela Estrangeira
	                  
	   cAlias3 := SZN->ZN_ALIASFI
   
	   dbSelectArea(cAlias3)
	   (cAlias3)->(dbSetOrder(Val(SZN->ZN_INDFILT)))
	   (cAlias3)->(dbSeek(&(SZN->ZN_CHFILTR),.F.))		
	                                        
       If (&((cAlias3)->(SZN->ZN_FILTRO)) < mv_par01) .Or. (&((cAlias3)->(SZN->ZN_FILTRO)) > mv_par02)
          (cAlias)->(dbSkip())
          Loop       
       EndIf	   
	
	EndIf
   	        
//----------------------------------------------------------------------------------------------
   	
   	dbSelectArea("SX3")
	SX3->(dbSeek(cAlias))

    RecLock(cAlias1,.T.)
    
	While SX3->(!EOF()) .And. (SX3->X3_ARQUIVO == cAlias)

/*    
	If Substr(SX3->X3_CAMPO,4,6) # "FILIAL"
	
    	If (!X3USO(SX3->X3_USADO) .Or. (SX3->X3_CONTEXT == 'V'))
		   SX3->(dbSkip())
           Loop        
	    EndIf
	EndIf

*/

	If Substr(SX3->X3_CAMPO,4,6) # "FILIAL"
	
    	If (SX3->X3_CONTEXT == 'V')
		   SX3->(dbSkip())
           Loop        
	    EndIf
	    
	EndIf

   //	    IncProc("Gerando arquivo do Alias: " + cAlias + "... ")
   		
    	&((cAlias1)->(SX3->X3_CAMPO)) := ((cAlias)->&(SX3->X3_CAMPO))
    		
		SX3->(dbSkip())                                                          
	
  	EndDo 

    MsUnLock(cAlias1)	
  
	(cAlias)->(dbSkip())            

EndDo
   
Return


//------------------------------------------------------------------------------------//
/*								Cria Arquivo de Trabalho da Tabela				     */

Static Function CriaWF(cAlias)

aEstru := {}

dbSelectArea("SX3")
SX3->(dbSeek(cAlias))

While SX3->(!EOF()) .And. (SX3->X3_ARQUIVO == cAlias)
         
/*
	If Substr(SX3->X3_CAMPO,4,6) # "FILIAL"
	
    	If (!X3USO(SX3->X3_USADO) .Or. (SX3->X3_CONTEXT == 'V'))
		   SX3->(dbSkip())
           Loop        
	    EndIf
	    
	EndIf
*/
	If Substr(SX3->X3_CAMPO,4,6) # "FILIAL"
	
    	If (SX3->X3_CONTEXT == 'V')
		   SX3->(dbSkip())
           Loop        
	    EndIf
	    
	EndIf


	Aadd(aEstru,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})    	

	SX3->(dbSkip())                                                          
	
EndDo
     
//------------------------------------------------------------------------------------//
/*								Criacao do Arquivo de Trabalho					     */

IncProc("Exportando arquivo do Alias: " + cAlias + "... ")

If (Select("TRBEXP" ) <> 0)
	dbSelectArea("TRBEXP")
	dbCloseArea()
End            

cNomeArq := CriaTrab(aEstru)
Use &cNomeArq Alias TRBEXP New 

IncProc("Arquivo exportado com sucesso... ")

Return

//------------------------------------------------------------------------------------//
/*								Monta Parametros de Selecao						     */

Static Function MontaSX1()
Local J := 0
Local I := 0

aRegistros 	:={}
/* P/ 508
aadd(aRegistros,{cPerg,"01","Data de            ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{cPerg,"02","Data ate           ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
*/       
AADD(aRegistros,{cPerg,"01","Data de           ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cPerg,"02","Data ate          ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})


dbSelectArea("SX1")
dbSeek(cPerg)

If !Found()
	
	dbSeek(cPerg)
	
	While (SX1->X1_GRUPO == cPerg) .And. (!EOF())
		Reclock("SX1")
		dbDelete()
		MsUnlock()
		dbSkip()
	EndDo
	
	For I := 1 To Len(aRegistros)

		RecLock("SX1",.T.)

		For J := 1 To FCount()
			FieldPut(J,aRegistros[I,J])
		Next

		MsUnlock()

	Next

EndIf

Pergunte(cPerg,.T.)

Return

