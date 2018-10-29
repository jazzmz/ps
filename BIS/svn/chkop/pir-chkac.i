/* ---------------------------------------------------------------------
File       : $RCSfile: pir-chkac.i,v $ $Revision: 1.17 $ $Date: 2009-10-22 04:58:10 $
Copyright  : ООО КБ "Пpоминвестрасчет"
Function   : Включаемый файл продедуры pir-chkop.p
           : Производит обработку счетов по дебету и кредиту проводки
           : &suff - обязательный параметр, указывает какой счет из проводки брать.
Created    : 29.05.2007 lavrinenko
Modified   : $Log: not supported by cvs2svn $
Modified   : Revision 1.16  2008/11/24 16:31:03  Buryagin
Modified   : Fix the final check of the account balance. It has been simplified.
Modified   :
Modified   : Revision 1.15  2008/11/01 08:01:57  Buryagin
Modified   : Changed of the logic of control.
Modified   :
Modified   : Revision 1.14  2008/10/27 14:34:33  Buryagin
Modified   : *** empty log message ***
Modified   :
Modified   : Revision 1.13  2008/10/16 05:44:03  Buryagin
Modified   : Fix the control of 'red' balance. Now looking for the entries from the last opened operation day to past.
Modified   :
Modified   : Revision 1.12  2007/09/25 06:50:56  lavrinenko
Modified   : Доработано определение остатка по счету при переносе документов в другой день.
Modified   :
Modified   : Revision 1.11  2007/09/04 07:30:53  lavrinenko
Modified   : Доработка процедурры контроля красного сальнодо по активным счетам
Modified   :
Modified   : Revision 1.10  2007/07/24 07:27:27  lavrinenko
Modified   : Реализована проверка размерности назначения платежа в документах отправляемых в МЦИ, Д4, Лобырева
Modified   :
Modified   : Revision 1.9  2007/07/04 07:52:13  lavrinenko
Modified   : усовершенствован механизм больбы с красным сальдо
Modified   :
Modified   : Revision 1.8  2007/07/04 06:55:17  lavrinenko
Modified   : Добавлена проверка остатка на последний рабочий день
Modified   :
Modified   : Revision 1.7  2007/06/28 12:20:20  lavrinenko
Modified   : Реализованы методы дополнительного контроля документов отправленных в ЬЦИ
Modified   :
Modified   : Revision 1.6  2007/06/25 14:04:37  lavrinenko
Modified   : Добавлена обработка дебета пассивных счетов имеющих парные счета
Modified   :
Modified   : Revision 1.5  2007/06/25 13:43:35  lavrinenko
Modified   : Добавлена обработка дебета пассивных счетов имеющих парные счета
Modified   :
Modified   : Revision 1.4  2007/06/21 12:59:49  lavrinenko
Modified   : Доработана обработка удаления докумен
Modified   :
Modified   : Revision 1.3  2007/06/20 11:48:43  lavrinenko
Modified   : Добавлена обработка удаления документа
Modified   :
Modified   : Revision 1.2  2007/06/13 13:29:29  lavrinenko
Modified   :  Доработка по замечаниям во время экуатации
Modified   :
Modified   : Revision 1.1  2007/06/07 09:33:21  lavrinenko
Modified   : ╨┐╤А╨╛╤Ж╨╡╨┤╤Г╤А╨░ ╨┐╤А╨╛╨▓╨╡╤А╨║╨╕ ╨╜╨░ ╨║╤А╨░╤Б╨╜╨╛╨╡ ╤Б╨░╨╗╤М╨┤╨╛
Modified   :
---------------------------------------------------------------------- */

RELEASE acct.
		
IF AVAIL history AND LOOKUP ('acct-{&suff}',history.field-value) > 0 THEN 
   FIND FIRST acct WHERE acct.acct =  ENTRY(LOOKUP ('acct-{&suff}',history.field-value) + 1, history.field-value) NO-LOCK NO-ERROR.
ELSE 
   FIND FIRST acct WHERE acct.acct = op-entry.acct-{&suff} NO-LOCK NO-ERROR.
			
IF AVAIL acct AND GetXAttrValueEx("acct", acct.acct + "," + acct.currency,"СКонСальдо",?) EQ "Запрет" THEN DO: 
        
  IF NOT ((acct.side = "П") AND "{&suff}" EQ "db"  AND {assigned acct.contr-acct} OR /* ситуации когда не проверяем */
           (acct.side = "А") AND "{&suff}" EQ "db"  AND op.op-date LT op-entry.op-date) THEN DO: 

	/** 
		Необходимо проверять наличие всех документов в следующих опер днях.
		Для этого найдем последний открытый опер.день.
	*/
	FIND LAST op-date NO-LOCK NO-ERROR.
	vDate = MINIMUM(op.op-date,op-entry.op-date).
	RUN acct-pos IN h_base (acct.acct, acct.currency, vDate, vDate, {&line-status}).

	/**
	   ----------------------------------------------------------------------------------------
	   ПРОВЕРКА ИЗМЕНЕНИЯ СТАТУСА
	   
	*/
  	/** 
  		если статус меняется и переходит через пограничный статус или документ удаляется 
  	*/
  	IF MAXIMUM(op.op-status, op-entry.op-status) GE {&line-status} AND 
  	  (MINIMUM(op.op-status, op-entry.op-status) LT {&line-status} 
  	   OR 'delete' EQ iParam) THEN DO: 
		  	 
		  	 vDate = IF (acct.side = "А") AND "{&suff}" EQ "db" THEN MINIMUM(op.op-date,op-entry.op-date)
             ELSE op-date.op-date.
		  	 
		  	 RUN acct-pos IN h_base (acct.acct, acct.currency, vDate, vDate, {&line-status}).

			 FOR EACH b-op-entry OF op WHERE b-op-entry.acct-db EQ acct.acct NO-LOCK:
				IF op.op-status GT op-entry.op-status	
				THEN {pir-calcsh.i &buff=b-op-entry &p-m={&p-m}}  			 /* статус увеличился */
				ELSE {pir-calcsh.i &buff=b-op-entry &p-m=" {&p-m} -1 *"} /* статус уменьшился */
			 END.
			 
			 FOR EACH b-op-entry OF op WHERE b-op-entry.acct-cr EQ acct.acct NO-LOCK:
				IF op.op-status LT op-entry.op-status	OR 'delete' EQ iParam
				THEN {pir-calcsh.i &buff=b-op-entry &p-m="{&p-m} -1 * "} /* статус уменьшился */
				ELSE {pir-calcsh.i &buff=b-op-entry {&*}} 							 /* статус увеличился */
			 END.
	END.


	/**
	   ----------------------------------------------------------------------------------------
	   ПРОВЕРКА ИЗМЕНЕНИЯ ДАТЫ
	   
	*/

	IF op.op-date GT op-entry.op-date THEN DO: /* если переносим документ вперед */

			 FOR EACH b-op-entry OF op 
			     WHERE b-op-entry.acct-db EQ acct.acct AND 
			           b-op-entry.op-date EQ op-entry.op-date NO-LOCK:
		 		
		 		IF  "{&suff}" EQ "cr" 
		 		THEN {pir-calcsh.i &buff=b-op-entry &p-m={&p-m}} 
		 		ELSE {pir-calcsh.i &buff=b-op-entry &p-m="{&p-m} -1 * "}
			 END.

			 FOR EACH b-op-entry OF op  
			     WHERE b-op-entry.acct-cr EQ acct.acct AND 
			           b-op-entry.op-date EQ op-entry.op-date NO-LOCK:
			    
				IF  "{&suff}" EQ "cr" 
				THEN {pir-calcsh.i &buff=b-op-entry &p-m="{&p-m} -1 * "} 
				ELSE {pir-calcsh.i &buff=b-op-entry &p-m={&p-m}}
			 END.

	END. ELSE IF op.op-date LT op-entry.op-date THEN DO: /* если переносим документ назад */
			 
			 FOR EACH b-op-entry OF op WHERE b-op-entry.acct-db EQ acct.acct NO-LOCK:
		 		IF  "{&suff}" EQ "db" THEN {pir-calcsh.i &buff=b-op-entry &p-m="{&p-m} -1 * "} 
			 END.
			 
			 FOR EACH b-op-entry OF op WHERE b-op-entry.acct-cr EQ acct.acct NO-LOCK:
				IF  "{&suff}" EQ "db" THEN {pir-calcsh.i &buff=b-op-entry &p-m={&p-m}} 
  		 	 END.
	END.
	

	/**
	   ----------------------------------------------------------------------------------------
	   ПРОВЕРКА ИЗМЕНЕНИЯ СУММЫ
	   
	   Анализ и мысли: все что было ниже до горизонтальной черты вроде не нужно вовсе, так как
	   контроль изменения суммы проводки работает в стандартном механизме БИС.
	   
	*/
	
	/**
		--------------------------------------------------------------------------------------
	*/
		
	/** Если счет валютный и остаток в валюте равен нулю, то и
	рублевый эквивалент остатка тоже должен быть равен нулю.
	Он таковым и станет, но только при закрытии дня, а пока нужна следующая строка кода */
	if acct.currency <> "" and sh-val = 0 then sh-bal = 0.
	
	vSumSaldo = IF acct.currency EQ "" THEN sh-bal ELSE sh-val.
	  
	/** НОВЫЙ ВАРИАНТ: ПРЕДПОЛОЖИТЕЛЬНО РАБОЧИЙ!!
	 
	    Окончательный анализ УДАЛЕНИЯ и ИЗМЕНЕНИЯ СТАТУСА, ДАТЫ. 
	    Изменение СУММЫ проводки контролируется штатной процедурой БИС. 
	*/
	
	IF 	((acct.side = "П") AND (vSumSaldo > 0)) 
		OR 
    	((acct.side = "А") AND (vSumSaldo < 0))
	THEN DO:	
    
		MESSAGE COLOR WHITE/RED 
      	  "При " (IF iParam EQ 'delete' THEN "удалении" 
      	  ELSE ("изменнении " + (IF iParam EQ 'date' THEN "даты" ELSE (IF iParam EQ 'status'THEN "статуса" ELSE "проводки" ))))
      	        " документа № " op.doc-num SKIP
                " по счету № " acct.acct "~n" 
                " возникает красное cальдо"
               TRIM(STRING(ABS(vSumSaldo),"->>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>9.99"))
              "на" STRING(lastmove,"99.99.9999")
              VIEW-AS ALERT-BOX ERROR
              TITLE "Ошибка документа".
      	RETURN.  
    
    END. 
    
  END.
      
END. 
