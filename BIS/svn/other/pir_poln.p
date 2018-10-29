{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdate.i}

def var typk as char no-undo.
def var blok as logical no-undo.

RUN messmenu.p(
       10,
       "[�������]",
       "",
       "��," +
       "����-������," +
       "�஬� ����-������," +
       "�� � �����஢���묨 ��⠬�").

typk = "".
blok = NO.

CASE INTEGER(pick-value):
   WHEN 1 THEN typk = "".
   WHEN 2 THEN typk = "b".
   WHEN 3 THEN typk = "n".
   WHEN 4 THEN blok = YES.
   OTHERWISE RETURN.
END CASE.

{setdest.i &cols=80}

def var symb as char no-undo.
def var polndt as char no-undo.
def var dtt as date no-undo.

symb = "-".

   put screen col 1 row 24 color bright-blink-normal 
       "��ࠡ��뢠���� " + STRING(end-date,"99/99/9999") + STRING(" ","X(55)").

   PUT UNFORMATTED "                   ���� �� ��������� �� " end-date SKIP.
   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   PUT UNFORMATTED  "|        ���        |                    �ப �������稩               |" SKIP.
   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.

   FOR EACH acct WHERE open-date LE end-date
                         AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) ) 
                         AND CAN-DO("4*", acct.acct)
           NO-LOCK BREAK BY acct :

   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.

      IF NOT blok THEN 
         IF UPPER(SUBSTR(acct.acct-status,1,4))="����" THEN NEXT.

      IF typk EQ "b" THEN
         IF UPPER(TRIM(GetXAttrValue("cust-corp",STRING(acct.cust-id),"������"))) NE "��" THEN NEXT.
      ELSE IF typk EQ "n" THEN
         IF UPPER(TRIM(GetXAttrValue("cust-corp",STRING(acct.cust-id),"������"))) EQ "��" THEN NEXT.

      RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

      IF (sh-bal EQ 0)  THEN NEXT.

      polndt = TRIM(GetXAttrValue("acct", acct.acct + "," + acct.currency,"�ਬ1")).

      IF polndt NE "" THEN DO:
         IF (UPPER(polndt) NE UPPER("�����筮")) AND (UPPER(polndt) NE UPPER("�������")) AND (UPPER(polndt) NE UPPER("�\�")) THEN DO:
            IF LENGTH(polndt) NE 10 THEN 
               PUT UNFORMATTED  "|" acct.acct FORMAT "x(20)" "|" polndt FORMAT "x(50)" "|" acct.acct-status FORMAT "x(8)" SKIP.
            ELSE DO:
              dtt = DATE(polndt) NO-ERROR.
              IF ERROR-STATUS:ERROR THEN /* ���ࠢ���� �ଠ� ���� */
                  PUT UNFORMATTED  "|" acct.acct FORMAT "x(20)" "|" polndt FORMAT "x(50)" "|" acct.acct-status FORMAT "x(8)" SKIP.
               ELSE IF dtt<end-date THEN 
                  PUT UNFORMATTED  "|" acct.acct FORMAT "x(20)" "|" polndt FORMAT "x(50)" "|" acct.acct-status FORMAT "x(8)" SKIP.
            END.
         END. 
      END.
   end.

   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").


{preview.i}
