{pirsavelog.p}

/* 
                Дополнено: 
                Распоряжение по резервам 283-П
                Русинов М.В. 07.03.2008.
                
                Распоряжение по резервам 232-П
                Бурягин Е.П. 10.01.2006 10:19
                
                Условимся, что броузере выбраны только "правильные" документы, т.е. те,
                которые должны отображаться в настоящем распоряжении.
                
*/

/* Подключяем глобалные настройки*/
{globals.i}
{intrface.get count}
{get-bankname.i}

{tmprecid.def}

/* Вывод в preview */
{pir-out2arch.i &postfix=".txt"}
&IF DEFINED(arch2)=0 &THEN
{setdest.i}
&ENDIF

/* Библиотека функций для работы со счетами */
{ulib.i}

{getdate.i}

/** ОПРЕДЕЛЕНИЯ **/

DEF INPUT PARAM inParam AS CHAR NO-UNDO.
/* Счет резерва: определим и сохраним его в этой переменной */
DEF VAR acct_rsrv AS CHAR NO-UNDO.
/* Балансовый счет, который попадает в первый столбец */
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

DEF VAR client_name AS CHAR    NO-UNDO.
DEF VAR loaninf     AS CHAR    NO-UNDO.
DEF VAR grrisk      AS INTEGER NO-UNDO.
DEF VAR prrisk      AS DECIMAL NO-UNDO.
DEF VAR prrisk2     AS DECIMAL NO-UNDO.

/* Итоговые значения */
DEF VAR total_pos_rur AS DECIMAL NO-UNDO.
DEF VAR total_pos_usd AS DECIMAL NO-UNDO.
DEF VAR total_pos_eur AS DECIMAL NO-UNDO.

DEF VAR total_calc_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_real_rsrv AS DECIMAL NO-UNDO.

DEF VAR total_create_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_delete_rsrv AS DECIMAL NO-UNDO.
/* Вывод ошибок на экран */
DEF VAR traceOn AS LOGICAL INITIAL false NO-UNDO.
/* Временная для работы */
DEF VAR tmpStr AS CHAR NO-UNDO.
/* Должности и подписи */
DEF VAR PIRbos AS CHAR    NO-UNDO.
DEF VAR PIRbosFIO AS CHAR NO-UNDO.
DEF VAR userPost AS CHAR  NO-UNDO.

/* Переменная для op-transaction */
DEF VAR op_trans AS INT NO-UNDO.
DEF VAR op_doc   AS DEC NO-UNDO.
DEF VAR doc_num2 AS DEC NO-UNDO.


/* Проверка входящего параметра 
IF NUM-ENTRIES(inParam) <> 2 THEN DO:
  MESSAGE "Недостаточное кол-во параметров. Должно быть <норм_документ>,<код_руководителя_из_PIRBoss>" 
          VIEW-AS ALERT-BOX.
  RETURN.
END.

PIRbos = ENTRY(1,FGetSetting("PIRboss",ENTRY(2, inParam),"")).
PIRbosFIO = ENTRY(2,FGetSetting("PIRboss",ENTRY(2, inParam),"")). */
/*
DEF VAR PIRbosU5    AS CHAR NO-UNDO.
DEF VAR PIRbosU5FIO AS CHAR NO-UNDO.

PIRbosU5 = ENTRY(1,FGetSetting("PIRboss","PIRbosU5","")).
PIRbosU5FIO = ENTRY(2,FGetSetting("PIRboss","PIRbosU5","")).

DEF VAR PIRbosD6    AS CHAR NO-UNDO.
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
PUT UNFORMATTED  "┌─────────────────────────────┐" SKIP.
PUT UNFORMATTED  "│Распоряжение на формирование │" SKIP.
PUT UNFORMATTED  "│резервов на возможные потери │" SKIP.
PUT UNFORMATTED  "└─────────────────────────────┘                                                                               " SKIP(2).
PUT UNFORMATTED  "                                                                                                               " cBankName SKIP(2).
PUT UNFORMATTED  "                                                                                     Дата совершения операций: " STRING(DATE-rasp,"99/99/9999") SKIP(3).
PUT UNFORMATTED  "                                         Р А С П О Р Я Ж Е Н И Е" skip(1)
                 '    В соответствии с Положением Банка России №283-П от 20.03.2006г.  "О порядке формирования кредитными организациями резервов на возможные потери"' SKIP
                 'прошу Вас урегулировать резерв по балансовым счетам, являющимися элементами расчетной базы:' SKIP
                 "┌────────────────────┬───────────────────────────────────┬───────────────┬───┬───────────────┬─────────┬───────────────┬───────────────┬───────────────┬───────────────┐" SKIP
                "│     № СЧЕТА        │     НАИМЕНОВАНИЕ КЛИЕНТА          │   ОСТАТОК     │ВАЛ│ ЗАДОЛЖЕННОСТЬ │ГР. и %  │ СУММА РАСЧЕТ. │ СУММА СФОРМИР.│   ДОСОЗДАТЬ   │  ВОССТАНОВИТЬ │" SKIP
    "│                    │                                   │   по счету    │   │ (руб) Остаток │ РИСКА   │ РЕЗЕРВА В РУБ.│ РЕЗЕРВА В РУБ.│РЕЗЕРВ (В РУБ.)│РЕЗЕРВ (В РУБ.)│" SKIP
                 "│                    │                                   │   (47423)     │   │ по 47423      │         │               │               │               │               │" SKIP
                 "├────────────────────┼───────────────────────────────────┼───────────────┼───┼───────────────┼──┬──────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP.


/* Для всех документов, выбранных в брoузере выполняем... */
FOR EACH tmprecid NO-LOCK, FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK:

    FIND FIRST op-entry OF op NO-LOCK.
              
        ASSIGN amt_create = 0.
               amt_delete = 0.
               /* 
               acct_main_no = op-entry.acct-db.
               acct_main_cur = "810".
               */
         op_trans = op.op-transaction.

END.

/*  
Маслов Д. А. 28.10.2008
Устанил ошибку в запросе поиска.
Раньше ошибочно искался последний документ созданный транзакцией op_trans. 
При этом не учитывались документы выбранные в браузере.
*/

FOR EACH tmprecid NO-LOCK, LAST op WHERE RECID(op) EQ tmprecid.id AND op.op-transaction EQ op_trans NO-LOCK:                  

/*
 Маслов Д. А.
По всем документам выбранным в браузере счетов. Находим последний документ который выбран и который создан транзакцией op_trans
*/

  FIND LAST op-entry OF op  NO-LOCK.


      IF op-entry.acct-db BEGINS "47425" THEN        ASSIGN acct_rsrv = op-entry.acct-db amt_delete = amt-rub.
            IF op-entry.acct-cr BEGINS "47425" THEN ASSIGN acct_rsrv = op-entry.acct-cr amt_create = amt-rub.

      IF acct_rsrv = "" THEN 
                   DO:
                        MESSAGE "В проводке документа " + op.doc-num + " нет счета резерва 47425!" VIEW-AS ALERT-BOX.
                        RETURN.
                   END.            
     
                /* ОТРЕЗАН КУСОК ПРОВЕРКИ СВЯЗИ СЧЕТОВ */
                
        /* Согласно реализации резервирования 232-П в БИСКВИТЕ, данный счет должен быть привязан 
                 к балансовому счету через дополнительную связь с кодом 80. Проверим существование данной связи
        */ 
                 
        FIND FIRST links WHERE
                links.link-id = 80
                AND
                ENTRY(1, links.target-id) = acct_rsrv
                NO-LOCK NO-ERROR.

        IF AVAIL links THEN 
                 /* Если связь существует, то сохраним номер и валюту внебалансового счета */ 
                DO:
                        acct_main_no = ENTRY(1,links.source-id).
                        acct_main_cur = ENTRY(2,links.source-id).
                        IF acct_main_cur = "" THEN acct_main_cur = "810".
                END.
        ELSE
                 /* Иначе выдаем сообщение об ошибке и завершаем работу процедуры */
                DO:
                        MESSAGE "Счет резерва " + acct_rsrv + " не привязан через доп.связь к 'базовому' счету!" VIEW-AS ALERT-BOX.
                        RETURN.
                END.  
        
        



        /* Найдем счет резерва в проводке. Он либо по дебету, либо по кредиту и начинается с 47425 
           попутно сохраним значение суммы проводки в соответствующую переменную 
        */


        /* Если все-таки ни по дебету, ни по кредиту счет, начинающийся на 4 не найден, 
           выдаем сообщение и выходим из процедуры */

                    
         /* Найдем остаток по балансовому счету на дату */
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
         
         /* Найдем название клиента */
         client_name = GetAcctClientName_UAL(acct_rsrv, traceOn).


         
                  /* Найдем процентную ставку. Вычислим ее как частное от деления расчетного резерва на рублевый остаток 
            внебалансового счета 
         */         
         /* prrisk = ROUND(acct_rsrv_calc_pos / acct_main_pos_rur, 2) * 100. */
         /* Найдем процентную ставку. Она хранится в доп.реквизите внебалансового счета */
         
         /*
         tmpStr = GetXAttrValueEx("acct",acct_main_no + "," + (if acct_main_cur="810" then "" else acct_main_cur),"pers-reserve","").
         IF tmpStr <> "" THEN
                         prrisk = DECIMAL(tmpStr).
                         
         */
         
         /*  prrisk = GetCommRate_ULL("%Рез", "", 0, acct_main_no, 0, end-date, TRUE). */

   /*  Поиск процента риска из доп.реквизита документа "Процент резерва" */
             prrisk = DEC(GetXAttrValueEx("op", STRING(op.op),"Резерв",?)).
        
         IF prrisk = ? 
         THEN 
             DO: 
                      MESSAGE "На документе номер: " + op.doc-num + " не заполнен Доп.Реквизит <Резерв>! Необходимо заполнить реквизит, проставив в него значение процента резерва по данной операции, и запустить отчет повторно." VIEW-AS ALERT-BOX.
                           RETURN. 
                         END.
                  
         /* Определим группу риска по процентной ставке */
         IF prrisk = 0 THEN grrisk = 1.
         IF prrisk >= 1 AND prrisk <= 20 THEN grrisk = 2.
         IF prrisk > 20 AND prrisk <= 50 THEN grrisk = 3.
         IF prrisk > 50 AND prrisk < 100 THEN grrisk = 4.
         IF prrisk = 100 THEN grrisk = 5.
         
         /* Выводим строку таблицы */
         PUT UNFORMATTED 
                 "│" acct_main_no FORMAT "x(20)"
                 "│" client_name FORMAT "x(35)"
                 "│" ABS(acct_main_pos) FORMAT "->>>,>>>,>>9.99"
                 "│" acct_main_cur FORMAT "xxx"
                 "│" ABS(acct_main_pos_rur) FORMAT "->>>,>>>,>>9.99"
                 "│" grrisk FORMAT ">>"
                 "│" prrisk FORMAT ">>9.9" "%"
                 "│" ABS(acct_rsrv_calc_pos) FORMAT "->>>,>>>,>>9.99"
                 "│" ABS(acct_rsrv_real_pos) FORMAT "->>>,>>>,>>9.99"
                 "│" amt_create FORMAT "->>>,>>>,>>9.99"
                 "│" amt_delete FORMAT "->>>,>>>,>>9.99" 
                 "│" SKIP
                 "├────────────────────┼───────────────────────────────────┼───────────────┼───┼───────────────┼──┼──────┼───────────────┼───────────────┼───────────────┼───────────────┤" SKIP.

	/***** Маслов
	 *
	 * Выгрузка в архив *
	 *
	 ***********************/
	&IF DEFINED(arch2) &THEN
			   /*** Помечаем документы как отправленные ***/
			   UpdateSignsEx('opb',STRING(op.op),"PirA2346U",STRING(iCurrOut)).
	&ENDIF

END.

/* Выводим итоговые значения */
PUT UNFORMATTED 
                 "│       ИТОГО:       " 
                 "│" SPACE(35)
                 "│" ABS(total_pos_rur) FORMAT "->>>,>>>,>>9.99"
                 "│810"
                 "│" SPACE(15)
                 "│" SPACE(2)
                 "│" SPACE(6)
                 "│" ABS(total_calc_rsrv) FORMAT "->>>,>>>,>>9.99"
                 "│" ABS(total_real_rsrv) FORMAT "->>>,>>>,>>9.99"
                 "│" ABS(total_create_rsrv) FORMAT "->>>,>>>,>>9.99"
                 "│" ABS(total_delete_rsrv) FORMAT "->>>,>>>,>>9.99" 
                 "│" SKIP
          "│                    " 
                 "│" SPACE(35)
                 "│" ABS(total_pos_usd) FORMAT "->>>,>>>,>>9.99"
                 "│840"
                 "│" SPACE(15)
                 "│" SPACE(2)
                 "│" SPACE(6)
                 "│" SPACE(15)
                 "│" SPACE(15)
                 "│" SPACE(15)
                 "│" SPACE(15)
                 "│" SKIP
/* Может скоро понадобится 
                 "│                    " 
                 "│" SPACE(35)
                 "│" SPACE(25)
                 "│" ABS(total_pos_eur) FORMAT "->>>,>>>,>>9.99"
                 "│978"
                 "│" SPACE(15)
                 "│" SPACE(2)
                 "│" SPACE(4)
                 "│" SPACE(15)
                 "│" SPACE(15)
                 "│" SPACE(15)
                 "│" SPACE(15)
                 "│" SKIP
*/
                 "└────────────────────┴───────────────────────────────────┴───────────────┴───┴───────────────┴──┴──────┴───────────────┴───────────────┴───────────────┴───────────────┘" SKIP(4).

/* Подписи в подвале */

PUT UNFORMATTED PIRbos SPACE(100 - LENGTH(PIRbos)) PIRbosFIO SKIP(5).

FIND FIRST _user WHERE _user._userid EQ userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN DO:
        userPost = GetXAttrValueEx("_user", _user._userid, "Должность", "").
        PUT UNFORMATTED userPost FORMAT "x(100)" _user._user-name SKIP.
END.
ELSE
        PUT UNFORMATTED "Исполнитель:" SKIP.


/* Отображаем содержимое preview */
&IF DEFINED(arch2)=0 &THEN
{preview.i}
&ELSE
{preview.i &filename=cPath}
&ENDIF