{pirsavelog.p}

/* 
	�� �P�������������� 

	����⨪� �6.
	����� �� �᭮�� acct-pos, � �裡 � �⨬ �� ����� ��८業��.
		
	04/04/06	��砫...
	[vk]
*/		
{globals.i}
{sh-defs.i}

def input parameter bline as char init "40702,40703,40802,40807,40817,42301,42305,42306,42601,42606,45505,45506".

def var i as integer no-undo.
def var a as integer extent 6 no-undo.

define temp-table ttrezult
	field bacct2 as char
	field AllOpenAcct as integer       /* �ᥣ� ������� ��楢�� ��⮢*/
	field NotNullOpenAcct as integer   /* �� ��� ������ �� �㫥�� */
	field WorkOpenAcct as integer      /* �� ��� ������, ࠡ�⠫� */
	field OpenAcct as integer          /* �� ��� ���뫨�� � 㪠������ ��ਮ�� */ 
	field WorkAcct as integer          /* �� ��� ࠡ�⠫� � 㪠������ ��ਮ�� */
	field CloseAcct as integer.        /* �� ��� ����뫨�� � 㪠������ ��ਮ�� */

{getdates.i}

{setdest.i}

do i = 1 to num-entries(bline).
create ttrezult.
ttrezult.bacct2 = entry(i, bline).

 for each acct where acct.bal-acct = integer(entry(i, bline)) by acct.acct:
       lastmove = ?.
       lastcurr = ?.	

     /* ������ �ᥣ� */ 
     if acct.open-date <= end-date and (acct.close-date = ? or
	acct.close-date > end-date) then do: 
		ttRezult.AllOpenAcct = ttRezult.AllOpenAcct + 1.

       run acct-pos in h_base (acct.acct, acct.currency, beg-date, end-date, "�").
       /* �㡫� */
       if acct.currency = "" then do:
         /* ���㫥�� �� ����� 㪠������� ��ਮ�� */
         if abs(sh-bal) > 0 then ttRezult.NotNullOpenAcct = ttRezult.NotNullOpenAcct + 1.
         
         /* ࠡ�⠫� � �祭�� 㪠������� ��ਮ�� */
         if (lastmove >= beg-date and lastmove <= end-date) then  
			ttRezult.WorkOpenAcct = ttRezult.WorkOpenAcct + 1. 

         /* ���뫨�� � �祭�� ��ਮ�� */
         if acct.open-date >= beg-date and  
  	    acct.open-date <= end-date then ttRezult.OpenAcct = ttRezult.OpenAcct + 1.	

         /* ���뫨�� � ࠡ�⠫� � �祭�� ��ਮ�� */ 
         if (acct.open-date >= beg-date and 
	    acct.open-date <= end-date) and 
	    lastmove >= beg-date and lastmove <= end-date then ttRezult.WorkAcct = ttRezult.WorkAcct + 1.	
       end.

       /* ����� */
       if acct.currency <> "" then do:
         /* ���㫥�� �� ����� 㪠������� ��ਮ�� */
         if abs(sh-val) > 0 then ttRezult.NotNullOpenAcct = ttRezult.NotNullOpenAcct + 1.
         
         /* ࠡ�⠫� � �祭�� 㪠������� ��ਮ�� */
         if lastcurr >= beg-date and lastcurr <= end-date then ttRezult.WorkOpenAcct = ttRezult.WorkOpenAcct + 1. 

         /* ���뫨�� � �祭�� ��ਮ�� */
         if acct.open-date >= beg-date and  
  	    acct.open-date <= end-date then ttRezult.OpenAcct = ttRezult.OpenAcct + 1.	

         /* ���뫨�� � ࠡ�⠫� � �祭�� ��ਮ�� */ 
         if acct.open-date >= beg-date and 
	    acct.open-date <= end-date and 
	    lastcurr >= beg-date and lastcurr <= end-date then ttRezult.WorkAcct = ttRezult.WorkAcct + 1.	
       end.

     end.

     /* ����뫨�� � �祭�� ��ਮ�� */
     if acct.close-date >= beg-date and acct.close-date <= end-date then ttRezult.CloseAcct = ttRezult.CloseAcct + 1.	
 end.
end. 


Put Unformatted "              ���������� �� ���� ������ �� ���� " end-date " ������� � " beg-date skip (1).
Put Unformatted "��������������������������������������������������������������������������������������������Ŀ" SKIP.
Put Unformatted "�        �               ���-�� �������� ������ �� ����  " end-date "              ����-�� �������" SKIP.
Put Unformatted "�        ���������������������������������������������������������������������Ĵ ����������� �" SKIP.
Put Unformatted "� ������ �   �����   � �� ��� ��� ��� �������� � �� ��� ������� ���� �  ������ �   � ������  �" SKIP.
Put Unformatted "�  ����  �           �� �����.�   � ������     � � " beg-date " �� " end-date " �����. � �  " beg-date " �" SKIP.
Put Unformatted "�        �           � �����. �  � " beg-date "    �������������������������������Ĵ �� " end-date " �" SKIP.
Put Unformatted "�        �           �        ��� " end-date " ���.�     �����   � �� ��� �������� �������������.�" SKIP.               
Put Unformatted "��������������������������������������������������������������������������������������������Ĵ" SKIP.

for each ttrezult by bacct2:
  put unformatted "�  " ttrezult.bacct2 " � " 
		string(ttrezult.AllOpenAcct,">>>>>>>>9") " �" 
		string(ttrezult.NotNullOpenAcct,">>>>>>9") " �" 
		string(ttrezult.WorkOpenAcct,">>>>>>>>>>>>>>9") " �"
		string(ttrezult.OpenAcct,">>>>>>>>>>>9") " �" 
                string(ttrezult.WorkAcct,">>>>>>>>>>>>>>>9") " �" 
                string(ttrezult.CloseAcct,">>>>>>>>>>>9") " �" skip.
Put Unformatted "��������������������������������������������������������������������������������������������Ĵ" SKIP.
end.

for each ttrezult by bacct2:
   a[1] = a[1] + ttrezult.AllOpenAcct.
   a[2] = a[2] + ttrezult.NotNullOpenAcct.
   a[3] = a[3] + ttrezult.WorkOpenAcct.
   a[4] = a[4] + ttrezult.OpenAcct.
   a[5] = a[5] + ttrezult.WorkAcct.
   a[6] = a[6] + ttrezult.CloseAcct.
end.

  Put Unformatted "�  �����:� "
		string(a[1],">>>>>>>>9") " �" 
		string(a[2],">>>>>>9") " �" 
		string(a[3],">>>>>>>>>>>>>>9") " �"
		string(a[4],">>>>>>>>>>>9") " �" 
		string(a[5],">>>>>>>>>>>>>>>9") " �" 
		string(a[6],">>>>>>>>>>>9") " �" skip.
 
  Put Unformatted "����������������������������������������������������������������������������������������������" skip.

{preview.i}
