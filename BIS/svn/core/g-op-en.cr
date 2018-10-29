/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2001 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: G-OP-EN.CR
      Comment:
   Parameters: &no-create-op-entry - ����� ��祣� �� ������
               &no-noe-define      - �� ������ ��६����
               &no-noe-calc        - �� ����� ����㯭� ����� �஢����
               &no-op-entry-create - �� ᮧ������ �஢����
               &no-op-entry-assign - �� �������� �஢����
               &no-op-entry-check  - �� �஢����� �ࠢ��쭮��� �஢����
         Uses:
      Used by: g-op.cr
      Created: 01.11.2002 15:14 SEMA    from g-op.cr
     Modified: 06.11.2002 14:39 SEMA     �� ��� 0010502 ��⠢���� ��ࠡ�⪠ ��ॡ�� ���⪮� �� ����⠬
     Modified: 10.04.2003 18:56 SEMA     �� ��� 0012638 � ⠡���� wop � ���� open-recid ��࠭���� ��뫪� ��
                                         ᮧ������ �஢����
     Modified: 20/07/2009 kraw (0070076) �맮� parssign.p ��� ������ �஢���� ���㬥��
*/

{intrface.get tmcod}
{intrface.get rights}

DEFINE VARIABLE mSymbolErr AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mSymbolMsg AS CHARACTER NO-UNDO.
/**
 * �� ��ࠡ�⪠ �������� ����������
 * �� �㡫�஢���� ��६�����.
 * ���: #2409
 * ���� : ��᫮� �. �. Maslov D. A.
 * 
 **/
&IF DEFINED (no-simbSide) EQ 0 &THEN
   DEFINE VARIABLE simbSide AS CHARACTER.
&ENDIF

&IF DEFINED (flag) NE 0 &THEN
set_type(in-cont-code).
&ENDIF
&IF DEFINED (no-create-op-entry) &THEN
   &SCOPED-DEFINE no-noe-define
   &SCOPED-DEFINE no-noe-calc
   &SCOPED-DEFINE no-op-entry-create
   &SCOPED-DEFINE no-op-entry-assign
   &SCOPED-DEFINE no-op-entry-check
&ENDIF

&IF DEFINED (no-noe-define) = 0 &THEN
         DEFINE VARIABLE noe AS INT64    NO-UNDO.
         &GLOBAL-DEFINE no-noe-define
&ENDIF

&IF DEFINED (no-noe-calc) = 0 &THEN
         find last op-entry of op no-error.
         noe = (if avail op-entry then op-entry.op-entry else 0) + 1.
&ENDIF

&IF DEFINED (no-op-entry-create) = 0 &THEN
         create op-entry.
&ENDIF
&IF DEFINED (no-op-entry-assign) = 0 &THEN
         assign
            op-entry.op         = op.op
            op-entry.op-entry   = noe
            op-entry.user-id    = op.user-id
            op-entry.op-status  = op.op-status
            op-entry.op-date    = op.op-date
            op-entry.acct-cat   = op.acct-cat
            op-entry.value-date = wop.value-date
            op-entry.acct-db    = wop.acct-db
            op-entry.acct-cr    = wop.acct-cr
            op-entry.currency   = wop.currency
            op-entry.amt-cur    = wop.amt-cur
            op-entry.amt-rub    = wop.amt-rub
            op-entry.type       = wop.type
            op-entry.op-cod     = wop.op-cod
            op-entry.prev-year  = wop.prev-year
            op-entry.op-status  = op.op-status

            wop.open-recid      = RECID(op-entry)
            .

         IF NOT GetTablePermissionEx("��ᑨ�����", "r") OR
            NOT tst-rght-code("��ᑨ�����", "r")
         THEN DO:
            &IF DEFINED(open-undo) > 0 &THEN
                {&open-undo}.
            &ENDIF
         END.
         simbSide = getTCodeFld("val", "��ᑨ�����", INPUT wop.symbol, op.op-date).
         IF NOT {assigned simbSide} THEN DO:
            IF wop.symbol NE "" THEN DO:
               mSymbolMsg = "".
               RUN GetXAttr IN h_xclass ("op-entry", "���", BUFFER xattr).
               RUN CheckField IN h_xclass (BUFFER xattr,
                                           INPUT wop.symbol,
                                           INPUT-OUTPUT mSymbolMsg,
                                           OUTPUT mSymbolErr).
               &IF DEFINED(open-undo) > 0 &THEN
               IF mSymbolErr THEN
                   {&open-undo}.
               &ENDIF
               UpdateSigns("op-entry",STRING(op.op) + "," + 
                           STRING(op-entry.op-entry),
                           "���",wop.symbol,YES).  
            END.
         END.
         ELSE
            op-entry.symbol     = wop.symbol.

&ENDIF

&IF DEFINED(RunParsSigns) NE 0 &THEN
RUN parssign2.p ("PARSSEN_ENTRY_",
                in-op-date,
                "op-template",
                op-kind.op-kind + "," + string(op-templ.op-templ),
                op-templ.class-code,
                "op-entry",
                STRING(op-entry.op) + "," + STRING(op-entry.op-entry),
                op-entry.class-code,
                RECID(op)).
&ENDIF

&IF DEFINED (no-op-entry-check) = 0 &THEN
   &IF defined(open-undo) EQ 0 &THEN
      {op-entry.upd
         &Ofnext    = "/*"
         &Offopupd  = "/*"
         &open-undo = "UNDO gen, RETRY gen "
         &kau-undo  = "UNDO gen, RETRY gen "
      }
   &ELSE
      {op-entry.upd
         &Offopupd = "/*"
         &Ofnext   = "/*"
         {&*}
      }
   &ENDIF

   &IF DEFINED(RunParsSigns) <> 0 &THEN
      /* �������� �� ⨯� PARSEN_<�����������>*/
      {g-psigns.i}
   &ENDIF
&ENDIF
