{pirsavelog.p}


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
    Copyright: (C) 1992-2005 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: lsa.p
      Comment: ����, ᮧ����� ������஬ ���⮢
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 06/09/05 13:13:00
     Modified:
*/
Form "~n@(#) lsa.p 1.0 RGen 06/09/05 RGen 06/09/05 [ AutoReport By R-Gen ]"
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
Define Variable Ispol            As Character            No-Undo.
Define Variable k-b              As Decimal              No-Undo.
Define Variable k-drag-b         As Decimal              No-Undo.
Define Variable k-drag-o         As Decimal              No-Undo.
Define Variable k-o              As Decimal              No-Undo.
Define Variable kinv-b           As Decimal              No-Undo.
Define Variable kinv-o           As Decimal              No-Undo.
Define Variable tot-b            As Decimal              No-Undo.
Define Variable tot-o            As Decimal              No-Undo.
Define Variable val-b            As Decimal              No-Undo.
Define Variable val-o            As Decimal              No-Undo.

/*--------------- ��।������ �� ��� 横��� ---------------*/

/* ��砫�� ����⢨� */
{getdate.i}

def var bDocRub as logical no-undo.

def var bDocDrg as logical no-undo.

def var bDocKas as logical no-undo.

def var nDigit  as integer no-undo.

def var nDocAmt like op-entry.amt-rub no-undo.

DEFINE BUFFER xop-entry FOR op-entry.

DEFINE VARIABLE mReRate    AS CHARACTER NO-UNDO.
DEFINE VARIABLE adb        AS CHARACTER NO-UNDO.
DEFINE VARIABLE acr        AS CHARACTER NO-UNDO.
DEFINE VARIABLE isCash     AS LOGICAL   NO-UNDO.

{op-cash.def}
mReRate    = FGetSetting("�����(b)", "������",   "*empty*").


for each op where op-date = end-date and op.op-status >= gop-status no-lock:
    bDocRub = YES.

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

        assign
  
            bDocKas     = isCash.
            bDocDrg     = false

        .

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

        assign

            tot-b  = tot-b  + nDocAmt       /* ������ �� ���㬥��� */

                when (op.acct-cat = "b")

            k-b = k-b + nDocAmt             /* ������ �� ���ᮢ� */

                when (op.acct-cat = "b")

                 /*and (bDocRub)*/ and (bDocKas)

            val-b = val-b + nDocAmt         /* ������ ����� ����ਠ��� */
    
                when (op.acct-cat = "b")
    
                 and (not bDocRub) and (not bDocDrg) and (not bDocKas)
    
            kinv-b = kinv-b + nDocAmt       /* ������ ����� ���ᮢ� */
    
                when (op.acct-cat = "b")

             and (not bDocRub) and (not bDocDrg) and (bDocKas)

            drag-b = drag-b + nDocAmt       /* ������ �ࠣ.���. ����ਠ��� */
    
                when (op.acct-cat = "b")
    
                 and (not bDocRub) and (bDocDrg) and (not bDocKas)
    
            k-drag-b = k-drag-b + nDocAmt   /* ������ �ࠣ.���. ���ᮢ� */
    
                when (op.acct-cat = "b")

             and (not bDocRub) and (bDocDrg) and (bDocKas)

            tot-o  = tot-o  + nDocAmt       /* ��������� �� ���㬥��� */
    
                when (op.acct-cat = "o")
    
            k-o = k-o + nDocAmt             /* ��������� �� ���ᮢ� */
    
                when (op.acct-cat = "o")
    
                 /*and (bDocRub)*/ and (bDocKas)

            val-o = val-o + nDocAmt         /* ��������� ����� ����ਠ��� */
    
                when (op.acct-cat = "o")
    
                 and (not bDocRub) and (not bDocDrg) and (not bDocKas)
    
            kinv-o = kinv-o + nDocAmt       /* ��������� ����� ���ᮢ� */
    
                when (op.acct-cat = "o")

                 and (not bDocRub) and (not bDocDrg) and (bDocKas)
    
            drag-o = drag-o + nDocAmt       /* ��������� �ࠣ.���. ����ਠ��� */
    
                when (op.acct-cat = "o")
    
                 and (not bDocRub) and (bDocDrg) and (not bDocKas)
    
            k-drag-o = k-drag-o + nDocAmt   /* ��������� �ࠣ.���. ���ᮢ� */

                when (op.acct-cat = "o")
    
                 and (not bDocRub) and (bDocDrg) and (bDocKas)
    
        .
    
    end.
    
end.

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
{get_set.i "����"}

    assign

/*       bank-name = setting.val*/
       bank-name = cBankName

    .

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� dob */
assign

 dob = end-date

.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� drag-b */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� drag-o */
/* ����� ��砫�� ����⢨� */

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

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� tot-b */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� tot-o */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� val-b */
/* ����� ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� val-o */
/* ����� ��砫�� ����⢨� */

/*-------------------- ��ନ஢���� ���� --------------------*/
{strtout3.i &cols=83 &option=Paged}

put unformatted "�ப �࠭����   __________________________________________________" skip.
put unformatted " " skip.
put unformatted "��娢�� ������ __________________________________________________" skip.
put unformatted " " skip.
put skip(1).
put unformatted "                 " Bank-name Format "x(50)"
                "" skip.
put skip(3).
put unformatted "��壠���᪨� ���㬥��� �� " dob Format "99/99/9999"
                "." skip.
put skip(3).
put unformatted "                                �� �����ᮢ� ��⠬       �� ��������ᮢ� ��⠬" skip.
put skip(1).
put unformatted "��壠���᪨� ���㬥���" skip.
put unformatted " " skip.
put unformatted "�� �㬬�                    " tot-b Format "->>>,>>>,>>>,>>9.99"
                "  ��.     " tot-o Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put skip(2).
put unformatted "�� ��� ��室���� � �⤥���� ������:" skip.
put skip(1).
put unformatted "���ᮢ� ���㬥���          " k-b Format "->>>,>>>,>>>,>>9.99"
                "  ��.     " k-o Format "->>>,>>>,>>>,>>9.99"
                "  ��." skip.
put skip(2).
put unformatted "    �� ������ � �����࠭��� ����⮩:" skip.
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
put unformatted "     �ப �࠭����  ____________" skip.
put unformatted " " skip.
put unformatted " " skip.
put skip(4).
put unformatted "���㬥��� ����஢��� � ������ __________________" skip.
put unformatted "                                   (�������)" skip.
put skip(2).
put unformatted "�ᯮ���⥫�:  " Ispol Format "x(50)"
                "" skip.

{endout3.i &nofooter=yes}

