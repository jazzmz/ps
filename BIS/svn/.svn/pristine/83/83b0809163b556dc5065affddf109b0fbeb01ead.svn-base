{pirsavelog.p}

/* ------------------------------------------------------
     File: $RCSfile: pirloanrep2.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:23 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: ТЗ от 07.02.2007
     Что делает: Генерирует отчет о состоянии ссудной задолженности
     Как работает: 
     Параметры: 
     Место запуска: Броузер кредитных договоров
     Автор: $Author: anisimov $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.2  2007/09/11 12:10:50  buryagin
     Изменения: Last debug ;) Can use it!
     Изменения:
------------------------------------------------------ */

{globals.i}
{ulib.i}

/** Вычисление суммы отстатков счетов, удоволетворяющих маске и валюте */
FUNCTION getAcctPosSumBy RETURNS DECIMAL (INPUT inAcctMask AS CHAR, INPUT inCurrencyMask AS CHAR, INPUT inSideMask AS CHAR, INPUT inDate AS DATE).
	DEF BUFFER bfrAcct FOR acct.
	DEF VAR s AS DECIMAL.
	/** Выборка */
	FOR EACH bfrAcct WHERE 
		bfrAcct.open-date LE inDate
		AND (
					bfrAcct.close-date GE inDate
					OR 
					bfrAcct.close-date EQ ?
				)
		AND
		CAN-DO(inAcctMask, bfrAcct.acct)
		AND
		CAN-DO(inCurrencyMask, bfrAcct.currency)
		AND 
		CAN-DO(inSideMask, bfrAcct.side)
		NO-LOCK
			:
		s = s + GetAcctPosValue_UAL(bfrAcct.acct, bfrAcct.currency, inDate, false).
	END.
	RETURN s.
END FUNCTION.

DEF VAR tmpStr AS CHAR NO-UNDO.

{getdate.i}
{setdest.i}

tmpStr = "!440*,!459*,44*,45*,46*,478*".
PUT UNFORMATTED "ОТЧЕТ О СОСТОЯНИИ ССУДНОЙ ЗАДОЛЖЕННОСТИ" SKIP
                "на " STRING(end-date, "99.99.9999") SKIP(2)
                "ЗАДОЛЖЕННОСТЬ" SKIP
                "                     " getAcctPosSumBy(tmpStr, "", "А", end-date) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
                "                     " getAcctPosSumBy(tmpStr, "840", "А", end-date) FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
								"                     " getAcctPosSumBy(tmpStr, "978", "А", end-date) FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
								"=====================================================================" SKIP(1)
								"РЕЗЕРВЫ" SKIP
                "По ссудной задолж.   " ABS(getAcctPosSumBy(tmpStr, "", "П", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
                "По лимиту            " ABS(getAcctPosSumBy("47425*", "", "П", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
								"=====================================================================" SKIP(1)
								"ВНЕБАЛАНС" SKIP
								"Итого (рубли)        " STRING(ABS(getAcctPosSumBy("91302*,91309*,91404*", "", "*", end-date)), ">>>,>>>,>>>,>>9.99") " (810)" SKIP
								"         в том числе:" SKIP
								"         91302       " ABS(getAcctPosSumBy("91302*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
								"         91309       " ABS(getAcctPosSumBy("91309*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
								"         91404       " ABS(getAcctPosSumBy("91404*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP(1)
								"Итого (долл.США)     " STRING(ABS(getAcctPosSumBy("91302*,91309*,91404*", "840", "*", end-date)), ">>>,>>>,>>>,>>9.99") " (840)" SKIP
								"         в том числе:" SKIP
								"         91302       " ABS(getAcctPosSumBy("91302*", "840", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
								"         91309       " ABS(getAcctPosSumBy("91309*", "840", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
								"         91404       " ABS(getAcctPosSumBy("91404*", "840", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP(1)
								"Итого (евро)         " STRING(ABS(getAcctPosSumBy("91302*,91309*,91404*", "978", "*", end-date)), ">>>,>>>,>>>,>>9.99") " (978)" SKIP
								"         в том числе:" SKIP
								"         91302       " ABS(getAcctPosSumBy("91302*", "978", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
								"         91309       " ABS(getAcctPosSumBy("91309*", "978", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
								"         91404       " ABS(getAcctPosSumBy("91404*", "978", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99"  SKIP
								"---------------------------------------------------------------------" SKIP(1)
								"         91604       " ABS(getAcctPosSumBy("91604*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
								"                     " ABS(getAcctPosSumBy("91604*", "840", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
								"                     " ABS(getAcctPosSumBy("91604*", "978", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
								"---------------------------------------------------------------------" SKIP(1)
								"         91305       " ABS(getAcctPosSumBy("91305*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
								"                     " ABS(getAcctPosSumBy("91305*", "840", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
								"                     " ABS(getAcctPosSumBy("91305*", "978", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
								"---------------------------------------------------------------------" SKIP(1)
								"         91307       " ABS(getAcctPosSumBy("91307*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
								"                     " ABS(getAcctPosSumBy("91307*", "840", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
								"                     " ABS(getAcctPosSumBy("91307*", "978", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
								"---------------------------------------------------------------------" SKIP(1)
								"         91303       " ABS(getAcctPosSumBy("91303*", "", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (810)" SKIP
								"                     " ABS(getAcctPosSumBy("91303*", "840", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (840)" SKIP
								"                     " ABS(getAcctPosSumBy("91303*", "978", "*", end-date)) FORMAT ">>>,>>>,>>>,>>9.99" " (978)" SKIP
								"=====================================================================" SKIP
								"КОНТРОЛЬНАЯ СУММА:   " ((ABS(getAcctPosSumBy(tmpStr, "*", "*", end-date)) 
																				+ ABS(getAcctPosSumBy("47425*", "", "*", end-date))
																				+ ABS(getAcctPosSumBy("91604*,91305*", "840", "*", end-date))) / 1000000) FORMAT ">>>,>>>,>>>,>>9.99" SKIP
                "=====================================================================" SKIP
								.
{preview.i}