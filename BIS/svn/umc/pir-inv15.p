/** 
    Copyright: ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (C) 2011 
     Filename: pir-inv15.p
      Comment: ��� ������ਧ�樨 ������� �������� �।�� �� ���ﭨ� �� �������� ����
       Launch: �� -> ��� -> �� -> ����⮪� -> ��㧥� ����祪 ctrl+g (��� � ���⠬ �⭮襭�� �� ����� :) ) -> ���15 ��� ������ਧ�樨 ���.���.�।��
   Parameters: 
         Uses:
      Used by:
      Created: ��⮢ �.�., 02.11.2011 
<���_ࠡ�⠥�> : �� �� ������ ���� ������� ���⪨ �� ᫥�. ᨭ�. ��⠬:
		������ ���죨: 20202810200000000001,20202840500000000001,
				 20202978100000000001 (⮫쪮 ����樮���� ����)
				+����樮���� ����:
				20202810800000000003,20202840100000000003,20202978700000000003 
		����� �㬠��: 90803 + ९�
		�������: 91202
		������: 91207
*/

{globals.i}
{sh-defs.i}
{getdate.i}
{get-bankname.i}
{tmprecid.def &pref = g }

DEF VAR Cash_acct     AS CHAR NO-UNDO.
DEF VAR Ost_cash_rub  AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_cash_usd  AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_cash_eur  AS DEC INIT 0 NO-UNDO.

DEF VAR Ost_cash_usd_eq  AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_cash_eur_eq  AS DEC INIT 0 NO-UNDO.
                             
DEF VAR tmpstr  AS CHAR Extent 2 NO-UNDO.
DEF VAR Ost_cash_rub_str  AS CHAR  NO-UNDO.
DEF VAR Ost_cash_usd_str  AS CHAR  NO-UNDO.
DEF VAR Ost_cash_eur_str  AS CHAR  NO-UNDO.

DEF VAR Ost_90803_rub AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_90803_usd AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_90803_eur AS DEC INIT 0 NO-UNDO.

DEF VAR Ost_91202_rub AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_91202_usd AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_91202_eur AS DEC INIT 0 NO-UNDO.

DEF VAR Ost_91207_rub AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_91207_usd AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_91207_eur AS DEC INIT 0 NO-UNDO.

DEF VAR Ost_All_rub AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_All_rub_str AS CHAR NO-UNDO.

/*
FORM TypeBcl WITH FRAME fr1.
*/

Cash_acct = "20202810200000000001,20202840500000000001,20202978100000000001,20202810800000000003,20202840100000000003,20202978700000000003" .


{setdest.i}

		/* ������ ���죨 */

FOR EACH acct WHERE CAN-DO(Cash_acct,acct.acct)
NO-LOCK:

  IF acct.currency <> "" THEN
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-val) > 0 AND acct.currency = "840" THEN
	DO:
        Ost_cash_usd = Ost_cash_usd + ABS(sh-val).    
        Ost_cash_usd_eq = Ost_cash_usd_eq + ABS(sh-bal).    
	END. 	
     IF ABS(sh-val) > 0 AND acct.currency = "978" THEN
	DO:
        Ost_cash_eur = Ost_cash_eur + ABS(sh-val).     	
        Ost_cash_eur_eq = Ost_cash_eur_eq + ABS(sh-bal).     	
	END.
  END.	
  ELSE
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_cash_rub = Ost_cash_rub + ABS(sh-bal).     	
  END.

END.


		/* ����� �㬠�� */

FOR EACH acct WHERE acct.acct begins "90803"
NO-LOCK:

  IF acct.currency <> "" THEN
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-val) > 0 AND acct.currency = "840" THEN
        Ost_90803_usd = Ost_90803_usd + ABS(sh-val).     	
     IF ABS(sh-val) > 0 AND acct.currency = "978" THEN
        Ost_90803_eur = Ost_90803_eur + ABS(sh-val).     	
  END.	
  ELSE
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_90803_rub = Ost_90803_rub + ABS(sh-bal).     	
  END.

END.


		/* ������� */

FOR EACH acct WHERE acct.acct begins "91202"
NO-LOCK:

  IF acct.currency <> "" THEN
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-val) > 0 AND acct.currency = "840" THEN
        Ost_91202_usd = Ost_91202_usd + ABS(sh-val).     	
     IF ABS(sh-val) > 0 AND acct.currency = "978" THEN
        Ost_91202_eur = Ost_91202_eur + ABS(sh-val).     	
  END.	
  ELSE
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_91202_rub = Ost_91202_rub + ABS(sh-bal).     	
  END.

END.



		/* ������ */

FOR EACH acct WHERE acct.acct begins "91207"
NO-LOCK:

  IF acct.currency <> "" THEN
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-val) > 0 AND acct.currency = "840" THEN
        Ost_91207_usd = Ost_91207_usd + ABS(sh-val).     	
     IF ABS(sh-val) > 0 AND acct.currency = "978" THEN
        Ost_91207_eur = Ost_91207_eur + ABS(sh-val).     	
  END.	
  ELSE
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_91207_rub = Ost_91207_rub + ABS(sh-bal).     	
  END.

END.


PUT UNFORM "                                                                                  �����஢����� �ଠ � ���-15 " SKIP. 
PUT UNFORM "                                               �⢥ত����� ���⠭�������� ��᪮���� ���ᨨ �� 18.08.1998 � 88 " SKIP. 
PUT UNFORM "                                                                                                    ------------ " SKIP. 
PUT UNFORM "                                                                                                    |    ���   |  " SKIP.
PUT UNFORM "                                                                                                    |----------| " SKIP.
PUT UNFORM "                                                                                      ��ଠ �� ���� | 0317013  | " SKIP.
PUT UNFORM "                                                                                                    |----------| " SKIP.
PUT UNFORM " ���� �� " + STRING(cBankName,"x(25)") + "                                                       �� ���� | 29287152 | " SKIP.
PUT UNFORM "                                                                                                    |----------| " SKIP.
PUT UNFORM  STRING(cBankName,"x(25)") + "                                                                        | 29287152 | " SKIP.
PUT UNFORM "                                                                                                    |----------| " SKIP.
PUT UNFORM "                                                                                   ��� ���⥫쭮�� |          | " SKIP.
PUT UNFORM "                                                                                         -----------|----------| " SKIP.
PUT UNFORM "                            �᭮����� ���         �ਪ��, ���⠭�������, �ᯮ�殮���    | �����    |          |" SKIP.
PUT UNFORM "                            �஢������        ------------------------------------------------------|----------| " SKIP.
PUT UNFORM "                            ������ਧ�樨:               (���㦭�� ���ભ���)          | ���     |          |" SKIP.
PUT UNFORM "                                                                                         -----------|----------| " SKIP.
PUT UNFORM "                                                                                       ��� ����樨 |          | " SKIP.
PUT UNFORM "                                                                                                    ------------ " SKIP.
PUT UNFORM "                                                                                      -------------------------- " SKIP.
PUT UNFORM "                                                                                      |�����  |   ���     |   | " SKIP.
PUT UNFORM "                                                                                      |���-� |   ���-�   |   | " SKIP.
PUT UNFORM "                                                                                      |------------------------| " SKIP.
PUT UNFORM "                                                                                      |       | " (end-date + 1) FORMAT "99/99/9999" " |   | " SKIP.
PUT UNFORM "                                                                                      -------------------------- " SKIP.
PUT UNFORM "                                                        ��� " SKIP.
PUT UNFORM "                                     ������ਧ�樨 ������� �������� �।��," SKIP.
PUT UNFORM "                                     ��室����� �� ���ﭨ� �� " (end-date + 1) FORMAT "99.99.9999" " �." SKIP.
PUT UNFORM "" SKIP(1).
PUT UNFORM "                                                      ��������" SKIP.
PUT UNFORM "   � ��砫� �஢������ ������ਧ�樨 �� ��室�� � ��室�� ���㬥��� �� ������� �।�⢠ ᤠ��  " SKIP. 
PUT UNFORM " � ��壠���� � �� ������� �।�⢠, ࠧ�� 業���� � ���㬥���, ����㯨�訥 �� ��� �⢥��⢥������," SKIP.
PUT UNFORM " ���室�����, � ���訥 ᯨᠭ� � ��室." SKIP.
PUT UNFORM "" SKIP.
PUT UNFORM " ���ਠ�쭮 �⢥��⢥���� ���: ____________________      _______________      _______________________________" SKIP.
PUT UNFORM "                                     (���������)              (�������)               (����஢�� ������)    " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "           ��� ��⠢��� �����ᨥ�, ����� ��⠭����� ᫥���饥:                                              " SKIP.
PUT UNFORM "                                                                                                               " SKIP.

IF Ost_cash_rub > 0 THEN
PUT UNFORM "          1) ������� �����    �㡫��:  " TRUNCATE(Ost_cash_rub,0)   " ��" (Ost_cash_rub - TRUNCATE(Ost_cash_rub,0) )   " ���. " SKIP.
IF Ost_cash_usd > 0 THEN                           
PUT UNFORM "                             ����.���:  " TRUNCATE(Ost_cash_usd_eq,0)   " ��" (Ost_cash_usd_eq - TRUNCATE(Ost_cash_usd_eq,0) )   " ���. " SKIP.
IF Ost_cash_eur > 0 THEN                           
PUT UNFORM "                                 ���:  " TRUNCATE(Ost_cash_eur_eq,0)   " ��" (Ost_cash_eur_eq - TRUNCATE(Ost_cash_eur_eq,0) )   " ���. " SKIP.

IF Ost_90803_rub > 0 THEN
PUT UNFORM "          2) 業��� �㬠�        " TRUNCATE(Ost_90803_rub ,0) " �� " (Ost_90803_rub - TRUNCATE(Ost_90803_rub,0) ) " ���. " SKIP.
IF Ost_90803_usd > 0 THEN
PUT UNFORM "                                 " Ost_90803_usd " ����.���  " SKIP.
IF Ost_90803_eur > 0 THEN
PUT UNFORM "                                 " Ost_90803_eur " ���      " SKIP.

IF Ost_91202_rub > 0 THEN
PUT UNFORM "          3) 業����            " TRUNCATE(Ost_91202_rub ,0) " �� " (Ost_91202_rub - TRUNCATE(Ost_91202_rub,0) ) " ���. " SKIP.
IF Ost_91202_usd > 0 THEN
PUT UNFORM "                                 " Ost_91202_usd " ����.���  " SKIP.
IF Ost_91202_eur > 0 THEN
PUT UNFORM "                                 " Ost_91202_eur " ���      " SKIP.

IF Ost_91207_rub > 0 THEN
PUT UNFORM "          4) ������              " TRUNCATE(Ost_91207_rub ,0) " �� " (Ost_91207_rub - TRUNCATE(Ost_91207_rub,0) ) " ���. " SKIP.
IF Ost_91207_usd > 0 THEN
PUT UNFORM "                                 " Ost_91207_usd " ����.���  " SKIP.
IF Ost_91207_eur > 0 THEN
PUT UNFORM "                                 " Ost_91207_eur " ���      " SKIP.

PUT UNFORM  SKIP(1).

Ost_All_rub = Ost_cash_rub + Ost_cash_usd_eq + Ost_cash_eur_eq + Ost_90803_rub + Ost_91202_rub + Ost_91207_rub .

RUN x-amtstr.p(dec(Ost_All_rub),"",true,true, output tmpstr[1], output tmpstr[2]).
Ost_All_rub_str = tmpstr[1] + " " + tmpstr[2].


PUT UNFORM "          �⮣� 䠪��᪨ ����稥 �� �㬬 " TRUNCATE(Ost_All_rub,0)   " ��" (Ost_All_rub - TRUNCATE(Ost_All_rub,0) )   " ���. " SKIP.
PUT UNFORM "     " Ost_All_rub_str  SKIP.
PUT UNFORM "                                             (�ய����)                                                        " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "          �� ���� ����� �� �㬬� " TRUNCATE(Ost_All_rub,0)   " ��" (Ost_All_rub - TRUNCATE(Ost_All_rub,0) )   " ���. " SKIP. 
PUT UNFORM "     " Ost_All_rub_str  SKIP.
PUT UNFORM "                                             (�ய����)                                                        " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "     �������� ������ਧ�樨: ����襪   __________________________________ ��. ______________���.           " SKIP.
PUT UNFORM "                                ������� __________________________________ ��. ______________���.           " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "     ��᫥���� ����� ���ᮢ�� �थ஢ ��室���� � ____________________,                                      " SKIP.
PUT UNFORM "                                       ��室���� � ____________________                                       " SKIP.
PUT UNFORM "                                                                                                               " SKIP.



PUT UNFORM "    �।ᥤ�⥫� �����ᨨ  _______________      _________________       _______________________________________" SKIP.
PUT UNFORM "                             (���������)              (�������)                  (����஢�� ������)         " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "    ����� �����ᨨ         _______________      _________________       _______________________________________" SKIP.
PUT UNFORM "                             (���������)              (�������)                  (����஢�� ������)         " SKIP.
PUT UNFORM "                           _______________      _________________       _______________________________________" SKIP.
PUT UNFORM "                             (���������)              (�������)                  (����஢�� ������)         " SKIP.
PUT UNFORM "                           _______________      _________________       _______________________________________" SKIP.
PUT UNFORM "                             (���������)              (�������)                  (����஢�� ������)         " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM " ���⢥ত��, �� ������� �।�⢠, ����᫥��� � ���, ��室���� �� ���� �⢥��⢥���� �࠭����.           " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM " ���ਠ�쭮 �⢥��⢥���� ���: ____________________      _______________      _______________________________" SKIP.
PUT UNFORM "                                     (���������)              (�������)             (����஢�� ������)      " SKIP.
PUT UNFORM "  ''___'' __________ _____ �.                                                                                  " SKIP.
PUT UNFORM "                                                                                                               " SKIP.

/*PAGE.*/

PUT UNFORM "   ����᭥��� ��稭 ����誮� ��� ������� ____________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM " ���ਠ�쭮 �⢥��⢥���� ���: ____________________      _______________      _______________________________" SKIP.
PUT UNFORM "                                     (���������)              (�������)             (����஢�� ������)      " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ��襭�� �㪮����⥫� �࣠����樨 ___________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "      _________________________     ______________________      _______________________________________________" SKIP.
PUT UNFORM "             (���������)                   (�������)                           (����஢�� ������)           " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "     ''___''__________ _____ �.                                                                                " SKIP.

                                                                                                                           
                                                                                                                           
{preview.i}                                                                                                                
                                                                                                                           
                                                                                                                           
                                                                                                                           