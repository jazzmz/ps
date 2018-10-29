{globals.i}
{tmprecid.def}

/* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR.  
/*DEF VAR iParam AS CHAR INIT "/home/bis/quit41d/imp-exp/telex/out/swift" NO-UNDO. */
/* Первый параметр */
DEF VAR out_file_name AS CHAR NO-UNDO. 

DEF VAR swift_name as CHAR NO-UNDO. 

DEF VAR oTpl as TTpl NO-UNDO.

DEF VAR i as INT NO-UNDO.
DEF VAR Cur AS CHAR NO-UNDO.
DEF VAR refer as CHAR NO-UNDO.

def var RusAlfavit as char INIT "а,б,в,г,д,е,ё,ж,з,и,й,к,л,м,н,о,п,р,с,т,у,ф,х,ц,ч,ш,щ,ъ,ы,ь,э,ю,я".
def var NeRusAlfavit as char INIT "A,B,V,G,F,E,E,ZH,Z,I,I,K,L,M,N,O,P,R,S,T,U,F,H,Z,CH,SH,SH,',Y,',E,YU,YA".


def buffer bloan for loan.

FIND FIRST tmprecid.
FIND FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK.

FIND FIRST banks where loan.cust-id = banks.bank-id NO-LOCK.
IF NOT AVAILABLE banks THEN MESSAGE "Не найден банк-контрагент по договору " loan.cont-code VIEW-AS ALERT-BOX.

CASE loan.currency:
     WHEN "810" THEN cur = "RUB".
     WHEN ""    THEN cur = "RUB".
     WHEN "978" THEN cur = "EUR".
     WHEN "840" THEN cur = "USD".
END CASE.

refer = STRING(YEAR(loan.open-date),"9999") + STRING(MONTH(loan.open-date),"99") + STRING(DAY(loan.open-date),"99") + "/" + ENTRY(2,loan.cont-code," ").

IF GetXAttrValueEx("banks",string(banks.bank-id),"swift-address","") eq "" or
   GetXAttrValueEx("banks",string(banks.bank-id),"swift-address","") eq ? then
   		do:
   		MESSAGE "Незаполнен SWIFT Банка!" VIEW-AS ALERT-BOX.
      RETURN.
      end.
else   
do:
 swift_name = GetXAttrValueEx("banks",string(banks.bank-id),"swift-address","").
 out_file_name  = ENTRY(1,iParam) +  "/"  + string(today,"999999") + swift_name  + ".999".                        
end.                         


find first term-obl where term-obl.cont-code EQ loan.cont-code 
                      and term-obl.contract  EQ loan.contract
                      and term-obl.idnt      EQ 2
                      and term-obl.end-date = loan.open-date
                      NO-LOCK NO-ERROR.

DEF VAR amount as DECIMAL NO-UNDO.

amount = term-obl.amt-rub. 
find last comm-rate where comm-rate.commission = "%Кред"
                      and comm-rate.kau = loan.contract + "," + loan.cont-code
                      and comm-rate.since <= loan.open-date 
                      NO-LOCK NO-ERROR.

DEF VAR Rate as DECIMAL NO-UNDO.

Rate = comm-rate.rate-comm.

find last bloan where bloan.class-code = "loan_agr_mm"
                 and (bloan.close-date = ? or bloan.close-date >= loan.open-date)
                 and (bloan.open-date <= loan.open-date)
                 and bloan.cust-cat = loan.cust-cat
                 and bloan.cust-id = loan.cust-id
                 NO-LOCK NO-ERROR.

def var gen_sogl as char no-undo.

gen_sogl = bloan.cont-code.

do i = 1 to 33:
   gen_sogl = replace (gen_sogl,entry(i,rusAlfavit),entry(i,nerusAlfavit)).
end.


def var payments as char init "" no-undo.
def var acct_type as char init "" no-undo.
DEF VAR Proc_amount AS DECIMAL INIT 0 NO-UNDO.


for each term-obl where term-obl.cont-code = loan.cont-code 
                      and term-obl.contract = loan.contract
                      and (term-obl.idnt = 1 OR term-obl.idnt = 3)
                      NO-LOCK
                      by term-obl.end-date 
		      by term-obl.idnt.

   if term-obl.idnt = 1 then do: acct_type = "КредПроц". Proc_amount = Proc_amount + term-obl.amt-rub. end.
                        else acct_type = "Кредит".

   find last loan-acct where loan-acct.contract  = loan.contract
                         and loan-acct.cont-code = loan.cont-code
                         and loan-acct.acct-type = acct_type
                         NO-LOCK NO-ERROR.


   payments = payments +  "ACC " + loan-acct.acct + " " + STRING(YEAR(loan.open-date),"9999") + STRING(MONTH(loan.open-date),"99") + STRING(DAY(loan.open-date),"99") + " " + Cur + " " + TRIM(STRING(term-obl.amt-rub,"->>>>>>>>>>>>>>>>9.99")) + CHR(10).
    
END.

  def var temp_swift as char NO-UNDO.
  def var temp_swift1 as char NO-UNDO.

  temp_swift = "".
  temp_swift1 = "".
  if (Length(swift_name) > 8) then 
	do:
           temp_swift = SUBSTRING(swift_name,9,Length(swift_name)).
	   
	   temp_swift1 = temp_swift.	
/*	   message temp_swift1 ViEW-AS ALERT-BOX.*/
	   if Length(temp_swift) < 4 then 
              temp_swift = "X" + temp_swift.

/*	      do j = 1 to (4 - Length(temp_swift)):
                 temp_swift = temp_swift + "X".
	      end.*/

	end.
  else temp_swift = "XXXX".
                      
    oTpl = new TTpl("pir_mm_swift999.tpl").
    oTpl:addAnchorValue("swift_name",swift_name + temp_swift).
    oTpl:addAnchorValue("refer",refer).
    oTpl:addAnchorValue("cur",cur).
    oTpl:addAnchorValue("AMOUNT",TRIM(STRING(amount,"->>>>>>>>>>>>9.99"))).
    oTpl:addAnchorValue("rate",rate).
    oTpl:addAnchorValue("Proc_amount",TRIM(STRING(Proc_amount,"->>>>>>>>>>>>9.99"))).
    oTpl:addAnchorValue("Trade_date",loan.open-date).
    oTpl:addAnchorValue("Value_date",loan.open-date).
    oTpl:addAnchorValue("Maturity_date",loan.end-date).
    oTpl:addAnchorValue("Gen_sogl",gen_sogl).
    oTpl:addAnchorValue("Gen_sogl_date",bloan.open-date).
    oTpl:addAnchorValue("cont-code",ENTRY(1,loan.cont-code," ")).
    oTpl:addAnchorValue("DateSogl",GetXAttrValueEx("loan",loan.contract + "," + ENTRY(1,loan.cont-code," "),"ДатаСогл","")).
    oTpl:addAnchorValue("transh_number",ENTRY(2,loan.cont-code," ")).
    oTpl:addAnchorValue("PAYMENTS",payments).


                         


{setdest.i}
    oTpl:show().
{preview.i}



OS-COPY VALUE("_spool.tmp") VALUE("telex_tmp.txt").

MESSAGE
                                "Экспортировать данные?"
VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE continue-ok AS LOGICAL .
/*out_file_name = "123.txt".*/
IF continue-ok THEN
DO:
  OUTPUT TO VALUE(out_file_name).
   display
    with NO-LABELS NO-UNDERLINE
   .
  OUTPUT CLOSE.

OS-COPY VALUE("telex_tmp.txt") VALUE(out_file_name).
OS-COMMAND silent VALUE("ux2dos") VALUE(out_file_name).
MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
END.                                        

DELETE OBJECT oTpl.