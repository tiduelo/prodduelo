#INCLUDE "rwmake.ch"  

User Function DUE012()
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

/*
+----------------------------------------------------------------------------+
| Programa  : DUE012   | Autor : Anderson Luis Barbosa     | Data: 19.11.01  |
+----------------------------------------------------------------------------+
| Descricao : Configurador do Arq. de Transferencia entre Filiais            |
+----------------------------------------------------------------------------+
| Uso       : Generico                                                       |
+----------------------------------------------------------------------------+
| Obs.      :                                                                |
+----------------------------------------------------------------------------+
*/

Private cString 


Private cString := "SZN"

dbSelectArea("SZN")
dbSetOrder(1)

AxCadastro(cString,"Configurador de Arquivos de Transferencia entre Filiais",cVldAlt,cVldExc)

Return
