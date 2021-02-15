#include "rwmake.ch"

User Function GDP009()
/*
*****************************************************************************
*****************************************************************************
**  Rotina   | GDP009   | Autor  -Claudenilson Dias     | Data | 05.03.10  **
**                      |                               |      |           **
*****************************************************************************
** Descricao | Menu de Manifesto                                           **
*****************************************************************************
**  Uso      | SIGAFAT                                                     **
*****************************************************************************
*****************************************************************************
*/

dbSelectArea("SZM")


aCores := { { 'ZM_STATUS == "I"', 'BR_VERDE'},;
{ 'ZM_STATUS == "P"', 'BR_VERMELHO'   },;
{ 'ZM_STATUS == "A"', 'BR_AMARELO' }}

private cLineOk2 := "AllwaysTrue()",oGets2 := {}, oSays2:={},oDlg2 := oMainWnd, oGetDados2 :=oMainWnd

aRotina := { { "Pesquisar"     ,'AXPESQUI'     , 0, 1 } ,;
{ "Visualisar"    ,'U_GDP009E(2)' , 0, 2 } ,;
{ "Incluir"       ,'U_GDP009C'    , 0, 3 } ,;
{ "Alterar"       ,'U_GDP009D'    , 0, 4 } ,;
{ "Excluir"       ,'U_GDP009E(5)' , 0, 5 } ,;
{ "Imprimir"      ,'U_GDR003'    , 0, 2 } ,;
{ "Legenda"       ,'U_GDP009L'    , 0, 2 } }

cCadastro := "MANIFESTO DE CARGA DE VENDAS "

//For ni:= 1 to Len(oGets)
//        oGets[ni]:Refresh()
//Next


mBrowse(01, 01, 30, 70, "SZM",,,,,, aCores)


Return(.T.)

User Function GDP009L()

_cLegOco  := "Manifesto"


_aLegCores:= {{ 'BR_VERDE'  , "Incluido" },;
{ 'BR_AMARELO' , "Modificadoo" },;
{ 'BR_VERMELHO', "Impresso" }}
//             { 'BR_PINK'    , "Aglutinado" },;
//             { 'BR_PRETO'   , "Vencido" },;

BrwLegenda(_cLegOco,"Legenda",_aLegCores)

Return(.T.)
