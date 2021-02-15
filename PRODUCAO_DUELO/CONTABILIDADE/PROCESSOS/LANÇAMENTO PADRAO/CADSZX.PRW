#include "rwmake.ch"   

User Function CadSZX()

//
// cadastro de verba por centro de custo
//
_cArea := Alias()
_nOrd  := IndexOrd() 
_nReg  :=RecNo()

DbSelectArea("SZX")
DbGotop()

axcadastro("SZX","Cadastro de Verbas por Centro de Custo")

dbSelectArea(_cArea)
DbSetOrder(_nOrd)
DbGoTo(_nReg)

return(nil)

   
