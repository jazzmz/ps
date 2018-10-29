{pirsavelog.p}

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: REE_BNK.P
      Comment: ������ �� �����
   Parameters:
         Uses:
      Used by:
      Created: 24.08.2004 12:49 SAP     
     Modified: 25.08.2004 12:31 SAP      
     Modified: 
*/
{globals.i}
{bank-id.i}

DEFINE INPUT  PARAMETER in-data-id LIKE DataBlock.Data-Id NO-UNDO.
DEFINE OUTPUT PARAMETER oRegNum    AS   CHARACTER         NO-UNDO.

DEFINE VARIABLE vFile-bnk AS CHARACTER INITIAL "bnk.txt" NO-UNDO.
DEFINE VARIABLE vBank     AS CHARACTER NO-UNDO.


find user-proc where user-proc.procedure = "pirree_elec".
if avail user-proc then 
vFile-bnk = GetXattrValueEx("user-proc",string(user-proc.public-number),"���","") + "/" + vFile-bnk.
else vFile-bnk = vFile-bnk.
DEFINE STREAM bnk.
{justasec}

vBank  = FGetSetting( "����������", "", "" ).
/*vBank  =  "�������᪨� ���� �஬�諥���-������樮���� ���⮢ " + chr(34) + "�p������������" + chr(34) + "(����⢮ � ��࠭�祭��� �⢥��⢥�������)" .*/
OUTPUT STREAM bnk TO VALUE ( vFile-bnk ) CONVERT TARGET "1251".
PUT STREAM bnk UNFORMATTED vBank + "^" + bank-regn.
OUTPUT STREAM bnk CLOSE.

oRegNum = bank-regn.



