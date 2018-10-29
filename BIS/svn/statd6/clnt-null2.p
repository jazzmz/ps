{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: clnt-null2.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:20 $
Copyright     : ��� �� "�p������������"
�����祭��    : ���� �� ��⠬ � �㫥�묨 ���⪠��, �� ����� �� �뫮 �������� �� ��ਮ�
���� ����᪠ : ��/�����/����� �� ��楢� ��⠬/������
����         : vk
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.2  2007/07/17 12:23:09  lavrinenko
���������     : ���७ ����� ��⮢
���������     :
              : 01/02/06  - ���� � ���� �� ����� ��� ����⮢ �� ��ਮ�.
              : ����� �������� �.�. *  �6
              :
              : 02/03/06  - ������� ���஢�� ��⮢  * �6
------------------------------------------------------ */
{globals.i}                  
{getdates.i}
{sh-defs.i}


DEF INPUT PARAM bal-line AS CHAR FORMAT "x(300)" NO-UNDO.


def var lm as c NO-UNDO.


{setdest.i &cols=100}

put unformatted "                            ���� �� ��⠬" skip
                "     �� ����� �� �뫮 �������� �� ��ਮ� � " beg-date " - " end-date skip(2).

put unformatted "                      ���⮪   " skip.
put unformatted "        ����        �� " end-date space "    ���              ������  " skip.
put unformatted "-------------------- --------- ---------- -------------------------------" skip.
put unformatted " " skip.


for each acct where acct.open-date < beg-date and acct.close-date = ? 
      and lookup(string(acct.bal-acct),bal-line) > 0 
      by acct.bal-acct by substring (acct.acct,17,4):
       run acct-pos in h_base (acct.acct, acct.currency, beg-date, end-date, "�").


/* ⨯� �����:)
for each acct where acct.open-date < beg-date and acct.close-date = ? 
      and lookup(string(acct.bal-acct),bal-line) > 0 by acct.acct:
      run acct-pos in h_base (acct.acct, acct.currency, beg-date, end-date, "�").
*/


/* �㡫� */
      if acct.currency = "" then do:
         if lastmove = ? OR (lastmove < beg-date OR 
            lastmove > end-date)  and 
            abs(sh-bal) = 0 then do:
              if lastmove = ? then lm = "          ".
              if lastmove <> ? then lm = string(lastmove,"99/99/9999"). 
               if acct.cust-cat = "�" then do:
                 find first person where person.person-id = acct.cust-id no-error.
                 if avail(person) then do:     
                    put unformatted string(acct.acct,"x(20)") space string(abs(sh-bal),">>>>>9.99") space
                                    lm space
                                    person.first-names space person.name-last skip.
                 end.
               end.
               if acct.cust-cat = "�" then do:
                 find first cust-corp where cust-corp.cust-id = acct.cust-id no-error.
                 if avail(cust-corp) then do:     
                    put unformatted string(acct.acct,"x(20)") space string(abs(sh-bal),">>>>>9.99") space 
                                    lm space
                                    string(cust-corp.name-corp,"x(40)") skip.
                 end.
               end.

         end.
      end.

/* ����� */
      if acct.currency <> "" then do:
         if lastcurr = ? OR (lastcurr < beg-date OR 
            lastcurr > end-date)  and 
            abs(sh-val) = 0 then do:
              if lastcurr = ? then lm = "          ".
              if lastcurr <> ? then lm = string(lastcurr,"99/99/9999"). 
               if acct.cust-cat = "�" then do:
                 find first person where person.person-id = acct.cust-id no-error.
                 if avail(person) then do:     
                    put unformatted string(acct.acct,"x(20)") space string(abs(sh-val),">>>>>9.99") space
                                    lm space
                                    person.first-names space person.name-last skip.
                 end.
               end.
               if acct.cust-cat = "�" then do:
                 find first cust-corp where cust-corp.cust-id = acct.cust-id no-error.
                 if avail(cust-corp) then do:     
                    put unformatted string(acct.acct,"x(20)") space string(abs(sh-val),">>>>>9.99") space 
                                    lm space
                                    string(cust-corp.name-corp,"x(60)") skip.
                 end.
               end.

         end.
      end.




end.
{preview.i}

