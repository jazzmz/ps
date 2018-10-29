DEF INPUT PARAMETER iKodStruct as CHAR.
DEF INPUT PARAMETER iKodTarif as CHAR.
DEF INPUT PARAMETER iDate as date.
DEF INPUT PARAMETER icomm-rate-id as Integer.


/*DEF var iKodStruct as CHAR.
DEF var iKodTarif as CHAR.
DEF var iDate as date.*/


DEF VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

TERMINAL-SIMULATION = CURRENT-WINDOW.
ASSIGN CURRENT-WINDOW                = TERMINAL-SIMULATION 
       THIS-PROCEDURE:CURRENT-WINDOW = TERMINAL-SIMULATION.


/* Форма для ввода и редактирования */
def var cVal as Char format "x(3)" NO-UNDO.
def var Min-val as Dec  NO-UNDO.
def var rate as dec NO-UNDO.
def var fixed like comm-rate.rate-fixed.
def var temp as char NO-UNDO.
DEF BUTTON btn_save LABEL "Сохранить".
/* Конец объявления переменных формы */


def BUFFER bfrcode for code.

def var isok as Logical NO-UNDO.

def var sin as date no-undo.

find first bfrcode where bfrcode.code = iKodStruct and bfrcode.class = "PirSrtTarif" NO-LOCK NO-ERROR.
if not available (bfrcode) then MESSAGE "Ошибка поиска структуры тарифного плана" VIEW-AS ALERT-BOX.


if icomm-rate-id <> 0 then 
   do:
      find first comm-rate where comm-rate.comm-rate-id = icomm-rate-id NO-LOCK NO-ERROR.
      if available comm-rate then 
	 do:
	    cVal = comm-rate.currency.
	    Min-val = comm-rate.min-value.
	    rate = comm-rate.rate-comm.
	    fixed = comm-rate.rate-fixed.
	    sin = comm-rate.since.
         end.
   end.

DEF frame fSet 
   "Валюта:" cVal SKIP(1) 
   "Минимальное значение:" Min-val SKIP(1) 
   "Размер Комиссии" rate SKIP(1)
   "" fixed SKIP(1)
   btn_save
   WITH CENTERED NO-LABELS TITLE bfrcode.name.


   DISPLAY cVal Min-val rate fixed  WITH frame fSet.
   isok = true.

/*   ON LEAVE OF fixed IN FRAME fSet DO:
     if INPUT fixed <> "=" and INPUT fixed <> "%" then DO:
	message "ВОЗМОЖНЫЕ ЗНАЧЕНИЯ = или %" VIEW-AS ALERT-BOX.
	fixed = "%".
     end.	
     END.                */

on choose of btn_save in frame fSet do:
   if icomm-rate-id <> 0 and sin <> idate then do:
   find first comm-rate where comm-rate.comm-rate-id = icomm-rate-id NO-ERROR.
   if available comm-rate then DELETE comm-rate.
   end.

   temp = bfrcode.val + "_" + iKodTarif. 

/*   SET cVal Min-val rate fixed WITH frame fSet.*/

    cVal = INPUT cVal.
    Min-val = INPUT Min-val.
    rate = INPUT rate.
    fixed = INPUT fixed.

/*   find first commission where commission.commission = temp and commission.currency = cVal and commission.min-value = min-val NO-LOCK NO-ERROR.

   if not available (commission) then
      do:
         /*создаем комиссию для тарифного плана, затем создаем значение комиссии*/
         CREATE commission.
	 ASSIGN
	  commission.commission = temp   
          commission.currency = cVal
	  commission.name-comm = bfrcode.name
          commission.min-value = min-val
          commission.contract = "base".
      end.*/


/*   find first commission where commission.commission = temp and commission.currency = cVal NO-LOCK NO-ERROR.   /* проверяем что действительно добавилась новая комиссия */
   if not available(commission) then message "Ошибка создания комиссии!!!" VIEW-AS ALERT-BOX.
   else                                                                                      */
     do:
        /*создаем значение комиссии в таблице comm-rate, 
	  для этого сначала ищем есть ли такое значение на выбранную дату, 
	  если есть - то модифицируем его, если нет создаем новое*/
      find first comm-rate where comm-rate.commission = temp
			     and comm-rate.currency   = cVal
                             and comm-rate.min-value  = Min-val
			     and comm-rate.since = iDate NO-ERROR.

        if available comm-rate then do: /*если нашли значит просто изменяем значения */
           DELETE comm-rate.

           CREATE comm-rate.
           ASSIGN 
             comm-rate.commission = temp
             comm-rate.currency   = cVal
	     comm-rate.min-value  = Min-val
	     comm-rate.since = iDate
	     comm-rate.rate-fixed = fixed
	     comm-rate.acct = "0"
	     comm-rate.rate-comm = rate.
           end.
	 else
	   do:
	      CREATE comm-rate.
              ASSIGN 
                 comm-rate.commission = temp
                 comm-rate.currency   = cVal
	         comm-rate.min-value  = Min-val
	         comm-rate.since = iDate
	         comm-rate.rate-fixed = fixed
                 comm-rate.acct = "0"
	         comm-rate.rate-comm = rate.
	   end.

     end.



end.




        enable cVal with frame fset IN WINDOW TERMINAL-SIMULATION.
	enable Min-val with frame fset IN WINDOW TERMINAL-SIMULATION.
	enable rate with frame fset IN WINDOW TERMINAL-SIMULATION. 
	enable fixed with frame fset IN WINDOW TERMINAL-SIMULATION.
        enable btn_save with frame fset IN WINDOW TERMINAL-SIMULATION.
        VIEW TERMINAL-SIMULATION.
        IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
                   WAIT-FOR /**CLOSE OF THIS-PROCEDURE*/
                            CHOOSE OF btn_save IN FRAME fset.
           END.



/**/

ON esc endkey.


