{pirsavelog.p}


{globals.i}
{getdate.i}

{exp-path.i &exp-filename = "'analiz/clients.txt'"}

def var c1 as char no-undo.
def var c2 as char no-undo.
def var c3 as char no-undo.
def var c4 as char no-undo.
def var c5 as char no-undo.
def var c6 as char no-undo.
def var c7 as char no-undo.
def var c8 as char no-undo.
def var c9 as char no-undo.
def var ca as char no-undo.
def var cb as char no-undo.
def var cc as char no-undo.
def var cd as char no-undo.
def var ce as char no-undo.
def var cf as char no-undo.
def var cg as char no-undo.

def var clnt_id as int no-undo.

def var symb as char no-undo.
def buffer bPerson for person.


FUNCTION GetIPUchred CHAR:

 def var cResult as char INIT "" NO-UNDO.
 def var cName as char NO-UNDO.
 def var cSurname as char no-UNDO.

 cResult = GetTempXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "��।��",end-date,"").
 if cResult = "" then 
   DO:
     cName = cust-corp.name-corp.
     cSurname = ENTRY(1,cust-corp.name-corp," ").
     cName = TRIM(REPLACE(cName,ENTRY(1,cust-corp.name-corp," "),"")).

/*     message cSurname cName  VIEW-AS ALERT-BOX.*/



    find first bperson where bperson.inn = cust-corp.inn NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE bperson then 
    DO:
       find first bperson where bperson.first-names = cName
                            and bperson.name-last = cSurname
                            NO-LOCK NO-ERROR. 
    END.
    IF AVAILABLE bperson then cResult = bperson.name-last + " " + bperson.first-names + ":100%;".
  END.
    RETURN cResult.

END FUNCTION.


symb = "-".

/* ���㧪� ������ �� 䨧��栬 */
 
   put screen col 1 row 24 color bright-blink-normal 
       "��ࠡ��뢠���� �ࠢ�筨� 䨧���" + STRING(" ","X(48)").

 FOR EACH person NO-LOCK BREAK BY person-id :
  clnt_id = person.person-id.

 FIND FIRST acct WHERE  acct.cust-cat EQ "�" AND 
                                acct.cust-id  EQ clnt_id AND 
                                (acct.close-date EQ ? OR acct.close-date >= end-date) AND 
                                acct.open-date<= end-date NO-LOCK NO-ERROR.

 IF AVAIL acct THEN DO:



        put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
        CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
        END CASE.

  

 
        
        ASSIGN
             c1 = TRIM(GetXAttrValue("person", STRING(person-id), "���"))
             c2 = TRIM(GetXAttrValue("person", STRING(person-id), "date-in"))
             c3 = TRIM(GetXAttrValue("person", STRING(person-id), "date-out"))
             c4 = TRIM(name-last) + " " + TRIM(first-names)
             c5 = TRIM(address[1] + " " + address[2])
             c6 = inn
             c7 = TRIM(GetXAttrValue("person", STRING(person-id), "�ࠦ�"))
             /*c8 = IF num-entries(GetXAttrValue("person", STRING(person-id), "���"),";") = 2 THEN TRIM(entry(2,GetXAttrValue("person", STRING(person-id), "���"),";")) 	ELSE GetXAttrValue("person", STRING(person-id), "���")*/
             c8 = TRIM(GetXAttrValue("person", STRING(cust-id), "���"))
             c9 = TRIM(document-id)
             ca = TRIM(GetXAttrValue("person", STRING(person.person-id), "Document4Date_vid"))
             cb = TRIM(document)
             cc = TRIM(REPLACE(issue, CHR(10), " "))
             ce = TRIM(GetXAttrValue("person", STRING(person-id), "����⢥�����"))
        .
  


     put unformatted skip "�/� " c1 FORMAT "x(12)" " "
                             c2 FORMAT "x(10)" " "
                             c3 FORMAT "x(10)" " "
                             c4 FORMAT "x(160)" " "
                             c5 FORMAT "x(160)" " "
                             c6 FORMAT "x(22)" " "
                             c7 FORMAT "x(5)" " "
                             c8 FORMAT "x(20)" " "
                             c9 FORMAT "x(20)" " "
                             ca FORMAT "x(10)" " "
                             cb FORMAT "x(15)" " "
                             cc FORMAT "x(100)" " "
                             SPACE(40)
                             ce FORMAT "x(500)"
                             .

        END. /* �����, �᫨ ��� ������ */
   END. /* ����� �� 䨧. ��栬 */

/* ���㧪� ������ �� �૨栬 */

   put screen col 1 row 24 color bright-blink-normal 
       "��ࠡ��뢠���� �ࠢ�筨� �૨�" + STRING(" ","X(48)").

   FOR EACH cust-corp NO-LOCK:
                clnt_id = cust-corp.cust-id.
                 


     FIND FIRST acct WHERE  acct.cust-cat EQ "�" AND 
                acct.cust-id  EQ clnt_id AND 
                (acct.close-date EQ ? OR acct.close-date >= end-date) AND 
                acct.open-date  <= end-date NO-LOCK NO-ERROR.

       IF AVAIL acct THEN 
         DO:

        put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
        CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
        END CASE.
          
        ASSIGN
             c1 = TRIM(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "���"))
             c2 = STRING(cust-corp.date-in)
             c3 = STRING(cust-corp.date-out)
             c4 = IF TRIM(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "NoExport")) eq "" then TRIM(TRIM(cust-stat) + " " + TRIM(name-corp))
                                                                                         else TRIM(TRIM(cust-stat) + " " + TRIM(name-corp)) + "(�㡫�)"             
             c5 = TRIM(addr-of-low[1] + " " + addr-of-low[2])
             c6 = STRING(cust-corp.inn,"x(12)") + " " + STRING(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "���"),"x(9)")
             c7 = TRIM(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "�ࠦ�"))
		     c8 = TRIM(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "���"))
             c9 = TRIM(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "����᪠"))
             ca = TRIM(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "RegDate"))
             cb = TRIM(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "����"))
             cc = TRIM(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "RegPlace"))
             cd = IF CAN-DO("!�����,!��*,*",TRIM(cust-stat)) THEN TRIM(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "�����")) ELSE REPLACE(GetIPUchred(),":100%;","")
             ce = IF CAN-DO("!�����,!��*,*",TRIM(cust-stat)) THEN TRIM(GetTempXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "��।��",end-date,"")) ELSE GetIPUchred()
             cf = TRIM(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "���⠢��"))
             cg = TRIM(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "���⠢���"))
             
        .

   put unformatted skip "�/� " c1 FORMAT "x(12)" " "
                             c2 FORMAT "x(10)" " "
                             c3 FORMAT "x(10)" " "
                             c4 FORMAT "x(160)" " "
                             c5 FORMAT "x(160)" " "
                             c6 FORMAT "x(22)" " "
                             c7 FORMAT "x(5)" " "
                             c8 FORMAT "x(20)" " "
                             c9 FORMAT "x(20)" " "
                             ca FORMAT "x(10)" " "
                             cb FORMAT "x(15)" " "
                             cc FORMAT "x(100)" " "
                             cd FORMAT "x(40)"
                             ce FORMAT "x(500)"
                             cf FORMAT "x(500)"
                             cg FORMAT "x(500)".

        END. /* �����, �᫨ ������ ��� */

   
        
   END. /* ����� �� ��. ��栬 */


/************************************* ����� ********************************/


   put screen col 1 row 24 color bright-blink-normal 
       "��ࠡ��뢠���� �ࠢ�筨� ������" + STRING(" ","X(48)").

   FOR EACH banks WHERE client NO-LOCK BREAK BY bank-id :

        put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
        CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
        END CASE.

        ASSIGN
             c1 = TRIM(GetXAttrValue("banks", STRING(bank-id), "���"))
             c4 = TRIM(name)
             c5 = TRIM(law-address)
             c6 = inn 
             c7 = if (country-id EQ "RUS") then "�����" else "��१"
             c8 = IF num-entries(TRIM(GetXAttrValue("banks", STRING(bank-id), "���")),";") = 2 THEN TRIM(entry(2,TRIM(GetXAttrValue("banks", STRING(bank-id), "���")),";")) 
                                                                                                                                                                                                                                                                                                                             ELSE TRIM(GetXAttrValue("banks", STRING(bank-id), "���"))
             c9 = TRIM(GetXAttrValue("banks", STRING(bank-id), "����᪠"))
             ca = TRIM(GetXAttrValue("banks", STRING(bank-id), "RegDate"))
             cb = TRIM(GetXAttrValue("banks", STRING(bank-id), "����"))
             cc = TRIM(GetXAttrValue("banks", STRING(bank-id), "RegPlace"))
             cd = TRIM(GetXAttrValue("banks", STRING(bank-id), "�����"))
             ce = TRIM(GetTempXAttrValueEx("banks", STRING(bank-id), "��।��",gend-date,""))
             cf = TRIM(GetXAttrValue("banks", STRING(bank-id), "���⠢��"))
             cg = TRIM(GetXAttrValue("banks", STRING(bank-id), "���⠢���"))
        .
        put unformatted skip "��� " c1 FORMAT "x(12)" " "
                             "                      "
                             c4 FORMAT "x(160)" " "
                             c5 FORMAT "x(160)" " "
                             c6 FORMAT "x(22)" " " 
                             c7 FORMAT "x(5)" " "
                             c8 FORMAT "x(20)" " "
                             c9 FORMAT "x(20)" " "
                             ca FORMAT "x(10)" " "
                             cb FORMAT "x(15)" " "
                             cc FORMAT "x(100)" " "
                             cd FORMAT "x(40)"
                             ce FORMAT "x(500)"
                             cf FORMAT "x(500)"
                             cg FORMAT "x(500)".

   end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

