{pirsavelog.p}

/*
	�� �P��������������
	����� ࠡ�祣� ����� ��⮢.

  16.11.2006 10:32
*/

{globals.i}


def var b1name as char extent 10.
def var b2name as char extent 10.
def var mCount as integer init 2.
def var mCont as integer init 2.
def var vLast as logical.
def var vLastCode as logical.
def var sig as integer.
def var itog as integer no-undo.
def var FirstDate as c no-undo.
def var fd as date no-undo.
def var i as integer no-undo.
def var cat-line as char no-undo.
def buffer bcode for code.

def var incat as c no-undo.
def var bal-cat as l extent 8 no-undo.
def var tc as c no-undo.

def var cat-all as char init "b,o,d,f,t,u,x,n".

def var cl as char no-undo.
def var in-end-date     like DataBlock.End-Date        no-undo.

{pir_wpp.i}
{getdate.i}
   in-end-date = end-date.
{setdest.i}
{wordwrap.def}

put unformatted "                                                              � � � � � � � � �" skip(2).
put unformatted "                                                         ���.�।ᥤ�⥫� �ࠢ�����" skip(2).
put unformatted "                                                         _____________ ������� �.�." skip (2).
put unformatted "                                                         _____ _____________ "  string(year(today)) "�." skip(2).
put unformatted "                          � � � � � � �   � � � �   � � � � � �" skip (2).
put unformatted "                              �� ���ﭨ� �� "  string(end-date,"99/99/9999") "�." skip(2).
put unformatted "��������������������������������������������������������������������������������������Ŀ" skip.
put unformatted "� ����� ��� �         ������������ ࠧ����� � ��⮢         ��ਧ���� ��� ������ �" skip.
put unformatted "�    1 (2)    �                     ������                    � ��� �     ���     �" skip.
put unformatted "�   ���浪�   �                                                �  �,�  �               �" skip.
put unformatted "��������������������������������������������������������������������������������������Ĵ" skip.
put unformatted "�  1  �   2   �                       3                        �   4   �       5       �" skip.

do i = 1 to num-entries(incat). 
  if entry(i,incat) <> "d" then cat-line = entry(i,incat) + "-acct1".
    else cat-line = entry(i,incat) + "-sect".
  find first bcode where bcode.class = "acct-cat" and bcode.code = substring(cat-line,1,1) no-lock.
  put unformatted "��������������������������������������������������������������������������������������Ĵ" skip.
  put unformatted "�               " string(bcode.name,"x(62)") "         �" skip.                        
  put unformatted "��������������������������������������������������������������������������������������Ĵ" skip.
                  

  for each code where code.class = cat-line and code.parent = cat-line break by code.code:
   /* �饬 ����� */
    cl = substring(cat-line,1,1).
    if cl <> "d" then cl = cl + "post". /* �������� ����� */
      else cl = cl + "pos".
    find last datablock where datablock.dataclass-id = cl and
               ((datablock.end-date = in-end-date or
               datablock.beg-date = in-end-date) or            
               (end-date >= datablock.beg-date and end-date <= datablock.end-date)) 
               no-lock no-error.

    if not avail(datablock) then do: /* �� ��諨 :( */
       put unformatted  "�� ���⠭ ����� ������ " cl " �� "  string(end-date,"99/99/9999") skip.
       next.
    end.

    sig = 0.	
    find first dataline where dataline.data-id = datablock.data-id and 
		   	dataline.sym1 = code.code no-lock no-error.
         if avail dataline then do:
          	sig=1.
          	put unformatted "+1" skip.
         end.

    for each bal-acct where bal-acct.bal-acct1 = code.code  by bal-acct.bal-acct:
      find first acct where acct.bal-acct = bal-acct.bal-acct /* and acct.open-date <= end-date and 
       (acct.close-date > end-date OR acct.close-date = ?) */   no-lock no-error. 
    end.
      if sig = 0 and not avail (dataline)then next.
         mCount = 2.
         b1name[1] = code.name.
	       {wordwrap.i
		       &s = b1name 
		       &l = 46
           &n = 10}
       put unformatted "�"space string (code.code,"x(3)") space "�" space(7) "� " string(b1name[1],"x(46)") " �       �               �" skip.
       DO WHILE (b1name[mCount] NE ""):
           PUT UNFORMATTED "�     �       � " string(b1name[mCount],"x(46)") " �       �               �" skip.
          mCount = mCount + 1.
       END.
  
  for each bal-acct where bal-acct.bal-acct1 = code.code by bal-acct.acct-cat by bal-acct.bal-acct:
    fd = 01.01.9999.
    for each acct where acct.bal-acct = bal-acct.bal-acct and acct.open-date <= end-date and 
     (acct.close-date > end-date OR acct.close-date = ?) no-lock on error undo, next:
      if acct.open-date < fd then fd = acct.open-date.
    end. 
    if fd < 01.01.3000 then firstdate = string (fd,"99/99/9999").
        else next. 
         itog = itog + 1.
         mCont = 2.
         b2name[1] = bal-acct.name-bal-acc.
        
	       {wordwrap.i
		         &s =b2name 
                 &l = 46
                 &n = 10}                                                                                        
         put unformatted "�     ��������������������������������������������������������������������������������Ĵ" skip.
         put unformatted "�     � " string(bal-acct.bal-acct,"99999") 
	  		  " � " string (b2name[1],"x(46)") " �   " string(bal-acct.side,"x(2)") "  �   " firstdate "  �" skip. 
         DO WHILE (b2name[mCont] NE ""):
            PUT UNFORMATTED "�     �       � " string(b2name[mCont],"x(46)") " �       �               �" skip.
            mCont = mCont + 1.
         END.
    end.	
		    put unformatted "��������������������������������������������������������������������������������������Ĵ" skip.

 end.

end.
        put unformatted "����������������������������������������������������������������������������������������" skip (3).

put unformatted space(5) "�ᥣ� ��⮢:" string (itog,">>>>>>9") skip(3).
put unformatted space(10) FGetSetting("��������","","") space(4)
		"_______________" space(5)
		FGetSetting("������","","") skip.

{preview.i}