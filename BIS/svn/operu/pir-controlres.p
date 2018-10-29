/********************************
 * Отчет.                       *
 * Для проверки правильности,   *
 * начисления резерва.          *
 *********************************
 * Автор: Маслов Д. А. (Maslov D. A.)
 * Дата создания: ....
 * Заявка: ....
 ********************************/

DEF VAR oTable    AS TTable    NO-UNDO.
DEF VAR oTableErr AS TTable    NO-UNDO.

DEF VAR oDTInput  AS TDTInput  NO-UNDO.
DEF VAR oTpl           AS TTpl      NO-UNDO.
DEF VAR oAcct     AS TAcct     NO-UNDO.
DEF VAR oUser     AS TUser     NO-UNDO.


DEF BUFFER bAcct FOR acct.

DEF VAR dPos  AS DECIMAL NO-UNDO.
DEF VAR dPos1 AS DECIMAL NO-UNDO.

DEF VAR oDocCollect AS CLASS TDocCollectWPos                            NO-UNDO.
DEF VAR dDifPos            AS DECIMAL INITIAL 0 LABEL "Разница остатков" NO-UNDO.
DEF VAR diffTime AS INTEGER LABEL "Время создания отчета"            NO-UNDO.


DEF VAR dCurrDate AS Date  NO-UNDO.

DEF VAR itmpOpId AS INTEGER LABEL "Временная для ID документа увелечения остатка"   NO-UNDO.
DEF VAR iDifDate AS INTEGER INITIAL 0 LABEL "Кол-во дней от последнего зачисления"  NO-UNDO.

DEF VAR cUserList AS CHARACTER NO-UNDO.


oDTInput = new TDTInput(3).
oDTInput:head = "Дата проверки?".
oDTInput:X = 210.
oDTInput:Y = 70.
oDTInput:show().

IF oDTInput:isSet THEN
DO:
dCurrDate = oDTInput:beg-date.
oTpl = new TTpl("pir-controlres.tpl").
oTable = new TTable(3).
oTableErr = new TTable(2).


diffTime = TIME.

oUser = new TUser().
cUserList = oUser:getUserList("05-u10-1").

FOR EACH acct WHERE acct BEGINS "47423" AND close-date=? 
                    AND CAN-DO(cUserList,user-id)  NO-LOCK:
      /* По всем счетам 47423
         ответсвенные которых
         SUDNIK, SERGEEVA, ZHUKOVA
      */
      /* Определеляем остаток на сегодня */      
     oAcct=new TAcct(acct.acct).
      dPos=oAcct:getLastPos2Date(dCurrDate).       
     DELETE OBJECT oAcct.
     
   IF dPos NE 0 THEN
     DO:
       /* Остаток не нулевой */
    FIND FIRST bAcct WHERE CAN-DO("47425" + SUBSTRING(acct.acct,6,3) + "*" + SUBSTRING(acct.acct,17,4),bAcct.acct) 
                                                    AND bAcct.cust-cat=acct.cust-cat AND bAcct.cust-id = acct.cust-id
                                                    NO-LOCK NO-ERROR.

       IF AVAILABLE(bAcct) THEN
         DO:
           /* Смотрим остаток на аналогичном 47425 */
           oAcct=new TAcct(bAcct.acct).
             dPos1=oAcct:getLastPos2Date(dCurrDate).
           DELETE OBJECT oAcct.
           dDifPos = dPos - dPos1.
             IF dDifPos <> 0 THEN
               DO:
                  /* 
                     РЕШЕНИЕ В ЛОБ!!! ДУМАЮ МОЖНО СДЕЛАТЬ БЫСТРЕЕ!!!
                     1. На счете требования по операциям ненулевой остаток.
                     2. Остаток на счете резерва не равен остатку на счете по
                     требованиями.
                     3. Делаем вывод возможно потребуется доначисление резерва.
                     4. Смотрим последнюю операцию приводящую к списанию со счета требования по прочим операциям в ноль.
                     5. Смотрим следующую за ней операцию, приводящую к увелечению остатка на счете. То есть последнюю операцию выводящую остаток
по счету из нуля.
                     6. Вычисляем количество дней между текущей датой и датой этой операции(делающий остаток ненулевой).
                     7. Если кол-во дней больше 30, то доначисляем 100 резерв.                 
                */
                                   
                  oDocCollect = new TDocCollectWPos().
                  oDocCollect:minPos = 0.
                  oDocCollect:maxPos = 0.
                  oDocCollect:filter-acct=acct.acct.                  

                  oDocCollect:applyFilter().

                  IF oDocCollect:DocCount > 0 THEN
                    DO:                    
                         itmpOpId=oDocCollect:getDocument(oDocCollect:DocCount):doc-id.
                         FIND FIRST op-entry WHERE op-entry.acct-db=acct.acct AND op-entry.op>itmpOpId NO-LOCK.
                             iDifDate = dCurrDate - op-entry.op-date.
                    END.
                    ELSE
                      DO:
                        /* 
                        Остаток на счете ненулевой, списания не было 
                        то есть зачисление есть первая операция
                        */
                     FIND FIRST op-entry WHERE op-entry.acct-db=acct.acct NO-LOCK.
                     iDifDate = dCurrDate - op-entry.op-date.                     
                    END.
                   oTable:addRow().
                   oTable:addCell(acct.acct).
                   oTable:addCell(iDifDate).
                   oTable:addCell(dDifPos).

                   DELETE OBJECT oDocCollect.                   

            END. /* Конец остатки не равны */               
         END.        /* Конец найден счет 47425*/
         ELSE
           DO:
                oTableErr:addRow().
                oTableErr:addCell(acct.acct).
                oTableErr:addCell("Счет резерва не найден").
           END.        /* Конец не найден счет 47423 */
     END.
 END.          
diffTime = TIME - diffTime.
oTpl:addAnchorValue("DATE-CREATE",STRING(dCurrDate)).
oTpl:addAnchorValue("TABLE1",oTable).

IF oTableErr:height GT 0 THEN oTpl:addAnchorValue("TABLEERR",oTableErr).
                         ELSE oTpl:addAnchorValue("TABLEERR","Ошибок не найдено.").

oTpl:addAnchorValue("TIME-RUN",STRING(diffTime)).
{setdest.i}
oTpl:show().
{preview.i}
DELETE OBJECT oUser.
DELETE OBJECT oTable.
DELETE OBJECT oTableErr.
DELETE OBJECT oTpl.
END.
DELETE OBJECT oDTInput.