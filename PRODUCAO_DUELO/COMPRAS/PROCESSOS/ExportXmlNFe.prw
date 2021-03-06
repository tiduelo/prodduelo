#Include "Protheus.ch"
#Include "ApWebSrv.ch"
#Include "TopConn.ch"
#include "tbiconn.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"



//-----------------------------------------------------------------------
/*/{Protheus.doc} BaixaZip()
Montagem da Dialog 'Exportar Zip'

@author Natalia Sartori
@since 04.07.2012
@version 1.00

@param cAlias, nReg, nOpc, cMarca, lInverte
/*/
//-----------------------------------------------------------------------
user function zExpoXML()
Local cWhere	:= ""
Local aNFXML	:= {}
Local _nL := 0


PREPARE ENVIRONMENT EMPRESA '05' FILIAL '01' USER 'Administrador' PASSWORD 'DUELO2022' TABLES 'C00,SM0' MODULO 'COM'
     cWhere += "%"
      cWhere += " C00_FILIAL='"+xFilial("C00")+"'"
      cWhere += " AND C00_STATUS = '1' "
      cWhere += " AND C00_CODEVE = '3' "
      cWhere += " AND C00_SITDOC = '1' "
	  cWhere += " AND C00_EXPXML = ''  "
      cWhere += "%"

      BeginSql Alias "TMPC00"
			SELECT C00_SERNFE , C00_NUMNFE
			FROM %Table:C00%    
			WHERE %Exp:cWhere% AND
			%notdel%
      EndSql

      TMPC00->(dbGotop())

        While !TMPC00->(Eof())
          aadd(aNFXML,{TMPC00->C00_SERNFE, TMPC00->C00_NUMNFE})
          TMPC00->(dbSkip())
        End
      TMPC00->(dbCloseArea())

	   For _nL:= 1 to Len(aNFXML)
		U_XMLBaixaGz( aNFXML[_nL,1], aNFXML[_nL,2])
	   Next _nL

RESET ENVIRONMENT
Return




//-----------------------------------------------------------------------
/*/{Protheus.doc} BaixaZip()
Montagem da Dialog 'Exportar Zip'

@author Natalia Sartori
@since 04.07.2012
@version 1.00

@param cAlias, nReg, nOpc, cMarca, lInverte
/*/
//----------------------------------------------------------------------- 
user function XMLBaixaGz(_cSerXml, _cDocXml)


  Local aArea		:= GetArea()
  Local aPerg		:= {}
  Local aParam	:= {Space(3),Space(09),Space(09),Space(60),Space(1)}
  Local aChaves	:= {}
  Local aXmlRet	:= {}

  Local cPaExpXml	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"BxXml"
  Local cWhere	:= ""
  Local lUsaColab := .f.
  Local cAliasTemp:= GetNextAlias()
  Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
  Local cIdEnt	:= RetIdEnti(lUsaColab)
  Local cAmbiente	:= ""
  Local cAviso	:= ""
  Local cHelp		:= ""
  Local lParamOk	:= .F.
  Local lRet		:= .F.

  Local nX		:= 0
  Local nY		:= 0
  Local nZ		:= 0
  Local nW		:= 0
  Local nXAux		:= 0
  Local nQtdChv	:= 0

//V�riavel que define se vai ser a exporta��o direta ou ir� montar browse para marcar - usado apenas para TOTVS Colabora��o
  Default nOpc		:= 0

  Private oRet

  If CTIsReady(cURL)
    MV_PAR01 := aParam[01] :=  _cSerXml 
    MV_PAR02 := aParam[02] :=  _cDocXml 
    MV_PAR03 := aParam[03] :=  _cDocXml 
    MV_PAR04 := aParam[04] :=  GetSrvProfString ("ROOTPATH","")+GetMv("MV_NGINN")        //"D:\TOTVS12\Microsiga\Protheus_Data\importadorxml\inn" //ParamLoad(cPaExpXml,aPerg,4,aParam[04])


      cWhere += "%"
      cWhere += " C00_FILIAL='"+xFilial("C00")+"'"
      cWhere += " AND C00_NUMNFE BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'"
      cWhere += " AND C00_SERNFE = '" + MV_PAR01+ "'"
      cWhere += " AND C00_STATUS = '1' "
      cWhere += " AND C00_CODEVE = '3' "
      cWhere += " AND C00_SITDOC = '1' "
	  cWhere += " AND C00_EXPXML = ''  "
      cWhere += "%"

      BeginSql Alias cAliasTemp
			SELECT C00_CHVNFE
			FROM %Table:C00%    
			WHERE %Exp:cWhere% AND
			%notdel%
      EndSql

      (cAliasTemp)->(dbGotop())


        While !(cAliasTemp)->(Eof())
          aadd(aChaves,(cAliasTemp)->C00_CHVNFE)
          (cAliasTemp)->(dbSkip())
        End
  
      (cAliasTemp)->(dbCloseArea())
      RestArea(aArea)

        oWs :=WSMANIFESTACAODESTINATARIO():New()
        oWs:cUserToken   := "TOTVS"
        oWs:cIDENT	     := cIdEnt
        oWs:cAMBIENTE	 := ""
        oWs:cVERSAO      := ""
        oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"
        oWs:CONFIGURARPARAMETROS()
        cAmbiente		 := oWs:OWSCONFIGURARPARAMETROSRESULT:CAMBIENTE

        oWs:cUserToken   := "TOTVS"
        oWs:cIDENT	     := cIdEnt
        oWs:cAMBIENTE	 := cAmbiente

        oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"

        cAviso := "Arquivos gerados: "+ CRLF + CRLF + "Serie  Numero" + CRLF

        While nQtdChv < Len(aChaves)

          oWs:oWSDOCUMENTOS:oWSDOCUMENTO  := MANIFESTACAODESTINATARIO_ARRAYOFBAIXARDOCUMENTO():New()

          If (Len(aChaves) - nQtdChv) < 5
            nXAux := 1
            For nX:= nQtdChv+1 to Len(aChaves)
              aadd(oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO,MANIFESTACAODESTINATARIO_BAIXARDOCUMENTO():New())
              oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO[nXAux]:CCHAVE := aChaves[nX]
              nXAux++
              nQtdChv++
            Next nX
            If oWs:BAIXARXMLDOCUMENTOS()
              If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") <> "U"
                If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") == "A"
                  aXmlRet := oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET
                Else
                  aXmlRet := {oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET}
                EndIf
              EndIF

              //Processa({|| lRet := VerifProces(oRet,aXmlRet,aParam,@cAviso)},"Processando","Aguarde, exportando arquivos",.T.)
                lRet := VerifProces(oRet,aXmlRet,aParam,@cAviso)
            EndIf
          Else
            For nY:= 1 to 5
              aadd(oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO,MANIFESTACAODESTINATARIO_BAIXARDOCUMENTO():New())
              oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO[nY]:CCHAVE := aChaves[nY+nQtdChv]
            Next nY
            nQtdChv := nQtdChv + 5

            If oWs:BAIXARXMLDOCUMENTOS()
              If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") <> "U"
                If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") == "A"
                  aXmlRet := oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET
                Else
                  aXmlRet := {oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET}
                EndIf
              EndIF
              //Processa({|| lRet := VerifProces(oRet,aXmlRet,aParam,@cAviso)},"Processando","Aguarde, exportando arquivos",.T.)
                lRet := VerifProces(oRet,aXmlRet,aParam,@cAviso)
            EndIf
          EndIf
        EndDo

  EndIf

Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} VerifProces() 

Fun��o auxiliar para o processamento da exporta��o do arquivo zip

@author Natalia Sartori
@since 04.07.2012
@version 1.00

@param oRet, aXmlRet, aParam, cAviso 

@return lRet - Se o arquivo foi gerado ou n�o
/*/
//----------------------------------------------------------------------- 
Static Function VerifProces(oRet,aXmlRet,aParam,cAviso)

  Local nZ 		:= 0
  Local lRet 		:= .F.

  ProcRegua(Len(aXmlRet))

  For nZ:=1 to Len(aXmlRet)
    IncProc()
    oRet := aXmlRet[nZ]
    If GeraArq(aParam,oRet)
      lRet := .T.
      cAviso += SubStr(oRet:CCHAVE,23,3)+ "    "+SubStr(oRet:CCHAVE,26,9) + CRLF
    EndIf
  Next

Return(lRet)

//-----------------------------------------------------------------------
/*/{Protheus.doc} GeraArq() 

Fun��o que exporta os arquivos conforme o retorno do metodo

@author Natalia Sartori
@since 04.07.2012
@version 1.00

@param aParam 	- Parametros do parambox
       oRetorno - Retorno do metodo com o resultado da solicita��o
       
@return lRet	- Arquivo gerado ou n�o       
/*/
//----------------------------------------------------------------------- 
Static Function GeraArq(aParam,oRetorno)

  Local cDestino 	:= ""
  Local cDrive   	:= ""
  Local cNfeProt  	:= ""
  Local cNfe			:= ""
  Local cNfeProc	:= ""
  Local cChave		:= ""
  Local cNfeProtzi	:= ""
  Local cNfeZip		:= ""
  Local cNfeProcZi	:= ""

  Local lRet		:= .F.

  Local nHandle	:= 0
  //Local _cLocXml := "\importadorxml\" //US_MANDEST
  Local _cRootPath := GetSrvProfString ("ROOTPATH","")
  Local _cDestExp  := GetMv("US_MANDEST")+"\" 
  Local _cDestCop  := GetMv("MV_NGINN")+"\" 
  Local _cLocAux   := "importproduto\"
  

  oRet := oRetorno

  //SplitPath(aParam[04],@cDrive,@cDestino,"","")
  //cDestino := cDrive+cDestino


  If Type ("oRet:CCHAVE") <> "U" .and. !Empty(oRet:CCHAVE)
    cChave	:= oRet:CCHAVE
  EndIf
  If Type ("oRet:CCHVSTATUS") <> "U" .and. (!Empty(oRet:CCHVSTATUS) .and. ('138' $ oRet:CCHVSTATUS .or. '140' $ oRet:CCHVSTATUS .or. '656' $ oRet:CCHVSTATUS))   //140: Download disponibilizado - 656:Consumo indevido (tras dos campos da SPED156)
  
    If Type ("oRet:CNFEPROTZIP") <> "U" .and. !Empty(oRet:CNFEPROTZIP)
      cNfeProtZi	:= oRet:CNFEPROTZIP
    EndIf
    If Type ("oRet:CNFEZIP") <> "U" .and. !Empty(oRet:CNFEZIP)
      cNfeZip	:= oRet:CNFEZIP
    EndIf
    If Type ("oRet:CNFEPROCZIP") <> "U" .and. !Empty(oRet:CNFEPROCZIP)
      cNfeProcZi	:= oRet:CNFEPROCZIP
    EndIf

  EndIf

  If !Empty(cChave)

		If !Empty( cNfeProcZi ) .AND. !'<nfeProc' $ cNfeProcZi
			nHandle  := FCreate( _cRootPath+_cDestExp+cChave+"-"+"nfeProc.gz" )
			If nHandle > 0
				FWrite( nHandle, cNfeProcZi )
				FClose( nHandle )
				lRet   := .T.
				GzDecomp(_cDestExp+cChave+"-"+"nfeProc.gz", _cDestExp )	        			
				frename(_cRootPath+_cDestExp+cChave+"-"+"nfeProc" , _cRootPath+_cDestCop+cChave+"-"+"nfeProc.xml" )

        GzDecomp(_cDestExp+cChave+"-"+"nfeProc.gz", _cDestExp )
        frename(_cRootPath+_cDestExp+cChave+"-"+"nfeProc" , _cRootPath+_cDestExp+_cLocAux+cChave+"-"+"nfeProc.xml" )
        U_fLexml(cChave)
				
				DbSelectArea("C00")
				Dbsetorder(1)
				Dbgotop()
				If DbSeek(xFilial("C00")+cChave,.F.)
					RecLock("C00",.F.)
						C00->C00_EXPXML := "S"
					MsUnlock("C00")
				EndIf

			EndIf
		EndIf

  EndIf

Return lRet



User function fLexml(cChave)
  Local _cRootPath     := "importadorxml\05\manifesto\importproduto\"
  Local cError         := ""
  Local cWarning       := "" 
  Local _cChvNfe       := cChave 
  Local cNomearq       := ""
  Local oNotaxml       := NIL
  Local _aProd         := {}
  Local _aItmProd      := {}
  Local _nI            := 0
  Local _cCodForn      := ""
  Local _cLojForn      := ""

  cNomearq := _cRootPath+_cChvNfe+"-"+"nfeProc.xml"
  oNotaxml := XmlParserFile(cNomearq, "_", @cError, @cWarning)


If (oNotaxml == NIL )
  MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
  Return
Endif

_cCodForn := GetAdvFVal("SA2", "A2_COD" ,xFilial("SA2") + oNotaxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT,3)
_cLojForn := GetAdvFVal("SA2", "A2_LOJA",xFilial("SA2") + oNotaxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT,3)
_aItmProd := oNotaxml:_NFEPROC:_NFE:_INFNFE:_DET



For _nI := 1 To Len(_aItmProd)
  aAdd( _aProd, { oNotaxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_CPROD:TEXT,;
                  oNotaxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_XPROD:TEXT } ) 
Next _nI

Dbselectarea("SA5")
dbsetorder(1)
dbgotop()
If dbSeek(_cCodForn + _cLojForn)
  For _nX := 0 To len(_aProd)

    Do While ! eof()
      If SA5->A5_CODPRF == _aProd[_nX][1]
        ADel( _aProd, _nX )
      EndIf 
      dbskip()		
    Enddo
    
  Next _nX
EndIf
dbclosearea()


Alert("oi")
return nil

 
