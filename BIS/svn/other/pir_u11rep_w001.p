{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pir_u11rep_w001.p
      Comment: Ежедневный отчет для У11
	       Отбираются все незакрытые договоры ПК, у которых от даты 
	       в ДР "Дата заявления на закрытие" прошло 30 дней.
   Parameters: 
       Launch: ПК - ПЕЧАТЬ - ВЫХОДНЫЕ ФОРМЫ 
         Uses:
      Created: Sitov S.A., 29.02.2012
	Basis: ТЗ (от 20.02.2012)
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */




{globals.i}		/** Глобальные определения */
{ulib.i}		/** Библиотека ПИР-функций */
{getdate.i}
{sh-defs.i}
{get-bankname.i}

/* ========================================================================= */
				/** Объявления */
/* ========================================================================= */

DEF VAR iagr  AS INT INIT 0 NO-UNDO.

DEF VAR DateApplication AS DATE NO-UNDO.



/* ========================================================================= */
				/** Реализация */
/* ========================================================================= */


{setdest.i}

PUT UNFORM    SKIP(1).
PUT UNFORM " " + cBankName SKIP(1).
PUT UNFORM FILL(" ",20) "Отчет ДОГОВОРЫ ПК ФЛ НА ЗАКРЫТИЕ на " STRING(end-date,"99/99/9999") "г." SKIP(1).

PUT UNFORM " | "
	STRING("ФИО","X(40)") " | "
	STRING("Номер договора","X(20)") " | "
	STRING("Статус дог.","X(6)") " | "
	STRING("Дата заявл ","X(10)") " | "
SKIP(1).



FOR EACH loan WHERE loan.contract   EQ "card-pers" 
		AND loan.class-code EQ "card-loan-pers"
		AND loan.cust-cat  EQ 'Ч'
		AND NOT( CAN-DO("ЗАКР,√,√√",loan.loan-status) )
NO-LOCK:

	IF AVAIL(loan) THEN
	  DO:
	     
	     DateApplication = DATE(GetXAttrValueEx("loan",loan.contract + "," + loan.cont-code,"appl_date",?) ) .
/*
message "ДатаЗаявления = " DateApplication "; (ДатаЗаявления + 30) = " (DateApplication + 30) "; Дата отчета = " end-date view-as alert-box.
*/
	     IF (DateApplication + 30) <= end-date THEN
		DO:

		iagr = iagr + 1 .
			
		FIND FIRST person WHERE	person.person-id = loan.cust-id
		NO-LOCK NO-ERROR.

		PUT UNFORM " | "
			STRING(person.name-last + " " + person.first-names,"X(40)") " | "
			STRING(loan.cont-code,"X(20)") " | "
			STRING(REPLACE(loan.loan-status,"√","V"),"X(6)") " | "
			STRING(DateApplication,"99/99/9999") " | "
		SKIP.

		END.

	  END. /* end_IF AVAIL(loan) */

END.


PUT UNFORM SKIP(1).
PUT UNFORM " Итого договоров: " iagr SKIP.

FIND FIRST _user WHERE _user._userid = LC(userid("bisquit")) NO-LOCK NO-ERROR.

PUT UNFORM " Время запуска: " STRING(TODAY,"99/99/9999") "г. " STRING(TIME,"HH:MM:SS")  SKIP.
PUT UNFORM " Исполнитель: " _user._user-name SKIP.


{preview.i}