{pirsavelog.p}

/**
	��楤�� �����⮢�� ���㬥�⮢ � ����� �㭪樮���� �� ࠡ�� � ��⠬�-䠪��ࠬ�.
	��楤�� ������ ���� �� "����" ���㬥��� �� ������ࠬ �७�� ���, ��������� �� 
	���.४������ ᮮ⢥�����騬� ���祭�ﬨ. 
	
	���� �.�., 20.12.2006 14:02
*/

{globals.i}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

DEF VAR tmpstr AS CHAR.
DEF VAR sfnumber AS CHAR LABEL "����� ��" FORMAT "x(6)".
DEF VAR sfdate AS DATE LABEL "��� ��" FORMAT "99/99/9999".
def var sfinfo AS CHAR LABEL "PISSFInfo" FORMAT "x(60)".
def var sfdetails AS CHAR LABEL "PIRSFDetails" FORMAT "x(60)".
def var sfprolong AS LOGICAL LABEL "�஫����஢��?" FORMAT "��/���".
def var sfamount AS DECIMAL LABEL "PIRSFAmount" FORMAT ">>>,>>>,>>9.99".
def var safeperiod AS INT LABEL "��ਮ� �७�� (���.)".
def var result as char extent 4.
def var i as int.

def buffer b-op-entry for op-entry.

PAUSE 0.

/** ��� ������� ��࠭��� ����� �������, ������ �������, ��᫥���� �᫮��� ������� � ��� � ஫�� */
FOR EACH tmprecid NO-LOCK,
    FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK,
    LAST loan-cond WHERE loan-cond.contract = loan.contract AND loan-cond.cont-code = loan.cont-code NO-LOCK,
    FIRST loan-acct OF loan WHERE acct-type = "������䏏�1" NO-LOCK
  :
    /** ������ ������ ����� �஢���� �� �।��� ������� ��� */ 
    FIND LAST op-entry WHERE 
    		op-entry.acct-db = loan-acct.acct 
    		AND 
    		op-entry.acct-cr BEGINS "61304"
				NO-LOCK.
				
    FIND FIRST op WHERE op.op = op-entry.op NO-LOCK.
    
    /** ���祭�� ���.४�. op.PIRSFNumber */
    tmpstr = GetXAttrValueEx("op", STRING(op.op), "PIRSFNumber", "").
    if num-entries(tmpstr) = 2 then do: 
    	sfnumber = ENTRY(1,tmpstr).
    	sfdate = DATE(ENTRY(2,tmpstr)).
    end. 
    else 
    do:
    	sfnumber = "".
    	sfdate = op.doc-date.
    end.	
    
    /** ���祭�� ���.४�. op.PIRSFInfo */
    sfinfo = GetXAttrValueEx("op", STRING(op.op), "PIRSFInfo", "").
    if (sfinfo = "") then sfinfo = "sf-out,�/�,�����,1," + loan.contract + "." + loan.cont-code.
    
    /** ���祭�� ���.४�. loan.SafePeriod */
    SafePeriod = INT(GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "SafePeriod", "1")).
    
    /** ���祭�� ���.४�. op.PIRSFDetails */
    sfdetails = GetXAttrValueEx("op", STRING(op.op), "PIRSFDetails", "").
    if (sfdetails = "") then 
       sfdetails = "�७�� ᥩ� ���. �" + loan.cont-code + " �� " + STRING(loan.open-date,"99/99/9999") 
       + ",10000001," + STRING(SafePeriod - 1).
    
    /** ���祭�� ���.४�. op.PIRSFAmount */
    sfamount = DEC(GetXAttrValueEx("op", STRING(op.op), "PIRSFAmount", "0")).
    /** �᫨ �㬬� ࠢ�� 0, � ������ �஢���� 408* - loan-acct.acct */
    if (sfamount = 0) then do:
    		find last b-op-entry where b-op-entry.acct-cr = loan-acct.acct and b-op-entry.acct-db begins "408" NO-LOCK no-error.
    		if avail b-op-entry then sfamount = b-op-entry.amt-rub.
    end.
    	
    
    if loan.open-date NE loan-cond.since then sfprolong = true. else sfprolong = false.
    
    DISPLAY "---------------------------- ������� ---------------------------" SKIP
            loan.cont-code SKIP loan.open-date FORMAT "99/99/9999" SKIP sfprolong SKIP
            "---------------------------- ���㬥�� --------------------------" SKIP
            op.doc-num op.doc-date LABEL "��" FORMAT "99/99/9999" SKIP
            op.details VIEW-AS EDITOR SIZE 40 BY 4 SKIP
            "----------------------- ���.४�. ���㬥�� --------------------" SKIP
            sfnumber SKIP sfdate SKIP 
            sfinfo SKIP
            sfdetails SKIP
            sfamount SKIP
                        
            WITH FRAME ff SIDE-LABELS CENTERED OVERLAY TITLE "��砫쭮� �襭�� �� ��-���".
    
    UPDATE sfnumber sfdate sfinfo sfdetails sfamount WITH FRAME ff.
    
    /** ���������� ⠡���� १���⮢. ��ଠ�: <���_���_४>,<���祭��> */
    
    result[1] = "PIRSFAmount;" + STRING(sfamount).
    result[2] = "PIRSFDetails;" + sfdetails.
    result[3] = "PIRSFInfo;" + sfinfo.
    result[4] = "PIRSFNumber;" + sfnumber + "," + STRING(sfdate,"99/99/9999").
    
    
    /** �������� ��� ��������� �������⥫��� ४����⮢ ���㬥�� */
    /** PIRSFNumber */
    
    DO i = 1 TO 4 :
    		
    		find first signs where 
    				file-name = "op"
    				and
    				surrogate = string(op.op)
    				and 
    				code = ENTRY(1, result[i], ";")
    				NO-ERROR.
    		if avail signs then 
    		  if i = 1 then 
    		    signs.code-value = ENTRY(2, result[i], ";").
    		  else
    				signs.xattr-value = ENTRY(2, result[i], ";").
    		else do:
    		  create signs.
    		  assign
    		  			 signs.file-name = "op"
    		  			 signs.surrogate = STRING(op.op)
    		  			 signs.code = ENTRY(1, result[i], ";").
    		  if i = 1 then 
    		    signs.code-value = ENTRY(2, result[i], ";").
    		  else
    		    signs.xattr-value = ENTRY(2, result[i], ";").
    		end.
    END.
    
    HIDE FRAME ff.
END.