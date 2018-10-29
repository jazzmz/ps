{pirsavelog.p}
/** ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007, ���ᮢ �.�.
    ������ �����
    ����᪠���� � ࠡ�祬 ��� �१ ���� Ctrl-G
*/

{globals.i}           /** �������� ��।������ */
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{intrface.get xclass} /** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get strng}  /** �㭪樨 ��� ࠡ��� � ��ப��� */
{ulib.i}              /*  ������⥪� �㭪権 ��� ࠡ��� � ��⠬� */

{leg207p.def}
{sh-defs.i}

/******************************************* ��।������ ��६����� � ��. */
DEF VAR cKOP     AS CHAR EXTENT 5 NO-UNDO.
DEF VAR cId      AS CHAR          NO-UNDO.
DEF VAR cSndName AS CHAR EXTENT 5 NO-UNDO.
DEF VAR cSndAcct AS CHAR          NO-UNDO.
DEF VAR cRsvName AS CHAR EXTENT 5 NO-UNDO.
DEF VAR cRsvAcct AS CHAR          NO-UNDO.
DEF VAR cDelail  AS CHAR EXTENT 5 NO-UNDO.
DEF VAR cT1      AS CHAR          NO-UNDO.
DEF VAR cT2      AS CHAR          NO-UNDO.
DEF VAR cT3      AS CHAR          NO-UNDO.
DEF VAR I        AS INTEGER       NO-UNDO.
DEF VAR daBeg    AS DATE          NO-UNDO.
DEF VAR daEnd    AS DATE          NO-UNDO.
DEF VAR daOtp    AS DATE          NO-UNDO.

&SCOP FILE_sword_p NO
{pirpp-uni.var}                     /* ��।������ ��६�����        */
{pirpp-uni.prg}                     /* ���ᠭ�� �⠭������ ��楤�� */

beg-date = gend-date.
end-date = gend-date.
{getdates.i &TitleLabel = "Interval" &noinit = YES}
daBeg    = beg-date.
daEnd    = end-date.

end-date = end-date + 1.
DO WHILE holiday(end-date):
   end-date = end-date + 1.
END.

{getdate.i  &TitleLabel = "Data otpravki" &noinit = YES}
daOtp = end-date.

{setdest.i} /* �뢮� � preview */

/******************************************* ��������� */
/* ����� ���� */
PUT UNFORMATTED
"                                         ������ ����権, ��������� �~\� �� 321-� �� " STRING(daEnd) SKIP(1)
"��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
"�   ���   �� ���.� ��� ���⥫�騪�   �          ���⥫�騪          �  ��� �����⥫�   �          �����⥫�          �����     �㬬�     �     �㬬�     �           �����祭�� ���⥦�           ��ᯮ���-�   ���    �" SKIP
"� ���㬥�⠳      �      (�����)       �                              �      (�।��)      �                              �����   ��.������   �  ���.������   �                                        �  ⥫�  � ����樨 �" SKIP
.
/*
FOR EACH tmprecid
   NO-LOCK,
   FIRST op
      WHERE RECID(op) EQ tmprecid.id
   NO-LOCK,
   FIRST op-entry OF op
   NO-LOCK:
*/
FOR EACH datablock
   WHERE (datablock.DataClass-Id EQ "Legal321")
     AND (datablock.beg-date     GE daBeg)
     AND (datablock.end-date     LE daEnd)
   NO-LOCK,
   EACH dataline
      WHERE (dataline.Data-Id EQ datablock.Data-Id)
        AND (dataline.Sym2    EQ {&MAIN-LINE})
        AND (DATE(ENTRY(3, dataline.Txt, "~n")) EQ daOtp)
        AND NOT (ENTRY(2, dataline.Sym1, CHR(1)) BEGINS "-USR-")
   NO-LOCK,
   FIRST op
      WHERE (op.op      EQ INTEGER(ENTRY(2, dataline.Sym1, CHR(1))))
   NO-LOCK,
   FIRST op-entry OF op
   NO-LOCK:

   if entry(8,DataLine.txt,CHR(10)) ne "0" then
	   cKOP[1]   = GetXAttrValue("op", STRING(op.op), "��������") + "/" + entry(8,DataLine.txt,CHR(10)). 
   else  cKOP[1]   = GetXAttrValue("op", STRING(op.op), "��������").

   IF (cKOP[1] NE "")
   THEN DO:

      RUN Collection-Info.


      IF    (op.doc-type EQ "03")
         OR (op.doc-type EQ "031")
      THEN DO:
         /* ४������ ���⥫�騪�                     */
         cSndAcct    = op-entry.acct-db.
         IF (cSndAcct BEGINS "20202")
         THEN cSndName[1] = cBankName.
         ELSE cSndName[1] = GetAcctClientName_UAL(cSndAcct, NO).
         /* ४������ �����⥫�                      */
         cRsvAcct    = op-entry.acct-cr.
         IF (cRsvAcct BEGINS "20202")
         THEN cRsvName[1] = cBankName.
         ELSE cRsvName[1] = GetAcctClientName_UAL(cRsvAcct, NO).
      END.
      ELSE DO:
         /* ४������ ���⥫�騪�                     */
         RUN for-pay("�����,����������,������,������,�������", "��",
                     OUTPUT cSndName[1], OUTPUT cSndAcct,
                     OUTPUT cT1, OUTPUT cT2, OUTPUT cT3).
         /* ४������ �����⥫�                      */
         RUN for-rec("������,����������,�������,������,�������", "��",
                     OUTPUT cRsvName[1], OUTPUT cRsvAcct,
                     OUTPUT cT1, OUTPUT cT2, OUTPUT cT3).
      END.

      RUN DelInnKpp(INPUT-OUTPUT cSndName[1]).
      RUN DelInnKpp(INPUT-OUTPUT cRsvName[1]).
      cDelail[1] = op.details.

      {wordwrap.i &s=cSndName &n=5 &l=30}
      {wordwrap.i &s=cRsvName &n=5 &l=30}
      {wordwrap.i &s=cDelail &n=5 &l=40}
      {wordwrap.i &s=cKOP    &n=5 &l=10}

      /* �뢮��� ��ப� ⠡���� */
      PUT UNFORMATTED 
         "��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         "�" op.op-date FORMAT "99.99.9999"
         "�" op.doc-num FORMAT "x(6)"
         "�" cSndAcct FORMAT "x(20)"
         "�" cSndName[1] FORMAT "x(30)"
         "�" cRsvAcct FORMAT "x(20)"
         "�" cRsvName[1] FORMAT "x(30)"
         "�" ENTRY(10, dataline.Txt, "~n")
         "�" (IF ENTRY(10, dataline.Txt, "~n") <> "643" then string(dataline.Val[3],"->>>,>>>,>>9.99") else string(0,"->>>,>>>,>>9.99"))
         "�" dataline.Val[2] FORMAT "->>>,>>>,>>9.99"
         "�" cDelail[1] FORMAT "x(40)"
         "�" op.user-id FORMAT "x(8)"
         "�" cKOP[1] FORMAT "x(10)"
         "�" SKIP.

      DO I = 2 TO 5
         WHILE (cSndName[I] NE "")
            OR (cRsvName[I] NE "")
            OR (cDelail[I]  NE "")
            OR (cKop[I]  NE "")
      :
         PUT UNFORMATTED
         "�          "
         "�      "
         "�                    "
         "�" cSndName[I] FORMAT "x(30)"
         "�                    "
         "�" cRsvName[I] FORMAT "x(30)"
         "�   "
         "�               "
         "�               "
         "�" cDelail[I] FORMAT "x(40)"
         "�        "
         "�" cKop[I] FORMAT "x(10)"
         "�" SKIP.
      END.

      FOR EACH Info-Store:
        DELETE Info-Store.
      END.

   END.
END.

PUT UNFORMATTED
"����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������" SKIP.
.
/* �⮡ࠦ��� ᮤ�ন��� preview */
{preview.i}

{intrface.del}

PROCEDURE DelInnKpp:
   DEFINE INPUT-OUTPUT PARAMETER cN  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iT1  AS INTEGER NO-UNDO.
   DEFINE VARIABLE iT2  AS INTEGER NO-UNDO.

   iT1 = INDEX(cN, "���").
   IF iT1 NE 0
   THEN DO:
      iT2 = INDEX(cN, " ", iT1 + 4).
      cN  = SUBSTRING(cN, 1, iT1 - 1) + SUBSTRING(cN, iT2 + 1, LENGTH(cN) - iT2).
   END.

   iT1 = INDEX(cN, "���").
   IF iT1 NE 0
   THEN DO:
      iT2 = INDEX(cN, " ", iT1 + 4).
      cN  = SUBSTRING(cN, 1, iT1 - 1) + SUBSTRING(cN, iT2 + 1, LENGTH(cN) - iT2).
   END.

END PROCEDURE.