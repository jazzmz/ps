/***************************************************
 *                                                                                               *
 *  Процедура контроля допустимости выполнения      *
 * приходной операции по депозитному договору.          *
 *                                                                                               *
 *                                                                                               *
 ***************************************************
 * Автор: Маслов Д. А.                                                         *
 * Дата создания: 15:46 01.09.2010                                      *
 * Заявка: #397                                                                       *
 **************************************************/
{globals.i}
{ulib.i}
{intrface.get debug}

/* Maslov D. A. Added By Event #505 */
&GLOBAL-DEFINE maskDepozAcctList397 !423*,!426*,42*

FUNCTION getPermitClose RETURNS INTEGER(INPUT cXAttrValue AS CHARACTER,INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE):

            /****************************************
             * Функция определяем срок договора и       *
             * затем возвращает количество дней            *
             *  до закрытия договора в течение                *
             *  которых запрещенно договор пополнять. *
            *****************************************/
        DEF VAR iDayDiff AS INTEGER.
        DEF VAR oSysClass AS TSysClass.
        
oSysClass = new TSysClass().

        IF cXAttrValue <> "" THEN
        DO:
                /* Установлен Доп. реквизит */
                 iDayDiff = INTEGER(cXAttrValue).
                /* 
                     В договоре наложены ограничения 
                     на пополнение вклада.
                */
          END. /* Конец доп реквизит установлен  */
           ELSE
                DO:

                            iDayDiff = dDateEnd - dDateBeg.

                            /* Определили какому временному интервалу принадлежит договор */
                            iDayDiff = oSysClass:getLineSegment(iDayDiff,"90,90,90,9999").

                           FIND FIRST code WHERE code.class EQ "PirPermitIn" AND code.val EQ STRING(iDayDiff) NO-LOCK NO-ERROR.

                            iDayDiff = INTEGER(code.code).
                END.  /* Конец не установлен доп. реквизит */

DELETE OBJECT oSysClass.

                RETURN iDayDiff.
END FUNCTION.

FUNCTION getDepozEndDate RETURNS DATE(INPUT cDogContract AS CHARACTER,INPUT cClassCode AS CHARACTER,INPUT cDogNum AS CHARACTER):
                            /**************************************
                             * Возвращает дату закрытия договора    *
                             **************************************/
DEF BUFFER bLoan-Cond FOR loan-cond.
DEF BUFFER bLoan FOR loan.

DEF VAR dDateEnd AS DATE INITIAL ?.                                    /* Дата окончания договора */

/* 
    Ни фига не знаю, где дата окончания договора хранится.
    Полагаю, что надо посмотреть доп. реквизит, и только потом
   посмотреть основной реквизит договора.
*/

  /* Нашли последнее условие по договору */
     FIND LAST bLoan-Cond WHERE bLoan-Cond.cont-code EQ cDogNum  AND bLoan-Cond.contract EQ cDogContract NO-LOCK NO-ERROR.
                IF NOT ERROR-STATUS:ERROR THEN
                     DO:                                
                            dDateEnd = DATE(getXAttrValue("loan-cond",bLoan-Cond.contract + "," + bLoan-Cond.cont-code + "," + STRING(bLoan-Cond.since),"CondEndDate")). 
                      END.

            IF dDateEnd EQ ? THEN
                    DO:
                            FIND FIRST bLoan WHERE bLoan.cont-code EQ cDogNum AND bLoan.contract EQ cDogContract AND bLoan.close-date EQ ?.
                            
                                        IF AVAILABLE(bLoan) THEN 
                                                DO:
                                                    dDateEnd = bLoan.end-date.                                
                                                END.
                    END.

             RETURN dDateEnd.
END FUNCTION.

FUNCTION getPermitDateByNum RETURNS DATE(INPUT cDogContract AS CHARACTER,INPUT cClassCode AS CHARACTER,INPUT cDogNum AS CHARACTER):

                                            /***********************************************
                                             *  Функция возвращает дату начиная с которой      *
                                             * запрещается пополнять вклад .                                 *
                                             ***********************************************/
/* Определяем локальные переменные */
DEF VAR dKIDBegPeriod AS DATE.                         /* Дата начального решения КИД */

DEF VAR dDateBeg AS DATE.                                   /* Дата начала договора */
DEF VAR dDateMiddle AS DATE.                              /* Дата начала ограничений */
DEF VAR dDateEnd AS DATE.                                    /* Дата окончания договора */
DEF VAR iDayDiff AS INTEGER.                               /* Количество дней до закрытия в течение которых вклад можно пополнять */

 
DEF VAR lResult AS LOGICAL INITIAL TRUE.     /* Результат работы функции по-умолчанию "разрешено пополнять" */
DEF VAR iDebugLevel AS INTEGER.                       /* Уровень отладки */
DEF VAR cExReq AS CHARACTER.                        /* Временная для хранения значения доп. реквизита */

dKIDBegPeriod = DATE(FGetSetting("ДатаНачКред",?,?)).
RUN GetLevel IN h_debug (OUTPUT iDebugLevel).

dDateMiddle = dKIDBegPeriod.


                        /* Счет принадлежит вкладу */
                       cExReq = GetXAttrValue("loan",cDogContract + "," + cDogNum,"PirPermitIn").
                       dDateBeg = DATE(getMainLoanAttr(cDogContract,cDogNum,"%ДатаНач")).

                       dDateEnd = getDepozEndDate(cDogContract,cClassCode,cDogNum).

                                          IF dDateEnd <> ? THEN  
                                                                    DO:
                                                                        iDayDiff = getPermitClose(cExReq,dDateBeg,dDateEnd).
                                                                        dDateMiddle = dDateEnd - iDayDiff.
                                                                    END.
                              RETURN dDateMiddle.
END FUNCTION.

FUNCTION getPermitDate RETURNS DATE(INPUT cAcct AS CHARACTER):

                                            /***********************************************
                                             *  Функция возвращает дату начиная с которой      *
                                             * запрещается пополнять вклад                                   *
                                             ***********************************************/

 /* Локализуем буфферы */
DEF BUFFER bLoan-Acct FOR loan-acct.

cAcct = REPLACE(cAcct,"-","").                                /* Убираем "-", чтоб по Copy/Paste удобно делать было */

FIND FIRST bLoan-Acct WHERE bLoan-Acct.acct = cAcct NO-LOCK NO-ERROR .

IF NOT ERROR-STATUS:ERROR THEN
  DO:
          /* Нашли связь счета и договора.  */
            RETURN getPermitDateByNum(bLoan-Acct.contract,"loan_attract",bLoan-Acct.cont-code).
   END. /* Конец привязка найдена */

   RETURN ?.
END FUNCTION.

FUNCTION isDepozInPermit RETURNS LOGICAL (INPUT cAcct AS CHARACTER,INPUT dOpDate AS DATE):

/*****************************************************
 *                                                                                                      *
 * Функция проверяет разрешено,                                           *
 * ли списание по договору                                                        *
 * в заданный временной период?                                            *
 *                                                                                                      *
 * Алгоритм:                                                                                   *
 *    1.  Находим связь Счет <--> Договор;                                *
 *    2. Ищем на договоре доп. реквизит PirPermitIn                *
 *  если этот доп. реквизит <> "пусто" и <> 0,                        *
 *  то из срока окончания вычитаем значение PirPermitIn.  *
 *   3. Если доп. реквизит = "пусто" или 0, то считаем,         *
 * что пополнять вклад можно в любое время;                      *
 *                                                                                                       *
********************************************************/
                            DEF VAR dDateMiddle AS DATE.

                              dDateMiddle = getPermitDate(cAcct).

                            IF dDateMiddle <> ? THEN
                                DO:

                                        IF dDateMiddle<=dOpDate THEN
                                           DO:
                                                 /*  Документ лежит в запрещенном
                                                       интервале и соответственно не может быть 
                                                       выполнен.
                                                */  
                                                 RETURN FALSE.
                                          END.
                                END.
                   RETURN TRUE.

END FUNCTION.