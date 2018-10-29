/** 
    Copyright: ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (C) 2011 
     Filename: pir-inv11.p
      Comment: ��� ������ਧ�樨 ������� �������� �।�� �� ���ﭨ� �� �������� ����
       Launch: �� -> ��� -> �� -> ����⮪� -> ��㧥� ����祪 ctrl+g (��� � ���⠬ �⭮襭�� �� ����� :) ) -> ���11 ��� ������ਧ�樨 ��室�� ����� ��ਮ���
   Parameters: 
         Uses:
      Used by:
      Created: ��⮢ �.�., 03.11.2011 
<���_ࠡ�⠥�> : 
	������ ��ਮ� �६���.
	�⡨ࠥ� �� ��� 61403, � ������ ��� ������� �� ��⠭������ ���� ����� �������� ����.
	��।��塞 ���� ��ࢮ�� ��室� �� �⮡࠭��� ����.
	�᫨ ��室 ��, � ��।��塞 ���⮪ �� ���� ��室� (������� 4). ���� � ��� ������ਧ�樨 ��� �� �������.
	�᫨ ����祭�� ���⮪ ����� 0, � ��।��塞 ���⮪ �� ������� ���� ��������� ��ਮ�� (������� 9, 13). ���� � ��� ������ਧ�樨 ��� �� �������.
	�᫨  ���⮪ �� ������� ���� ��������� ��ਮ�� ����� 0, ��⠥� ������� 8. ���� � ��� ������ਧ�樨 ��� �� �������.
	������� 8 = (������� 4) - (������� 13)
*/


{globals.i}
{sh-defs.i}
{getdates.i}
{get-bankname.i}

DEF VAR count AS INT INIT 0 NO-UNDO.

DEF VAR Ost_61403_beg AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_61403_end AS DEC INIT 0 NO-UNDO.

DEF VAR DB_ob AS DEC INIT 0 NO-UNDO.
DEF VAR start_date AS DATE NO-UNDO.
DEF VAR count_op AS INT INIT 0 NO-UNDO.

def var act as char  NO-UNDO.

DEFINE  TEMP-TABLE rep-pp NO-UNDO
   FIELD nmbr     AS INT
   FIELD act-name AS CHAR  
   FIELD act-num  AS CHAR  
   FIELD amt4      AS DEC  
   FIELD amt8      AS DEC  
   FIELD amt9      AS DEC  
   FIELD amt13     AS DEC  
   INDEX nmbr act-num    
.


DEF VAR All_amt4    AS DEC INIT 0 NO-UNDO.
DEF VAR All_amt8    AS DEC INIT 0 NO-UNDO.
DEF VAR All_amt9    AS DEC INIT 0 NO-UNDO.
DEF VAR All_amt13   AS DEC INIT 0 NO-UNDO.



{setdest.i}

		/* 61403 */

FOR EACH acct WHERE acct.acct begins "61403" /*"61403810200000000092"*/
     AND (acct.close-date =? OR acct.close-date >= end-date )
NO-LOCK:

     DB_ob = 0 .
     Ost_61403_beg = 0.
     Ost_61403_end = 0.
     start_date = beg-date.
     count_op = 0 .

     FOR EACH op-entry WHERE ( op-entry.op-date >= beg-date AND op-entry.op-date <= end-date)
        AND op-entry.acct-db = acct.acct
     NO-LOCK:
	DB_ob = DB_ob + op-entry.amt-rub.
        count_op = count_op + 1.
        IF count_op = 1 THEN
           start_date = op-entry.op-date . /* ��� ��ࢮ� �஢���� */
     END.

     RUN acct-pos IN h_base (acct.acct, acct.currency,start_date,start_date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_61403_beg = ABS(sh-bal).     	

     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_61403_end = ABS(sh-bal).     	


     IF     Ost_61403_beg > 0  AND Ost_61403_end > 0  AND DB_ob > 0 THEN
     DO:

	count =  count + 1 .

        CREATE rep-pp.
        ASSIGN
            nmbr =  count     
            act-name = acct.details 
            act-num  = acct.acct
            amt4  = Ost_61403_beg    
            amt8  = Ost_61403_beg - Ost_61403_end    
            amt9  = Ost_61403_end    
            amt13 = Ost_61403_end    
        .

/*
message acct.acct " | " rep-pp.act-num " | " count " | " rep-pp.nmbr  view-as alert-box.
*/

/*	
   PUT UNFORM acct.details format "x(50)" " | " acct.acct " | Ost_beg = " Ost_61403_beg FORMAT "->,>>>,>>9.99" " | Ost_end = " Ost_61403_end FORMAT "->,>>>,>>9.99" " count = " count /* " | DB_ob= " DB_ob */  SKIP.
*/


     END.

END.
                                                                                                                           

PUT UNFORM "                                                                                          �����஢����� �ଠ N ���-11 " SKIP .
PUT UNFORM "                                                           �⢥ত��� ���⠭�������� ��᪮���� ���ᨨ �� 18.08.98 N 88 " SKIP .
PUT UNFORM "                                                                                                            ����������Ŀ " SKIP .
PUT UNFORM "                                                                                                            ����       � " SKIP .
PUT UNFORM "                                                                                                            ����������Ĵ " SKIP .
PUT UNFORM "                                                                                              ��ଠ �� ���� � 0317012  � " SKIP .
PUT UNFORM "                                                                                                            ����������Ĵ " SKIP .
PUT UNFORM " ���� �� " + STRING(cBankName,"x(25)") + "                                                                �� ���� � 29287152 � " SKIP.
PUT UNFORM "                                                                                                            ����������Ĵ " SKIP .
PUT UNFORM STRING(cBankName,"x(25)") + "                                                                                  � 29287152 � " SKIP .
PUT UNFORM "                                                                                                            ����������Ĵ " SKIP .
PUT UNFORM "                                                                                           ��� ���⥫쭮�� �          � " SKIP .
PUT UNFORM "                                                                                                 ���������������������Ĵ " SKIP .
PUT UNFORM "                                    �᭮����� ���         �ਪ��, ���⠭�������, �ᯮ�殮���    � �����    �          � " SKIP .
PUT UNFORM "                                    �஢������        ����������������������������������������������������������������Ĵ " SKIP .
PUT UNFORM "                                    ������ਧ�樨:               ���㦭�� ���ભ���            � ���     �          � " SKIP .
PUT UNFORM "                                                                                                 ���������������������Ĵ " SKIP .
PUT UNFORM "                                                                                 ��� ��砫� ������ਧ�樨 �          � " SKIP .
PUT UNFORM "                                                                                                            ����������Ĵ " SKIP .
PUT UNFORM "                                                                              ��� ����砭�� ������ਧ�樨 �          � " SKIP .
PUT UNFORM "                                                                                                            ����������Ĵ " SKIP .
PUT UNFORM "                                                                                               ��� ����樨 �          � " SKIP .
PUT UNFORM "                                                                                                            ������������ " SKIP .
PUT UNFORM "                                                                                                   �������������������Ŀ " SKIP .
PUT UNFORM "                                                                                                   ������  �   ���    � " SKIP .
PUT UNFORM "                                                                                                   ����-� �   ���-�  � " SKIP .
PUT UNFORM "                                                                                                   �������������������Ĵ " SKIP .
PUT UNFORM "                                                                                                   �       �" today FORMAT "99/99/9999" " � " SKIP .
PUT UNFORM "                                                                                                   ��������������������� " SKIP .
PUT UNFORM "                                                                ���                                                      " SKIP .
PUT UNFORM "                                                                                                                         " SKIP .
PUT UNFORM "                                             ������ਧ�樨 ��室�� ����� ��ਮ���" SKIP .
PUT UNFORM "" SKIP .
PUT UNFORM "                 ��� ��⠢��� �����ᨥ� � ⮬, �� ���⠢���� �� " end-date FORMAT "99/99/9999" " �. �஢����� ������ਧ��� ��室�� ����� ��ਮ���." SKIP .
PUT UNFORM "" SKIP .
PUT UNFORM "�� ������ਧ�樨 ��⠭������ ᫥���饥:" SKIP .
PUT UNFORM "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ " SKIP .
PUT UNFORM "���- �                                                    � ���� (���-�           �           �           �  ���ᠭ�  ����⮪ ���-����-�� �    �������� ᯨᠭ�� ��      ������� ���-�  �������� ������ਧ�樨    � " SKIP .
PUT UNFORM "���� �                   ��� ��室��                     ������) �㬬��   ���    �   �ப    �  �����. � (����襭�)���� �� ��砫� �����楢�  ᥡ��⮨����� �த�樨     �⮪ ��室��,  �          ��.���.             � " SKIP .
PUT UNFORM "���  �                                                    �  ��室��  � ��������- � ����襭�� �  �㬬� �  �  ��室�� �������ਧ. ���� ��� �          ��.���.            ��������騩 ��- �������������������������������Ĵ " SKIP .
PUT UNFORM "���- �                                                    �  �����   �  �����    � ��室��  �  ᯨᠭ�� � �� ��砫� ������ ���  �������.�                              ���襭�� � ���-�               �����譥 ᯨᠭ�� " SKIP .
PUT UNFORM "���-����������������������������������������������������Ĵ  ��ਮ���  � ��室��  �(� ������)� ��室��  � �������. �              ����- ������������������������������Ĵ 饬 ��ਮ��   �    ��������   �   (��������   � " SKIP .
PUT UNFORM "���  �              ������������              �    ���    �  ��.���.  �           �           � ��.���.  �  ��.���. �  ��.���.�.  � ���   �   �� �����    � � ��砫� �����  ��.���.     �   ��ᯨᠭ��  �����⠭�������)� " SKIP .
PUT UNFORM "�    �                                        �           �            �           �           �           �           �              �       �               �              �               �               �               � " SKIP .
PUT UNFORM "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ " SKIP .
PUT UNFORM "� 1  �                    2                   �     3     �     4      �     5     �     6     �     7     �     8     �       9      �  10   �      11       �       12     �       13      �      14       �       15      � " SKIP .
PUT UNFORM "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ " SKIP . /*�६����� ���� � ����஬ ���" SKIP .*/


FOR EACH rep-pp NO-LOCK:

    PUT UNFORM  
        "�"
        rep-pp.nmbr FORMAT "->99" "�" 
        rep-pp.act-name format "x(40)" "�" 
        FILL(" ",11) "�" /*3*/
        rep-pp.amt4 FORMAT "->>>,>>99.99" "�" 
        FILL(" ",11) "�" /*5*/
        FILL(" ",11) "�" /*6*/
        FILL(" ",11) "�" /*7*/        
        rep-pp.amt8 FORMAT "->>>,>>9.99" "�" 
        rep-pp.amt9 FORMAT "->,>>>,>>9.99" " �" 
        FILL(" ",7)  "�" /*10*/
        FILL(" ",15) "�" /*11*/
        FILL(" ",14) "�" /*12*/
        rep-pp.amt13 FORMAT "->>,>>>,>>9.99" " �" 
        FILL(" ",15) "�" /*14*/
        FILL(" ",15) "�" /*15*/
        /* " " rep-pp.act-num " | " */
    SKIP.

/* ������뢠�� �㬬� */

    All_amt4   = All_amt4  + rep-pp.amt4  .
    All_amt8   = All_amt8  + rep-pp.amt8  .
    All_amt9   = All_amt9  + rep-pp.amt9  .
    All_amt13  = All_amt13 + rep-pp.amt13 .

    PUT UNFORM "����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ " SKIP .

END.


PUT UNFORM "                                              �  �����    �" All_amt4 FORMAT "->>>,>>99.99" "�     �     �     �     �           �" All_amt8 FORMAT "->>>,>>9.99" "�" All_amt9 FORMAT "->,>>>,>>9.99" " �       �               �              �" All_amt13 FORMAT "->>,>>>,>>9.99" " �               �               � " SKIP .
PUT UNFORM "                                              �������������������������������������������������������������������������������������������������������������������������������������������������������������������������������� " SKIP .

PUT UNFORM "      �� ������� �⮣�� �� ��ப��, ��࠭�栬 � � 楫�� �� ���� ������ਧ�樨 �஢�७�. " SKIP.                                           
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "        �।ᥤ�⥫� �����ᨨ    ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                     (���������)                      (�������)                           (����஢�� ������)                " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "        ����� �����ᨨ           ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                     (���������)                      (�������)                           (����஢�� ������)                " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "                                 ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                     (���������)                      (�������)                           (����஢�� ������)                " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "                                 ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                     (���������)                      (�������)                           (����஢�� ������)                " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "      �� 業����, ������������ � �����饬 ��� ������ਧ�樨 � � _______ �� � ________, �����ᨥ� �஢�७� � ����� � ���� (��襬)       " SKIP .
PUT UNFORM "                                                                                                                                               " SKIP .
PUT UNFORM "������⢨� � ���ᥭ� � ���, � �裡 � 祬 ��⥭��� � ������ਧ�樮���� �����ᨨ �� ���� (�� �����).                                                " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "�������, ����᫥��� � ���, ��室���� �� ���� (��襬) �⢥��⢥���� �࠭����.                                                                     " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "���ਠ�쭮 �⢥��⢥����(�) ���(�):  ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                            (���������)                   (�������)                             (����஢�� ������)                 " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "                                        ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                            (���������)                   (�������)                             (����஢�� ������)                 " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "                                        ____________________         ____________________         ___________________________________________________ " SKIP .
PUT UNFORM "                                            (���������)                    (�������)                            (����஢�� ������)                 " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "                                                              ''___'' __________ _____ �.                                                             " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "�������� � �����饬 ��� ����� � ����� �஢�ਫ ____________________         ____________________    ___________________________________________ " SKIP .
PUT UNFORM "                                                          (���������)                  (�������)                      (����஢�� ������)           " SKIP .
PUT UNFORM "                                                                                                                                                      " SKIP .
PUT UNFORM "                                                              ''___'' __________ _____ �.                                                             " SKIP .


                                                                                                                          
{preview.i}                                                                                                                
                                                                                                                           
                                                                                                                           
                                                                                                                           