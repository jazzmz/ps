{pirsavelog.p}

/*
		Акт инвентаризации остатков по балансовосу счету на дату
		Бурягин Е.П., 31.01.2006 9:28
		
		Modified: 08.02.2007 11:47 Buryagin
							По просьбе Елешиной "разделил" отчет на два: официальный и неофициальный.
							Официальный отличается от "брата" тем, что у него есть в шапке "Утверждаю" и подписи внизу.
							Как это работает: если в параметрах заданы значения, то это значит, что хотят получить официальный отчет,
							иначе хотят получить неофициальный отчет.
*/

/* Глобальные определения */
{globals.i}
/* Библиотека по работе со счетами */
{ulib.i}
/* Перенос строк по словам */
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */

DEF INPUT PARAM iParam AS CHAR.

/* Балансовый счет */
DEF VAR balAcct AS CHAR FORMAT "x(5)" LABEL "Балансовый счет".
/* Дата составления акта */
DEF VAR repDate AS DATE FORMAT "99/99/9999" LABEL "Дата составления".
/* Дата состояния */
DEF VAR acctInventar AS CHAR FORMAT "x(30)" LABEL "Инвентаризация".
/* Содержание */
DEF VAR acctDetails AS CHAR FORMAT "x(30)" LABEL "Содержание операции".
/* Наименование л/счета */
DEF VAR acctName AS CHARACTER.
/* Флаг отладки для библиотеки uacctlib.i */
DEF VAR onTrace AS LOGICAL INITIAL false.
/* Остаток по счету */
DEF VAR acctPos 	AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99".
DEF VAR totalAcctPos 	AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99".
/* Остаток по счету в рублевом эквиваленте */
DEF VAR acctPosRub 	AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99".
DEF VAR totalAcctPosRub AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99".
/* Сквозной нумератор */
DEF VAR iRow AS INTEGER FORMAT ">>>>>>" INITIAL 1.
/* Итератор */
DEF VAR i AS INTEGER.
DEF VAR s AS INT NO-UNDO.
DEF VAR tmpStr AS CHAR EXTENT 5 NO-UNDO.
/* Подавлять нулевые строки */
DEF VAR noZero AS LOGICAL VIEW-AS TOGGLE-BOX LABEL "Подавлять нулевые сроки" INITIAL true.

/* Возьмем балансовый счет первого лицевого из выбранных */
FOR FIRST tmprecid NO-LOCK,
		FIRST acct WHERE RECID(acct) EQ tmprecid.id NO-LOCK
:
	balAcct = STRING(acct.bal-acct).
END.
PAUSE 0.


/* Отобразим и, как это бывает в языках 4GL, определим окно */
DISPLAY
	balAcct 	SKIP
	repDate 	SKIP
	acctDetails 	SKIP
	acctInventar 	SKIP
	noZero
  WITH FRAME inputFrame CENTERED OVERLAY SIDE-LABELS.
  
/* Введем значения */
SET 
	balAcct 
	repDate
	acctDetails
	acctInventar
	noZero
		WITH FRAME inputFrame.
HIDE FRAME inputFrame.


DEF VAR oTable AS TTable.
oTable = new TTable(6).

{tpl.create}
oTpl:addAnchorValue("BALACCT",balAcct).
oTpl:addAnchorValue("DATE"	, IF repDate  <> ? THEN (repDate + 1) ELSE TODAY).
oTpl:addAnchorValue("INVENTAR"	, acctInventar).

/* Для всех счетов, принадлежащих введенному балансовому счету
   делаем...
*/
DEF VAR acctPosRubTotal AS DEC INIT 0 NO-UNDO.
FOR EACH tmprecid NO-LOCK,
  FIRST acct WHERE RECID(acct) EQ tmprecid.id 
  AND
	acct.acct BEGINS balAcct
	AND
	acct.open-date LE repDate
	AND
	(
		acct.close-date GT repDate
		OR
		acct.close-date = ?
	)
	NO-LOCK
:
	acctPos = ABS(GetAcctPosValue_UAL(acct.acct, acct.currency, repDate, onTrace)).
	IF acctPos <> 0 OR NOT noZero THEN DO:
		totalAcctPos = totalAcctPos + acctPos.
		acctPosRub = ABS(GetAcctPosValue_UAL(acct.acct, "810", repDate, onTrace)).
		totalAcctPosRub = totalAcctPosRub + acctPosRub.
	
	oTable:addRow().
		oTable:addCell(iRow).
		oTable:addCell(acct.acct).
		oTable:addCell(REPLACE(acct.details, "\n", "")).
		oTable:addCell(STRING(acctPos	, "->>>,>>>,>>>,>>9.99")).
		oTable:addCell(STRING(acctPosRub, "->>>,>>>,>>>,>>9.99")).
		oTable:addCell(acctDetails).
		iRow = iRow + 1.
		acctPosRubTotal = acctPosRubTotal + acctPosRub.
	END.
END.

/** Сумма прописью */
DEF VAR amount-str AS CHAR EXTENT 2. /** сумма прописью */
DEF VAR TotalAmt   AS CHAR NO-UNDO.  /** вся строка суммы цифрами и прописью */
RUN x-amtstr.p(acctPosRubTotal, '', true, true, output amount-str[1], output amount-str[2]).
amount-str[1] = amount-str[1] + ' ' + amount-str[2].
SUBSTR(amount-str[1], 1, 1) = caps(substr(amount-str[1], 1, 1)).

TotalAmt = "" .
tmpStr[1] = "- на сумму:  " + TRIM(STRING(acctPosRubTotal, "->>>,>>>,>>>,>>9.99")) + " (" + amount-str[1] + ")" .
{wordwrap.i &s=tmpStr &n=5 &l=125}
DO s = 1 TO 5 :
  IF tmpStr[s] <> "" THEN
	TotalAmt = TotalAmt + tmpStr[s] + CHR(10) .
END.

oTpl:addAnchorValue("TotalCol"	   , iRow - 1). 					/* количество порядковых номеров */
oTpl:addAnchorValue("TotalAmt"	   , TotalAmt). 					/* на сумму цифрами и прописью */


/* Итоговые значения */
oTable:addRow().
	oTable:addCell("").
	oTable:addCell("").
	oTable:addCell("Итого:").
	oTable:addCell(STRING(totalAcctPos	, "->>>,>>>,>>>,>>9.99")).
	oTable:addCell(STRING(totalAcctPosRub	, "->>>,>>>,>>>,>>9.99")).
	oTable:addCell("").
	oTable:setAlign(3,oTable:height,"left").


 /* Отображаем */
oTpl:addAnchorValue("TABLE",oTable).
 def var iPageLength as int init 1000 NO-UNDO.
/*{setdest.i}*/
{setdest.i &custom = " IF YES THEN iPageLength ELSE "}

	oTpl:show().
 {preview.i}

{tpl.delete}