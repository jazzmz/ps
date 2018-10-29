{pirsavelog.p}
/** 
   ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2009

   ��ନ஢���� spiska VP.
   ���ᮢ �.�., 30.12.2009
*/

{globals.i}           /* �������� ��।������ */
{tmprecid.def}        /* �ᯮ��㥬 ���ଠ�� �� ��㧥� */
/*
{parsin.def}
{intrface.get xclass} /* �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get strng}  /* �㭪樨 ��� ࠡ��� � ��ப��� */
*/
{setdest.i}

/******************************************* ��।������ ��६����� � ��. */

DEFINE VARIABLE cKl       AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE cAnketa   AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE iwwI      AS INTEGER                     NO-UNDO.
DEFINE VARIABLE cPrLine   AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE iLineW    AS INTEGER   INIT 80           NO-UNDO.

DEFINE BUFFER   bCR       FOR cust-role.
/******************************************* ��������� */

iwwI = 0.

FOR EACH tmprecid
   NO-LOCK,
   FIRST cust-role
      WHERE (RECID(cust-role) EQ tmprecid.id)
        AND (cust-role.class-code EQ "�룮���ਮ���⥫�2")
      NO-LOCK
      BREAK BY cust-role.open-date:

   iwwI = iwwI + 1.

   IF FIRST(cust-role.open-date)
   THEN DO:
      IF (cust-role.file-name EQ "cust-corp")
      THEN DO:
         FIND FIRST cust-corp
            WHERE (cust-corp.cust-id EQ INTEGER(cust-role.surrogate))
            NO-ERROR.
         cKl = cust-corp.cust-stat + " " + cust-corp.name-corp.
      END.
      ELSE DO:
         FIND FIRST person
            WHERE (person.person-id EQ INTEGER(cust-role.surrogate))
            NO-ERROR.
         cKl = person.name-last + " " + person.first-names.
      END.

      /* ����� ��������� */
      cAnketa = "���᮪ �룮���ਮ���⥫�� ������ " + cKl + "| |".
   END.

   FIND FIRST bCR
      WHERE (bCR.cust-cat   EQ cust-role.cust-cat)
        AND (bCR.cust-id    EQ cust-role.cust-id)
        AND (bCR.class-code EQ "ImaginClient")
      NO-ERROR.

   cAnketa = cAnketa
           + STRING(iwwI, "-9") + ". "
           + STRING(cust-role.cust-name, "x(50)") + " "
           + STRING(cust-role.open-date, "99.99.9999")
           + (IF AVAIL bCR THEN " ������ �����|" ELSE "|")
           .
END.

DO WHILE (LENGTH(cAnketa) GT 0):

   IF (INDEX(SUBSTRING(cAnketa, 1, iLineW + 1), "|") NE 0)
   THEN
      ASSIGN
         cPrLine = SUBSTRING(cAnketa, 1, INDEX(cAnketa, "|") - 1)
         cAnketa = SUBSTRING(cAnketa, INDEX(cAnketa, "|") + 1)
      .
   ELSE
      ASSIGN
         iwwI    = MAX(R-INDEX(SUBSTRING(cAnketa, 1, iLineW + 1), " "),
                       R-INDEX(SUBSTRING(cAnketa, 1, iLineW    ), ","))
         iwwI    = (IF (iwwI GT 0) THEN iwwI ELSE iLineW)
         cPrLine = SUBSTRING(cAnketa, 1, iwwI)
         cAnketa = "      " + SUBSTRING(cAnketa, iwwI + 1)
      .
   IF (LENGTH(cPrLine) GT iLineW)
   THEN cPrLine = SUBSTRING(cPrLine, 1, iLineW).

   PUT UNFORMATTED cPrLine SKIP.
END.

{preview.i}
{intrface.del}
