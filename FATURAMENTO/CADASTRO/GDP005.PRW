#include "rwmake.ch"
#include "colors.ch"

User Function gdp005()
//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++ Rotina  :  ALTERAÇÃO DE REGIOES NO SX5
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++ Descrica:  Controle de ocorrencias internas                             ++
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++ Uso     :  Todos os sistemas                                            ++
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++ Alterado:                                                               ++
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
_cSX5Area := alias()
_cSX5Ind  := indexord()
_cSX5Rec  := recno()


dbSelectArea("SX5")
dbSetOrder(1)
dbgotop()

SET FILTER TO X5_FILIAL = XFILIAL("SX5") .AND. X5_TABELA == "A2"

axcadastro("SX5","Regioes de clientes")

SET FILTER TO

dbselectarea(_csx5Area)
dbsetorder(_cSx5Ind)
dbgoto(_cSx5Rec)

Return nil

