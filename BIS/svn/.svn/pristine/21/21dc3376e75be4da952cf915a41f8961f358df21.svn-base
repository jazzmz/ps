{globals.i}
{intrface.get tmess}    /* Инструменты обработки сообщений. */
{lshpr.pro}            /* Инструменты для расчета параметров договора */
{svarloan.def NEW}          /* Shared переменные модуля "Кредиты и депозиты". */

def input param end-date as date no-undo.
def input param recidl as RECID no-undo.
def output param res as char init "" no-undo.
def output param restr as char init "" no-undo.
def var res1 as dec no-undo.

def var dT1 	  as dec    	NO-UNDO.
def var dT2 	  as dec 	NO-UNDO.
DEF VAR proc-name AS CHAR 	NO-UNDO.

DEFINE NEW SHARED STREAM err.

find first loan where recid(loan) eq recidl no-lock no-error.
if avail loan then do:
	if loan.close-date eq ? then do:
		/* пересчитаем договор */
		RUN SetSysConf IN h_base ("NoProtocol","YES").
	        RUN SetSysConf IN h_base ("PUT-TO-TMESS","").
                {setdest.i &stream="stream err" &filename='_spool_recalc.tmp' &append = "APPEND"}
                {get_meth.i  'Calc' 'loanclc'}
                RUN VALUE(proc-name + ".p") (loan.contract,
                                             loan.cont-code,
                                             end-date).

		RUN DeleteOldDataProtocol IN h_base ("PUT-TO-TMESS").
		RUN DeleteOldDataProtocol IN h_base ("NoProtocol").

		/* теперь смотрим на параметр 367 */
		RUN STNDRT_PARAM (loan.Contract, loan.Cont-code, 367, loan.since, OUTPUT res1, OUTPUT dT1, OUTPUT dT2).
		res = string(res1).
        end.
	else do:
		res = "договор закрыт. надо смотреть вручную".
	end.
end.
else res = "".
