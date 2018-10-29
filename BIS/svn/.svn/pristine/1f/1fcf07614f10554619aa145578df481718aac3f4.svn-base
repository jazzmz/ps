{globals.i}
{intrface.get db2l}
{intrface.get comm}
{intrface.get i254}
{intrface.get instrum}

def input param end-date as date no-undo.
def input param recidl as RECID no-undo.
def output param res as char init "" no-undo.
def output param restr as char init "" no-undo.

def var PrRisk  as DEC	 	NO-UNDO.
def var GrRisk  as int	 	NO-UNDO.
DEF VAR POS 	as char 	NO-UNDO.
DEF VAR kau_ob 	AS char	 	NO-UNDO.
DEF VAR dr 	AS char	 	NO-UNDO.

DEF VAR vCRSurr       AS CHAR NO-UNDO. /* Суррогат comm-rate'a  */
DEF VAR vKachObespech AS CHAR NO-UNDO. /* Качество обеспечения  */
DEF BUFFER bfrLoan FOR loan.

find first loan where recid(loan) eq recidl no-lock no-error.
if avail loan then do:
	/* если будет транш, то смотри обеспечение на охвате */
	find first bfrLoan where bfrLoan.cont-code eq entry(1,loan.cont-code," ") no-lock no-error.
	if avail bfrLoan then do:
        	for each term-obl of bfrLoan WHERE /*term-obl.cont-code EQ bfrLoan.cont-code AND term-obl.contract EQ bfrLoan.contract */
        	        	term-obl.end-date GE end-date 
        			and term-obl.idnt EQ 5
        			no-lock:
/*        		kau_ob = term-obl.contract + "," + term-obl.cont-code + ",5," + string(term-obl.end-date) + "," + string(term-obl.fop-offbal).*/
			kau_ob = GetSurrogateBuffer("term-obl",(BUFFER term-obl:HANDLE)).
        		dr = GetXAttrValueEx("comm-rate",vCRSurr,"КачОбеспеч","").
                	find last comm-rate WHERE comm-rate.commission EQ "КачОбеспеч" 
        				AND  comm-rate.acct EQ "0" 
        				AND comm-rate.kau EQ kau_ob 
        				and comm-rate.since LE end-date 
        				NO-LOCK no-error.
        		if avail comm-rate then do:
        			vCRSurr  = GetSurrogateBuffer("comm-rate",(BUFFER comm-rate:HANDLE)).
        			/* Категорию качества по доп.реку на comm-rate */
        			vKachObespech = GetXAttrValueEx("comm-rate",vCRSurr,"КачОбеспеч","бе").
        			if vKachObespech eq "II" then do: 
					/*res = "есть" . */
                         		dr = GetXAttrValueEx("term-obl",kau_ob,"РегОбесп","").
                         		if dr ne "" then do:
                 	       			res = "есть" + ",зарегистрировано".	
                         		end.
                         		else  res = "есть" + ", не зарегистрировано".
				end.
        		end.
         	end.
	end.
	/* проверка */
	if loan.cont-type begins "Ипот" and res eq "" then do:
                restr = "ВНИМАНИЕ!".
	end.
end.
