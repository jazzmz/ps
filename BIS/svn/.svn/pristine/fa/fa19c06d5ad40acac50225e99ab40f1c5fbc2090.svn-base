/**************************************************************
 * Отчет для отображения контролируемых                       *
 * сделок.                                                    *
 * Логика состоит из трех этапов:                             *
 *    Этап №1: Отбираем всех нерезидентов и собираем          *
 * их ГВК;                                                    *
 *    Этап №2: По каждому из ГВК просчитываем доходы.         *
 * Если доходы > указанного значения, то сделки по нерезам    *
 * из указанного ГВК относятся к контроллируемым.             *
 *    Этап №3: Выводим отчет.                                 *
 **************************************************************
 * Автор : Маслов Д. А. Maslov D. A.                          *
 * Заявка: #2607                                              *
 * Дата  : 01.04.13                                           *
 ***************************************************************/
 {globals.i}
 {intrface.get xclass}



 DEF INPUT PARAM in-Data-Id LIKE DataBlock.Data-Id NO-UNDO.
 DEF INPUT PARAM cParam                    AS CHAR NO-UNDO.



 FUNCTION calcOneGain RETURNS DEC(
                                  INPUT cCust-Cat AS CHAR,
                                  INPUT PK AS INT64,
                                  INPUT dBegDate AS DATE,
                                  INPUT dEndDate AS DATE
                                  ):

   DEF BUFFER acct     FOR acct.
   DEF BUFFER op       FOR op.
   DEF BUFFER op-entry FOR op-entry.

   DEF VAR dRes AS DEC NO-UNDO.
        

    FOR EACH acct WHERE acct.cust-cat = cCust-Cat
                    AND acct.cust-id  = PK NO-LOCK:

          /**********************************
           * По всем счетам клиента         *
           * смотрим оборот.                *
           **********************************
           * Обороты по ДБ.                 *
           **********************************/

            FOR EACH op-entry WHERE op-entry.op-date >= dBegDate AND op-entry.op-date <= dEndDate AND op-entry.op-date <> ?
                                AND op-entry.acct-db EQ acct.acct 
                                AND op-entry.acct-cr BEGINS '7' NO-LOCK,
              FIRST op OF op-entry WHERE CAN-DO("!Курс*,!Нуль,!Сальдо,*",op.op-kind) NO-LOCK:
                  dRes = dRes + op-entry.amt-rub.
            END.

         /**********************************
          * По всем счетам клиента         *
          * смотрим оборот.                *
          **********************************
          * Обороты по КР.
          **********************************/


            FOR EACH op-entry WHERE op-entry.op-date >= dBegDate AND op-entry.op-date <= dEndDate AND op-entry.op-date <> ?
                                AND op-entry.acct-cr EQ acct.acct 
                                AND op-entry.acct-db BEGINS '7' NO-LOCK,
              FIRST op OF op-entry WHERE CAN-DO("!Курс*,!Нуль,!Сальдо,*",op.op-kind) NO-LOCK:
                  dRes = dRes + op-entry.amt-rub.
            END.

    END. /* конец FOR EACH acct */

   RETURN dRes.

 END FUNCTION.


   /*************************
    * По всем клиентам, которые
    * находятся в группе "ГВК".
    * Считаем прибыль/убыток.
    * @param CHAR gvk      Группа взаимосвязанных клиентов
    * @param DATE dBegDate Дата начала расчета
    * @param DATE dEndDate Дата окончания расчета
    * @return DEC
    **************************/
 FUNCTION calcMaxGain RETURNS DECIMAL(INPUT gvk AS CHAR,
                                      INPUT dBegDate AS DATE,
                                      INPUT dEndDate AS DATE
                                      ):

   DEF BUFFER tmpsigns FOR tmpsigns.


   DEF VAR dRes    AS DEC INIT 0 NO-UNDO.
   
   DEF VAR cCust-Cat AS CHAR     NO-UNDO.


   IF gvk BEGINS "ГВК" THEN DO:

   /***
    * Отбираем всех клиентов
    * которые в заданный промежуток
    * состояли в указанном ГВК
    ***/
   FOR EACH tmpsigns WHERE   tmpsigns.code        = "ГВК"
                         AND tmpsigns.code-value  = gvk
                         AND tmpsigns.since      <= dEndDate NO-LOCK:


    CASE tmpsigns.file-name:
        WHEN "person" THEN DO:
             cCust-Cat = "Ч".
        END.
        WHEN "cust-corp" THEN DO:
             cCust-Cat = "Ю".
        END.
    END CASE.                        
    
     dRes = dRes + calcOneGain(cCust-Cat,INT64(tmpsigns.surrogate),dBegDate,dEndDate).    

   END.  /* конец FOR EACH tmpsigns */
  END. ELSE DO:
          RETURN calcOneGain(SUBSTR(gvk,1,1),INT64(SUBSTR(gvk,3)),dBegDate,dEndDate).
  END.

  RETURN dRes.

 END FUNCTION.

 /**
  * Функция добавляет в список новое значение, 
  * при этом если в списке уже содержится такое значение,
  * то ничего не просходит.
  * @param  CHAR cList     Списко значений
  * @param  CHAR cNewValue Значение которое должно быть добавлено в список
  * @return CHAR
  **/
 FUNCTION newToList RETURNS CHAR(INPUT cList AS CHAR,INPUT cNewValue AS CHAR):
   DEF VAR i AS INT NO-UNDO.

   cList = (IF cList = ? THEN "" ELSE cList).

   DO i = 1 TO NUM-ENTRIES(cList,"|"):
        IF ENTRY(i,cList,"|") = cNewValue THEN DO:
            RETURN cList.
        END.
   END.

  RETURN cList + (IF cList <> "" THEN "|" ELSE "") + cNewValue.  
 END FUNCTION.

 /**
  * Функция строит по клиенту таблицу
  * со всеми контролируемыми сделками
  **/
 FUNCTION addInfo RETURNS LOG (
                               INPUT cCust-Cat AS CHAR,
                               INPUT PK        AS INT64,
                               INPUT orgCount  AS INT64,
                               INPUT dBegDate  AS DATE,
                               INPUT dEndDate  AS DATE,
                               INPUT oTable    AS TTable2
                              ):

  DEF BUFFER acct FOR acct.
  DEF VAR oClient AS TClient    NO-UNDO.

  DEF VAR dRes       AS DEC INIT 0 NO-UNDO.
  DEF VAR vLineCount AS INT INIT 0 NO-UNDO.
  DEF VAR vResItog   AS DEC INIT 0 NO-UNDO.

  oClient = NEW TClient(cCust-Cat,PK).

        oTable:addRow()
              :addCell(orgCount)
              :addCell(oClient:name-short)
              :addCell("")
              :addCell("")
        .


    FOR EACH acct WHERE acct.cust-cat = cCust-Cat
                    AND acct.cust-id  = PK NO-LOCK:

          /**********************************
           * По всем счетам клиента         *
           * смотрим оборот.                *
           **********************************
           * Обороты по ДБ.                 *
           **********************************/

            FOR EACH op-entry WHERE op-entry.op-date >= dBegDate AND op-entry.op-date <= dEndDate
                                AND op-entry.acct-db EQ acct.acct 
                                AND op-entry.acct-cr BEGINS '7' NO-LOCK,
              FIRST op OF op-entry WHERE CAN-DO("!Курс*,!Нуль,!Сальдо,*",op.op-kind) NO-LOCK:
                  dRes = dRes + op-entry.amt-rub.
                  vLineCount = vLineCount + 1.

                  oTable:addRow()
                        :addCell(STRING(orgCount) + "." + STRING(vLineCount))
                        :addCell("")
                        :addCell(op.details)
                        :addCell(STRING(op-entry.amt-rub,"->>>,>>>,>>>,>>9.99"))
                  .
            END.

         vResItog = vResItog + dRes.

         /**********************************
          * По всем счетам клиента         *
          * смотрим оборот.                *
          **********************************
          * Обороты по КР.
          **********************************/

            dRes = 0.

            FOR EACH op-entry WHERE op-entry.op-date >= dBegDate AND op-entry.op-date <= dEndDate
                                AND op-entry.acct-cr EQ acct.acct 
                                AND op-entry.acct-db BEGINS '7' NO-LOCK,
              FIRST op OF op-entry WHERE CAN-DO("!Курс*,!Нуль,!Сальдо,*",op.op-kind) NO-LOCK:
                  dRes = dRes + op-entry.amt-rub.

                   vLineCount = vLineCount + 1.

                  oTable:addRow()
                        :addCell(STRING(orgCount) + "." + STRING(vLineCount))
                        :addCell("")
                        :addCell(op.details)
                        :addCell(STRING(op-entry.amt-rub,"->>>,>>>,>>>,>>9.99"))
                  .

            END.
    END.

         vResItog = vResItog + dRes.

         oTable:addRow()
               :addCell("")
               :addCell("Итого по компании:")
               :addCell("")
               :addCell(STRING(vResItog,"->>>,>>>,>>>,>>9.99"))
         .


  DELETE OBJECT oClient.

 END FUNCTION.

 DEF VAR currGVK AS CHAR    NO-UNDO.
 DEF VAR key1    AS CHAR    NO-UNDO.
 DEF VAR val1    AS CHAR    NO-UNDO.


 DEF VAR dLimit    AS DEC INIT 50000000 NO-UNDO.
 DEF VAR oAArray   AS TAArray        NO-UNDO.
 DEF VAR oCntArray AS TAArray        NO-UNDO.
 DEF VAR lst       AS TAArray        NO-UNDO.

 DEF VAR currDate  AS DATE           NO-UNDO.
 DEF VAR currGain  AS DEC            NO-UNDO.

 DEF VAR dBegDate  AS DATE           NO-UNDO.
 DEF VAR dEndDate  AS DATE           NO-UNDO. 
 DEF VAR newValue  AS CHAR           NO-UNDO.

 DEF VAR vLnCountInt AS INT NO-UNDO.
 DEF VAR vLnTotalInt AS INT NO-UNDO.

 DEF VAR currLst     AS CHAR NO-UNDO.
 DEF VAR currClnPK   AS CHAR NO-UNDO.
 DEF VAR i           AS INT  NO-UNDO.

 DEF VAR oTable      AS TTable2    NO-UNDO.
 DEF VAR dNum        AS INT INIT 0 NO-UNDO.

 DEF VAR orgCount    AS INT INIT 0 NO-UNDO.


 currDate = TODAY.

 oTable = NEW TTable2().


 ASSIGN
   dBegDate = gbeg-date
   dEndDate = gend-date
 .

 {tpl.create}

 /********************************************
  * Этап №1. Собираем "подозрительные" ГВК   *
  ********************************************/

 oAArray   = NEW TAArray().
 oCntArray = NEW TAArray().


 /**********************************
  * Критерий №1. Юрик нерезидент.  *
  **********************************/
 FOR EACH cust-corp WHERE cust-corp.country-id <> 'RUS' AND cust-corp.date-in <= dBegDate  AND (cust-corp.date-out >= dEndDate OR cust-corp.date-out = ?) NO-LOCK:
    currGVK  = getTempXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"ГВК",currDate,"Ю-" + STRING(cust-corp.cust-id)).

    newValue = newToList(oAArray:get(currGVK),"Ю," + STRING(cust-corp.cust-id)).

    oAArray:setH(currGVK,newValue).
 END.

 /***********************************
  * Критерий №2. Физик нерезидент.  *
  ***********************************/
 FOR EACH person WHERE person.country-id <> 'RUS' AND cust-corp.date-in <= dBegDate  AND (person.date-out >= dEndDate OR person.date-out = ?) NO-LOCK:
    currGVK  = getTempXAttrValueEx("person",STRING(person.person-id),"ГВК",currDate,"Ч-" + STRING(person.person-id)).
    newValue = newToList(oAArray:get(currGVK),"Ч," + STRING(person.person-id)).
    oAArray:setH(currGVK,newValue).
 END.

  /***********************************
   * Критерий №3.                    *
   * Взаимозависимое с банком лицо.  *
   ***********************************/

  FOR EACH cust-role WHERE cust-role.file-name EQ "person" 
                       AND cust-role.class-code EQ "ПИРВзаимосвязанный" NO-LOCK,
         FIRST person WHERE person.person-id = INT64(cust-role.surrogate) AND cust-corp.date-in <= dBegDate  AND (cust-corp.date-out >= dEndDate OR cust-corp.date-out = ?) NO-LOCK:

    currGVK  = getTempXAttrValueEx("person",STRING(cust-role.surrogate),"ГВК",currDate,"Ч-" + STRING(cust-role.surrogate)).
    newValue = newToList(oAArray:get(currGVK),"Ч," + STRING(cust-role.surrogate)).
    oAArray:setH(currGVK,newValue).
  END.                      

  /************************************
   * Критерий №4. Взаимозависимое с   *
   * банком лицо.                     *
   ************************************/

  FOR EACH cust-role WHERE cust-role.file-name EQ "cust-corp" 
                       AND cust-role.class-code EQ "ПИРВзаимосвязанный" NO-LOCK,
               FIRST cust-corp WHERE cust-corp.cust-id = INT64(cust-role.surrogate) AND cust-corp.date-in <= dBegDate  AND (cust-corp.date-out >= dEndDate OR cust-corp.date-out = ?) NO-LOCK:

    currGVK  = getTempXAttrValueEx("person",STRING(cust-role.surrogate),"ГВК",currDate,"Ю-" + STRING(cust-role.surrogate)).
    newValue = newToList(oAArray:get(currGVK),"Ю," + STRING(cust-role.surrogate)).
    oAArray:setH(currGVK,newValue).
  END.                      


 /********************************************
  * Этап №2. Обсчитываем прибыль по ГВК.     *
  ********************************************/
 {setdest.i}
  {init-bar.i "Обработка клиентов ..."}
  vLnTotalInt = oAArray:length.

  {foreach oAArray key1 val1}

       
       currGain = calcMaxGain(key1,dBegDate,dEndDate).

       IF  currGain > dLimit THEN DO:
           /* Доход по ГВК превосходит пограничный лимит */
           oCntArray:setH(key1,currGain).
       END.

       {move-bar.i vLnCountInt vLnTotalInt}
       vLnCountInt = vLnCountInt + 1.

  {endforeach oAArray}



 /*********************************************
  * Этап №3. Выводим контролируемуе сделки    *
  *********************************************/

  {foreach oCntArray key1 val1}
       currLst = oAArray:get(key1).       

       DO i = 1 TO NUM-ENTRIES(currLst,"|"):
          currClnPK = ENTRY(i,currLst,"|").  
          orgCount  = orgCount + 1.

          addInfo(ENTRY(1,currClnPK),INT64(ENTRY(2,currClnPK)),orgCount,dBegDate,dEndDate,oTable).
       END.

  {endforeach oCntArray}

 oTpl:addAnchorValue("TABLE",oTable).
 oTpl:addAnchorValue("YEAR",{term2str dBegDate dEndDate}).
 oTpl:show().
 
 {preview.i}

 DELETE OBJECT oAArray.
 DELETE OBJECT oCntArray.
 DELETE OBJECT oTable.
 DELETE OBJECT oTpl.

 


{intrface.del}