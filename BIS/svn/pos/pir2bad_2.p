/*��ᯮ�殮��� � �뭮� �� ������
����: ��᪮� �.�.
�����稪: ��ᨫ쪮�� �.�.*/

using Progress.Lang.*.

{globals.i}
{getdate.i}
{lshpr.pro}           /* �����㬥��� ��� ���� ��ࠬ��஢ ������� */
{ulib.i}

DEF INPUT PARAMETER TypeOtch AS INT NO-UNDO.

DEF VAR oTpl AS TTpl NO-UNDO.
def buffer transh for loan.

def var oTable AS TTable NO-UNDO.
def var ctrans AS CHAR   NO-UNDO.

def var oFunc   as tfunc   NO-UNDO.
def var grriska as char    NO-UNDO.
def var rate    as dec     NO-UNDO.
def var transhloan as char NO-UNDO.
	
def var DataZakl as date NO-UNDO.
oFunc = new tfunc().

def buffer bfloan-int for loan-int.

def buffer bLoan-int for loan-int.

def var itogo AS dec initial 0 NO-UNDO.
def var str AS char NO-UNDO.

Def Var Month_Name As Char Initial
  "ﭢ���,䥢ࠫ�,����,��५�,���,���,���,������,ᥭ����,������,�����,�������" No-UnDo.

DEFINE VARIABLE mW AS INTEGER NO-UNDO INITIAL 0
    VIEW-AS RADIO-SET RADIO-BUTTONS " ����襭�� ������������ �� ��",0,	
				" ����襭�� ����祭��� ������������ �� ��",1,
				" ����襭�� ����祭��� %",2,
				" ����襭�� %",3,
				" ����襭�� ���᫥���� %",4,
				" ����� ����⮩�� �� ��",5
    LABEL "�롥�� �ᯮ�殮��� ".

DEFINE VARIABLE cur AS char NO-UNDO 
    VIEW-AS RADIO-SET RADIO-BUTTONS "�㡫�","",	
				"�������","840",
				"���","978"
    LABEL "�롥�� ������ ".

   PAUSE 0.
   DO ON ERROR  UNDO, LEAVE
      ON ENDKEY UNDO, LEAVE WITH FRAME wow:
      UPDATE mW GO-ON (RETURN)
         WITH FRAME wow CENTERED OVERLAY ROW 10 SIDE-LABELS TITLE
         COLOR bright-white "[ �������� �������� ]".
   END.
   HIDE FRAME wow NO-PAUSE.
   if lastkey eq 27 then do:
      HIDE FRAME wow.
      return.
   end.     

   PAUSE 0.
   DO ON ERROR  UNDO, LEAVE
      ON ENDKEY UNDO, LEAVE WITH FRAME curframe:
      UPDATE cur GO-ON (RETURN)
         WITH FRAME curframe CENTERED OVERLAY ROW 10 SIDE-LABELS TITLE
         COLOR bright-white "[ �������� �������� ]".
   END.
   HIDE FRAME curframe NO-PAUSE.
   if lastkey eq 27 then do:
      HIDE FRAME curframe.
      return.
   end.     

oTpl = new TTpl("pir2bad_" + string(mW) + ".tpl").

oTable = new TTable(6).

for each loan-int where loan-int.contract = "�।��"
		        and ((loan-int.id-k = 0 and loan-int.id-d = 7 and mW = 10) /*����� ����������� � ������ */
		        or  (loan-int.id-k = 33 and loan-int.id-d = 10 and mW = 10) /*���᫥��� ��業�� �� ���ப� */
		        or  (loan-int.id-k = 32 and loan-int.id-d = 33 and mW = 10) /*�����᫥��� ��業⮢ */
		        or  (loan-int.id-k = 2 and loan-int.id-d = 1 and mW = 0) /*����襭�� �� */
		        or  (loan-int.id-k = 7 and loan-int.id-d = 5 and mW = 1) /*����襭�� ����祭���� �� */

		        or  (loan-int.id-k = 10 and loan-int.id-d = 5 and mW = 2 and CAN-FIND(op WHERE op.op = loan-int.op and op.op-kind = "pst112")) /*����襭�� ����祭��� % */
		        or  (loan-int.id-k = 6 and loan-int.id-d = 5 and mW = 3 and CAN-FIND(op WHERE op.op = loan-int.op and op.op-kind = "pst115")) /*����襭�� % */
		        or  (loan-int.id-k = 35 and loan-int.id-d = 5 and mW = 4 and CAN-FIND(op WHERE op.op = loan-int.op and op.op-kind = "pst114")) /*����襭�� ���᫥���� % */

		        or  (loan-int.id-d = 30 and loan-int.id-k = 48 and mW = 2 and CAN-FIND(op WHERE op.op = loan-int.op and op.op-kind = "pst112")) /*����襭�� ����祭��� % */
		        or  (loan-int.id-d = 6 and loan-int.id-k = 4 and mW = 3  and CAN-FIND(op WHERE op.op = loan-int.op and op.op-kind = "pst115")) /*����襭�� % */
		        or  (loan-int.id-d = 30 and loan-int.id-k = 29 and mW = 4 and CAN-FIND(op WHERE op.op = loan-int.op and op.op-kind = "pst114")) /*����襭�� ���᫥���� % */

		        or  (loan-int.id-k = 26 and loan-int.id-d = 5 and mW = 5)) /*����� �����⮩�� �� �� */
 		        and loan-int.op-date = end-date NO-LOCK by loan-int.id-k BY loan-int.amt-rub.

    find first loan where loan.contract = "�।��" and loan.cont-code = loan-int.cont-code /*and loan.end-date = end-date */
			and can-do(cur,loan.currency) 
			and can-do("l_agr_with*,loan_trans_*",loan.class-code) NO-LOCK NO-ERROR.
    if available loan then do:

		    find first op-entry where op-entry.op = loan-int.op and can-do(cur,op-entry.currency) /*and can-do("40817*,40820*",op-entry.acct-db)*/ NO-LOCK NO-ERROR.
		    
	            if avail (op-entry) then do:
			    find first person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.

			    dataZakl = DATE(getMainLoanAttr("�।��",ENTRY(1,loan.cont-code," "),"%��⠑���")).

			    oTable:AddRow().
			    oTable:AddCell(op-entry.acct-cr).

			    if cur = "" then do:
				oTable:AddCell(round(op-entry.amt-rub,2)).
				itogo = itogo + round(op-entry.amt-rub,2).
			    end.
			    else do:
				oTable:AddCell(round(op-entry.amt-cur,2)).
				itogo = itogo + round(op-entry.amt-cur,2).
			    end.
		
			    if TypeOtch = 1 then 
			    oTable:AddCell("810").
			    else
			    oTable:AddCell(op-entry.currency).

			    if loan-int.id-k = 0 then 
			    oTable:AddCell("��७�� �� ������ ��. ����� ").

			    /*�����᫥��� ��業⮢ */
			    if loan-int.id-k = 32 then 
			    oTable:AddCell("������. ��業⮢ �� ⥪�騩 ����� ").

			    /*���᫥��� ��業�� �� ���ப� */
			    if loan-int.id-k = 33 then 
			    oTable:AddCell("��७�� �� ������ ���᫥���� ��業⮢ ").

			    /*����襭�� �� */
			    if loan-int.id-k = 2 then do:
				    oTable:AddCell("����襭�� �᭮����� ����� ").
			    end.

			    /*����襭�� ����祭���� �� */
			    if loan-int.id-k = 7 then do:
				    oTable:AddCell("����襭�� ����祭��� ������������ �� �᭮����� �����").
			    end.

			    /*����襭�� ����祭��� %  */
			    if loan-int.id-k = 10 or loan-int.id-k = 48 then 
			    oTable:AddCell("����襭�� ����祭��� ��業⮢ ").
		
			    /*����襭�� % */
			    if loan-int.id-k = 6 or loan-int.id-k = 4 then do: 
				    /* ��室�� �뫮 �� ����襭�� ��業⮢ �� ⥪�騩 ����� */
				    find last bloan-int where bloan-int.contract = loan.contract
   				        and bloan-int.cont-code = loan.cont-code 
		        		and bloan-int.id-k = 6 and bloan-int.id-d = 5 /* ����� ��業⮢ */
					and bloan-int.mdate < end-date and bloan-int.mdate > date(Month(end-date),1, YEAR(end-date))
				        NO-LOCK NO-ERROR. 
			
				    If NOT available (bloan-int) then do:
					  if (loan.open-date + 1) > date(Month(end-date),1, YEAR(end-date)) then
				 	  oTable:AddCell("����襭�� ��業⮢ � " + STRING(loan.open-date + 1) + " �� " + STRING(end-date)).
					  else
				 	  oTable:AddCell("����襭�� ��業⮢ � " + STRING(date(Month(end-date),1, YEAR(end-date))) + " �� " + STRING(end-date)).
				    end.
				    else
				          oTable:AddCell("����襭�� ��業⮢ � " + STRING(bloan-int.mdate + 1) + " �� " + STRING(end-date)).
			    end.

	                    /*����襭�� ���᫥���� % */
			    if loan-int.id-k = 35 or loan-int.id-k = 29 then do:
				    /* ��室�� �뫮 �� ���. ��業⮢. �� �㤥� ��� �� */
				    find last bloan-int where bloan-int.contract = loan.contract
	   			        and bloan-int.cont-code = loan.cont-code 
			        	and ((bloan-int.id-k = 32 and bloan-int.id-d = 33)
                                         or (bloan-int.id-k = 30 and bloan-int.id-d = 29)) /* �ॡ������ �� ���. % */
					and bloan-int.mdate < end-date 
				        NO-LOCK NO-ERROR. 
					
				    /* ��室�� �뫮 �� ����襭�� ��業⮢. �� �㤥� ��� C */
				    find last bfloan-int where bfloan-int.contract = loan.contract
   	 			        and bfloan-int.cont-code = loan.cont-code 
		        		and bfloan-int.id-k = 6 and bfloan-int.id-d = 5 /* ����� % */
					and bfloan-int.mdate < end-date 
				        NO-LOCK NO-ERROR. 

				    If available (bloan-int) then do:
					  If available (bfloan-int) then do:
				 	  	oTable:AddCell("����襭�� ���᫥���� ��業⮢ � " + STRING(bfloan-int.mdate + 1) + " �� " + STRING(bloan-int.mdate)).
		                	  end.
			                  else 
				 	  	oTable:AddCell("����襭�� ���᫥���� ��業⮢ � " + STRING(loan.open-date + 1) + " �� " + STRING(bloan-int.mdate)).
				    end.
				    else
			        	  oTable:AddCell("�ॡ������ �� ���. ��業⠬ �� �������").
			    end.

        	            /*����� ����⮩�� �� ��*/
			    if loan-int.id-k = 26 then do:
				    /* ��室�� �뫮 �� ���. ��業⮢. �� �㤥� ��� �� */
				    find last bloan-int where bloan-int.contract = loan.contract
   				        and bloan-int.cont-code = loan.cont-code 
		        		and bloan-int.id-k = 26 and bloan-int.id-d = 5 /* �ॡ������ �� ���. % */
					and bloan-int.mdate < end-date 
				        NO-LOCK NO-ERROR. 
			
				    If available (bloan-int) then 
					oTable:AddCell("����� ����⮩�� �� ������ �᭮����� ����� � " + STRING(bloan-int.mdate + 1) + " �� " + STRING(end-date)).
		            	    else
			 	  	oTable:AddCell("����� ����⮩�� �� ������ �᭮����� ����� � " + STRING(loan.end-date + 1) + " �� " + STRING(end-date)).

			    end.

			    oTable:AddCell(loan.cont-code + " �� " + STRING(dataZakl)).
			    oTable:AddCell(Person.name-last + " " + Person.first-names).
		    end.

    end.
end.

oTpl:addAnchorValue("itogo",itogo).
oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("Date",end-date).
oTpl:addAnchorValue("DateY",string(YEAR(end-date),"9999")).
oTpl:addAnchorValue("DateM",entry(MONTH(end-date), Month_Name)).

{setdest.i}
oTpl:Show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oFunc.