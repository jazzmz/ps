using Progress.Lang.*.
/***********************************************************
 *                                                                                                                *
 * Процедура формирует распоряжение по клиентским                *
 * курсам.                                                                                                  *
 * Относится к транзакции БМ->ОД->Insert->Конверсионные    *
 * операции -> (ПИРБАНК) КОНВЕРСИОННЫЕ ОПЕРАЦИИ     *
 * -> Продажа/Покупка (За рубли)                                                        *
 * Предполагается, что пользователь самостоятельно
 * с помощью фильтра отберет проводки
 *                                                                                                                 *
 ************************************************************
 * Автор: Маслов Д. А.                                                                          *
 * Дата создания: 16:42 11.05.2010                                                       *
 * Заявка: #315                                                                                        *
 ***********************************************************/

{tmprecid.def}
{globals.i}
/*****
 !!! ВНИМАНИЕ !!!! 
В: Один из документов не попадает в отчет. Что делать?
О: Проверить какое назначение стоит у клиентского счета. Должно быть одно из списка SettlementAccountSign
*****/

&SCOPED-DEFINE SettlementAccountSign Расчет*,Текущ*,Депоз*
&SCOPED-DEFINE CommDb КонверДб
&SCOPED-DEFINE CommCr КонверКР
&SCOPED-DEFINE kursXAttrName sprate


DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oTable AS TTable NO-UNDO.

DEF VAR oDocument AS TDocument NO-UNDO.
DEF VAR oClient AS TClient NO-UNDO.

DEF VAR iType AS INTEGER INITIAL 2 NO-UNDO.          /* Количество видов */
DEF VAR i AS INTEGER NO-UNDO.                               

DEF VAR dCurrDate AS DATE NO-UNDO.                  /* Текущая дата */
DEF VAR oSysClass AS TSysClass NO-UNDO.

dCurrDate=gend-date.

oSysClass = new TSysClass().

oTpl = new TTpl("pir-operkurs.tpl").

oTable = new TTable(5 * iType ).
oTable:addRow().
oTable:addCell("Сумма").
oTable:addCell("Вал").
oTable:addCell("Наименование клиента").
oTable:addCell("Ком").
oTable:addCell("Курс").
oTable:addCell("Сумма").
oTable:addCell("Вал").
oTable:addCell("Наименование клиента").
oTable:addCell("Ком").
oTable:addCell("Курс").


DEF TEMP-TABLE ttRecidEx NO-UNDO
                                     FIELD id AS RECID
                                     FIELD type AS INTEGER
                                     FIELD mark AS LOGICAL
                                     FIELD sum LIKE op-entry.amt-cur
                                     FIELD currency LIKE op-entry.currency
                                     FIELD name-short AS CHARACTER
                                     FIELD comission AS DECIMAL
                                     FIELD k AS DECIMAL
                                .

DEF BUFFER bfrttRecidEx FOR ttRecidEx.

DEF VAR oAcct-Db AS TAcctBal NO-UNDO.
DEF VAR oAcct-Cr AS TAcctBal NO-UNDO.

/********** ПРОИЗВОДИМ МАРКИРОВКУ ОПЕРАЦИЙ ПО ТИПАМ ********/

FOR EACH tmprecid,
        FIRST op-entry WHERE RECID(op-entry) = tmprecid.id NO-LOCK,
            FIRST op OF op-entry NO-LOCK:

            oDocument = new TDocument(op.op).
            oAcct-Cr = new TAcctBal(op-entry.acct-cr).

            IF CAN-DO("{&SettlementAccountSign}",oAcct-Cr:getXAttr("ЦельСч")) AND oAcct-Cr:val EQ 810  THEN 
                  DO:
                               /* По кредиту стоит клиентский рублевый счет, значит это продажа валюты */
                              CREATE ttRecidEx.
                                  ASSIGN  
                                       ttRecidEx.id = tmprecid.id
                                       ttRecidEx.type = 1
                                       ttRecidEx.mark = FALSE
                                       ttRecidEx.sum = op-entry.amt-cur
                                       ttRecidEx.currency = op-entry.currency
                                       ttRecidEx.name-short = oAcct-Cr:name-short
                                       ttRecidEx.comission = (DECIMAL(oDocument:getXAttr("PirConvComm")) * 100)
                                       ttRecidEx.k = DECIMAL(oDocument:getXAttr("{&kursXAttrName}"))                                       
                                   .
                   END.
            ELSE
                IF CAN-DO("{&SettlementAccountSign}",oAcct-Cr:getXAttr("ЦельСч"))  AND oAcct-Cr:val <> 810 THEN
                    DO:
                              /* По кредиту стоит клиентский валютный счет значит это покупка валюты */
                           CREATE ttRecidEx.
                              ASSIGN
                                   ttRecidEx.id = tmprecid.id
                                   ttRecidEx.type = 2
                                   ttRecidEx.mark = FALSE
                                   ttRecidEx.sum = op-entry.amt-cur
                                   ttRecidEx.currency = op-entry.currency
                                   ttRecidEx.name-short = oAcct-Cr:name-short
                                   ttRecidEx.comission = (DECIMAL(oDocument:getXAttr("PirConvComm")) * 100)
                                   ttRecidEx.k = DECIMAL(oDocument:getXAttr("{&kursXAttrName}"))
                                  .
                      END.

        DELETE OBJECT oAcct-Cr.
        DELETE OBJECT oDocument.
END.

/*************** КОНЕЦ МАРКИРОВКИ ПО ТИПАМ ***********/


/*********** ОСУЩЕСТВЛЯЕМ РАЗБИВКУ ПО ТИПАМ **************/

DO WHILE CAN-FIND(FIRST ttRecidEx WHERE ttRecidEx.mark = FALSE):
                /* До тех пор найден хотя бы один не помеченный */
            oTable:addRow().

                DO i = 1 TO iType:
                    /* Производим разбивку по типам */

                    FIND FIRST ttRecidEx WHERE ttRecidEx.type = i AND ttRecidEx.mark = FALSE NO-LOCK NO-ERROR.

                    IF AVAILABLE(ttRecidEx) THEN
                                    DO:
                                            oTable:addCell(ttRecidEx.sum).
                                            oTable:addCell(ttRecidEx.currency).
                                            oTable:addCell(ttRecidEx.name-short).
                                            oTable:addCell(ttRecidEx.comission).
                                            oTable:addCell(ttRecidEx.k).
                                            ttRecidEx.mark = TRUE.                     /* Помечаем как отображенный */
                                    END.
                                    ELSE 
                                        DO:
                                            oTable:addCell("").
                                            oTable:addCell("").
                                            oTable:addCell("").
                                            oTable:addCell("").
                                            oTable:addCell("").
                                        END.

                  END.
END.

/************** КОНЕЦ РАЗБИВКИ ПО ТИПАМ *********************/

oTpl:addAnchorValue("TABLE1",oTable).

oTpl:addAnchorValue("DATE",gend-date).

oTpl:addAnchorValue("КУРС1",oSysClass:getCBRKurs(840,gend-date)).
oTpl:addAnchorValue("КУРС2",oSysClass:getCBRKurs(978,gend-date)).
oTpl:addAnchorValue("КУРС3",oSysClass:getCBRKurs(826,gend-date)).


{setdest.i}
  oTpl:show().
{preview.i}

DELETE OBJECT oTable. 
DELETE OBJECT oSysClass.