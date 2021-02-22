#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "rwmake.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc}

---------------
@author Rafael Cruz - SURY SOLUÇÕES
@since 19.02.2021
@version 1.00
@Função MATUCOMP - Alterações automáticas
@param Utilizado para alterações automáticas nos complementos dos documentos fiscais após a emissão das Notas Fiscais.
/*/
//-----------------------------------------------------------------------
// _________________________________________________________________________________________________
//|Quando se referir aos complementos para geracao dos registros C110, C111, C112, C113, C114 e C115|
//|  a tabela CDT também deve ser alimentada, pois ela que efetua o relacionamentos com as outras   |
//|  conforme registro. C110 = Tab. CDT, C111 = Tab. CDG, , C112 = Tab. CDC, C113 = Tab. CDD,       |
//|  C114 = Tab. CDE e C115 = Tab. CDF                                                              |
//|_________________________________________________________________________________________________|
User Function  MATUCOMP()
 cEntSai   := ParamIXB[1]
 cDoc      := ParamIXB[3]
 cSerie    := ParamIXB[2]
 cCliefor  := ParamIXB[4]
 cLoja     := ParamIXB[5]
 lExiste   := CDG->(dbSeek(xFilial("CDG")+cEntSai+cDoc+cSerie+cClieFor+cLoja))

If cEntSai == "S" .AND. FWCodEmp() == "04" .AND. ALLTRIM(SF2->F2_ESPECIE) == "SPED"
    If lExiste
	    RecLock("CDG",.F.)
    Else
	    dbSelectArea("SD2")
    	dbSetOrder(3)
	    MsSeek(xFilial("SD2")+cDoc+cSerie+cClieFor+cLoja)
  
    	Do While !SD2->(Eof())

            If SD2->D2_DOC == cDoc .and. SD2->D2_SERIE == cSerie .and. SD2->D2_CLIENTE == cClieFor .and. SD2->D2_LOJA == cLoja
		        RecLock("CDG",.T.)
            	CDG->CDG_FILIAL = xFilial("CDG")
        		CDG->CDG_TPMOV  = cEntSai
	        	CDG->CDG_DOC    = cDoc
    		    CDG->CDG_SERIE  = cSerie
        		CDG->CDG_CLIFOR = cClieFor
	        	CDG->CDG_LOJA   = cLoja
		        CDG->CDG_IFCOMP = "000004"
        		CDG->CDG_PROCES = "50018146820194047203"
	        	CDG->CDG_TPPROC = "1"
    	    	CDG->CDG_SDOC   = "001"
	    	    CDG->CDG_VALOR  = SD2->D2_VALICM
    	    	CDG->CDG_ITEM   = SD2->D2_ITEM
	        	CDG->CDG_ITPROC = "00000001"
	        	MsUnLock()
		        FkCommit()
            EndIf

	    	SD2->(DbSkip())
	    Enddo
    EndIf
EndIf

Return()
