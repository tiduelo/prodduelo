#INCLUDE "rwmake.ch"  

User Function DUE012B()

/*
+----------------------------------------------------------------------------+
| Programa  : DUE012B  | Autor : Anderson Luis Barbosa     | Data: 20.11.01  |
+----------------------------------------------------------------------------+
| Descricao : Importador de Arquivos de integracao entre Filiais             |
+----------------------------------------------------------------------------+
| Uso       : Generico                                                       |
+----------------------------------------------------------------------------+
| Obs.      :                                                                |
+----------------------------------------------------------------------------+
*/   

cNomeArq := ''

@ 096, 042  To  300, 400 Dialog oDlg1 Title "Integracao entre Filiais - Importacao de Dados"

@ 020, 030  Say "Esta rotina ira importar os dados para realizacao"
@ 030, 030  Say "da Integracao entre Filiais dos arquivos definidos"
@ 040, 030  Say "nas Configuracoes de Integracao."

@ 075, 110 BmpButton Type 01 Action Processa({|lEnd| Importar(@lEnd)},"Importando Arquivos...",OemToAnsi(""),.T.)        
@ 075, 140 BmpButton Type 02 Action Close(oDlg1)

Activate Dialog oDlg1 Centered

Return Nil

//------------------------------------------------------------------------------------//
/*								Processa Importação de Dados					     */

Static Function Importar()
                 
Close(oDlg1)

dbSelectArea("SZN")
SZN->(dbSetOrder(1))
SZN->(dbGoTop())      

SZN->(ProcRegua(RecCount()))

While SZN->(!EOF())
                 
    If SZN->ZN_ATIVO == "N"
       SZN->(dbSkip())
       Loop
    EndIf        

	cArq := '\SIGAINT01\' + SZN->ZN_ALIAS + GetDbExtension()
    
    If File(cArq)
    
       If SZN->ZN_ZAPTAB == "S"
                                       
          dbSelectArea(SZN->ZN_ALIAS)
          (SZN->ZN_ALIAS)->(dbCloseArea())       
          AbreExcl(SZN->ZN_ALIAS)            
          ZAP       
	      (SZN->ZN_ALIAS)->(dbCloseArea())
          
       EndIf        
                   
       Incproc('Atualizando Arquivo do Alias: ' + SZN->ZN_ALIAS + '. Aguarde.... ')

       dbSelectArea(SZN->ZN_ALIAS)
	   Append From (cArq) //SDF // Delimited	
	   fErase(cArq)                
	   
	Else
 
       Incproc('Arquivo do Alias: ' + SZN->ZN_ALIAS + ' nao encontrado... ')	
	
	EndIf    
   
    SZN->(dbSkip())                                                               

EndDo       

MsgBox('Importacao de dados finalizada com sucesso!','Aviso','INFO')

Return                       

