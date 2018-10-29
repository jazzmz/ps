/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2003 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: a-in.p
      Comment: ��室 ���ਠ���� 業���⥩
   Parameters:
         Uses:
      Used by:
      Created: 13:39 24.03.98 PETER
     Modified: 24.12.2001 shin - ��������� �ଠ� � �裡 � ���������� ��������
*/

&SCOPED-DEFINE Init_DebugXAttr YES

{g-defs.i}
{globals.def}
{a-defs.i}
{def-wf.i NEW}
{defframe.i new}
{a-persis.get}

DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
DEFINE INPUT PARAMETER oprid      AS RECID NO-UNDO.

/* �����⥬� ��� ����窨 */
DEFINE VARIABLE in-contract  LIKE loan.contract       NO-UNDO.

/* �ࠧ� ���樠�����㥬 ����� ⥪�饣� ����� */
in-contract = work-module.

/* �������� ����� ����窨 - ���筨��
** (������ ���� �⪠� ��� ���������� ����୮�� ।���஢����)
*/
DEFINE VARIABLE in-cont-code LIKE loan.cont-code.

/* ���� �࠭��� ��� ����樨 */
DEFINE VARIABLE xtab-no      LIKE employee.tab-no     NO-UNDO.
DEFINE VARIABLE xbranch-id   LIKE branch.branch-id    NO-UNDO.
DEFINE VARIABLE sname        AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE xQty         LIKE kau-entry.qty       NO-UNDO.

/* ��� �����⥭⭮� ������⥪� a-obj.p */
DEFINE VARIABLE ht           AS   HANDLE              NO-UNDO.

/* ��� �࠭���樨 �ਢ離� ��⮢ */
DEFINE VARIABLE mAcctOpKind  AS   CHARACTER           NO-UNDO.

/* ��६����, ����室��� �: */
/* pir-a-opcal.i   */
DEFINE VARIABLE tcur-db      LIKE op-templ.currency   NO-UNDO.
DEFINE VARIABLE tcur-cr      LIKE op-templ.currency   NO-UNDO.

/* asswop.i    */
DEFINE VARIABLE dval         LIKE op-entry.value-date NO-UNDO.

/* a-op.cr     */
DEFINE VARIABLE noe          LIKE op-entry.op-entry   NO-UNDO.

/* details.def */
DEFINE VARIABLE fler         AS   LOGICAL             NO-UNDO.

/* ���� �६����� ⠡���� ��뫮� �� ᮧ����� ���㬥��� */
DEFINE BUFFER xwop FOR wop.

FORM
   op.doc-type       LABEL "��������"
          " " doc-type.name
   op.doc-num        LABEL "N"
   op.doc-date       LABEL "��"
"������������������������������������������������������������������������������"

   in-cont-code      LABEL "���.�����/��������"
                     HELP "�������� ����� 業����"
          " " asset.name
SKIP
   mCostNew          LABEL "���������"
   xqty              LABEL "���-��"
   remove-amt        LABEL "�����"
                     FORMAT "z,zzz,zzz,zzz,zz9.99"
"������������������������������������������������������������������������������"
   xbranch-id        LABEL "�����/�����"
                     HELP "��� ���ࠧ������� �� ��. ��������"
    " " branch.name  FORMAT "x(16)"

   xtab-no           LABEL "   ���.���"
                     HELP "������� ����� ���ਠ�쭮-�⢥��⢥����� ���"
    " " sname        FORMAT "x(16)"
"�[ ���������� �������� ]�������������������������������[ F3-�।., F4-᫥�. ]�"
   op.details        VIEW-AS EDITOR INNER-CHARS 78 INNER-LINES 3
WITH FRAME opreq 1 DOWN OVERLAY CENTERED SIDE-LABELS NO-LABEL ROW 3
     TITLE COLOR BRIGHT-WHITE "[ �������� : " + op-kind.name + " ]".

{a-wopacc.i
   &db=yes
   }
{a-wopacc.i}

/* ��⠭�������� ������⥪� ������� �㭪権 ��� */
RUN a-obj.p  PERSISTENT SET ht
   (
     INPUT "Main"
   , INPUT ""
   , INPUT ""
   ) .

FIND FIRST op-kind
     WHERE RECID(op-kind) EQ oprid
   NO-LOCK.

/* ���������� �६����� ⠡���� 蠡����� �஢���� */
RUN Templ_Cre.

{a-op.trg
   &ONcalc    = YES
   &RemAmt    = YES
   &Details   = YES
   &ONcalcAmt = YES
   }
{chkacces.i}
{g-currv1.i}
{a-debug.i}
{plibinit.i
   &TransParsLibs = "a-pfunc.p"
   }
{a-tr-prc.i}

gen:
DO TRANSACTION WITH FRAME opreq
ON ENDKEY UNDO, LEAVE
ON ERROR  UNDO, LEAVE
:
   HIDE FRAME edtempl NO-PAUSE.

   ASSIGN
      cur-op-date = in-op-date
      dval        = in-op-date
      xqty        = (IF CAN-DO("��,���", work-module)
                     THEN 1
                     ELSE 0)
      remove-amt  = xqty * mCostNew WHEN AVAILABLE asset
      .

   RELEASE op.
   RUN Op_Cre
      (
        INPUT "FIRST"
      ) .

   COLOR DISPLAY BRIGHT-GREEN
      doc-type.name
      asset.name
      branch.name
      sname
      .

   COLOR DISPLAY BRIGHT-WHITE
      op.doc-type
      op.doc-num
      op.doc-date
      op.details
      in-cont-code
      xbranch-id
      xtab-no
      mCostNew
      xqty
      remove-amt
      .

   RUN GetDocTypeName IN h_op (op.doc-type, OUTPUT mDocTypeName).

   DISPLAY
      op.doc-type   WHEN op.doc-type  NE ""
      mDocTypeName @ doc-type.name
      op.doc-num    WHEN op.doc-num   NE ""
      op.doc-date   WHEN op.doc-date  NE ?

      in-cont-code  WHEN in-cont-code NE ""
      GetObjName(
                  "loan"
                , in-contract + "," + AddFilToLoan(
                                                    in-cont-code
                                                  , shFilial
                                                  )
                , NO
                )                      @ asset.name
      mCostNew      WHEN AVAILABLE asset

      xbranch-id    WHEN xbranch-id   NE ""
      GetObjName(
                  "branch"
                , xbranch-id
                , YES
                )                      @ branch.name

      xtab-no       WHEN xtab-no      NE 0
      GetObjName(
                  "employee"
                , shFilial + "," + STRING(xtab-no)
                , NO
                )                      @ sname

      xqty
      remove-amt
      op.details
      .

   sset:
   DO ON ERROR  UNDO gen, RETRY gen
      ON ENDKEY UNDO gen, LEAVE gen
   :
      SET
         op.doc-type  WHEN op.doc-type  EQ ""
         op.doc-num
         op.doc-date
         in-cont-code WHEN in-cont-code EQ ""
         xqty         WHEN LOOKUP(work-module, "��,���") EQ 0
         remove-amt
         xbranch-id
         xtab-no
         op.details
         .

      ASSIGN
         mDoc-Num  = op.doc-num
         mDoc-Date = op.doc-date
         mDetails  = op.details
         .

      {justamin}

      RUN Change IN ht
         (
           INPUT in-contract
         , INPUT AddFilToLoan(
                               in-cont-code
                             , shFilial
                             )
         , INPUT xtab-no
         , INPUT xbranch-id
         ) .

      PAUSE 0.

      IF OPSYS NE "unix" THEN
         CLEAR FRAME edtempl ALL NO-PAUSE.

      IF FRAME-LINE NE 0 THEN
         UP FRAME-LINE - 1.

      RUN Op_Cre
         (
           INPUT "EACH"
         ) .

      {pir-a-opcal.i
         &qty       = "STRING(xqty)"
         &open-undo = "UNDO gen, RETRY gen"
         &kau-undo  = "UNDO gen, RETRY gen"
         }

      HIDE FRAME edtempl NO-PAUSE.

      RUN Op_Upd
         (
           INPUT YES
         ) .

      PAUSE 0 BEFORE-HIDE.

      RUN "a-en(ok.p"
         (
           INPUT 12
         ) .

      IF CAN-DO("END-ERROR,ENDKEY", KEYFUNCTION(LASTKEY)) THEN
         UNDO gen, RETRY gen.
   END.
END.

{a-persis.del}

{g-print1.i}

{a-tr-end.i}

RETURN.


PROCEDURE OnGoOfFrame:
   DEFINE VARIABLE vH AS HANDLE NO-UNDO.

   vH = FRAME opreq:HANDLE.
   vH = vH:FIRST-CHILD.
   vH = vH:FIRST-CHILD.
   DO WHILE VALID-HANDLE(vH):
      IF vH:SENSITIVE AND
         vH:VISIBLE
      THEN DO:
         APPLY "LEAVE" TO vH.
         IF RETURN-VALUE EQ {&RET-ERROR} THEN
            RETURN ERROR.
      END.
      vH = vH:NEXT-SIBLING.
   END.
END PROCEDURE. /* OnGoOfFrame */

