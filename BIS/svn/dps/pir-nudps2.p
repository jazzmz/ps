/*****************************
 * Регистр налогового учета
 * по депозитным договорам.
 *****************************
 *
 * Автор: Маслов Д. А.
 * Дата создания: 04.02.13
 * Заявка: #1294
 *
 ******************************/


 {globals.i}
 {tmprecid.def}
 {intrface.get comm}
 {intrface.get dps}
 {intrface.get dpspr}

 {ulib.i}

 {tmprecid.def}
 DEF VAR oTpl      AS TTpl                 NO-UNDO.
 DEF VAR oTable    AS TTable2              NO-UNDO.
 DEF VAR dBegDate  AS DATE INIT 01/11/2012 NO-UNDO.
 DEF VAR dEndDate  AS DATE INIT 08/01/2012 NO-UNDO.
 DEF VAR iBegDate  AS DATE INIT 01/11/2012 NO-UNDO.
 DEF VAR iEndDate  AS DATE INIT 08/01/2012 NO-UNDO.
 DEF VAR period    AS INT                  NO-UNDO.

 DEF VAR i         AS INT  INIT 1          NO-UNDO.

 DEF VAR key1      AS CHAR                 NO-UNDO.
 DEF VAR val1      AS CHAR                 NO-UNDO.
 DEF VAR key2      AS CHAR                 NO-UNDO.
 DEF VAR val2      AS CHAR                 NO-UNDO.
 DEF VAR tmpDate   AS CHAR                 NO-UNDO.

 DEF VAR oLoan     AS TLoan                NO-UNDO.
 DEF VAR acctMain  AS TAcct                NO-UNDO.

 DEF VAR oSysClass       AS TSysClass      NO-UNDO.
 DEF VAR acctFrost       AS TAArray        NO-UNDO.
 DEF VAR acctFrostPoints AS TAArray        NO-UNDO.

 DEF VAR cbref%    AS TAArray              NO-UNDO.
 DEF VAR d%        AS TAArray              NO-UNDO.
 DEF VAR dPos      AS DEC                  NO-UNDO.

 DEF VAR field4    AS DEC INIT 0           NO-UNDO.
 DEF VAR field5    AS DEC INIT 0           NO-UNDO.
 DEF VAR field6    AS DEC INIT 0           NO-UNDO.

 DEF VAR nach%     AS DEC                  NO-UNDO.
 DEF VAR p%        AS DEC                  NO-UNDO.
 DEF VAR max%      AS DEC                  NO-UNDO.
 DEF VAR d         AS DEC                  NO-UNDO.
 DEF VAR pcbrf     AS DEC                  NO-UNDO.
 DEF VAR currCbrf  AS DEC                  NO-UNDO.
 DEF VAR dDiff%    AS DEC                  NO-UNDO.

 {getdates.i}

 ASSIGN
  dBegDate = beg-date
  dEndDate = end-date
 .

/**
 * Находит ставку рефинансирования на дату.
 **/

FUNCTION getCbrefDiff RETURNS TAArray (INPUT dBegDate AS DATE,INPUT dEndDate AS DATE):
 DEF VAR vCBRefComm AS CHAR    NO-UNDO.
 DEF VAR oAArray    AS TAArray NO-UNDO.

 oAArray = NEW TAArray().

 FOR EACH comm-rate WHERE comm-rate.commi     EQ "%ЦбРеф"
                      AND comm-rate.filial-id EQ shfilial
                      AND comm-rate.branch-id EQ ""
                      AND comm-rate.acct      EQ "0"
                      AND comm-rate.currency  EQ ""
                      AND comm-rate.since <= dEndDate
                      NO-LOCK:
  oAArray:setH(comm-rate.since,comm-rate.rate-comm).

 END.



 RETURN oAArray.
END FUNCTION.

/**
 * Функция аналог find last Только для TAArray
 **/

FUNCTION findLast RETURNS DECIMAL (INPUT oAArray AS TAArray,INPUT dDate AS DATE):
   DEF VAR key1  AS CHAR NO-UNDO.
   DEF VAR val1  AS CHAR NO-UNDO.
   DEF VAR dPrev AS DEC  NO-UNDO.

   {foreach oAArray key1 val1}
         IF dDate >= DATE(key1) THEN DO:
             dPrev = DECIMAL(val1).
         END.
   {endforeach oAArray}
 RETURN dPrev.
END FUNCTION.


 oSysClass = NEW TSysClass().
 

 FIND FIRST tmprecid NO-LOCK.

      oTable = NEW TTable2().

      oLoan  = NEW TLoan(tmprecid.id).
        acctMain        = oLoan:getAcct(oLoan:getMainRole(),dBegDate).
        acctFrost       = acctMain:getStableIntervals(dBegDate,dEndDate).
        acctFrostPoints = NEW TAArray().

        cbref%    = getCbrefDiff(dBegDate,dEndDate).
        d%        = oLoan:getRates("%Депоз",dBegDate,dEndDate).


        /***
         * Целью этих конских телодвижений
         * является разбиение на периоды постоянства остатка.
         ***/

        /***
         * Развернули промежутки постоянства остатка в точки и одновременно добавили новые по ставкам.
         **/
        {foreach acctFrost key1 val1}
             ASSIGN
              iBegDate = DATE(ENTRY(1,key1,"-"))
              iEndDate = DATE(ENTRY(2,key1,"-"))
             .
            acctFrostPoints:setH(iBegDate,val1).

/*
 По телефонному разговору с Балан С.
 Предполагается следующая логика. Если во время
жизни договора не было изменения процентной ставки,
 то ставка рефинансирования берется на дату открытия.
Если была, то на дату отчета.

             {foreach cbref% key2 val2}
                  IF iBegDate < DATE(key2) AND DATE(key2) < iEndDate THEN DO:
                      acctFrostPoints:setH(DATE(key2) - 1,val1).
                      acctFrostPoints:setH(DATE(key2),val1).
                  END.
             {endforeach cbref%}
*/

             {foreach d% key2 val2}
                  IF iBegDate < DATE(key2) AND DATE(key2) < iEndDate THEN DO:
                      acctFrostPoints:setH(DATE(key2) - 1,val1).
                      acctFrostPoints:setH(DATE(key2),val1).
                  END.
             {endforeach d%}

            acctFrostPoints:setH(iEndDate,val1).
        {endforeach acctFrost}


            acctFrost:empty().

                i = 1.
            {foreach acctFrostPoints key1 val1}

                IF i MODULO 2  = 0 THEN DO:
                  tmpDate = tmpDate + "-" + key1.
                  acctFrost:setH(tmpDate,val1).
                END. ELSE DO:
                  tmpDate = key1.
                END.             
                i = i + 1.
            {endforeach acctFrostPoints}

        {foreach acctFrost key1 val1}
               iBegDate = DATE(ENTRY(1,key1,"-")).
               iEndDate = DATE(ENTRY(2,key1,"-")).
               period   = iEndDate - iBegDate + 1.
               p%       = findLast(d%,iBegDate) * 0.01.
               currCbrf = (IF d%:length > 1 THEN findLast(cbref%,iEndDate) ELSE findLast(cbref%,oLoan:open-date)).
               pcbrf    = currCbrf * 0.01 * (IF oLoan:currency = "" THEN 1.8 ELSE 0.8).
               dDiff%   = p% - pcbrf.
               dPos     = oSysClass:convert2Rur(INT(oLoan:currency),DEC(val1),dEndDate).


                nach%  = ROUND(period * dPos * p%     / TSysClass:getPercentBase(iBegDate),2).
                max%   = ROUND(period * dPos * pcbrf  / TSysClass:getPercentBase(iBegDate),2).
                d      = ROUND(period * dPos * dDiff% / TSysClass:getPercentBase(iBegDate),2).        
                field4 =  field4 + nach%.
                field5 =  field5 + max%.
                field6 =  field6 + d.             

	 oTable:addRow()
              :addCell(key1)
              :addCell(period)
              :addCell(dPos)
              :addCell(nach%)
              :addCell(max%)
              :addCell(d)
              :addCell(currCbrf)
              :addCell(pcbrf * 100)
              :addCell(p% * 100)              
              :addCell(TSysClass:getPercentBase(iBegDate)).
                 
        {endforeach acctFrost}
       oTable:addRow()       
             :addCell("ИТОГО:")
             :fillCells(2,"") 
             :addCell(field4) 
             :addCell(field5) 
             :addCell(field6) 
             :fillCells(4,"").

      field4 = 0.
      field5 = 0.
      field6 = 0.

       oTpl = NEW TTpl(IF oLoan:currency = "" THEN "pir-nudps2r.tpl" ELSE "pir-nudps2v.tpl").
       CASE oLoan:currency:
          WHEN "840" THEN DO:                
                oTpl:addAnchorValue("kurs",oSysClass:getCBRKurs(840,dEndDate)).
                oTpl:addAnchorValue("val","долларов США").
          END.
          WHEN "978" THEN DO:
                oTpl:addAnchorValue("kurs",oSysClass:getCBRKurs(978,dEndDate)).
                oTpl:addAnchorValue("val","евро").
          END.
          WHEN "826" THEN DO:
                oTpl:addAnchorValue("kurs",oSysClass:getCBRKurs(826,dEndDate)).
                oTpl:addAnchorValue("val","евро").
          END.
       END CASE.

       oTpl:addAnchorValue("begDate",dBegDate).
       oTpl:addAnchorValue("endDate",dEndDate).
       oTpl:addAnchorValue("TABLE",oTable).

      {tpl.show}

      DELETE OBJECT d%.
      DELETE OBJECT cbref%.
      DELETE OBJECT acctFrost.
      DELETE OBJECT acctFrostPoints.
      DELETE OBJECT acctMain.
      DELETE OBJECT oLoan.
      DELETE OBJECT oTable.
      DELETE OBJECT oSysClass.


   {tpl.delete}


