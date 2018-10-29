/*****************************************
 *                                       *
 * Отчет "Распоряжение по начислению %". *
 *                                       *
 *****************************************
 * Автор: Маслов Д. А.                   *
 * Дата создания: 20.03.12               *
 * Заявка: #838                          *
 ******************************************/

{globals.i}

{def_work.i new}
{intrface.get date}

{tmprecid.def}

/** Сделаем расчет по Входящему остатку **/
in_out_ost = YES.


/*** КОНФИГУРАЦИЯ ***/

DEF VAR scheme    AS CHAR INIT "IsG140" NO-UNDO.
DEF VAR in-commi  AS CHAR INIT "ds1-59" NO-UNDO.

/*** КОНЕЦ КОНФИГУРАЦИИ ***/

DEF VAR nach_h AS HANDLE NO-UNDO.
DEF VAR currDate  AS DATE 		  NO-UNDO.
DEF VAR begDate   AS DATE INIT 01/01/2012 NO-UNDO.
DEF VAR endDate   AS DATE INIT 01/31/2012 NO-UNDO.

DEF VAR mDays     AS INT 		  NO-UNDO.
DEF VAR dMinValue AS DECIMAL INIT 0       NO-UNDO.
DEF VAR percent AS DECIMAL INIT 0         NO-UNDO.
DEF VAR basis-time AS DECIMAL INIT 0      NO-UNDO.

DEF VAR sum1      AS DECIMAL NO-UNDO.
DEF VAR sum2      AS DECIMAL NO-UNDO.
DEF VAR sum3      AS DECIMAL NO-UNDO.

DEF VAR AmtStr    AS CHAR EXTENT 2 NO-UNDO.

DEF VAR oTpl    AS TTpl    NO-UNDO.
DEF VAR oTable1 AS TTable  NO-UNDO.
DEF VAR oTable2 AS TTable  NO-UNDO.

DEF VAR oAcct   AS TAcct   NO-UNDO.
DEF VAR oClient AS TClient NO-UNDO.

DEF VAR extDocNum  AS CHAR NO-UNDO.
DEF VAR extDocDate AS CHAR NO-UNDO.

{getdates.i}

begDate = beg-date.
endDate = end-date.

{getdate.i}

{setdest.i}
currDate = end-date.


RUN load_nachtool(YES,OUTPUT nach_h).


/**
 * Строим таблицу фрост.
 * @var RECID rid RID на счет
 * @void
 **/
FUNCTION buildFrost RETURNS LOGICAL (INPUT rid AS RECID,INPUT begDate AS DATE,INPUT endDate AS DATE):

     /* Схема начисления */
     DEF VAR rid1      AS RECID              NO-UNDO.

     FIND FIRST acct WHERE RECID(acct) = rid NO-LOCK.

     /** Построили фрост **/
     RUN CREATE_REAL_FOST in nach_h(RECID(acct),begDate,endDate).

     /** Заполнили ставками, это в данном случае лишнее, но оставлю на память **/
     RUN CREATE_RATE_CR   in nach_h(in-commi,RECID(acct),"",?,0,?,endDate).

     /** Получили указатель на действующую схему начисления **/
     RUN GET_CURRENCT_SCHEME in nach_h (scheme,acct.acct,acct.currency,?,endDate, output rid1).

     /** Заполнили параметры схемы начисления **/
     RUN GET_SCH_LINE_BY_RID IN nach_h (rid1, BUFFER interest-sch-line).

    RETURN TRUE.
END FUNCTION.

/************
 * Тело отчета 
 *************/

FOR EACH tmprecid NO-LOCK,
  FIRST acct WHERE RECID(acct) = tmprecid.id NO-LOCK:

oTpl = new TTpl("pir-dps859.tpl").
RUN DELETE_FOST IN nach_h.

buildFrost(RECID(acct),begDate,endDate).

RUN GetMinAmt in nach_h(OUTPUT dMinValue).

oTable1 = new TTable(2).

FOR EACH fost:
    oTable1:addRow().
     oTable1:addCell(fost.since).
     oTable1:addCell(fost.balance).
END.


RUN DELETE_FOST in nach_h.


/**********
 * Производим расчет
 * по минимальному значению.
 **********/

RUN CREATE_SINGLE_REM_FOST in nach_h (begDate,dMinValue).

mDays = cDay(interest-sch-line.interest-month,begDate,endDate + 1).

RUN CREATE_RATE_CR IN nach_h (in-commi,RECID(acct), ?, ?, ?, mDays, endDate).

FIND FIRST fost NO-LOCK.
percent = fost.rate.
basis-time = interest-sch-line.basis-time.

RUN NACH_AND_REPORT IN nach_h (interest-sch-line.interest-sch,
                               acct.acct,
                               acct.currency,
                               ?,
                               begDate,
                               endDate,
                               interest-sch-line.interest-month,
                               interest-sch-line.basis-time).

RUN RESULT_CALC IN nach_h(OUTPUT sum1, OUTPUT sum2, OUTPUT sum3).
RUN DELETE_REPORT IN nach_h.

oTable2 = new TTable(7).
oTable2:addRow().
oTable2:addCell(acct.acct).
oTable2:addCell(begDate).
oTable2:addCell(endDate).
oTable2:addCell(mDays).
oTable2:addCell(dMinValue).
oTable2:addCell(percent).
oTable2:addCell(sum1).


Run x-amtstr.p(sum1,acct.currency,true,true,output amtstr[1], output amtstr[2]).

oClient = new TClient(acct.acct).

oAcct = new TAcct(acct.acct).

oTpl:addAnchorValue("NAME",oClient:name-short).
oTpl:addAnchorValue("currDate",currDate).
oTpl:addAnchorValue("EXTDOCNUM",ENTRY(2,oAcct:getXAttr("PIRSubAgree"))).
oTpl:addAnchorValue("EXTDOCDATE",STRING(DATE(ENTRY(1,oAcct:getXAttr("PIRSubAgree"))),"99.99.9999")).
oTpl:addAnchorValue("DOCNUM",ENTRY(2,oAcct:getXAttr("ДогОткрЛС"))).
oTpl:addAnchorValue("DOCDATE",STRING(DATE(ENTRY(1,oAcct:getXAttr("ДогОткрЛС"))),"99.99.9999")).
oTpl:addAnchorValue("ACCT",acct.acct).
oTpl:addAnchorValue("SUMM",sum1).
oTpl:addAnchorValue("SUMSTR",amtstr[1] + " " + amtstr[2]).
oTpl:addAnchorValue("TABLE1",oTable1).
oTpl:addAnchorValue("TABLE2",oTable2).
oTpl:addAnchorValue("begDate",begDate).
oTpl:addAnchorValue("endDate",endDate).

oTpl:show().
{tpl.delete}
DELETE OBJECT oClient.
DELETE OBJECT oAcct.
PAGE.
/***
 Расчет начисления и формирование отчета 
 ***/
END. /* По выделенным счетам */
{preview.i}

RUN remove_nachtool (NO, nach_h).

