#Include "RwMake.Ch"
#Include "TopConn.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSCI001F   บ Autor ณ Cleiton Campos     บ Data ณ  12/09/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera arquivo para pessoa fisica                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณArguto                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ Alteracoes                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      ณ Descricao                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

USER FUNCTION SCI001F(nHdl,_cEol,MV_PAR01,MV_PAR02)

LOCAL _cLin		:= ""
LOCAL _cCpo		:= ""
LOCAL _cQuery	:= ""
Local _lValid   := .F.
Local _cData    := ""

ProcRegua(1)

_cQuery	:= "SELECT 'TPREG'    = 'F', "            // Campo 01
_cQuery	+= "       'CNPJ'     = A1_CGC,"          // Campo 02
_cQuery	+= "       'RG'       = SPACE(20),"       // Campo 03
_cQuery	+= "       'EMISSOR'  = SPACE(04),"       // Campo 04
_cQuery	+= "       'NOME'     = REPLACE(SA1.A1_NOME,',',''),"     // Campo 05
_cQuery	+= "       'NTZ_END'  = 'D',"             // Campo 06
_cQuery	+= "       'ENDERECO' = REPLACE(A1_END,',',''),"          // Campo 07
_cQuery	+= "       'CIDADE'   = LEFT(A1_MUN,30)," // Campo 08
_cQuery	+= "       'UF'       = A1_EST,"          // Campo 09
_cQuery	+= "       'CEP'      = A1_CEP,"          // Campo 10
_cQuery	+= "       'DDD_TEL'  = LEFT(A1_TEL,2),"  // Campo 11
_cQuery	+= "       'TELEFONE' = SUBSTRING(A1_TEL,3,10)," // Campo 12
_cQuery	+= "       'DDD_FAX'  = LEFT(A1_FAX,2),"         // Campo 13
_cQuery	+= "       'FAX'      = SUBSTRING(A1_FAX,3,10)," // Campo 14
_cQuery	+= "       'EMAIL'    = SA1.A1_EMAIL,"           // Campo 15
_cQuery	+= "       'DATCAD'   = SUBSTRING(A1_DTCAD,5,2)+SUBSTRING(A1_DTCAD,1,4)," // Campo 16
_cQuery	+= "       'TITULO'   = REPLACE(SE1.E1_NUM,',','')," // Campo 17
_cQuery	+= "       'TIPODOC'  = CASE"         // Campo 18
_cQuery	+= "                     WHEN E1_TIPO   =  'NF' THEN 'N'"
_cQuery	+= "                     WHEN E1_TIPO   =  'CH' THEN 'C'"
_cQuery	+= "                     WHEN E1_TIPO   =  'FT' THEN 'F'"
_cQuery	+= "                     WHEN E1_TIPO   =  'DP' THEN 'D'"
_cQuery	+= "                     WHEN E1_NUMBOR <> ''   THEN 'B'"
_cQuery	+= "                    END,"
_cQuery	+= "       'MOEDA'   = 'R$  ',"    // Campo 19
_cQuery	+= "       'VALOR'   = CONVERT(INT,CONVERT(MONEY,E1_VALOR*100)) - "    // Campo 20 e 21
_cQuery	+= "                   (SELECT ISNULL(CONVERT(INT,CONVERT(MONEY,SUM(E5_VALOR*100))),0)"
_cQuery	+= "                    FROM SE5010 SE5"
_cQuery	+= "                    WHERE SE5.E5_NUMERO = SE1.E1_NUM"
_cQuery	+= "                    AND   SE5.E5_PARCELA = SE1.E1_PARCELA"
_cQuery	+= "                    AND   SE5.E5_CLIFOR = SE1.E1_CLIENTE"
_cQuery	+= "                    AND   SE5.E5_LOJA   = SE1.E1_LOJA"
_cQuery	+= "                    AND   SE5.E5_MOTBX <> 'NOR'"
_cQuery	+= "                    AND   SE5.D_E_L_E_T_ <> '*'),"
_cQuery	+= "       'VLRPAGO' = CONVERT(INT,CONVERT(MONEY,(SE1.E1_VALLIQ*100)))," // Campo 22 e 23
_cQuery	+= "       'DTVENDA' = SE1.E1_EMISSAO,"                 // Campo 24
_cQuery	+= "       'DTVECTO' = SE1.E1_VENCTO,"                  // Campo 25
_cQuery	+= "       'DTBAIXA' = CASE"                  // Campo 26
_cQuery += "                    WHEN SE1.E1_EMISSAO = E1_VENCTO AND SE1.E1_BAIXA <> '' THEN SE1.E1_VENCTO "
_cQuery += "                    ELSE SE1.E1_BAIXA"
_cQuery += "                   END"
_cQuery	+= " FROM " + RetSqlName("SA1") + " SA1, "
_cQuery	+=            RetSqlName("SE1") + " SE1 "
_cQuery	+= " WHERE SE1.E1_VENCTO  <= '" + DtoS(M->ddatabase) + "' "
_cQuery	+= " AND   SE1.E1_STATUS = 'B'"
_cQuery += " AND   SE1.E1_EMISSAO BETWEEN '"+ DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
_cQuery	+= " AND   SA1.A1_COD  = SE1.E1_CLIENTE "
_cQuery	+= " AND   SA1.A1_LOJA = SE1.E1_LOJA "
_cQuery	+= " AND   LEN(SA1.A1_CGC) = 11 "
_cQuery	+= " AND   SA1.D_E_L_E_T_ <> '*' "
_cQuery	+= " AND   SE1.D_E_L_E_T_ <> '*' "

TcQuery _cQuery New Alias "REGSCIF"

dbSelectArea("REGSCIF")
dbGoTop()
WHILE !EOF()
	
	_cLin		:= SPACE(353)
	
	_lValid := REGSCIF->VALOR > 0 .And.  REGSCIF->DTVECTO < DtoS(M->dDataBase)
	
	If _lValid
		// Campo 01
		_cCpo		:= PADR(REGSCIF->TPREG,01)		           	// Tipo do registro
		_cLin		:= STUFF(_cLin,01,01,_cCpo)
		
		// Campo 02
		_cCpo		:= PADR(REGSCIF->CNPJ,11)		            // CPF
		_cLin		:= STUFF(_cLin,02,12,_cCpo)
		
		// Campo 03
		_cCpo		:= PADR(SPACE(20),13)			            // RG
		_cLin		:= STUFF(_cLin,13,32,_cCpo)
		
		// Campo 04
		_cCpo		:= PADR(SPACE(04),04)		   		        // Orgao emissor
		_cLin		:= STUFF(_cLin,33,36,_cCpo)
		
		// Campo 05
		_cCpo		:= PADR(REGSCIF->NOME,55)					// Nome do consumidor
		_cLin		:= STUFF(_cLin,37,91,_cCpo)
		
		// Campo 06
		_cCpo		:= PADR(REGSCIF->NTZ_END,1)				    // Natureza do endereco
		_cLin		:= STUFF(_cLin,92,92,_cCpo)
		
		// Campo 07
		_cCpo		:= PADR(REGSCIF->ENDERECO,70) 		        // Endereco
		_cLin		:= STUFF(_cLin,93,162,_cCpo)
		
		// Campo 08
		_cCpo		:= PADR(REGSCIF->CIDADE,30)			        // Cidade
		_cLin		:= STUFF(_cLin,163,192,_cCpo)
		
		// Campo 09
		_cCpo		:= PADR(REGSCIF->UF,2)			            // UF
		_cLin		:= STUFF(_cLin,193,194,_cCpo)
		
		// Campo 10
		_cCpo		:= PADR(REGSCIF->CEP,8)			            // CEP
		_cLin		:= STUFF(_cLin,195,202,_cCpo)
		
		// Campo 11
		_cCpo		:= PADR("",4)			        // DDD do telefone
		_cLin		:= STUFF(_cLin,203,206,_cCpo)
		
		// Campo 12
		_cCpo		:= PADR("",10)			    // Numero do telefone
		_cLin		:= STUFF(_cLin,207,216,_cCpo)
		
		// Campo 13
		_cCpo		:= PADR("",4)			        // DDD do fax
		_cLin		:= STUFF(_cLin,217,220,_cCpo)
		
		// Campo 14
		_cCpo		:= PADR("",10)			        // Numero do fax
		_cLin		:= STUFF(_cLin,221,230,_cCpo)
		
		// Campo 15
		_cCpo		:= PADR("",50)			        // E-MAIL
		_cLin		:= STUFF(_cLin,231,280,_cCpo)
		
		// Campo 16
		_cCpo		:= PADR(REGSCIF->DATCAD,6)			        // Cliente desde
		_cLin		:= STUFF(_cLin,281,286,_cCpo)
		
		// Campo 17
		_cCpo		:= PADR(REGSCIF->TITULO,12)			        // Identificador da transacao
		_cLin		:= STUFF(_cLin,287,298,_cCpo)
		
		// Campo 18
		_cCpo		:= PADR(REGSCIF->TIPODOC,1)			        // Tipo de documento da transacao
		_cLin		:= STUFF(_cLin,299,299,_cCpo)
		
		// Campo 19
		_cCpo		:= PADR(REGSCIF->MOEDA,4)			        // Moeda
		_cLin		:= STUFF(_cLin,300,303,_cCpo)
		
		// Campo 20 e 21
		_cCpo		:= PADR(STRZERO(REGSCIF->VALOR,13),13)	    // Valor inteiro da transacao
		_cLin		:= STUFF(_cLin,304,316,_cCpo)
		
		// Campo 22 e 23
		_cCpo		:= PADR(STRZERO(REGSCIF->VLRPAGO,13),13)	// Valor inteiro pago
		_cLin		:= STUFF(_cLin,317,329,_cCpo)
		
		// Campo 24
		_cData      := SubStr(REGSCIF->DTVENDA,7,2) + SubStr(REGSCIF->DTVENDA,5,2) + SubStr(REGSCIF->DTVENDA,1,4)
		_cCpo		:= PADR(AllTrim(_cData),8)    // Data da venda
		_cLin		:= STUFF(_cLin,330,337,_cCpo)
		
		// Campo 25
		_cData      := SubStr(REGSCIF->DTVECTO,7,2) + SubStr(REGSCIF->DTVECTO,5,2) + SubStr(REGSCIF->DTVECTO,1,4)
		_cCpo		:= PADR(AllTrim(_cData),8)	    // Data do vencimento
		_cLin		:= STUFF(_cLin,338,345,_cCpo)
		
		// Campo 26
		_cData      := SubStr(REGSCIF->DTBAIXA,7,2) + SubStr(REGSCIF->DTBAIXA,5,2) + SubStr(REGSCIF->DTBAIXA,1,4)
		_cCpo		:= PADR(AllTrim(_cData),8)	    // Data da baixa
		_cLin		:= STUFF(_cLin,346,353,_cCpo)
		
		_cLin		+= _cEol
		
		IncProc("Gravando registro! "+Alltrim(REGSCIF->TITULO))
		
		IF fWrite(nHdl,_cLin,Len(_cLin)) != LEN(_cLin)
			_cMensagem	:= "Ocorreu um erro na gravacao do arquivo. "
			HELP("",1,PROCNAME(),,_cMensagem,1,0)
		ENDIF
	EndIf
	dbSelectArea("REGSCIF")
	dbSkip()
	
ENDDO

dbCloseArea("REGSCIF")

RETURN