using Progress.Lang.*.                        /* ������砥� ��⥬�� ������ �ண��� */


CLASS tfunc: 
      /***************************************************** 
       *                                                   *
       * ����� ������⥪� ��� ��⮤�� �� ������� �㭪権 *
       *                                                   *
       *****************************************************/


def temp-table tPremia NO-UNDO
	field since as date
	field Premia as dec
	INDEX since IS PRIMARY since
	INDEX Premia Premia.



METHOD PUBLIC char getKRez(INPUT cCont-code AS CHARACTER, INPUT dDate AS DATE):
define variable tempDate as Date NO-UNDO.
define variable tempKRez as DEC INIT 0 NO-UNDO.
define variable tempResult as CHAR INIT "" NO-UNDO.
define buffer bcomm-rate for comm-rate.
define buffer bterm-obl for term-obl.


find last bcomm-rate
	where bcomm-rate.commission begins "%���"
	  and bcomm-rate.kau = "�।��," + cCont-code                                       
	  and bcomm-rate.since <= dDate
	NO-LOCK NO-ERROR.

	if available(bcomm-rate) then do:
	   tempDate = bcomm-rate.since.
	   tempKRez = bcomm-rate.rate-comm.

           IF tempKRez = 0 THEN tempResult = TRIM(STRING(tempKRez,">>9.99")) + ",1".
  	   IF tempKRez >= 1 AND tempKRez <= 20 THEN tempResult = TRIM(STRING(tempKRez,">>9.99")) + ",2".
	   IF tempKRez > 20 AND tempKRez <= 50 THEN tempResult = TRIM(STRING(tempKRez,">>9.99")) + ",3".
	   IF tempKRez > 50 AND tempKRez < 100 THEN tempResult = TRIM(STRING(tempKRez,">>9.99")) + ",4".
	   IF tempKRez = 100 THEN tempResult = TRIM(STRING(tempKRez,">>9.99")) + ",5".

	end.

	find last bterm-obl WHERE bterm-obl.cont-code EQ cCont-code 
			      AND bterm-obl.contract EQ '�।��'
			      AND bterm-obl.idnt EQ 128 
			      and bterm-obl.end-date <= dDate 
 	  		      AND (bterm-obl.sop-date = ? or bterm-obl.sop-date >= tempDate)  
			      NO-LOCK NO-ERROR.
	if AVAILABLE (bterm-obl) then do:


 /*     bterm-obl.end-date     ��� ����� � ����䥫� */

 /*     bterm-obl.sop-date     ��� �뢮�� �� ����䥫� */

       if (bterm-obl.end-date >= tempDate) or (tempdate = ?) then 
       do:

          find last bcomm-rate
   	                 where bcomm-rate.commission begins "%���"
	                   and bcomm-rate.kau = "���," + bterm-obl.lnk-cont-code                                        
	                   and bcomm-rate.since <= dDate
	                   NO-LOCK NO-ERROR.
	  if available(bcomm-rate) then 
		do: 
		   tempKRez = bcomm-rate.rate-comm.
	  	   tempResult = TRIM(STRING(tempKRez,">>9.99")) + ",���".	
                end.
       end.


  
end.
RETURN  tempResult.


END METHOD.


METHOD PUBLIC char FindAmortPremia(INPUT cCont-code AS CHARACTER, INPUT cContract AS CHARACTER,INPUT dDate AS DATE):

define variable tempResult as CHAR INIT "" NO-UNDO.

DEF VAR mRoleSfx     AS CHAR    NO-UNDO INIT "-���-����". /*�� ���� � ⠪�� 墮�⮬ ஫� ���᫥�� ����⨧���*/

DEF VAR mRoleSfx2    AS CHAR    NO-UNDO INIT "-���-���". /*�� ���� � ⠪�� 墮�⮬ ஫� ���᫥�� "��ࢮ��砫쭠� �⮨���� ��"*/
                                                                                                                                   
DEF VAR dBegDate as Date NO-UNDO. /*��� ��砫� ��ਮ�� � ���஬ �饬 ��������� ��ࢮ��砫쭮� �⮨����*/

def var dIzmStoimost as Decimal NO-UNDO.
def var mPremia as Decimal NO-UNDO.
def var mPremia10 as Decimal NO-UNDO INIT 0.
def var mPremia30 as Decimal NO-UNDO INIT 0.
def buffer bfrloan-acct for loan-acct.

                                   


	find first loan where loan.cont-code = cCont-code and loan.contract = cContract NO-LOCK NO-ERROR.

	if AVAILABLE (loan) then 
		do:
		   FOR EACH  loan-acct      WHERE
		             loan-acct.contract  = loan.contract
		         AND loan-acct.cont-code = loan.cont-code
		         AND loan-acct.acct-type = loan.contract + mRoleSfx
		         AND loan-acct.since    <= dDate
		         NO-LOCK,
                         LAST  acct           WHERE
                               acct.acct           = loan-acct.acct
                           AND acct.currency       = loan-acct.currency
                         NO-LOCK:



		        FOR EACH op-entry       WHERE
	        	         (op-entry.acct-db    = loan-acct.acct               AND
		                  op-entry.op-date   >= loan-acct.since             AND
		                  op-entry.op-date   <= dDate                       AND
	        	          acct.side           = "�"
		                 )
	        	      OR (op-entry.acct-cr    = loan-acct.acct            AND
	                	  op-entry.op-date   >= loan-acct.since           AND
		                  op-entry.op-date   <= dDate                       AND
		                  acct.side           = "�"
		                 )
		            NO-LOCK,
 
		            FIRST op OF op-entry WHERE 
		               (op.op-kind begins '5002n0')
		            or (op.op-kind begins '5001b+')
		            or (op.op-kind begins '7012b2t')
               
		            NO-LOCK:
                                       DO: 

					       CREATE tPremia.
					       ASSIGN 

						      tPremia.Premia = op-entry.amt-rub
                                                      tPremia.since = op.op-date.

                                       END.
                                         
		        END. /*for each op-entry*/        


                   find last bfrloan-acct WHERE 
		             bfrloan-acct.contract  = loan.contract
		         AND bfrloan-acct.cont-code = loan.cont-code
		         AND bfrloan-acct.acct-type = loan.contract + mRoleSfx2
		         AND bfrloan-acct.since    <= dDate
		         NO-LOCK NO-ERROR.

		   if available (loan-acct) then do:

		     for each tpremia:       /*�᫨ �뫠 �६��, ����� �뫮 ��������� ��ࢮ��砫쭮� �⮨����, ����� ᬮ�ਬ �� ��������� �� ���� � ⥪�騩 �����*/

		         if Month(tpremia.since) > 1 then dbegDate = DATE(MONTH(tpremia.since) - 1,01,YEAR(tpremia.since)). /*��⠥� �� �६�� ����� ���᫨�� �� �� ����祭�� � ��諮� ����*/
		         else dbegDate = DATE(12,01,YEAR(tpremia.since) - 1).
		         for each op-entry where 
			          op-entry.acct-db = bfrloan-acct.acct
			      and op-entry.currency = bfrloan-acct.currency
			      and op-entry.op-date >= dBegDate
	                      and op-entry.op-date <= tpremia.since
			      NO-LOCK:
                                      dIzmStoimost = op-entry.amt-rub. /*��⠥� �� ��������� ��ࢮ��砫쭮� �⮨���� �� ��ਮ�*/
			      end.
                           	                                           
                         mPremia = tpremia.Premia.


                         if loan.cont-code = "3/14/156" and dDate >= 12/31/2011 then  /*������让 ������ ��� �� �� ���஬� ���ࠢ��쭮 ᯨᠫ� �६�� � ��⮬ ��।����� � ���� ����*/
                	    do:

       	                     mPremia = mPremia +  17467.00.
		
 	                    end.
 
                          IF ABS(mPremia - (dIzmStoimost / 10)) < 1 THEN mPremia10 = mPremia10 + mPremia .
                          IF ABS(mPremia - (30 * dIzmStoimost / 100)) < 1 THEN mPremia30 = mPremia30 + mPremia .        


		     end.
		    
                     end.    
                end.
		       tempResult = String(mPremia10) + ";" + STRING(mPremia30).

		

		end.         /*if availble (loan)*/


EMPTY TEMP-TABLE tpremia.
RETURN  tempResult.


END METHOD.


END CLASS
