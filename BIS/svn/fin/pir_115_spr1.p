{globals.i}
/*{getdates.i}*/
{svarloan.def NEW}          /* Shared ��६���� ����� "�।��� � ��������". */
{intrface.get tmess}    /* �����㬥��� ��ࠡ�⪨ ᮮ�饭��. */
{intrface.get xclass} /* ����㧪� �����㬥���� ����奬� */
{intrface.get pogcr}
{norm.i new}
 
def input  param icont-type as char no-undo.
def input  param bdate   as date no-undo.
def input  param edate   as date no-undo.
def input  param ckred   as char no-undo.
def input  param sdate   as date no-undo.
def output param summ_all   as dec  init 0 no-undo.
def var summ-t    as DEC  NO-UNDO.
/*def var summ_all  as DEC  NO-UNDO.*/
DEF VAR proc-name AS CHAR NO-UNDO.
DEF VAR drCK      AS CHAR NO-UNDO.
def var liamt     as dec  no-undo.
def var toamt     as dec  no-undo.
def var filename  as char no-undo.
def stream flRep. 

DEFINE NEW SHARED STREAM err.

def Buffer bfrloan FOR loan.

DEF TEMP-TABLE tblRes NO-UNDO
               FIELD name  AS CHARACTE
               FIELD acctB AS CHARACTER
               FIELD acctV AS CHARACTER
          .

DEF temp-table tRep no-undo
   field ContCode as char
   field Amt      as dec
.

for each loan where loan.contract eq "�।��" and can-do(icont-type,loan.cont-type) and loan.cust-cat eq "�" 
   and can-do("!��*,!��*,*",loan.cont-code) no-lock:

   find first bfrLoan where bfrLoan.cont-code eq entry(1,loan.cont-code," ") no-lock no-error.
   drCK = GetTempXAttrValueEx("loan",bfrLoan.contract + "," + bfrLoan.cont-code,"����।",edate,"").
   if can-do(ckred,drCK) then do: 
/*      message "1" drCK bfrLoan.cont-code Loan.cont-code view-as alert-box.*/
      /*������ �������*/
      if loan.close-date eq ? and loan.since ne sdate then do:
   	RUN SetSysConf IN h_base ("NoProtocol","YES").
           RUN SetSysConf IN h_base ("PUT-TO-TMESS","").
           {setdest.i &stream="stream err" &filename='_spool_recalc.tmp' &append = "APPEND"}
           {get_meth.i  'Calc' 'loanclc'}
           RUN VALUE(proc-name + ".p") (loan.contract,
                                        loan.cont-code,
                                        sdate).

   	RUN DeleteOldDataProtocol IN h_base ("PUT-TO-TMESS").
   	RUN DeleteOldDataProtocol IN h_base ("NoProtocol").
      end.

      find last term-obl of loan where 
         term-obl.idnt EQ 3 
         and term-obl.end-date GE bdate
         and term-obl.end-date LE edate
         no-lock no-error.
      if avail term-obl then do:    
         /* ������襭�� ���⮪ */
/*         RUN summ-t1.p (OUTPUT summ-t,RECID(term-obl),RECID(loan)). */
         RUN summ-t.p(OUTPUT summ-t,loan.Contract,loan.Cont-Code,RECID(term-obl),sdate).
         if loan.currency ne "" then
            summ-t = CurToCurWork("����",loan.currency,"",edate,summ-t).
         summ_all = summ_all + summ-t.
         create tRep.
         ASSIGN 
            tRep.ContCode = loan.cont-code
	    tRep.Amt = summ-t.
      end.

      if loan.close-date GE edate then do:
   	RUN SetSysConf IN h_base ("NoProtocol","YES").
           RUN SetSysConf IN h_base ("PUT-TO-TMESS","").
           {setdest.i &stream="stream err" &filename='_spool_recalc.tmp' &append = "APPEND"}
           {get_meth.i  'Calc' 'loanclc'}
           RUN VALUE(proc-name + ".p") (loan.contract,
                                        loan.cont-code,
                                        loan.close-date + 1).

   	RUN DeleteOldDataProtocol IN h_base ("PUT-TO-TMESS").
   	RUN DeleteOldDataProtocol IN h_base ("NoProtocol").
        /* ����⠥� �� �� ����ᨫ� � ��砫� ������� �� ��砫� ��ਮ�� */
        liamt = 0.
        for each loan-int of loan where loan-int.id-d eq 2 and loan-int.id-k eq 0 
	   and loan-int.mdate LE sdate and loan-int.mdate GE loan.open-date
           no-lock:
           liamt = liamt + loan-int.amt-rub.
        end.
	/* ����⠥� ������� ���⥦� */
	toamt = 0.
        for each term-obl of loan where term-obl.end-date LE sdate and term-obl.end-date GE loan.open-date 
	   and term-obl.idnt EQ 3
           no-lock:
	   toamt = toamt + term-obl.amt-rub.
	end.
	/* ����砥� ��९���� ��� ��������� ��� 0. */
	summ-t = liamt - toamt.
	/* �᫨ �� ��ᨫ��� ���६�, ⮣�� ��६ ������� ���⥦ */ 
	if summ-t LE 0 then do:
	   find first term-obl of loan where term-obl.end-date GE bdate and term-obl.end-date LE edate 
           and term-obl.idnt eq 3
           no-lock no-error.
	   if avail term-obl then do:
              summ-t = term-obl.amt-rub.
              if loan.currency ne "" then
                 summ-t = CurToCurWork("����",loan.currency,"",edate,term-obl.amt-rub).
              summ_all = summ_all + summ-t.   
           end.
	end.
        /* �᫨ �뫠 ��९���. */ 
        /*if summ-t GT 0 then do:*/
        else do:   
	   find first term-obl of loan where term-obl.end-date GE bdate and term-obl.end-date LE edate no-lock no-error.
	   if avail term-obl then do:
              summ-t = term-obl.amt-rub - summ-t.
              if summ-t GT 0 then do: 
                 if loan.currency ne "" then
                    summ-t = CurToCurWork("����",loan.currency,"",edate,summ-t).
                 summ_all = summ_all + summ-t.	
              end.
           end.           
        end.
        create tRep.
        ASSIGN 
           tRep.ContCode = loan.cont-code
           tRep.Amt = summ-t.
      end.
   end.
end.

filename = "./115_spr1_d" + string(today,"9999-99-99") + "_t" + replace(STRING(TIME,"HH:MM:SS"),":","-") + "_" + string(USERID("bisquit")) + ".log".
OUTPUT STREAM flRep to VALUE(filename).
/*OUTPUT TO VALUE(filename).*/
for each tRep no-lock:
/*  put unformatted tRep.ContCode format "x(15)" tRep.Amt SKIP.*/
  export stream flRep tRep.ContCode tRep.Amt.
end.
OUTPUT stream flRep CLOSE.



