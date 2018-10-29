/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2002 ТОО "Банковские информационные системы"
     Filename: tr-db(l.p
      Comment: Субаналитка по договорам. (КредТ Требования по начисленным %%)
   Parameters: 
      Created: ??? ??/??/???? 
     Modified: Om  17/04/02 Ошибка: - создание операции на плановую дату,
                                    - форматирование кода.
     Modified: Илюха 30/10/02 избавление от явного присваивания констант значениям lr-st
                              см. svarloan.def массив может изменяться, а менять во всех
                              местах довольно тяжело
     Modified: 24/01/2003 Om Доработка: проверка операций по "течению".
     Modified: 31/03/2003 Om Доработка: если дата ОД не совпадает с плановой
                                        датой, то запрашивать подтверждение с
                                        возможностью скорректировать дату.
     Modified: 11/08/2003 Om Ошибка: Если плановая дата документа не совпадает
                                     с датой операционного дня, то производится
                                     запрос даты. После ввода, осуществляется
                                     проверка на то, что дата открытия договора
                                     меньше либо равна запрашиваемой.
     Modified: 20/01/2005 Илюха - полная переделка
                                  пока не стал сливать все процедуры аналитики
                                  в одну, хотя это очень сильно напрашивается
                                  дублирование кода ужасное, но как это сделать
                                  покрасивее пока не знаю

*/
Form "~n@(#) tr-cr(l.p 1.0 ??? ??/??/???? Om 07/04/2002 "
with frame sccs-id stream-io width 250.

{svarloan.def NEW GLOBAL}
{globals.i} /* Подключение глобальных переменных/инструментов сессии */
{pick-val.i}          /* Необходима для выбора договоров */
{intrface.get xclass} /* Загрузка инструментов по работе с метасхемой */
{intrface.get db2l}   /* Динамическая работа с БД  */
{intrface.get loan}   /* Инструменты для кредитов  */
{intrface.get lv}
{intrface.get rights} /* Проверка прав  */
{intrface.get tmess}  /* Служба сообщений */
{loanint.pro}         /* Процедуры работы с операциями по договору. */
{loankau.pro}         /* Процедуры для субаналитики по догвора. */

&GLOB isk '2,4,5'
/* список шаблонов кау, обрабатывающих кредитные и депозттные договора */
&GLOB shabl_kau 'АналДог,АналДогВ,КредТ,ДепТ'

&GLOB RET_ERR  DO: ~
                  ~{intrface.del~} ~
                  pick-value = 'NO'. ~
                  RETURN mRetErr. ~
               END.

&GLOB RET_OK   DO: ~
                  ~{intrface.del~} ~
                  pick-value = 'YES'. ~
                  RETURN. ~
               END.

DEF INPUT PARAM iRidEntry AS RECID NO-UNDO. /* Идентификатор проводки */
DEF INPUT PARAM iSide     AS LOG   NO-UNDO. /* */

DEF VAR mCh AS LOG INIT YES.

DEF VAR mCurDate   AS DATE  NO-UNDO.
DEF VAR mLoanSince AS DATE NO-UNDO.

DEF VAR mHOp       AS HANDLE NO-UNDO. /*Указатель на документ*/
DEF VAR mHEntry    AS HANDLE NO-UNDO. /*Указатель на проводку*/
DEF VAR mHAcct     AS HANDLE NO-UNDO. /*Указатель на счет проводки*/
DEF VAR mHCAcct    AS HANDLE NO-UNDO. /*Указатель на кор счет*/
DEF VAR mHLoanAcct AS HANDLE NO-UNDO. /*Указатель на связь счета и договора*/
DEF VAR mRidOp     AS RECID  NO-UNDO. /*recid документа */

DEF VAR mAcct     AS CHAR  NO-UNDO. /*Счет нашей стороны проводки */
DEF VAR mCurr     AS CHAR  NO-UNDO. /*Валюта счета нашней стороны проводки*/
DEF VAR mCorrAcct AS CHAR  NO-UNDO. /*Счет другой стороны*/
DEF VAR mCorrCurr AS CHAR  NO-UNDO. /*Валюта счет другой стороны*/
DEF VAR mCorrKau  AS CHAR  NO-UNDO. /*Кау счета другой стороны*/
DEF VAR mKauEnt   AS CHAR  NO-UNDO. /*Кау другой стороны проводки*/
DEF VAR mKau      AS CHAR  NO-UNDO. /*Кау нашей стороны проводки*/
DEF VAR mKauCalc  AS CHAR  NO-UNDO. 
DEF VAR mOpCode   AS CHAR  NO-UNDO.
DEF VAR mTStr     AS CHAR  NO-UNDO.
DEF VAR mList     AS CHAR  NO-UNDO.
DEF VAR mAcctSide AS CHAR  NO-UNDO.

DEF VAR mLastContract AS CHAR NO-UNDO. /* идентификатор договора */
DEF VAR mLastContCode AS CHAR NO-UNDO. /*    для привязки        */
DEF VAR mCodeInt      AS CHAR NO-UNDO. /* операция для привязки  */
DEF VAR mAutoLink     AS LOG  NO-UNDO. /* значение НП АвтПрив    */
DEF VAR mOperFlag     AS LOG  NO-UNDO. 
DEF VAR mSkipOper     AS LOG  NO-UNDO.
DEF VAR mRetErr       AS CHAR NO-UNDO.

/*kmy*/
DEFINE VARIABLE mAutoLinkCalc AS LOGICAL NO-UNDO.  
mAutoLinkCalc = CAN-DO("yes,true,ok,да", fGetSetting("АвтПривРасч", ?,"нет")).

DEF NEW SHARED STREAM err.

{loankau.us}
{loankau.ds}

/* Поиск  проводки, документа, счета, корреспондирующего счета */
RUN FindEntities(iRidEntry,
                 iSide,
                 OUTPUT mHOp,
                 OUTPUT mHEntry,
                 OUTPUT mHAcct,
                 OUTPUT mHCAcct,
                 OUTPUT mRidOp).

IF NOT VALID-HANDLE(mHOp)    OR
   NOT VALID-HANDLE(mHEntry) OR
   NOT VALID-HANDLE(mHAcct)  THEN
{&RET_OK}

ASSIGN
   mAcct     = GetValue(mHAcct,"acct")
   mCurr     = GetValue(mHAcct,"currency")
   mAcctSide = GetValue(mHAcct,"side")

   mKauEnt = GetValue(mHEntry,"kau-cr")  WHEN     iSide
   mKauEnt = GetValue(mHEntry,"kau-db")  WHEN NOT iSide

   mKau = GetValue(mHEntry,"kau-db")  WHEN     iSide
   mKau = GetValue(mHEntry,"kau-cr")  WHEN NOT iSide

   mCorrAcct = GetValue(mHCAcct,"acct")     WHEN VALID-HANDLE(mHCAcct)
   mCorrCurr = GetValue(mHCAcct,"currency") WHEN VALID-HANDLE(mHCAcct)
   mCorrKau  = GetValue(mHCAcct,"kau-id")   WHEN VALID-HANDLE(mHCAcct)

   mAutoLink = CAN-DO("yes,true,ok,да", fGetSetting("АвтПрив", ?,"нет")).
   .

/* Субаналитика уже создана */
IF {assigned mKau} THEN {&RET_OK}

/**
 * Если выполняется повторная привязка,
 * то ничего не делаем. Аналогичная
 * заявка в БИСе 0164291.
 *
 * Автор: Маслов Д. А. Maslov D. A.
 * Дата создания: 20.09.12
 * Заявка: #956
 *
 **/

IF VALID-HANDLE(mHCAcct) AND CAN-DO({&shabl_kau},mCorrKau) AND ({assigned mKauEnt}) AND CAN-DO(FGetSetting("ОпИскПовтАн","" ,""),ENTRY(3,mKauEnt)) THEN {&RET_OK}

/** КОНЕЦ #956 **/


/* Пользователь не создает субаналитику */
IF GetValue(mHEntry,"user-id") = "SERV" AND
   USERID("bisquit")           = "SERV"
THEN  {&RET_OK}

/* Определение даты операции. */
mCurDate = IF GetValue(mHEntry,"prev-year") = "YES"

           /* Если ЗО, то и операцию создаем на соответствующую дату */
           THEN DATE(12,31,YEAR(DATE(GetValue(mHOp,"op-date"))) - 1)

           /* Плановая дата документа */
           ELSE DATE(GetValue(mHOp,"contract-date")).

/* Ищем последнюю привязку счета */
RUN GetLastLinkAcctTr(mAcct,mCurr,mCurDate,mAcctSide,OUTPUT mHLoanAcct).

IF NOT VALID-HANDLE(mHLoanAcct) THEN {&RET_OK}

/* Данные нашего договорчика */
ASSIGN
   mLastContract = GetValue(mHLoanAcct,"contract")
   mLastContCode = GetValue(mHLoanAcct,"cont-code")
   mKauCalc  = ""
   mOpCode   = ""
   mSkipOper = NO
   .

/*kmy*/
IF mAutoLinkCalc THEN DO:
   mKauCalc = getAutoKau(mCurDate, iSide).
   IF mKauCalc <> ? THEN
      IF mKauCalc <> "" THEN
         IF NUM-ENTRIES(mKauCalc) = 3 THEN DO:
            mOpCode   = TRIM(ENTRY(3,mKauCalc)).
            IF mOpCode = "" THEN  mSkipOper = YES.
         END.
END.

IF mAutoLinkCalc AND mSkipOper THEN {&RET_OK}

/* Заполняем табличку со связями счета  с договорами */
RUN FillLocalTTRole(mAcct,mCurr,mCurDate,OUTPUT mList).
/* Заполняем табличку со связями ролей счетов  с операциями */
RUN FillLocalTTOper(mList,iSide,mOpCode).

/* Операции нет - ничего не делаем */
IF NOT CAN-FIND(FIRST ttOperRole) THEN {&RET_OK}

/* Если это полупроводка, то пробуем обработать как полноценный документ */
IF NOT VALID-HANDLE(mHCAcct) THEN
DO:
/* проверим можно ли собрать полную проводку? */
   RUN FindSecondOpEntry(mLastContract,
                         mLastContCode,
                         mCurDate,
                         iSide,
                         mHOp,
                  OUTPUT mOperFlag).
   IF mOperFlag THEN
   DO:
/* собственно ставим документ на аналитику. */
      RUN CrKauForFulOpEn(mLastContract,
                          mLastContCode,
                          mAcct,
                          mCurr,
                          mCurDate,
                          iSide,
                          mHOp,
                          mHEntry,
                   OUTPUT mOperFlag).
      IF mOperFlag THEN {&RET_OK}
   END.
END.

IF    NOT mAutoLink 
  AND work-module         NE "factor" THEN 
DO:
   RUN Fill-SysMes IN h_tmess("",
                              "",
                              "4",
                              "Возможна привязка проводки, "  +
                              (IF iSide 
                                  THEN "дебетующей счет " 
                                  ELSE "кредитующей счет " ) +
                              delFilFromAcct(mAcct) + "~n к " + (IF mLastContract = "Кредит"
                                                                    THEN "кредитному"
                                                                    ELSE "депозитному") +
                              " договору.Будете осуществлять?").

   IF LASTKEY = KEYCODE("Esc") THEN DO:
      mRetErr = "выполнение прервано по инициативе пользователя".
      {&RET_ERR}
   END.

   IF work-module = "factor" THEN 
      pick-value = "NO".

   IF pick-value NE "YES" THEN {&RET_OK}
END.

pick-value = "yes".

RUN ChkOpRights.

IF RETURN-VALUE = "EXIT" THEN DO:
   mRetErr = "недостаточно прав для выполнения операции".
   {&RET_ERR}
END.

/* Выбираем договор и операцию */
define variable mSkip as logical no-undo.
RUN InputLoan(INPUT-OUTPUT mLastContract,
              INPUT-OUTPUT mLastContCode,
              mCurDate,
              iSide,
              YES,
              OUTPUT mCodeInt,
              output mSkip).

if mSkip then /*не создавать суб.аналитическую проводку*/
do:
   pick-value = "yes".
   return.
end.

IF mLastContCode = "" THEN DO:
   mRetErr = "выполнение прервано по инициативе пользователя".
   {&RET_ERR}
END.

mLoanSince = DATE(GetBufferValue(
        "loan",
        "
        WHERE loan.contract = '" + mLastContract + "'
          AND loan.cont-code = '" + mLastContCode + "'",
        "since")).

pick-value = "yes".

/* Создание субаналитики */
IF IsBindEarlier(mCurDate,mLoanSince)
THEN DO TRANSACTION
   ON ERROR  UNDO, RETRY
   ON ENDKEY UNDO, RETRY:

   IF RETRY AND LASTKEY = KEYCODE("Esc") THEN
      mRetErr = "выполнение прервано по инициативе пользователя".
   IF RETRY THEN {&RET_ERR}

   /* Корректировка плановой даты и пересчет состояния должен происходить раньше 
      формирования сумм операции, иначе суммы будут сформированны на дату ДО пересчета,
      а не на плановую дату ( тем более скорректированную ) */

   /* Получение плановой даты операции */
   IF GetSysConf("DisplayOFF") EQ "YES" 
   THEN 
      RUN Fill-SysMes IN h_tmess ("", "", "", "Плановая дата: " + STRING(mCurDate,"99/99/9999") + ".").
   ELSE
      RUN UpdContract (mLastContract,    /* Назначение договора. */
                       mLastContCode,    /* Номер договора. */
                       mCurDate,         /* Плановая дата документа. */
                       mCodeInt,         /* Операция */
                       OUTPUT mCurDate). /* Верная дата документа. */

   /* Обработка ошибки. */
   IF RETURN-VALUE NE "" THEN 
   DO:
      mRetErr = RETURN-VALUE.
      UNDO, RETRY.
   END.

   /* Подтверждение ввода документа. */
   IF GetSysConf("DisplayOFF") NE "YES" 
   THEN DO:
   
      RUN ConfirmAction ( mRidOp,                 /* Идентификатор договора.  */
                          INPUT-OUTPUT mCurDate). /* Плановая дата документа. */

      /* Обработка ошибки. */
      IF RETURN-VALUE NE "" THEN
      DO:
         mRetErr = RETURN-VALUE.
         UNDO, RETRY.
      END.
   END.
   /* Корректировка плановой даты операции. */
   RUN SetLIntDate (mCurDate).

   /* Пересчет договора на подтвержденную плановую дату. */
   IF mCurDate <> mLoanSince THEN 
      RUN LoanCalc (mLastContract,    /* Назначение договора. */
                    mLastContCode,    /* Номер договора. */
                    mCurDate).        /* Плановая дата докеумента. */

   IF mCurDate <> DATE(GetBufferValue("loan","WHERE loan.contract = '" + mLastContract + "'
                                                AND loan.cont-code = '" + mLastContCode + "'",
                                      "since")) THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("","","","Дата проводки не равна дате пересчета состояния договора. При првязке возможны ошибки. Пересчитайте договор.").
      mRetErr = "no_mess".
      UNDO, RETRY.   
   END.
   /* И только теперь формируем данные по операции */

   /* Формирование перечня операци для создания.
   ** Определение суммы и валюты операций. */
   RUN GetOper (iRidEntry,      /* Идентификатор проводки. */
                mLastContract,  /* Назначение договора. */
                mLastContCode,  /* Номер договора. */
                mCurDate,       /* Плановая дата док-а. */
                mCodeInt,       /* Код вида операции. */
                YES).

   /* Обработка ошибки. */
   IF RETURN-VALUE NE ""
   THEN DO:
      MESSAGE
          COLOR MESSAGES
          RETURN-VALUE
      VIEW-AS ALERT-BOX.
      mRetErr = "no_mess".
      UNDO, RETRY.
   END.

   /* Вызов метода проверки операции из метасхемы.
   ** Делаем непосредственно перед созданием операции,
   ** что-бы проверки были после подтверждения суммы и плановой даты */
   RUN RunChkMethod (mLastContract,  /* Назначение договора. */
                     mLastContCode,  /* Номер договора. */
                     iRidEntry,  /* Идентификатор проводки. */
                     mCodeInt).  /* Код операции внесистемного учета. */

   /* Обработка ошибки. */
   IF RETURN-VALUE NE ""
   THEN DO:
      mRetErr = RETURN-VALUE.
      UNDO, RETRY.
   END.

   /* Создание операции. */
   RUN CreLInt (mLastContract,  /* Назначение договора. */
                mLastContCode). /* Номер договора. */

   /* Обработка ошибки. */
   IF RETURN-VALUE NE ""
   THEN DO:
      MESSAGE
          COLOR messages
          RETURN-VALUE.
      mRetErr = "no_mess".
      UNDO, RETRY.
   END.

   /* Создание субаналитики по проводке. */
   RUN CreEntryKau(iRidEntry, /* Идентификатор проводки. */
                   mLastContract,  /* Назначение договора. */
                   mLastContCode,  /* Номер договора. */
                   mCodeInt,   /* Код вида операции. */
                   NOT iSide,  /* Сторона счета Yes - кредит. */
                   mCurDate).  /* Верная плановая дата документа. */

   /* Обработка ошибки. */
   IF RETURN-VALUE NE ""
   THEN DO:
      IF RETURN-VALUE BEGINS "lock"
      THEN RUN wholock(IF RETURN-VALUE EQ "lock_op"
                       THEN mRidOp
                       ELSE iRidEntry, "").
      ELSE MESSAGE
              COLOR messages
              RETURN-VALUE
           VIEW-AS ALERT-BOX.                
      mRetErr = "".
      UNDO, RETRY.
   END.
   mRetErr = "".
END.
ELSE
DO:
   pick-value = "NO".
   mRetErr = "выполнение прервано по инициативе пользователя".
END.


{intrface.del}

RETURN  mRetErr.