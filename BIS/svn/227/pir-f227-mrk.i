 /******************************************
  * Процедура устанавливает рынок
  * на договорах по которым уже расчитан
  * рынок.
  ******************************************
  * Автор : Маслов Д. А.
  * Заявка: #2907
  * Дата  :
  *******************************************/

 DEF VAR setMarketPrice AS LOG INIT NO    NO-UNDO.

 DEF VAR mBegDate LIKE DataBlock.Beg-Date NO-UNDO.
 DEF VAR mEndDate LIKE DataBlock.End-Date NO-UNDO.

 DEF VAR oTable AS TTable2 NO-UNDO.
 DEF VAR oParam AS TAArray NO-UNDO.
 DEF VAR oLoan  AS TLoan   NO-UNDO.


 DEF BUFFER pDataBlock  FOR DataBlock.
 DEF BUFFER pDataLine   FOR DataLine.
 DEF BUFFER bufDataLine FOR DataLine.

 DEF VAR mExc AS TAArray NO-UNDO.

 ASSIGN
   mBegDate = DataBlock.Beg-Date
   mEndDate = DataBlock.End-Date
 .


 MESSAGE "Установить рынок по вкладам взаимозависимых?" VIEW-AS ALERT-BOX BUTTONS YES-NO SET setMarketPrice.

/**
 * 1. Идем по всем операциям с кодом 06*,!07-1*,07* взаимозависимых лиц;
 * 2. По операции находим договор;
 * 3. На договоре выставляем ДР "PirMarketPrice".
 **/

 mExc = NEW TAArray().

 oTable = NEW TTable2().

 IF setMarketPrice THEN DO:

    FOR EACH PDataBlock WHERE PDataBlock.DataClass-id EQ 'f227_1' 
                          AND PDataBlock.Beg-Date     EQ mBegDate
                          AND PDataBlock.End-Date     EQ mEndDate NO-LOCK,
        EACH PDataLine WHERE  PDataLine.data-id       EQ PDataBlock.data-id 
                          AND LOGICAL(PDataLine.Sym3) 
                          AND CAN-DO("06*,!07-1*,07*",pDataLine.Sym2) NO-LOCK:


         FIND FIRST bufDataLine OF DataBlock WHERE bufDataLine.Sym1 = PDataLine.Sym2 NO-LOCK NO-ERROR.

         IF NOT AVAILABLE(bufDataLine) THEN DO:
            NEXT.
         END.

         oParam = NEW TAArray().
         oParam:loadSplittedList(PDataLine.txt,"~001",FALSE).

         IF oParam:get("contract") = ? THEN DO:
            oLoan = NEW TLoan(oParam:get("cont-code")).
         END. ELSE DO:
            oLoan = NEW TLoan(oParam:get("contract"),oParam:get("cont-code")).
         END.



         IF oLoan:getXAttrWDef("PirMarketPrice",?) = ? AND mExc:get(oLoan:contract + "," + oLoan:cont-code) = ? THEN DO:

          mExc:setH(oLoan:contract + "," + oLoan:cont-code,"YES").
         
         UpdateSigns("loan",oLoan:contract + "," + oLoan:cont-code,"PirMarketPrice",STRING(bufDataLine.val[2]),YES).

          oTable:addRow()
                :addCell(PDataLine.Sym4)
                :addCell(PDataLine.Sym2)
                :addCell(oParam:get("cont-code"))
                :addCell(bufDataLine.val[2])
          .


         END.

        DELETE OBJECT oLoan.
        DELETE OBJECT oParam.

    END.

 END.


DELETE OBJECT oTable.
DELETE OBJECT mExc.
