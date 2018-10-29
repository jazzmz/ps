{pirsavelog.p}

/*
 �� �P��������������

 11/01/06  - ���� � ������� �� ����� �� ���⠢��� ���� � �� ��⠬ �� ����� ��� ����⮢
    	     �� ��ਮ�.
	     ����� �������� �.�.

 [vk]

*/
{globals.i}                  
{getdates.i}
{sh-defs.i}

def var ogrn as c.
def var edate as date format "99/99/9999".
def var bdate as date format "99/99/9999".
def var b as date format "99/99/9999".
def var a as date format "99/99/9999".
def var i as integer.
def var symb as char no-undo.

symb = "-".


/* �६���� ⠡���� */

define TEMP-TABLE ttCC NO-UNDO
        Field fcustid like cust-corp.cust-id 
	Field fstat as char
	Field fname as char.


define TEMP-TABLE ttRez NO-UNDO
        Field fcustid like cust-corp.cust-id 
	Field facct like acct.acct
	Field fbeg-ost like acct-pos.balance
	Field fend-ost like acct-pos.balance
	Field fdpd as date.

/* �६���� ⠡���� */

   MESSAGE "�뢮���� ��� ⮫쪮 � �㫥�묨 ���⪠��?" 
           VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mWop AS LOG.


{setdest.i &cols=100}

put unformatted "           ���� � ������� � ���������騬 ���� � �� ����" skip
                "     �� ����� �� �뫮 �������� �� ��ਮ� � " beg-date " - " end-date skip(2).

put unformatted "        ����          �室�騩 ���⮪   ��室. ���⮪       ���" skip.
put unformatted "--------------------  ----------------  ----------------  ----------" skip.
put unformatted " " skip.
For each cust-corp by cust-corp.cust-id:
  ogrn = GetXAttrValue("cust-corp",STRING(cust-corp.cust-id),"����").

/* �஢��塞 ����稥 ��� �� ������ ������ ��� � ������ */
  find first acct where acct.cust-cat = "�" and acct.acct-cat = "b" and
                        acct.cust-id = cust-corp.cust-id and
                        acct.close-date = ? no-error.
  if not avail (acct) then next.
/* �� ⨯� �஢�ਫ�... */


  IF ogrn = "" then do:
    for each acct where acct.cust-cat = "�" and acct.acct-cat = "b" and
                        acct.cust-id = cust-corp.cust-id and
                        acct.close-date = ? 
                        by acct.acct:

      run acct-pos in h_base (acct.acct, acct.currency, beg-date, end-date, "�").

/* �㡫� */
      if acct.currency = "" then do:
         if lastmove = ? OR lastmove < beg-date OR lastmove > end-date then do: 
               if mWop and abs(sh-bal) = 0 then do:

/* ������塞 ⠡���� */
                    run ttRezCreate.
/* �� ⨯� ��������� */
               end.
             else do:
               if not(mWop) then do:
                    run ttRezCreate.
             end.
                
             end.
         end.              
      end.

/* ����� */ 
      if acct.currency <> "" then do:
         if lastmove = ? OR lastcurr < beg-date OR lastcurr > end-date then do: 
               if mWop and abs(sh-val) = 0 then do:
                    run ttRezCreate.
               end.
             else do:
               if not(mWop) then do:
                    run ttRezCreate.
             end.
                
             end.
         end.              
      end.

    end.
  end.
   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.

end.


for each ttCC by ttCC.fcustid:
  Put unformatted ttCC.fstat space string(ttCC.fname,"x(70)") skip.
  i = 0.
  for each ttRez where ttRez.fcustid = ttCC.fcustid by ttRez.facct:
           put unformatted ttRez.facct space(2)
                           string(ttRez.fbeg-ost,">>>>>>>>>>>>9.99") space(2) 
                           string(ttRez.fend-ost,">>>>>>>>>>>>9.99") space(2)
                           string(ttrez.fdpd,"99/99/9999") skip.
           i = i + 1.
   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.
  end.
   put unformatted  "--------------------" skip.
   put unformatted  "�ᥣ� ��⮢: " string (i,"999") skip.                            
   put unformatted  " " skip.
end.



{preview.i}



procedure ttRezCreate.
/* 		 Message cust-corp.cust-stat cust-corp.name-corp view-as alert-box.
*/
             find first ttCC where ttCC.fcustid = cust-corp.cust-id no-error.
             if not avail(ttCC) then do:
		 Create ttCC.
                  ttCC.fstat = cust-corp.cust-stat.
         	  ttCC.fname = cust-corp.name-corp.
         	  ttCC.fcustid  = cust-corp.cust-id.
         	 Update.
              end.
                 Create ttRez.
                  ttRez.fcustid = cust-corp.cust-id. 
         	  ttRez.facct = acct.acct.
                  if acct.currency = "" then ttRez.fbeg-ost = abs(sh-in-bal). 
         	     else ttRez.fbeg-ost = abs(sh-in-val).                
                  if acct.currency = "" then ttRez.fend-ost = abs(sh-bal). 
         	     else ttRez.fend-ost = abs(sh-val).
                  if acct.currency = "" then ttRez.fdpd = lastmove. 
         	     else ttRez.fdpd = lastcurr.
	         Update.	 
end.

