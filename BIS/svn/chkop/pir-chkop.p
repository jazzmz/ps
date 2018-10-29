USING Progress.Lang.*.
/* ---------------------------------------------------------------------
File       : $RCSfile: pir-chkop.p,v $ $Revision: 1.69 $ $Date: 2011-02-15 14:45:58 $
Copyright  : ООО КБ "Пpоминвестрасчет"
Function   : Процедура метода chkupd класса op.
           : Выполняет проверку изменяемой проводки на возникновение красного сальдо.	
Created    : 29.05.2007 lavrinenko
Modified   : $Log: not supported by cvs2svn $
Modified   : Revision 1.67  2010/12/28 13:02:08  borisov
Modified   : U Maslova ne rabotaet CVS
Modified   :
Modified   : Revision 1.64  2010/11/13 08:26:05  maslov
Modified   : Izmenen spisok schetov. Ispravlen visov includnikov. Event #505.
Modified   :
Modified   : Revision 1.63  2010/09/13 09:14:52  maslov
Modified   : *** empty log message ***
Modified   :
Modified   : Revision 1.59  2010/07/23 11:06:00  ermilov
Modified   : Remove  checking  for Val control
Modified   :
Modified   : Revision 1.58  2010/04/22 18:06:00  ermilov
Modified   : Return to previos version (1.56)
Modified   :
Modified   : Revision 1.57  2010/03/18 10:33:43  maslov
Modified   : Add changes for Marcheva
Modified   :
Modified   : Revision 1.56  2009/12/07 06:25:26  Buryagin
Modified   : New check for 2281-U. The check #8-2
Modified   :
Modified   : Revision 1.55  2009/11/30 16:02:41  Buryagin
Modified   : Fix the check #5. Excepted from check the op-status "FKS"
Modified   :
Modified   : Revision 1.54  2009/11/30 10:10:04  Buryagin
Modified   : New check #6 (PODFT)
Modified   :
Modified   : Revision 1.53  2009/11/10 06:02:46  ermilov
Modified   : Remove doc-type 06 from Check #14
Modified   :
Modified   : Revision 1.52  2009/11/05 11:50:37  Buryagin
Modified   : Fix the check #2, add status 'V'
Modified   :
Modified   : Revision 1.51  2009/10/30 06:29:17  ermilov
Modified   : Some changes in CARD control
Modified   :
Modified   : Revision 1.50  2009/10/23 10:38:53  Buryagin
Modified   : Fix the check #3. Need for the cash docs, which created in the 'V' status.
Modified   :
Modified   : Revision 1.49  2009/10/22 13:01:19  Buryagin
Modified   : Fix the check #3. vStatus changed to 'тИЪ' as a constant.
Modified   :
Modified   : Revision 1.48  2009/10/22 12:46:02  Buryagin
Modified   : Uncommented the check #3.
Modified   :
Modified   : Revision 1.47  2009/10/13 11:58:54  ermilov
Modified   : Check #10 from  1.40
Modified   :
Modified   : Revision 1.46  2009/10/02 07:15:39  ermilov
Modified   : Changes in CARD control
Modified   :
Modified   : Revision 1.45  2009/10/02 06:46:27  ermilov
Modified   : Added CARD control
Modified   :
Modified   : Revision 1.44  2009/09/30 13:30:56  Buryagin
Modified   : Come back to old version 1.42 from 09.09.2009
Modified   :
Modified   : Revision 1.42  2009/09/09 05:11:11  ermilov
Modified   : *** empty log message ***
Modified   :
Modified   : Revision 1.41  2009/09/09 04:56:02  ermilov
Modified   : Fixing VO control for ben-acct
Modified   :
Modified   : Revision 1.40  2009/08/21 10:26:14  ermilov
Modified   : Reconfigure VO control for suspicius operations
Modified   :
Modified   : Revision 1.39  2009/07/15 13:01:27  Buryagin
Modified   : Fix the check #11.3. Commented AND NOT CAN-DO("1,2,3,4",op.order-pay)
Modified   :
Modified   : Revision 1.38  2009/06/16 12:03:24  Buryagin
Modified   : Added the new check 11.4
Modified   :
Modified   : Revision 1.37  2009/06/08 08:09:46  borisov
Modified   : Proverka 6, test "11:00" - proverka statusa: GE 'V' vmesto 'VV'
Modified   :
Modified   : Revision 1.36  2009/03/18 06:08:12  ermilov
Modified   : Added interface.get ps,strng
Modified   :
Modified   : Revision 1.35  2009/02/11 16:11:53  ermilov
Modified   : some fixes fo VO control #2
Modified   :
Modified   : Revision 1.34  2009/02/10 11:28:57  ermilov
Modified   : Added control of a canceletion a docs with extended attribute "PIRCHECKVO"
Modified   :
Modified   : Revision 1.33  2009/02/09 17:20:47  ermilov
Modified   : TZ from D.Savina: kass operation with VO codes must be controlled by U10-1
Modified   :
Modified   : Revision 1.32  2008/11/21 07:13:15  Buryagin
Modified   : Fixed the Check #11.3
Modified   :
Modified   : Revision 1.31  2008/11/20 19:26:19  ermilov
Modified   : Added forbidden of update/remove docs with VO  control
Modified   :
Modified   : Revision 1.30  2008/11/20 13:41:13  ermilov
Modified   : *** empty log message ***
Modified   :
Modified   : Revision 1.29  2008/11/18 08:17:32  Buryagin
Modified   : Fix the check #6.
Modified   : Logic expression "op.op-status < vStatus" changed with "op.op-status <= vStatus".
Modified   :
Modified   : Revision 1.28  2008/11/07 09:15:27  Buryagin
Modified   : 1. Formatted the all code.
Modified   : 2. Fixed the Check #11.3: controlling only the changing from FBN to FBO of the document status.
Modified   :
Modified   : Revision 1.27  2008/08/18 11:54:41  Buryagin
Modified   : GetLoanLimit_ULL(..., true -> false)
Modified   :
Modified   : Revision 1.26  2008/08/18 11:36:40  Buryagin
Modified   : Fix the control of position of account and commission for pay out. Limit.
Modified   :
Modified   : Revision 1.25  2008/08/13 12:27:53  Buryagin
Modified   : Fix the account position control. Operations created by user PLASTIC is checking now.
Modified   :
Modified   : Revision 1.24  2008/08/11 14:01:17  Buryagin
Modified   : Fix the errors in commission for pays out
Modified   :
Modified   : Revision 1.23  2008/08/08 13:53:57  Buryagin
Modified   : Fix the control of the needed account position for the getting of commission by the client's pay out
Modified   :
Modified   : Revision 1.22  2008/07/08 13:56:43  Buryagin
Modified   : Fix: Exclude the TaxPay from the calculate procedure of total count/amount for the checking of needed position of account for out payments with the commission by the payment.
Modified   :
Modified   : Revision 1.21  2008/06/19 06:54:35  Buryagin
Modified   : Fixed the checking of available position in the client's account for getting rate for out transfer.
Modified   :
Modified   : Revision 1.20  2008/06/04 08:49:58  kuntash
Modified   : dorabotka PODFT
Modified   :
Modified   : Revision 1.19  2008/06/04 06:51:15  Buryagin
Modified   : Fix: in-line call of pir-chksgn.i needs the macros-param "ope".
Modified   :
Modified   : Revision 1.18  2008/06/04 05:41:31  Buryagin
Modified   : Added the code which checking the period of validity for the card of customer's signs.
Modified   :
Modified   : Revision 1.17  2008/05/26 10:37:17  kuntash
Modified   : kontrol komissii
Modified   :
Modified   : Revision 1.16  2008/02/22 13:17:35  kuntash
Modified   : dorabotka 222-p
Modified   :
Modified   : Revision 1.15  2008/01/17 17:20:57  kuntash
Modified   : dorabotka 275 FZ
Modified   :
Modified   : Revision 1.14  2007/12/19 13:09:53  kuntash
Modified   : dorabotka
Modified   :
Modified   : Revision 1.13  2007/12/17 18:46:25  kuntash
Modified   : dorabotka do 35 patcha
Modified   :
Modified   : Revision 1.11  2007/09/25 06:50:56  lavrinenko
Modified   : Доработано определение остатка по счету при переносе документов в другой день.
Modified   :
Modified   : Revision 1.10  2007/09/04 07:30:53  lavrinenko
Modified   : Доработка процедурры контроля красного сальнодо по активным счетам
Modified   :
Modified   : Revision 1.9  2007/08/07 12:53:47  lavrinenko
Modified   : Убрана проверка на редактирование документов с высоким статтусом. Проверка на самоконтроль  дополнера проверкой на сисок исключений
Modified   :
Modified   : Revision 1.8  2007/08/06 07:09:13  lavrinenko
Modified   : Реализованы проверки по просьбе Колосовой: 1. запрет самоконтроля, 2. Запрет редактирования документов с высоким статусом не контролеру
Modified   :
Modified   : Revision 1.7  2007/07/30 11:17:08  lavrinenko
Modified   : Добавлены дополнительные комментарии
Modified   :
Modified   : Revision 1.6  2007/07/24 07:27:27  lavrinenko
Modified   : Реализована проверка размерности назначения платежа в документах отправляемых в МЦИ, Д4, Лобырева
Modified   :
Modified   : Revision 1.5  2007/06/28 12:20:20  lavrinenko
Modified   : Реализованы методы дополнительного контроля документов отправленных в ЬЦИ
Modified   :
Modified   : Revision 1.4  2007/06/21 12:59:49  lavrinenko
Modified   : Доработана обработка удаления докумен
Modified   :
Modified   : Revision 1.3  2007/06/20 11:44:39  lavrinenko
Modified   : Добавлена обработка удаления документ
Modified   : 
Modified   :
Modified   : Revision 1.2  2007/06/13 13:29:29  lavrinenko
Modified   :  Доработка по замечаниям во время экуатации
Modified   : 
Modified   : Revision 1.1  2007/06/07 09:33:21  lavrinenko
Modified   : ╨┐╤А╨╛╤Ж╨╡╨┤╤Г╤А╨░ ╨┐╤А╨╛╨▓╨╡╤А╨║╨╕ ╨╜╨░ ╨║╤А╨░╤Б╨╜╨╛╨╡ ╤Б╨░╨╗╤М╨┤╨╛
Modified   :
---------------------------------------------------------------------- */
{globals.i}
{intrface.get xclass}
{intrface.get acct}
{intrface.get count}

{wordwrap.def}
{tmprecid.def}

{intrface.get bank}
{intrface.get swi}
{intrface.get terr}
{intrface.get instrum}
{intrface.get re}
{intrface.get tmess}
{intrface.get comm}

{intrface.get ps}
{intrface.get strng}

{chkop117.i}
{sh-defs.i}

/** Для контроля комиссии за межбанк используем...*/
{ulib.i}
{pir-chkop-6.def}
{pir-chkop-8-2.def}

&SCOP line-status "ФАА"

DEFINE INPUT PARAMETER iRecOp AS RECID.
DEFINE INPUT PARAMETER iParam AS CHAR.

DEFINE BUFFER b-op-entry FOR op-entry.
DEFINE BUFFER b-acct FOR acct.
DEFINE BUFFER b-op FOR op.

DEFINE VARIABLE vDate        AS DATE    NO-UNDO.
DEFINE VARIABLE vSumSaldo    AS DECIMAL NO-UNDO.
DEFINE VARIABLE vSumOld      AS DECIMAL NO-UNDO.
DEFINE VARIABLE vCom         AS DECIMAL NO-UNDO.
DEFINE VARIABLE vSumFlag     AS LOGICAL NO-UNDO.
DEFINE VARIABLE vStatus      AS CHAR    NO-UNDO.
DEFINE VARIABLE vSelfList    AS CHAR    NO-UNDO.
DEFINE VARIABLE vUserList    AS CHAR    NO-UNDO.
DEFINE VARIABLE vOp-kindList AS CHAR    NO-UNDO.
DEFINE VARIABLE vI           AS INT     NO-UNDO.
/* для 275-ФЗ */
DEFINE VARIABLE vINN           AS CHAR    NO-UNDO.
DEFINE VARIABLE vNamePl        AS CHAR    NO-UNDO.
DEFINE VARIABLE vDetails1       AS CHAR    NO-UNDO.
DEFINE VARIABLE vDetails2       AS CHAR    NO-UNDO.
DEFINE VARIABLE vDetails3      AS CHAR    NO-UNDO.

DEFINE VARIABLE TEMP AS CHAR NO-UNDO.

DEF VAR oAcct AS TAcctBal NO-UNDO.


ASSIGN  
   vStatus       = FGetSetting('ПрИзмДок', '', '√√' )
   vSelfList     = FGetSetting('PIRSelf','',?)
   vUserList     = FGetSetting('PIRUser','',?)
   vOp-kindList  = FGetSetting('Опердень','Befcl',?)
   pick-value    = 'no'
. 

/* message ' Пошел запуск pir-chkop.p iparam = ' iParam VIEW-AS ALERT-BOX ERROR . */

/* Проверка на наличие документа */
FIND FIRST op WHERE RECID(op) = iRecOp NO-LOCK NO-ERROR.
IF NOT AVAIL op THEN DO:
  BELL.
  MESSAGE COLOR MESSAGE "НЕ НАЙДЕНА ЗАПИСЬ <op>"
  VIEW-AS ALERT-BOX ERROR
  TITLE "ОШИБКА".
  RETURN.
END.

/***************************
 * Заявка #683
 * Это необходимо для того,
 * чтобы определять направление
 * изменения статуса.
 ***************************/
DEF VAR direct AS CHARACTER INITIAL ? NO-UNDO.

DEF VAR oPoValid  AS TPOValid  NO-UNDO.
DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR lResult   AS LOG       NO-UNDO.

DEF VAR newDate   AS DATE INIT ? NO-UNDO.
DEF VAR oldDate   AS DATE INIT ? NO-UNDO.

ASSIGN
  newDate = op.op-date
  oldDate = op.op-date
.

DEF BUFFER fOp-entry FOR op-entry.
FIND FIRST fOp-entry OF op NO-LOCK NO-ERROR.

/*** КОНЕЦ #683 ***/

IF AVAILABLE(fOp-entry) THEN DO:
	IF op.op-status>fop-entry.op-status THEN direct="up".
	IF op.op-status<fop-entry.op-status THEN direct="down".

        ASSIGN 
          oldDate = fop-entry.op-date
          newDate = op.op-date
        .

END.



 oPoValid  = new TPOValid(iRecOp).
 oSysClass = NEW TSysClass().

IF (iParam EQ "status") THEN
   DO:
	   /*********************************************
	    *                                    			      *
	    * Указанный здесь код выполняется     *
	    * при смене статуса.                 		      *
            * Событие: onStatusChange                     *
	    * Реагирует на следующие                    *
	    * документы:                                            *
            *  1. Повысить статус документа;           *
	    *  2. Понизить статус документа;           *
	    *  3. Откатить документ;                          *
	    *  4. Аннулировать документ.                 *
	    *                                                                *
	    ********************************************
	    * Автор: Маслов Д. А. (Maslov D. A.)     *
	    * Заявка: #638                                        *
	    * Дата создания: 17.02.11                     *
	    *********************************************/
		{pir-onstatuschange.i}

   END.


	   /**************************************************
	    *
	    * Указанный здесь код выполняется
	    * один раз!
	    * Событие: 
	    * onDocChangeState
	    * Реагирует на следующие действия:
	    *    1. Просмотреть документ;
	    *    2. Редактировать документ;
	    *    3. Изменить статус документа;
	    *    4. Редактировать проводку.
	    *   
            *
	    **************************************************/

IF (iParam EQ "status" AND op.op-status EQ "Ф") OR iParam EQ "" THEN
    DO:
	   {pir-ondocchstate.i} 
    END.

DELETE OBJECT oPOValid  NO-ERROR.   
DELETE OBJECT oSysClass NO-ERROR.

/*  Проверка убрана 23/07/2010 в связи с изменениями в 60ом патче. Теперь она живет в base-pp.p)   
    Ермилов В.Н.: изменение,редактирование документов уже помеченных валютным контролем 
	FOR EACH op-entry OF op NO-LOCK:
	IF ( iParam = ''  )   	
				
				AND    op.op-status EQ op-entry.op-status   
				AND   NOT CAN-DO ('У-10-2,У-2-3',GetXAttrValueEx("_User", USERID('bisquit'),"group-id",?))    
				AND    GetXattrValueEx("op", string(op.op), "PIRcheckVO","") EQ "Да"  
	THEN	DO:
			  MESSAGE COLOR WHITE/RED 
		    		" Документ промаркирован сотрудником валютного контроля !!!" skip
		    		" Изменение основных реквизитов невозможно !!!" skip
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		      			RETURN.  				
		END.
	 ELSE message "!!!!! " iParam .	
END.
Конец  */



/* смена даты/статуса документа/удаление */
IF CAN-DO('date,status,op-entry,delete', iParam ) and NOT CAN-DO(vOp-kindList,op.op-kind) THEN DO:  
   FOR EACH op-entry OF op NO-LOCK:

   vDate         = MAXIMUM (op.op-date,op-entry.op-date).


/**********
  ВРЕМЕННАЯ ЗАГЛУШКА ДЛЯ ПРОВЕРКИ КОРРЕКТНОСТИ ДОХОДНЫХ СЧЕТОВ
 **********/

IF op.op-date >= 01/01/2013 
  AND ( CAN-DO(FGetSetting('PirChkOp','DenyAcct','!*'),op-entry.acct-db) OR CAN-DO(FGetSetting('PirChkOp','DenyAcct','!*'),op-entry.acct-cr)) THEN DO:

   MESSAGE COLOR WHITE/RED 
          "Вы пытаетесь использовать ошибочный доходный/расходный счет."
          VIEW-AS ALERT-BOX TITLE "Ошибка документа".
       RETURN. 

END.


/**********************************************************************
 * Check #1
 **********************************************************************/

/** проверка карточки с образцами подписей */
{pir-chksgn.i &ope=op-entry}







/**********************************************************************
 * Check #2
 **********************************************************************/

/* проверка попыток самоконтроля */		


IF op.user-id EQ USERID('bisquit') AND 
          op.op-status GT op-entry.op-status AND
          MAXIMUM(op.op-status, op-entry.op-status) GE '√' AND   
          NOT CAN-DO(vSelfList,GetXAttrValueEx("_User", USERID('bisquit'),"group-id",?)) THEN DO:
              MESSAGE COLOR WHITE/RED 
                " Вы не имеете права контролировать собственные документы !!!"
                VIEW-AS ALERT-BOX TITLE "Ошибка документа".
          RETURN. 
END.  






/**********************************************************************
 * Check #3
 **********************************************************************/

/* Запрет редактирования документов с высоким стутусом сотруднику не являющемуся контроллером данного документа */

IF op.user-inspector NE "" AND op.user-inspector NE ? AND op.user-inspect NE USERID('bisquit') AND MAXIMUM(op.op-status, op-entry.op-status) GE '√' THEN DO:
				MESSAGE COLOR WHITE/RED 
		    		" Вы не имеете права редактировать проконтролированный документ !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		      			RETURN.  				
END. 
 






/**********************************************************************
 * Check #4
 **********************************************************************/

/* Проверка переноса кассы  в другой месяц*/
/*
IF  CAN-DO('date', iParam ) and (op-entry.acct-db begins "202" or op-entry.acct-cr begins "202") THEN
      DO:
        IF month(today) ne month(op-entry.op-date) and month(op-entry.op-date) ne month(op.op-date) THEN
        DO:
			  MESSAGE COLOR WHITE/RED 
		    		" Документ по кассе расположен в другом месяце !!!" skip
		    		" Возможна 202 отчетность уже сдана !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		      			RETURN.  				
		END.        
END. */ 







/**********************************************************************
 * Check #5
 **********************************************************************/
define variable accts_vo as character init 
"*30111*,*30114*,*30122*,*30123*,*30230*,*30231*,*40803*,*40804*,*40805*,*40806*,*40807*,*40808*,*40809*,*40810*,
*40811*,*40812*,*40813*,*40814*,*40815*,*40818*,*40819*,*40820*,*42501*,*42502*,*42503*,*42504*,
*42505*,*42506*,*42507*,*42607*,*42601*,*42602*,*42603*,*42604*,*42605*,*42606*,*42607*,*42608*,*42609*,*42610*,
*42611*,*42612*,*42613*,*42614*,*42615*,*44001*,*44002*,*44003*,*44004*,*44005*,*44006*,*44007*" no-undo.

define variable accts_vo2 as character init 
"30111*,30114*,30122*,30123*,30230*,30231*,40803*,40804*,40805*,40806*,40807*,40808*,40809*,40810*,
40811*,40812*,40813*,40814*,40815*,40818*,40819*,40820*,42501*,42502*,42503*,42504*,
42505*,42506*,42507*,42607*,42601*,42602*,42603*,42604*,42605*,42606*,42607*,42608*,42609*,42610*,
42611*,42612*,42613*,42614*,42615*,44001*,44002*,44003*,44004*,44005*,44006*,44007*" no-undo.

define variable accts_vo3 as character init "405*,406*,407*,408*,421*,422*,423*,424*,425*,426*" no-undo. /* счета клентов */

/* Проверка валютного контроля */
/* #3541 */ 
if logical (FGetSetting("PirChkOp","Pir3541","YES"))  then do:
	if (op.op-status GT "ФБМ") and 
	(op.op-status NE "ФКА") and 
	can-do("!09,*",op.doc-type)
	and not can-do("05*",op.op-kind) 
        and can-do (accts_vo2 + ",30102*" + accts_vo3, op-entry.acct-cr) /* счета из ТЗ + клиентские счета + корр.счёт*/
	and can-do (accts_vo3, op-entry.acct-db) then do:
		find first acct where acct.acct eq op-entry.acct-db no-lock no-error.
		if available acct and acct.cust-cat eq "Ю" then do:
			if  GetXattrValueEx("op", string(op.op), "PIRcheckVO","") NE "Да" and
			(can-do (accts_vo2, string (op.ben-acct)) or 
			can-do (accts_vo, string (op.name-ben)) or 
			can-do (accts_vo, string (op.details))) then do:
				message color white/red " Документ не проверен валютным контролем! " skip
				" Дальнейшая работа с ним невозможна! "
				view-as alert-box
				title "Ошибка #3541".
				return.
			end.
		end.
	end.
end.




IF  (op.op-status GT "ФБМ") and 
	(op.op-status NE "ФКА") and (
				ChckAcctNecessary(op-entry.acct-db,"Да,Пр") or 
				ChckAcctNecessary(op-entry.acct-cr,"Да,Пр") or 
      				CAN-DO('40807*,40820*,426*,425*,30111*,30231*', TRIM (op.ben-acct))	
				) and 

      			
			 not can-do("05*",op.op-kind)
      			 THEN


      DO:
        
	IF  GetXattrValueEx("op", string(op.op), "PIRcheckVO","") NE "Да" AND
	(  
				/* 1) Vznos-snyatie po kasse */ 
	
		(op-entry.acct-db BEGINS "20202"  and op-entry.acct-cr BEGINS "40807" and substring(op-entry.acct-cr,14,3) NE "050") OR
		(op-entry.acct-db BEGINS "40807"  and op-entry.acct-cr BEGINS "20202" and substring(op-entry.acct-db,14,3) NE "050") 
		
		OR		/* 2) Perevodi rez-nerez  vnutri banka */ 
	
		(						
		 CAN-DO('40807*,40820*,426*,425*', TRIM (op-entry.acct-db)) AND 
		 CAN-DO('401*,402*,403*,404*,405*,406*,407*,40802*,40817*,423*,40807*,40820*,426*,425*', TRIM (op-entry.acct-cr))		
		) 
		OR		
		(						
		 CAN-DO('40807*,40820*,426*,425*', TRIM (op-entry.acct-cr)) AND 
		 CAN-DO('401*,402*,403*,404*,405*,406*,407*,40802*,40817*,423*,40807*,40820*,426*,425*', TRIM (op-entry.acct-db))		
		) 

		OR		/* 3) Vneshnie perevodi rezov */ 

		(							
		 CAN-DO('!.............050....,401*,402*,403*,404*,405*,406*,407*,40802*,40817*,423*', TRIM (op-entry.acct-db)) AND 
		 CAN-DO('30102*,30110*,30109*', TRIM (op-entry.acct-cr)) AND
		 CAN-DO('40807*,40820*,426*,425*,30111*,30231*', TRIM (op.ben-acct))		
		) 


		OR		/* 4) Vneshnie perevodi nerezov */ 

		(						
		 CAN-DO('40807*,40820*,426*,425*', TRIM (op-entry.acct-db)) AND 
		 CAN-DO('30102*,30110*,30109*', TRIM (op-entry.acct-cr))		
		) 
	   )
        THEN
        DO:
			  MESSAGE COLOR WHITE/RED 
		    		" Документ не проверен валютным контролем! " skip
		    		" Дальнейшая работа с ним невозможна! "
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		      			RETURN.  				
		    END.        
END. 


/* Проверка валютного контроля 2: запрет аннулировния документов с проставленным доп реком PIRcheckVO */
IF  ((op.op-status EQ "А") OR (op-entry.op-status EQ "А")) AND  GetXattrValueEx("op", string(op.op), "PIRcheckVO","") EQ "Да" THEN
        DO:
			  MESSAGE COLOR WHITE/RED 
		    		" Документ проконтролирован валютным контролем !!!" skip
		    		" Анулировать его нельзя !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		      			RETURN.  				
END. 


/**********************************************************************
 * Check #6
 **********************************************************************/

/* Проверка ПОДФТ */
{pir-chkop-6.i}




/**********************************************************************
 * Check #7
 **********************************************************************/

/* Проверка проверки отправки Пластика */
IF GetXAttrValueEx("op-entry",STRING(op-entry.op) + "," + STRING(op-entry.op-entry),"CardStatus","") eq "ОТПР" 
        THEN
        DO:
			  MESSAGE COLOR WHITE/RED 
		    		" Документ отправлен в процессинг UCS !!!" skip
		    		" Дальнейшая работа с ним невозможна !!!" skip
		    		" Для решения вопроса можно обратиться в Управление пластиковых карт !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		      			RETURN.  				
		END.
/* конец проверки отправки Пластика */








/**********************************************************************
 * Check #8
 **********************************************************************/

/* Обработка 275-ФЗ c 15.01.2008 */
IF can-do("01*,02,06,016,019",op.doc-type) and op.acct-cat eq "b" and op.op-date GT 01/14/2008 and op.op-date LT 12/07/2009 and not can-do("70*,60*",op-entry.acct-cr) 
			and CAN-DO('date,status', iParam ) and can-do("40*",op-entry.acct-db)
			THEN
		DO:	 

				 vINN = "".
				 vDetails1 = "".
				 vDetails2 = "".
				 vDetails3 = "".
				 
				 
				 
				 FIND FIRST b-acct where b-acct.acct eq op-entry.acct-db /* and not can-do("409*",op-entry.acct-db)*/ no-lock no-error.
				 
				 CASE b-acct.cust-cat:
				      WHEN "Ю"  THEN 
				          DO:
				 	     FIND FIRST cust-corp WHERE cust-corp.cust-id EQ b-acct.cust-id NO-LOCK NO-ERROR.


/*
   Проверяем является ли клиент резидентом.
   Если клиент резидент, тогда проверяем его ИНН.
   Если клиент нерезидент, то на ИНН не смотрим вообще.
   В качестве флага РЕЗИДЕНТ/НЕРЕЗИДЕНТ используем основной реквизит
   country-id.
*/				 	     
				 	     IF cust-corp.country-id EQ "RUS" OR cust-corp.country-id EQ "" THEN
				 	       DO:
				 	          vINN = REPLACE(cust-corp.inn,"0","").
				 	          IF vINN eq "" then vINN = GetXAttrValue('op',STRING(op.op),'inn-send').
				 	          vINN = REPLACE(vINN,"0","").
				 	     
				 	          IF vINN eq "" THEN
				 		     DO:
				 		        MESSAGE COLOR WHITE/RED
				 		        " Ошибка 275-ФЗ !!!" skip
				 		        " У юридического лица отсутствует ИНН (КИО) !!!" skip
				 		        " Нельзя работать с таким типом документа !!!"
				                        VIEW-AS ALERT-BOX 
		                                        TITLE "Ошибка документа".
		      				       RETURN.
				 		     END.
				 	       END. /* КОНЕЦ РЕЗИДЕНТ/НЕРЕЗИДЕНТ */
				    END. /* конец Ю */ 
          WHEN "Ч"  THEN
          DO:
            FIND FIRST person WHERE person.person-id  EQ b-acct.cust-id NO-LOCK NO-ERROR.
            vINN = REPLACE(person.inn,"0","").
            IF vINN eq "" then vINN = GetXAttrValue('op',STRING(op.op),'inn-send').
				 		vINN = REPLACE(vINN,"0","").
				 		IF vINN eq "" THEN
				 		DO:
				 		vNamePl = REPLACE(GetXAttrValue('op',STRING(op.op),'name-send'),"~n"," ").
				 		vNamePl = REPLACE(vNamePl,","," ").
				 		vNamePl = REPLACE(vNamePl,"."," ").
				 		IF NUM-ENTRIES(vNamePl," ") < 5 THEN
				 		DO:
				 		MESSAGE COLOR WHITE/RED
				 				" Ошибка 275-ФЗ !!!" skip
				 				" У физического лица отсутствует ИНН (КИО) !!!" skip
				 				" Необходимо заполнить допреквизит name-send (Наимен. клиента + Адрес проживания) !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		      			RETURN.
				 		END.
				 		END. /* конец vINN */
          END. /* конец Ч */
         END. /* конец CASE */

END. /* конец 275 ФЗ */

{pir-chkop-8-2.i}


/**********************************************************************
 * Check #9
 **********************************************************************/

/* Запрет редактирования чужых документов  
IF ((op.user-inspector NE USERID('bisquit') and op.user-inspector ne "") 
			    or  (op.user-id NE USERID('bisquit') and  NOT CAN-DO(vUserList,op.user-id))
			    )
		     and CAN-DO('date,op-entry', iParam )
		THEN DO:
				MESSAGE COLOR WHITE/RED 
		    		" Вы не имеете права редактировать чужой документ !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		      			RETURN.  				
END. */ /* IF op.user-inspector NE USERID('bisquit') AND op.user-id NE USERID('bisquit') */






/**********************************************************************
 * Check #10
 **********************************************************************/

/* Проверка документов созданных одной транзакцией */
/*	
FIND FIRST b-op where b-op.op-transaction EQ op.op-transaction and  b-op.op NE op.op  no-lock no-error.
	  IF AVAIL b-op and ((CAN-DO('date,op-entry,delete', iParam )) or (CAN-DO('status',iParam) and op.op-status EQ "А")) THEN
DO:
	  	MESSAGE COLOR WHITE/RED 
		  " Документ нельзя редактровать, потому что он имеет связанный документ !!!"
		  VIEW-AS ALERT-BOX 
		  TITLE "Ошибка документа".
		  RETURN.
END.
*/





/**********************************************************************
 * Check #11
 **********************************************************************/

/* обработка документов для МЦИ */
IF op-entry.acct-cr BEGINS "30102" THEN 
      DO:



/**********************************************************************
 * SUB Check #11.1
 **********************************************************************/
/* Проверка на размерность назначения платежа при отправке документов в МЦИ */
	IF LENGTH (op.details) GT 210 THEN 
	DO: 
		MESSAGE " В документе № " op.doc-num SKIP " назначение платежа больше 210 символов" SKIP
            	" отправка в МЦИ невозможна !"
            	VIEW-AS ALERT-BOX WARNING
            	TITLE "Предупреждение".
    END.

/**********************************************************************
 * SUB Check #11.2
 **********************************************************************/
/* обработка документов отправленных в МЦИ */
IF (MINIMUM(op.op-status, op-entry.op-status) EQ 'А' OR CAN-DO('date,delete',iParam)) THEN 
	DO:

/*Кусок по заявке 3458 */
		if can-find (first PackObject where PackObject.file-name eq 'op-entry' and 
			PackObject.Surrogate eq string(op-entry.op) + "," + string(op-entry.op-entry) and
			PackObject.kind eq "RKCReturn") and
			not can-find (first PackObject where PackObject.file-name eq 'op-entry' and 
			PackObject.Surrogate eq string(op-entry.op) + "," + string(op-entry.op-entry) and
			PackObject.kind ne "RKCReturn") and
			can-do (FGetSetting("PirChkOp","Pir3458",""), userid('bisquit')) and 
			can-do (op.user-id, "MCI") and
			(can-do (op.doc-type, "02") or can-do (op.doc-type, "015"))
		then do:
			if op.op-status ne op-entry.op-status then do:
				run Fill-SysMes IN h_tmess ("","",3,"Внимание! #3458\nВы уверены, что хотите аннулировать документ полученный из МЦИ?\n|Да,Нет").
				if pick-value="2" then return.
			end.
		end. 
/*Конец куска по заявке 3458 */
		else do:
/* Далее определяем наличие факта выгрузки и отстутсвие ошибок */	
			FIND FIRST PackObject WHERE 
				PackObject.Surrogate EQ (STRING (op-entry.op) + ',' + STRING(op-entry.op-entry)) AND
				PackObject.File-Name   EQ "op-entry" 
				NO-LOCK NO-ERROR.
			IF AVAIL PackObject THEN 
				FIND FIRST Packet WHERE 
					PackObject.PacketID EQ Packet.PacketID AND
					NOT {assigned Packet.PackError} 
					NO-LOCK NO-ERROR.
				IF AVAIL Packet AND
				NOT CAN-FIND(Packet WHERE 
				PackObject.PacketID EQ Packet.PacketID AND
				{assigned Packet.PackError} ) THEN 
				DO:
					MESSAGE COLOR WHITE/RED 
					" Документ № " op.doc-num " отправлен в МЦИ " SKIP
					" изменения запрещены !!!"
					VIEW-AS ALERT-BOX 
					TITLE "Ошибка документа".
					RETURN.
				END.
		end.
	END. 		 	

/**********************************************************************
 * SUB Check #11.3
 **********************************************************************/
/* проверка на комиссию за РКО (перевод) 
	результаты вычислений данной проверки будут использоваться 
	в проверке 11.4
*/	

def buffer bfrAcct for Acct.
def var temp40821 as char INIT "" NO-UNDO.
IF LOGICAL(FGetSetting("PirChkOp","PirRKOStatus","YES")) THEN DO:

vCom = 0.
IF CAN-DO('status',iParam) THEN 
  DO:			
       if op-entry.acct-db begins "40821" then 
        do:

           oAcct = NEW TAcctBal(op-entry.acct-db).
	     TEMP = oAcct:getAlias40821(op-entry.op-date).
           DELETE OBJECT oAcct.

           FIND FIRST b-acct WHERE b-acct.acct = TEMP NO-LOCK NO-ERROR.

        end.
        else
        do:
  	   FIND FIRST b-acct WHERE b-acct.acct = op-entry.acct-db NO-LOCK NO-ERROR.
        end.

       if op-entry.acct-db BEGINS "40702" then
       do:
           temp40821 = "".
          FIND FIRST bfracct WHERE bfracct.cust-id = b-acct.cust-id 
                               AND bfracct.acct begins "40821*" NO-LOCK NO-ERROR.
          IF AVAILABLE (bfrAcct) then temp40821 = bfracct.acct.

       end.

		IF AVAIL b-acct AND GetXAttrValueEx("acct", b-acct.acct + "," + b-acct.currency,"СКонСальдо",?) EQ "Запрет" 
		          AND MAXIMUM(op.op-status, op-entry.op-status) GE "ФБО"	and b-acct.cust-cat ne "В"   
		          AND NOT CAN-DO("40101810*,40201810*,40402810*",op.ben-acct)
		          /* AND NOT CAN-DO("1,2,3,4",op.order-pay) */
		          AND NOT CAN-DO("016",op.doc-type)
		          AND can-do("30109*,30110*,405*,406*,407*,40802*,40803*,40804*,40805*,40817*,423*",b-acct.acct)
		          THEN 
		DO:
/*		                message b-acct.acct VIEW-AS ALERT-BOX.*/
				RUN acct-pos IN h_base (b-acct.acct, b-acct.currency, vDate, vDate, {&line-status}).
				
				/** Учитываем лимит по счету */
				/** Привязан ли счет к договору лимита? */
				FIND FIRST loan-acct WHERE 
					loan-acct.contract = "Расчет"
					AND
					loan-acct.acct-type = "Расчет"
					AND
					loan-acct.since <= vDate
					AND
					loan-acct.acct = b-acct.acct
					NO-LOCK NO-ERROR.
				IF AVAIL loan-acct THEN DO:
					/** Если счет найден, то учтем лимит по остатку счета, воспользовавшись 
					функцией от ПИРбанка */
					sh-bal = ABS(sh-bal) - ABS(GetLoanLimit_ULL(loan-acct.contract, loan-acct.cont-code, vDate, false)).
				END.
									
				/* комиссия за перевод */
				vI = 0.
				FOR EACH b-op-entry where 
						(b-op-entry.acct-db eq b-acct.acct or
						b-op-entry.acct-db eq op-entry.acct-db or 
						b-op-entry.acct-db eq temp40821) and
						b-op-entry.acct-cr BEGINS "30102" and 
						b-op-entry.op-status >= "ФБН" and 
						b-op-entry.op-date eq vDate 
						NO-LOCK,
					FIRST b-op OF b-op-entry WHERE
					    b-op.op-status >= "ФБО"
					    AND NOT CAN-DO("40101810*,40201810*,40402810*", b-op.ben-acct)
						/* AND NOT CAN-DO("1,2,3,4",b-op.order-pay) */
						AND NOT CAN-DO("016",b-op.doc-type)
		          		AND can-do("30109*,30110*,405*,406*,407*,40802*,40803*,40804*,40805*,40817*,423*,40821*,40807*",b-op-entry.acct-db)
		         :
/*                message b-acct.acct sh-bal VIEW-AS ALERT-BOX.	*/
				 /** Для каждой найденной проводки расчитаем сумму комиссии и прибавим ее к ранее расчитанной */
				 vCom = vCom + GetSumRate_ULL("K01TAR", b-acct.currency, b-op-entry.amt-rub, b-acct.acct, 0, vDate, false).
				 vI = vI + 1.
				END.
        
				Sh-bal = ABS(sh-bal) - (vCom).

				IF Sh-bal < 0 THEN 
				DO:
        MESSAGE COLOR WHITE/RED 
      	  "При " (IF iParam EQ 'delete' THEN "удалении" 
      	  ELSE ("изменении " + (IF iParam EQ 'date' THEN "даты" ELSE (IF iParam EQ 'status'THEN "статуса" ELSE "проводки" ))))
      	        " документа № " op.doc-num SKIP
/*                " по счету № " b-acct.acct "~n" */
                " по счету № " op-entry.acct-db "~n" 
                " не хватает средств для снятия комиссии за перевод "
               TRIM(STRING(ABS(Sh-bal),"->>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>9.99"))
              "на" STRING(lastmove,"99.99.9999")
              VIEW-AS ALERT-BOX ERROR
              TITLE "Ошибка документа".
        RETURN.  
        END. 
    END.    
	END. /* конец провеки комисии на РКО 20 руб */
END.  /* IF op-entry.acct-cr BEGINS "30102" МЦИ */


/**********************************************************************
 * SUB Check #11.4
 **********************************************************************/
/* проверка на комиссию за РКО (изготовление) 
   учитывает сумму vCom из проверки 11.3 */
   	

 IF CAN-DO('status',iParam) THEN 
  	DO:			
/*	  FIND FIRST b-acct WHERE b-acct.acct = op-entry.acct-db NO-LOCK NO-ERROR.*/
       if op-entry.acct-db begins "40821" then 
        do:
           oAcct = NEW TAcctBal(op-entry.acct-db).
                TEMP = oAcct:getAlias40821(op-entry.op-date).
           DELETE OBJECT oAcct.

           FIND FIRST b-acct WHERE b-acct.acct = TEMP NO-LOCK NO-ERROR.

        end.
        else
        do:
 	   FIND FIRST b-acct WHERE b-acct.acct = op-entry.acct-db NO-LOCK NO-ERROR.
        end.


		IF AVAIL b-acct AND GetXAttrValueEx("acct", b-acct.acct + "," + b-acct.currency,"СКонСальдо",?) EQ "Запрет" 
		          AND MAXIMUM(op.op-status, op-entry.op-status) GE "ФБО" and b-acct.cust-cat ne "В"
		          AND CAN-DO("0199", op.op-kind)
		THEN DO:
		
			RUN acct-pos IN h_base (b-acct.acct, b-acct.currency, vDate, vDate, {&line-status}).
	
			/** Учитываем лимит по счету */
			/** Привязан ли счет к договору лимита? */
			FIND FIRST loan-acct WHERE 
					loan-acct.contract = "Расчет"
					AND
					loan-acct.acct-type = "Расчет"
					AND
					loan-acct.since <= vDate
					AND
					loan-acct.acct = b-acct.acct
					NO-LOCK NO-ERROR.

			IF AVAIL loan-acct THEN DO:
					/** Если счет найден, то учтем лимит по остатку счета, воспользовавшись 
					функцией от ПИРбанка */
					sh-bal = ABS(sh-bal) - ABS(GetLoanLimit_ULL(loan-acct.contract, loan-acct.cont-code, vDate, false)).
			END.
			
			vCom = vCom + GetSumRate_ULL("K40911", b-acct.currency, op-entry.amt-rub, b-acct.acct, 0, vDate, false).

			Sh-bal = ABS(sh-bal) - (vCom).

			IF Sh-bal < 0 THEN DO:
		        MESSAGE COLOR WHITE/RED 
      	  			"При " (IF iParam EQ 'delete' THEN "удалении" 
      	  					ELSE ("изменении " + (IF iParam EQ 'date' THEN "даты" ELSE (IF iParam EQ 'status'THEN "статуса" ELSE "проводки" ))))
      	        	" документа № " op.doc-num SKIP
                	" по счету № " b-acct.acct "~n" 
                	" не хватает средств для снятия комиссии за изготовление "
               		TRIM(STRING(ABS(Sh-bal),"->>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>9.99"))
              		"на" STRING(lastmove,"99.99.9999")
              		VIEW-AS ALERT-BOX ERROR
              		TITLE "Ошибка документа".
        		RETURN.  
        	END. 

			
		END.
	END.

END. /* Если проверка включена */

			
/**********************************************************************
 * Check #12
 **********************************************************************/
		 /*********************************
		  * Если пользователь перечислен в
		  * НП, то для него включается новая
		  * проверка на красное сальдо.
		  * !!! ВНИМАНИЕ !!!
		  * Старая при этом отключается.
		  * 05.05.11 9:40
		  **********************************/
IF NOT CAN-DO(FGetSetting("PirChkop","PirRedSaldoV2","!*"),USERID("bisquit")) THEN DO:
/* проверки на красное сальдо */		
IF (MAXIMUM(op.op-status, op-entry.op-status) GE {&line-status} OR 'delete' EQ iParam) THEN 
DO:
	RELEASE history.

	{pir-chkac.i &suff=db &p-m="+" {&*}}
	{pir-chkac.i &suff=cr &p-m="-" {&*}}

	IF 'op-entry' EQ iParam THEN 
	DO:
		FIND LAST history WHERE history.file-name  EQ 'op-entry' AND 
								history.field-ref  EQ STRING(op.op) + ',' + STRING(op-entry.op-entry) AND 
				 				history.modif-date EQ TODAY AND
				 				history.modif-time GE (TIME - 10)
				 				NO-LOCK NO-ERROR. 
		IF AVAIL history THEN 
		DO:
			{pir-chkac.i &suff=db &p-m="+" {&*}}
	 		{pir-chkac.i &suff=cr &p-m="-" {&*}}
		END.
				
	END. 
			
END.

END.


/**********************************************************************
 * Check #13
 **********************************************************************/

/*
/* Обработка документов Клиент - банка на отправку ответов и запросов */
IF op.user-id eq "BNK-CL" and CAN-DO('status', iParam ) THEN
DO:	
		
	/* положителный ответ */		
	IF op-entry.op-status eq "В" and op.op-status > op-entry.op-status THEN 
	DO:
		auto = yes.
        RUN pir_e-tel195.p (op.op,"2557",op-entry.acct-db,substr(op-entry.acct-db,6,3),"196"). 
    END.
    
    
    /* отрицательный запрос при анулировании и в ошибки */
	IF op.op-status eq "В"  or op.op-status eq "А" /* and op-entry.op-status ne "В" */ THEN 
	DO:
		auto = no.
		RUN pir_e-tel195.p (op.op,"2557",op-entry.acct-db,substr(op-entry.acct-db,6,3),"195").
    END.
END. /* конец BNK-CL */

*/
/**********************************************************************
 * Check #14
 **********************************************************************/


/* Проверка контроля документов управлением пластиковых карт */

/*****************************************************
 * Выполнены доработки по					*
 * Добавлено условие, при котором
 * до передачи документов в валютное
 * управление должна стоять виза 
 * управления пластиковых карт.
 *
 * Дата создания: 11:20 16.05.2011
 * Заявка: #698
 * Автор: Маслов Д. А.
 ********************************/

IF LOGICAL(FGetSetting("PirChkOp","PirPlVisaStatus","YES")) THEN DO:

IF  (op.op-status GT "ФБМ") 
    AND CAN-DO('40817....000.050*,40820....000.050*',op-entry.acct-db)  
    AND GetXattrValueEx("op", string(op.op), "PIRcheckCARD","") NE "Да" 
THEN
  DO:

	    /*** ВНЕШНИЙ ДОКУМЕНТ ПЛАСТИКОВ ***/
	     IF CAN-DO("!302*,30*",op-entry.acct-cr) THEN DO:
			  MESSAGE COLOR WHITE/RED 
		    		"ДОКУМЕНТ " + op.doc-num + " на сумму " + STRING(op-entry.amt-rub) " ТРЕБУЕТ ВИЗЫ У-11!" SKIP
				"ЭТО ВНЕШНИЙ ДОКУМЕНТ СО СЧЕТА ПЛАСТИКОВ." SKIP
		    	 	"ДАЛЬНЕЙШАЯ РАБОТА С НИМ НЕВОЗМОЖНА!"
		            VIEW-AS ALERT-BOX TITLE "ОШИБКА #698".
		      			RETURN.  				
		
	     END.
	     ELSE DO:
		/***
		 * 100% из выборки убирют
		 * комиссии, но уточнить критерии
		 * пока не у кого :-(
		 * 13:23 16.05.2011
		 ***/
		IF CAN-DO('01,015,016,016а,02',op.doc-type) THEN DO:
			  MESSAGE COLOR WHITE/RED 
		    		" Документ не проверен Управлением пластиковых карт! " skip
		    		" Дальнейшая работа с ним невозможна! "
		            VIEW-AS ALERT-BOX 
		            TITLE "Ошибка документа".
		      			RETURN.  				
		END. /*  CAN-DO */
	     END. /* ELSE */
    END.        

END.

/**********************************************************************
 * Check #16                                                          *
 **********************************************************************/
/*
 * Вывод сообщения по клиенту (mess)
****************************************************/

DEFINE VARIABLE cAcctDb  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAcctCr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKlAcct  AS CHARACTER INIT "405*,406*,407*,408*,42301*,42601*" NO-UNDO.

IF     (iParam EQ 'op-entry')
   AND NOT CAN-DO(FGetSetting("PIRNoMess", ?, ?), op.op-kind)
THEN DO:

   cAcctDb = op-entry.acct-db.
   cAcctCr = op-entry.acct-cr.

   IF (cAcctDb EQ ?)
   THEN DO:
      FIND FIRST b-op-entry OF op
         WHERE (b-op-entry.acct-cr EQ ?)
         NO-LOCK NO-ERROR.
      IF (AVAIL b-op-entry)
      THEN cAcctDb = b-op-entry.acct-db.
   END.

   IF (cAcctCr EQ ?)
   THEN DO:
      FIND FIRST b-op-entry OF op
         WHERE (b-op-entry.acct-db EQ ?)
         NO-LOCK NO-ERROR.
      IF (AVAIL b-op-entry)
      THEN cAcctCr = b-op-entry.acct-cr.
   END.

   IF     CAN-DO(cKlAcct, cAcctDb)
      AND NOT CAN-DO("70601*", cAcctCr)
   THEN
      RUN KlMess(cAcctDb).

   IF     CAN-DO(cKlAcct, cAcctCr)
      AND CAN-DO("202*", cAcctDb)
   THEN
      RUN KlMess(cAcctCr).
END.

PROCEDURE KlMess:
DEFINE INPUT PARAMETER icAcct AS CHARACTER NO-UNDO.
DEFINE VARIABLE        cMess  AS CHARACTER NO-UNDO.

   FIND FIRST acct
      WHERE (acct.acct EQ icAcct)
      NO-LOCK NO-ERROR.

   IF AVAIL acct
      AND (acct.cust-cat NE "В")
   THEN DO:
      cMess = GetXAttrValue(ENTRY(LOOKUP(acct.cust-cat, "Ю,Ч,Б"), "cust-corp,person,banks"), STRING(acct.cust-id), "mess").
      IF (cMess NE "")
      THEN
         MESSAGE COLOR WHITE
            GetAcctClientName_UAL(icAcct, NO) SKIP
            cMess
            VIEW-AS ALERT-BOX
            TITLE "Сообщение по клиенту".
   END.
END PROCEDURE.

/************************** END CHECK #16 ***************************/
/************************************************************************
* Check #17                                                             *
* Заявка #931. Проверяем, чтобы в переносимом документе не было текста, *
* содержащего дату опер.дня, и если такой имеется, выдаём пользователю  *
* предупреждение.                                                       *
************************************************************************/

IF (iParam EQ "date") THEN DO:
	IF (op.op-date NE op-entry.op-date) THEN DO:
		IF CAN-DO ("*" + STRING(op-entry.op-date,"99/99/9999") + "*,*"  + STRING(op-entry.op-date,"99.99.9999") + "*", STRING(op.details)) THEN DO:
			RUN Fill-SysMes IN h_tmess ("","",3,"Внимание! #931\nВ содержании документа есть дата совпадающая с текущий опер. днем.|Продолжить,Отменить").
			IF pick-value="2" THEN Return.
		END. /* IF CAN-DO */
	END. /* IF (op.op-date) */
END. /* IF iParam */

/************************** END CHECK #17 ***************************/

/***********************************************************************
* Check #18                                                            *
* Заявка #916. Проверяем, не содержит ли перносимый в другой опер.     *
* день документ связей типа PirLnkCom с другим документом. При        *
* наличии таковой, даём пользователю выбрать - перенести все связанные *
* документы или не переносить ничего.                                  *
***********************************************************************/

DEF VAR chD        AS CHAR NO-UNDO INIT "".
DEF VAR pWhat      AS INT  NO-UNDO.
DEF VAR pWHERE     AS DATE NO-UNDO.
DEF VAR lRes       AS LOG  NO-UNDO.
DEF VAR trList     AS CHAR NO-UNDO.
DEF VAR roleList   AS CHAR NO-UNDO.
DEF VAR oSysClass3 AS TSysClass NO-UNDO.
DEF VAR oUser      AS TUser     NO-UNDO.

DEF VAR currDoc AS TDocument NO-UNDO.
DEF VAR lnkDocs AS TAArray   NO-UNDO.


 oUser = new TUser().
     roleList = oUser:getRoleList("05*").
 DELETE OBJECT oUser.

 oSysClass3 = new TSysClass().
    trList = oSysClass3:getCodeValue("PirLnkTrList",roleList,"!*").
 DELETE OBJECT oSysClass3.

IF CAN-DO(trList,op.op-kind) THEN DO:

chD = GetSysConf("pirchkop18-disabled").
IF (iParam EQ "date") AND NOT {assigned chd} THEN DO:
	IF (op.op-date NE op-entry.op-date) THEN DO:
                /**
                 * Маслов Д. А. Maslov D. A.
                 * По заявке #2063
                 * Перевожу на классы.
                 **/
                  currDoc = NEW TDocument(op.op).
                       lnkDocs = currDoc:getLnkDocs().

                       IF lnkDocs:length > 0 THEN DO:

                       RUN Fill-SysMes IN h_tmess ("","",3,"Внимание! #916\nС документом связано " + STRING(lnkDocs:length) + " документов!\n|Перенести все связанные,Отменить").

                       IF pick-value="2" THEN DO:
                   	 RUN DeleteOldDataProtocol IN h_base ("pirchkop18-disabled").
                         DELETE OBJECT currDoc.
                         DELETE OBJECT lnkDocs.
                         RETURN.
                       END.
                     RUN SetSysConf IN h_base ("pirchkop18-disabled","yes").
                     RUN pir-lnk-move.p(lnkDocs:toList(),op.op-date,OUTPUT lRes).

                     IF NOT lRes THEN DO:
 		       RUN DeleteOldDataProtocol IN h_base ("pirchkop18-disabled").
                       DELETE OBJECT currDoc.
	               DELETE OBJECT lnkDocs.
                       RETURN.
                     END.

                  DELETE OBJECT currDoc.
                  DELETE OBJECT lnkDocs.
		RUN DeleteOldDataProtocol IN h_base ("pirchkop18-disabled").
               END. /* lnkDocs:length > 0 */
	END. /* IF (op.op-date) */
END. /* IF iParam */
END. /* Если документ относится к связанным транзакциям */

/************************** END CHECK #18 ***************************/


/* Если производим перенос документа в другой день */
IF iParam = "date" THEN DO:
 {pir-onmovedate.i}
END.



/**********************************************************************
 * Check # NEW NEW NEW NEW NEW NEW NEW
 **********************************************************************/

/**
 * !!!!!!!!!!!!!!!!!!!!!!! 
 * Если нужно добавить проверку, сделайте это выше данного комментария
 */
 
END. /* FOR EACH op-entry OF op */
END. /* IF CAN-DO('date,status,op-entry,delete', iParam ) */





pick-value = "yes". 

{intrface.del}	
RETURN.
