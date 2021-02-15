#include "Protheus.ch"
#include "rwmake.ch"
#include "PRTOPDEF.CH"



User Function M103PCIT() 
Local aArea      := GetArea()
Local _aRet := PARAMIXB
Local _nPosCtD1 := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CONTA"})
Local _nPosRtD1 := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_RATEIO"})
Local _nPosDesc := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_DESCRI"})
Local _nPosProd := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"}) 
Local _aColsX   := aClone(aCols) 
Local Xi := 0

For Xi :=1 To Len(_aColsX)
	If _aColsX[n][_nPosRtD1] == "1"
		_aColsX[n][_nPosCtD1] := " "
	EndIf
Next Xi

aCols   := aClone(_aColsX) 

RestArea(aArea)
Return(_aRet)

