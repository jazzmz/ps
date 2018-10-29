
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: NALPL_ED.P
      Comment: Форма редактирования и просмотра реквизитов налоговых
               платежей по реквизитам документа
   Parameters: iOpRid - указатель на документ
               iView  - тип редактирования
                  0 - просмотр реквизитов (если есть)
                  1 - штатное редактирование (со всеми проверками)
                  2 - ручной запуск - обязательный показ формы
         Uses:
      Used by:
      Created: 24.04.2003 16:09 SEMA
     Modified: 29.04.2003 17:21 SEMA     по заявке 0015363 создание файла
     Modified: 05.05.2003 15:59 SEMA     по заявке 0015363 исправлено дублирование символа в поле kpp-send, исправлена
                                         ошибка вызова формы в ручной режиме
     Modified: 05.05.2003 17:49 SEMA     по заявке 0015363 исправление логики обработки проводки
     Modified: 06.05.2003 14:21 SEMA     по заявке 0015363 вставлена проверка полей в конце фрейма
     Modified: 06.05.2003 17:54 SEMA     по заявке 0015363 изменено определение счета получателя, в качестве инструментов
                                         используется инклдюдник pp-uni.prg
     Modified: 13.05.2003 11:57 SEMA
                                         по заявке 0015363
                                         а) теперь не ругаемся на отсутствие проводки (в постановке на картотеку важно) а
                                         просто выходим
                                         б) исправлен выбор КПП при "контроле на наличие значений" в случае уже
                                         установленного значения (раньше всегда бралось первое из списка)
     Modified: 28.05.2003 15:01 KAVI     16806 проверка на значение в поле 109
     Modified: 30.05.2003       Илюха    16506,17122
     Modified: 27.05.2003 15:54 kolal    Доработан контроль поля 107 - можно вводить "0".
                                         Заявка 16512.
     Modified: 03.06.2003 11:07 kolal    Доработан контроль поля 107 - можно вводить
                                         дату. Заявка 16512.
     MODIFIED: 23/06/2003 KOSTIK         17375 Добавлено определение КПП получателя при внутреннем платеже.
     Modified: 03.07.2003 15:02 kolal    Отредактирован текст сообщений о незаполненных
                                         полях. Заявка 16454.
     Modified: 03.07.2003 15:04 kolal    16454
     Modified: 29.07.2003 ilvi           Исправлена синтаксическая ошибка
     Modified: 04.08.2003 GORM           (з. 18327) В форму подставляются значения по умолчанию для реквизитов
                                         ПокОП (106) и ПокТП (110).
     Modified: 08.09.2003 18:30 YUSS     17992 - если поле 101 не вводят,то все signs не создаются
                                               - исправлено с полного контроля на контроль на наличие значений
     Modified: 10.09.2003 18:30 YUSS     17252 - поле 107 и 109
     Modified: 22.10.2003 14:53 rija     17194 - 1256 Доработать ввод поля (107) "Налоговый период".
     Modified: 23.10.2003 ilvi          (16790)- Добавлена возможность заполнения поле (103) из справочника
     Modified: 12.11.2003 12:53 rija     17194 - 1256 Доработать ввод поля (107) "Налоговый период".
     Modified: 27.11.2003 18:53 rija     0017194 - 1256 Доработать ввод поля (107) "Налоговый
                                         период".
     Modified: 01.12.2003 11:40 rija     17194 - 1256 Доработать ввод поля (107) "Налоговый период".
                                         БЕСПОЛЕЗНАЯ И НЕНУЖНАЯ ПРОВЕРКА, ПРОВЕРЯЕТСЯ ЧУТЬ ПОЗЖЕ
     Modified: 26.12.2003 kraw (0017064) Заполнение КПП и ОКАТО из оргструктуры
     Modified: 29.01.2004 16:53 kolal    Доп. обработка поля (110). Заявка 17137.
     Modified: 03.03.2004 13:08 kolal    При отсутствии реквизита ОКАТО-НАЛОГ на клиенте
                                         при потоковом вводе копируется предыдущее
                                         значение. Заявка 19106.
     Modified: 03.03.2004 13:13 kolal    19106
     Modified: 02.12.2004 kraw (0035669) Увеличение КБК с 19 до 20 знаков
     Modified: 28.01.2005 kraw (0042270) Заполнение ДР "п106н_СтатПлат"
     Modified: 
*/

/* ******** Входные параметры ******** */
/* iOpRid - указатель на документ */
DEFINE INPUT  PARAMETER iOpRid AS RECID      NO-UNDO.
/* iView - тип редактирования
                  0 - просмотр реквизитов (если есть)
                  1 - обязательный просмотр реквизитов (даже если нет)
                  2 - штатное редактирование (со всеми проверками)
                  3 - ручной запуск - обязательный показ формы              */
DEFINE INPUT  PARAMETER iView  AS INTEGER    NO-UNDO.
/* уровень фрейма на экране */
DEFINE INPUT  PARAMETER level AS INTEGER    NO-UNDO.

DEFINE VARIABLE mEmpty AS LOGICAL NO-UNDO.

/** pirbank added */
DEFINE VARIABLE choiceDbl AS LOGICAL NO-UNDO.
DEFINE VARIABLE mDoubleEnter AS LOGICAL NO-UNDO.
DEFINE  VARIABLE tmpKBK  AS CHARACTER NO-UNDO.
DEFINE  VARIABLE tmpOKATO  AS CHARACTER NO-UNDO.
DEFINE  VARIABLE tmpKPPs AS CHARACTER NO-UNDO.
DEFINE  VARIABLE tmpKPPr AS CHARACTER NO-UNDO.
DEFINE  VARIABLE tmpPokOP AS CHARACTER NO-UNDO.
DEFINE  VARIABLE tmpPokNP1 AS CHARACTER NO-UNDO.
DEFINE  VARIABLE tmpPokND AS CHARACTER NO-UNDO.
DEFINE  VARIABLE tmpPokTP AS CHARACTER NO-UNDO.
DEFINE  VARIABLE tmpPokDD AS CHARACTER NO-UNDO.

DEFINE VARIABLE mKppFromBen AS CHARACTER NO-UNDO.
/** pirbank end */


/* ******** Объявление переменных ******** */
&GLOBAL-DEFINE ViewOnly iView EQ 0 OR iView EQ 1
&GLOBAL-DEFINE ViewOnlyIfExist iView EQ 0
&GLOBAL-DEFINE ManualRun iView EQ 3

&GLOBAL-DEFINE NOT_IN_TRANS          YES
&GLOBAL-DEFINE ENABLE_EDIT_KPP       YES
&GLOBAL-DEFINE ALWAYS_SHOW_KPP_LIST  YES

{globals.i}
{intrface.get xclass}
{intrface.get cust}
{intrface.get strng}
{pp-uni.var &FILE_sword_p=YES} /* определение переменных для pp-uni.prg */
{pp-uni.prg &NEW_1256=YES}     /* процедуры определения параметров платежного требования */

DEFINE BUFFER acct-b1 FOR acct.
DEFINE BUFFER DbAcct  FOR acct.

/* допреквизит Kpp-send КПП плательщика                  (102) */
DEFINE  VARIABLE mKppSend      AS CHARACTER NO-UNDO.
/* допреквизит Kpp-rec  КПП получателя.                  (103) */
DEFINE  VARIABLE mKppRec       AS CHARACTER NO-UNDO.

/* допреквизит "Период" для контроля по классификатору "Нал:НП" (107) */
DEFINE VARIABLE mChkPokNP      AS LOGICAL   NO-UNDO.
DEFINE  VARIABLE mPokNP1       AS CHARACTER NO-UNDO.
/* допреквизит "Период" для указания даты (107) */
DEFINE  VARIABLE mPokNP2       AS CHARACTER NO-UNDO.
DEFINE  VARIABLE mPokNP3       AS CHARACTER NO-UNDO.

DEFINE  VARIABLE mTypePokDD    AS CHARACTER NO-UNDO.
DEFINE  VARIABLE mFormatPokDD  AS CHARACTER NO-UNDO.

/* переменные для показа расшифровки значений */
DEFINE VARIABLE vVal        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mPokSTLabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mKBKLabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mPokOPLabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mPokNPLabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mPokTPLabel AS CHARACTER  NO-UNDO.

DEFINE VARIABLE mBalNalog AS CHARACTER  NO-UNDO. /* маска счетов из настроечного параметра "bal-nalog" */
DEFINE VARIABLE mCRDNP    AS CHARACTER  NO-UNDO. /* маска кодов документа из настроечного параметра "КРДНП" */

DEFINE VARIABLE mIsFullControlInput AS LOGICAL    NO-UNDO. /* Полный контроль/Контроль на наличие значений */
DEFINE VARIABLE mConstControl       AS LOGICAL    NO-UNDO. /* Всегда контролировать ввод НР на обязательность ввода */
     
DEFINE VARIABLE mClassFieldList AS CHARACTER  NO-UNDO. /* список переменных, обрабатываемых классификаторами */
DEFINE VARIABLE mClassCodeList AS CHARACTER  NO-UNDO. /* список классификаторов для контроля значений */

DEFINE VARIABLE mKppSendAllowSelect AS LOGICAL    NO-UNDO. /* позволяется ли выбор значений в поле КПП-Плательщика ? */
DEFINE VARIABLE mKppSendSensitive   AS LOGICAL    NO-UNDO. /* можно ли вообще редактировать mKppSend */
DEFINE VARIABLE mKppRecSensitive    AS LOGICAL    NO-UNDO. /* можно ли вообще редактировать mKppRec */
DEFINE VARIABLE mOKATOSensitive     AS LOGICAL    NO-UNDO. /* можно ли вообще редактировать mOKATO */
DEFINE VARIABLE mKppSendValues      AS CHARACTER  NO-UNDO. /* список значений для выбора в поле КПП-Плательщика */

DEFINE VARIABLE mKppRecAllowSelect  AS LOGICAL    NO-UNDO. /* позволяется ли выбор значений в поле КПП-Плательщика ? */
DEFINE VARIABLE mKppRecValues       AS CHARACTER  NO-UNDO. /* список значений для выбора в поле КПП-Плательщика */

DEFINE VARIABLE mS AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSelectKppRec AS CHAR NO-UNDO.

DEFINE VARIABLE mOKATOAllowSelect AS LOG  NO-UNDO. /*возможность редактирования
                                                     поля ОКАТО*/
DEFINE VARIABLE mOKATOValues      AS CHAR NO-UNDO. /*список значений ОКАТО*/
DEFINE VARIABLE mAnotherFieldList AS CHAR NO-UNDO. /*дополнительный список
                                                 полей, обрабатываемых по F1 */
DEFINE VARIABLE mAcctDbFlag       AS LOG  NO-UNDO. /* = да если счет дебета
                                                   внутрибанковский */

DEFINE VARIABLE m106n_stat_plat AS CHARACTER NO-UNDO.
mConstControl = fGetSetting ("ГНИ", "ВводНР", "") EQ "Да".

{ kppproc.i
    &BUF-OP-ENTRY = op-entry
    &BUF-OP       = op
}

{conf_op.i}
{kpp_rec.i}

ASSIGN
   mDoubleEnter      = iView EQ 99
   mClassFieldList   = "mPokST,mKBK,mPokOp,mPokNP1,mPokTP"
   mClassCodeList    = "ПокСт,КБК,Нал:ОП,Нал:НП,Нал:ВП"
/*   mAnotherFieldList = "mKppSend,mKppRec,mOKATO"*/
   mTypePokDD        = GetXAttrEx("opb",'ПокДД','Data-Type')
   mFormatPokDD      = GetXAttrEx("opb",'ПокДД','Data-Format')
.

IF NOT (mFormatPokDD = "" OR
        mFormatPokDD = "x(10)" OR
        mFormatPokDD = "xx.xx.xxxx" ) THEN
   MESSAGE "Формат поля 'Дата (109)' : " + mFormatPokDD SKIP
           "заменен на x(10)         " SKIP (1)
           "Формат должен быть:      " SKIP
           " - пустым                " SKIP
           " - x(10)                 " SKIP
           " - xx.xx.xxxx            " SKIP (1)
           "Измените формат реквизита: " SKIP
           "ПокДД - Показатель даты документа " SKIP
           "в метасхеме opb - Балансовые документы" SKIP
   VIEW-AS ALERT-BOX INFORMATION.

/* ******** Объявление формы ******** */
FORM
   "Статус составителя (101):" mPokST FORMAT "xx" HELP "Нажмите F1 для выбора из классификатора" mPokSTLabel AT 39 FORMAT "x(40)" SKIP(1)
   "   КПП плательщика (102):" mKppSend FORMAT "x(9)" SKIP
   "    КПП получателя (103):" mKppRec  FORMAT "x(9)" SKIP(1)
   "      КБК (104):" mKBK FORMAT "x(20)" HELP "Нажмите F1 для выбора из классификатора" mKBKLabel   AT 39 FORMAT "x(40)" SKIP
   "    ОКАТО (105):" mOKATO FORMAT "x(11)" SKIP
   "Основание (106):" mPokOP FORMAT "xx" HELP "Нажмите F1 для выбора из классификатора" mPokOPLabel AT 39 FORMAT "x(40)" SKIP
   "   Период (107):" mPokNP1 FORMAT "x(10)" HELP "Нажмите F1 для выбора из классификатора"
                      mPokNPLabel AT 39 FORMAT "x(40)" SKIP
   "    Номер (108):" mPokND FORMAT "x(15)" SKIP
   "     Дата (109):" mPokDD /* формат берется из формата доп.реквизита */ SKIP
   "      Тип (110):" mPokTP FORMAT "xx" HELP "Нажмите F1 для выбора из классификатора" mPokTPLabel AT 39 FORMAT "x(40)" SKIP
   WITH FRAME NalPr-frame
   TITLE COLOR bright-white "[ Реквизиты налоговых платежей ]"
   ROW level
   CENTERED NO-LABELS
   OVERLAY.

mPokDD:FORMAT = IF mFormatPokDD = "xx.xx.xxxx" THEN mFormatPokDD ELSE "x(10)".

ON "GO" OF FRAME NalPr-Frame DO:

   DEFINE VARIABLE vS AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vI AS INTEGER    NO-UNDO.
   
   ASSIGN
      mPokNP1
      mPokNP = mPokNP1
      mPokDD
   .

   IF NOT mEmpty THEN
   DO:

      IF mPokNP <> "0"
      THEN DO:
         vS = GetCode ("Нал:НП", ENTRY(1,mPokNp1,".")).
         mChkPokNP = INDEX(mPokNp1,".") > 0.
         IF mChkPokNP THEN DO:
            ASSIGN
               mPokNP2 = ENTRY(2,mPokNp1,".")
               mPokNP3 = ""
               mPokNP3 = ENTRY(3,mPokNp1,".") WHEN NUM-ENTRIES(mPokNp1,".") GT 2
            .
         END.
         IF vS EQ ? THEN
         DO: /* значения поля нет в классификаторе - это должна быть дата*/
            IF mChkPokNP THEN DO:
               vS = STRING(DATE(mPokNP1),"99.99.9999") NO-ERROR.
               IF ERROR-STATUS:ERROR
                  OR vS EQ ""
                  OR vS EQ ? THEN
               DO:
                  MESSAGE "Неправильно введена дата налогового периода !"
                     VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                  APPLY "ENTRY" TO mPokNP1.
                  RETURN NO-APPLY.
               END.
            END.
         END.
         ELSE
         DO:

            vI = INTEGER(mPokNP2) NO-ERROR.
            IF ERROR-STATUS:ERROR
               OR vI < 0
               OR vI > INTEGER(vS) THEN
            DO:
               MESSAGE "Значение должно быть от 00 по " + STRING(INTEGER(vS),"99")
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
               APPLY "ENTRY" TO mPokNP1.
               RETURN NO-APPLY.
            END.

            IF LENGTH(mPokNP3) <> 4 THEN
            DO:
               MESSAGE "Формат поля должен быть ГГГГ"
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
               APPLY "ENTRY" TO mPokNP1.
               RETURN NO-APPLY.
            END.

            vI = INTEGER(mPokNP3) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
               MESSAGE "Неправильно введен год"
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
               APPLY "ENTRY" TO mPokNP1.
               RETURN NO-APPLY.
            END.
         END.

      IF mPokDD NE "0" AND
         NOT {&ManualRun}
      THEN DO:
         ASSIGN
            vS = STRING(DATE(mPokDD),"99.99.9999") NO-ERROR.

         IF ERROR-STATUS:ERROR
            OR vS EQ ""
            OR vS EQ ? THEN
         DO:
            MESSAGE "Неправильно введена дата" skip
                    "Формат поля должен быть ДД.ММ.ГГГГ"
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "ENTRY" TO mPokDD.
            RETURN NO-APPLY.
         END.
         ELSE
            mPokDD = vS.
      END.

      ASSIGN
         mPokST
         mKppSend
         mKppRec
         mKBK
         mOKATO
         mPokOP
         mPokND
         mPokTP
         mPokNP = mPokNP1
      .

      /* если это не запуск в ручную - то все поля должны быть заполнены */
      IF NOT {&ManualRun} THEN DO:
         vS = "".

         IF mPokST EQ ? OR
            mPokST EQ "" THEN DO:
            vS = vS + "Не заполнено поле ""Статус составителя (101)"".~n".
         END.
         IF ((mKppSend    EQ ? OR
              mKppSend    EQ "") AND
             mKppSend:SENSITIVE) THEN DO:
            vS = vS + "Не заполнено поле ""КПП плательщика (102)"".~n".
         END.
         IF mKppRec       EQ ? OR
            mKppRec       EQ ""  THEN DO:
            vS = vS + "Не заполнено поле ""КПП получателя (103)"".~n".
         END.
         IF ((mKBK        EQ ? OR
              mKBK        EQ "") AND
             mKBK:SENSITIVE) THEN DO:
            vS = vS + "Не заполнено поле ""КБК (104)"".~n".
         END.
         IF ((mOKATO EQ ? OR
              mOKATO EQ "") AND
             mOKATO:SENSITIVE) THEN DO:
            vS = vS + "Не заполнено поле ""ОКАТО (105)"".~n".
         END.
         IF mPokOP        EQ ? OR
            mPokOP        EQ "" THEN DO:
            vS = vS + "Не заполнено поле ""Основание (106)"".~n".
         END.
         IF mPokNP        EQ ? OR
            mPokNP        EQ "" THEN DO:
            vS = vS + "Не заполнено поле ""Период (107)"".~n".
         END.
         IF mPokND        EQ ? OR
            mPokND        EQ "" THEN DO:
            vS = vS + "Не заполнено поле ""Номер (108)"".~n".
         END.
         IF mPokDD        EQ ? OR
            mPokDD        EQ "" THEN DO:
            vS = vS + "Не заполнено поле ""Дата (109)"".~n".
         END.
         IF mPokTP        EQ ? OR
            mPokTP        EQ "" THEN DO:
            vS = vS + "Не заполнено поле ""Тип (110)"".~n".
         END.
         IF vS NE "" THEN DO:
            MESSAGE vS "Все поля должны быть заполнены."
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN NO-APPLY.
         END.
      END.
   END.
END.
END.

/** pirbank added */
ON LEAVE OF mKPPRec IN FRAME NalPr-Frame DO:
   ASSIGN mKPPRec.
   IF mDoubleEnter THEN DO:
      IF tmpKPPr NE mKPPRec THEN DO:
         MESSAGE "Не совпадает КПП получателя с начальным документом. В документе указано " + tmpKPPr + "!  Продолжить?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE choiceDbl.
         IF NOT choiceDbl THEN RETURN NO-APPLY.
      END.
   END.
END.

ON LEAVE OF mKPPSend IN FRAME NalPr-Frame DO:
   ASSIGN mKPPSend.
   IF mDoubleEnter THEN DO:
      IF tmpKPPs NE mKPPSend THEN DO:
         MESSAGE "Не совпадает КПП отправителя с начальным документом. В документе указано " + tmpKPPs + "!  Продолжить?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE choiceDbl.
         IF NOT choiceDbl THEN RETURN NO-APPLY.
      END.
   END.
END.

ON LEAVE OF mKBK IN FRAME NalPr-Frame DO:
   ASSIGN mKBK.
   IF mDoubleEnter THEN DO:
      IF tmpKBK NE mKBK THEN DO:
         MESSAGE "Не совпадает КБК с начальным документом. В документе указано " + tmpKBK + "!  Продолжить?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE choiceDbl.
         IF NOT choiceDbl THEN RETURN NO-APPLY.
      END.
   END.
END.

ON LEAVE OF mKBK IN FRAME NalPr-Frame DO:
   ASSIGN mKBK.
   IF mDoubleEnter THEN DO:
      IF tmpKBK NE mKBK THEN DO:
         MESSAGE "Не совпадает КБК с начальным документом. В документе указано " + tmpKBK + "!  Продолжить?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE choiceDbl.
         IF NOT choiceDbl THEN RETURN NO-APPLY.
      END.
   END.
END.


ON LEAVE OF mOKATO IN FRAME NalPr-Frame DO:
   ASSIGN mOKATO.
   IF mDoubleEnter THEN DO:
      IF tmpOKATO NE mOKATO THEN DO:
         MESSAGE "Не совпадает ОКАТО с начальным документом. В документе указано " + tmpOKATO + "!  Продолжить?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE choiceDbl.
         IF NOT choiceDbl THEN RETURN NO-APPLY.
      END.
   END.
END.

ON LEAVE OF mPokOP IN FRAME NalPr-Frame DO:
   ASSIGN mPokOP.
   IF mDoubleEnter THEN DO:
      IF tmpPokOP NE mPokOP THEN DO:
         MESSAGE "Не совпадает Основание (106) с начальным документом. В документе указано " + tmpPokOP + "!  Продолжить?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE choiceDbl.
         IF NOT choiceDbl THEN RETURN NO-APPLY.
      END.
   END.
END.

ON LEAVE OF mPokNP1 IN FRAME NalPr-Frame DO:
   ASSIGN mPokNP1.
   IF mDoubleEnter THEN DO:
      IF tmpPokNP1 NE mPokNP1 THEN DO:
         MESSAGE "Не совпадает Период (107) с начальным документом. В документе указано " + tmpPokNP1 + "!  Продолжить?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE choiceDbl.
         IF NOT choiceDbl THEN RETURN NO-APPLY.
      END.
   END.
END.

ON LEAVE OF mPokND IN FRAME NalPr-Frame DO:
   ASSIGN mPokND.
   IF mDoubleEnter THEN DO:
      IF tmpPokND NE mPokND THEN DO:
         MESSAGE "Не совпадает Номер (108) с начальным документом. В документе указано " + tmpPokND + "!  Продолжить?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE choiceDbl.
         IF NOT choiceDbl THEN RETURN NO-APPLY.
      END.
   END.
END.

ON LEAVE OF mPokDD IN FRAME NalPr-Frame DO:
   ASSIGN mPokDD.
   IF mDoubleEnter THEN DO:
      IF tmpPokDD NE mPokDD THEN DO:
         MESSAGE "Не совпадает Дата (109) с начальным документом. В документе указано " + tmpPokDD + "!  Продолжить?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE choiceDbl.
         IF NOT choiceDbl THEN RETURN NO-APPLY.
      END.
   END.
END.

ON LEAVE OF mPokTP IN FRAME NalPr-Frame DO:
   ASSIGN mPokTP.
   IF mDoubleEnter THEN DO:
      IF tmpPokTP NE mPokTP THEN DO:
         MESSAGE "Не совпадает Тип (110) с начальным документом. В документе указано " + tmpPokTP + "!  Продолжить?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE choiceDbl.
         IF NOT choiceDbl THEN RETURN NO-APPLY.
      END.
   END.
END.




/** pirbank end */








ON "leave" OF FRAME NalPr-Frame ANYWHERE DO:

   DEFINE VARIABLE vS AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vI AS INTEGER    NO-UNDO.
   DEFINE VARIABLE vMonthLimit AS INTEGER NO-UNDO.

   &IF DEFINED(SESSION-REMOTE) &THEN
      IF LASTKEY = KEYCODE("F1") THEN RETURN.
   &ENDIF

   /* если это не запуск в ручную - то все поля должны быть заполнены */

   IF NOT {&ManualRun} THEN DO:
      IF FRAME-FIELD EQ "mPokST"
        	 AND NOT mIsFullControlInput
         AND FRAME-VALUE EQ "" THEN
      DO:
         IF mConstControl THEN
             mEmpty = NO.         
         ELSE
            MESSAGE "Вы действительно хотите оставить все поля пустыми?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                UPDATE mEmpty.
         IF mEmpty THEN
         DO:
            APPLY "GO".
            RETURN.
         END.
      END.
      ELSE
         mEmpty = NO.

   END.


   ASSIGN
      mPokST
      mKppSend
      mKppRec
      mKBK
      mOKATO
      mPokOP
      mPokNP1
      mPokND
      mPokDD
      mPokTP
      .

   vI = LOOKUP(FRAME-FIELD, mClassFieldList).

   IF vI > 0 THEN DO:
      vval = FRAME-VALUE.
      IF FRAME-FIELD = "mPokNP1" THEN DO:
         vS = GetCode (ENTRY(vI, mClassCodeList), ENTRY(1,vVal,".")).
         mChkPokNP = INDEX(vVal,".") > 0.
         IF mChkPokNP THEN DO:
            ASSIGN
               mPokNP2 = ENTRY(2,vVal,".")
               mPokNP3 = ""
               mPokNP3 = ENTRY(3,vVal,".") WHEN NUM-ENTRIES(vVal,".") GT 2
            .
         END.
      END.
      ELSE
         vS = GetCode (ENTRY(vI, mClassCodeList), vVal).

      /* Если это 1-я часть поля 107 "Налоговый период", то оно может
         содержать 0 или число */
      IF FRAME-FIELD = "mPokNP1" THEN
      DO:
         IF INDEX(vVal,".") > 0 AND vS EQ ? THEN DO:
            vI = INTEGER(ENTRY(1,mPokNP1,".")) NO-ERROR.
            IF ERROR-STATUS:ERROR
               OR vI < 0
               OR vI > 31 THEN
            DO:
               MESSAGE "Значением поля может быть день (включая 0)" SKIP
                       "или значение классификатора 'Нал:НП' !"
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
               RETURN NO-APPLY.
            END.
         END.


      END.
      /* если "полный контроль" то сверяем каждое поле c доменом */
      ELSE IF mIsFullControlInput THEN DO:
         IF vS EQ ? THEN DO: /* значения поля нет в классификаторе */
            MESSAGE "Нет такого значения в классификаторе: '" + ENTRY(vI, mClassCodeList) + "' !"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN NO-APPLY.
         END.
      END.
   END.
   RUN FillLabelFields.
   RUN DispFrame.

   IF FRAME-FIELD = "mPokNP1"
      AND mChkPokNP THEN
   DO:
      IF LENGTH(mPokNP2) <> 2 THEN
      DO:
         MESSAGE "Не правильно задан месяц"
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         RETURN NO-APPLY.
      END.
      vS = GetCode ("Нал:НП", ENTRY(1,mPokNP1,".")).
      IF vS = ? THEN vS = "12". /* месяц */

      vI = INTEGER(mPokNP2) NO-ERROR.
      IF ERROR-STATUS:ERROR
         OR vI < 0
         OR vI > INTEGER(vS) THEN
      DO:
         MESSAGE "Значение месяца должно быть от 00 по " + STRING(INTEGER(vS),"99")
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         RETURN NO-APPLY.
      END.
   END.

   IF FRAME-FIELD = "mPokNP1"
      AND mChkPokNP THEN
   DO:
      IF LENGTH(mPokNP3) <> 4 THEN
      DO:
         MESSAGE "Не правильно задан год"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         RETURN NO-APPLY.
      END.

      vS = GetCode ("Нал:НП", ENTRY(1,mPokNP1,".")).
      IF vS EQ ? THEN
      DO: /* значения поля нет в классификаторе - это должна быть дата*/
         vS = STRING(DATE(mPokNP1)) NO-ERROR.
         IF ERROR-STATUS:ERROR
            AND (vS NE ""
            OR vS NE ?) THEN
         DO:
            MESSAGE "Неправильно введена дата налогового периода !"
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "ENTRY" TO mPokNP1.
            RETURN NO-APPLY.
         END.
      END.
      ELSE
      DO:
         vI = INTEGER(mPokNP3) NO-ERROR.
         IF ERROR-STATUS:ERROR THEN
         DO:
            MESSAGE "Неправильно введен год"
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN NO-APPLY.
         END.
      END.
      RUN DispFrame.
   END.
/* Отдельно тестируем формат mPokDD - должен быть дд.мм.гггг или 0*/
   IF FRAME-FIELD = "mPokDD" THEN
   DO:
      IF mPokDD NE "0" THEN
      DO:
         ASSIGN
            vS = STRING(DATE(mPokDD),"99.99.9999") NO-ERROR.
         IF ERROR-STATUS:ERROR
            OR vS EQ ""
            OR vS EQ ? THEN
         DO:
            MESSAGE "Неправильно введена дата" skip
                    "Формат поля должен быть ДД.ММ.ГГГГ"
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN NO-APPLY.
         END.
         IF INDEX(mFormatPokDD,".") = 0 THEN
            ASSIGN
               mPokDD = STRING(DATE(mPokDD),"99.99.9999").
      END.
      RUN DispFrame.
   END.
END.

ON 'F1':U OF FRAME NalPr-Frame ANYWHERE DO:
   DEFINE VARIABLE vS  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vS1 AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vS2 AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vI  AS INTEGER   NO-UNDO.

   vI = LOOKUP(FRAME-FIELD, mClassFieldList + "," + mAnotherFieldList ).
   IF vI EQ 0 THEN RETURN NO-APPLY. /* чтобы не звучала на остальных полях */

   IF LOOKUP(FRAME-FIELD,mClassFieldList) <> 0 THEN
   DO WITH FRAME NalPr-Frame:
      vS = GetCodeName ("", ENTRY(vI, mClassCodeList)).
      IF vS NE ? THEN DO:
         vS1 = GetCodeMisc("", ENTRY(vI, mClassCodeList), 3).
         IF vS1 <> "" THEN
            IF SearchPFile(vS1) <> ? THEN
            DO:
               vS2 = GetCode("КБК", mKBK).
               IF mIsFullControlInput 
                  AND vS2 NE ""
                  AND ENTRY(vI, mClassFieldList) EQ "mPokTP" THEN
                  RUN SetSysConf IN h_base ("WhereCanDo", vS2).
               RUN VALUE(vS1 + ".p") (ENTRY(vI, mClassCodeList),
                                      ENTRY(vI, mClassCodeList),
                                      vS,
                                      4).
               RUN SetSysConf IN h_base ("WhereCanDo", ?).
            END.
            ELSE DO:
               MESSAGE "Не могу найти процедуру просмотра."
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
               RETURN NO-APPLY.
            END.
         ELSE
            RUN pclass.p (ENTRY(vI, mClassCodeList),
                          ENTRY(vI, mClassCodeList),
                          vS,
                          4).
         IF (LASTKEY EQ 13 OR LASTKEY EQ 10) AND pick-value NE ? THEN DO:
            IF ENTRY(vI, mClassFieldList) EQ "mPokNP1" THEN
               SELF:SCREEN-VALUE = IF pick-value NE "0" 
                                   THEN (pick-value + ".")
                                   ELSE pick-value.
            ELSE
               SELF:SCREEN-VALUE = pick-value.
         END.
      END.
      ELSE
         MESSAGE "Нет такого классификатора: '" + ENTRY(vI, mClassCodeList) + "' !"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   END.
   ELSE
   DO:
      pick-value = ?.
/*      IF FRAME-FIELD = "mKppSend" AND
         mKppSendAllowSelect      AND
         mIsFullControlInput      THEN
      DO:
         RUN messmenu.p(10 ,"[ВЫБЕРИТЕ КПП ПЛАТЕЛЬЩИКА]","",mKppSendValues).
         IF (LASTKEY EQ 13 OR LASTKEY EQ 10) AND pick-value NE ? THEN
            SELF:SCREEN-VALUE = ENTRY(INT(pick-value),mKppSendValues).
      END. */  

      IF FRAME-FIELD = "mKppRec" AND
         mKppRecAllowSelect      THEN
      DO:

         RUN messmenu.p(10 ,"[ВЫБЕРИТЕ КПП ПОЛУЧАТЕЛЯ]","",mKppRecValues).
         IF (LASTKEY EQ 13 OR LASTKEY EQ 10) AND pick-value NE ? THEN
            SELF:SCREEN-VALUE = ENTRY(INT(pick-value),mKppRecValues).
      END.
/*
      IF NOT mIsFullControlInput  AND
         FRAME-FIELD = "mKppSend" THEN
      DO:
         kpp_var_code = ?.
         { kppproc.i
             &BUF-OP-ENTRY = op-entry
             &BUF-OP       = op
         }
         IF kpp_var_code <> ? AND kpp_var_code <> "" THEN
            SELF:SCREEN-VALUE = kpp_var_code.

      END.  */
      IF FRAME-FIELD = "mKppRec" THEN
      DO:
         RUN KppRecUpd(INPUT iOpRid,OUTPUT cSelectKppRec).
            IF cSelectKppRec <> ? AND cSelectKppRec <> "" THEN
               SELF:SCREEN-VALUE = cSelectKppRec.
          
      END.
/*      IF FRAME-FIELD = "mOKATO" AND mOKATOAllowSelect THEN
      DO:
         RUN messmenu.p(10 ,"[ВЫБЕРИТЕ ОКАТО]","",mOKATOValues).
         IF (LASTKEY EQ 13 OR LASTKEY EQ 10) AND pick-value NE ? THEN
            SELF:SCREEN-VALUE = ENTRY(INT(pick-value),mOKATOValues).
      END.*/
   END.
   RETURN NO-APPLY.
END.

/*ON ANY-PRINTABLE, CLEAR, DELETE-CHARACTER, CTRL-V, BACKSPACE OF mKppSend IN FRAME NalPr-Frame DO:

   DEFINE VARIABLE vI AS INTEGER    NO-UNDO.

   IF mKppSendAllowSelect THEN DO:
      /* если ручной запуск формы - то вводить можно что угодно */
      IF mKppSendValues EQ ? OR (NOT mIsFullControlInput AND mAcctDbFlag ) THEN RETURN.
      ELSE DO: /* иначе выбираем значение из списка по пробелу */
         IF LASTKEY EQ 32 THEN DO:
            vI = LOOKUP(mKppSend, mKppSendValues) + 1.
            IF vI > NUM-ENTRIES(mKppSendValues) THEN vI = 1.
            mKppSend = ENTRY(vI, mKppSendValues).
            DISP mKppSend WITH FRAME NalPr-Frame.
            RETURN NO-APPLY.
         END.
         ELSE RETURN NO-APPLY.
      END.
   END.
   ELSE RETURN NO-APPLY.
END.       */

COLOR DISPLAY bright-white
   mPokST
   mKppSend
   mKppRec
   mKBK
   mOKATO
   mPokOP
   mPokNP1
   mPokND
   mPokDD
   mPokTP
   WITH FRAME NalPr-Frame.

COLOR DISPLAY bright-green
   mPokSTLabel
   mKBKLabel
   mPokOPLabel
   mPokNPLabel
   mPokTPLabel
   WITH FRAME NalPr-Frame.


/* ******** Инициализация переменных ******** */
ASSIGN
   mBalNalog = FGetSetting ("ГНИ", "bal-nalog", ?) /* маски для анализа получателя платежа */
   mCRDNP    = FGetSetting ("ГНИ", "КРДНП", ?)     /* маски для анализа кодов документа */
   .

/* ******** основной блок ******** */
FIND FIRST op WHERE RECID(op) EQ iOpRid NO-LOCK NO-ERROR.
IF NOT AVAIL op THEN DO:
   MESSAGE "Программа обработки реквизитов налоговых платежей не смогла найти документ"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   RETURN "ESC".
END.

RELEASE DbAcct.

FIND FIRST op-entry OF op NO-LOCK NO-ERROR.

IF AVAIL op-entry THEN
   FIND FIRST DbAcct WHERE
              DbAcct.Acct = Op-Entry.Acct-Db
   NO-LOCK NO-ERROR.
IF AVAIL DbAcct AND DbAcct.Cust-Cat = "В" THEN
   mAcctDbFlag = YES.

/* запущена на просмотр ? */
IF {&ViewOnly} THEN DO:
   /* заполняем значения из документа */
   RUN FillVars (iOpRid).

   /* проверяем - было ли хоть одно поле заполнено ? */
   IF NOT {&ViewOnlyIfExist} OR
      mPokST        NE "" OR
      mKppSend      NE "" OR
      mKppRec       NE "" OR
      mKBK          NE "" OR
      mOKATO        NE "" OR
      mPokOP        NE "" OR
      mPokNP        NE "" OR
      mPokND        NE "" OR
      mPokDD        NE "" OR
      mPokTP        NE ""
   THEN DO:
      RUN FillLabelFields.

      loop:
      DO ON ERROR UNDO loop, LEAVE loop ON ENDKEY UNDO loop, LEAVE loop:
         PAUSE 0.
         RUN DispFrame.
         PAUSE.
      END.

      HIDE FRAME NalPr-Frame NO-PAUSE.

      INPUT CLEAR.

      RETURN "OK".
   END.
END.
ELSE DO:
   FIND FIRST op-entry OF op NO-LOCK NO-ERROR.
   IF NOT AVAIL op-entry THEN
      RETURN.

   /* определяем получателя платежа */
   RUN Collection-Info.
   IF AVAIL op-entry THEN
      RUN DefRecipient.

   /* проверяем - получатель платежа соответствует маске(ам) ? */
   IF CAN-DO(mBalNalog, ENTRY(1, PoAcct)) THEN DO:
      /* если код документа соответствует маске(ам) */
      IF CAN-DO(mCRDNP, op.doc-type) THEN DO:
         FIND FIRST op-entry OF op NO-LOCK NO-ERROR.
         IF NOT AVAIL op-entry THEN DO:
            RUN EditFrame ("").
            RETURN RETURN-VALUE.
         END. /* avail op-entry */
         ELSE DO:
            {find-act.i
               &acct = op-entry.acct-db
               &curr = op-entry.currency
            }
            IF NOT AVAIL acct THEN DO:
               RUN EditFrame ("").
               RETURN RETURN-VALUE.
            END.
            ELSE DO:
               RUN EditFrame (GetXAttrValue("acct", acct.acct + "," + acct.currency, "КБК")).
               RETURN RETURN-VALUE.
            END.
         END.
      END. /* CAN-DO(mCRDNP, op.doc-type)  */
      ELSE DO: /* если код документа не соответствует маске */
         
         IF {&ManualRun} THEN DO:
            RUN EditFrame ("").
            RETURN RETURN-VALUE.
         END.
      END.
   END. /* can-do (mBalNalog, PoAcct) */
   ELSE DO:
      IF {&ManualRun} THEN DO:
         RUN EditFrame ("").
         RETURN RETURN-VALUE.
      END.
   END.
END.

/*
procedure:  FillVars
comment:    заполняет переменные фрейма, берет информацию из доп.реквизитов
            документа
parameters: iOpRid

*/
PROCEDURE FillVars.
   /* iOpRid - указатель на документ */
   DEFINE INPUT  PARAMETER iOpRid AS RECID      NO-UNDO.

   DEFINE VARIABLE vI AS INTEGER NO-UNDO.

   DEFINE BUFFER op   FOR op.
   DEFINE BUFFER acct FOR acct.

   ASSIGN
      mPokSTLabel        = ""
      mKBKLabel          = ""
      mPokOPLabel        = ""
      mPokNPLabel        = ""
      mPokTPLabel        = ""
      .

   FIND FIRST op WHERE RECID(op) EQ iOpRid NO-LOCK NO-ERROR.
   IF NOT AVAIL op THEN RETURN.

   RUN GetDopParam.

   ASSIGN
      mPokNP1 = mPokNP
      mPokOP        = GetXattrValueEx ("op", STRING(op.op), "ПокОП",       "")
      mPokTP        = GetXattrValueEx ("op", STRING(op.op), "ПокТП",       "")
      mPokOP        = IF mPokOP = "" 
                         AND  NOT {&ViewOnlyIfExist}
                         THEN GetXattrInit ("opb", "ПокОП")
                         ELSE mPokOP
      mPokTP        = IF mPokTP = "" 
                         AND NOT {&ViewOnlyIfExist}
                         THEN GetXattrInit ("opb", "ПокТП")
                         ELSE mPokTP
                      /* если в формате доп.реквизита есть "." , то искл. ее из значения */
      mPokDD        = IF INDEX(mFormatPokDD,".") > 0
                         THEN REPLACE(mPokDD, ".", "")
                         ELSE mPokDD
      mKppSendSensitive = YES
      mKppRecSensitive  = YES
      mOKATOSensitive   = YES
      m106n_stat_plat   = GetXattrValueEx ("op", STRING(op.op), "п106н_СтатПлат", "")
   .

   ASSIGN
      mKppSend = GetXAttrValueEx("op", 
                                 STRING(op.op), 
                                 "kpp-send", 
                                 "")
      mKppRec  = GetXAttrValueEx("op", 
                                 STRING(op.op), 
                                 "kpp-rec", 
                                 "")
   .

/** pirbank added */

   IF mDoubleEnter THEN DO:



      ASSIGN
         mKppSend = ""
         mKppRec  = ""
	 mKppFromBen = ""
	 tmpOKATO   = mOKATO
	 mOKATO	 = ""
         tmpKBK   = mKBK
         mKBK     = ""
         tmpPokOP = mPokOp
         mPokOP = ""
         tmpPokNP1 = mPokNP1
         mPokNP1 = ""
         tmpPokND = mPokND
         mPokND = ""
         tmpPokTP = mPokTP
         mPokTP = ""
         tmpPokDD = mPokDD
	 mPokDD = ""
         tmpKPPr  = GetXAttrValueEx("op", 
                                    STRING(op.op), 
                                    "kpp-rec", 
                                    "")
         tmpKPPs  = GetXAttrValueEx("op", 
                                    STRING(op.op), 
                                    "kpp-send", 
                                    "")
      .


END. 
/** pirbank end */
      

IF AVAILABLE op-entry THEN 
DO:
    IF (mKppSend EQ "" AND mKppRec EQ "") THEN
    DO:

      mKppFromBen = GetXAttrValueEx("op-template",
                        op.op-kind + "," + STRING(op-entry.op-entry),
                        "const-recip","").
      IF NUM-ENTRIES(mKppFromBen,"^") GE 4 THEN
         mKppFromBen = ENTRY(4, mKppFromBen, "^").
      ELSE
         mKppFromBen = "".
   END.

   FOR FIRST acct WHERE acct.acct     EQ op-entry.acct-db
                     AND acct.currency EQ op-entry.currency
                   NO-LOCK,
       FIRST branch OF acct NO-LOCK:

      IF mKppFromBen NE "" THEN
      DO:
         CASE op.doc-kind :
            WHEN "SEND" THEN
               mKppSend = mKppFromBen.
            WHEN "REC" THEN
               mKppRec = mKppFromBen.
            OTHERWISE
               IF CAN-DO(FGetSetting("НазнСчМБР",?,""),acct.contract) THEN
                  mKppSend = mKppFromBen.
	               ELSE
                  mKppRec = mKppFromBen.

         END CASE.
      END.

      IF GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "КБК", ?) NE ? THEN
      DO:

         /** pirbank: IF mKppSend EQ "" THEN */
         IF (mKppSend EQ "") AND ( NOT mDoubleEnter ) THEN
            mKppSend = GetXAttrValueEx("branch", 
                                       branch.branch-id, 
                                       "kpp-send", 
                                       "").

         /** pirbank: IF mOKATO EQ "" THEN */
  /*       IF (mOKATO EQ "") AND ( NOT mDoubleEnter ) THEN
            mOKATO   = GetXAttrValueEx("branch", 
                                       branch.branch-id, 
                                       "ОКАТО-НАЛОГ", 
                                       "").*/

         /** pirbank: IF mKppRec EQ "" THEN */
         IF (mKppRec EQ "") AND ( NOT mDoubleEnter ) THEN
            mKppRec  = GetXAttrValueEx("branch", 
                                       branch.branch-id, 
                                       "kpp-rec", 
                                       "").


         /** pirbank: IF mOKATO EQ "" THEN */
         IF (mOKATO EQ "") AND ( NOT mDoubleEnter ) THEN
            ASSIGN
/*               mOKATOValues  = FGetSetting ("ГНИ", "ОКАТО_НалИнсп", ?)*/
/*               mOKATOAllowSelect = (NUM-ENTRIES(mOKATOValues) > 1)*/

               mOKATO  =  /*IF mOKATO <> "" AND mOKATO <> ? THEN*/
                             mOKATO
/*                          ELSE
                             IF mOKATOValues <> "" THEN
                                ENTRY(1,mOKATOValues)
                             ELSE
                                mOKATOValues*/
            .                

         IF mOKATO NE ""  THEN
            mOKATOSensitive = NO.
            
         IF mKppSend NE "" THEN
            mKppSendSensitive = NO.
               
         IF mKppRec NE "" THEN
            mKppRecSensitive = NO.
      END.
   END.
END.
END PROCEDURE.

/*
procedure:  SaveVars
comment:    сохраняет значения фрейма в доп.реквизиты документа
parameters: iOpRid

*/
PROCEDURE SaveVars.
   /* iOpRid - указатель на документ */
   DEFINE INPUT  PARAMETER iOpRid AS RECID      NO-UNDO.

   DEFINE BUFFER op FOR op.

   FIND FIRST op WHERE RECID(op) EQ iOpRid NO-LOCK NO-ERROR.
   IF NOT AVAIL op THEN RETURN.
   IF NOT mEmpty THEN
   DO:
      UpdateSigns ("op", STRING(op.op), "ПокСт",       mPokST,        YES).
      UpdateSigns ("op", STRING(op.op), "Kpp-send",    mKppSend,      NO).
      UpdateSigns ("op", STRING(op.op), "Kpp-rec",     mKppRec,       NO).
      UpdateSigns ("op", STRING(op.op), "КБК",         mKBK,          YES).
      UpdateSigns ("op", STRING(op.op), "ОКАТО-НАЛОГ", mOKATO,        NO).
      UpdateSigns ("op", STRING(op.op), "ПокОП",       mPokOP,        YES).
      UpdateSigns ("op", STRING(op.op), "ПокНП",       IF mPokNP NE ".." 
                                                          THEN mPokNP
                                                          ELSE "",    YES).
      UpdateSigns ("op", STRING(op.op), "ПокНД",       mPokND,        YES).
      UpdateSigns ("op", STRING(op.op), "ПокДД",       mPokDD,        NO).
      UpdateSigns ("op", STRING(op.op), "ПокТП",       mPokTP,        YES).
      UpdateSigns ("op", STRING(op.op), "п106н_СтатПлат", m106n_stat_plat, isXAttrIndexed(op.class-code,"п106н_СтатПлат")).
   END.
END PROCEDURE.

/*
procedure: FillLabelFields
comment:  заполняет поля - расшифровку значений фрейма
*/
PROCEDURE FillLabelFields.
   ASSIGN
      mPokSTLabel        = GetCodeName ("ПокСт", mPokST)
      mKBKLabel          = GetCodeName ("КБК", mKBK)
      mPokOPLabel        = GetCodeName ("Нал:ОП", mPokOP)
      mPokNPLabel        = GetCodeName ("Нал:НП", ENTRY(1,mPokNP1,".")) WHEN INDEX(mPokNP1,".") > 0 
      mPokTPLabel        = GetCodeName ("Нал:ВП", mPokTP)
      .

      IF GetCodeBuff("ПокСт", mPokST, BUFFER code) THEN
         IF code.description[1] NE "" THEN
            m106n_stat_plat = code.description[1].

END PROCEDURE.

/*
procedure: DispFrame
comment:  отображает содержимое полей фрейма

*/
PROCEDURE DispFrame.


   DISP
      "" WHEN mPokST EQ ? @ mPokST
      mPokST WHEN mPokST NE ?
      "" WHEN mKppSend EQ ? @ mKppSend
      mKppSend WHEN mKppSend NE ?
      "" WHEN mKppRec EQ ? @ mKppRec
      mKppRec WHEN mKppRec NE ?
      "" WHEN mKBK EQ ? @ mKBK
      mKBK WHEN mKBK NE ?
      "" WHEN mOKATO EQ ? @ mOKATO
      mOKATO WHEN mOKATO NE ?
      "" WHEN mPokOP EQ ? @ mPokOP
      mPokOP WHEN mPokOP NE ?
      "" WHEN mPokNP1 EQ ? @ mPokNP1
      mPokNP1 WHEN mPokNP1 NE ?
      "" WHEN mPokND EQ ? @ mPokND
      mPokND WHEN mPokND NE ?
      "" WHEN mPokDD EQ ? @ mPokDD
      mPokDD WHEN mPokDD NE ?
      "" WHEN mPokTP EQ ? @ mPokTP
      mPokTP WHEN mPokTP NE ?
      mPokSTLabel
      mKBKLabel
      mPokOPLabel
      mPokNPLabel
      mPokTPLabel
      WITH FRAME NalPr-Frame.
END PROCEDURE.

FUNCTION GetOKATO RETURNS CHAR (INPUT iOpRid AS RECID, INPUT iOldOKATO AS CHAR):
   DEFINE BUFFER op FOR op.
   DEFINE VAR vOpOKATO AS CHAR NO-UNDO.

   FIND FIRST op WHERE RECID(op) EQ iOpRid NO-LOCK NO-ERROR.
   IF NOT AVAIL op THEN RETURN ?.
   vOpOKATO = GetXAttrValueEx("op",STRING(op.op),"ОКАТО-НАЛОГ","").
   IF vOpOKATO NE "" THEN 
      RETURN vOpOKATO.

   FIND FIRST op-entry OF op NO-LOCK NO-ERROR.
   IF NOT AVAIL op-entry THEN RETURN ?.
   {find-act.i
      &acct = op-entry.acct-db
      &curr = op-entry.currency
   }
   IF NOT AVAIL acct THEN RETURN ?.

   CASE acct.cust-cat:
      WHEN "Ю" THEN RETURN GetXAttrValueEx ("cust-corp", STRING(acct.cust-id), "ОКАТО-НАЛОГ", iOldOkato).
      WHEN "Ч" THEN RETURN GetXAttrValueEx ("person",    STRING(acct.cust-id), "ОКАТО-НАЛОГ", iOldOkato).
      WHEN "Б" THEN RETURN GetXAttrValueEx ("banks",     STRING(acct.cust-id), "ОКАТО-НАЛОГ", iOldOkato).
      OTHERWISE     RETURN "".
   END CASE.

   RETURN ?.

END FUNCTION.

FUNCTION GetKpp RETURNS CHAR (INPUT iOpRid AS RECID):
   DEFINE BUFFER op FOR op.

   FIND FIRST op WHERE RECID(op) EQ iOpRid NO-LOCK NO-ERROR.
   IF NOT AVAIL op THEN RETURN ?.

   FIND FIRST op-entry OF op NO-LOCK NO-ERROR.
   IF NOT AVAIL op-entry THEN RETURN ?.
   {find-act.i
      &acct = op-entry.acct-db
      &curr = op-entry.currency
   }
   IF NOT AVAIL acct THEN RETURN ?.

   CASE acct.cust-cat:
      WHEN "Ю" THEN RETURN GetXAttrValueEx ("cust-corp", STRING(acct.cust-id), "КПП", "0").
      WHEN "Ч" THEN RETURN GetXAttrValueEx ("person",    STRING(acct.cust-id), "КПП", "0").
      WHEN "Б" THEN RETURN GetXAttrValueEx ("banks",     STRING(acct.cust-id), "КПП", "0").
      OTHERWISE     RETURN "0".
   END CASE.

   RETURN ?.

END FUNCTION.

FUNCTION GetKppAcct RETURNS CHAR (INPUT iAcct AS CHARACTER):

   FIND FIRST acct WHERE acct.acct EQ iAcct NO-LOCK NO-ERROR.
   IF NOT AVAIL acct THEN RETURN ?.
   CASE acct.cust-cat:
      WHEN "Ю" THEN RETURN GetXAttrValueEx ("cust-corp", STRING(acct.cust-id), "КПП", "0").
      WHEN "Ч" THEN RETURN GetXAttrValueEx ("person",    STRING(acct.cust-id), "КПП", "0").
      WHEN "Б" THEN RETURN GetXAttrValueEx ("banks",     STRING(acct.cust-id), "КПП", "0").
      OTHERWISE     RETURN "0".
   END CASE.

   RETURN ?.

END FUNCTION.

PROCEDURE EditFrame.
   DEFINE INPUT  PARAMETER iKBK AS CHARACTER  NO-UNDO.

   DEFINE VARIABLE vResult AS CHARACTER  NO-UNDO.

   mIsFullControlInput = iKBK NE "".

   /* заполняем значения из документа */
   RUN FillVars (iOpRid).

   IF mIsFullControlInput THEN /* если у нас обязательный ввод */
      ASSIGN
/*         mKppSendValues = FGetSetting ("БанкКПП", ?, ?)*/
/*         mKppSendAllowSelect = (NUM-ENTRIES(mKppSendValues) > 1)*/
         mKppSend   =  /*IF mKppSend <> "" AND mKppSend <> ? THEN*/
                          mKppSend
/*                       ELSE
                       IF mKppSendValues <> "" THEN
                          ENTRY(1,mKppSendValues)
                       ELSE
                          mKppSendValues*/
        mKppRecValues       = GetKppAcct(poAcct)
        mKppRec             = IF mKppRec  <> "" AND mKppRec  <> ? THEN
                                 mKppRec
                              ELSE
                              IF LOOKUP(mKppRec , mKppRecValues) = 0
                              THEN
                                 ENTRY(1, mKppRecValues)
                              ELSE
                                 mKppRec
        mKppRecAllowSelect  = NUM-ENTRIES(mKppRecValues) > 1

         mKBK     = iKBK
/*         mOKATOValues  = FGetSetting ("ГНИ", "ОКАТО_НалИнсп", ?)*/
         mOKATOAllowSelect = (NUM-ENTRIES(mOKATOValues) > 1)
         mOKATO  = /* IF mOKATO <> "" AND mOKATO <> ? THEN*/
                       mOKATO
/*                    ELSE
                    IF mOKATOValues <> "" THEN
                       ENTRY(1,mOKATOValues)
                    ELSE
                       mOKATOValues  */
         .
   ELSE DO: /* если не обязательный ввод */
      IF NOT {&ManualRun} THEN
         ASSIGN
/*            mKppSendValues = GetKpp (iOpRid)*/
            mKppSend = /*IF mKppSend <> "" AND mKppSend <> ? THEN*/
                          mKppSend
/*                       ELSE
                       IF LOOKUP(mKppSend, mKppSendValues) = 0
                       THEN
                          ENTRY(1, mKppSendValues)
                       ELSE
                          mKppSend*/
/*            mKppSendAllowSelect = NUM-ENTRIES(mKppSendValues) > 1*/
            mKppRecValues       = GetKppAcct(poAcct)

            mKppRec             = IF mKppRec  <> "" AND mKppRec  <> ? THEN
                                     mKppRec
                                  ELSE
                                  IF LOOKUP(mKppRec , mKppRecValues) = 0
                                  THEN
                                     ENTRY(1, mKppRecValues)
                                  ELSE
                                     mKppRec
            mKppRecAllowSelect  = NUM-ENTRIES(mKppRecValues) > 1

            mOKATO = GetOKATO (iOpRid, mOkato)
         .
      ELSE /* если ручной запус формы */
         mKppSendValues      = ?

      .

/*     mKppSendAllowSelect = YES.*/
   END.
   RUN FillLabelFields.
   
   loop:
   DO ON ERROR UNDO loop, LEAVE loop ON ENDKEY UNDO loop, LEAVE loop:
      PAUSE 0.
      RUN DispFrame.
      
      ENABLE
         mPokST
         mKppSend      
         mKppRec       WHEN mKppRecSensitive
         mKBK          WHEN NOT mIsFullControlInput
         mOKATO        WHEN (NOT mIsFullControlInput OR
                            (mIsFullControlInput    AND
                             mOKATOAllowSelect))  AND       
                             mOKATOSensitive
         mPokOP
         mPokNP1
         mPokND
         mPokDD
         mPokTP
         WITH FRAME NalPr-Frame.
      WAIT-FOR GO,WINDOW-CLOSE OF CURRENT-WINDOW FOCUS mPokST.

   END.

   ASSIGN
      mPokST
      mKppSend
      mKppRec
      mKBK
      mOKATO
      mPokOP
      mPokNP1
      mPokND
      mPokTP
      .
   HIDE FRAME NalPr-Frame NO-PAUSE.

   vResult = "ESC".

   IF LASTKEY EQ 10 OR LASTKEY EQ 13 THEN DO:
      RUN SaveVars (iOpRid).
      vResult = "OK".
   END.

   INPUT CLEAR.

   RETURN vResult.

END PROCEDURE.

PROCEDURE KppRecUpd:
   DEFINE INPUT PARAMETER ipOpRecid AS RECID NO-UNDO.
   DEFINE OUTPUT PARAMETER opSelectKppRec AS CHAR NO-UNDO.

   DEFINE VARIABLE vKppRecList    AS CHAR NO-UNDO.
   DEFINE VARIABLE vKppRecNewList AS CHAR NO-UNDO.
   DEFINE VARIABLE vCode          AS CHAR NO-UNDO.
   DEFINE VARIABLE codefind       AS CHAR NO-UNDO.

   FIND FIRST op WHERE RECID(op) EQ ipOpRecid NO-LOCK NO-ERROR.

   IF AVAIL op THEN DO:
      IF op.doc-kind EQ "rec" OR op.doc-kind eq "" THEN DO:
         FIND FIRST op-bank OF op WHERE op-bank.op-bank-type EQ "" NO-LOCK NO-ERROR. 
         IF AVAIL  op-bank THEN 
            codefind = STRING (INT (op-bank.bank-code), "999999999") + "," + op.ben-acct + "," + op.inn. /* BIC */
         ELSE 
            RUN getOpDocSysConf(INPUT "КппПол", INPUT RECID(op), OUTPUT codefind).

         RUN GetRecipientValue IN h_cust (ENTRY(1,codefind),
                                          GetEntries(2,codefind,",",""),
                                          GetEntries(3,codefind,",",""),
                                          "БИК,РАСЧ_СЧЕТ,ИНН,КПП",
                                          OUTPUT vCode
                                         ).
         IF GetEntries(1,vCode,CHR(2),"") <> "" THEN DO:
            vKppRecList = GetEntries(4,vCode,CHR(2),"").
            RUN RecKpp(INPUT vKppRecList,OUTPUT opSelectKppRec,OUTPUT vKppRecNewList).
            IF vKppRecList <> vKppRecNewList THEN DO:
               TR:
               DO TRANSACTION ON ERROR UNDO TR,LEAVE TR:
                  RUN CreateUpdateRecipient IN h_cust (GetEntries(1,vCode,CHR(2),""),GetEntries(2,vCode,CHR(2),""),GetEntries(3,vCode,CHR(2),""),?,vKppRecNewList,?,?,"КПП").
               END.  /* End of TR BLOCK */
            END.
         END. /*IF AVAIL CODE */

      END. /*IF op.doc-kind EQ "rec" OR op.doc-kind eq ""*/

   END. /*IF AVAIL op*/

END PROCEDURE.

{intrface.del}
