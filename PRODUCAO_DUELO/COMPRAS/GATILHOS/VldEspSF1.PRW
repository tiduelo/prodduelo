#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Rotina    | VldEspSF1 �Autor � Rafael Cruz - SURY Solu��es  |Data � 05/02/21 ���
�������������������������������������������������������������������������������Ĵ��
���Descri�ao | Valida��o da Serie informada na inclus�o da Nota de Entrada****   ��
�������������������������������������������������������������������������������Ĵ��
���Parametros� cESPECIE= Variavel Padr�o da Rotina MATA103/MATA910 onde informar���
���          |            especie da  NF                                        ���
���          | cSerie  = Variavel Padr�o da Rotina MATA103/MATA910 onde informar���
���          |            Serie da NF                                           ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � _lRet    = True ou False para Serie da Nota Fiscal               ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � SIGACOM - MATA103/MATA910                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������
������������������������������*/
User Function VldEspSF1() 

// ����������������������������������������������Ŀ
// | Declara��o de Variaveis                      |
// ������������������������������������������������
Local _lRet    := .T.
Local _alfa    := "a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p/q/r/s/t/u/v/w/x/y/z/A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P/Q/R/S/T/U/V/W/X/Y/Z/"
Local _cRotina := "MATA103/MATA910"
Local _aSerie  := {}
Local _nX      := 0
Local _nY      := 0


// ����������������������������������������������Ŀ
// | Iniciando valida��o                          |
// ������������������������������������������������

//Essa valida��o s� ocorrera se estive variavel cESPECIE / cSerie tambem a Rotina esta sendo executado.
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
                MsgBox("Para especie SPED/CTE o conteudo n�o poder� ser Alfabetico!","Aten��o","STOP")
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
                        MsgBox("Para especie NFSe/NFS o conteudo dever� ser Alfabetico!","Aten��o","STOP")
                         cSerie := Space(3)
                Exit
	        EndIf
        Next _nY
	EndIf
EndIf

_aSerie :={}

Return(_lRet)
