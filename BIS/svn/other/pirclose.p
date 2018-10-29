{pirsavelog.p}

/*
               
    Copyright:
     Filename: 
      Comment: 
   Parameters: 
      Used by: 
      Created: 
     Modified: 
*/
/*Form "~n@(#) BPOS_.P �������� ������ � ᢥ�⪠ ��室��/��室��"
with frame sccs-id stream-io width 250./
*/
{globals.i}
{sv-calc.i &nodebug = yes}
{intrface.get xclass}
/* {sv-temp.i new}*/

def var par_str as char no-undo.
def var par1 as char no-undo.
def var par2 as char no-undo.
def var i as int no-undo.
def var delta as dec extent 2 no-undo.
def var del_a as dec extent 2 no-undo.
def var del_b as dec extent 2 no-undo.
def var del-prt as dec extent 2 no-undo.
def var err as char no-undo.

def var dob as date no-undo.
def var cl-acct-cat as char no-undo.
def var per    as char format "x(20)" no-undo.
def var period as char format "x(12)" no-undo.

/* def buffer xDataLine  for DataLine.
def buffer xbal-acct  for bal-acct.
def buffer xbranch for branch.
{branch.pro}

def query q-branch for xbranch.
find first branch of DataBlock no-lock.
*/
cl-acct-cat = SUBSTRING(dataclass.dataclass-id,1,1).
dob = DataBlock.beg-date.
per = {term2str beg-date end-date }.
period = {sv-tstr beg-date end-date }.
  
if cl-acct-cat eq "b" then
DO:
/* �஢�ઠ �� 61406 61306 */
for each op where op.doc-date eq DataBlock.beg-date
						and op.doc-num begins "�" no-lock:

    find first op-entry of op where
               op-entry.acct-cr begins "61406" no-lock no-error.
          if avail op-entry then
             do:
             		run normdbg in h_debug (0,"�訡��","�।�⮢�� ������ �� ��⮬���᪮� ��८業�� �� ���� "    
             		+  string(op-entry.acct-cr,"x(20)")).
             		             
             MESSAGE color white/red
      				" �� ���� � "  string(op-entry.acct-cr,"x(20)") SKIP
              " ��諠 �।�⮢�� ������ " 
              "�"
              STRING (DataBlock.beg-date,"99.99.9999")
             VIEW-AS ALERT-BOX.
             
             		DataBlock.IsFinal = NO.
             		             	
              end.
     find first op-entry of op where
                op-entry.acct-db begins "61306" no-lock no-error.
          if avail op-entry then
             do:
             		run normdbg in h_debug (0,"�訡��","����⮢�� ������ �� ��⮬���᪮� ��८業�� �� ���� "    
             		+  string(op-entry.acct-db,"x(20)")).
             	             		
             		MESSAGE color white/red
      				   " �� ���� � "  string(op-entry.acct-db,"x(20)") SKIP
                 " ��諠  ������ " 
                 "�"
                 STRING (DataBlock.beg-date,"99.99.9999")
                VIEW-AS ALERT-BOX. 
                DataBlock.IsFinal = NO.
             end.
 end.
/* ����� �஢�ન 61306 61406 */
END.

/* �஢�ઠ �� ��᭮� ᠫ줮 �� ��⠬ */
  for each acct-pos where
            acct-pos.filial-id = shFilial and
            acct-pos.since eq dob and
            can-do(cl-acct-cat,acct-pos.acct-cat) and
            acct-pos.acct gt "0" no-lock,
            acct of acct-pos no-lock:
            
		if acct.side eq "�" and acct-pos.balance < 0 then 
						do:
										run normdbg in h_debug (0,"�訡��","�।�⮢�� ᠫ줮 �� ��⨢��� ��� "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " �� ��� �"  string(acct.acct,"x(20)") SKIP
                    " �।�⮢�� ᠫ줮" 
                    "��"
                    STRING (DataBlock.beg-date,"99.99.9999")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
           end.

     if acct.side eq "�" and acct-pos.balance > 0 then 
          do:
                    run normdbg in h_debug (0,"�訡��","�।�⮢�� ᠫ줮 �� ���ᨢ��� ��� "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " �� ��� �"  string(acct.acct,"x(20)") SKIP
                    " �।�⮢�� ᠫ줮" 
                    "��"
                    STRING (DataBlock.beg-date,"99.99.9999")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
           end.
     
     if acct.side eq "�" and acct-pos.balance > 0  and acct.contr-acct ne "" then 
          do:
                    run normdbg in h_debug (0,"�訡��","��� �� ᢥ���� "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " ��� �"  string(acct.acct,"x(20)") SKIP
                    " �� ᢥ����" 
                    "�� �"
                    string(acct.contr-acct,"x(20)")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
         end.
      
      if acct.side eq "�" and acct-pos.balance < 0  and acct.contr-acct ne "" then 
          do:
                    run normdbg in h_debug (0,"�訡��","��� �� ᢥ���� "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " ��� �"  string(acct.acct,"x(20)") SKIP
                    " �� ᢥ����" 
                    "�� �"
                    string(acct.contr-acct,"x(20)")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
         end.
         
         
      if acct.close-date <= dob and acct-pos.balance ne 0 then 
             do:
      							run normdbg in h_debug (0,"�訡��","���㫥��� ᠫ줮 �� �����⮬ ��� "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " �� ��� �"  string(acct.acct,"x(20)") SKIP
                    " ���㫥��� ᠫ줮 �� �����⮬ ���" 
                    "��"
                    STRING (DataBlock.beg-date,"99.99.9999")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
             end.
              
/*  �஢�ઠ ᢥ�⪨ ��室�� ��室�� �� ����� ����� */
/* ����� �� �㦭�
      if cl-acct-cat eq "b" and acct-pos.balance ne 0 
         and can-do("706*",acct.acct)  and period eq "����⠫" then 
             do:
      							run normdbg in h_debug (0,"�訡��","���㫥��� ᠫ줮 �� ��� ��室�/��室� �� ����� ����⠫� "    
             		                            +  string(acct.acct,"x(20)")).
		                MESSAGE color white/red
      				      " �� ��� �"  string(acct.acct,"x(20)") SKIP
                    " ���㫥��� ᠫ줮 �� ����� ����⠫�" 
                    "��"
                    STRING (DataBlock.end-date,"99.99.9999")
                    VIEW-AS ALERT-BOX. 
                    DataBlock.IsFinal = NO.
             end. 
*/
      

   end.