/****************************************************************************************************************************************************************************************
 *																	  *
 *  Отчет на указанную дату, по счетам резервов созданным согласно 254-П.									  *
 *  Автор: Маслов Д. А.															  *
 *  Дата создания: 12.09.2008														  *
 *  Описание: Находится в файле det-pir-res254.p												  *
 *																	  *
 *  Много лишних преобразований из стринг в децимал и обратно.  Вариант черновой необходимо доработать функции создания отчета			  *						
 *																	  *
 *****************************************************************************************************************************************************************************************/

{globals.i}
{wordwrap.def}
{sh-defs.i}
{setdest.i & cols=50}
{tmprecid.def}        /** Используем информацию из броузера */

/********************************  Объявляем глобальную переменную для подсчета строк ****************************/
DEFINE VARIABLE iCountStr AS INTEGER INITIAL 0  NO-UNDO.

/************************************************************* Служебные процедуры  ******************************************************************/

PROCEDURE putHeader2Report:
PUT UNFORMATTED
		"                   ОТЧЕТ ПО РЕЗЕРВАМ, СОЗДАННЫМ СОГЛАСНО 283-П.  На   "  gend-date " ." SKIP.

PUT UNFORMATTED 
"|--------------------------------------------------------------------------------------------------------------|" SKIP
"|  №  | Номер договора |    Номер счета     | Сумма остатка |  Номер счета       | Сумма остатка | Дата открытия |" SKIP
"|--------------------------------------------------------------------------------------------------------------|" SKIP.

END.

PROCEDURE put2Report:
  DEFINE INPUT PARAMETER element1 AS CHARACTER.
  DEFINE INPUT PARAMETER element2 AS CHARACTER.
  DEFINE INPUT PARAMETER element3 AS CHARACTER.
  DEFINE INPUT PARAMETER element4 AS CHARACTER.
  DEFINE INPUT PARAMETER element5 AS CHARACTER.
  DEFINE INPUT PARAMETER element6 AS CHARACTER.

   iCountStr = iCountStr + 1.


           /*************************************************************
            *						    *
            *						    *
            * Формирует строки для отчеты		    *
            *						    *
            *************************************************************/

       PUT UNFORMATTED 
		"|"  STRING(iCountStr)  FORMAT "X(5)" "|" element6 FORMAT "X(16)" "|" element1 FORMAT "X(20)" "| " element2 FORMAT "X(14)" "|" element3 FORMAT "X(20)" "|" element4 FORMAT "X(15)"  "|" element5 FORMAT "X(15)" "|" SKIP.
END.

PROCEDURE putFooter2Report:
	DEFINE INPUT PARAMETER col2Summ AS CHARACTER.
	DEFINE INPUT PARAMETER col4Summ AS CHARACTER.
  PUT UNFORMATTED
		 "|--------------------------------------------------------------------------------------------------------------|" SKIP
		 "| Итого:                                    | "col2Summ FORMAT "X(14)" "|                    | " col4Summ FORMAT "X(14)" "|               | " SKIP
		 "|--------------------------------------------------------------------------------------------------------------|" SKIP.
		
END.

FUNCTION isValidate RETURNS LOGICAL (
				    col1 AS CHARACTER,
				    col2 AS CHARACTER,
				    col3 AS CHARACTER,
				    col4 AS CHARACTER).
 /****************************************************
  *				             *
  * Функция возврщает ИСТИНУ если строка  *
  * удовлетворяет необходимым условиям и   *
  * ее необходимо вывести на экран                 *
 *****************************************************/
RETURN TRUE.
/*
       IF NOT (col2 = col4  AND col2 = "0") THEN 
	IF col1<>"" OR col3<>"" THEN RETURN TRUE.
			  	  ELSE RETURN FALSE.*/

END.

/**************************************************** Конец определения служебных процедур  ****************************************************/


/*************************************************** Определение служебных переменных  *********************************************************/

DEFINE VARIABLE cAcctBal AS CHARACTER  NO-UNDO.	                      /* Переменная для хранения остатка по счету */
DEFINE VARIABLE cAcctRole AS CHARACTER NO-UNDO. 		     /* Переменная для хранения роли счета           */
DEFINE VARIABLE dCurrDate AS DATE NO-UNDO.           		     /* Переменная для хранения даты на которую формируется отчет */

DEFINE VARIABLE outStrArray1 AS CHARACTER EXTENT 6 NO-UNDO.     /* Определение массива для хранения строки таблицы */

DEFINE VARIABLE dLoanOpenDate AS DATE NO-UNDO. 		    /* Дата открытия договора */

DEFINE SHARED VARIABLE gend-date AS DATE NO-UNDO.                      /* Переменная для определения даты конца периода */
DEFINE VARIABLE iProp AS DECIMAL NO-UNDO.		                   /* Переменная для хранения соотношения между Ячейкой C и E */
DEFINE VARIABLE i AS INTEGER  NO-UNDO.
DEFINE VARIABLE dCol2Summ AS DECIMAL INITIAL 0 NO-UNDO.
DEFINE VARIABLE dCol4Summ AS DECIMAL INITIAL 0 NO-UNDO.
DEFINE VARIABLE iPrecession AS INTEGER INITIAL 2 NO-UNDO.

/************************************************** Конец определения службеных переменных *****************************************************/

               RUN putHeader2Report.

      FOR EACH  tmprecid NO-LOCK,
	FIRST loan WHERE tmprecid.id = RECID(loan) BY loan.cont-code:

	             /* По всем договорам */

                      	           FOR EACH loan-acct  OF loan NO-LOCK:
			   /* По всем счетам в договоре */

			   RUN acct-pos in h_base (loan-acct.acct, loan-acct.currency,gend-date,gend-date, chr(251)).

			    cAcctBal = STRING( ABSOLUTE(sh-bal) ).

			    dLoanOpenDate = loan.open-date.
					

		                       CASE loan-acct.acct-type:
				WHEN "Кредит" THEN
					DO:
				    	   outStrArray1[1] = loan-acct.acct.
		   		                   outStrArray1[2] = cAcctBal.
					   dCol2Summ = ROUND(dCol2Summ + DECIMAL(cAcctBal),iPrecession).
					END.

				WHEN "КредРез"  THEN
					DO:
					   outStrArray1[3] = loan-acct.acct.
					   outStrArray1[4] = cAcctBal.
					   dCol4Summ = ROUND(dCol4Summ + DECIMAL(cAcctBal),iPrecession).
					END.
		                        END. /* CASE */
 	                        END. /* По всем счетам в договоре */
		        
		         outStrArray1[6] = loan.cont-code.	
		         outStrArray1[5] = STRING( ROUND(100 / DECIMAL(outStrArray1[2]) * DECIMAL(outStrArray1[4]),iPrecession) ) NO-ERROR.

 	                        /* Выводим полученные данные в массив */		

			      IF isValidate(outStrArray1[1],outStrArray1[2],outStrArray1[3],outStrArray1[4]) THEN
				      RUN put2Report(outStrArray1[1],outStrArray1[2],outStrArray1[3],outStrArray1[4],STRING(dLoanOpenDate),outStrArray1[6]).

		      /* Обнуляем строки */
			      DO i = 1 TO 6 BY 1:
				outStrArray1[i] = "".
			       END.
	END. /* Конец по всем выделенным в браузере */

RUN putFooter2Report(STRING(dCol2Summ),STRING(dCol4Summ)).

{preview.i}