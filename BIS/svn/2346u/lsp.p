
                   /*******************************************
                    *                                         *
                    *  ������� ������������ � �������������!  *
                    *                                         *
                    *  ������������� ������ ���� ����������,  *
                    *  �.�. �� ��������� ����������� �������  *
                    *             �������������!              *
                    *                                         *
                    *******************************************/

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2013 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: lsp.p
      Comment: ����, ᮧ����� ������஬ ���⮢
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 13/02/13 17:32:19
     Modified:
*/
Form "~n@(#) lsp.p 1.0 RGen 13/02/13 RGen 13/02/13 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- �室�� ��ࠬ���� --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- ������� ��६����� --------------------*/

Define Buffer buf_0_op               For op.

/*--------------- ���� ��� ����� ��: ---------------*/

/*--------------- ��६���� ��� ᯥ樠���� �����: ---------------*/
Define Variable Bank-name        As Character            No-Undo.
Define Variable dob              As Date                 No-Undo.
Define Variable drag-b           As Decimal              No-Undo.
Define Variable drag-o           As Decimal              No-Undo.
Define Variable eas-rur          As Decimal              No-Undo.
Define Variable eas-rur-futures  As Decimal              No-Undo.
Define Variable eas-val          As Decimal              No-Undo.
Define Variable Ispol            As Character            No-Undo.
Define Variable k-b              As Decimal              No-Undo.
Define Variable k-drag-b         As Decimal              No-Undo.
Define Variable k-drag-o         As Decimal              No-Undo.
Define Variable k-o              As Decimal              No-Undo.
Define Variable kinv-b           As Decimal              No-Undo.
Define Variable kinv-o           As Decimal              No-Undo.
Define Variable pls-b            As Decimal              No-Undo.
Define Variable pls-o            As Decimal              No-Undo.
Define Variable tot-b            As Decimal              No-Undo.
Define Variable tot-d            As Decimal              No-Undo.
Define Variable tot-o            As Decimal              No-Undo.
Define Variable tot-s            As Decimal              No-Undo.
Define Variable val-b            As Decimal              No-Undo.
Define Variable val-o            As Decimal              No-Undo.
Define Variable vpls-b           As Decimal              No-Undo.
Define Variable vpls-o           As Decimal              No-Undo.

/*--------------- ��।������ �� ��� 横��� ---------------*/

/* ��砫�� ����⢨� */
{getdate.i}

def var bDocRub as logical no-undo.
def var bDocDrg as logical no-undo.
def var bDocKas as logical no-undo.
def var bDocPls as logical no-undo.
def var nDigit  as integer no-undo.

def var nDocAmt like op-entry.amt-rub no-undo.

DEFINE BUFFER xop-entry FOR op-entry.

DEFINE VARIABLE mReRate    AS CHARACTER NO-UNDO.
DEFINE VARIABLE adb        AS CHARACTER NO-UNDO.
DEFINE VARIABLE acr        AS CHARACTER NO-UNDO.
DEFINE VARIABLE isCash     AS LOGICAL   NO-UNDO.

/* ������ �������� � ����������� ������ */
DEFINE VARIABLE isEArch    AS LOGICAL INITIAL FALSE NO-UNDO.

def var i        as dec init 0 NO-UNDO.
DEF VAR ot       AS TTable2    NO-UNDO.
DEF VAR filename AS char       NO-UNDO.
DEF VAR s 	 AS dec        NO-UNDO.
ot = new TTable2(10).

{op-cash.def}
mReRate    = FGetSetting("�����(b)", "��⏥�",   "*empty*").

ot:addRow().
ot:addCell("����� �/�").
ot:addCell("op.op").
ot:addCell("����� ���㬥��").
ot:addCell("��� ���㬥��").
ot:addCell("�����").
ot:addCell("����஫��").
ot:addCell("�㬬� � ��.").
ot:addCell("�㬬� ���.").
ot:addCell("��� ��").
ot:addCell("��⥣��� ").

for each op where op-date = end-date and op.op-status >= CHR(251) no-lock:

    bDocRub = YES.
    bDocPls = NO.

    /******************************* 
     * �஢��塞 ���. ४�����,    *
     * �᫨ �� ����, ����� ���-�  *
     * ���㦥� � ��娢.           *
     *******************************/
    IF INT64(getXAttrValueEx("op",STRING(op.op),"PirA2346U","0"))>1000 THEN isEArch = TRUE.
    ELSE isEArch = FALSE.
    
    if op.op-kind EQ "i-tag_pl" or
       op.user-id EQ "MARKOVA" or
       op.user-id EQ "ARISTARH" THEN bDocPls = YES. 

    for each op-entry of op no-lock:
        IF op-entry.currency NE "" THEN bDocRub =NO.
    end.

    for each op-entry of op:
       ASSIGN
          adb = ?
          acr = ?
       .

       IF op-entry.acct-cr EQ ? THEN 
       DO:
          FIND FIRST xop-entry WHERE xop-entry.op = op.op 
                                 AND xop-entry.acct-db EQ ? 
             USE-INDEX op-entry NO-LOCK NO-ERROR.
          ASSIGN
            adb = op-entry.acct-db
            acr = IF AVAILABLE xop-entry THEN xop-entry.acct-cr ELSE "**empty**"
          .
       END.
       ELSE IF op-entry.acct-db EQ ? THEN 
       DO:
          FIND FIRST xop-entry WHERE xop-entry.op = op.op 
                                 AND xop-entry.acct-cr EQ ? 
             USE-INDEX op-entry NO-LOCK  NO-ERROR.
          ASSIGN       
             adb = IF AVAILABLE xop-entry THEN xop-entry.acct-db ELSE "**empty**"
             acr = op-entry.acct-cr
          .
       END.
       ELSE 
       DO:
          ASSIGN
             adb = op-entry.acct-db
             acr = op-entry.acct-cr
          .
       END.

       {op-cash.i}
        if op.op-kind NE "����" and op.op-kind NE "����1"  then 
        do:
        assign
            bDocKas     = isCash.
            bDocDrg     = false.
        end.

        IF bDocRub THEN
           bDocRub = NOT (CAN-FIND( FIRST acct WHERE acct.acct = op-entry.acct-cr
                                                 AND CAN-DO(mReRate, acct.acct))
                          OR 
                          CAN-FIND( FIRST acct WHERE acct.acct = op-entry.acct-db
                                                 AND CAN-DO(mReRate, acct.acct))
           ).


        IF bDocRub AND op-entry.acct-db = ? THEN
            bDocRub = NOT CAN-FIND(FIRST op-entry OF op WHERE op-entry.currency <> "" 
                                                          AND op-entry.acct-cr = ?
                                  ).
        ELSE IF bDocRub AND op-entry.acct-cr = ? THEN
            bDocRub = NOT CAN-FIND(FIRST op-entry OF op WHERE op-entry.currency <> "" 
                                                          AND op-entry.acct-db = ?
                                  ).

        if( (not bDocRub) and (not bDocDrg) ) then do:

            nDigit = -1.

            assign

                nDigit = integer( substr( op-entry.currency, 1, 1 ) )

            no-error.

            bDocDrg = (nDigit < 0).

        end.

        assign

            nDocAmt = 0
            nDocAmt = op-entry.amt-rub

            when op-entry.acct-db <> ?

        .
        i = i + 1.
        ot:addRow().
        ot:addCell(i).
        ot:addCell(op.op).
        ot:addCell(op.doc-num).
        ot:addCell(op.op-date).
        ot:addCell(op.op-status).
        ot:addCell(op.user-inspector).
        ot:addCell(nDocAmt).
	s = s + nDocAmt.
        ot:addCell(s).
        ot:addCell(op-entry.acct-db).
        ot:addCell(op.acct-cat).

        assign

            tot-b  = tot-b  + nDocAmt       /* ������ �� ���㬥��� */

                when (op.acct-cat = "b")

             /* ����� �� ���㧪� � ���஭�� ��娢 */
             eas-rur   = eas-rur    + nDocAmt      
                when (op.acct-cat = "b") AND isEArch AND bDocRub

             eas-val = eas-val + nDocAmt
                when (op.acct-cat = "b") AND isEArch AND (NOT bDocRub)
                
             eas-rur-futures = eas-rur-futures + nDocAmt
                  when (op.acct-cat = "f") AND isEArch
                
             /* ����� �� ���㧪� � ���஭�� ��娢 */
             
            k-b = k-b + nDocAmt             /* ������ �� ���ᮢ� */

                when (op.acct-cat = "b")

                 /*and (bDocRub)*/ and (bDocKas)

            val-b = val-b + nDocAmt         /* ������ ����� ����ਠ��� */
    
                when (op.acct-cat = "b")
    
                 and (not bDocRub) and (not bDocDrg) and (not bDocKas) and (not bDocPls) AND (NOT isEArch)
    
            kinv-b = kinv-b + nDocAmt       /* ������ ����� ���ᮢ� */
    
                when (op.acct-cat = "b")

                 and (not bDocRub) and (not bDocDrg) and (bDocKas)  /* and (not bDocPls) */ AND (NOT isEArch)
                                          
            pls-b  = pls-b  + nDocAmt        /* ������ ����⨪ ����ਠ��� */

                when (op.acct-cat = "b")

                 and (bDocPls) and (not bDocDrg) and (not bDocKas) AND (NOT isEArch)

            vpls-b = vpls-b + nDocAmt        /* ������ ����⨪ ����ਠ��� ����� */

                when (op.acct-cat = "b")

                 and (bDocPls) and (not bDocRub) and (not bDocDrg) and (not bDocKas) AND (NOT isEArch)

            drag-b = drag-b + nDocAmt       /* ������ �ࠣ.���. ����ਠ��� */
    
                when (op.acct-cat = "b")
    
                 and (not bDocRub) and (bDocDrg) and (not bDocKas) and (not bDocPls) AND (NOT isEArch)
    
            k-drag-b = k-drag-b + nDocAmt   /* ������ �ࠣ.���. ���ᮢ� */
    
                when (op.acct-cat = "b")

             and (not bDocRub) and (bDocDrg) and (bDocKas) and (not bDocPls) AND (NOT isEArch)

            tot-o  = tot-o  + nDocAmt       /* ��������� �� ���㬥��� */
    
                when (op.acct-cat = "o")
    
            k-o = k-o + nDocAmt             /* ��������� �� ���ᮢ� */
    
                when (op.acct-cat = "o")
    
                 /*and (bDocRub)*/ and (bDocKas)

            val-o = val-o + nDocAmt         /* ��������� ����� ����ਠ��� */
    
                when (op.acct-cat = "o")
    
                 and (not bDocRub) and (not bDocDrg) and (not bDocKas) and (not bDocPls)
    
            kinv-o = kinv-o + nDocAmt       /* ��������� ����� ���ᮢ� */
    
                when (op.acct-cat = "o")

                 and (not bDocRub) and (not bDocDrg) and (bDocKas) /* and (not bDocPls) */

            pls-o  = pls-o  + nDocAmt       /* ��������� ����⨪ ����ਠ��� */

                when (op.acct-cat = "o")

                 and (bDocPls) and (not bDocDrg) and (not bDocKas)

            vpls-o = vpls-o + nDocAmt       /* ��������� ����⨪ ����ਠ��� ����� */

                when (op.acct-cat = "o")

                 and (bDocPls) and (not bDocRub) and (not bDocDrg) and (not bDocKas)
    
            drag-o = drag-o + nDocAmt       /* ��������� �ࠣ.���. ����ਠ��� */
    
                when (op.acct-cat = "o")
    
                 and (not bDocRub) and (bDocDrg) and (not bDocKas) and (not bDocPls)
    
            k-drag-o = k-drag-o + nDocAmt   /* ��������� �ࠣ.���. ���ᮢ� */

                when (op.acct-cat = "o")
    
                 and (not bDocRub) and (bDocDrg) and (bDocKas) and (not bDocPls)

            tot-s  = tot-s  + nDocAmt       /* ���� �� ���㬥��� */
    
                when (op.acct-cat = "f")

            tot-d  = tot-d  + nDocAmt       /* ���� �� ���㬥��� */
    
                when (op.acct-cat = "d")
        .
    
    end.
end.

filename = "/home2/bis/quit41d/imp-exp/protocol/stub/lsp_d" + string(today,"9999-99-99") + "_t" + replace(STRING(TIME,"HH:MM:SS"),":","-") + "_" + string(USERID("bisquit")) + ".log".
OUTPUT TO VALUE(filename).
ot:show().
OUTPUT CLOSE.
DELETE OBJECT ot.

/*-----------------------------------------
   �஢�ઠ ������ ����� ������� ⠡����,
   �� ������ 㪠�뢠�� Input Param RID
-------------------------------------------*/
Find op Where RecID(op) = RID no-lock no-error.
If Not Avail(op) then do:
  message "��� ����� <op>".
  Return.
end.

/*------------------------------------------------
   ���⠢��� buffers �� �����, ��������
   � ᮮ⢥��⢨� � ������묨 � ���� �ࠢ�����
------------------------------------------------*/
/* �.�. �� ������ �ࠢ��� ��� �롮ન ����ᥩ �� ������� ⠡����,
   ���� ���⠢�� ��� buffer �� input RecID                    */
find buf_0_op where RecID(buf_0_op) = RecID(op) no-lock.

/*------------------------------------------------
   ���᫨�� ���祭�� ᯥ樠���� �����
   � ᮮ⢥��⢨� � ������묨 � ���� �ࠢ�����
------------------------------------------------*/
/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Bank-name */
{get-bankname.i}
bank-name = cBankName.



/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� dob */
assign

 dob = end-date

.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� drag-b */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� drag-o */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� eas-rur */
/* �������� � ��������� �������� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� eas-rur-futures */
/* � ��砫��� ����⢨�� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� eas-val */
/* �������� � ��������� �������� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Ispol */
find first _user where _user._userid = user('bisquit').

       assign

             ispol = _user._user-name

       .

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� k-b */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� k-drag-b */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� k-drag-o */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� k-o */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� kinv-b */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� kinv-o */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� pls-b */
/* */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� pls-o */
/* */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� tot-b */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� tot-d */
/* */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� tot-o */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� tot-s */
/* */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� val-b */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� val-o */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� vpls-b */
/* */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� vpls-o */
/* */

/*-------------------- ��ନ஢���� ���� --------------------*/
{strtout3.i &cols=83 &option=Paged}

put unformatted "�ப �࠭����   __________________________________________________" skip.
put unformatted " " skip.
put unformatted "��娢�� ������ __________________________________________________" skip.
put skip(1).
put unformatted "                 " Bank-name Format "x(50)"
                "" skip.
put skip(2).
put unformatted "��壠���᪨� ���㬥��� �� " dob Format "99/99/9999"
                "." skip.
put skip(1).
put unformatted "                                �� �����ᮢ� ��⠬       �� ��������ᮢ� ��⠬" skip.
put skip(1).
put unformatted "��壠���᪨� ���㬥���" skip.
put unformatted " " skip.
put unformatted "�� �㬬�                    " tot-b Format "->>>,>>>,>>>,>>9.99"
                "  ��.     " tot-o Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put skip(1).
put unformatted "�࠭���� �� �㬠���� ���⥫� � ��室���� � �⤥���� ������:" skip.
put skip(1).
put unformatted "���ᮢ� ���㬥���          " k-b Format "->>>,>>>,>>>,>>9.99"
                "  ��.     " k-o Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put skip(1).
put unformatted "    �� ������ � �����࠭��� ����⮩" skip.
put skip(1).
put unformatted "��壠���᪨� ���㬥���     " val-b Format "->>>,>>>,>>>,>>9.99"
                "  ��.     " val-o Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put skip(1).
put unformatted "     �ப �࠭����  ____________" skip.
put unformatted " " skip.
put unformatted "���ᮢ� ���㬥���          " kinv-b Format "->>>,>>>,>>>,>>9.99"
                "  ��.     " kinv-o Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put skip(1).
put unformatted "     �ப �࠭����  ____________" skip.
put unformatted " " skip.
put unformatted "    �� ������ � ����⨪��묨 ���⠬�" skip.
put skip(1).
put unformatted "��壠���᪨� ���㬥���" skip.
put skip(1).
put unformatted "�� �㬬�                    " pls-b Format "->>>,>>>,>>>,>>9.99"
                "  ��.     " pls-o Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put unformatted " " skip.
put unformatted "    �� ������ � �����࠭��� ����⮩" skip.
put unformatted " " skip.
put unformatted "    ��壠���᪨� ���㬥��� " vpls-b Format "->>>,>>>,>>>,>>9.99"
                "  ��      " vpls-o Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put skip(1).
put unformatted "              �ப �࠭���� _____________" skip.
put skip(1).
put unformatted "    �� ������ � �ࠣ�業�묨 ��⠫����:" skip.
put unformatted " " skip.
put unformatted "��壠���᪨� ���㬥���     " drag-b Format "->>>,>>>,>>>,>>9.99"
                "  ��.     " drag-o Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put skip(1).
put unformatted "     �ப �࠭����  ____________" skip.
put skip(1).
put unformatted "���ᮢ� ���㬥���          " k-drag-b Format "->>>,>>>,>>>,>>9.99"
                "  ��.     " k-drag-o Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put skip(1).
put unformatted "     �ப �࠭����  ___________" skip.
put skip(1).
put unformatted "�࠭���� � ���஭��� ����:" skip.
put unformatted " " skip.
put unformatted "  ��壠���᪨� ���㬥���:" skip.
put unformatted " " skip.
put unformatted "   �� �㡫��� ������      " eas-rur Format "->>>,>>>,>>>,>>9.99"
                " ��." skip.
put unformatted " " skip.
put unformatted "       �ப �࠭���� ____________" skip.
put skip(1).
put unformatted "   �� ������ ������      " eas-val Format "->>>,>>>,>>>,>>9.99"
                " ��." skip.
put skip(1).
put unformatted "       �ப �࠭���� ____________" skip.
put skip(1).
put unformatted "��壠���᪨� ���㬥��� �� ��⥣�ਨ ""���� ᤥ���""" skip.
put skip(1).
put unformatted "�� �㬬�                    " tot-s Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put skip(1).
put unformatted "�࠭���� � ���஭��� ���� ""���� ᤥ���""" skip.
put skip(1).
put unformatted "�� �㬬�                    " eas-rur-futures Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put skip(1).
put unformatted "��壠���᪨� ���㬥��� �� ��⥣�ਨ ""����""" skip.
put skip(1).
put unformatted "�� �㬬�                    " tot-d Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put unformatted " " skip.
put unformatted "���㬥��� ����஢��� � ������ __________________" skip.
put unformatted "                                   (�������)" skip.
put skip(1).
put unformatted "�ᯮ���⥫�:  " Ispol Format "x(50)"
                "" skip.

{endout3.i &nofooter=yes}
