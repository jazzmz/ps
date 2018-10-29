{pirsavelog.p}

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: a-positn.p
      Comment: ��������� ���⪮�.
   Parameters:
         Uses: ap-sortg.i
      Used by:
      Created:
     Modified: 07.04.2004 fedm
*/

/* ������⢮ ��ப �� ��࠭�� */
/*Message "sagdf" VIEW-AS ALERT-BOX.*/
DEF INPUT PARAMETER iPar  AS CHAR  NO-UNDO.

DEF var iPageLength  AS INT  NO-UNDO.
iPageLength = INT(entry(1,iPar)).

iPageLength = (IF iPageLength <= 0
               THEN 0
               ELSE MAX(iPageLength, 20)
              ).

&SCOPED-DEFINE jer     NO
&GLOBAL-DEFINE by-acct YES
&GLOBAL-DEFINE cols    100
/* ����, �� ����� ����室��� ��������� �⮣� */
&GLOBAL-DEFINE TotalFields  af.name[1] ~
                            af.qty  ~
                            af.disc

/* ���������� temp-table af */
{ap-sortg.i
   &no-beg-date = YES
}

/* ����� �� ���浪� */
DEF VAR mLineN    AS INT   NO-UNDO.


{setdest.i &custom = " IF YES THEN iPageLength ELSE "}

DEF FRAME list
   mLineN          COLUMN-LABEL  "��"
                   FORMAT        ">>>9"
   af.inv-num      COLUMN-LABEL  "����������� N"
                   FORMAT        "x(13)"
   af.name[1]         COLUMN-LABEL  "������������"
   af.cont-type    COLUMN-LABEL  "��� ��������"
                   FORMAT        "x(12)"
   af.qty          COLUMN-LABEL  "����������"
                   FORMAT        "->>>>9.99"
   af.unit         COLUMN-LABEL  "��"
                   FORMAT        "x(4)"
   af.disc         COLUMN-LABEL  "�����"
                   FORMAT        "->>>,>>>,>>>,>>9.99"
WITH WIDTH {&cols} DOWN NO-BOX.

DEF FRAME fPageHead
   HEADER "���� " + STRING(PAGE-NUMBER) TO 78
WITH WIDTH {&cols} DOWN NO-BOX PAGE-TOP.

/* �뢮��� ��������� ���� ⮫쪮 �� ��ࢮ� ��࠭��! */
PUT UNFORMATTED
   GetReportName("������� �� ������ �� ����� ������������� ���")
SKIP(1).

VIEW FRAME fPageHead.

/* ��ନ஢���� ���� */
cyc:
FOR EACH  af
   BREAK BY af.sort-value:

   ACCUMULATE
      ?           (COUNT)
      af.qty      (TOTAL BY af.sort-value)
      af.disc     (TOTAL BY af.sort-value).

   IF FIRST-OF(af.sort-value) AND
      in-sort <> "no-group"
   THEN
   DO:
      IF LINE-COUNTER + 2 > PAGE-SIZE THEN
         PAGE.

      PUT UNFORMATTED " "
         GetGroupName()
      SKIP(1).
   END.

   DISPLAY
      (ACCUM COUNT ?) @ mLineN
      af.inv-num
      af.name[1]
      af.cont-type
      af.qty
      af.unit
      af.disc
   WITH FRAME list.

   DOWN WITH FRAME list.

   IF LAST-OF(af.sort-value) THEN
   DO:
      IF in-sort <> "no-group" THEN
      DO:
         IF LINE-COUNTER + 3 > PAGE-SIZE THEN
            PAGE.

         UNDERLINE {&TotalFields} WITH FRAME list.

         DISPLAY
            GetSubTitle()                          @ af.name[1]
            (ACCUM TOTAL BY af.sort-value af.qty)  @ af.qty
            (ACCUM TOTAL BY af.sort-value af.disc) @ af.disc
         WITH FRAME list.

         DOWN 1 WITH FRAME list.
      END.

      IF LAST(af.sort-value) THEN
      DO:
         UNDERLINE {&TotalFields} WITH FRAME list.

         DISPLAY
            "�⮣� �� ��������"                   @ af.name[1]
            (ACCUM TOTAL af.qty)                   @ af.qty
            (ACCUM TOTAL af.disc)                  @ af.disc
         WITH FRAME list.
      END. /* LAST */
   END. /* LAST-OF */
END.

	DISPLAY
	"��ࠢ���騩 ������                       ______________ " entry(2,iPar) FORMAT "x(20)" skip(2)
	"�������騩 ᪫����                       ______________ " entry(3,iPar) FORMAT "x(20)"skip (2)
	"����騩 ᯥ樠���� �⤥�� �� ���� ���   ______________ " entry(4,iPar) FORMAT "x(20)".
/* {signatur.i}*/
{preview.i}
{intrface.del}