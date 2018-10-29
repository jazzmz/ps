{pirsavelog.p}

/*
                ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1996 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: leg207ex.p
      Comment: ����� ॥��� �� ����� Legal207
               ᮣ��᭮ ��������� 207-� (��뢠��� ��室��)
         Uses:
      Used BY:
      Created: 26/10/2005 Anisimov
*/
/******************************************************************************/
{globals.i}
{repinfo.i}
{norm.i NEW}

{intrface.get xclass}
{intrface.get strng}

{leg207p.def}
{leg161p.fun}

{getdate.i}

{setdest.i &cols=275}


DEFINE INPUT PARAMETER ipDataID  AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER iParmStr AS CHARACTER NO-UNDO.

DEFINE BUFFER bDataLine FOR DataLine.
DEFINE VAR    hWrite      AS  handle     NO-UNDO.

DEFINE VAR    mErrCount   AS  INTEGER    NO-UNDO.
DEFINE VAR    mError      AS  INTEGER    NO-UNDO.
DEFINE VAR    mNumber     AS  INTEGER    NO-UNDO.
DEFINE VAR    mCod	      AS CHARACTER   NO-UNDO.
DEFINE VAR    mSign	      AS CHARACTER   NO-UNDO.

DEFINE BUFFER Data0 FOR DataLine.
DEFINE BUFFER Data1 FOR DataLine.
DEFINE BUFFER Data2 FOR DataLine.

DEFINE QUERY qData  FOR Data0, Data1.

FUNCTION GetDat0Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
FUNCTION GetDat1Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
FUNCTION GetDat2Txt RETURN CHAR    (INPUT ipItem   AS INTEGER) forward.
/*============================================================================*/
{fexp-chk.i &DataID = ipDataID}


mCod  = GetEntries(2, iParmStr,";",?).
mSign = GetEntries(1, iParmStr,";",?).

/*
message "ok" mCod mSign. pause.
*/

FIND FIRST setting WHERE setting.code     EQ "Legal207"
                     AND setting.sub-code EQ "�������"
                         SHARE-LOCK NO-ERROR.
IF NOT AVAILABLE(setting) THEN DO:
   MESSAGE "����� � ��� �ᯮ�������� ��㣨� ���짮��⥫��." SKIP
           "���஡�� �����."                                 SKIP
           VIEW-AS ALERT-BOX INFORMATION.
   RETURN.
END.
FIND current DataBlock SHARE-LOCK NO-ERROR.
IF NOT AVAILABLE(DataBlock) THEN DO:
   MESSAGE "���� ������ ��������� ��㣨� ���짮��⥫��." SKIP
           "���஡�� �����."                            SKIP
           VIEW-AS ALERT-BOX INFORMATION.
   RETURN.
END.

{getbrnch.i &SOATO     = vSoato
            &OKATO     = vOkato
            &REGN      = vRegNum
            &BANKCODE  = vBankCode
            &BRANCH    = Branch.Branch-ID
}

/* �⠥� ��  */
   OPEN QUERY qData PRESELECT EACH Data0 WHERE
                                   Data0.Data-ID            EQ ipDataID
                               AND Data0.Sym2               EQ {&MAIN-LINE}
                                   NO-LOCK,
                             FIRST Data1 WHERE
                                   Data1.Data-ID EQ ipDataID
                               AND Data1.Sym1    EQ Data0.Sym1
                               AND Data1.Sym2    EQ {&BANK-LINE}
                                   NO-LOCK.

/* ����砥� ����� ������ */
get FIRST qData.
   if mCod = "6001" then
   put unformatted skip "                                                                          ������ �������� ����権, ����� ��।��� � ���� ����� ���ᨨ � ᮮ⢥��⢨� � ���������� �� �� 207-� " end-date FORMAT "99.99.9999" .
   else  
   do:
   put unformatted skip "                                                                               ������ ����権, ��������� ��易⥫쭮�� ����஫� � ᮮ⢥��⢨� � ���������� �� �� 207-�,".
   put unformatted skip "                                                                                                     ����� �뫨 ��।��� � ���� ����� ���ᨨ "  end-date FORMAT "99.99.9999" .
   end.
   put unformatted skip "+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+".
   put unformatted skip "| �/� |����� | ��� ���. | ��� ����. | ��� |      �㬬� � �����     |      �㬬� � �㡫��     |��� ��|  �������⥫�� ���� ����樨    | �������⥫쭠� ���ଠ�� �� ����樨                                                                                           |".
   put unformatted skip "|            | �����祭�� ���⥦�, �᭮����� �஢������ ����樨                                                                                                                                                                                                             |".
   put unformatted skip "|            |        ������������ ���⥫�騪�        |    ���     |��|����/����|����/����� ���㬥��| ��� ॣ.|     ����� � ��� �뤠� ���㬥�� 㤮�⮢����騩 ��筮���     |    ����� ����樮���� �����   | ����|���� ॣ����樨                                      |".
   put unformatted skip "|            |        ������������ �����⥫�         |    ���     |��|����/����|����/����� ���㬥��| ��� ॣ.|     ����� � ��� �뤠� ���㬥�� 㤮�⮢����騩 ��筮���     |    ����� ����樮���� �����   | ����|���� ॣ����樨                                      |".
   put unformatted skip "+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+".
mNumber = 1.


main-loop:
DO TRANSACTION WHILE AVAILABLE(Data0)
   ON ERROR  UNDO main-loop, LEAVE main-loop
   ON ENDKEY UNDO main-loop, LEAVE main-loop:


   FIND FIRST DataLine WHERE recid(DataLine) EQ recid(Data0)
              EXCLUSIVE-LOCK NO-ERROR.

   IF NOT AVAILABLE(DataLine) or not can-do(mCod,string(Data0.Sym3)) /*  or end-date ne date(GetEntries(5,Data0.Txt,"~n",{&E-DATE}))  */  THEN DO:
      get NEXT qData.
      NEXT main-loop.
   END.

   put unformatted skip "|" mNumber FORMAT ">>>>9" "|"
                             Data0.Val[1]           FORMAT ">>>>>9" "| "
                             DATE(GetEntries( 5,Data0.Txt,"~n",{&E-DATE})) FORMAT "99.99.9999" " | "
                             DATE(GetEntries(11,Data0.Txt,"~n",{&E-DATE})) FORMAT "99.99.9999" " | "
                             string(GetDat0Txt( 6),        "x(3)") " | "
                             string(Data0.Val[3],   "->>>,>>>,>>>,>>>,>>9.99") " | "
                             string(Data0.Val[2],   "->>>,>>>,>>>,>>>,>>9.99") " | "
                             string(Data0.Sym3,           "x(4)")  " | "
                             string(GetDat0Txt( 4)     ,  "x(32)") " | "
                             TRIM(GetDat0Txt(10))  FORMAT "x(127)" " | ".
   put unformatted skip "|            |"
                             string(GetDat0Txt( 8), "x(255)") "|".

/* ����砥� ����� � ���⥫�騪� */
   FIND FIRST Data2 WHERE Data2.Data-ID EQ ipDataID
                      AND Data2.Sym1    EQ Data0.Sym1
                      AND Data2.Sym2    EQ {&SEND-LINE}
                      NO-LOCK NO-ERROR.
   put unformatted skip "|            |"
                             string(GetDat2Txt( 3),  "x(40)") "|"
                             string(GetDat2Txt(11),  "x(12)") "|"
                             string(GetDat2Txt( 8),   "x(2)") "|"
                             string(GetDat2Txt( 9),  "x(10)") "|"
                             string(GetDat2Txt(10),  "x(20)") "|"
                             DATE(GetDat2Txt(13)) FORMAT "99.99.9999" "|"
                             string(GetDat2Txt(12),  "x(60)") "|"
                             string(GetDat2Txt(14),  "x(32)") "|"
                             string(GetDat2Txt( 4),   "x(5)") "|"
                             string(GetDat2Txt( 6),  "x(55)") "|".
/* ����砥� ����� � �����⥫� */
   FIND FIRST Data2 WHERE Data2.Data-ID EQ ipDataID
                      AND Data2.Sym1    EQ Data0.Sym1
                      AND Data2.Sym2    EQ {&RECV-LINE}
                      NO-LOCK NO-ERROR.
   put unformatted skip "|            |"
                             string(GetDat2Txt( 3),  "x(40)") "|"
                             string(GetDat2Txt(11),  "x(12)") "|"
                             string(GetDat2Txt( 8),   "x(2)") "|"
                             string(GetDat2Txt( 9),  "x(10)") "|"
                             string(GetDat2Txt(10),  "x(20)") "|"
                             DATE(GetDat2Txt(13)) FORMAT "99.99.9999" "|"
                             string(GetDat2Txt(12),  "x(60)") "|"
                             string(GetDat2Txt(14),  "x(32)") "|"
                             string(GetDat2Txt( 4),   "x(5)") "|"
                             string(GetDat2Txt( 6),  "x(55)") "|".
   put unformatted skip "+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+".

   ASSIGN
      mNumber = mNumber + 1
   .

   get NEXT qData.
END.

if mSign eq "�������" then
put unformatted skip(2) "�㪮����⥫� ����� : ________________ " skip (1).
{signatur.i &user-only = yes}
{preview.i}

RETURN.
/*----------------------------------------------------------------------------*/
FUNCTION GetDat0Txt RETURN CHAR (INPUT ipItem AS INTEGER):
   RETURN ClearExtSym(GetEntries(ipItem,Data0.Txt,"~n","0")).
END FUNCTION.
/*----------------------------------------------------------------------------*/
FUNCTION GetDat1Txt RETURN CHAR (INPUT ipItem AS INTEGER):
   RETURN ClearExtSym(GetEntries(ipItem,Data1.Txt,"~n","0")).
END FUNCTION.
/*----------------------------------------------------------------------------*/
FUNCTION GetDat2Txt RETURN CHAR (INPUT ipItem AS INTEGER):
IF AVAILABLE(Data2)
   THEN RETURN ClearExtSym(GetEntries(ipItem,Data2.Txt,"~n","0")).
   ELSE RETURN "0".
END FUNCTION.
/******************************************************************************/

PROCEDURE OpenQueryData:
   DEFINE INPUT  PARAMETER iClose  AS LOGICAL NO-UNDO.
   DEFINE OUTPUT PARAMETER oCount  AS INTEGER NO-UNDO.

   OPEN QUERY qData PRESELECT EACH Data0 WHERE
                                   Data0.Data-ID            EQ ipDataID
                               AND Data0.Sym2               EQ {&MAIN-LINE}
                               AND (INTEGER(Data0.Val[1])   EQ 0)
                                   NO-LOCK,
                             FIRST Data1 WHERE
                                   Data1.Data-ID EQ ipDataID
                               AND Data1.Sym1    EQ Data0.Sym1
                               AND Data1.Sym2    EQ {&BANK-LINE}
                                   NO-LOCK.
   oCount = num-results("qData").
   IF iClose THEN CLOSE QUERY qData.

END PROCEDURE.
