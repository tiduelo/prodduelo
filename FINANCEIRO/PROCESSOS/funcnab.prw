#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 15/02/01

**********************
User Function NUMREM()
**********************
// Incrementar o numero de remessa (no Header) e numero do pagamento a ser
// enviado ao banco (no Detalhes)
// Criar campos A6_REMES (CHR,7)
// CNAB Bradesco

SetPrvt("_REMESSA,NREG,CIND,CBANCO,CAGENC,CCONTA")
Private _Remessa := ""

DbSelectArea("SA6")
nReg    := Recno()
cInd    := IndexOrd()
cBanco  := "237"
cAgenc  := "875-3"
cConta  := "30783-1   "

DbSetOrder(1)
DbSeek(xFilial("SA6")+cBanco+cAgenc+cConta)

Reclock("SA6",.f.)
SA6->A6_REMES  := SOMA1(SA6->A6_REMES,7)
MsUnlock()

_Remessa := SA6->A6_REMES

Dbselectarea("SA6")
DbSetOrder(cInd)
DbGoTo(nReg)
Return(_Remessa)


*************
User Function Numbrad()
*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Loca i :=0 
Private _NossoNum := "",_Carteira := "",_cAgenc := ""
Private i:=0,_nSoma:=0;_nResto:=0

_Carteira := "09"

For i:=1 to Len(alltrim(SEE->EE_AGENCIA))
    If !(substr(SEE->EE_AGENCIA,i,1) $ "/-.,")
    _cAgenc += substr(SEE->EE_AGENCIA,i,1)    
    Endif
Next

_NossoNum := _Carteira+LEFT(STRZERO(VAL(_cAgenc),5),4)+LEFT(SEE->EE_NUMBCO2,7)

_cMul := "2765432765432" //Fator para achar DV
_nSoma:= 0

for i:= 1 to 13
   _nSoma :=  _nSoma + round(Val(Subs(_NossoNum,i,1))*Val(Subs(_cMul,i,1)),0)
Next
_nDigVer := int(round(_nSoma / 11,1))
_cDigVer := "0"
_cResto  := int(_nSoma % 11)
_nDigVer := 11 - _cResto

If _nDigVer > 0 .and. _nDigVer < 10
   _cDigVer := alltrim(str(_nDigver))
Endif

If _cResto == 1
   _cDigVer := "P"
Endif
If _cResto == 0
   _cDigVer := "0"
Endif
cDig := _cDigVer //Modulo11(_NossoNum,2,9)

_NossoNum := SUBSTR(_NossoNum,3,11)+cDig
Reclock("SEE",.f.)
SEE->EE_NUMBCO2 := SOMA1(SEE->EE_NUMBCO2,7)
MSUNLOCK()  
Reclock("SE1",.f.)
SE1->E1_NUMBCO := _NossoNum
MSUNLOCK()  
Return(_NossoNum)


*************
User Function CodEmp()
*************
// Retorna o codigo da empresa, eliminando os caracteres especiais
// dos campos conta e agencia
// CNAB Banco do Brasil
Local i := 0
Private _CodEmp := "",_cConta := "",i:=0

For i:=1 to Len(alltrim(SEE->EE_CONTA))
    If !(substr(SEE->EE_CONTA,i,1) $ "/-.,")
    _cConta += substr(SEE->EE_CONTA,i,1)    
    Endif
Next

_CodEmp := STRZERO(VAL(SEE->EE_AGENCIA),5)+STRZERO(VAL(_cConta),9)+LEFT(SEE->EE_CODEMP,6)

Return(_CodEmp)

*************
User Function Numbco()
*************
// Retorna o Nosso Numero
// CNAB Banco do Brasil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local i := 0
Private _NossoNum := ""

_NossoNum := Left(SEE->EE_CODEMP,6)+LEFT(SEE->EE_NUMBCO,5)

_cMul := "78923456789" //Fator para achar DV
_nSoma:= 0

//Rotina para calculo do digito verificador
for i:= 1 to 11
   _nSoma :=  _nSoma + round(Val(Subs(_NossoNum,i,1))*Val(Subs(_cMul,i,1)),0)
Next
_nDigVer := int(round(_nSoma / 11,1))
_cDigVer := _nDigVer* 11
_nDigVer := _nSoma - _cDigVer

If _nDigVer == 10
   _cDigVer := "X"
Endif
If _nDigVer == 0
   _cDigVer := "0"
Endif
If _nDigVer > 0 .and. _nDigVer < 10
   _cDigVer := alltrim(str(_nDigver))
Endif
cDig := _cDigVer //Modulo11(_NossoNum,2,9)
_NossoNum := _NossoNum+cDig
Reclock("SEE",.f.)
SEE->EE_NUMBCO := SOMA1(SEE->EE_NUMBCO,5)
MSUNLOCK()  
Reclock("SE1",.f.)
SE1->E1_NUMBCO := _NossoNum
MSUNLOCK()  
Return(_NossoNum)

