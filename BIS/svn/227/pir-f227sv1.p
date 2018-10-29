/********************************************
 * Сводный регистр по налогам.              *
 *                                          *
 ********************************************
 * Автор        : Маслов Д. А. Maslov D. A. *
 * Дата создания: 19.03.13                  *
 * Заявка       : #2335                     *
 ********************************************/

 DEF INPUT PARAM in-data-id LIKE DataBlock.Data-Id NO-UNDO.


 FUNCTION getOneOperValue RETURNS DECIMAL (INPUT dBegDate AS DATE,INPUT dEndDate AS DATE,INPUT cOper AS CHAR):

    DEF BUFFER PDataBlock    FOR DataBlock.
    DEF BUFFER PDataLine     FOR DataLine.

    DEF VAR dRes AS DEC INIT 0 NO-UNDO.

    FOR EACH PDataBlock WHERE PDataBlock.DataClass-id EQ 'f227_2' 
                          AND PDataBlock.Beg-Date     EQ dBegDate
                          AND PDataBlock.End-Date     EQ dEndDate NO-LOCK,
       EACH PDataLine WHERE  PDataLine.data-id       EQ PDataBlock.data-id
                         AND CAN-DO(cOper,PDataLine.Sym1) NO-LOCK BREAK BY PDataLine.Sym1:
       dRes = dRes + PDataLine.val[5].

    END.
  RETURN dRes.
 END FUNCTION.

 FUNCTION getOperName RETURNS CHAR (INPUT cOperName AS CHAR):

  FIND FIRST code WHERE code.class  EQ 'PirF227OName' 
                    AND code.parent EQ 'PirF227OName'
                    AND code.code EQ cOperName NO-ERROR.

  IF AVAILABLE(code) THEN DO:
     RETURN code.name.
  END. ELSE DO:
     RETURN cOperName.
  END.

 END FUNCTION.

 {globals.i}

 DEF BUFFER currDataBlock FOR DataBlock.
 DEF BUFFER PDataBlock    FOR DataBlock.
 DEF BUFFER PDataLine     FOR DataLine.

 DEF VAR oRes     AS TAArray       NO-UNDO.
 DEF VAR oResNP   AS TAArray       NO-UNDO.
 DEF VAR oResNDS  AS TAArray       NO-UNDO.

 DEF VAR maskFind AS CHAR          NO-UNDO.

 DEF VAR dSum     AS DEC    INIT 0 NO-UNDO.
 DEF VAR dSum1    AS DEC    INIT 0 NO-UNDO.

 DEF VAR dBegDate AS DATE          NO-UNDO.
 DEF VAR dEndDate AS DATE          NO-UNDO.

 DEF VAR currTable AS TTable2      NO-UNDO.
 DEF VAR oTable1   AS TTable2      NO-UNDO.
 DEF VAR oTable2   AS TTable2      NO-UNDO.
 DEF VAR oTable3   AS TTable2      NO-UNDO.
 DEF VAR oTable4   AS TTable2      NO-UNDO.

 DEF VAR i         AS INT          NO-UNDO.
 DEF VAR subValue  AS DEC          NO-UNDO.

 DEF VAR k20       AS DEC INIT 0.2 NO-UNDO.

 DEF VAR currItog  AS TAArray      NO-UNDO.
 DEF VAR oItog1    AS TAArray      NO-UNDO.
 DEF VAR oItog2    AS TAArray      NO-UNDO.
 DEF VAR oItog3    AS TAArray      NO-UNDO.
 DEF VAR oItog4    AS TAArray      NO-UNDO.


 oRes    = NEW TAArray().
 oResNP  = NEW TAArray().
 oResNDS = NEW TAArray().

 oItog1  = NEW TAArray("0").
 oItog2  = NEW TAArray("0").
 oItog3  = NEW TAArray("0").
 oItog4  = NEW TAArray("0").

 oTable1 = NEW TTable2().

    oTable1:addRow()
           :addCell("1")
           :addCell("2")
           :addCell("3")
           :addCell("4")
           :addCell("5=4*20%")
           :addCell("6=4*18%")
    .

 oTable2 = NEW TTable2().

    oTable2:addRow()
           :addCell("1")
           :addCell("2")
           :addCell("3")
           :addCell("4")
           :addCell("5=4*20%")
           :addCell("6=4*18%")
    .

 oTable3 = NEW TTable2().

    oTable3:addRow()
           :addCell("1")
           :addCell("2")
           :addCell("3")
           :addCell("4")
           :addCell("5=4*20%")
           :addCell("6=4*18%")
    .

 oTable4 = NEW TTable2().
 
    oTable4:addRow()
           :addCell("1")
           :addCell("2")
           :addCell("3")
           :addCell("4")
           :addCell("5=4*20%")
           :addCell("6=4*18%")
    .



 {tpl.create}
 FIND FIRST currDataBlock WHERE currDataBlock.Data-Id EQ in-data-id NO-LOCK.
  ASSIGN
     dBegDate = currDataBlock.Beg-Date
     dEndDate = currDataBlock.End-Date
 .


 FOR EACH code WHERE code.class  EQ 'PirF227Svod' 
                 AND code.parent EQ 'PirF227Svod' NO-LOCK:

    maskFind = code.val.

    FOR EACH PDataBlock WHERE PDataBlock.DataClass-id EQ 'f227_2' 
                          AND PDataBlock.Beg-Date     EQ dBegDate
                          AND PDataBlock.End-Date     EQ dEndDate NO-LOCK,
       EACH PDataLine WHERE  PDataLine.data-id       EQ PDataBlock.data-id
                         AND CAN-DO(maskFind,PDataLine.Sym1) NO-LOCK BREAK BY PDataLine.Sym1:

         dSum  = dSum  + PDataLine.Val[5].
         dSum1 = dSum1 + PDataLine.Val[7].

    END.

  oRes:setH(code.code,dSum).
  oResNP:setH(code.code,dSum * k20).
  oResNDS:setH(code.code,dSum1).
  dSum = 0.
 END.


 FOR EACH code WHERE code.class EQ 'PirF227Svod' 
                 AND code.parent EQ 'PirF227Svod' NO-LOCK BREAK BY code.name:

      maskFind = code.val.

       IF FIRST-OF(code.name) THEN DO:

           CASE code.name:
               WHEN "Доходы от реализации" THEN DO:
	          currTable = oTable1.
                  currItog  = oItog1.
               END.
               WHEN "внереализационные доходы" THEN DO:
	          currTable = oTable2.
                  currItog  = oItog2.
               END.
               WHEN "расходы от реализации" THEN DO:
                  currTable = oTable3.
                  currItog  = oItog3.
               END.
               WHEN "внереализационные расходы" THEN DO:
	          currTable = oTable4.
                  currItog  = oItog4.
               END.
           END CASE.
       END.

             currTable:addRow()
                      :addCell(code.code)
                      :addCell("X")
                      :addCell("X")
                      :addCell(STRING(DEC(oRes:get(code.code)),">>>,>>>,>>>,>>>,>>9.99"))
                      :addCell(STRING(DEC(oResNP:get(code.code)),">>>,>>>,>>>,>>>,>>9.99"))
                      :addCell(STRING(DEC(oResNDS:get(code.code)),">>>,>>>,>>>,>>>,>>9.99"))
             .

   FOR EACH PDataBlock WHERE PDataBlock.DataClass-id EQ 'f227_2' 
                          AND PDataBlock.Beg-Date     EQ dBegDate
                          AND PDataBlock.End-Date     EQ dEndDate NO-LOCK,
       EACH PDataLine WHERE  PDataLine.data-id       EQ PDataBlock.data-id
                         AND CAN-DO(maskFind,PDataLine.Sym1) NO-LOCK BREAK BY PDataLine.Sym1:

             subValue = PDataLine.Val[5].

             IF subValue <> 0 THEN DO:
                 currTable:addRow()
                          :addCell(ENTRY(1,PDataLine.Sym1,"|"))
                          :addCell(PDataLine.Sym1)
                          :addCell(getOperName(PDataLine.Sym1))
                          :addCell(STRING(subValue,">>>,>>>,>>>,>>>,>>9.99"))
                          :addCell(STRING(subValue * k20,">>>,>>>,>>>,>>>,>>9.99"))
                          :addCell(STRING(PDataLine.val[7],">>>,>>>,>>>,>>>,>>9.99"))
                 .
                  currItog:incrementTo("subValue",subValue).
                  currItog:incrementTo("subValue_k20",subValue * k20).
                  currItog:incrementTo("val7",PDataLine.val[7]).
             END.

    END.

 END.

 oTable1:addRow()
        :addCell("Итого:")
        :addCell("")
        :addCell("")
        :addCell(oItog1:get("subValue"))
        :addCell(oItog1:get("subValue_k20"))
        :addCell(oItog1:get("val7"))
  .

 oTable2:addRow()
        :addCell("Итого:")
        :addCell("")
        :addCell("")
        :addCell(STRING(DEC(oItog2:get("subValue")),">>>,>>>,>>>,>>>,>>9.99"))
        :addCell(STRING(DEC(oItog2:get("subValue_k20")),">>>,>>>,>>>,>>>,>>9.99"))
        :addCell(STRING(DEC(oItog2:get("val7")),">>>,>>>,>>>,>>>,>>9.99"))
  .

 oTable3:addRow()
        :addCell("Итого:")
        :addCell("")
        :addCell("")
        :addCell(STRING(DEC(oItog3:get("subValue")),">>>,>>>,>>>,>>>,>>9.99"))
        :addCell(STRING(DEC(oItog3:get("subValue_k20")),">>>,>>>,>>>,>>>,>>9.99"))
        :addCell(STRING(DEC(oItog3:get("val7")),">>>,>>>,>>>,>>>,>>9.99"))
  .

 oTable4:addRow()
        :addCell("Итого:")
        :addCell("")
        :addCell("")
        :addCell(STRING(DEC(oItog4:get("subValue")),">>>,>>>,>>>,>>>,>>9.99"))
        :addCell(STRING(DEC(oItog4:get("subValue_k20")),">>>,>>>,>>>,>>>,>>9.99"))
        :addCell(STRING(DEC(oItog4:get("val7")),">>>,>>>,>>>,>>>,>>9.99"))
  .

oTpl:addAnchorValue("YEAR",{term2str dBegDate dEndDate}).

IF oTable1:rowCount > 0 THEN DO:
 oTpl:addAnchorValue("TABLE1",oTable1). 
 oTpl:addAnchorValue("itog1",DEC(oItog1:get("subValue")) + DEC(oItog1:get("subValue_k20")) + DEC(oItog1:get("val7"))).
END.
ELSE DO:
 oTpl:addAnchorValue("TABLE1","*** НЕТ ДАННЫХ ***").
 oTpl:addAnchorValue("itog1","").
END.

IF oTable2:rowCount > 0 THEN DO:
 oTpl:addAnchorValue("TABLE2",oTable2). 
 oTpl:addAnchorValue("itog2",DEC(oItog2:get("subValue")) + DEC(oItog2:get("subValue_k20")) + DEC(oItog2:get("val7"))).
END.
ELSE DO:
 oTpl:addAnchorValue("TABLE2","*** НЕТ ДАННЫХ ***").
 oTpl:addAnchorValue("itog2","").
END.

IF oTable3:rowCount > 0 THEN DO:
 oTpl:addAnchorValue("TABLE3",oTable3). 
 oTpl:addAnchorValue("itog3",DEC(oItog3:get("subValue")) + DEC(oItog3:get("subValue_k20")) + DEC(oItog3:get("val7"))).
END.
ELSE DO:
 oTpl:addAnchorValue("TABLE3","*** НЕТ ДАННЫХ ***").
 oTpl:addAnchorValue("itog3","").
END.

IF oTable4:rowCount > 0 THEN DO:
 oTpl:addAnchorValue("TABLE4",oTable4).
 oTpl:addAnchorValue("itog4",DEC(oItog4:get("subValue")) + DEC(oItog4:get("subValue_k20")) + DEC(oItog4:get("val7"))).
END.
ELSE DO:
 oTpl:addAnchorValue("TABLE4","*** НЕТ ДАННЫХ ***").
 oTpl:addAnchorValue("itog4","").
END.


{tpl.show}

DELETE OBJECT oItog1.
DELETE OBJECT oItog2.
DELETE OBJECT oItog3.
DELETE OBJECT oItog4.

DELETE OBJECT oTable1.
DELETE OBJECT oTable2.
DELETE OBJECT oTable3.
DELETE OBJECT oTable4.

DELETE OBJECT oRes.
DELETE OBJECT oResNP.
DELETE OBJECT oResNDS.
{tpl.delete}