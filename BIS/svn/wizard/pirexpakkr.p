{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pirexpakkr.pp
      Comment: Экспорт данных в формате afx для МАСТЕРА ДОГОВОРОВ 
		по аккредитиву
   Parameters: Первый параметр - тип операции,
		Второй параметр - полное имя файла экспорта
         Uses:
       Launch: БМ ->  Оп.день -> Отметить документ открытия/раскрытия аккредитива, CTRL+G  
		-> ПИР: ЭКСПОРТ ДАННЫХ В МАСТЕР  -> ПИР: Эксп.данных Открытие аккредитива (либо ПИР: Эксп.данных Раскрытие аккредитива)
      Created: Sitov S.A., 02.08.2012
	Basis: #1184
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */




{globals.i}		/** Глобальные определения */
{tmprecid.def}		/** Подключение возможности использовать информацию броузера */
{pir_expmaster.fun}     /** Библиотека функций для Мастера */
{intrface.get strng}

/* ========================================================================= */
				/** Объявления */
/* ========================================================================= */

  /* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR NO-UNDO.

  /* Первый параметр */
DEF VAR out_file_name AS CHAR NO-UNDO. 

DEF VAR d_type AS CHAR NO-UNDO. /* 1 - открытие, 2 -раскрытие , 0 - ошибка*/

DEF VAR b_name AS CHAR NO-UNDO.
DEF VAR b_inn  AS CHAR NO-UNDO.
DEF VAR b_acct AS CHAR NO-UNDO.
DEF VAR s_name AS CHAR NO-UNDO.
DEF VAR s_inn  AS CHAR NO-UNDO.
DEF VAR s_acct AS CHAR NO-UNDO.

DEF VAR a_num  AS CHAR NO-UNDO.
DEF VAR a_opdt AS CHAR NO-UNDO.
DEF VAR a_endt AS CHAR NO-UNDO.
DEF VAR a_amnt AS DEC  NO-UNDO.
DEF VAR a_cur  AS CHAR NO-UNDO.


DEF VAR usershortname AS CHAR NO-UNDO.

def var a as char no-undo.

/* ========================================================================= */
				/** Реализация */
/* ========================================================================= */


IF NUM-ENTRIES(iParam,";") > 1 THEN	
    DO:
	out_file_name = ENTRY(2,iParam,";").
	d_type = ENTRY(1,iParam,";").
    END.
ELSE
    DO:
	out_file_name = "/home2/bis/quit41d/work/ssitov/tmp/new_data.afx".
	d_type = "0".
    END.


  /** Задаем вывод в файл */		
OUTPUT TO VALUE(out_file_name).


FOR FIRST tmprecid 
NO-LOCK,
FIRST op WHERE 
RECID(op) EQ tmprecid.id 
NO-LOCK:


		/** НАЧАЛО */	
	RUN Master_OutStr("<data>").


	FIND FIRST op-entry OF op NO-LOCK NO-ERROR.

	  /* Определяем тип операции, по которой выгружают данные */ 
	CASE d_type :
            WHEN "1"  THEN DO:	/* открытие аккредитива */
		b_acct = op-entry.acct-db .
		s_acct = op-entry.acct-cr .
		a_opdt = STRING(op.op-date,"99.99.9999") .
		a_endt = "".
            END.
	    WHEN "2" THEN DO:   /* раскрытие аккредитива */
		b_acct = op-entry.acct-cr .
        	s_acct = op-entry.acct-db .
		a_endt = STRING(op.op-date,"99/99/9999") .

		IF op.details MATCHES "*../../20..*"  THEN
		  DO:
		    a_opdt  = TRIM(SUBSTRING(op.details,INDEX(op.details,"/") - 2,10)) .
		  END.
		ELSE 
		  MESSAGE "Неверно заполнена ДАТА АККРЕДИТИВА ! Верный формат: ДД/ММ/ГГГГ " VIEW-AS ALERT-BOX.

	    END.
	    OTHERWISE DO:
        	MESSAGE "Неизвестный параметр запуска! Обратитесь к админисратору!" VIEW-AS ALERT-BOX.
		RETURN.
	    END.
	END CASE.

	IF NOT(s_acct BEGINS "40901") THEN 
		MESSAGE "ПРЕДУПРЕЖДЕНИЕ! Вероятно, выбрана не та процедура экспорта или не тот документ! Проверьте!" VIEW-AS ALERT-BOX.



		/***	 ПОКУПАТЕЛЬ	 ***/

	FIND FIRST acct WHERE acct.acct = b_acct NO-LOCK NO-ERROR.

	IF acct.cust-cat = "Ч" THEN
	  DO:
		FIND FIRST person WHERE person.person-id = acct.cust-id NO-LOCK NO-ERROR.
		b_name = person.name-last + " " + person.first-names .
		b_inn  = person.inn .
	  END.
	IF acct.cust-cat = "Ю" THEN
	  DO:
		FIND FIRST cust-corp WHERE cust-corp.cust-id = acct.cust-id NO-LOCK NO-ERROR.
		b_name = GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"FullName","") .
		b_inn  = cust-corp.inn .
	  END.

	RUN Master_OutStr("<buyer>").
	RUN Master_OutStr("name=" + b_name ).
	RUN Master_OutStr("inn="  + b_inn  ).
	RUN Master_OutStr("acct=" + b_acct ).
	RUN Master_OutStr("</buyer>").



		/***	 ПРОДАВЕЦ	 ***/

	FIND FIRST acct WHERE acct.acct = s_acct NO-LOCK NO-ERROR.

	IF acct.cust-cat = "Ч" THEN
	  DO:
		FIND FIRST person WHERE person.person-id = acct.cust-id NO-LOCK NO-ERROR.
		s_name = person.name-last + " " + person.first-names .
		s_inn  = person.inn .
	  END.
	IF acct.cust-cat = "Ю" THEN
	  DO:
		FIND FIRST cust-corp WHERE cust-corp.cust-id = acct.cust-id NO-LOCK NO-ERROR.
		s_name = GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"FullName","") .
		s_inn  = cust-corp.inn .
	  END.

	RUN Master_OutStr("<seller>").
	RUN Master_OutStr("name=" + s_name ).
	RUN Master_OutStr("inn="  + s_inn  ).
	RUN Master_OutStr("acct=" + s_acct ).
	RUN Master_OutStr("acctname=" + acct.details ).
	RUN Master_OutStr("rsacct=" + "" ).
	RUN Master_OutStr("</seller>").



		/***	 АККРЕДИТИВ	 ***/

	  /* Определяем номер и дату аккредитива */
	IF op.details MATCHES "*N*"  THEN
	  DO:
		a_num  = TRIM(SUBSTRING(op.details,INDEX(op.details,"N") + 1,INDEX(op.details," от") - INDEX(op.details,"N"))) .
		MESSAGE "Номер аккредитива: " a_num "  Дата открытия: " a_opdt VIEW-AS ALERT-BOX.
	  END.
	ELSE 
	  MESSAGE "Неверно заполнен НОМЕР АККРЕДИТИВА !" VIEW-AS ALERT-BOX.

	IF op-entry.currency = "" THEN
	  DO:
		a_amnt = op-entry.amt-rub .
		a_cur  = "810" .
	  END.
	ELSE 
	  DO:
		a_amnt = op-entry.amt-cur .
		a_cur  = op-entry.currency .
	  END. 


	RUN Master_OutStr("<akkreditiv>").
	RUN Master_OutStr("num="	+ a_num	 ).
	RUN Master_OutStr("opendate="	+ a_opdt ).
	RUN Master_OutStr("enddate="	+ a_endt ).
	RUN Master_OutStr("amnt="	+ STRING(a_amnt) ).
	RUN Master_OutStr("cur="	+ a_cur  ).
	RUN Master_OutStr("gr1_num="	+ ""  ).
	RUN Master_OutStr("gr1_opdate="	+ ""  ).
	RUN Master_OutStr("gr1_addr="	+ ""  ).
	RUN Master_OutStr("gr2_datareg=" + "" ).
	RUN Master_OutStr("gr3_predv="	+ ""  ).
	RUN Master_OutStr("gr3_botkr="	+ STRING(GetKom("АккредОткр",op-entry.currency,op.op-date,a_amnt)) ).
	RUN Master_OutStr("gr3_buved="	+ STRING(GetKom("АккредИзв" ,op-entry.currency,op.op-date,a_amnt)) ).
	RUN Master_OutStr("gr3_spay="	+ STRING(GetKom("АккредПлат",op-entry.currency,op.op-date,a_amnt)) ).
	RUN Master_OutStr("gr3_sprov="	+ STRING(GetKom("АккредПров",op-entry.currency,op.op-date,a_amnt)) ).
	RUN Master_OutStr("</akkreditiv>").




		/** ПОЛЬЗОВАТЕЛЬ */					

	RUN Master_OutStr("<user>").

	FIND FIRST _user WHERE _user._userid = LC(userid("bisquit")) NO-LOCK NO-ERROR.
	RUN Master_OutStr("username=" + _user._user-name).

	usershortname = GetEntries(1,_user._user-name," ","") + " " +
			SUBSTRING(GetEntries(2,_user._user-name," ",""),1,1) + "." +
			SUBSTRING(GetEntries(3,_user._user-name," ",""),1,1) + "." .
	RUN Master_OutStr("usershortname=" + usershortname ).

	RUN Master_OutStr("userpost=" + GetXAttrValueEx("_user", _user._userid, "Должность", "") ).
	RUN Master_OutStr("</user>").


		/** ПРОЦЕДУРА ВЫГРУЗКИ */					

	RUN Master_OutStr("<expproc>").
	RUN Master_OutStr("procname=" + "pirexpakkr.p" ).
	RUN Master_OutStr("</expproc>").


	/** КОНЕЦ */					
	RUN Master_OutStr("</data>").

END.


OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.


