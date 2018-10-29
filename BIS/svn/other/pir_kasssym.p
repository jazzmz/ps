{pirsavelog.p}

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 2005 ��� �� "�P��������������"
     Filename: pir_kasssym.p
      Comment: '��������� ���㬥�⮢ � 㪠������ ᨬ����� ���ᯫ��� �� ⥪�饬� ���짮��⥫�'
   Parameters:
         Uses: 
      Used by: YAKOVEN, ZEMTZOVA
      Created: 13.10.2005      ANISIMOV
*/

DEF VAR mNameBank AS CHAR NO-UNDO.
DEF VAR mName     AS CHAR NO-UNDO.
DEF VAR mI        AS INT  NO-UNDO.
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{globals.i}
{get-bankname.i}
mNameBank = cBankName.
{setdest.i &cols=130}
PUT 
   UNFORMATTED
   "������������ ����� " mNameBank SKIP
.

find _user where _user._userid eq userid("bisquit") no-lock no-error.

FOR EACH tmprecid 
         NO-LOCK,
   FIRST op WHERE 
         RECID(op) EQ tmprecid.id AND
         user-id EQ _user._userid
         NO-LOCK, 
    EACH op-entry OF op
         NO-LOCK
   BREAK BY op.op-date
         BY op-entry.symbol
         BY op.doc-num :
   FORM 
      op.doc-num
      op-entry.acct-db  
      op-entry.acct-cr  
      op-entry.symbol
      op-entry.amt-rub  
      mName VIEW-AS EDITOR SIZE 40 BY 1 COLUMN-LABEL "���������� ��������"
   WITH WIDTH 220.

   IF FIRST-OF(op.op-date) THEN 
      PUT 
         UNFORMATTED
         "��������� ���㬥�⮢ �� ���ᮢ� ᨬ����� �� " op.op-date SKIP
      .
   
   mName = TRIM(REPLACE(op.details,'\n',' ')).
   IF TRIM(op-entry.symbol) NE "" THEN
      DISPLAY
         op.doc-num
         op-entry.acct-db  WHEN op-entry.acct-db  NE ?
         op-entry.acct-cr  WHEN op-entry.acct-cr  NE ?
         op-entry.symbol
         op-entry.amt-rub  WHEN op-entry.amt-rub  NE ?
         mName  WITH /*NO-BOX*/ USE-TEXT 
      .
END.
{signatur.i &user-only=yes}
{preview.i}
  
