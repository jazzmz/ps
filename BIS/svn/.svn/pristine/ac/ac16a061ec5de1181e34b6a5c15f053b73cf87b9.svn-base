{pirsavelog.p}

/* 
		Распоряжение по резервам 232-П
		Бурягин Е.П. 10.01.2006 10:19
		
		Условимся, что броузере выбраны только "правильные" документы, т.е. те,
		которые должны отображаться в настоящем распоряжении.
*/

/* Подключяем глобалные настройки*/
{globals.i}
/* Вывод в preview */
{setdest.i}
/* Библиотека функций для работы со счетами */
{ulib.i}
{intrface.get instrum}
{tmprecid.def}        /** Используем информацию из броузера */
{get-bankname.i}
/** ОПРЕДЕЛЕНИЯ **/

/* Счет резерва: определим и сохраним его в этой переменной */
DEF VAR acct_rsrv AS CHAR NO-UNDO.
/* Внебалансовый счет, который попадает в первый столбец */
DEF VAR acct_main_no  AS CHAR NO-UNDO.
DEF VAR acct_main_cur AS CHAR NO-UNDO.
/* Позиция по счету */
DEF VAR acct_main_pos AS DECIMAL NO-UNDO.
DEF VAR acct_main_pos_rur AS DECIMAL NO-UNDO.
DEF VAR acct_rsrv_calc_pos AS DECIMAL NO-UNDO.
DEF VAR acct_rsrv_real_pos AS DECIMAL NO-UNDO.

/* Сумма операции */
DEF VAR amt_create AS DECIMAL NO-UNDO.
DEF VAR amt_delete AS DECIMAL NO-UNDO.
DEF VAR amt_korr   AS DECIMAL NO-UNDO.

DEF VAR client_name AS CHAR extent 2 no-undo.
DEF VAR loaninf AS CHAR NO-UNDO.
DEF VAR grrisk AS INTEGER NO-UNDO.
DEF VAR prrisk AS INTEGER NO-UNDO.
DEF VAR mEnd AS INTEGER NO-UNDO.
DEF VAR kursop AS DECIMAL NO-UNDO.

/* Итоговые значения */
DEF VAR total_pos_rur AS DECIMAL NO-UNDO.
DEF VAR total_pos_usd AS DECIMAL NO-UNDO.
DEF VAR total_pos_eur AS DECIMAL NO-UNDO.
DEF VAR total_calc_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_real_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_create_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_delete_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_korr_rsrv AS DECIMAL NO-UNDO.

def var PIRbosKazna as char NO-UNDO.
def var PIRbosKaznaFIO as char NO-UNDO.

/* Вывод ошибок на экран */
DEF VAR traceOn AS LOGICAL INITIAL false NO-UNDO.
/* Временная для работы */
DEF VAR tmpStr AS CHAR NO-UNDO.
/* Должности и подписи */
DEF VAR PIRbosloan AS CHAR NO-UNDO.
DEF VAR PIRbosloanFIO AS CHAR NO-UNDO.
PIRbosloan = ENTRY(1,FGetSetting("PIRboss","PIRbosloan","")).
PIRbosloanFIO = ENTRY(2,FGetSetting("PIRboss","PIRbosloan","")).
/*
DEF VAR PIRbosU5 AS CHAR NO-UNDO.
DEF VAR PIRbosU5FIO AS CHAR NO-UNDO.
PIRbosU5 = ENTRY(1,FGetSetting("PIRboss","PIRbosU5","")).
PIRbosU5FIO = ENTRY(2,FGetSetting("PIRboss","PIRbosU5","")).
DEF VAR PIRbosD6 AS CHAR NO-UNDO.
DEF VAR PIRbosD6FIO AS CHAR NO-UNDO.
PIRbosD6 = ENTRY(1,FGetSetting("PIRboss","PIRbosD6","")).
PIRbosD6FIO = ENTRY(2,FGetSetting("PIRboss","PIRbosD6","")).
*/
/* Дата распоряжения */
DEF VAR DATE-rasp AS DATE NO-UNDO.

/** РЕАЛИЗАЦИЯ **/

/* Из первой операции найдем дату отчета */
DATE-rasp = TODAY.
FOR FIRST tmprecid NO-LOCK,
		FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK
		:
		DATE-rasp = op.op-DATE.
END.

/* Шапка отчета */
PUT UNFORMATTED  "                                                                                                               В департамент-3" SKIP.
PUT UNFORMATTED  "                                                                                                               " cBankName SKIP(2).
PUT UNFORMATTED  "                                                                                                               " STRING(DATE-rasp,"99/99/9999") SKIP(3).
PUT UNFORMATTED  "                                         Р А С П О Р Я Ж Е Н И Е" skip(1)
	 	'             В соответствии с Положением Банка России "О порядке формирования кредитными организациями резервов на возможные потери"' SKIP
	 	'прошу Вас урегулировать резерв по внебалансовым счетам, являющимися элементами расчетной базы:' SKIP
	 	"┌────────────────────┬───────────────────────────────────┬────────┬────────┬───────────────┬───────────────┬───────┬───────────────────────────────┬───────────────┐" SKIP
		"│                    │                                   │  Код   │  Курс  │ Сумма остатка │ Сумма остатка │Катег-я│          Сумма резерва        │     Сумма     │" SKIP
                "│    Номер счета     │     Наименование контрагента      │ валюты │ валюты │по к/с в валюте│по к/с в рублях│кач-ва ├───────────────┬───────────────┤ корректировки │" SKIP 		
                "│                    │                                   │        │        │               │               │ и %   │   расчетного  │   созданного  │               │" SKIP
	 	"├────────────────────┼───────────────────────────────────┼────────┼────────┼───────────────┼───────────────┼──┬────┼───────────────┼───────────────┼───────────────┤" SKIP.

  find last tmprecid no-lock.
  if avail tmprecid then mEnd = tmprecid.id.
/* Для всех документов, выбранных в брoузере выполняем... */
FOR EACH tmprecid 
         NO-LOCK,
   FIRST op WHERE 
         RECID(op) EQ tmprecid.id 
         NO-LOCK, 
   FIRST op-entry OF op
         NO-LOCK
: 
	
	ASSIGN amt_create = 0 amt_delete = 0.
	/* Найдем счет резерва в проводке. Он либо по дебету, либо по кредиту и начинается с 4 
	   попутно сохраним значение суммы проводки в соответствующую переменную 
	*/
	IF op-entry.acct-db BEGINS "3" THEN	ASSIGN acct_rsrv = op-entry.acct-db amt_delete = amt-rub amt_korr = amt_delete.
	IF op-entry.acct-cr BEGINS "3" THEN ASSIGN acct_rsrv = op-entry.acct-cr amt_create = amt-rub amt_korr = amt_create.

	/* Если все-таки ни по дебету, ни по кредиту счет, начинающийся на 4 не найден, 
	   выдаем сообщение и выходим из процедуры */
	IF acct_rsrv = "" THEN 
		DO:
			MESSAGE "В проводке документа " + op.doc-num + " нет счета резерва, начинающегося на 4!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
	/* Согласно реализации резервирования 232-П в БИСКВИТЕ, данный счет должен быть привязан 
		 к внебалансовому счету через доп.реквизит. Проверим существование данной связи */
	FIND FIRST signs WHERE 
		file-name = "acct"	
		AND
		code = "acct-reserve"
		AND
		code-value = acct_rsrv
		NO-LOCK NO-ERROR.
	IF AVAIL signs THEN 
		/* Если связь существует, то сохраним номер и валюту внебалансового счета */
		DO:
			acct_main_no = ENTRY(1,surrogate).
			acct_main_cur = ENTRY(2,surrogate).
			IF acct_main_cur = "" THEN acct_main_cur = "810".
	        END.
	ELSE
		/* Иначе выдаем сообщение об ошибке и завершаем работу процедуры */
		DO:
			MESSAGE "Счет резерва " + acct_rsrv + " не привязан через доп.реквизит к внебалансовому счету!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
	
/* курс */
	IF acct_main_cur ne "" THEN
	    kursop = FindRateSimple("Учетный",acct_main_cur,op.op-date).
	       
	    
	 /* Найдем остаток по внебалансовому счету на дату */
	 acct_main_pos     = ABS(GetAcctPosValue_UAL(acct_main_no, acct_main_cur, op.op-DATE, traceOn)).
	 acct_main_pos_rur = ABS(GetAcctPosValue_UAL(acct_main_no, "810", op.op-DATE, traceOn)).
	 
	 /* Найдем расчетный резерв. На самом деле, на момент выполнения процедуры это фактически уже 
	    сформированный резерв
	 */
	 acct_rsrv_calc_pos = ABS(GetAcctPosValue_UAL(acct_rsrv, "810", op.op-DATE, traceOn)).
	 
	 /* Найдем сформированный резерв. Поскольку распоряжение формируется по факту, т.е. по проводкам, то
	 	  сумма сформированного резерва = остаток на счете резерва +- сумма проводки 
	 */
	 acct_rsrv_real_pos = acct_rsrv_calc_pos - amt_create + amt_delete.
	 
	 /* Накапливаем итоговые суммы */
	 IF acct_main_cur = "810" THEN
	   total_pos_rur = total_pos_rur + acct_main_pos.
	 IF acct_main_cur = "840" THEN
	   total_pos_usd = total_pos_usd + acct_main_pos.
	 /* Может скоро понадобится 
	 IF acct_main_cur = "978" THEN
	   total_pos_eur = total_pos_eur + acct_main_pos.
	 */
	 ASSIGN  
	   total_calc_rsrv = total_calc_rsrv + acct_rsrv_calc_pos
	   total_real_rsrv = total_real_rsrv + acct_rsrv_real_pos
	   total_create_rsrv = total_create_rsrv + amt_create
	   total_delete_rsrv = total_delete_rsrv + amt_delete.
	   total_korr_rsrv = total_korr_rsrv + amt_create + amt_delete.
	   
	 
	 /* Найдем название клиента */
        FIND FIRST acct WHERE acct.acct EQ acct_rsrv NO-LOCK NO-ERROR.
        {getcust.i &name=client_name &OFFinn = "/*" &OFFsigns = "/*"}
        client_name[1]= client_name[1] + " " + Client_Name[2].
	 
	
	/* найдем курс */
	 /* Найдем информацию о договоре */
	 FIND FIRST loan-acct WHERE
	 		loan-acct.acct = acct_rsrv
	 		AND
	 		loan-acct.contract = "Кредит"
	 		NO-LOCK NO-ERROR.
	 IF AVAIL loan-acct THEN
	   DO:
	     FIND FIRST loan WHERE
	       loan.contract = loan-acct.contract
	       AND
	       loan.cont-code = loan-acct.cont-code
	       NO-LOCK NO-ERROR.
	     IF AVAIL loan THEN
	       DO:
	       	 loaninf = loan.cont-code + " от ". 
				   prrisk = loan.risk.
				   FIND FIRST signs WHERE  
									signs.code = "ДатаСогл"
									AND 
									signs.file-name = "loan"
									AND 
									signs.surrogate = "Кредит," + loan.cont-code
									NO-LOCK NO-ERROR.
					 IF AVAIL signs THEN
					   DO:
							 loaninf = loaninf + signs.code-value.
						 END.
					 ELSE
					 	 DO:
						   loaninf = loaninf + STRING(loan.open-DATE,"99/99/9999").
						 END.
	       END.
	   END.
   ELSE 
	 	 loaninf = "не определен".

	 /* Найдем процентную ставку. Вычислим ее как частное от деления расчетного резерва на рублевый остаток 
	    внебалансового счета 
	 */	 
	 /* prrisk = ROUND(acct_rsrv_calc_pos / acct_main_pos_rur, 2) * 100. */
	 /* Найдем процентную ставку. Она хранится в доп.реквизите внебалансового счета */
	 tmpStr = GetXAttrValueEx("acct",acct_main_no + "," + (if acct_main_cur="810" then "" else acct_main_cur),"pers-reserve","").
	 IF tmpStr <> "" THEN
	 		prrisk = DECIMAL(tmpStr).
	 tmpStr = GetXAttrValueEx("acct",acct_main_no + "," + (if acct_main_cur="810" then "" else acct_main_cur),"ГрРиска","").
	 IF tmpStr <> "" THEN
	 		grrisk = integer(substring(tmpStr,1,1)).

	 
	 /* Определим группу риска по процентной ставке */
	/* IF prrisk = 0 THEN grrisk = 1.
	 IF prrisk >= 1 AND prrisk <= 20 THEN grrisk = 2.
	 IF prrisk > 20 AND prrisk <= 50 THEN grrisk = 3.
	 IF prrisk > 50 AND prrisk < 100 THEN grrisk = 4.
	 IF prrisk = 100 THEN grrisk = 5.
*/
	 
	 /* Выводим строку таблицы */
	 PUT UNFORMATTED 
	 	"│" acct_main_no FORMAT "x(20)"
	 	"│" client_name[1] FORMAT "x(35)"
	 	"│" acct_main_cur FORMAT "xxx" at 62
	 	"│"  at 67 kursop format ">>9.9999" 
		"│" ABS(acct_main_pos) FORMAT "->>>,>>>,>>9.99"
	 	"│" ABS(acct_main_pos_rur) FORMAT "->>>,>>>,>>9.99"
	 	"│" grrisk FORMAT ">>"
	 	"│" prrisk FORMAT ">>9" "%"
	 	"│" ABS(acct_rsrv_calc_pos) FORMAT "->>>,>>>,>>9.99"
	 	"│" ABS(acct_rsrv_real_pos) FORMAT "->>>,>>>,>>9.99"
	 	"│" amt_korr FORMAT "->>>,>>>,>>9.99"
/*	 	"│" amt_delete FORMAT "->>>,>>>,>>9.99" 
*/
	 	"│" SKIP.
	if tmprecid.id eq mEnd then
PUT UNFORMATTED "├────────────────────┴───────────────────────────────────┴────────┴────────┴───────────────┴───────────────┴──┴────┴───────────────┴───────────────┼───────────────┤" SKIP.
       else
PUT UNFORMATTED	"├────────────────────┼───────────────────────────────────┼────────┼────────┼───────────────┼───────────────┼──┼────┼───────────────┼───────────────┼───────────────┤" SKIP.


END.
/* Выводим итоговые значения */
PUT UNFORMATTED "│                                                                                                                             Итого создать:       │" + string(total_create_rsrv,"->>>,>>>,>>9.99") + "│" skip.
PUT UNFORMATTED "│                                                                                                                             Итого восстановить:  │" + string(total_delete_rsrv,"->>>,>>>,>>9.99") + "│" skip.
PUT UNFORMATTED "│                                                                                                                             Всего:               │" + string(total_korr_rsrv,"->>>,>>>,>>9.99") + "│" skip.
PUT UNFORMATTED "└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴───────────────┘" skip(2).

/* Подписи в подвале */
PIRbosKazna = ENTRY(1,FGetSetting("PIRboss","PIRbosKazna","")).
PIRbosKaznaFIO = ENTRY(2,FGetSetting("PIRboss","PIRbosKazna","")).

PUT UNFORMATTED PIRbosKazna SPACE(100 - LENGTH(PIRboskazna)) PIRbosKaznaFIO SKIP(5).

FIND FIRST _user WHERE _user._userid EQ userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	PUT UNFORMATTED "Начальник отдела операций"  SKIP
	                "на финановых рынках:     " SPACE(75) _user._user-name SKIP.
ELSE
	PUT UNFORMATTED "Начальник отдела операций"  SKIP
	                "на финановых рынках:" SKIP.


/* Отображаем содержимое preview */
{preview.i}