{pirsavelog.p}
/** 
   ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2009

   ��ꥬ �।�⭮�� ����䥫� �� ����.
   ���ᮢ �.�., 10.09.2010
*/

{globals.i}           /* �������� ��।������ */
{intrface.get i254}
{sh-defs.i}

/******************************************* ��।������ ��६����� � ��. */

DEFINE VARIABLE cMAcct1   AS CHARACTER EXTENT  7 NO-UNDO.
DEFINE VARIABLE cMAcct2   AS CHARACTER EXTENT 10 NO-UNDO.
ASSIGN
   cMAcct1[2] = "!45415*,!45515*,!45315*,!45715*,454*,455*,453*,457*,45815*,45817*"
   cMAcct1[3] = "!45115*,!45215*,!45615*,451*,452*,456*,45811*,45812*,45813*,45814*,45816*"
   cMAcct1[4] = "!32015*,!32115*,!32215*,!32315*,!32415*,320*,321*,322*,323*,324*"
   cMAcct1[5] = "47423*"
   cMAcct1[6] = "!51415*,!51515*,514*,515*"
   cMAcct1[7] = "!50219*,!50319*,501*,502*,503*"

   cMAcct2[1] = "45101*,45201*,45301*,45401*,45509*,45608*,45708*"
   cMAcct2[2] = "45109*,45209*,45309*,45409*,45508*"
   cMAcct2[3] = "45103*,45203*,45303*,45403*,45502*,45601*,45701*"
   cMAcct2[4] = "45104*,45204*,45304*,45404*,45503*,45602*,45702*"
   cMAcct2[5] = "45105*,45205*,45305*,45405*,45504*,45603*,45703*"
   cMAcct2[6] = "45106*,45206*,45306*,45406*,45505*,45604*,45704*"
   cMAcct2[7] = "45107*,45207*,45307*,45407*,45506*,45605*,45705*"
   cMAcct2[8] = "45108*,45208*,45308*,45408*,45507*,45606*,45706*"
   cMAcct2[9] = "45811*,45812*,45813*,45814*,45815*,45816*,45817*"
   cMAcct2[10] = "47423*"
   NO-ERROR.

DEFINE VARIABLE dSumm     AS DECIMAL   EXTENT 10 NO-UNDO.
DEFINE VARIABLE dSRisk    AS DECIMAL   EXTENT  6 NO-UNDO INIT 0.
DEFINE VARIABLE grrisk    AS INTEGER   NO-UNDO.
DEFINE VARIABLE prrisk    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iI        AS INTEGER   NO-UNDO.
DEFINE VARIABLE cTmp      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lNoLoan   AS LOGICAL   NO-UNDO.

/******************************************* ��������� */
{getdate.i}
{setdest.i}

dSumm[1] = 0.
DO iI = 2 TO 7:

   dSumm[iI] = 0.

   FOR EACH acct
      WHERE CAN-DO(cMAcct1[iI], acct.acct)
        AND ((acct.close-date   EQ ?)
          OR (acct.close-date   GE end-date))
      NO-LOCK:

      RUN acct-pos IN h_base(acct.acct, acct.currency, end-date, end-date, cTmp).
      dSumm[iI] = dSumm[iI] + sh-in-bal.

      lNoLoan = YES.
      FOR FIRST loan-acct
         WHERE (loan-acct.acct     EQ acct.acct)
           AND (loan-acct.currency EQ acct.currency)
         NO-LOCK,
         FIRST loan OF loan-acct
         NO-LOCK:

         prrisk = LnRsrvRate(loan.contract, loan.cont-code, end-date).
         grrisk = LnGetGrRiska(prrisk, end-date).
         dSRisk[grrisk] = dSRisk[grrisk] + sh-in-bal.
         lNoLoan = NO.
      END.

      IF lNoLoan
      THEN DO:

         cTmp   = SUBSTRING(GetXAttrValue("acct", acct.acct + "," + acct.currency, "����᪠"), 1, 1).
         grrisk = INTEGER(cTmp) NO-ERROR.

         IF    ERROR-STATUS:ERROR
            OR (grrisk EQ 0)
         THEN DO:
/*
            PUT UNFORMATTED
               "No GrRisk " acct.acct SKIP.
*/
            dSRisk[6] = dSRisk[6] + sh-in-bal.
         END.
         ELSE
            dSRisk[grrisk] = dSRisk[grrisk] + sh-in-bal.
      END.
   END.

   dSumm[1] = dSumm[1] + dSumm[iI].
END.

PUT UNFORMATTED
   "                 ��ꥬ �।�⭮�� ����䥫� �� " STRING(end-date, "99.99.9999")  SKIP(1)
   "����������������������������������������������������������������������������Ŀ" SKIP
   "�             ������������             �   �㬬� ���⪮�   ����� � �।�⭮��" SKIP
   "�                                      �                    �  ����䥫�, %%  �" SKIP
   "����������������������������������������������������������������������������͵" SKIP
   "�1. ��ꥬ �।�⭮�� ����䥫�          �"
      dSumm[1] FORMAT " ->>,>>>,>>>,>>9.99 �                �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "� � ⮬ �᫥:                         �                    �                �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�2. �।���, �뤠��� 䨧��᪨� ��栬 �"
      dSumm[2] FORMAT " ->>,>>>,>>>,>>9.99 �"
     (dSumm[2] * 100.0 / dSumm[1])  FORMAT "       >>9.99   �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�3. �।���, �뤠��� �ਤ��᪨� ��栬�"
      dSumm[3] FORMAT " ->>,>>>,>>>,>>9.99 �"
     (dSumm[3] * 100.0 / dSumm[1]) FORMAT "       >>9.99   �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�4. �뤠��� ���                       �"
      dSumm[4] FORMAT " ->>,>>>,>>>,>>9.99 �"
     (dSumm[4] * 100.0 / dSumm[1]) FORMAT "       >>9.99   �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�5. �ࠢ� �ॡ������                   �"
      dSumm[5] FORMAT " ->>,>>>,>>>,>>9.99 �"
     (dSumm[5] * 100.0 / dSumm[1]) FORMAT "       >>9.99   �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�6. �ਮ��⥭�� ���ᥫ�              �"
      dSumm[6] FORMAT " ->>,>>>,>>>,>>9.99 �"
     (dSumm[6] * 100.0 / dSumm[1]) FORMAT "       >>9.99   �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�7. ��� 業�� �㬠��                 �"
      dSumm[7] FORMAT " ->>,>>>,>>>,>>9.99 �"
     (dSumm[7] * 100.0 / dSumm[1]) FORMAT "       >>9.99   �" SKIP
   "������������������������������������������������������������������������������" SKIP
.

DO iI = 1 TO 10:

   dSumm[iI] = 0.

   FOR EACH acct
      WHERE CAN-DO(cMAcct2[iI], acct.acct)
        AND ((acct.close-date   EQ ?)
          OR (acct.close-date   GE end-date))
      NO-LOCK:

      RUN acct-pos IN h_base(acct.acct, acct.currency, end-date, end-date, cTmp).
      dSumm[iI] = dSumm[iI] + sh-in-bal.
   END.
END.

PUT UNFORMATTED SKIP(3)
   "        ��㯯�஢�� �।�⭮�� ����䥫� �� �ப�� �뤠� �� " STRING(end-date, "99.99.9999")  SKIP
   "                (��� ��� �������� � ��� � 業�� �㬠��)" SKIP(1)
   "����������������������������������������������������������������������������Ŀ" SKIP
   "�             ������������                       �      �㬬� ���⪮�       �" SKIP
   "����������������������������������������������������������������������������͵" SKIP
   "� 1. � ०��� '�������'                        �"
      dSumm[1]   FORMAT  "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "� 2. �� ����ॡ������                            �"
      dSumm[2]   FORMAT  "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "� 3. �� 30 ����                                  �"
      dSumm[3]   FORMAT  "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "� 4. �� 31 �� 90 ����                            �"
      dSumm[4]   FORMAT  "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "� 5. �� 91 �� 180 ����                           �"
      dSumm[5]   FORMAT  "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "� 6. �� 181 �� 1 ����                            �"
      dSumm[6]   FORMAT  "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "� 7. �� 1 ���� �� 3 ���                          �"
      dSumm[7]   FORMAT  "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "� 8. ��� 3 ���                                 �"
      dSumm[8]   FORMAT  "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "� 9. ����祭��� �������������                  �"
      dSumm[9]   FORMAT  "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�10. �ࠢ� �ॡ������                            �"
      dSumm[10]  FORMAT  "     ->>,>>>,>>>,>>9.99    �" SKIP
   "������������������������������������������������������������������������������" SKIP
.

PUT UNFORMATTED SKIP(3)
   "   ��㯯�஢�� �।�⭮�� ����䥫� �� ��⥣��� ����⢠ �� " STRING(end-date, "99.99.9999")  SKIP(1)
   "����������������������������������������������������������������������������Ŀ" SKIP
   "�              ��⥣��� ����⢠                �      �㬬� ���⪮�       �" SKIP
   "����������������������������������������������������������������������������͵" SKIP
   "�                     1-�                        �"
      dSRisk[1]   FORMAT "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�                     2-�                        �"
      dSRisk[2]   FORMAT "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�                     3-�                        �"
      dSRisk[3]   FORMAT "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�                     4-�                        �"
      dSRisk[4]   FORMAT "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�                     5-�                        �"
      dSRisk[5]   FORMAT "     ->>,>>>,>>>,>>9.99    �" SKIP
   "����������������������������������������������������������������������������Ĵ" SKIP
   "�                     ���                        �"
      dSRisk[6]   FORMAT "     ->>,>>>,>>>,>>9.99    �" SKIP
   "������������������������������������������������������������������������������" SKIP
.

{preview.i}
{intrface.del}