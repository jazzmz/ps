{pirsavelog.p}
/**             ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
                ��ନ஢���� ᯨ᪠ ����権 �।���� ������஢ ��� �.808 �ࠢ�筮.
                ���ᮢ �.�., 28.08.2009
*/
/*
  ������� ������ �� ���� ����� �㬬� � �����, �� �� ��⮢�� �.�. + ������� ����������� �롮� ����� ��� �뢮��
  ��᪮� �.�.
  16.11.2010.
*/
{globals.i}           /** �������� ��।������ */
{pick-val.i}
{chkacces.i}
{intrface.get xclass} /** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get strng}  /** �㭪樨 ��� ࠡ��� � ��ப��� */
{intrface.get date}   /** �㭪樨 ��� ࠡ��� � ��⠬� */
{intrface.get instrum}

{sh-defs.i}
{ulib.i}

/* ��।������ ��६����� ��� �뢮�� ��� */
DEF VAR vDate AS Char  No-Undo.
DEF VAR vDoc-num AS Char  No-Undo.
DEF VAR vKod-Banka AS Char  No-Undo.
DEF VAR vKorrAcct AS Char  No-Undo.
DEF VAR vName-Bank AS Char  No-Undo.
DEF VAR vNameKontr AS Char  No-Undo.
DEF VAR vINNKontr AS Char  No-Undo.
DEF VAR vAcct AS Char  No-Undo.
DEF VAR vDb AS Char  No-Undo.
DEF VAR vCr AS Char  No-Undo.
DEF VAR vPos AS Char  No-Undo.
DEF VAR vOst AS Char  No-Undo.
DEF VAR vDetails AS Char  No-Undo.

DEF VAR T1 AS INTEGER  No-Undo.
DEF VAR T2 AS INTEGER  No-Undo.
DEF VAR TempVar AS Decimal  No-Undo.
DEF VAR dPrevDate AS Date  No-Undo.
DEF VAR firstone AS Logical INITIAL TRUE  No-Undo.

/* ����� ������塞 ��� ��� �롮� ������ ����� ���� �뢮����*/
ASSIGN
 vDate = "+"
 vDoc-num = "+"
 vKod-Banka = "+"
 vKorrAcct = "+"
 vName-Bank = "+"
 vNameKontr = "+"
 vINNKontr = "+"
 vAcct = "+"
 vDb = "+"
 vCr = "+"
 vPos = "+"
 vOst = "+"
 vDetails = "+".


FORM
   vDate
      FORMAT "x(1)" 
      LABEL  "��� ����樨"  
      HELP   "��� ����樨"

   vDoc-num
      FORMAT "x(1)" 
      LABEL  "����� ���㬥��"  
      HELP   "����� ���㬥��"

   vKod-Banka
      FORMAT "x(1)" 
      LABEL  "��� �����"  
      HELP   "��� �����"

   vKorrAcct
      FORMAT "x(1)" 
      LABEL  "����.���"  
      HELP   "����.���"

   vName-Bank
      FORMAT "x(1)"  
      LABEL  "�������� �����"  
      HELP   "�������� �����"

   vNameKontr
      FORMAT "x(1)" 
      LABEL  "�������� ����ࠣ���"  
      HELP   "�������� ����ࠣ���"

   vINNKontr
      FORMAT "x(1)" 
      LABEL  "��� ����ࠣ���"  
      HELP   "��� ����ࠣ���"

   vAcct
      FORMAT "x(1)" 
      LABEL  "���"  
      HELP   "���"

   vDb
      FORMAT "x(1)" 
      LABEL  "�����"  
      HELP   "�����"

   vCr
      FORMAT "x(1)" 
      LABEL  "�।��"  
      HELP   "�।��"

   vPos
      FORMAT "x(1)" 
      LABEL  "������ �� ����"  
      HELP   "������ �� ����"

   vOst
      FORMAT "x(1)" 
      LABEL  "���⮪ � ���� ���"  
      HELP   "���⮪ � ���� ���"

    vDetails
      FORMAT "x(1)" 
      LABEL  "����ঠ��� ����樨"  
      HELP   "����ঠ��� ����樨"

WITH FRAME frParam 1 COL OVERLAY CENTERED ROW 10 TITLE "[ �롥�� ����� ��� �뢮�� ]".

PAUSE 0.

UPDATE
 vDate
 vDoc-num
 vKod-Banka
 vKorrAcct
 vName-Bank
 vNameKontr
 vINNKontr
 vAcct
 vDb
 vCr
 vPos
 vOst
 vDetails
WITH FRAME frParam.

HIDE FRAME frParam NO-PAUSE.




{pir_exf_exl.i}
{getdates.i}

DEFINE VAR oTDoc AS TDocument  No-Undo.

DEFINE VAR oTAcct AS TAcct  No-Undo.

DEFINE VARIABLE oClient AS TClient  No-Undo.


{exp-path.i &exp-filename = "'segment.xls'"}
/******************************************* ��।������ ��६����� � ��. */
DEF VAR cXL       AS CHAR     NO-UNDO.
DEF VAR cKl       AS CHAR     NO-UNDO.
DEF VAR cINN      AS CHAR     NO-UNDO.

/******************************************* ��������� */
{tmprecid.def}          /* ������ �⬥⮪. */

PUT UNFORMATTED XLHead("Klient", "DCCCCCCCNNNC", "71,83,70,150,200,200,110,150,110,110,110,200").

T1 = Time. 

FOR EACH tmprecid NO-LOCK,
   FIRST acct
      WHERE recid(acct) = tmprecid.id
      NO-LOCK:

   RUN acct-pos IN h_base(acct.acct, acct.currency, beg-date, beg-date, cXL).
   oClient = new TClient(acct.acct).

   cXL = XLRow(0)
       + XLCell("�믨᪠ �� ���� " + acct.acct + " �� ��ਮ� � "
                + STRING(beg-date, "99.99.9999") + " �� " + STRING(end-date, "99.99.9999"))
       + XLRowEnd() + XLRow(0)
       + XLCell(oClient:name-short
                + " (���: " + oClient:getInnByDate(end-date) + " )")
       + XLEmptyCells(6)
       + XLCell("�室�騩 ���⮪ �� ���:") + XLEmptyCell()
       + XLNumCell(ABS(sh-in-bal))
       + XLRowEnd()
       .
   DELETE OBJECT oClient.

   PUT UNFORMATTED XLRow(2) XLRowEnd() cXL.
   cXL = "".
   IF vDate = "+" THEN cXL = cXL + XLCell("���").
   IF vDoc-num = "+" THEN cXL = cXL + XLCell("N ���㬥��").
   IF vKod-Banka = "+" THEN cXL = cXL + XLCell("��� �����").
   IF vKorrAcct = "+" THEN cXL = cXL + XLCell("����.���").
   IF vName-Bank = "+" THEN cXL = cXL + XLCell("�������� �����").
   IF vNameKontr = "+" THEN cXL = cXL + XLCell("�������� ����ࠣ���").
   IF vINNKontr = "+" THEN cXL = cXL + XLCell("��� ����ࠣ���").
   IF vAcct = "+" THEN cXL = cXL + XLCell("��� ����ࠣ���").
   IF vDb = "+" THEN cXL = cXL + XLCell("��").
   IF vCr = "+" THEN cXL = cXL + XLCell("��").
   IF vPos = "+" THEN cXL = cXL + XLCell("���⮪ �� ���").
   IF vDetails = "+" THEN cXL = cXL + XLCell("����ঠ��� ����樨").

   /*cXL = XLCell("���")
       + XLCell("N ���㬥��")
       + XLCell("��� �����")
       + XLCell("����.���")
       + XLCell("�������� �����")
       + XLCell("�������� ����ࠣ���")
       + XLCell("��� ����ࠣ���")
       + XLCell("��� ����ࠣ���")
       + XLCell("��")
       + XLCell("��")
       + XLCell("���⮪ �� ���")
       + XLCell("����ঠ��� ����樨")
       .*/
   PUT UNFORMATTED XLRow(2) cXL XLRowEnd() .
   dprevDate = beg-date.
  
   FOR EACH op
      WHERE (op.op-date >= beg-date)
        AND (op.op-date <= end-date)
        AND NOT (op.doc-num BEGINS "�")
      NO-LOCK,
      EACH op-entry OF op
         WHERE (op-entry.acct-db EQ acct.acct)
            OR (op-entry.acct-cr EQ acct.acct)
      NO-LOCK
      BREAK BY op-entry.op-date BY op-entry.op-entry:

/* ����� ������塞 ����⮣ �� ���. */
    if vOst = "+" THEN DO:
      IF op-entry.op-date <> dprevdate and firstone <> true
        THEN DO:
           cXl = "".
           oTAcct = new TAcct(acct.acct).
           tempVar = oTAcct:getLastPos2Date(dprevdate,"",810).

           IF vDate = "+" THEN cXL = cXL + XLDateCell(dprevdate).
           IF vDoc-num = "+" THEN cXL = cXL + XLCell(" ").
           IF vKod-Banka = "+" THEN cXL = cXL + XLCell(" ").
           IF vKorrAcct = "+" THEN cXL = cXL + XLCell(" ").
           IF vName-Bank = "+" THEN cXL = cXL + XLCell(" ").
           IF vNameKontr = "+" THEN cXL = cXL + XLCell(" ").
           IF vINNKontr = "+" THEN cXL = cXL + XLCell(" ").
           IF vAcct = "+" THEN cXL = cXL + XLCell(" ").
           IF vDb = "+" THEN cXL = cXL + XLCell(" ").
           IF vCr = "+" THEN cXL = cXL + XLCell(" ").
           IF vPos = "+" THEN cXL = cXL + XLCell(" ") + XLCell(" ") + XLCell("���⮪ � ���� ���:") + XLNumCell(tempvar).
           IF vDetails = "+" THEN cXL = cXL + XLCell(" ").
           PUT UNFORMATTED XLRow(0) cXL XLRowEnd()
           cXl = "".
        END.

      firstone = false.
     END.


/* ����� ���������� ��� � ����� ���㬥��*/
   
        cXL = "".
        IF vDate = "+" THEN  cXL = cXL + XLDateCell(op-entry.op-date).
        IF vDoc-num = "+" THEN cXL = cXL + XLCell(op.doc-num).

/*      cXL = XLDateCell(op-entry.op-date)
          + XLCell(op.doc-num). */

      FIND FIRST op-bank
         WHERE (op-bank.op EQ op.op)
           AND (op-bank.op-bank-type   EQ "")
           AND (op-bank.bank-code-type EQ "���-9")
         NO-LOCK NO-ERROR.
/* ����� ���������� �������� �����, ��� �����, ����.���, �������� �����, �������� ����ࠣ���, ��� ����ࠣ���, ��� ����ࠣ���*/

      IF AVAILABLE(op-bank)
      THEN DO:
         FIND FIRST banks-code OF op-bank
            NO-ERROR.
         FIND FIRST banks OF banks-code
            NO-ERROR.
     /*    cXL = "".*/
         IF vKod-Banka = "+" THEN cXL = cXL + XLCell(op-bank.bank-code).
         IF vKorrAcct = "+" THEN cXL = cXL + XLCell(op-bank.corr-acct).
         IF vName-Bank = "+" THEN cXL = cXL + XLCell(banks.name).
         IF vNameKontr = "+" THEN cXL = cXL + XLCell(op.name-ben).
         IF vINNKontr = "+" THEN cXL = cXL + XLCell(op.inn).
         IF vAcct = "+" THEN cXL = cXL + XLCell(op.ben-acct).
      END.
      ELSE DO:
         IF vKod-Banka = "+" THEN cXL = cXL + XLCell(" ").
         IF vKorrAcct = "+" THEN cXL = cXL + XLCell(" ").
         IF vName-Bank = "+" THEN cXL = cXL + XLCell(" ").

         IF (op-entry.acct-db EQ acct.acct)
         THEN DO:
            cKl = GetAcctClientName_UAL(op-entry.acct-cr, false).
            IF (cKl NE "")
            THEN DO:
               cINN = GetXAttrValue("op", STRING(op.op), "inn-rec").
               IF (cINN = "")
               THEN cINN = GetClientInfo_ULL(GetAcctClientID_ULL(op-entry.acct-cr, FALSE), "inn", FALSE).
            END.
            ELSE cINN = "".

               IF vNameKontr = "+" THEN cXL = cXL + XLCell(cKl).
               IF vINNKontr = "+" THEN cXL = cXL + XLCell(cINN).
               IF vAcct = "+" THEN cXL = cXL + XLCell(op-entry.acct-cr).

         END.
         ELSE DO:
            cKl = GetAcctClientName_UAL(op-entry.acct-db, false).
            IF (cKl NE "")
            THEN DO:
               cINN = GetXAttrValue("op", STRING(op.op), "inn-send").
               IF (cINN = "")
               THEN cINN = GetClientInfo_ULL(GetAcctClientID_ULL(op-entry.acct-db, FALSE), "inn", FALSE).
            END.
            ELSE cINN = "".
               IF vNameKontr = "+" THEN cXL = cXL + XLCell(cKl).
               IF vINNKontr = "+" THEN cXL = cXL + XLCell(cINN).
               IF vAcct = "+" THEN cXL = cXL + XLCell(op-entry.acct-db).
         END.
      END.
/* ����� ������塞 ����� � �।��          */
      IF (op-entry.acct-db EQ acct.acct)
      THEN DO:
         IF vDb = "+" THEN cXL = cXL + XLNumCell(op-entry.amt-rub).
         IF vCr = "+" THEN cXL = cXL + XLEmptyCell().
      END.
      ELSE DO: 
         IF vDb = "+" THEN cXL = cXL + XLEmptyCell().
         IF vCr = "+" THEN cXL = cXL + XLNumCell(op-entry.amt-rub).
      END.
   /* ����� ���������� ������ �� ���� */

      IF vPos = "+" 
      THEN DO:
         oTDoc = new TDocument(op-entry.op).
         if acct.currency <>? or acct.currency <>"810" then 
         do:
            TempVar = oTDoc:getpos(acct.acct).
            TempVar = oTDoc:AcctPosInRub.
         END. 
       
         ELSE TempVar = oTdoc:getpos(acct.acct).
         IF (TempVar NE ?)
         THEN cXL = cXL + XLNumCell(TempVar).
         ELSE cXL = cXL + XLEmptyCell().
         delete object oTDoc.                 
      END.

/*   */

/* ����� ���������� ᮤ�ঠ��� ����樨 */
      IF vDetails = "+" THEN cXL = cXL + XLCell(op.details) + XLCell("  ").

      IF FIRST-OF(op-entry.op-date)
      THEN PUT UNFORMATTED XLRow(1) cXL XLRowEnd().
      ELSE PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
      cXL = "".

      dprevdate = op-entry.op-date.


   END.

           cXl = "".
           oTAcct = new TAcct(acct.acct).
           tempVar = oTAcct:getLastPos2Date(dprevdate,"",810).

           IF vDate = "+" THEN cXL = cXL + XLDateCell(dprevdate).
           IF vDoc-num = "+" THEN cXL = cXL + XLCell(" ").
           IF vKod-Banka = "+" THEN cXL = cXL + XLCell(" ").
           IF vKorrAcct = "+" THEN cXL = cXL + XLCell(" ").
           IF vName-Bank = "+" THEN cXL = cXL + XLCell(" ").
           IF vNameKontr = "+" THEN cXL = cXL + XLCell(" ").
           IF vINNKontr = "+" THEN cXL = cXL + XLCell(" ").
           IF vAcct = "+" THEN cXL = cXL + XLCell(" ").
           IF vDb = "+" THEN cXL = cXL + XLCell(" ").
           IF vCr = "+" THEN cXL = cXL + XLCell(" ").
           IF vPos = "+" THEN cXL = cXL + XLCell(" ") + XLCell(" ") + XLCell("���⮪ � ���� ���:") + XLNumCell(tempvar).
           IF vDetails = "+" THEN cXL = cXL + XLCell(" ").
           PUT UNFORMATTED XLRow(0) cXL XLRowEnd().



/* ����� ���������� �⮣� */
   RUN acct-pos IN h_base(acct.acct, acct.currency, beg-date, end-date, cXL).
   cXL = XLRow(2).
   IF vDate = "+" THEN cXL = cXL + XLCell("�⮣� :").
   IF vDoc-num = "+" THEN cXL = cXL + XLCell(" ").
   IF vKod-Banka = "+" THEN cXL = cXL + XLCell(" ").
   IF vKorrAcct = "+" THEN cXL = cXL + XLCell(" ").
   IF vName-Bank = "+" THEN cXL = cXL + XLCell(" ").
   IF vNameKontr = "+" THEN cXL = cXL + XLCell(" ").
   IF vINNKontr = "+" THEN cXL = cXL + XLCell(" ").
   IF vAcct = "+" THEN cXL = cXL + XLCell("������: ").
   IF vDb = "+" THEN cXL = cXL + XLNumCell(sh-db).
   IF vCr = "+" THEN cXL = cXL + XLNumCell(sh-cr).
   IF vPos = "+" THEN cXL = cXL + XLCell(" ").
   IF vDetails = "+" THEN cXL = cXL + XLCell(" ").

   cXL = cXL + XLRowEnd() + XLRow(0).

   IF vDate = "+" THEN cXL = cXL + XLCell(" ").
   IF vDoc-num = "+" THEN cXL = cXL + XLCell(" ").
   IF vKod-Banka = "+" THEN cXL = cXL + XLCell(" ").
   IF vKorrAcct = "+" THEN cXL = cXL + XLCell(" ").
   IF vName-Bank = "+" THEN cXL = cXL + XLCell(" ").
   IF vNameKontr = "+" THEN cXL = cXL + XLCell(" ").
   IF vINNKontr = "+" THEN cXL = cXL + XLCell(" ").
   IF vAcct = "+" THEN cXL = cXL + XLCell("���⮪ �� ���: ").
   IF vDb = "+" THEN cXL = cXL + XLCell(" ").
   IF vCr = "+" THEN cXL = cXL + XLNumCell(ABS(sh-bal)).

   cXL = cXL + XLRowEnd().
   PUT UNFORMATTED cXL.



END.



T2 = Time.

PUT UNFORMATTED XLEnd().

/*MESSAGE T2 - T1 VIEW-AS ALERT-BOX.*/

{intrface.del}
