{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pirreedpsp.p,v $ $Revision: 1.7 $ $Date: 2009-04-23 17:04:48 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : reedpsp.p.
Причина       :  
Место запуска : Весь бисквит
Автор         : $Author: ermilov $
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.6  2008/03/18 09:27:35  kuntash
Изменения     : dorabotka itoga
Изменения     :
Изменения     : Revision 1.5  2008/01/28 15:25:55  kuntash
Изменения     : dorabotka 1927-u
Изменения     :
Изменения     : Revision 1.4  2007/10/18 07:42:24  anisimov
Изменения     : no message
Изменения     :
Изменения     : Revision 1.3  2007/09/10 08:26:09  kuntash
Изменения     : ╨┤╨╛╤А╨░╨▒╨╛╤В╨║╨░ 101 ╤А╨░╤Б╨┐
Изменения     :
Изменения     : Revision 1.2  2007/09/10 12:44:53  kuntash
Изменения     : 1. При выборе нескольких вкладчиков таблица ttReeLoan создается несколько раз, что создает дублирование
Изменения     : данных со второго участника. Перенесена процедура заполнения таблицы {pirree_dps.i} до расчета данных.
------------------------------------------------------ */
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ТОО "Банковские информационные системы"
     Filename: reedpsp.p
      Comment: Печать выписки из реестра обязательств банка перд вкладчиками
   Parameters:
         Uses:
      Used by:
      Created: 18.08.2004 15:36 FEAK    
     Modified: 19.08.2004 15:00 FEAK     
     Modified: 
*/            
                                                    
DEFINE INPUT PARAMETER in-data-id LIKE DataBlock.Data-Id NO-UNDO.

{globals.i}
{wordwrap.def}
{norm.i}
{repinfo.i}
{intrface.get xclass}
{intrface.get strng}
{bank-id.i} 
{tmprecid.def}        /** Используем информацию из броузера */

&glob STREAM STREAM mStr

DEF VAR vMaxLines AS INTEGER NO-UNDO.
DEF VAR mString AS CHAR EXTENT 12 NO-UNDO. 
DEF VAR mLength AS INT EXTENT 12 NO-UNDO.
DEF VAR mS AS CHAR EXTENT 10 NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR j AS INTEGER NO-UNDO.
DEF VAR mI AS INTEGER NO-UNDO.
DEF VAR vSString AS CHAR NO-UNDO.
DEF VAR vMaxVzSum AS DEC FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEF VAR vDate AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR vBank AS CHAR NO-UNDO.
DEF VAR vAdress AS CHAR NO-UNDO.
DEF VAR vCurSumd AS DEC NO-UNDO.
DEF VAR vCurSumk AS DEC NO-UNDO.
DEF VAR vPers AS CHAR NO-UNDO.
DEF VAR vUNKg AS CHAR NO-UNDO.
DEF VAR vRecId AS RECID NO-UNDO.
DEF {&STREAM}.

{fexp-chk.i
   &DataID = " in-Data-Id"}

FIND FIRST DataBlock WHERE DataBlock.Data-Id EQ in-Data-Id NO-LOCK.
IF AVAIL DataBlock THEN
   ASSIGN vDate = DataBlock.End-Date.

{get-bankname.i}
vBank = cBankNameFull.
/*vBank  = "Коммерческий банк промышленно-инвестиционных расчетов " + chr(34) + "Пpоминвестрасчет" + chr(34) + "(общество с ограниченной ответственностью)".*/
vAdress  = FGetSetting( "Адрес_пч", "", "" ).

DO
ON ERROR UNDO, LEAVE
ON ENDKEY UNDO, LEAVE
WITH FRAME fr1
   CENTERED
   ROW 10
   OVERLAY
   SIDE-LABELS
   1 COL
   COLOR MESSAGES
   TITLE "[ МАКСИМАЛЬНАЯ СУММА ВОЗМЕЩЕНИЯ ]":
 vMaxVzSum=700000.
   DISPLAY vMaxVzSum.

   UPDATE
      vMaxVzSum
         LABEL "Сумма возмещения:"
         HELP  "Задайте максимальную сумму возмещения."

    EDITING:
       READKEY.
       APPLY LASTKEY.
    END.   
END.
HIDE FRAME fr1 NO-PAUSE.
IF KEYFUNC(LASTKEY) EQ "end-error"
THEN RETURN.

RUN browseld.p ("person",
                "crclass-code",
                "*",
                ?,
                3).

IF LASTKEY NE 10 AND LASTKEY NE 13 THEN RETURN.
IF NOT CAN-FIND (FIRST tmprecid) THEN DO:
    MESSAGE "Нет выбранных клиентов"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.

{setdest.i &stream="stream mStr" &filename='reedpsp.tmp'}
{pirree_dps.i}
   
for each tmprecid:
   find first person where recid(person) = tmprecid.id no-lock.
   ASSIGN vUNKg = STRING(INT(GetXAttrValue("person",string(person.person-id),"УНК"))).
   
   /*получение данных из блока данных - ?*/


   FIND FIRST ttRee WHERE string(int(ttRee.SysNum)) EQ vUNKg NO-ERROR.
   
   IF AVAIL ttRee THEN
   DO: 
      PUT {&STREAM} UNFORMATTED
      "        Выписка из реестра обязательств банка перед вкладчиками" SKIP(1).
      PUT {&STREAM} UNFORMATTED
      "Сведения о банке" SKIP
      "Наименование банка:  " vBank SKIP
      "Почтовый адрес:  " vAdress SKIP
      "Регистрационный номер:  " bank-regn SKIP(1).

      ASSIGN 
         mString[1] = /* STRING(ttRee.id)  string(int(ttRee.SysNum),">>>>>>9")*/ string(ttRee.SysNum)
         mString[2] = ttRee.FIO
         mString[3] = ttRee.AdressReq + ", " + ttRee.AdressPos + ", " + ttRee.Phone + ", " + ttRee.Email
         mString[4] = ttRee.DocTypeCode + ", " + ttRee.DocNum + ", " + ttRee.KemVidano
         mLength[1] = 10
         mLength[2] = 20
         mLength[3] = 30
         mLength[4] = 35
         vCurSumd = 0.
         vCurSumk = 0.
         .     
      PUT {&STREAM} UNFORMATTED
         "┌──────────┬────────────────────┬──────────────────────────────┬───────────────────────────────────┐" SKIP
         "│  Номер   │       Ф.И.О.       │      Адрес регистрации,      │       Код вида и реквизиты        │" SKIP
         "│вкладчика │                    │   для почтовых уведомлений,  │             документа,            │" SKIP
         "│по реестру│                    │           телефон,           │      удостоверяющего личность     │" SKIP
         "│  обяза-  │                    │      электронная почта       │                                   │" SKIP
         "│ тельств  │                    │                              │                                   │" SKIP
         "├──────────┼────────────────────┼──────────────────────────────┼───────────────────────────────────┤" SKIP.
      
      ASSIGN j = 1.     
      DO i = 1 TO 4:
         ASSIGN mS[1] = mString[i].
         {wordwrap.i &s = mS
                     &n = 10
                     &l = mLength[i]}
         DO WHILE mS[j] NE "":
            ASSIGN j = j + 1.
         END.
         IF j GT vMaxLines THEN
            ASSIGN vMaxLines = j - 1.
      END.
      
      DO j = 1 TO vMaxLines: /*цикл по строкам*/
         DO i = 1 TO 4:      /*цикл по элементам... 1-2-3...*/
            ASSIGN mS[1] = mString[i]. /*сохраняем для будущей порезки*/
            {wordwrap.i &s = mS
                        &n = 2
                        &l = mLength[i]
            }
            ASSIGN mString[i] = mS[2]. /*отрезали, теперь все что не понадобилось сохраняем 
                                         для будущего шага по строкам*/
            RUN Cutter (mLength[i], 1, NO).
      
            /*добавили пробелов до нужного количества*/
            PUT {&STREAM} UNFORMATTED "│" mS[1]. /*вывели саму строчку*/
         END.
         PUT {&STREAM} UNFORMATTED "│" SKIP.
      END.
      PUT {&STREAM} UNFORMATTED
         "└──────────┴────────────────────┴──────────────────────────────┴───────────────────────────────────┘" SKIP(1).
      
      /*обязательства банка*/
      FIND FIRST ttReeLoan WHERE ttReeLoan.SysNum EQ ttRee.SysNum
                           AND ttReeLoan.Symbol EQ "д" NO-ERROR.
      IF AVAIL ttReeLoan THEN
      DO:
         ASSIGN mString[6] = "".
         PUT {&STREAM} UNFORMATTED
            "Сведения о подлежащих страхованию обязательствах банка перед вкладчиком." SKIP(1).
      
         PUT {&STREAM} UNFORMATTED
            "┌──────┬────────────────────┬──────────┬───────────┬────────────────────┬────────────────┬────────────────┐" SKIP
            "│№ п/п │  Номер документа,  │Дата доку-│Порядковый │       Номер        │     Сумма      │      Сумма     │" SKIP
            "│      │    на основании    │мента, на │  номер    │      лицевого      │    в валюте    │    в рублях    │" SKIP
            "│      │      которого      │основании │ филиала,  │      счета для     │  обязательств  │    по курсу    │" SKIP
            "│      │    принят вклад    │ которого │ заключив- │        учета       │                │     Банка      │" SKIP
            "│      │                    │  принят  │   шего    │    обязательств    │                │     России     │" SKIP
            "│      │                    │  вклад   │  договор  │                    │                │                │" SKIP
            "├──────┼────────────────────┼──────────┼───────────┼────────────────────┼────────────────┼────────────────┤" SKIP.
      
         FOR EACH ttReeLoan WHERE ttReeLoan.SysNum EQ ttRee.SysNum
                              AND ttReeLoan.Symbol EQ "д":
            ASSIGN 
               vCurSumd = vCurSumd + ttReeLoan.SumInRur
               vPers = vPers + ttReeLoan.ContNum + ","
               .
            ASSIGN
               mString[6] = STRING(INT(mString[6]) + 1)
               mLength[6] = 6
               mString[7] = ttReeLoan.ContNum
               mLength[7] = 20
               mString[8] = ttReeLoan.ContDate
               mLength[8] = 10
               mString[9] = ttReeLoan.BankRegNum
               mLength[9] = 11
               mString[10] = ttReeLoan.AcctNum
               mLength[10] = 20
               mString[11] = STRING(ttReeLoan.SumInCurr,"->>>,>>>,>>9.99")
               mLength[11] = 16
               mString[12] = STRING(ttReeLoan.SumInRur,"->>>,>>>,>>9.99")
               mLength[12] = 16
               .
            DO i = 1 TO 7:
               ASSIGN mS[1] = mString [(i + 5)].
               RUN Cutter (mLength[(i + 5)], 1, YES).
               ASSIGN mString [(i + 5)] = mS[1].
            END.
            ASSIGN 
               vSString = "│" + mString[6] + 
                          "│" + mString[7] + 
                          "│" + mString[8] +
                          "│" + mString[9] +
                          "│" + mString[10] + 
                          "│" + mString[11] + 
                          "│" + mString[12] + "│"
               .
            PUT {&STREAM} UNFORMATTED vSString SKIP.
         END.         
         ASSIGN mS[1] = STRING(vCurSumd,"->>>,>>>,>>9.99").
         RUN Cutter (16, 1, YES).
      
         PUT {&STREAM} UNFORMATTED
            "├──────┴────────────────────┴──────────┴───────────┴────────────────────┴────────────────┼────────────────┤" SKIP
            "│Итого обязательств (руб.)                                                               │" mS[1] "│" SKIP
            "└────────────────────────────────────────────────────────────────────────────────────────┴────────────────┘" SKIP(1).
      END.
      
      /*встречные требования*/
      
      PUT {&STREAM} UNFORMATTED
         "Сведения о встречных требованиях банка к вкладчику." SKIP(1).
      
      PUT {&STREAM} UNFORMATTED
         "┌──────┬────────────────────┬──────────┬───────────┬────────────────────┬────────────────┬────────────────┐" SKIP
         "│№ п/п │  Номер документа,  │Дата доку-│Порядковый │       Номер        │     Сумма      │      Сумма     │" SKIP
         "│      │    на основании    │мента, на │  номер    │      лицевого      │    в валюте    │    в рублях    │" SKIP
         "│      │      которого      │основании │ филиала,  │      счета для     │   требования   │    по курсу    │" SKIP
         "│      │      возникло      │ которого │ заключив- │        учета       │                │     Банка      │" SKIP
         "│      │     требование     │ возникло │   шего    │      встречных     │                │     России     │" SKIP
         "│      │                    │требование│  договор  │     требований     │                │                │" SKIP
         "├──────┼────────────────────┼──────────┼───────────┼────────────────────┼────────────────┼────────────────┤" SKIP.
      
      ASSIGN mString[6] = "".
      FOR EACH ttReeLoan WHERE ttReeLoan.SysNum EQ ttRee.SysNum
                           AND ttReeLoan.Symbol EQ "к":
/*         IF LOOKUP(ttReeLoan.ContNum, vPers) NE 0 THEN NEXT.
*/
         ASSIGN 
            vCurSumk = vCurSumk + ttReeLoan.SumInRur
            vPers = vPers + ttReeLoan.ContNum + ","
            .
         ASSIGN
            mString[6] = STRING(INT(mString[6]) + 1)
            mLength[6] = 6
            mString[7] = ttReeLoan.ContNum
            mLength[7] = 20
            mString[8] = ttReeLoan.ContDate
            mLength[8] = 10
            mString[9] = ttReeLoan.BankRegNum
            mLength[9] = 11
            mString[10] = ttReeLoan.AcctNum
            mLength[10] = 20
            mString[11] = STRING(ttReeLoan.SumInCurr,"->>>,>>>,>>9.99")
            mLength[11] = 16
            mString[12] = STRING(ttReeLoan.SumInRur,"->>>,>>>,>>9.99")
            mLength[12] = 16
            .
         DO i = 1 TO 7:
            ASSIGN mS[1] = mString [(i + 5)].
            RUN Cutter (mLength[(i + 5)], 1, YES).
            ASSIGN mString [(i + 5)] = mS[1].
         END.
         ASSIGN 
            vSString = "│" + mString[6] + 
                       "│" + mString[7] + 
                       "│" + mString[8] +
                       "│" + mString[9] +
                       "│" + mString[10] + 
                       "│" + mString[11] + 
                       "│" + mString[12] + "│"
            .
         PUT {&STREAM} UNFORMATTED vSString SKIP.
      END.      
      ASSIGN mS[1] = STRING(vCurSumk,"->>>,>>>,>>9.99").
      RUN Cutter (16, 1, YES).
      
      PUT {&STREAM} UNFORMATTED
         "├──────┴────────────────────┴──────────┴───────────┴────────────────────┴────────────────┼────────────────┤" SKIP
         "│Итого встречных требований (руб.)                                                       │" mS[1] "│" SKIP
         "└────────────────────────────────────────────────────────────────────────────────────────┴────────────────┘" SKIP(1).
      
      IF vCurSumd EQ ? THEN
         ASSIGN vCurSumd = 0.
      IF vCurSumk EQ ? THEN
         ASSIGN vCurSumk = 0.
      ASSIGN vCurSumd = vCurSumd - vCurSumk.
      IF vCurSumd LT 0 THEN
         ASSIGN vCurSumd = 0.
      PUT {&STREAM} UNFORMATTED
         "Сумма обязательств по вкладам за вычетом суммы встречных требований " SKIP
         "к вкладчику (руб.)  " vCurSumd SKIP(1).


  /* IF vCurSumd LE 100000.00 THEN
      ASSIGN vCurSumk = vCurSumd.
   IF vCurSumd GT 100000.00 and  vCurSumd LE vMaxVzSum THEN
      vCurSumk = round(100000.00 + ((vCurSumd - 100000.00) / 100 * 90),2).
   IF vCurSumd GT vMaxVzSum THEN
      ASSIGN vCurSumk = vMaxVzSum.
     */

      IF vCurSumd LT vMaxVzSum THEN
         ASSIGN vCurSumk = vCurSumd.
      ELSE
         ASSIGN vCurSumk = vMaxVzSum.







      PUT {&STREAM} UNFORMATTED
         "Сумма, подлежащая страховому возмещению Агенством по страхованию" SKIP
         "вкладов (руб.)  " vCurSumk SKIP(3). 
      PAGE {&STREAM}.   
      ASSIGN vPers = "".
   END.
END.
{signatur.i &stream="{&STREAM}"}                               
{preview.i &stream="{&STREAM}" &filename='reedpsp.tmp'}


PROCEDURE Cutter.

DEF INPUT PARAM iStr AS INTEGER.
DEF INPUT PARAM iNum AS INTEGER.
DEF INPUT PARAM iFwd AS LOGICAL.

ASSIGN mI = 1.
REPEAT WHILE mI LE iNum:
   IF mS[mI] NE ? THEN
      IF iFwd EQ NO THEN
         ASSIGN 
            mS[mI] = mS[mI] + FILL (" ", (iStr - LENGTH(mS[mI]))).
      ELSE
         ASSIGN 
            mS[mI] = FILL (" ", (iStr - LENGTH(mS[mI]))) + mS[mI].
   ELSE
      ASSIGN 
         mS[mI] = FILL (" ", iStr).
   ASSIGN mI = mI + 1.  
END.

END PROCEDURE.

