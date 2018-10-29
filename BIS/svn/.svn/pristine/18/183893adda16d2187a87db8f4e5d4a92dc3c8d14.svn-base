/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2002 ТОО "Банковские информационные системы"
     Filename: tcg-tr.p
      Comment: Групповая обработка транзакций по картам
   Parameters:
         Uses:
      Used by:
      Created: 20.11.2005 mioa
     Modified: 31.01.2007 laav   (0069754)
*/

/******************************************************************************/
/*                                 DEFINE BLOCK                               */
/******************************************************************************/
/*            Вся эта куча инклюдов, переменных с жуткими названиями,
             таблиц, буферов и логов необходима для нормальной работы
                    любой уважающей себя старой транзакции                    */

DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
DEFINE INPUT PARAMETER iOpRID     AS RECID NO-UNDO.

&SCOPED-DEFINE ofsrch     0.
&SCOPED-DEFINE docontract 0.
&SCOPED-DEFINE col-lab    'ПЛАНОВАЯ ДАТА ЗАЧИСЛЕНИЯ'

{g-defs.i      }
{def-wf.i   new}
{defframe.i new}

{intrface.get oldpr}
{intrface.get db2l}
{intrface.get xclass}
{intrface.get card}
{intrface.get jloan}
{intrface.get instrum}
{intrface.get strng}
{intrface.get valid}
{intrface.get tmess}

{tmpobj.def}
{tmprecid.def}
{details.def}   /* Инструмент вызова парссерной обработки поля op.details */

/******************************** переменные **********************************/
/* Шаблоны */
DEFINE VAR vTemplList    AS CHAR    NO-UNDO INIT "".
DEFINE VAR vOpTemplList  AS CHAR    NO-UNDO INIT "".
/* Настройки транзакции */
DEFINE VAR vUserBrowse   AS LOGICAL NO-UNDO.
DEFINE VAR vSelectStatus AS CHAR    NO-UNDO.
DEFINE VAR vReportProc   AS CHAR    NO-UNDO.
DEFINE VAR vShowTempls   AS LOGICAL NO-UNDO.
DEFINE VAR vUserSozd     AS CHAR    NO-UNDO.
/* Типы договоров */
DEFINE VAR vContracts    AS CHAR    NO-UNDO INIT "card-pers,card-corp".
DEFINE VAR vContractNs   AS CHAR    NO-UNDO INIT "ДОГОВОРА НА ОБСЛУЖИВАНИЕ КАРТ ФИЗИЧЕСКИХ ЛИЦ,КОРПОРАТИВНЫЕ КАРТОЧНЫЕ ДОГОВОРА".
DEFINE VAR vObjID        AS CHAR    NO-UNDO. /* Переменная-идентификатор для генерации лога */
/* Счетчик */
DEFINE VAR vi            AS INTEGER NO-UNDO.
/* Даты */
DEFINE VAR vTmpDate      AS DATE    NO-UNDO.
DEFINE VAR cred          AS DATE    NO-UNDO INIT ?. /* Плановая дата */
DEFINE VAR dval          AS DATE    NO-UNDO.        /* Дата валютирования для использования в asswop.i */
/* Нумерация документов и проводок */
DEFINE VAR vDocNum       AS INTEGER NO-UNDO.
DEFINE VAR vDocNumStr    AS CHAR    NO-UNDO. /* Префикс для номера документа */
DEFINE VAR vOpEntryNum   AS INTEGER NO-UNDO INIT 0.
/* Генерация документов и проводок */
DEFINE VAR vConversion   AS LOGICAL NO-UNDO. /* Признак "документ конверсионный" */

DEFINE VAR vN            AS INTEGER NO-UNDO INIT 0.

DEFINE VAR rid1          AS RECID   EXTENT 30 NO-UNDO.
DEFINE VAR count-total   AS DECIMAL NO-UNDO.
DEFINE VAR in-contract   AS CHAR NO-UNDO.
DEFINE VAR in-cont-code  AS CHAR NO-UNDO.
DEFINE VAR vTmpOp        AS INTEGER NO-UNDO.
DEFINE VAR fler          AS LOGICAL NO-UNDO.
DEFINE VAR s-rub         LIKE op-entry.amt-rub EXTENT 30 NO-UNDO.
DEFINE VAR s-cur         LIKE op-entry.amt-cur EXTENT 30 NO-UNDO.
DEFINE VAR mKR           AS DECIMAL NO-UNDO. /*переменная для хранения значения курсовой разницы*/
DEFINE VAR mPositiveKr   AS LOGICAL NO-UNDO. /*признак положительной курсовой разницы*/
DEFINE VAR vIndexed      AS LOGICAL NO-UNDO.
DEFINE VAR vIndexed2     AS LOGICAL NO-UNDO.

DEFINE VAR mVar          AS CHAR    NO-UNDO. /* Тип расчета */
DEFINE VAR mAmtDiff      AS LOGICAL NO-UNDO. /* Признак "Суммы разные" */

DEFINE VAR mCurr2        AS CHAR    NO-UNDO. /* переменная для хранения валюты эквивалента */
DEFINE VAR mAmt1         AS DECIMAL NO-UNDO. /* Сумма из поля "Расчет суммы"       */
DEFINE VAR mAmt2         AS DECIMAL NO-UNDO. /* Сумма из поля "Расчет эквивалента" */

DEFINE VAR mAmtRub1      AS DECIMAL NO-UNDO. /*переменная для хранения рублевой суммы проводки*/
DEFINE VAR mAmtRub2      AS DECIMAL NO-UNDO. /*переменная для хранения рублевой суммы проводки*/
DEFINE VAR vSelectCodes  AS CHAR    NO-UNDO. /* список обрабатываемых транзакций ПЦ (ДР sel-codes класса card-k-tr) */
DEFINE VAR mStrError     AS CHAR    NO-UNDO. /* Переменные для обработки ошибок при расчете сумм */
DEFINE VAR mStrResult    AS CHAR    NO-UNDO. /* Переменные для обработки ошибок при расчете сумм */

/******************************* таблицы **************************************/
DEFINE BUFFER xop-entry  FOR op-entry.
DEFINE BUFFER xwop       FOR wop.
DEFINE BUFFER bb-code    FOR code.
DEFINE BUFFER b-pctr     FOR pc-trans.
DEFINE BUFFER b-acct-cr  FOR acct.
DEFINE BUFFER b-acct-db  FOR acct.
DEFINE BUFFER bc-acct    FOR acct. /* Буфер для использования в g-currv1.i */
DEFINE BUFFER card       FOR loan.
DEFINE BUFFER card-loan  FOR loan.
DEFINE BUFFER card-equip FOR loan.


/******************************** потоки **************************************/
DEFINE NEW GLOBAL SHARED STREAM err .
DEFINE STREAM err1.
DEFINE STREAM doc.

{g-currv1.i &OFbase="/*" &BYTrans}
/* Включение протокола ошибок */
{logg.i """Журнал ошибок при обработке транзакций"""}

vUserSozd = "PLASTIK". /* Добавил Кунташев В.Н. PIR*/

/******************************************************************************/
/*                               PREMAIN BLOCK                                */
/******************************************************************************/
/* Это тоже все для транзакции */
OUTPUT STREAM doc TO TERMINAL.

{g-frame3.i
   &op      = t-op
   &DoTable = yes
}
{g-frame3.i
   &DoFrame = YES
   &row     = 10
   &op      = t-op
}

FIND FIRST op-kind WHERE RECID(op-kind) = iOpRID NO-LOCK NO-ERROR.

RUN Init-SysMes IN h_tmess (op-kind.op-kind,"","").

cur-op-date   = in-op-date.
DebugParser   = INTEGER(GetXAttrValueEx('op-kind',op-kind.op-kind,'DebugParser',
                                        '0')).
vSelectStatus =         GetXAttrValueEx('op-kind',op-kind.op-kind,'sel-status',
                                        GetXAttrInit(op-kind.class-code, 'sel-status')).
vUserBrowse   = LOGICAL(GetXAttrValueEx('op-kind',op-kind.op-kind,'user-browse',
                                        GetXAttrInit(op-kind.class-code, 'user-browse')), 
                        'Да/Нет').
vReportProc   =         GetXAttrValueEx('op-kind',op-kind.op-kind,'report-proc',
                                        GetXAttrInit(op-kind.class-code, 'report-proc')).
vShowTempls   = LOGICAL(GetXAttrValueEx('op-kind',op-kind.op-kind,'show-templs',
                                        GetXAttrInit(op-kind.class-code, 'show-templs')), 
                        'Да/Нет').
vSelectCodes  =         GetXAttrValueEx('op-kind',op-kind.op-kind,'sel-codes',"*").

{setdest2.i &stream="stream err"  &cols=120 &filename=_spool.tmp }
{setdest2.i &stream="stream err1" &cols=120 &filename=_spool1.tmp}

vTemplList   = list-op-templ(op-kind.op-kind,"card").
vOpTemplList = list-op-templ(op-kind.op-kind,"op"  ).

/******************************************************************************/
/*                                 MAIN BLOCK                                 */
/******************************************************************************/
{plibinit.i &TransParsLibs=cardpars.p}

/******************************************************************************/
/* Фильтр для транзакций */
FOR EACH TmpObj:
 DELETE TmpObj.
END. 
FOR EACH tmprecid:
 DELETE tmprecid.
END. 

/* если значение ДР sel-codes не задано или "*", берем все возможные типы транзакций
** из классификатора op-int/ПЦ-ТРАНЗ */
IF vSelectCodes EQ "*" THEN
   FOR EACH code WHERE code.class   EQ "op-int"
                   AND code.parent  EQ "ПЦ-ТРАНЗ"
   NO-LOCK:
      {additem.i vSelectCodes code.code}
   END.

/* цикл по типам транзакций ПЦ */
DO vi = 1 TO NUM-ENTRIES(vSelectCodes):
   FOR EACH b-pctr WHERE b-pctr.pctr-status               EQ vSelectStatus
                     AND ENTRY(1,b-pctr.pctr-code,"~001") EQ ENTRY(vi,vSelectCodes) /* отбираем по типу транзакции */
   NO-LOCK:
     CREATE TmpObj.
     TmpObj.rid = RECID(b-pctr).
     CREATE tmprecid.
     tmprecid.id = RECID(b-pctr).
   END.
END.   

IF NOT CAN-FIND(FIRST TmpObj) THEN DO:
  MESSAGE "Нет ни одной транзакции статуса" vSelectStatus "для обработки" VIEW-AS ALERT-BOX.
  {plibdel.i}
  {intrface.del xclass}
  {intrface.del card}
  RETURN.
END. 

IF vUserBrowse THEN DO:
  RUN browseld.p ("pc-trans", "RidRest~001UseTmpObjInQuery", "YES~001" + STRING(mTmpObjHand), "", 2).
  IF LASTKEY <> 10 THEN DO:
    {plibdel.i}
    {intrface.del xclass}
    {intrface.del card}
    RETURN.
  END. 
END.

/******************************************************************************/
/* Создаем прототипы документов */
vi = 0.
FOR EACH op-templ OF op-kind
                  WHERE CAN-DO(vOpTemplList, STRING(op-template.op-template))
                  NO-LOCK BREAK BY op-templ.op-templ
                  ON ERROR  UNDO, RETURN
                  ON ENDKEY UNDO, RETURN:
   vi = vi + 1.
   CREATE t-op.
   ASSIGN
      t-op.op             = op-templ.op-templ
      t-op.doc-type       = op-templ.doc-type
      t-op.op-date        = in-op-date
      t-op.contract-date  = IF vi EQ 1 THEN in-op-date ELSE cred
      t-op.doc-date       = in-op-date
      t-op.details        = op-templ.details
      t-op.user-id        = vUserSozd
   .

   IF vShowTempls THEN DO:
      {g-frame3.i
         &DoBefore = YES
         &op       = t-op
      }
      {g-frame3.i
         &DoDisp   = YES
         &DoStream = YES
         &op       = t-op
      }
      {g-frame3.i
         &DoSet    = YES
         &op       = t-op
      }
   END.

   IF vi EQ 1 THEN cred = t-op.contract-date.

   IF vi EQ 1 AND t-op.doc-num NE '' AND t-op.doc-num NE ? THEN
   DO:
      vDocNum    = INTEGER(t-op.doc-num) NO-ERROR.
      vDocNumStr = IF ERROR-STATUS:ERROR THEN t-op.doc-num ELSE ''.
   END.
END.

vIndexed  = isXAttrIndexed("opb-card", "ТранзПЦ").
vIndexed2 = isXAttrIndexed("opb",      "CardStatus").

/******************************************************************************/
PUT STREAM err1 UNFORMATTED
    'Плановая дата ' STRING(cred) SKIP
    'Обработка транзакций ПЦ' SKIP(1).
/******************************************************************************/

/** Охватывающая логическая транзакция
	Создана buryagin.pirbank.ru
*/
MAIN_BLOCK: DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:

/* Обработка отобраных карт */
LIST_ITEM:
FOR EACH  tmprecid NO-LOCK,
    FIRST b-pctr   WHERE RECID(b-pctr) = tmprecid.id EXCLUSIVE-LOCK:
    
    /* Окружение для парсерных функций */
    SetEnv("pctr-id", STRING(b-pctr.pctr-id)).
    
    vObjID = "Tранзакция № " + ENTRY(1, b-pctr.pctr-code, "~001") + "(" + b-pctr.inpc-stan + "): ".

    vN = vN + 1.

    ASSIGN 
       b-pctr.pctr-status = "ОБР"
       b-pctr.proc-date   = cred
       b-pctr.proc-time   = TIME       WHEN cred EQ TODAY
       .
    
    /* Обрабатываем документы */
    OP_TEMPL:
    FOR EACH op-templ OF op-kind
                      WHERE CAN-DO(vOpTemplList, STRING(op-template.op-template))
                      NO-LOCK
                      ON ERROR  UNDO LIST_ITEM, LEAVE LIST_ITEM
                      ON ENDKEY UNDO LIST_ITEM, LEAVE LIST_ITEM:
       
       /* 0. Отсев неподходящих шаблонов
             если тип обрабатываемой транзакции ПЦ не принадлежит списку, указанному на ДР "ТипыТранз"
             шаблона документа, то пропускаем обработку шаблона для этой транзакции ПЦ */
       IF NOT CAN-DO(GetXAttrValueEx("op-template",
                                     op-template.op-kind + "," + STRING(op-template.op-template),
                                     "ТипыТранз",
                                     GetXAttrInit(op-template.Class-Code,"ТипыТранз")),
                     REPLACE(b-pctr.pctr-code, "~001",""))
       THEN NEXT OP_TEMPL.

       /* 0.1 Проверка прототипа документа */
       FIND FIRST t-op WHERE t-op.op EQ op-templ.op-templ NO-LOCK NO-ERROR.
       IF NOT AVAILABLE t-op THEN NEXT OP_TEMPL.
       
       /* 1. Создаем документ */
       CREATE op.
       {op(sess).cr}
       {g-op.ass}
       ASSIGN
          op.doc-type      = t-op.doc-type
          op.contract-date = t-op.contract-date
          /*op.doc-num     = vDocNumStr + STRING(vDocNum)*/
          vDocNum          = vDocNum + 1
          op.user-id       = vUserSozd
       .

       /* 2. Создаем и инициализируем проводку */
       FIND LAST xop-entry WHERE xop-entry.op EQ op.op NO-LOCK NO-ERROR.
       vOpEntryNum = IF AVAILABLE xop-entry THEN (xop-entry.op-entry + 1) ELSE 1.
       
       CREATE op-entry.
       {g-en.ass &ind=vOpEntryNum}
       ASSIGN
          op-entry.value-date = in-op-date
          op-entry.currency   = IF op-templ.currency <> ? THEN GetCurr(op-templ.currency) ELSE ""
          op-entry.user-id    = /* USERID('bisquit') */ vUserSozd
       .

       /* 3.0 запоминаем значение валюты эквивалента (от нее зависит - двухвалютный шаблон или одновалютный) */
       mCurr2 = GetCurr(GetXattrValueEx("op-template",
                                        op-templ.op-kind + "," + STRING(op-templ.op-template),
                                        "cur-eq", 
                                        ?)).
     
       IF mCurr2 EQ "810" 
          THEN mCurr2 = "".
       
    /* Добавил Кунташев PIR */
       IF not can-do ("840,978,",mCurr2)
           THEN mCurr2 = "840".
              
       /* 3. Заполняем таблицу wop */
       FOR EACH wop WHERE wop.op-templ >= op-templ.op-templ:
          DELETE wop.
       END.
  
       CREATE wop.
       ASSIGN
          wop.currency = op-entry.currency
          wop.op-kind  = op-kind.op-kind
          wop.op-templ = op-template.op-template
          wop.op-recid = RECID(op-entry)
          wop.con-date = op.contract-date
          
          dval         = op-entry.value-date
          cred         = op.contract-date
       .
       
       /* 4. Считаем суммы */
       IF (op-templ.prep-amt-rub    <> ? AND op-templ.prep-amt-rub    <> "") OR
          (op-templ.prep-amt-natcur <> ? AND op-templ.prep-amt-natcur <> "")
       THEN
       DO:
          {asswop.i}
          /*здесь нам понадобится менять op, берем себе права на него*/
          /*Чтобы не перерассчитывать много раз поле "details" будем проверять номер 
            текущего шаблона у транзакции. Если номер строго больше, чем у предыдущего, 
            то значит это еще первый вклад и надо рассчитывать.*/
          IF op-templ.op-template GT vTmpOp THEN
          DO:
            FIND CURRENT op EXCLUSIVE-LOCK NO-ERROR.
            RUN ProcessDetails (RECID(wop), INPUT-OUTPUT op.details).
            FIND CURRENT op NO-LOCK NO-ERROR. /* больше нам op менять не надо, убираем EXCLUSIVE-LOCK */
          END.
          
          
          /* 4.1 Первая сумма */
          IF op-templ.prep-amt-rub <> "" AND op-templ.prep-amt-rub <> ? THEN
          DO:
            RUN OldParsMain IN h_oldpr (RECID(wop),    
                                        wop.op-kind + "," + STRING(wop.op-templ),
                                        in-op-date,
                                        op-template.amt-rub,
                                        wop.prepf,
                                        op-template.op-template,
                                        INPUT-OUTPUT DebugParser,
                                        INPUT-OUTPUT sStop,
                                        OUTPUT mStrError,
                                        OUTPUT wop.amt-rub,
                                        OUTPUT mStrResult) NO-ERROR.
            IF mStrError NE "" THEN DO:
               MESSAGE "Проверьте: " + (IF mStrError EQ ? 
                                        THEN "?" 
                                        ELSE mStrError)
                   VIEW-AS ALERT-BOX ERROR.
                RUN logg.p(vLogFName,vObjID + "обнаружена ошибка в формуле шаблона " + 
                                     STRING(op-template.op-template) + " (" + op-template.amt-rub + ")").
                vShowLog = YES.
                UNDO LIST_ITEM, NEXT LIST_ITEM.
            END.
            mAmt1 = wop.amt-rub NO-ERROR.
          END.

          /* 4.2 Вторая сумма */
          IF op-templ.prep-amt-natcur <> "" AND op-templ.prep-amt-natcur <> ? THEN
          DO:

            RUN OldParsMain IN h_oldpr (RECID(wop),    
                                        wop.op-kind + "," + STRING(wop.op-templ),
                                        in-op-date,
                                        op-template.amt-rub,
                                        wop.prepnv,
                                        op-template.op-template,
                                        INPUT-OUTPUT DebugParser,
                                        INPUT-OUTPUT sStop,
                                        OUTPUT mStrError,
                                        OUTPUT wop.amt-rub,
                                        OUTPUT mStrResult) NO-ERROR.
            IF mStrError NE "" THEN DO:
               MESSAGE "Проверьте: " + (IF mStrError EQ ? 
                                        THEN "?" 
                                        ELSE mStrError)
                   VIEW-AS ALERT-BOX ERROR.
                RUN logg.p(vLogFName,vObjID + "обнаружена ошибка в формуле шаблона " + 
                                     STRING(op-template.op-template) + " (" + op-template.amt-natcur + ")").
                vShowLog = YES.
                UNDO LIST_ITEM, NEXT LIST_ITEM.
            END.
            mAmt2 = wop.amt-rub NO-ERROR.
          END.

       END.
       
       /* 5. Ищем счета */
       {g-acctv1.i
          &OFbase = YES
          &vacct  = tacct
       }
       
       IF tacct-cr EQ ? OR tacct-db EQ ? THEN
       DO:
          IF tacct-cr = ? THEN
             RUN logg.p(vLogFName,vObjID + "не найден счет кредита по шаблону " + 
                                  STRING(op-template.op-template) + " (" +  op-template.acct-cr + ")").
          IF tacct-db = ? THEN
             RUN logg.p(vLogFName,vObjID + "не найден счет дебета  по шаблону " +
                                  STRING(op-template.op-template) + " (" +  op-template.acct-db + ")").
          vShowLog = YES.
          UNDO LIST_ITEM, NEXT LIST_ITEM.
       END.
       
       /* 5.1 Проверка соответствия счетов валюте операции
              Валюта хотя бы одного из счетов обязана быть равна валюте операции */
       FIND FIRST b-acct-cr WHERE b-acct-cr.acct = tacct-cr NO-LOCK NO-ERROR.
       FIND FIRST b-acct-db WHERE b-acct-db.acct = tacct-db NO-LOCK NO-ERROR.
       IF NOT AVAILABLE b-acct-cr THEN DO:
          RUN logg.p(vLogFName,vObjID + "счет кредита с номером " + tacct-cr + " не найден в справочнике счетов").
          vShowLog = YES.
          UNDO LIST_ITEM, NEXT LIST_ITEM.
       END.
       IF NOT AVAILABLE b-acct-db THEN DO:
          RUN logg.p(vLogFName,vObjID + "счет дебета с номером " + tacct-db + " не найден в справочнике счетов").
          vShowLog = YES.
          UNDO LIST_ITEM, NEXT LIST_ITEM.
       END.
       
       IF b-acct-cr.currency <> wop.currency AND b-acct-db.currency <> wop.currency THEN DO:
          RUN logg.p(vLogFName,vObjID + "валюта хотя бы одного счетов должна быть равна " + wop.currency + "").
          vShowLog = YES.
          UNDO LIST_ITEM, NEXT LIST_ITEM.
       END.
       
       /* 6. Определяем способ расчета проводок (см. заявку 0069754, поле Подробности, а также прикрепленный exel-файл,
             расписывающий, какие проводки формируются в каждом случае)
             В условиях пользуемся тем, что валюта одного из счетов обязана быть равна валюте проводки
Варианты: mVar
3.1     mCurr2 <> ? AND wop.currency <> ""       AND mCurr2 <> "" AND wop.currency <> mCurr2
3.1.a   mCurr2 <> ? AND wop.currency <> ""       AND mCurr2 <> "" AND wop.currency =  mCurr2
3.2     mCurr2 <> ? AND wop.currency =  ""       AND mCurr2 =  "" 
3.3     mCurr2 <> ? AND wop.currency =  ""       AND mCurr2 <> "" 
3.4     mCurr2 <> ? AND wop.currency <> ""       AND mCurr2 =  "" 
4.1     mCurr2 =  ? AND b-acct-db.currency =  "" AND b-acct-cr.currency =  "" 
4.2     mCurr2 =  ? AND b-acct-db.currency <> "" AND b-acct-cr.currency <> "" AND b-acct-db.currency =  b-acct-cr.currency
4.3.1   mCurr2 =  ? AND b-acct-db.currency <> "" AND b-acct-cr.currency <> "" AND b-acct-db.currency <> b-acct-cr.currency AND b-acct-db.currency = wop.currency
4.3.2   mCurr2 =  ? AND b-acct-db.currency <> "" AND b-acct-cr.currency <> "" AND b-acct-db.currency <> b-acct-cr.currency AND b-acct-cr.currency = wop.currency
4.4.1   mCurr2 =  ? AND b-acct-db.currency =  "" AND b-acct-cr.currency <> "" AND wop.currency = ""
4.4.3   mCurr2 =  ? AND b-acct-db.currency =  "" AND b-acct-cr.currency <> "" AND wop.currency <> ""
4.4.2   mCurr2 =  ? AND b-acct-db.currency <> "" AND b-acct-cr.currency =  "" AND wop.currency = ""
4.4.4   mCurr2 =  ? AND b-acct-db.currency <> "" AND b-acct-cr.currency =  "" AND wop.currency <> ""
Признак "Суммы разные" mAmtDiff:
3.1   TRUE
4.3.1 TRUE
4.3.2 TRUE
4.1   FALSE
4.2   FALSE
4.4.3 FALSE
4.4.4 FALSE
3.1.a mAmt1 <> mAmt2
3.2   mAmt1 <> mAmt2
3.3   ПЕРЕСЧЕТ(mAmt2, mCurr2, "")       <> mAmt1
3.4   ПЕРЕСЧЕТ(mAmt1, wop.currency, "") <> mAmt2
4.4.1 ПЕРЕСЧЕТ(  ПЕРЕСЧЕТ(mAmt1, "", b-acct-cr.currency),   b-acct-cr.currency,    "" ) <> mAmt1
4.4.2 ПЕРЕСЧЕТ(  ПЕРЕСЧЕТ(mAmt1, "", b-acct-db.currency),   b-acct-db.currency,    "" ) <> mAmt1
              */
              
       mVar = IF mCurr2 <> ? THEN 
              (   
                  IF      wop.currency <> "" AND mCurr2 <> "" AND wop.currency <> mCurr2                        THEN "3.1"
                  ELSE IF wop.currency <> "" AND mCurr2 <> "" AND wop.currency =  mCurr2                        THEN "3.1.a"
                  ELSE IF wop.currency =  "" AND mCurr2 =  ""                                                   THEN "3.2"
                  ELSE IF wop.currency =  "" AND mCurr2 <> ""                                                   THEN "3.3"
                  ELSE /* wop.currency <> "" AND mCurr2 =  "" */                                                     "3.4"
              )
              ELSE /* mCurr2 =  ? */
              (
                  IF      b-acct-db.currency =  "" AND b-acct-cr.currency =  ""                                 THEN "4.1"
                  ELSE IF b-acct-db.currency <> "" AND b-acct-cr.currency <> "" THEN
                  (
                      IF      b-acct-db.currency =  b-acct-cr.currency                                          THEN "4.2"
                      ELSE IF b-acct-db.currency <> b-acct-cr.currency AND b-acct-db.currency = wop.currency    THEN "4.3.1"
                      ELSE /* b-acct-db.currency <> b-acct-cr.currency AND b-acct-cr.currency = wop.currency */      "4.3.2"
                  )
                  ELSE IF b-acct-db.currency =  "" AND b-acct-cr.currency <> "" THEN 
                  (
                      IF wop.currency = ""                                                                      THEN "4.4.1"
                      ELSE                                                                                           "4.4.3"
                  )
                  ELSE
                  (
                      IF wop.currency = ""                                                                      THEN "4.4.2"
                      ELSE                                                                                           "4.4.4"
                  )
                  
              ).
/* message "100"    mCurr2  "200"  wop.currency  "300"  mVar "mAmt1"    mAmt1 "mAmt2"    mAmt2. pause.           */         
       /* 6.1 Определяем, разные рублевые суммы получаются или нет? (это же является признаком - есть вторая проводка или нет) */
       mAmtDiff = IF      mVar = "3.1"   OR 
                          mVar = "4.3.1" OR 
                          mVar = "4.3.2"       THEN TRUE
                  ELSE IF mVar = "4.1"   OR 
                          mVar = "4.2"   OR 
                          mVar = "4.4.3" OR 
                          mVar = "4.4.4"       THEN FALSE
                  ELSE IF mVar = "3.1.a" OR 
                          mVar = "3.2"         THEN mAmt1 <> mAmt2
                  ELSE IF mVar = "3.3"         THEN FALSE /* CurToCurWork("Учетный", mCurr2, "", op.op-date, mAmt2)       <> mAmt1 */  /* Исправил Кунташев PIR для того чтобы поменялась корреспонденция*/
                  ELSE IF mVar = "3.4"         THEN FALSE /* CurToCurWork("Учетный", wop.currency, "", op.op-date, mAmt1) <> mAmt2 */  /* Добавил Кунташев PIR */
                  ELSE IF mVar = "4.4.1"       THEN CurToCurWork("Учетный", b-acct-cr.currency, "", op.op-date, CurToCurWork("Учетный", "", b-acct-cr.currency, op.op-date, mAmt1)) <> mAmt1
                  ELSE /*mVar = "4.4.2" */          CurToCurWork("Учетный", b-acct-db.currency, "", op.op-date, CurToCurWork("Учетный", "", b-acct-db.currency, op.op-date, mAmt1)) <> mAmt1
                  .

       /* 7. Заполняем первую проводку */
       ASSIGN
          op-entry.acct-db  = tacct-db
          op-entry.acct-cr  = IF mAmtDiff THEN ? ELSE tacct-cr
          op-entry.currency = IF      mVar = "3.1"   OR mVar = "3.1.a" OR mVar = "3.4"   OR 
                                      mVar = "4.2"   OR mVar = "4.3.1" OR mVar = "4.4.3" OR mVar = "4.4.4" THEN wop.currency
                              ELSE IF mVar = "3.2"   OR mVar = "4.1"                                       THEN ""
                              ELSE IF mVar = "4.3.2" OR mVar = "4.4.2"                                     THEN b-acct-db.currency
                              ELSE IF mVar = "3.3"                                                         THEN IF mAmtDiff THEN "" ELSE mCurr2
                              ELSE /* mVar = "4.4.1" */                                                         IF mAmtDiff THEN "" ELSE b-acct-cr.currency
       .
       ASSIGN
          op-entry.amt-cur  = IF      mVar = "3.1"   OR mVar = "3.1.a" OR mVar = "3.4"   OR 
                                      mVar = "4.2"   OR mVar = "4.3.1" OR mVar = "4.4.3" OR mVar = "4.4.4" THEN mAmt1
                              ELSE IF mVar = "3.2"   OR mVar = "4.1"                                       THEN 0
                              ELSE IF mVar = "3.3"                                                         THEN IF mAmtDiff THEN 0 ELSE mAmt2
                              ELSE IF mVar = "4.3.2"                                                       THEN CurToCurWork("Учетный", wop.currency, b-acct-db.currency, op.op-date, mAmt1)
                              ELSE IF mVar = "4.4.1"                                                       THEN IF mAmtDiff THEN 0
                                                                                                                ELSE CurToCurWork("Учетный", "", b-acct-cr.currency, op.op-date, mAmt1)
                              ELSE /* mVar = "4.4.2" */                                                         CurToCurWork("Учетный", "", b-acct-db.currency, op.op-date, mAmt1)

          op-entry.amt-rub  = IF      mVar = "3.2"   OR mVar = "3.3"   OR mVar = "4.1"   OR mVar = "4.4.1" THEN mAmt1
                              ELSE IF mVar = "3.1"   OR mVar = "3.1.a" OR mVar = "4.3.2"                   THEN CurToCurWork("Учетный", op-entry.currency, "", op.op-date, op-entry.amt-cur)
                              ELSE IF mVar = "4.2"   OR mVar = "4.3.1" OR mVar = "4.4.3" OR mVar = "4.4.4" THEN IF op-templ.prep-amt-natcur <> "" AND op-templ.prep-amt-natcur <> ? THEN mAmt2 
                                                                                                                ELSE CurToCurWork("Учетный", op-entry.currency, "", op.op-date, op-entry.amt-cur)
                              ELSE IF mVar = "3.4"                                                         THEN IF mAmtDiff THEN CurToCurWork("Учетный", op-entry.currency, "", op.op-date, op-entry.amt-cur)
                                                                                                                ELSE mAmt2
                              ELSE /* mVar = "4.4.2" */                                                         IF mAmtDiff THEN CurToCurWork("Учетный", op-entry.currency, "", op.op-date, op-entry.amt-cur)
                                                                                                                ELSE mAmt1
       .

       /* Запомним сумму первой проводки; пока не доказано обратное - будем считать, что и вторая проводка имеет ту же сумму */
       mAmtRub1 = op-entry.amt-rub.
       mAmtRub2 = op-entry.amt-rub.

       /* 7.1 Проверка 1й проводки */
       IF op-entry.amt-rub NE 0 OR op-entry.amt-cur NE 0 THEN
       DO:
          vWasErr = YES.
          tr0:
          DO:
             {op-entry.upd
                 &871=yes
                 &Ofnext="/*"
                 &undo="leave tr0"
                 &open-undo="leave tr0"
                 &kau-undo="leave tr0 "
                 &offopupd="/*"
             }
             vWasErr = NO.
          END.
          IF vWasErr THEN
          DO:
             RUN logg.p(vLogFName,vObjID + "обнаружена ошибка при проведении операции по счетам").
             vShowLog = YES.
             UNDO LIST_ITEM, NEXT LIST_ITEM.
          END.
       END.
       ELSE
       DO:
          RUN logg.p(vLogFName,vObjID + "нулевая сумма").
          vShowLog = YES.
          UNDO OP_TEMPL, NEXT OP_TEMPL.
       END.
       
       /* 7.2. Устанавливаем допреквизиты PARSSEN_ */
       {g-psigns.i}

       /* 8. Вторая ПОЛУпроводка: создается, если суммы разные */
       IF mAmtDiff THEN DO:
          FIND LAST xop-entry WHERE xop-entry.op EQ op.op NO-LOCK NO-ERROR.
          vOpEntryNum = IF AVAILABLE xop-entry THEN (xop-entry.op-entry + 1) ELSE 1.
          
          CREATE op-entry.
          {g-en.ass &ind=vOpEntryNum}


          ASSIGN
             op-entry.value-date = in-op-date
             op-entry.op-date    = in-op-date
             op-entry.user-id    = /* USERID('bisquit') */ vUserSozd
             
             op-entry.acct-cr    = tacct-cr
             op-entry.acct-db    = ?
             op-entry.currency   = IF      mVar = "3.1"   OR mVar = "3.1.a" OR mVar = "3.3"   THEN mCurr2
                                   ELSE IF mVar = "3.2"   OR mVar = "3.4"   OR mVar = "4.4.2" THEN ""
                                   ELSE IF mVar = "4.3.1" OR mVar = "4.4.1"                   THEN b-acct-cr.currency
                                   ELSE                                                            wop.currency
             
          .
          ASSIGN
             op-entry.amt-cur    = IF      mVar = "3.1"   OR mVar = "3.1.a" OR mVar = "3.3"   THEN mAmt2
                                   ELSE IF mVar = "3.2"   OR mVar = "3.4"   OR mVar = "4.4.2" THEN 0
                                   ELSE IF mVar = "4.3.1"                                     THEN CurToCurWork("Учетный", wop.currency, op-entry.currency, op.op-date, mAmt1)
                                   ELSE IF mVar = "4.3.2"                                     THEN mAmt1
                                   ELSE                                                            CurToCurWork("Учетный", "", op-entry.currency, op.op-date, mAmt1)
             op-entry.amt-rub    = IF      mVar = "3.2"   OR mVar = "3.4"                     THEN mAmt2
                                   ELSE IF mVar = "4.4.2"                                     THEN mAmt1
                                   ELSE IF mVar = "4.3.2"                                     THEN IF op-templ.prep-amt-natcur <> "" AND op-templ.prep-amt-natcur <> ? THEN mAmt2 
                                                                                                   ELSE CurToCurWork("Учетный", op-entry.currency, "", op.op-date, op-entry.amt-cur)
                                   ELSE                                                            CurToCurWork("Учетный", op-entry.currency, "", op.op-date, op-entry.amt-cur)
          .

          /* Запоминаем сумму второй проводки */
          mAmtRub2  = op-entry.amt-rub.

          /* 8.1 Проверка второй полупроводки */
          IF op-entry.amt-rub NE 0 OR op-entry.amt-cur NE 0 THEN
          DO:
             vWasErr = YES.
             tr0:
             DO:
                {op-entry.upd
                    &871=yes 
                    &Ofnext="/*"
                    &open-undo="leave tr0" 
                    &kau-undo="leave tr0 " 
                    &offopupd="/*"
                }
                vWasErr = NO.
             END.
             IF vWasErr THEN
             DO:
                RUN logg.p(vLogFName,vObjID + "обнаружена ошибка при проведении операции по счетам").
                vShowLog = YES.
                UNDO LIST_ITEM, NEXT LIST_ITEM.
             END.
          END.
          ELSE
          DO:
             RUN logg.p(vLogFName,vObjID + "нулевая сумма").
             vShowLog = YES.
             UNDO OP_TEMPL, NEXT OP_TEMPL.
          END.
       END.

       /* 8.2. Устанавливаем допреквизиты PARSSEN_ */
       {g-psigns.i}
       
       /* 9. Третья ПОЛУпроводка: курсовые разницы */
       mKR = mAmtRub1 - mAmtRub2. /* Курсовая разница = первая проводка - вторая проводка */
       
        /* Добавил Кунташев PIR */
       IF  mVar = "3.4" then 
       DO:
       mKR = CurToCurWork("Учетный", wop.currency, "", op.op-date, mAmt1) - mAmtRub1.
       END.
     
       IF  mVar = "3.3" then 
       DO:
       mKR =  mAmtRub2 - CurToCurWork("Учетный", mCurr2, "", op.op-date, mAmt2).
       END.
       
/* message "600"   mAmtRub1 "2"   mAmtRub2 "3" CurToCurWork("Учетный", wop.currency, "", op.op-date, mAmt1) "4" CurToCurWork("Учетный", mCurr2, "", op.op-date, mAmt2) mKR.    */

       IF mKR <> 0 THEN DO:

         mPositiveKR = mKR > 0.

         FIND LAST xop-entry WHERE xop-entry.op EQ op.op NO-LOCK NO-ERROR.
         vOpEntryNum = IF AVAILABLE xop-entry THEN (xop-entry.op-entry + 1) ELSE 1.
         
         CREATE op-entry.
         {g-en.ass &ind=vOpEntryNum}
         ASSIGN
            op-entry.value-date = in-op-date
            op-entry.op-date    = in-op-date
            op-entry.user-id    = /* USERID('bisquit') */ vUserSozd

            op-entry.currency   = IF  (mVar = "3.4" or mVar = "3.3") and substr(tacct-db,6,3) eq "810" then substr(tacct-cr,6,3) ELSE IF (mVar = "3.4" or mVar = "3.3") and substr(tacct-cr,6,3) eq "810" then substr(tacct-db,6,3) ELSE "" /* Всегда рубли */
            op-entry.amt-cur    = 0
            op-entry.amt-rub    = ABSOLUTE(mKR)
         .
       
        /* Исправил Кунташев PIR */
         op-entry.acct-db = IF substr(tacct-db,6,3) eq "810" and mKR > 0 then  tacct-cr else IF substr(tacct-cr,6,3) eq "810" and mKR > 0 then  tacct-db else if mPositiveKR THEN ?  ELSE FGetSetting("Счета","СчетОтрКР","").
         op-entry.acct-cr = IF substr(tacct-db,6,3) eq "810" and mKR < 0 then  tacct-cr else IF substr(tacct-cr,6,3) eq "810" and mKR < 0 then  tacct-db else IF mPositiveKR THEN FGetSetting("Счета","СчетПолКР","") ELSE ?.
            
         /* 9.1 Проверка третьей проводки */
         IF op-entry.amt-rub NE 0 OR op-entry.amt-cur NE 0 THEN
         DO:
            vWasErr = YES.
            tr0:
            DO:
               {op-entry.upd
                   &871=yes 
                   &Ofnext="/*"
                   &open-undo="leave tr0" 
                   &kau-undo="leave tr0 " 
                   &offopupd="/*"
               }
               vWasErr = NO.
            END.
            IF vWasErr THEN
            DO:
               RUN logg.p(vLogFName,vObjID + "обнаружена ошибка при проведении операции по счетам").
               vShowLog = YES.
                UNDO LIST_ITEM, NEXT LIST_ITEM.
            END.
         END.
         ELSE
         DO:
            RUN logg.p(vLogFName,vObjID + "нулевая сумма").
            vShowLog = YES.
            UNDO OP_TEMPL, NEXT OP_TEMPL.
         END.
       END. 

       /* 9.2. Устанавливаем допреквизиты PARSSEN_ */
       {g-psigns.i}
       
       /* N. Постобработка */
       IF AVAILABLE op-entry THEN DO:
          /* Допреквизиты для проводки */
          UpdateSigns("op", GetSurrogateBuffer("op", (BUFFER op:HANDLE)), 
                      "ТранзПЦ", STRING(b-pctr.pctr-id), vIndexed).
          UpdateSigns("op", GetSurrogateBuffer("op", (BUFFER op:HANDLE)), 
                      "CardStatus", "НО", vIndexed2).
                    
                      
          /* Зачем-то запоминаем суммы */
          ASSIGN
             s-rub[op-templ.op-templ] = s-rub[op-templ.op-templ] +
                                        op-entry.amt-rub
             s-cur[op-templ.op-templ] = s-cur[op-templ.op-templ] +
                                        op-entry.amt-cur
          .

          /* Если на транзакции настроен параметр op_code - создаем для него операцию */
          IF GetXAttrValueEx("op-template", op-template.op-kind + "," + 
                             STRING(op-template.op-template), "op_code", "") <> "" THEN DO:
            CREATE op-int.
            ASSIGN 
              op-int.class-code    = GetXAttrValueEx("op-template", op-template.op-kind + "," + 
                                     STRING(op-template.op-template), "op_code", "")
              op-int.op-int-status = CHR(251)
            .
            
            ASSIGN
              op-int.op-int-code   = GetXAttrInit(op-int.class-code, "op-int-code")
              op-int.create-date   = in-op-date
              op-int.cont-date     = op.contract-date
  
              op-int.file-name     = "pc-trans"
              op-int.surrogate     = STRING(b-pctr.pctr-id)
              
              op-int.par-int[1]    = op-entry.op
              op-int.par-int[2]    = op-entry.op-entry
            .
          END.
          
          /* Печать итогов зачисления */
          PUT STREAM err1 UNFORMATTED
              ENTRY(1, b-pctr.pctr-code, "~001") + "(" + b-pctr.inpc-stan + ")" AT 1
              tacct-cr      AT 32
              STRING(wop.amt-rub, '>>,>>>,>>>,>>9.99') AT 54
              SKIP.
       END.

    END. /* Цикл по шаблонам документов */
END. /* Цикл по транзакциям */

/** проверяем остались ли необработанные транзакции */
DO vi = 1 TO NUM-ENTRIES(vSelectCodes):
   FOR EACH b-pctr WHERE b-pctr.pctr-status               EQ vSelectStatus
                     AND ENTRY(1,b-pctr.pctr-code,"~001") EQ ENTRY(vi,vSelectCodes) /* отбираем по типу транзакции */
   NO-LOCK:
   		RUN logg.p(vLogFName,"ОШИБКА!!! Найдены необработанные транзакции ПЦ! Все изменения откатываются!").
   		vShowLog = YES.
	   	UNDO MAIN_BLOCK, LEAVE MAIN_BLOCK.
   END.
END.   


END. /** охватывающая логическая транзакция */
/******************************************************************************/
/*
/* Печать итогов зачисления */
PUT STREAM err1 UNFORMATTED
   SKIP(1)
   'Итого зачислено:' AT 1
    STRING(s-rub[1],'>>,>>>,>>>,>>9.99')  AT 44
    SKIP.
*/

{preview2.i
   &stream   = "stream err1"
   &filename = _spool1.tmp
}

/* Ведомость ошибок */
IF vShowLog THEN
DO:
   {preview.i
      &filename = vLogFName      
      &nodef    = "/*"
   }
END.

RUN End-SysMes IN h_tmess.

OUTPUT STREAM err  CLOSE.
OUTPUT STREAM err1 CLOSE.
OUTPUT STREAM doc  CLOSE.

{plibdel.i}
{intrface.del xclass}
{intrface.del card}
RETURN.
