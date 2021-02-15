#include "Protheus.ch"
#include "rwmake.ch"  
#include "PRTOPDEF.CH"

User Function LP650_001 (cTes)
cTesComp := cTes

SetPrvt("nVAL")
nVAL:= 0
	nVAL:= (SD1->D1_TOTAL+IF(SF4->F4_CREDIPI="S",SD1->D1_VALIPI,0)-(SD1->D1_VALIPI+IF(SF4->F4_CREDICM="S",SD1->D1_VALICM,0)))-(SD1->D1_VALIMP5+SD1->D1_VALIMP6)+;
	SD1->D1_ICMSRET + IF(SF4->F4_COMPL="S",((SD1->D1_BASEICM*0.17 + SD1->D1_VALIPI )-SD1->D1_VALICM),0) - IF(SF4->F4_IPIPECR > 0,SD1->D1_VALIPI,0)
                                         
	If SD1->D1_VALDESC > 0.00
		nVAL:= nVAL - SD1->D1_VALDESC
	Endif
Return(nVAL) 

User Function LP655_001 (cTes)
cTesComp := cTes

SetPrvt("nVAL")
nVAL:= 0
	nVAL:= (SD1->D1_TOTAL+IF(SF4->F4_CREDIPI="S",SD1->D1_VALIPI,0)-(SD1->D1_VALIPI+IF(SF4->F4_CREDICM="S",SD1->D1_VALICM,0)))-(SD1->D1_VALIMP5+SD1->D1_VALIMP6)+;
	SD1->D1_ICMSRET + IF(SF4->F4_COMPL="S",((SD1->D1_BASEICM*0.17 + SD1->D1_VALIPI )-SD1->D1_VALICM),0)
                                         
	If SD1->D1_VALDESC > 0.00
		nVAL:= nVAL - SD1->D1_VALDESC
	Endif

	If SDE->DE_PERC > 0.00
		nVAL:= 0
	Endif
	
Return(nVAL)

User Function LP665_001 (cTes)
cTesComp := cTes

SetPrvt("nVAL")
nVAL:= 0
IF POSICIONE("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_CONTBIL")=='N'
	nVAL:= 0
ELSEIF SD1->D1_TIPO=='D'
	nVAL:= 0
ELSE 
	nVAL := SF1->F1_VALBRUT-((SF1->F1_IRRF+SF1->F1_ISS+SF1->F1_INSS) - (SF1->F1_VALPIS+SF1->F1_VALCOFI+SF1->F1_VALCSLL))
ENDIF

	If SDE->DE_PERC > 0.00
		nVAL:= 0
	Endif

Return(nVAL)

             

User Function LP620_006 (cTes)
cTesComp := cTes

SetPrvt("nVAL")
nVAL:= 0
	nVAL:= (SD2->D2_TOTAL+IF(SF4->F4_CREDIPI="S",SD2->D2_VALIPI,0)-(SD2->D2_VALIPI+IF(SF4->F4_CREDICM="S",SD2->D2_VALICM,0)))-(SD2->D2_VALIMP5+SD2->D2_VALIMP6)+;
	SD2->D2_ICMSRET + IF(SF4->F4_COMPL="S",((SD2->D2_BASEICM*0.17 + SD2->D2_VALIPI )-SD2->D2_VALICM),0)

Return(nVAL) 






