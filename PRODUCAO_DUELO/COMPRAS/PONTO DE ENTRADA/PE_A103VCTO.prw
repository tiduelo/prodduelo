/*PE_A103VCTO*/
#INCLUDE "RWMAKE.CH"


/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    A103VCTO  ¦ Autor ¦ Rafael Cruz- SURY     ¦ Data ¦ 30.04.21  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦PONTO DE ENTRADA PARA MANIPULAR INFORMAÇÕES ARRAY aColsSE2  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦Exclusivo para Vinhos Duelo                                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Objetivo ¦Atualizar os valores do titulo antes da inclusão da NF      ¦¦¦
¦¦¦ COM PA                                                                ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/ 

User Function A103VCTO()

Local aVencto     := {} //Array com os vencimentos e valores para geração dos títulos.
Local aPELinhas   := PARAMIXB[1]
Local nPEValor    := PARAMIXB[2]
Local cPECondicao := PARAMIXB[3]
Local nPEValIPI   := PARAMIXB[4]
Local dPEDEmissao := PARAMIXB[5]
Local nPEValSol   := PARAMIXB[6]
Local _cCondAnt   := GetAdvFVal("SE4", "E4_CTRADT",xFilial("SE4")+PARAMIXB[3],1)
Local _nPosPed    := 0 
Local _aQtdPacl   := {}
Local _cTipCond   := ""
Local _nVlrAnt    := 0
Local _cNumTit    := ""
Local _nResParc   := 0
Local _nVlrParc   := 0
Local _nH         := 0
Local _dDt1Parc   := CtoD("  /  /  ")
Local _n11PosArra := 0
Local _cTp8Gp1    := ""
Local _aTp8Gp1    := {}
Local _cTp8Gp1    := ""
Local _n21PosArra := 0
Local _n22PosArra := 0
Local _cTp8Gp2    := ""
Local _aTp8Gp2    := {} 

/*
PARAMIXB[1] - Array - Array com os títulos (aColsSE2)
PARAMIXB[2] - Numérico - Valor do Título
PARAMIXB[3] - Caracter - Condição de Pagamento
PARAMIXB[4] - Numérico - Valor do IPI
PARAMIXB[5] - Data - Data de Emissão
PARAMIXB[6] - Numérico - Valor do Solidário
*/


//Condição de Pagamento com Antecipação
If _cCondAnt == "1"

    
    _cTipCond   := GetAdvFVal("SE4", "E4_TIPO",xFilial("SE4")+PARAMIXB[3],1)
    _nPosPed    := aScan( aHeadD1, { |x| Alltrim(x[2])=="D1_PEDIDO" } )
    _cNumTit    := PadR(("PC"+aColsD1[1,_nPosPed]),9," ")
    _nVlrAnt    := GetAdvFVal("SE2", "E2_VALOR",xFilial("SE2")+"ANT"+_cNumTit+SPACE(1)+"PA "+CA100FOR+CLOJA,1)
    _nResParc   := nPEValor - _nVlrAnt  //Restante da Fatura
    

    If  _cTipCond == "1" //Cond. Pagto. TIPO 1 - indica o deslocamento em dias a partir da data base

        _aQtdPacl   := Strtokarr (GetAdvFVal("SE4", "E4_COND",xFilial("SE4")+PARAMIXB[3],1),",")
        _nVlrParc :=  (_nResParc/(Len(_aQtdPacl)-1))

        For _nH:=1 To Len(_aQtdPacl)
            _dDtParc := DaySum(dPEDEmissao,Val(_aQtdPacl[_nH]))           
            If _nH = 1
                aadd(aVencto,{_dDtParc,_nVlrAnt})
            Else
                aadd(aVencto,{_dDtParc,_nVlrParc})
            EndIf 
        Next _nH

    ElseIf _cTipCond == "2" 
    
    ElseIf _cTipCond == "3"
    
    ElseIf _cTipCond == "4"
    
    ElseIf _cTipCond == "5"//Cond. Pagto. TIPO 5 - representa a carência, a quantidade de duplicatas e os vencimentos, nesta ordem, representado por valores numéricos
    
        _aQtdPacl := Strtokarr (GetAdvFVal("SE4", "E4_COND",xFilial("SE4")+PARAMIXB[3],1),",")
        _nVlrParc :=  (_nResParc/((Val(_aQtdPacl[2])-1)))

        For _nH:=1 To Val(_aQtdPacl[2])
                      
            If _nH = 1
                _dDtParc  := DaySum(dPEDEmissao,Val(_aQtdPacl[1]))
                _dDt1Parc := DaySum(dPEDEmissao,Val(_aQtdPacl[1]))
                aadd(aVencto,{_dDtParc,_nVlrAnt})
            Else
                _dDtParc := DaySum(_dDt1Parc, (Val(_aQtdPacl[3]) * _nH))                
                aadd(aVencto,{_dDtParc,_nVlrParc})
            EndIf 
        Next _nH

    ElseIf _cTipCond == "6"
    
    ElseIf _cTipCond == "7"
    
    ElseIf _cTipCond == "8"
        _n11PosArra := (AT( "]", GetAdvFVal("SE4", "E4_COND",xFilial("SE4")+PARAMIXB[3],1))-2)
        _cTp8Gp1    := SubStr(GetAdvFVal("SE4", "E4_COND",xFilial("SE4")+PARAMIXB[3],1),2,_n11PosArra)
        _aTp8Gp1    := Strtokarr (_cTp8Gp1,",")

        _cTp8Gp1    := SubStr(GetAdvFVal("SE4", "E4_COND",xFilial("SE4")+PARAMIXB[3],1),2)
        _n21PosArra := AT( "[", _cTp8Gp1 )
        _n22PosArra := RAt("]",_cTp8Gp1) //(Len(Alltrim(GetAdvFVal("SE4", "E4_COND",xFilial("SE4")+PARAMIXB[3],1)))-2)
        _cTp8Gp2    := SubStr( _cTp8Gp1, (_n21PosArra+1) , ((_n22PosArra-1) - _n21PosArra))
        _aTp8Gp2    := Strtokarr (_cTp8Gp2,",")     
        

    
    ElseIf _cTipCond == "9"
    
    EndIf

EndIf

Return aVencto
