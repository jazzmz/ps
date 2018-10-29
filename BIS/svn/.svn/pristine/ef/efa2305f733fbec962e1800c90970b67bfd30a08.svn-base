DEFINE VARIABLE oAcct AS CLASS TAcct NO-UNDO.

DEFINE BUFFER bAcct FOR acct.

DEF VAR dPos  AS DECIMAL NO-UNDO.
DEF VAR dPos1 AS DECIMAL NO-UNDO.

DEF VAR oDocCollect AS CLASS TDocCollectWPos 			  NO-UNDO.
DEF VAR dDifPos     AS DECIMAL INITIAL 0 LABEL "Разница остатков" NO-UNDO.

DEF VAR itmpOpId AS INTEGER LABEL "Временная для ID документа увелечения остатка" NO-UNDO.

DEF VAR iDifDate AS INTEGER INITIAL 0 LABEL "Кол-во дней от последнего зачисления" NO-UNDO.

{globals.i}
{setdest.i}

PUT UNFORMATTED "ПРОВЕРКА НА НЕОБХОДИМОСТЬ ДОНАЧИСЛЕНИЯ РЕЗЕРВА" SKIP.
FOR EACH acct WHERE acct BEGINS "47423" AND close-date=? AND (user-id="SUDNIK" OR user-id="SERGEEVA" OR user-id="ZHUKOVA") NO-LOCK:
      /* По всем счетам 47423
         ответсвенные которых
         SUDNIK, SERGEEVA, ZHUKOVA
      */
      /* Определеляем остаток на сегодня */      
     oAcct=new TAcct(acct.acct).
      dPos=oAcct:getLastPos2Date(TODAY).       
     DELETE OBJECT oAcct.
     
   IF dPos NE 0 THEN
     DO:
       /* Остаток не нулевой */
    FIND FIRST bAcct WHERE CAN-DO("47425" + SUBSTRING(acct.acct,6,3) + "*" + SUBSTRING(acct.acct,16,5),bAcct.acct) NO-LOCK NO-ERROR.
       IF AVAILABLE(bAcct) THEN
         DO:
           /* Смотрим остаток на аналогичном 47425 */
           oAcct=new TAcct(bAcct.acct).
             dPos1=oAcct:getLastPos2Date(TODAY).
           DELETE OBJECT oAcct.
           dDifPos = dPos - dPos1.
             IF dDifPos > 0 THEN
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
                     7. Если кол-во дней больше 30, то доначисляем 100 резерв.                 */
                                   
                  oDocCollect = new TDocCollectWPos().
                  oDocCollect:minPos = 0.
                  oDocCollect:maxPos = 0.
                  oDocCollect:filter-acct=acct.acct.                  

                  oDocCollect:applyFilter().

                  IF oDocCollect:DocCount > 0 THEN
                    DO:
                     
                    PUT UNFORMATTED "Проверяем счет - " acct.acct + "|".
                    itmpOpId=oDocCollect:getDocument(oDocCollect:DocCount):doc-id.
            FIND FIRST op-entry WHERE op-entry.acct-db=acct.acct AND op-entry.op>itmpOpId.
            iDifDate = TODAY - op-entry.op-date.
/*            PUT UNFORMATTED STRING(iDifDate) + "|" + STRING(dDifPos) SKIP.*/

                    END.
                    ELSE
                      DO:
                        /* 
                        Остаток на счете ненулевой, списания не было 
                        то есть зачисление есть первая операция
                        */
                     FIND FIRST op-entry WHERE op-entry.acct-db=acct.acct.
                     iDifDate = TODAY - op-entry.op-date.                     
                    END.
                  PUT UNFORMATTED STRING(iDifDate) + "|" + STRING(dDifPos) SKIP.
                   DELETE OBJECT oDocCollect.
                   
            END. /* Конец остатки не равны */               
         END.        /* Конец найден счет 47425*/
         
     END.
 END.          
{preview.i}