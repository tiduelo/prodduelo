#include "rwmake.ch"

/////////////////////////
User Function SF2460I()
/////////////////////////
//
// Ponto de Entrada apos a gravacao do SF2
//
///////////////////////

_cAtuarea := alias()
_nAtuorde := indexord()
_nAtuRegi := recno()

_cNomCli   := ""
_npesol    := 0
_npesob    := 0
_nvolumes  := 0
_cEspecie  := ""
_cPlaca    := ""
_cUFPlaca  := ""
_cPEDCLI   := ""
_cCodVend  := ""
_cSupVend  := ""
_cZonVend  := ""
_dSAIDA    := CTOD("")
_cVeiculo  := space(8)

dbSelectArea("SC5")

_cMENNOTA  	:= SC5->C5_MENNOTA
_cMENS1    	:= SC5->C5_MENS1
_cMENS2    	:= SC5->C5_MENS2
_cMENS3    	:= SC5->C5_MENS3
_cMENS4    	:= SC5->C5_MENS4
_cMENS5    	:= SC5->C5_MENS5
_cMENS6    	:= SC5->C5_MENS6
_cMENS7    	:= SC5->C5_MENS7
//_cPlaca    	:= SC5->C5_PLACA
//_cUFPlaca  	:= SC5->C5_UFPLACA
_cPEDCLI   	:= SC5->C5_PEDCLI
_cCodVend  	:= SC5->C5_VEND1
_dSAIDA    	:= SC5->C5_SAIDA
_ccodCli	:= SC5->C5_CLIENTE
_clojCli	:= SC5->C5_LOJACLI  
_cVeiculo  := SC5->C5_VEICULO


if !empty(_cCodVend)	
	_cSupVend  := GetAdvFVal("SA3", "A3_SUPER",xFilial("SA3")+ _cCodVend ,1)
	//_cZonVend  := GetAdvFVal("DA5", "DA5_COD" ,xFilial("DA5")+ _cCodVend ,2)	
	_cZonVend  := GetAdvFVal("SA1", "A1_ZONA" ,xFilial("SA1")+ _ccodCli + _clojCli ,1)
endif

if !empty(_cVeiculo)
	_cPlaca			:= GetAdvFVal("DA3","DA3_PLACA",xFilial("DA3")+_cVeiculo,1)
	_cUFPlaca		:= GetAdvFVal("DA3","DA3_ESTPLA",xFilial("DA3")+_cVeiculo,1)
endif


dbSelectArea("SF2")

_cNota    := SF2->F2_DOC
_cSerie   := SF2->F2_SERIE
_cCliente := SF2->F2_CLIENTE
_cLoja    := SF2->F2_LOJA

if SF2->F2_TIPO $ "BD"
	
	dbSelectArea("SA2")
	
	_nSA2orde := indexord()
	_nSA2Regi := recno()
	
	dbsetorder(1)
	dbgotop()
	
	if dbseek(xfilial("SA2")+_cCliente+_cLoja,.f.)
		_cNomCli  := "FORN-"+sa2->a2_nome
	Endif
	
	dbsetorder(_nSA2orde)
	dbgoto(_nSA2Regi)
	
Else
	
	dbSelectArea("SA1")
	
	_nSA1orde := indexord()
	_nSA1Regi := recno()
	
	dbsetorder(1)
	dbgotop()
	
	if dbseek(xfilial("SA1")+_cCliente+_cLoja,.f.)
		_cNomCli  := sa1->a1_nome
	Endif
	
	dbsetorder(_nSA1orde)
	dbgoto(_nSA1Regi)
	
Endif

dbSelectArea("SD2")

_nSD2orde := indexord()
_nSD2Regi := recno()

dbSetOrder(3)
dbgotop()

if dbSeek(xfilial("SD2")+_cNota+_cSerie+_cCliente+_cLoja,.F.)
	
	Do WHILE !EOF() .AND. xfilial("SD2")+_cNota+_cSerie+_cCliente+_cLoja == D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA
		
		_nvolumes  += D2_QUANT
		
		if empty(_cEspecie)
			_cEspecie  := D2_UM
		Else
			if _cEspecie <> D2_UM
				_cEspecie := "DIVERSOS"
			Endif
		Endif
		
		DbSkip()
		
	Enddo
ELSE
	MSGBOX("Problema com itens da NF - COMUNIQUE TI - PE SF240I")
ENDIF

dbsetorder(_nSD2orde)
dbgoto(_nSD2Regi)

dbSelectArea("SF2")

IF 	RecLock("SF2",.F.)
	//SF2->F2_PLIQUI  := _npesol
	//SF2->F2_PBRUTO  := _npesob
	SF2->F2_CLINOME := _cNomCli
	SF2->F2_ESPECI1 := iif(empty(SF2->F2_ESPECI1),_cEspecie,SF2->F2_ESPECI1)
	SF2->F2_VOLUME1 := iif(empty(SF2->F2_VOLUME1),_nvolumes,SF2->F2_VOLUME1)
	SF2->F2_MENNOTA := _cMENNOTA
	SF2->F2_MENS1   := _cMENS1
	SF2->F2_MENS2   := _cMENS2
	SF2->F2_MENS3   := _cMENS3
	SF2->F2_MENS4   := _cMENS4
	SF2->F2_MENS5   := _cMENS5
	SF2->F2_MENS6   := _cMENS6
	SF2->F2_MENS7   := _cMENS7
	SF2->F2_PLACA   := _cPlaca
	SF2->F2_UFPLACA := _cUFPlaca
	SF2->F2_PEDCLI  := _cPEDCLI
	SF2->F2_SAIDA   := _dSAIDA
	SF2->F2_VEICUL1 := iif(empty(SF2->F2_VEICUL1),_cVeiculo,SF2->F2_VEICUL1)
	SF2->F2_VENDSUP	:= _cSupVend
	SF2->F2_ZONAVEN	:= _cZonVend
	
	MsUnlock()
Endif

dbselectarea(_cAtuarea)
dbsetorder(_nAtuorde)
dbgoto(_nAtuRegi)

Return NIL
