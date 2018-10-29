{bislogin.i}
/*def var iKodStruct AS CHAR INIT "I.1.01".
def var iKodTarif as char init "1.".
def var idate as date init 12/12/12.
def var icomm-rate-id as int init 0.*/

DEF INPUT PARAMETER iKodStruct as CHAR.
DEF INPUT PARAMETER iKodTarif as CHAR.
DEF INPUT PARAMETER iDate as date.
DEF INPUT PARAMETER icomm-rate-id as Integer.
 /* Форма для ввода и редактирования */
def var cVal as Char format "x(3)" NO-UNDO.
def var Min-val as Dec  NO-UNDO.
def var rate as dec NO-UNDO.
def var fixed like comm-rate.rate-fixed.
def var temp as char NO-UNDO.
def buffer bcomm-rate for comm-rate.
def var isnew as logical INIT TRUE no-undo.

def buffer bfrcode for code.

find first bfrcode where bfrcode.code = iKodStruct and bfrcode.class = "PirStrTarif" NO-LOCK NO-ERROR.
if not available (bfrcode) then MESSAGE "Ошибка поиска структуры тарифного плана" VIEW-AS ALERT-BOX.

find first comm-rate where comm-rate.comm-rate-id = icomm-rate-id 
		       and comm-rate.commission = bfrcode.val + "_" + iKodTarif 
		       and comm-rate.since = idate	
			NO-ERROR.

if available comm-rate then do:
   cVal = comm-rate.currency.
   min-val = comm-rate.min-value.
   rate =  comm-rate.rate-comm.
   fixed = comm-rate.rate-fixed.
   isnew = false.
end.


def frame fSet
"Валюта:" cVal skip
"С какой суммы действует:" min-val FORMAT "->>>,>>>,>>9.99" skip
"Ставка" rate skip
"=/%   " fixed skip
   WITH CENTERED NO-LABELS TITLE "Введите данные".

DISPLAY cVal min-val rate fixed WITH FRAME fSet.

   ON LEAVE OF fixed IN FRAME fSet DO:
     if INPUT fixed <> "=" and INPUT fixed <> "%" then DO:
        message "ВОЗМОЖНЫЕ ЗНАЧЕНИЯ = или %" VIEW-AS ALERT-BOX.
        fixed = yes.
        RETURN NO-APPLY.
     end.        
     END.                

   ON LEAVE OF cVal IN FRAME fSet DO:
     if NOT CAN-DO(",826,840,978",INPUT cVal) THEN DO:
        message "Шутить изволите?" VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
     end.        
     END.                

   ON LEAVE OF min-val IN FRAME fSet DO:
     find first bcomm-rate where bcomm-rate.commission = bfrcode.val + "_" + iKodTarif 
                             and bcomm-rate.since = idate
                             and bcomm-rate.min-value = INPUT min-val NO-LOCK NO-ERROR.


     if AVAILABLE (bcomm-rate) THEN DO:
        message "Уже существует комиссия с такой минимальной суммой" VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
     end.        
     END.                



SET cVal min-val rate fixed WITH FRAME fSet.

if isnew then 
CREATE comm-rate.

ASSIGN
             comm-rate.commission = bfrcode.val + "_" + iKodTarif
             comm-rate.currency   = cVal
             comm-rate.min-value  = Min-val
             comm-rate.since = iDate
             comm-rate.rate-fixed = fixed
             comm-rate.acct = "0"
             comm-rate.rate-comm = rate.

HIDE FRAME fset.

