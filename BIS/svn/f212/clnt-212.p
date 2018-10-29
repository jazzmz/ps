{pirsavelog.p}

/*
 КБ ПPОМИНВЕСТРАСЧЕТ

212 - форма.
	    


*/
{globals.i}                  
{getdates.i}

def var symb as char no-undo.
def var fil1 as char no-undo.
def var fil2 as char no-undo.
def var fild as char no-undo.
def var num as integer no-undo.
def var num2 as integer no-undo.

def var numid as integer no-undo.

DEFINE VAR max-cust AS INTEGER   NO-UNDO.
DEFINE VAR num-cust AS INTEGER   NO-UNDO.
DEFINE VAR name-cust   AS CHARACTER NO-UNDO.

DEFINE VAR cAcctMask AS CHARACTER NO-UNDO.			/*Берем и храним маску счетов из настроечного параметра*/

cAcctMask = FGetSetting("PIR212Report","PIR212AcctMask","").

/* 
"40501,40502,40602,40701,40702,40703,40804,40805,40814" 
Описание алгоритма работы можно посмотреть в Eventum номер заявки 64
*/

IF cAcctMask EQ "" THEN
MESSAGE "Укажите счета на основании которых будут отбираться организации. Настроечный параметр PIR212Report." VIEW-AS ALERT-BOX.
 ELSE
   DO:
symb = "-".
num = 0.
num2 = 0.
max-cust = 0.
num-cust = 0.
numid = 0.

{setdest.i &cols=100}

FUNCTION  findMoveInAcct RETURNS LOGICAL(INPUT cAcct AS CHARACTER):
                            /*******************************************
                             * Функция смотрит движение                              *
                             * по счету в корреспонденции                              *
                             * с кассой. Если такое                                            *
                             * движение было, то возвращает                        *
                             * TRUE, иначе FALSE.                                           *
                              * Конечно этому методу не место                         *
                              * в этом классе, но куда унести пока не знаю. *
                             *******************************************/
                             
FIND FIRST op-entry WHERE op-entry.acct-db MATCHES '20202*' AND op-entry.acct-cr=cAcct AND op-date>beg-date AND op-date<end-date NO-LOCK NO-ERROR.

 IF NOT AVAILABLE(op-entry) THEN 
    DO:
     FIND FIRST op-entry WHERE op-entry.acct-db=cAcct AND op-entry.acct-cr MATCHES '20202*' AND op-entry.op-date>beg-date AND op-date<end-date NO-LOCK NO-ERROR.
     IF AVAILABLE(op-entry) THEN RETURN TRUE.
      END.
      ELSE RETURN TRUE.
   RETURN FALSE.      
END FUNCTION.


/*****************************************
 * Считаем клиентов для вывода в
 * индикатор.
 *****************************************/

for each cust-corp no-lock:
  for each acct where acct.cust-cat  = "Ю" and acct.cust-id = cust-corp.cust-id 
      and can-do(cAcctMask,string(acct.bal-acct)) 
      and acct.currency = ""
      and acct.contract ne "Накоп" 
      and (acct.close-date = ? or acct.close-date GE beg-date)
      /* and can-do("рез*",acct.details) */
      no-lock:
       name-cust = "Поиск клиентов:" + STRING(max-cust). 
       {init-bar.i """ + name-cust + ""}
       max-cust = max-cust + 1.
	NEXT.                 
  end.
end.

name-cust = "Обработка клиентов:" + STRING(max-cust).
{init-bar.i """ + name-cust + ""}
max-cust = max-cust * 2.
/*
/**********************************************
 * Отключаю вывод информации             *
 * по обслуживаемым организациям.       *
 * Оставляю только контроллируемые.     *
 * Заявка: #608					     *
 **********************************************/
/* Обработка обслуживаемых клиентов */
put unformatted "               КОЛ-ВО ОБСЛУЖИВАЕМЫХ КЛИЕНТОВ        " skip
                "                           " beg-date " - " end-date skip(2).

put unformatted " " skip "Юридические лица:" skip.
put unformatted " " skip.

put unformatted " №                         КЛИЕНТ                                  СЧЕТ        " skip.
put unformatted "-----  --------------------------------------------------  --------------------" skip.


/**********************************************
 * Маслов Д. А. (Maslov D. A.)
 * Заявка: #608
 * По всем организациям у которых
 * есть счета.
 **********************************************/

FOR EACH cust-role WHERE cust-role.cust-cat EQ "Ю" AND cust-role.Class-Code eq 'ImaginClient' NO-LOCK,
	FIRST cust-corp WHERE cust-corp.cust-id EQ INT64(cust-role.cust-id) NO-LOCK:

     FOR EACH acct WHERE acct.cust-cat  = "Ю" and acct.cust-id = cust-corp.cust-id 
   				      	    AND can-do(cAcctMask,string(acct.bal-acct)) 
				            AND acct.currency = "" 
      				            AND (acct.close-date = ? OR acct.close-date GE end-date)
      				            AND acct.contract ne "Накоп"  AND NOT getXAttrValue("acct",acct.acct + ",","ЦельСЧ") MATCHES "Накоп*" NO-LOCK:
     

	IF cust-corp.cust-id = numid THEN 
		DO:  
		   fil1 = string("","x(7)").
		   IF acct.details eq ? THEN  fil2 = string("","x(52)"). ELSE fil2 = string (acct.details,"x(52)").
		   IF (acct.details begins "накоп") OR  (acct.details begins "рез") THEN NEXT.
		END.    
		ELSE
		  DO:
		       num-cust = num-cust + 1.
		       {move-bar.i num-cust max-cust}
		
                       IF (acct.details eq ?)  or (acct.details eq "") THEN fil2 = string(cust-corp.name-short, "x(52)"). ELSE fil2 = string (acct.details,"x(52)").
		       IF (acct.details begins "накоп") or  (acct.details begins "рез") THEN next.

		        num  = num + 1.
		        fil1 = string(num,">>>>9") + "  ".
                 END.

   PUT UNFORMATTED fil1 fil2 acct.acct space(2) skip.


  END.   /* По всем счетам */

  numid = cust-corp.cust-id.   
END.   /* По всем cust-corp */

put unformatted skip(2).
put unformatted "Всего количество обслуживаемых организаций: "string(num,">>>>9") skip(3).
*/

/*******************************************
 * Конец подсчета обслуживаемых
 *******************************************/

num2 = 0.
/* Обработка контроллируемых клиентов */
put unformatted "                      КОЛ-ВО КОНТРОЛИРУЕМЫХ КЛИЕНТОВ        " skip
                "                           " beg-date " - " end-date skip(2).

put unformatted " " skip "Юридические лица:" skip.
put unformatted " " skip.

put unformatted " №                         КЛИЕНТ                                  СЧЕТ            ДАТА  " skip.
put unformatted "-----  --------------------------------------------------  --------------------  --------" skip.

FOR EACH cust-role WHERE cust-role.cust-cat EQ "Ю" AND cust-role.Class-Code eq 'ImaginClient' NO-LOCK,
	FIRST cust-corp WHERE cust-corp.cust-id EQ INT64(cust-role.cust-id) NO-LOCK,
          EACH acct WHERE acct.cust-cat  = "Ю" and acct.cust-id = cust-corp.cust-id 
					  AND can-do(cAcctMask,string(acct.bal-acct)) 
      					  AND acct.currency = "" 
      					  AND (acct.close-date = ? OR acct.close-date GE beg-date)
      					  AND acct.contract ne "Накоп"
				      NO-LOCK:
   
		/********************************************
		 * Проверяем на наличия движения	 *
		 *  с корреспонденцией по кассе.		 *
		 * Автор: Маслов Д. А. (Maslov D. A.)	 *
		 * Заявка: #608					 *
		 ********************************************/

                 if (acct.details eq ?)  or (acct.details eq "") THEN fil2 = string(cust-corp.name-short, "x(52)"). ELSE fil2 = string (acct.details,"x(52)").

		 IF findMoveInAcct(acct.acct) THEN 
			 DO:
						/***********************************************************************
						 * Если по счету было движение с кассой,					  *
						 * но мы уже проконтролировали эту организацию,			  *
						 * то выводить ее не надо.								  *
						 * Другими словами, выводим, только тех					  *
						 * кто начал работать по кассе и еще не проконтроллирован.    *
						 * Заявка: #608
						 ***********************************************************************/
						IF DATE(getXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"PIRCon212LastDate",FGetSetting("Дата_НР","",""))) <= (beg-date - INTEGER(FGetSetting("PIR212Report","CntRepBegOffset",""))) THEN
							DO: 
							       num2  = num2 + 1.
							       fil1 = string(num2,">>>>9") + "  ".
							      PUT UNFORMATTED fil1 fil2  acct.acct space(2)  fild skip.
							 END.		      
			 END.     

					   num-cust = num-cust + 1.
  END. /* Клиентам */


put unformatted skip(2).
put unformatted "Количество контролируемых организаций: "string(num2,">>>>9") skip.



{preview.i}
END.

                   