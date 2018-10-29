/*****************************************
 *                                       *
 * Отчет.                                *
 * Проверяет наличие нарушения           *
 * режима остатков по группе счетов      *
 *                                       *
 *****************************************
 *                                       *
 * Автор: Маслов Д. А. Maslov D. A.      *
 * Дата создания: 01.03.12               *
 * Заявка: #838                          *
 *                                       *
 *****************************************
 *                                       *
 * Модификация по заявке #2656           *
 * Автор: Красков А.                     *
 *                                       *
 *  04.04.2013                           *
 *                                       *
 *****************************************/ 
{globals.i}
{tmprecid.def}

/*DEF INPUT PARAM cParam AS CHARACTER NO-UNDO.*/

DEF VAR oArray            AS TAArray   NO-UNDO.
DEF VAR oAMinMode             AS TAArray   NO-UNDO.
DEF VAR oAMinCalc         AS TAArray   NO-UNDO.

DEF VAR oAcct		  AS TAcct     NO-UNDO.

DEF VAR oTable		  AS TTable    NO-UNDO.
DEF VAR oSysClass         AS TSysClass NO-UNDO.

DEF VAR key1	          AS CHARACTER NO-UNDO.
DEF VAR value1	          AS CHARACTER NO-UNDO.

DEF VAR mQuery            AS HANDLE    NO-UNDO.
DEF VAR mCnt1             AS INT64     NO-UNDO.
DEF VAR mBuffer           AS HANDLE    NO-UNDO.
DEF VAR fltName 	  AS CHARACTER NO-UNDO.

DEF VAR iDate		  AS DATE            NO-UNDO.
DEF VAR iMiddle		  AS DECIMAL INIT 0  NO-UNDO.
DEF VAR iColsCount        AS INT64   INIT 0  NO-UNDO.
DEF VAR i                 AS INT     INIT 1  NO-UNDO.
DEF VAR dAgr              AS DECIMAL INIT 0  NO-UNDO.
DEF VAR dSum              AS DECIMAL INIT 0  NO-UNDO.
DEF VAR dLimit            AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.99" LABEL "Введите число" INIT 0  NO-UNDO.

DEF VAR startDate         AS DATE            NO-UNDO.


oSysClass = new TSysClass().

/*/**************
 * Ведь не очевидно, что
 * настройка фильтра должна
 * быть в следующем виде:
 * ИМЯ ПОЛЬЗОВАТЕЛЯ,acct.p,НАЗВАНИЕФИЛЬТРА,b
 ***************/
fltName = ENTRY(1,cParam,"|").*/

/*dLimit  = DECIMAL(ENTRY(2,cParam,"|")). */

PAUSE 0.

UPDATE SKIP(1) dLimit SKIP(1)
  WITH FRAME fMain OVERLAY ROW 10 CENTERED SIDE-LABELS TITLE "[ Лимит ]".

HIDE FRAME fMain.



{getdates.i}

DEF VAR oTpl AS TTpl.
oTpl = new TTpl("pir-chk838.tpl").



oArray     = new TAArray().
oAMinMode      = new TAArray().
oAMinCalc  = new TAArray().

/*
/*********
 * Шаг №1.
 * Находим счета подлежащие
 * обработке.
 *********/
SUBSCRIBE "AfterNavigate" ANYWHERE RUN-PROCEDURE "AfterNavigate".

RUN browseld.p ("acct",
		"UserConf",
                fltName,
		"",
		4).

UNSUBSCRIBE "AfterNavigate".

PROCEDURE AfterNavigate:
   DEF INPUT PARAM iNavigate AS HANDLE  NO-UNDO.
   DEF OUTPUT PARAM oCont    AS LOGICAL NO-UNDO.


  RUN Open-Query IN iNavigate.

  mQuery = DYNAMIC-FUNCTION("GetHandleQuery" IN iNavigate).

IF    NOT VALID-HANDLE(mQuery)
      OR mQuery:TYPE NE "QUERY"
      OR NOT mQuery:IS-OPEN THEN
	MESSAGE "ОШибка открытия запроса!!!" VIEW-AS ALERT-BOX.

  RUN GetFirstRecord IN iNavigate (mQuery).

    DO mCnt1 = 1 TO mQuery:NUM-BUFFERS:
      mBuffer = mQuery:GET-BUFFER-HANDLE(mCnt1).
      IF mBuffer:TABLE EQ "acct" THEN LEAVE.
    END.

  DO WHILE NOT mQuery:QUERY-OFF-END:

     IF mBuffer:AVAIL THEN DO:   
       oArray:setH(mBuffer::acct,mBuffer::details).	  
     END.

    RUN GetNextRecord IN iNavigate (mQuery).
  END.

END PROCEDURE.
*/


for each tmprecid, first acct where RECID(acct) = tmprecid.id NO-LOCK:
      oArray:setH(acct.acct,acct.details).	  
END.


/*******
 * Шаг №2.
 * Обрабатываем счета.
 *******/

 /***
  * Формирую шапку
  ***/
  iColsCount = oArray:length + 3.
  oTable = new TTable(iColsCount).
  oTable:decFormat=">>>,>>>,>>>,>>9.99".

  oTable:addRow().
  oTable:addCell("Дата").
  {foreach oArray key1 value1}
    oTable:addCell(SUBSTRING(key1,1,9) + "*" + SUBSTRING(key1,17,4)).

     oAcct = new TAcct(key1).
       oAMinMode:setH(key1,oAcct:getLastPos2Date(beg-date)).
       oAMinCalc:setH(key1,oAcct:getLastPos2Date(beg-date)).
     DELETE OBJECT oAcct.

  {endforeach oArray}
    oTable:addCell("Итого").
    oTable:addCell("Нарушение").
 /**
  * По заявке #1662
  * надо отобразить остаток
  * на утро по счетам. Остаток на утро,
  * есть не что иное как остаток на вечер предыдущего дня.
  **/

 startDate = beg-date - 1.

 DO iDate = startDate TO end-date:
   oTable:addRow().
       IF iDate = startDate THEN DO:
         oTable:addCell("Входящий :" + STRING(iDate + 1)).
       END. ELSE DO:
         IF iDate = startDate + 1 THEN DO:
              oTable:addCell("Исходящий:" + STRING(iDate)).
         END. ELSE DO:
              oTable:addCell(iDate).
         END.
       END.
   {foreach oArray key1 value1}
       oAcct = new TAcct(key1).
        dSum = oAcct:getLastPos2Date(iDate,CHR(251)).

        /**
         * Исключаем из расчета минимального остатка,
         * входящий остаток на начало периода.
         **/
        IF iDate > startDate THEN DO:
          IF DECIMAL(oAMinMode:get(key1)) > dSum THEN oAMinMode:setH(key1,STRING(dSum)).
        END.

          /**
           * По заявке #1864
           * А ведь все таки надо чтобы и 
           * входящий остаток на начало периода
           * считался.
           **************************************
           * Зато по заявке #1951 остаток на конец
           * периода не должен учитываться. Вообщем
           * надо анализировать задание сначало.
           ***************************************/
          IF iDate < end-date THEN DO:
           IF DECIMAL(oAMinCalc:get(key1)) > dSum THEN oAMinCalc:setH(key1,STRING(dSum)).
          END.

        dAgr = dAgr + dSum.
        oTable:addCell(dSum).
       DELETE OBJECT oAcct.
   {endforeach oArray}
        oTable:addCell(dAgr).
        oTable:addCell( (IF dAgr > dLimit THEN "" ELSE CHR(251)) ).
     dAgr = 0.
 END.

/**
 * Выводим итог без входящего
 **/
oTable:addRow().
oTable:addCell("Минимальное режим:").
{foreach oAMinMode key1 value1}
  oTable:addCell(DECIMAL(value1)).
{endforeach oAMinMode}
oTable:addCell("").
oTable:addCell("").

/**
 * Выводим итог с входящим
 **/
oTable:addRow().
oTable:addCell("Минимальное расчет:").
{foreach oAMinCalc key1 value1}
  oTable:addCell(DECIMAL(value1)).
{endforeach oAMinCalc}
oTable:addCell("").
oTable:addCell("").
oTable:setAlign(1,1,"center").

oTpl:addAnchorValue("ORG",oArray:getFirst()).
oTpl:addAnchorValue("beg-date",beg-date).
oTpl:addAnchorValue("end-date",end-date).
oTpl:addAnchorValue("TABLE",oTable).
{tpl.show}

DELETE OBJECT oTable.
DELETE OBJECT oArray.
DELETE OBJECT oAMinMode.
DELETE OBJECT oAMinCalc.
DELETE OBJECT oSysClass.
