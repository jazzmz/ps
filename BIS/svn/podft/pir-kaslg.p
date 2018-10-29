{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-kaslg.p,v $ $Revision: 1.1 $ $Date: 2008-05-16 09:56:56 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Причина       : ТЗ от 10.09.2007, Отдел противодействия легализации доходов, Утина В.А
Назначение    : Отчет по счетам, открытые 3 месяца назад и имеющие обороты по кассе более 600000 руб
Место запуска : БМ/Печать/Отчеты по лицевым счетам/Оборотно-сальдовые ведомости/Отчет по клиентам открывшие счета и работающие по кассе.
Автор         : $Author: kuntash $ 
Изменения     : $Log: not supported by cvs2svn $

------------------------------------------------------ */


{globals.i}
{chkacces.i}
{sh-defs.i}
{wordwrap.def}


{ifndef {&format}}
   &GLOB format ->>>,>>>,>>>,>>9.99
{endif} */

DEFINE VAR long-acct   AS   CHAR FORMAT "x(25)" COLUMN-LABEL "ЛИЦЕВОЙ СЧЕТ" NO-UNDO.
DEFINE VAR name        AS   CHAR FORMAT "x(35)" EXTENT 10 COLUMN-LABEL "НАИМЕНОВАНИЕ" NO-UNDO.

DEFINE VAR out_Result_db  AS   DECIMAL    NO-UNDO.
DEFINE VAR out_Result_cr  AS   DECIMAL    NO-UNDO.
DEFINE VAR porog          AS   DECIMAL    NO-UNDO.

DEFINE VARIABLE i AS INTEGER    NO-UNDO.
DEFINE VARIABLE vM AS INTEGER    NO-UNDO.
DEFINE VARIABLE vD AS INTEGER    NO-UNDO INIT 0.

DEFINE BUFFER b-op-entry FOR op-entry.
DEFINE BUFFER b-acct FOR acct.
DEFINE BUFFER b-op FOR op.


DEFINE TEMP-TABLE tt-Acct  NO-UNDO
   FIELD fAcct       LIKE acct.acct
   FIELD fopen       as char format "x(10)"
   FIELD fclose      as char format "x(10)"
   FIELD Fdb         LIKE acct-pos.debit  
   FIELD fcr         LIKE acct-pos.credit
   FIELD fmar        AS char format "x(10)" 
   INDEX iAcct       IS UNIQUE PRIMARY  fAcct
   INDEX iturn Fdb Fcr DESCENDING
.


{getdate.i}
/*{getturns.i}*/

{get-fmt.i &obj=b-Acct-Fmt}

{empty tt-Acct}
 
{justamin}


i = 0.
out_Result_db = 0.
out_Result_cr = 0.
porog = 600000.

 
 /* определяем 3 месяца назад */
   vM = IF MONTH(end-date) LT 4 THEN (MONTH (end-date) + 9) ELSE (MONTH(end-date) - 3).

   ASSIGN beg-date = DATE (vM, DAY (end-date), YEAR (end-date) - (IF vM LE 9 THEN 0 ELSE 1)) NO-ERROR.

   DO WHILE ERROR-STATUS:ERROR:
      vd = vd + 1.
      ASSIGN 
         beg-date = DATE (vM, DAY (end-date) - vd, YEAR (end-date) - (IF vM LE 9 THEN 0 ELSE 1))
      NO-ERROR.
   END.


/*
MESSAGE(beg-date) VIEW-AS ALERT-BOX BUTTONS OK. PAUSE. 
MESSAGE(end-date) VIEW-AS ALERT-BOX BUTTONS OK. PAUSE. 
*/

/* Для каждого не закрытого в задаваемом промежутке дат счета юрика или физика,*/ 

FOR EACH acct WHERE CAN-DO('Ю,Ч',acct.cust-cat) 				  AND 
                     acct.acct-cat    EQ 'b'     				  AND
                    (acct.close-date  EQ ?         				OR
                     acct.close-date  LE today) 				AND
                     acct.open-date   GE beg-date      NO-LOCK:
                    
    /* Для каждой проводки такого счета, дебет которой счет, а кредит - касса */
    FOR EACH op-entry WHERE op-entry.op-date GE beg-date  	AND  
                            op-entry.op-date LE end-date  		AND
                            op-entry.acct-db EQ acct.acct	  	AND
                            CAN-DO('20202*',op-entry.acct-cr)
                                                          NO-LOCK:
                           {on-esc RETURN}                          
     /* Складываем сумму проводок */
     if avail op-entry then  out_Result_db = out_Result_db + op-entry.amt-rub. 
     END.   

    /* Для каждой проводки такого счета, дебет которой счет, а дебет - касса */
    FOR EACH op-entry WHERE op-entry.op-date GE beg-date  	AND  
                        op-entry.op-date LE end-date  		AND
                        op-entry.acct-cr EQ acct.acct     AND
                        CAN-DO('20202*',op-entry.acct-db)
                                                          NO-LOCK:
                           {on-esc RETURN}                          
      /* Складываем сумму проводок */
      if avail op-entry then  out_Result_cr = out_Result_cr + op-entry.amt-rub.
    END.
     
     	IF  out_Result_db GE porog or out_Result_cr GE porog  THEN 
     	DO:
   		   FOR EACH op-entry where op-entry.acct-cr EQ acct.acct  and
   		                           op-entry.op-date GE beg-date  	and
                                 op-entry.op-date LE end-date 
   		                           no-lock,
   		       first op of op-entry no-lock:
   		       
   		       
   		       IF avail op and can-do(GetXattrValueEx("op", string(op.op), "ПодозДокумент",""),"6001") then
   		       DO:
  		       i = i + 1.
   		       END.
   		   END.                        	
   		   FOR EACH op-entry where op-entry.acct-db EQ acct.acct and
   		                           op-entry.op-date GE beg-date  	and
                                 op-entry.op-date LE end-date 
   		                           no-lock,
   		       first op of op-entry no-lock:
   		       
   		       
   		       IF avail op and can-do(GetXattrValueEx("op", string(op.op), "ПодозДокумент",""),"6001") then
   		       DO:
  		       i = i + 1.
   		       END.
   		   END.                        	
   		  
   		  
   		  CREATE tt-Acct.
        ASSIGN
           tt-acct.fAcct     = acct.acct
					 tt-acct.fopen     = string(acct.open-date,"99.99.9999")
					 tt-acct.fclose    = if acct.close-date ne ? then string(acct.close-date,"99.99.9999") else ""
					 tt-acct.Fdb       = ABS(out_Result_db) 
           tt-acct.fcr       = ABS(out_Result_cr) 
           tt-acct.fmar      = if i =0 then "" else "      " + string(i)
        .
     END.
out_Result_db = 0.
out_Result_cr = 0.
i=0.
END. /* FOR EACH acct WHERE CAN-DO('Ю,Ч',acct.cust-cat) */

{setdest.i &cols="200"}

FOR EACH tt-Acct NO-LOCK,
    FIRST acct WHERE acct.acct EQ tt-acct.facct NO-LOCK 
    BY tt-acct.Fdb DESCENDING ON ENDKEY UNDO, LEAVE:
  
FORM  NAME[1]
      long-acct
      acct.Curr
      tt-acct.fopen       COLUMN-LABEL "ДАТА!ОТКРЫТИЯ"   
      tt-acct.fclose      COLUMN-LABEL "ДАТА!ЗАКРЫТИЯ"   
      tt-Acct.Fdb         COLUMN-LABEL "ОБОРОТ ПО!ДЕБЕТУ КАССА"   FORMAT "{&format}" 
      tt-Acct.fcr         COLUMN-LABEL "ОБОРОТ ПО!КРЕДИТУ КАССА"  FORMAT "{&format}" 
      tt-acct.fmar        COLUMN-LABEL "НАЛИЧИЕ 6001! ЗА ПЕРИОД" 
      
 HEADER  CAPS(name-bank) FORMAT "x(70)" SKIP
        "ЖУРНАЛ ПО КАССОВЫМ ОПЕРАЦИЯМ ЗА " + CAPS({term2str Beg-Date End-Date})  FORMAT "x(69)"

  SKIP(2)
  WITH NO-BOX WIDTH 400
.

  {getcust.i &name="name" &offinn="/*"}
  name[1] = TRIM(name[1] + " " + name[2]).
  {wordwrap.i &s=name &l=35 &n=10}  
  
  DISPLAY {out-fmt.i tt-Acct.facct fmt} @ long-acct
          
          NAME[1]
          acct.Curr
          tt-acct.fopen
          tt-acct.fclose
          tt-acct.Fdb      
          tt-acct.fcr      
          tt-acct.fmar

  .
END.
{preview.i}

{pir-log.i &module="$RCSfile: pir-kaslg.p,v $" &comment="Оборотная ведомость за период по клиентам, обороты кассы которых превысили пороговую сумму."}


