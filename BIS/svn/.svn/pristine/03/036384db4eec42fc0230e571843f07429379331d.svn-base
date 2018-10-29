{pirsavelog.p}
/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pir_u11rep_t004.p
      Comment: pir_u11rep_t004.csv - отчет для У11
	       Списанные доходы прошлых лет со счетов 61304 (по ПК) за период 
	       в разрезе налоговых периодов и валют
	       Алгоритм: 
		  1) Отбор по проводок за заданный период по транзакции pir-spkm 
		     с корреспонденцией  ДБ 61304 КР 70601810600001720201,70601810900001720202
		  2) По счету 61304 определяем договор ПК, основной счет СКС
		  3а) Если счет СКС не закрыт (или закрыт в позже заданного периода), то 
		      находим последнюю комиссию за годовое обслуживание (далеее см. код)
		  3б) Если счет СКС закрыт (с учетом заданного периода), то 
		      находим последнюю комиссию за годовое обслуживание
			- Если год зачисления и год закрытия СКС совпадают,
		          то налоговый период = год закрытия СКС
			- Если год зачисления меньше года закрытия СКС,
		          то налоговый период = год зачисления + 1 год
   Parameters: 
       Launch: ПК - ПЕЧАТЬ - ВЫХОДНЫЕ ФОРМЫ 
         Uses:
      Created: Sitov S.A., 19.04.2012
	Basis: #926 (ТЗ)
     Modified: Sitov S.A., 24.07.2012 , #1149 (ТЗ)
*/
/* ========================================================================= */




{globals.i}
{getdates.i}
{intrface.get xclass}


/* ========================================================================= */
				/** Объявления */
/* ========================================================================= */


DEF VAR tOpEntryAmt AS DEC   NO-UNDO.
DEF VAR tCodeComm AS CHAR NO-UNDO.
DEF VAR KomGod	AS DEC   NO-UNDO.
DEF VAR OldCardEndDate	AS DATE NO-UNDO.

DEF VAR i AS INT INIT 0 NO-UNDO.

DEF VAR a1 AS INT INIT 0 NO-UNDO.
DEF VAR a2 AS INT INIT 0 NO-UNDO.
DEF VAR a3 AS INT INIT 0 NO-UNDO.

DEF VAR m AS INT INIT 0 NO-UNDO.
DEF VAR n AS INT INIT 0 NO-UNDO.
DEF VAR o AS INT INIT 0 NO-UNDO.

DEF VAR DateCloseSCSminusyear AS DATE NO-UNDO.

DEF BUFFER bloan-acct FOR loan-acct.
DEF BUFFER bop-entry  FOR op-entry.
DEF BUFFER wop-entry  FOR op-entry.
DEF BUFFER card	      FOR loan.

DEF temp-table rep-tt NO-UNDO  
	FIELD DogPK AS CHAR
	FIELD AcctSCS AS CHAR 
	FIELD AcctComiss AS CHAR 
	FIELD OpEntryDate AS DATE
	FIELD OpEntryCurr AS CHAR
	FIELD OpEntryAmt  AS DECIMAL
	FIELD AcctSCSClose AS DATE
	FIELD OpEntryComisDate AS DATE
	FIELD OpEntryComisCur  AS CHAR
	FIELD NalPeriod AS CHAR
	FIELD Gpuppa AS CHAR
.


DEF VAR tmpFile	AS CHAR INIT "pir_u11rep_t004.csv" NO-UNDO.
tmpFile = "/home/bis/quit41d/imp-exp/users/" + LC(userid("bisquit")) + "/" + tmpFile .
DEFINE STREAM rep_excel .



/* ========================================================================= */
				/** Реализация */
/* ========================================================================= */

OUTPUT STREAM rep_excel TO VALUE (tmpFile) CONVERT TARGET "1251".

PUT STREAM rep_excel UNFORM ";Списанные доходы прошлых лет со счетов 61304 (по ПК);"  SKIP.
PUT STREAM rep_excel UNFORM ";за период с " beg-date " по " end-date ";"  SKIP.
PUT STREAM rep_excel UNFORM ";в разрезе налоговых периодов и валют;"  SKIP(2).

PUT STREAM rep_excel UNFORM "Дата запуска отчета;" today  ";"  SKIP(2).


PUT STREAM rep_excel UNFORM
  "Группа;"
  "Договор ПК;"
  "Счет СКС;"
  "Счет комисии;"
  "Дата Проводки;"
  "Валюта Проводки;"
  "Сумма Проводки;"
  "ДатаЗакрСКС;"
  "ДатаПроводкиКомиссии;"
  "ВалПроводкиКомиссии;"
  "Налог.период;"
SKIP.



FOR EACH op-entry 
	WHERE op-entry.op-date >= beg-date
	AND op-entry.op-date <= end-date
	AND op-entry.acct-db BEGINS "61304"
	AND ( op-entry.acct-cr EQ "70601810600001720201" OR op-entry.acct-cr EQ "70601810900001720202" )
	AND   (op-entry.op-status EQ "√" OR op-entry.op-status EQ "√√")
NO-LOCK,
FIRST op OF op-entry 
	WHERE op.op-kind EQ "pir-spkm"
NO-LOCK:

  i = i + 1.

  FIND FIRST loan-acct WHERE loan-acct.acct EQ op-entry.acct-db
	AND loan-acct.currency EQ op-entry.currency
  NO-LOCK NO-ERROR.

	/* Находим догвовор ПК */
  FIND FIRST loan WHERE loan.class-code = "card-loan-pers"
	AND loan.currency EQ loan-acct.currency
	AND loan.cont-code EQ loan-acct.cont-code
  NO-LOCK NO-ERROR.

	/* Находим основной счет СКС */
  FIND FIRST bloan-acct OF loan 
	WHERE bloan-acct.currency EQ loan.currency
	AND bloan-acct.acct-type BEGINS "SCS@" 
  NO-LOCK NO-ERROR.

	/* Находим пластиковую карту */
  FIND FIRST card 
	WHERE card.contract EQ 'card'
	AND card.parent-cont-code EQ loan.cont-code
	AND card.parent-contract EQ 'card-pers'
	AND card.loan-work EQ yes
  NO-LOCK NO-ERROR.


  CREATE rep-tt.

  ASSIGN
	rep-tt.DogPK = loan.cont-code
	rep-tt.AcctSCS = bloan-acct.acct
	rep-tt.AcctComiss = loan-acct.acct
	rep-tt.OpEntryDate = op-entry.op-date
  . 

  IF op-entry.currency = "" THEN
    DO:
	tOpEntryAmt  = op-entry.amt-rub .
	ASSIGN
	  rep-tt.OpEntryCurr = "810"
	  rep-tt.OpEntryAmt  = op-entry.amt-rub
	. 
    END.
  ELSE
    DO:
	tOpEntryAmt  = op-entry.amt-cur .
	ASSIGN
	  rep-tt.OpEntryCurr = op-entry.currency
	  rep-tt.OpEntryAmt  = op-entry.amt-cur
	. 
    END.


  FIND FIRST acct WHERE acct.acct EQ bloan-acct.acct
  NO-LOCK NO-ERROR.


	/* Если счет СКС не закрыт (или закрыт в позже заданного периода), то 
	   находим последнюю комиссию за годовое обслуживание 
	   (дату документа) и от неё определяем налоговый период (+1 год) */
  IF AVAIL(acct) AND ( acct.close-date = ? OR acct.close-date > end-date ) THEN
	DO:

	FIND LAST bop-entry 
		WHERE bop-entry.acct-db EQ bloan-acct.acct
		AND   bop-entry.acct-cr EQ op-entry.acct-db
		AND   (bop-entry.op-status EQ "√" OR bop-entry.op-status EQ "√√")  /*NE "A"*/
	NO-LOCK NO-ERROR.

		IF AVAIL(bop-entry) THEN
		  DO:

			 /* А1 - Списание комиссии было примерно за месяц до даты окончания карты (которая стоит сейчас!!!) */

			IF ( INT(card.end-date - bop-entry.op-date) <= 31 ) THEN
			  DO:
				a1 = a1 + 1.

				ASSIGN
				  rep-tt.AcctSCSClose =  ? 
				  rep-tt.OpEntryComisDate = bop-entry.op-date
				  rep-tt.OpEntryComisCur  = bop-entry.currency
				  rep-tt.NalPeriod = STRING(YEAR(card.end-date))
				  rep-tt.Gpuppa = "A1"
				. 

			  END.

			 /* А2 - Списание комиссии было позже даты окончания карты (которая стоит сейчас!!!) */

			IF ( bop-entry.op-date > card.end-date ) THEN
			  DO:
				a2 = a2 + 1.

				ASSIGN
				  rep-tt.AcctSCSClose =  ? 
				  rep-tt.OpEntryComisDate = bop-entry.op-date
				  rep-tt.OpEntryComisCur  = bop-entry.currency
				  rep-tt.NalPeriod = STRING(YEAR(card.end-date))
				  rep-tt.Gpuppa = "A2"
				. 

			  END.


			 /* А3 - Списание комиссии было более чем за месяц до даты окончания карты (которая стоит сейчас!!!) */

			IF ( INT(card.end-date - bop-entry.op-date) > 31 ) THEN
			  DO:
				a3 = a3 + 1.

				KomGod = 0 .

				/* Определяем комиссию KomGod */

				FIND LAST loan-cond 
					WHERE loan-cond.contract  EQ loan.contract
		                        AND loan-cond.cont-code EQ loan.cont-code
                			AND loan-cond.since     LE card.end-date
				NO-LOCK NO-ERROR.  

				/*Определение кода коммисии*/

				IF loan-cond.class-code MATCHES "*SAFE*" THEN
				   tCodeComm = GetXAttrInit(loan-cond.class-code,"КомГод2").
				ELSE
				   tCodeComm = GetXAttrInit(loan-cond.class-code,"КомГод").

				tCodeComm = tCodeComm + "@" + card.sec-code.


				/*Поиск значений действующих на дату процентной ставки для данной комиссии*/
				FIND LAST comm-rate 
					WHERE	comm-rate.commission  EQ tCodeComm
			     		AND comm-rate.since    LE card.end-date
				NO-LOCK NO-ERROR.

				IF AVAIL comm-rate THEN  
				  	KomGod = comm-rate.rate-comm. 

				/* дата окончания карты (на момент списания) */
				/* OldCardEndDate = DATE( STRING(MONTH(card.end-date)) + "/" + STRING(DAY(card.end-date)) + "/" + STRING(YEAR(bop-entry.op-date)) ) . */
				OldCardEndDate = DATE( STRING(DAY(card.end-date)) + "/" + STRING(MONTH(card.end-date)) + "/" + STRING(YEAR(bop-entry.op-date)) ) .

				/* Находим суммы для разбиения по периодам */ 
				IF (tOpEntryAmt >= (0.95 * KomGod / 12 )) AND (tOpEntryAmt <= (1.05 * KomGod / 12)) THEN 
				  DO:
					ASSIGN
					  rep-tt.AcctSCSClose =  ? 
					  rep-tt.OpEntryComisDate = bop-entry.op-date
					  rep-tt.OpEntryComisCur  = bop-entry.currency
					  rep-tt.NalPeriod = STRING(YEAR(OldCardEndDate))
					  rep-tt.Gpuppa = "A3"
					. 
				  END.
				ELSE
				  DO:
					ASSIGN
					  rep-tt.AcctSCSClose =  ? 
					  rep-tt.OpEntryComisDate = bop-entry.op-date
					  rep-tt.OpEntryComisCur  = bop-entry.currency
					  rep-tt.OpEntryAmt  = (IF (tOpEntryAmt >= KomGod / 12) THEN (KomGod / 12 ) ELSE tOpEntryAmt)
					  rep-tt.NalPeriod = STRING(YEAR(OldCardEndDate))
					  rep-tt.Gpuppa = "A3a"
					. 

					  /**** а вторая часть суммы пойдет во вторую строку. ЖЕСТЬ !!!! */

					CREATE rep-tt.

					IF op-entry.currency = "" THEN
					  DO:
						ASSIGN
						  rep-tt.OpEntryCurr = "810"
						. 
					  END.
					ELSE
					  DO:
						ASSIGN
						  rep-tt.OpEntryCurr = op-entry.currency
						. 
					  END.

					ASSIGN
					  rep-tt.DogPK = loan.cont-code
					  rep-tt.AcctSCS = bloan-acct.acct
					  rep-tt.AcctComiss = loan-acct.acct
					  rep-tt.OpEntryDate = op-entry.op-date
					  rep-tt.AcctSCSClose =  ? 
					  rep-tt.OpEntryComisDate = bop-entry.op-date
					  rep-tt.OpEntryComisCur  = bop-entry.currency
					  rep-tt.OpEntryAmt  = (IF (tOpEntryAmt - KomGod / 12) > 0 THEN (tOpEntryAmt - KomGod / 12) ELSE 0)
					  rep-tt.NalPeriod = STRING(YEAR(OldCardEndDate) + 1)
					  rep-tt.Gpuppa = "A3b"
					. 

					  /**** вторая сторка закончилась. ЖЕСТЬ!!!! */

				  END.

			  END. /* случай А3 закончился */ 

		  END.

	END.

	/* Если счет СКС закрыт (с учетом заданного периода), то 
	   находим последнюю комиссию за годовое обслуживание */
  ELSE 
	DO:

	FIND LAST wop-entry 
		WHERE wop-entry.acct-db EQ bloan-acct.acct
		AND   wop-entry.acct-cr EQ op-entry.acct-db
		AND   (wop-entry.op-status EQ "√" OR wop-entry.op-status EQ "√√")  /*NE "A"*/
	NO-LOCK NO-ERROR.

		IF AVAIL(wop-entry) THEN
		  DO:


			/* Если год зачисления и год закрытия СКС совпадают,
			   то налоговый период = год закрытия СКС */

			IF ( YEAR(wop-entry.op-date) EQ YEAR(acct.close-date) ) THEN
			  DO:
				m = m + 1.

				ASSIGN
				  rep-tt.AcctSCSClose = acct.close-date
				  rep-tt.OpEntryComisDate = wop-entry.op-date
				  rep-tt.OpEntryComisCur  = wop-entry.currency
				  rep-tt.NalPeriod = STRING(YEAR(wop-entry.op-date)) 
				  rep-tt.Gpuppa = "B"
				.
			  END.

			/* Если год зачисления < год закрытия СКС ,
			   то налоговый период = год зачисления + 1 год */

			IF ( YEAR(wop-entry.op-date) LT YEAR(acct.close-date) ) THEN
			  DO:
				n = n + 1.

				ASSIGN
				  rep-tt.AcctSCSClose = acct.close-date
				  rep-tt.OpEntryComisDate = wop-entry.op-date
				  rep-tt.OpEntryComisCur  = wop-entry.currency
				  rep-tt.NalPeriod = STRING(YEAR(wop-entry.op-date) + 1) 
				  rep-tt.Gpuppa = "C"
				. 
			  END.

			/* Если год зачисления > год закрытия СКС ,
			   то ЭТО СТРАННЫЙ НЕПРАВИЛЬНЫЙ СЛУЧАЙ !!! (а вдруг такие есть) */

			IF ( YEAR(wop-entry.op-date) GT YEAR(acct.close-date) ) THEN
			  DO:
				n = n + 1.

				ASSIGN
				  rep-tt.AcctSCSClose = acct.close-date
				  rep-tt.OpEntryComisDate = wop-entry.op-date
				  rep-tt.OpEntryComisCur  = wop-entry.currency
				  rep-tt.NalPeriod = STRING("Не удалось определить!") 
				  rep-tt.Gpuppa = "E"
				. 
			  END.

		  END.
	END.
 	
 
END. /* FOR EACH op-entry  */




FOR EACH rep-tt BY rep-tt.NalPeriod BY rep-tt.OpEntryCurr :

PUT STREAM rep_excel UNFORM
  rep-tt.Gpuppa ";"
  rep-tt.DogPK ";"
  "'" rep-tt.AcctSCS ";"
  "'" rep-tt.AcctComiss  ";"
  rep-tt.OpEntryDate ";"
  rep-tt.OpEntryCurr ";"
  rep-tt.OpEntryAmt ";"
  rep-tt.AcctSCSClose ";"
  rep-tt.OpEntryComisDate ";"
  rep-tt.OpEntryComisCur  ";"
  rep-tt.NalPeriod ";"
SKIP.

END.


PUT STREAM rep_excel UNFORM  SKIP(1).
PUT STREAM rep_excel UNFORM "ВСЕГО:;"    i SKIP(1).
PUT STREAM rep_excel UNFORM "Группа А1:;" a1 SKIP(1).
PUT STREAM rep_excel UNFORM "Группа А2:;" a2 SKIP(1).
PUT STREAM rep_excel UNFORM "Группа А3:;" a3 SKIP(1).
PUT STREAM rep_excel UNFORM "Группа В:;" m SKIP(1).
PUT STREAM rep_excel UNFORM "Группа C:;" n SKIP(1).
PUT STREAM rep_excel UNFORM "Группа E:;" o SKIP(1).


OUTPUT STREAM rep_excel CLOSE.


MESSAGE tmpFile VIEW-AS ALERT-BOX  TITLE "Файл сохранен в:".
