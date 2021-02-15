#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"


USER FUNCTION MOTDEV() 

DbSelectArea("ZTM")
dbSetOrder(1)

AxCadastro("ZTM","MOVIMENTACAO DE MALA DIRETA")
    
RETURN