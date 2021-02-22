#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    | VldEspSF1 ³Autor ³ Rafael Cruz - SURY Soluções  |Data ³ 05/02/21 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Validação da Serie informada na inclusão da Nota de Entrada****   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cESPECIE= Variavel Padrão da Rotina MATA103/MATA910 onde informar³±±
±±³          |            especie da  NF                                        ³±±
±±³          | cSerie  = Variavel Padrão da Rotina MATA103/MATA910 onde informar³±±
±±³          |            Serie da NF                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ _lRet    = True ou False para Serie da Nota Fiscal               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACOM - MATA103/MATA910                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
User Function VldEspSF1() 

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | Declaração de Variaveis                      |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lRet    := .T.
Local _alfa    := "a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p/q/r/s/t/u/v/w/x/y/z/A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P/Q/R/S/T/U/V/W/X/Y/Z/"
Local _cRotina := "MATA103/MATA910"
Local _aSerie  := {}
Local _nX      := 0
Local _nY      := 0


// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | Iniciando validação                          |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Essa validação só ocorrera se estive variavel cESPECIE / cSerie tambem a Rotina esta sendo executado.
If Type("cESPECIE") <> "U" .And. Type("cSerie") <> "U" .And. FUNNAME()$_cRotina 
  
  
  //Valida se Especie da NF se atende nossa regra
	If Alltrim(cESPECIE)$("SPED/CTE")

        AAdd( _aSerie,SubStr(cSerie,1,1) )
        AAdd( _aSerie,SubStr(cSerie,2,1) )
        AAdd( _aSerie,SubStr(cSerie,3,1) )

        For _nX := 1 To Len(_aSerie)
            //Valida se seire da NF se atende nossa regra
	    	If!(Alltrim(_aSerie[_nX])$_alfa)        
                _lRet := .T.
                ElseIf Empty(_aSerie[_nX])
                        Conout("pula array VldEspSF1")
	    	Else
                _lRet := .F.
                MsgBox("Para especie SPED/CTE o conteudo não poderá ser Alfabetico!","Atenção","STOP")
                cSerie := Space(3)
                Exit
		    EndIf
        Next _nX
	EndIf


        //Valida se Especie da NF se atende nossa regra
	If Alltrim(cESPECIE)$("/NFSE/NFS/")
            
        AAdd( _aSerie,SubStr(cSerie,1,1) )
        AAdd( _aSerie,SubStr(cSerie,2,1) )
        AAdd( _aSerie,SubStr(cSerie,3,1) )

        For _nY := 1 To Len(_aSerie)

            //Valida se seire da NF se atende nossa regra
	        If Alltrim(_aSerie[_nY])$_alfa
                        _lRet := .T.
                ElseIf Empty(_aSerie[_nY])
                        Conout("pula array VldEspSF1")
	        Else
                        _lRet := .F.
                        MsgBox("Para especie NFSe/NFS o conteudo deverá ser Alfabetico!","Atenção","STOP")
                         cSerie := Space(3)
                Exit
	        EndIf
        Next _nY
	EndIf
EndIf

_aSerie :={}

Return(_lRet)
