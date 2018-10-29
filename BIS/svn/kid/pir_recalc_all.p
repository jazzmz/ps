/*
#3661
Пересчитывает все открытые договораы на дату end-date. 
Если договор на дату end-date был открыт, но в дату запуска процедуры закрыт, то пересчитывает на дату закрытия +1.
Автор: Никитина Ю.А.
*/
{globals.i}
{svarloan.def NEW}          /* Shared переменные модуля "Кредиты и депозиты". */
{intrface.get tmess}    /* Инструменты обработки сообщений. */
{intrface.get xclass} /* Загрузка инструментария метасхемы */
{intrface.get pogcr}
{norm.i new}

DEF VAR BtOk 		as log		NO-UNDO.
DEF VAR sfinish 	as char 	NO-UNDO.
DEF VAR sstart 		as char 	NO-UNDO.
DEF VAR tstart 		as int64 	NO-UNDO.
DEF VAR proc-name 	AS CHAR 	NO-UNDO.
DEF VAR vLastClsDate 	AS DATE 	NO-UNDO.

DEFINE NEW SHARED STREAM err.

def input param in-date as date no-undo.

vLastClsDate = FGetLastClsDate(?,"b").
IF vLastClsDate <> ? THEN
   end-date = vLastClsDate.

if end-date eq ? then do:
	{getdate.i}.
end.

MESSAGE "ВНИМАНИЕ! ~n Хотите запустить пересчет всех договоров на дату " end-date "? ~n ВНИМАНИЕ!" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE BtOk. 
IF NOT BtOk or BtOk eq ? THEN RETURN .

sstart = string(Time,"HH:MM:SS").
tstart = Time.
for each loan where loan.contract eq "Кредит" and (loan.close-date eq ? or loan.close-date GE end-date) 
		and loan.open-date LT end-date
		no-lock:
	PAUSE 0.
	Display "Пересчитываю договоры." skip "Время запуска " + sstart format "x(26)" skip "Время работы " + string((Time - tstart),"HH:MM:SS") format "x(26)" with frame Inf overlay Centered . 
	if loan.close-date eq ? then do:
		RUN SetSysConf IN h_base ("NoProtocol","YES").
	        RUN SetSysConf IN h_base ("PUT-TO-TMESS","").
                {setdest.i &stream="stream err" &filename='_spool_recalc.tmp' &append = "APPEND"}
                {get_meth.i  'Calc' 'loanclc'}
                RUN VALUE(proc-name + ".p") (loan.contract,
                                             loan.cont-code,
                                             end-date).

		RUN DeleteOldDataProtocol IN h_base ("PUT-TO-TMESS").
		RUN DeleteOldDataProtocol IN h_base ("NoProtocol").
        end.
	if loan.close-date GE end-date then do:
		RUN SetSysConf IN h_base ("NoProtocol","YES").
	        RUN SetSysConf IN h_base ("PUT-TO-TMESS","").
                {setdest.i &stream="stream err" &filename='_spool_recalc.tmp' &append = "APPEND"}
                {get_meth.i  'Calc' 'loanclc'}
                RUN VALUE(proc-name + ".p") (loan.contract,
                                             loan.cont-code,
                                             loan.close-date + 1).

		RUN DeleteOldDataProtocol IN h_base ("PUT-TO-TMESS").
		RUN DeleteOldDataProtocol IN h_base ("NoProtocol").
	end.
end.
Hide Frame Inf No-Pause.
