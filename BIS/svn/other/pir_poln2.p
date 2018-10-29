/* pir_poln2.p - ���� �� ��������� �����⮢ 2 (����祭� ����� ⮫쪮 ��.���)
   ������/������ �� ������� ������/������
   01/02/12 SStepanov ��������� � ���� ��⮢ 30109* �� ������ ����⠭���� �.�.
*/

{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdates.i}

def var typk as char no-undo.
def var blok as logical no-undo.
/* def var mBes as logical no-undo. */


/* �६���� ⠡���� ��� �࠭���� �⮡࠭��� ��⮢  */
define TEMP-TABLE ttTable NO-UNDO
	field facct as char
	Field fdate as char.

define TEMP-TABLE ttTable2 NO-UNDO
	field facct as char
	Field fdate as char.

define TEMP-TABLE ttTable3 NO-UNDO
	field facct as char
	Field fdate as date.



/* message "OK" view-as alert-box. */
 
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
/* mBes = NO. */

CASE INTEGER(pick-value):
   WHEN 1 THEN typk = "".
   WHEN 2 THEN typk = "b".
   WHEN 3 THEN typk = "n".
   WHEN 4 THEN blok = YES.
   OTHERWISE RETURN.
END CASE.

MESSAGE "�뢮���� �����⮢ � ������묨 ��������ﬨ?"
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO
        UPDATE mBes AS LOGICAL.

{setdest.i &cols=80}

def var symb as char no-undo.
def var polndt as char no-undo.
def var dtt as date no-undo.

symb = "-".

   put screen col 1 row 24 color bright-blink-normal 
       "��ࠡ��뢠���� " + STRING(end-date,"99/99/9999") + STRING(" ","X(55)").

   PUT UNFORMATTED "                              ���� �� ���������  " SKIP.
   Put unformatted "                          �� " beg-date " - " end-date SKIP.
   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   PUT UNFORMATTED  "|         ���         |                  �ப �������稩               |" SKIP.
   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.

 FOR EACH acct WHERE CAN-DO("4*,30109*", acct.acct)
                        AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) )
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

    /*  IF (sh-bal EQ 0)  THEN NEXT.*/

      polndt = TRIM(GetXAttrValue("acct", acct.acct + "," + acct.currency,"�ਬ1")).
 
   IF polndt NE "" THEN 
   DO:
      if polndt matches "*���*" or polndt matches "*�/�*" then 
       do:
         create ttTable2.
         ttTable2.facct = acct.acct.
	       ttTable2.fdate = polndt.
	       update.	 
       end.
      else
       do:
        
        dtt = DATE(polndt) NO-ERROR.
  
        IF ERROR-STATUS:ERROR THEN 
        do: /* ���ࠢ���� �ଠ� ���� */
         create ttTable.
         ttTable.facct = acct.acct.
	       ttTable.fdate = polndt.
	       update.	 
        end.
        ELSE 
        do: 
         IF dtt>=beg-date and dtt<=end-date THEN 
         do:
         create ttTable3.
         ttTable3.facct = acct.acct.
	       ttTable3.fdate = dtt.
	       update.	 
         end.
        end.
/*            PUT UNFORMATTED  "| " acct.acct FORMAT "x(20)" " | " string(dtt,"99/99/9999") "|" acct.acct-status FORMAT "x(8)" SKIP.
*/
       end.
  END.

/*����� for*/
 end.
 
for each ttTable3 by fdate:
      PUT UNFORMATTED  "| " ttTable3.facct FORMAT "x(20)" " | " string(ttTable3.fdate,"99/99/9999") "                                     |" SKIP.
end.



   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   PUT UNFORMATTED " " skip.
   PUT UNFORMATTED " " skip.
   PUT UNFORMATTED " " skip.

   PUT UNFORMATTED "    ���� �� ��⠬ � �����४⭮ ���������� ४����⮬ ����1 " skip.
   Put unformatted "                          �� " beg-date " - " end-date SKIP.
   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   PUT UNFORMATTED  "|        ���        | �ப �������稩  ���������� �����������!!!       |" SKIP.
   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.

 for each ttTable:
   PUT UNFORMATTED  "|" ttTable.facct FORMAT "x(20)" "| " ttTable.fdate FORMAT "x(48)" " |"  SKIP.
 end.


   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   PUT UNFORMATTED " " skip.
   PUT UNFORMATTED " " skip.
   PUT UNFORMATTED " " skip.

   IF mBes THEN DO:
      PUT UNFORMATTED "    ���� �� ��⠬ � ������묨 ���������" skip.
      Put unformatted "                          �� " beg-date " - " end-date SKIP.
      PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
      PUT UNFORMATTED  "|        ���        | �ப �������稩                                  |" SKIP.
      PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   
      for each ttTable2:
         PUT UNFORMATTED  "|" ttTable2.facct FORMAT "x(20)" "| " ttTable2.fdate FORMAT "x(48)" " |"  SKIP.
      end.
      PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   END.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").


{preview.i}
