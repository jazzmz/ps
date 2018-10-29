{pirsavelog.p}
/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2012
     Filename: pir-prolacctname.p
      Comment: pir-prolacctname.p - проверочный отчет с функцией переименования счетов (из этого отчета)
	       АЛГОРИТМ: 

		Взависимости от параметра два режима:
		   1 - отчет по выбранному КД и функционал по переименованию счета
		   2 - только отчет по всем договорам-пролонгациям

		По таблице пролонгаций (pro-obl) отбираем все договоры (или один выбранный договор),
		пролонгированные на заданную дату. Определяем номер договора 
		и последний привязанный ссудный счет (с учетом даты запуска) 
		Если дата привяки счета меньше даты пролонгации, то значит
		пролонгировали на том же счете,т.е. proltype = 1
		Иначе - была пролонгация с новым счетом, т.е. proltype = 2
		В обоих случаях проводим корректировку наименования счета.

		Кроме того, производится:
		  а) ПОКА ОТКЛЮЧЕНО ! проверка на корректность ДР ВидРеструкт, КолРеструкт 
			при пролонгации договора для формы отчетности 
		  б) ...

		В режиме 1: Пользователю выдаются два отчета по пролонгированным 
		договорам с указанием ошибок.
		ПЕРЕИМЕНОВАНИЕ СЧЕТОВ производится по команде пользователя !!!

   Parameters: 
       Launch:  КД - ПЕЧАТЬ - (ПИР) КИД КОНТРОЛЬ - Ведомость КД при пролонгации. Наименования счетов 
		КД - АКТИВЫ - Выбрали договор, отметили. Ctrl+G - ПРОВЕРОЧНЫЕ ВЕДОМОСТИ - Пролонгация КД. Смена наименования счета
         Uses:
      Created: Sitov S.A., 03.09.2012
	Basis: #1171
     Modified: 
*/
/* ========================================================================= */


{globals.i}
{ulib.i}		/** Библиотека собственных функций ПИР */
{getdate.i}
{pir-prolacctname.i}
{tmprecid.def}


/***** ================================================================= *****/
/*** 	          ВХОДНЫЕ ПАРАМЕТРЫ, ПЕРЕМЕННЫЕ И ПР.                      ***/
/***** ================================================================= *****/

DEF INPUT PARAMETER vCode as CHAR.


DEF VAR OpDay    AS DATE NO-UNDO.
DEF VAR newdetls AS CHAR NO-UNDO.
DEF VAR proltype AS INT  NO-UNDO.
DEF VAR chkloan  AS CHAR NO-UNDO.
DEF VAR FlagErr  AS LOGICAL INIT NO NO-UNDO.  /* no - нет ошибок */
DEF VAR FlagDog  AS LOGICAL INIT NO NO-UNDO.  /* no - нет пролонгированных договоров */
DEF VAR iContCode AS CHAR NO-UNDO.


  /*** Временная таблица для отобранных счетов ***/
DEF TEMP-TABLE repacct NO-UNDO
	FIELD acct     AS CHAR
	FIELD loannum  AS CHAR 	
	FIELD loanprd  AS DATE
	FIELD olddetls AS CHAR
	FIELD newdetls AS CHAR
	FIELD proltype AS INT
	FIELD errname  AS CHAR
	INDEX acct acct
.

   /*** РИСОВАЛКИ  ****/ 
DEF VAR oTpl1       AS TTpl      NO-UNDO.
DEF VAR oTableDoc1  AS TTableCSV NO-UNDO.
DEF VAR oTpl2       AS TTpl      NO-UNDO.
DEF VAR oTableDoc2  AS TTableCSV NO-UNDO.

oTpl1 = new TTpl("pir-prolacctname1.tpl").
oTableDoc1 = new TTableCSV(6).
oTpl2 = new TTpl("pir-prolacctname2.tpl").
oTableDoc2 = new TTableCSV(6).



/***** ================================================================= *****/
/*** 	   ЗАПУСК С ПАРАМЕТРОМ    1  -  Отчет по выбранному КД и           ***/
/***				     функционал по переименованию счета    ***/
/***** ================================================================= *****/

IF vcode = "1" THEN 
  DO:

    FOR FIRST tmprecid ,
    FIRST loan
       WHERE tmprecid.id = recid(loan)
    NO-LOCK :
  
	iContCode = loan.cont-code .
  
	IF NOT AVAIL(loan) THEN 
	  DO:
            MESSAGE "НЕ НАЙДЕН ДОГОВОР !!!" VIEW-AS ALERT-BOX.
            RETURN. 
	  END.
	ELSE
            MESSAGE "Выбранный договор : " iContCode  VIEW-AS ALERT-BOX.
    
    END. 

  END. /* end_IF vcode = "1" */
  

/***** ================================================================= *****/
/*** 	   ЗАПУСК С ПАРАМЕТРОМ  2 - отчет по всем договорам-пролонгациям   ***/
/***** ================================================================= *****/

IF vcode = "2" THEN 
    iContCode = "*" .


IF NOT( vcode = "1" OR vcode = "2" ) THEN 
   DO:
     MESSAGE "НЕВЕРНО ЗАДАН ПАРАМЕТР ПРОЦЕДУРЫ !!!" VIEW-AS ALERT-BOX.
     RETURN.
   END.



/***** ================================================================= *****/
/*** 	                    РЕАЛИЗАЦИЯ                                     ***/
/***** ================================================================= *****/

OpDay = end-date .

FOR EACH pro-obl
    WHERE pro-obl.contract = "Кредит"
    AND pro-obl.pr-date   =  OpDay
    AND CAN-DO(iContCode,pro-obl.cont-code)
NO-LOCK:


newdetls = "" . 
chkloan  = "" .
FlagDog  = yes .

    /* Находим последний привязанный ссудный счет (с учетом даты запуска) */
  FIND LAST loan-acct
	WHERE loan-acct.contract = pro-obl.contract
	AND  loan-acct.cont-code = pro-obl.cont-code
	AND  loan-acct.acct-type = "Кредит"
	AND  loan-acct.since <= OpDay
  NO-LOCK NO-ERROR.

  FIND FIRST acct WHERE acct.acct = loan-acct.acct  NO-LOCK NO-ERROR.

   /*
     Если дата привяки счета меньше даты пролонгации, то
      считаем, что пролонгировали на том же счете,т.е. proltype = 1
      Иначе - должна быть пролонгация с новым счетом, т.е. proltype = 2
      В обоих случаях нужна корректировка Наименования счета.
   */

  IF loan-acct.since < pro-obl.pr-date THEN
	proltype = 1 .
  ELSE
 	proltype = 2 .


    /*** Определяем новое название счета */
  newdetls = PirNewNameLoanAcct(loan-acct.cont-code, loan-acct.acct, OpDay) . 

    /*** Проверка на корректность ДР договора для формы отчетности */
  /* Пока проверка не внедрена. жду решения */
  /*chkloan = PirChkLoanDR(loan-acct.cont-code, pro-obl.nn) .*/
  chkloan = "" . 


  CREATE repacct.
  ASSIGN
	repacct.acct     = acct.acct
	repacct.loannum  = pro-obl.cont-code
	repacct.loanprd  = pro-obl.pr-date
	repacct.olddetls = acct.details
	repacct.newdetls = newdetls
	repacct.proltype = proltype
	repacct.errname  = PirErrCodeName(newdetls,chkloan)
  .


END.



	/********* ВЫВОД В ТАБЛИЦЫ  ***********/

   /*** Пролонгация со старым ссудным счетом КД */
FOR EACH repacct 
   WHERE repacct.proltype = 1
:
	oTableDoc1:addRow().
	oTableDoc1:addCell(repacct.loannum).
	oTableDoc1:addCell(STRING(repacct.loanprd,"99/99/99") ).
	oTableDoc1:addCell(repacct.acct).
	oTableDoc1:addCell(repacct.olddetls).
	oTableDoc1:addCell(repacct.newdetls).
	oTableDoc1:addCell(repacct.errname ).

	IF repacct.errname <> "" THEN
	  FlagErr = yes .

END.

   /*** Пролонгация с новым ссудным счетом КД */
FOR EACH repacct 
   WHERE repacct.proltype = 2
:
	oTableDoc2:addRow().
	oTableDoc2:addCell(repacct.loannum).
	oTableDoc2:addCell(STRING(repacct.loanprd,"99/99/99") ).
	oTableDoc2:addCell(repacct.acct).
	oTableDoc2:addCell(repacct.olddetls).
	oTableDoc2:addCell(repacct.newdetls).
	oTableDoc2:addCell(repacct.errname ).

	IF repacct.errname <> "" THEN
	  FlagErr = yes .

END.


oTpl1:addAnchorValue("OpDate",OpDay).
IF oTableDoc1:HEIGHT <> 0 THEN  oTpl1:addAnchorValue("TABLEDOC",oTableDoc1). ELSE oTpl1:addAnchorValue("TABLEDOC","*** НЕТ ДАННЫХ ***").

oTpl2:addAnchorValue("OpDate",OpDay).
IF oTableDoc2:HEIGHT <> 0 THEN  oTpl2:addAnchorValue("TABLEDOC",oTableDoc2). ELSE oTpl2:addAnchorValue("TABLEDOC","*** НЕТ ДАННЫХ ***").


{setdest.i}
oTpl1:show().
PAGE.
oTpl2:show().
{preview.i}


DELETE OBJECT oTableDoc1.
DELETE OBJECT oTpl1.
DELETE OBJECT oTableDoc2.
DELETE OBJECT oTpl2.




/***** ================================================================= *****/
/*** 	          СМЕНА НАИМЕНОВАНИЯ СЧЕТА                                 ***/
/***** ================================================================= *****/

IF vcode = "1" AND FlagDog THEN
DO:
   MESSAGE "Произвести смену наименования ?" 
	VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mChange AS LOG.

   IF mChange NE ? THEN 
   DO:
       IF mChange THEN
       DO:

           IF FlagErr THEN
             MESSAGE "Были обнаружены ошибки. Всё равно поизвести смену наименования ?" 
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mChange2 AS LOG.

           IF ( FlagErr = YES AND mChange2 = YES) 
		OR
	      ( FlagErr = NO )	
	   THEN
           DO:
  		/********* СМЕНА НАИМЕНОВАНИЯ СЧЕТА ***********/

		FOR EACH repacct BY repacct.proltype 
		:

		FIND FIRST acct WHERE acct.acct EQ repacct.acct EXCLUSIVE-LOCK .

		IF AVAIL acct THEN
			acct.details = repacct.newdetls .

	        END.  /* end_for_each */ 

	     MESSAGE " Смена наименования произошла!" VIEW-AS ALERT-BOX.
          END.  /* end_IF mChange2 = YES */
          ELSE
	     MESSAGE " 2 Смена наименования не произошла!" VIEW-AS ALERT-BOX.

     END.  /*  end_IF mChange = YES */
     ELSE
         MESSAGE " Смена наименования не произошла!" VIEW-AS ALERT-BOX.

   END. /* end_ IF mChange NE ? */

END. /* end_if vcode = "1" */ 
