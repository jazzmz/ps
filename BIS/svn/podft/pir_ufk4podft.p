/* pir_ufk4podft.p #974 Доля платежей в УФК ко всем платежам клиента
   экспорт в .xls файл, добавил агрегацию, где несколько счетов у одного клиента
*/

using Progress.Lang.*.

{globals.i}
{sh-defs.i}
{tmprecid.def}

{ulib.i}

{pir_exf_exl.i}

{getdates.i}

DEF VAR V_CUST_CORP_ACCTS 	AS CHAR NO-UNDO INIT "404*,405*,406*,407*,408*".
DEF VAR V_UFK_ACCTS 	 	AS CHAR NO-UNDO INIT "401*,402*,403*,404*".

{ulib.i}

def var d1 as int		NO-UNDO.
DEF VAR oTpl   AS TTpl   	NO-UNDO.
def var oTable AS TTableCSV 	NO-UNDO.

oTable = new TTableCsv(9).
  oTable:AddROW().
  oTable:addCell("П/н").
  oTable:addCell("Наименование клиента").
  oTable:addCell("ИНН").
  oTable:addCell("Номер счета").
  oTable:addCell("Оборот по ДБ").
  oTable:addCell("Оборот по КР").
  oTable:addCell("Сумма платежей в УФК").
  oTable:addCell("Доля платежей в УФК по отношению к ДБ").
  oTable:addCell("Дата закрытия счета").

DEF VAR i AS INT NO-UNDO INIT 1.

{exp-path.i &exp-filename = "'pir_ufk4podft.xls'"}
DEF VAR cXL AS CHAR NO-UNDO.
PUT UNFORMATTED XLHead("dop", "CCCCNNNND", "50,250,80,180,120,120,120,100,74").

cXL = XLCell("Отдел ПОДФТ: Данные по платежам клиентов в УФК (Управление Федерального Казначейства) за период с " +
		STRING(beg-date, "99/99/99") + " по " + STRING(end-date, "99/99/99")
	).

PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

cXL = 
    XLCell("П/н")
  + XLCell("Наименование клиента")
  + XLCell("ИНН")
  + XLCell("Номер счета")
  + XLCell("Оборот по ДБ")
  + XLCell("Оборот по КР")
  + XLCell("Сумма платежей в УФК")
  + XLCell("Доля платежей в УФК по отношению к ДБ")
  + XLCell("Дата закрытия счета")
.
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

FOR EACH tmprecid
  , FIRST cust-corp
      WHERE RECID(cust-corp) = tmprecid.id
      NO-LOCK
  , EACH acct
      WHERE acct.cust-id  = cust-corp.cust-id
	AND acct.cust-cat = "Ю"
	AND CAN-DO(V_CUST_CORP_ACCTS, acct.acct)
	AND acct.currency = ""
      NO-LOCK 
	BREAK BY acct.cust-id :

   RUN acct-pos IN h_base(acct.acct, acct.currency, beg-date, end-date, "Ф").

   DEF VAR vAmt2UFK AS DEC NO-UNDO.
   vAmt2UFK = 0.
   FOR EACH op-entry
     WHERE op-entry.op-date >= beg-date
       AND op-entry.op-date <= end-date
       AND op-entry.acct-db = acct.acct
     NO-LOCK
     , FIRST op OF op-entry
         WHERE CAN-DO(V_UFK_ACCTS, op.ben-acct)
         NO-LOCK :
     vAmt2UFK = vAmt2UFK + op-entry.amt-rub.
   END.

   DEF VAR vAmt2UFKpart AS DEC NO-UNDO.
   vAmt2UFKpart = IF sh-db <> 0
			THEN vAmt2UFK / sh-db * 100
			ELSE 0.0.
/*
   oTable:AddROW().
   oTable:addCell(STRING(i, ">>>>9")).
   oTable:addCell(cust-corp.name-corp).	/* Наименование клиента */
   oTable:addCell(cust-corp.inn).	/* ИНН */
   oTable:addCell(acct.acct).		/* Номер счета */
   oTable:addCell(STRING(sh-db        , ">>>,>>>>,>>>,>>9.99")). /* Оборот по ДБ */
   oTable:addCell(STRING(sh-cr        , ">>>,>>>>,>>>,>>9.99")). /* Оборот по КР */
   oTable:addCell(STRING(vAmt2UFK     , ">>>,>>>>,>>>,>>9.99")). /* Сумма платежей в УФК */
   oTable:addCell(STRING(vAmt2UFKpart , ">>>,>>>>,>>>,>>9.99")). /* Доля платежей в УФК по отношению к ДБ */
   oTable:addCell(acct.close-date).
*/

  cXL = 
     XLCell(STRING(i, ">>>>9"))
   + XLCell(cust-corp.name-corp)	/* Наименование клиента */
   + XLCell(cust-corp.inn) 		/* ИНН */
   + XLCell(acct.acct) 			/* Номер счета */
   + XLNumCell(sh-db        )  		/* Оборот по ДБ */
   + XLNumCell(sh-cr        )  		/* Оборот по КР */
   + XLNumCell(vAmt2UFK     )  		/* Сумма платежей в УФК */
   + XLNumCell(vAmt2UFKpart )  		/* Доля платежей в УФК по отношению к ДБ */
   + XLDateCell(acct.close-date)
  .
  PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .
  i = i + 1.
  ACCUMULATE
	acct.cust-id 	(COUNT BY acct.cust-id)
	sh-db		(TOTAL BY acct.cust-id)
	sh-cr		(TOTAL BY acct.cust-id)
	vAmt2UFK	(TOTAL BY acct.cust-id)
  .
  IF LAST-OF(acct.cust-id ) AND (ACCUM COUNT BY acct.cust-id acct.cust-id) > 1 THEN DO:
    vAmt2UFKpart = IF (ACCUM TOTAL BY acct.cust-id sh-db) <> 0
			THEN (ACCUM TOTAL BY acct.cust-id vAmt2UFK) / (ACCUM TOTAL BY acct.cust-id sh-db) * 100
			ELSE 0.0.
    cXL = 
       XLCell("ИТОГО")
     + XLCell(cust-corp.name-corp)	/* Наименование клиента */
     + XLCell(cust-corp.inn) 		/* ИНН */
     + XLCell("") 			/* Номер счета */
     + XLNumCell(ACCUM TOTAL BY acct.cust-id sh-db        )  	/* Оборот по ДБ */
     + XLNumCell(ACCUM TOTAL BY acct.cust-id sh-cr        )  	/* Оборот по КР */
     + XLNumCell(ACCUM TOTAL BY acct.cust-id vAmt2UFK     )  	/* Сумма платежей в УФК */
     + XLNumCell(vAmt2UFKpart )  	/* Доля платежей в УФК по отношению к ДБ */
     + XLCell("")
    .
    PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .
  END.
END.

/*
{setdest.i}

PUT UNFORMATTED "Отдел ПОДФТ: Данные по платежам клиентов в УФК (Управление Федерального Казначейства) за период с "
		STRING(beg-date, "99/99/99") " по " STRING(end-date, "99/99/99") 
  SKIP.

oTable:show().

{preview.i}
*/
/* oTable:Save-To("1.csv"). */

PUT UNFORMATTED XLEnd().

DELETE OBJECT oTable.
