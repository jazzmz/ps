{pirsavelog.p}

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2003 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: af-amor.p
      Comment: ����� ����⨧�樨
   Parameters:
         Uses:
      Used by:
      Created: 01.03.1998 Peter
     Modified: 09/08/2004 Om ��ࠡ�⪠. ������祭 �⠭����� ��㧥� �� ���.
     Modified:
*/

{intrface.get date}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

{g-defs.i}
{a-defs.i}
{globals.def}
{def-wf.i new}
{defframe.i new " - 3"}

DEF INPUT PARAMETER in-op-date AS DATE   NO-UNDO.
DEF INPUT PARAMETER oprid      AS RECID  NO-UNDO.

DEF NEW SHARED VAR list-id AS CHAR NO-UNDO.

DEF BUFFER xwop  FOR wop.
DEF BUFFER b2-op FOR op.
DEF BUFFER op    FOR op.

/* ���� ��ꥤ����� �஢���� �� ࠭� ����窠�? */
DEF VAR mAlong       AS LOGICAL  NO-UNDO INITIAL YES.
/* ���� ��� �롮� ��ਠ�� */
DEF VAR mOK          AS LOGICAL  NO-UNDO.
/* �����⥬� ���           */
DEF VAR in-contract  AS CHAR     NO-UNDO.
/* ���.� ����窨 ���       */
DEF VAR in-cont-code AS CHAR     NO-UNDO.
/* ��� �����⥭⭮� ��楤��� a-obj.p */
DEF VAR ht           AS HANDLE   NO-UNDO.

DEF VAR fler         AS LOGICAL  NO-UNDO.
DEF VAR tcur-db      AS CHAR     NO-UNDO.
DEF VAR tcur-cr      AS CHAR     NO-UNDO.
DEF VAR noe          AS INT      NO-UNDO.
DEF VAR dval         AS DATE     NO-UNDO.
DEF VAR nn           AS INT      NO-UNDO.
DEF VAR inter        AS DECIMAL  NO-UNDO.
DEF VAR tstr         AS CHAR     NO-UNDO.
DEF VAR MonOldBeg    AS CHAR     NO-UNDO.
DEF VAR MonOldEnd    AS CHAR     NO-UNDO.


     MonOldBeg = string(FirstMonDate(GoMonth(in-op-date,-1))).
     MonOldEnd = string(LastMonDate(GoMonth(in-op-date,-1))).

/* ��騥 �஢�ન �����⨬��� �஢������ ����⨧�樨. */
FUNCTION Can-Amort RETURNS LOGICAL :

   DEF BUFFER op-kind FOR op-kind.
   DEF BUFFER op      FOR op.

   /* ��ࢮ� �᫮ ����� ⥪�饩 ���� */
   DEF VAR vMonBeg    AS DATE     NO-UNDO.
   /* ��ࢮ� �᫮ ᫥���饣� �����   */
   DEF VAR vMonEnd    AS DATE     NO-UNDO.
   /* ���� ��� �롮� ��ਠ�� */
   DEF VAR vOK        AS LOGICAL  NO-UNDO.
   

   ASSIGN
     vMonBeg = FirstMonDate(in-op-date)
     vMonEnd = LastMonDate (in-op-date).

   FOR
      EACH  op-kind WHERE
            op-kind.module =       work-module
        AND op-kind.proc   MATCHES "*spis*"
         NO-LOCK,

      FIRST op WHERE
            op.op-kind  = op-kind.op-kind
        AND op.op-date >= vMonBeg
        AND op.op-date <= vMonEnd
         NO-LOCK:

      MESSAGE
         "������ ���㬥�� � ������६���� ᯨᠭ���"      SKIP
         "��" op.op-date "�" op.doc-num                   SKIP(1)
         "��������, ������६����� ᯨᠭ�� � �⮬ �����" SKIP
         "㦥 �஢�����! �த������?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE vOK.

      RETURN vOK.
   END.

   RETURN YES.
END FUNCTION. /* Can-Amort */

/* �஢�ન �����⨬��� �஢������ ����⨧�樨 �� ����窥. */
FUNCTION Can-Amort-Loan RETURNS LOGICAL :

   /* ���� ��� �롮� ��ਠ��                  */
   DEF VAR vOK       AS LOGICAL  NO-UNDO.
   /* ���᮪ ��ਮ��� ����ࢠ樨/४������樨 */
   DEF VAR vConsPers AS CHAR     NO-UNDO.
   /* ��।��� ��ਮ� ����ࢠ樨/४������樨*/
   DEF VAR vPer      AS CHAR     NO-UNDO.
   /* ���稪                                   */
   DEF VAR vI        AS INT      NO-UNDO.
   /* ��ਮ� ����� ����⨧�樨                */
   DEF VAR vMonPer   AS DATE     NO-UNDO EXTENT 2.

   /* ��ਮ� ����� ����⨧�樨                */
   ASSIGN
      vMonPer[1] = FirstMonDate(in-op-date)
      vMonPer[2] = LastMonDate (in-op-date).

   /* �᫨ ����窠 ����� ����� ��砫� �����,
   ** � ����⨧��� ���筮 �� �஢������ (�᪫�祭�� ��� ����� ���2).
   */
   IF loan.open-date >= vMonPer[1] THEN
   DO:
      IF loan.class-code <> "���2"
      THEN
         RETURN NO.
      ELSE
      DO:
         vOK = NO.

         MESSAGE
            "����窠 " loan.cont-code asset.name  SKIP
            "�������� � ⥪�饬 �����!"           SKIP
            "�믮����� �� ��� ������?"
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE vOK.

         IF vOK <> YES  THEN
            RETURN vOK.
      END.
   END.

   /* ���᮪ ��ਮ��� ����ࢠ樨/४������樨 */
   vConsPers  = GetXAttrValueEx("loan",
                                loan.contract + "," + loan.cont-code,
                                "��ਮ�����",
                                ?
                               ).

   IF vConsPers <> ? THEN
   DO vI = 1 TO NUM-ENTRIES(vConsPers):
      vPer = ENTRY(vI, vConsPers).
      /* �᫮��� ����祭�� ��ਮ��� */
      IF DATE(ENTRY(1, vPer, "-")) <= vMonPer[2] AND
         DATE(ENTRY(2, vPer, "-")) >= vMonPer[1] THEN
      DO:
         vOK = NO.

         MESSAGE
            "� �⮬ ����� 業����� " loan.doc-ref
                  GetObjName("asset", loan.cont-type, NO)  SKIP
            "��室����� �� ����ࢠ樨/४������樨."     SKIP
            "�஢����� ����⨧��� �� 業����?"
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE vOK.

         IF vOK <> YES  THEN
            RETURN vOK.
         ELSE
            LEAVE.
      END.
   END.

   RETURN YES.

END FUNCTION. /* Can-Amort-Loan */

/* ��।������ �᭮���� ��� ����� �࠭���樨 */
FORM
"��������" op.doc-type ":" doc-type.name "N" op.doc-num "��" op.doc-date SKIP
"�[ ���������� �������� ]�������������������������������[ F3-�।., F4-᫥�. ]�"
  op.details  VIEW-AS EDITOR INNER-CHARS 78 INNER-LINES 3
WITH FRAME opreq 1 DOWN OVERLAY CENTERED NO-LABEL ROW 3
     TITLE COLOR bright-white "[ �������� : " + op-kind.name + " ]".

{a-wopacc.i
   &db=YES
}
{a-wopacc.i}

/* ��騥 �஢�ન �����⨬��� �஢������ ����⨧�樨 */
IF Can-Amort() <> YES  THEN
   RETURN.

FIND FIRST op-kind WHERE
     RECID(op-kind) = oprid
NO-LOCK.

{plibinit.i &TransParsLibs = "a-pfunc.p" }

mAlong = (GetXAttrValueEx ("op-kind",
                           op-kind.op-kind,
                           "along",
                           GetXattrInit (op-kind.class-code,
                                         "along"
                                        )
                          ) = "���� ���㬥��"
         ).

/* ���������� �६����� ⠡���� 蠡����� �஢���� */
RUN Templ_Cre.

{a-op.trg
   &OFFbranch = YES
   &OFFtab-no = YES
   &ONgroup   = YES
   &Details   = YES
}

/* �롨ࠥ�, �� ����� ����窠� �஢���� ����⨧��� */
{empty tmprecid}

/* ����� ��㧥� �� ���. */
RUN browseld.p (work-module,"open-date1" + CHR(1) + "open-date2" + CHR(1) + "close-date1",
                            MonOldBeg + CHR(1) + MonOldEnd + CHR(1) + "" + CHR(1) + "��-���-���",
			    "open-date1" + CHR(1) + "open-date2", 4).

IF KEY-FUNCTION(LASTKEY) = "END-ERROR" OR
   NOT CAN-FIND(FIRST tmprecid) THEN
DO:
   RUN EndPurge.
   RETURN.
END.

/* ��⠭�������� ������⥪� ������� �㭪権 ��� */
RUN a-obj.p PERSISTENT SET ht ("Main",  "", "").

{chkacces.i}
{g-currv1.i}
{a-debug.i}

{a-tr-prc.i}

gen:
DO TRANSACTION WITH FRAME opreq
   ON ENDKEY UNDO gen, LEAVE gen
   ON ERROR  UNDO gen, LEAVE gen:

   RUN SetSysConf IN h_base ("", STRING(THIS-PROCEDURE)).
   RUN SetSysConf IN h_base ("", "YES").

   ASSIGN
     cur-op-date = in-op-date
     dval        = in-op-date.

   HIDE FRAME edtempl NO-PAUSE.

   RELEASE op.
   RUN Op_Cre ("FIRST").

   COLOR DISPLAY BRIGHT-GREEN
      doc-type.name.

   COLOR DISPLAY BRIGHT-WHITE
      op.doc-type
      op.doc-num
      op.doc-date
      op.details.

      RUN GetDocTypeName IN h_op (op.doc-type, OUTPUT mDocTypeName).

   DISPLAY
      op.doc-type    WHEN op.doc-type <> ""
      mDocTypeName
    @ doc-type.name
      op.doc-num     WHEN op.doc-num  <> ""
      op.doc-date    WHEN op.doc-date <> ?
      op.details.

   sset:
   DO ON ERROR  UNDO gen, LEAVE gen
      ON ENDKEY UNDO gen, LEAVE gen:

      SET
         op.doc-type WHEN op.doc-type = ""
         op.doc-num
         op.doc-date
         op.details.

      ASSIGN
         mDoc-Num  = op.doc-num
         mDoc-Date = op.doc-date
         mDetails  = op.details.

      {justamin}

      IF OPSYS <> "unix" THEN
         CLEAR FRAME edtempl ALL NO-PAUSE.

      IF FRAME-LINE <> 0 THEN
         UP FRAME-LINE - 1.

      IF mAlong THEN
         RUN Op_Cre("EACH").

      ASSIGN
         chpar1 = ""
         chpar2 = work-module.

      /* ��ॡ�� ��࠭��� ����祪 ���. */
      FOR
         EACH  tmprecid
            NO-LOCK,

         FIRST loan WHERE
               RECID(loan)      = tmprecid.id
           AND loan.open-date  <= in-op-date
           AND (loan.close-date = ? OR
                loan.close-date > in-op-date
               )
            NO-LOCK,

         FIRST asset WHERE
               asset.cont-type = loan.cont-type
            NO-LOCK

         ON ERROR  UNDO gen, LEAVE gen
         ON ENDKEY UNDO gen, RETRY gen:

         ASSIGN
            in-contract  = loan.contract
            in-cont-code = loan.doc-ref.

         /* �஢�ન �����⨬��� �஢������ ����⨧�樨 */
/*         mOK = Can-Amort-Loan().

         IF mOK = ?  THEN
            UNDO gen, LEAVE gen.

         IF mOK = NO THEN
            NEXT.
*/
         /* ����ன�� �� ᫥������ ������ */
         RUN Change IN ht (loan.contract,
                           loan.cont-code,
                           ?,
                           ""
                          ).

         IF NOT mAlong THEN
            RUN Op_Cre("EACH").

         {debuger.i '"af-amor.p:���᫥��"' "inter"}

         {a-opcal.i
            &open-undo = "UNDO gen, RETRY gen"
            &kau-undo  = "UNDO gen, RETRY gen"
         }

         IF mAlong THEN
            {additem.i chpar1 loan.doc-ref}
         ELSE
         DO:
            chpar1 = loan.doc-ref.
            RUN Op_Upd (YES).
         END.
      END.

      HIDE FRAME edtempl NO-PAUSE.

      IF mAlong THEN
         RUN Op_Upd (YES).

      PAUSE 0 BEFORE-HIDE.

      RUN "op-en(ok.p" (9).
      IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN
         UNDO gen, RETRY gen.
   END.
END.

IF mErr THEN
DO:
   {preview2.i
      &stream   = " STREAM err "
      &filename = "a-trans"
   }
END.

{g-print1.i}

{a-tr-end.i
   &DelTempTable = tmprecid
}

RETURN.