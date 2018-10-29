/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pirexpu5soglpodft.p
      Comment: Экспорт данных в формате afx для МАСТЕРА ДОГОВОРОВ 
		по договору ЮЛ,ИП (кредитному, депозитному)
   Parameters: Полное имя файла экспорта
         Uses:
      Created: Ситов С.А., 28.03.2013
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */


{globals.i}		/** Глобальные определения */
{tmprecid.def}		/** Подключение возможности использовать информацию броузера */
{intrface.get strng}
{ulib.i}		/** Библиотека ПИР-функций */
{pir_expmaster.fun}     /** Библиотека функций для Мастера */


/* ========================================================================= */
				/** Объявления */
/* ========================================================================= */

  /* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR.

DEF VAR out_file_name AS CHAR. 
DEF VAR dogtype AS CHAR. 
DEF VAR name          AS CHAR. 
DEF VAR nameshort     AS CHAR. 
DEF VAR predstfioip   AS CHAR. 
DEF VAR predstpostip  AS CHAR. 


/* ========================================================================= */
				/** Реализация */
/* ========================================================================= */


IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/ssitov/tmp/new_data.afx".


OUTPUT TO VALUE(out_file_name).


FOR FIRST tmprecid 
NO-LOCK,
FIRST loan 
  WHERE RECID(loan) EQ tmprecid.id 
NO-LOCK,
FIRST loan-cond 
  WHERE loan-cond.contract = loan.contract 
  AND  loan-cond.cont-code = loan.cont-code 
NO-LOCK : 


	/** Открывающий тэг */	
	RUN Master_OutStr("<data>").


		/** КЛИЕНТ */
	IF loan.cust-cat = "Ю" THEN
	DO:
	  FIND FIRST cust-corp WHERE cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
	  IF AVAIL cust-corp THEN
	  DO:
		IF cust-corp.cust-stat = "ИП" THEN
		DO:
		  name = "Индивидуальный предприниматель " + cust-corp.name-corp .
		  nameshort = "ИП " + cust-corp.name-corp .
		  predstfioip  = cust-corp.name-corp .
		  predstpostip = "" .
		END.
		ELSE
		DO:
		  name = GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"FullName","") .
		  nameshort = cust-corp.name-short .
		  predstfioip  = REPLACE(GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"ФИОрук",""),";","")   .
		  predstpostip = LC(GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"ДолРук","")) .
		END.

		RUN Master_OutStr("<client>").
		RUN Master_OutStr("name=" 		+  name ).
		RUN Master_OutStr("nameshort=" 		+  nameshort ).
		RUN Master_OutStr("addrur=" 		+  Master_GetClntAddr(cust-corp.cust-id,"Ю","АдрЮр") ).
		RUN Master_OutStr("addrfakt=" 		+  Master_GetClntAddr(cust-corp.cust-id,"Ю","АдрФакт") ).
		RUN Master_OutStr("inn=" 		+  cust-corp.inn ).
		RUN Master_OutStr("ogrn=" 		+  GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"ОГРН","") ).
		RUN Master_OutStr("predstfio=" 		+  predstfioip  ).
		RUN Master_OutStr("predstfioip="	+  predstfioip  ).
		RUN Master_OutStr("predstpost="		+  predstpostip ).
		RUN Master_OutStr("predstpostip="	+  predstpostip ).
		RUN Master_OutStr("predstdoc=" 		+  "Устава").
		RUN Master_OutStr("</client>").
	  END.
	END.
	ELSE
	DO:
	  MESSAGE "Счет не принадлежит юридическому лицу / индивидуальному предпринимателю!" VIEW-AS ALERT-BOX.
	  RETURN.
	END.


		/** СОГЛАШЕНИЕ и договор, на основании которого оно возникло */
	IF CAN-DO("loan_allocat,loan-transh,loan-tran-lin",loan.class-code) THEN
	  dogtype = "кредитного договора" . .
	IF CAN-DO("loan_attract",loan.class-code) THEN
	  dogtype = "депозитного договора" .


	RUN Master_OutStr("<agreement>").
	RUN Master_OutStr("number="		+  "" ). /* заполняется в форме мастера */
	RUN Master_OutStr("date="		+  "" ). /* заполняется в форме мастера */
	RUN Master_OutStr("dognumber="		+  loan.cont-code ).
	RUN Master_OutStr("dogdate="		+  STRING(loan.open-date, "99/99/9999") ).
	RUN Master_OutStr("dogcurrency="	+  (if loan.currency = "" then "810" else loan.currency) ).
	RUN Master_OutStr("dogtype="		+  dogtype ).
	RUN Master_OutStr("</agreement>").


		/** ПОЛЬЗОВАТЕЛЬ */					
	RUN Master_OutStrUser(userid("bisquit")).

		/** ПРОЦЕДУРА ВЫГРУЗКИ */					
	RUN Master_OutStr("<expproc>").
	RUN Master_OutStr("procname=" + "pirexpu5soglpodft.p" ).
	RUN Master_OutStr("</expproc>").


	RUN Master_OutStr("</data>").

END. /* конец цикла */

OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
