/*расшифровка к отчету Индикаторы Банка по 69-т пункты 13 и 14*/

  {globals.i}
  {intrface.get date}
  {lshpr.pro}
  DEF INPUT PARAM in-data-id LIKE DataBlock.Data-Id NO-UNDO.   

  def var oTable as TTable.
  def var oTable2 as TTable.


  def buffer prevDataBlock for DataBlock.
  DEF BUFFER currDataBLock for DataBlock.
  DEF BUFFER forDataBLock for DataBlock.
  DEF BUFFER DataBlock118 for DataBlock.
  DEF BUFFER DataLine118 for DataLine.
  DEF BUFFER currDataLine for DataLine.
  DEF BUFFER prevDataLine for DataLine.
  DEF BUFFER prevDataLine2 for DataLine.
  DEF BUFFER bloan for loan.
  DEF VAR oClient as TClient.
  DEF VAR currDate as DATE NO-UNDO.
  DEF VAR prevDate as DATE NO-UNDO.

  def var currkredit as decimal no-undo.	
  def var prevkredit as decimal no-undo.	
  def var totalkredit as decimal no-undo.
  def var totalprevkredit as decimal no-undo.
  def var capital as decimal no-undo.
  def var prevcapital as decimal no-undo.
  DEF VAR Temp as decimal NO-UNDO.
  def var oAcct AS TAcct.
  def var iFile as Char NO-UNDO.
  def var UNKg AS CHAR NO-UNDO.
  def var GVK AS CHAR NO-UNDO.
  def var i as int init 0 NO-UNDO.
  def var totalprevdeposit AS DEC NO-UNDO.
  def var tempkredit AS DEC NO-UNDO.
  def var tempdeposit AS DEC NO-UNDO.
  def temp-table tf157 
            field sym1 like dataline.sym1
            field val3 like dataline.val[3]
            Index sym1 sym1.

  def temp-table tf118 
            field sym3 like dataline.sym3	
            field val3 like dataline.val[3]
            Index sym3 sym3.

  def temp-table tf117 
            field sym1 like dataline.sym1
            field val3 like dataline.val[3]
            Index sym1 sym1.

  def temp-table kredit-in
            field cont-code as char
            field doc-num as char
            INDEX cont-code cont-code.

  FIND FIRST currDataBlock WHERE currDataBlock.Data-Id EQ in-data-id NO-LOCK NO-ERROR.

  currDate = currDataBlock.End-Date.
 
   oTable = new TTable(3).
/*   oTable:AddRow().
   oTable:AddCell("Номер договора").
   oTable:AddCell("Наименование клиента").
   oTable:AddCell("Остаток по ссуде / капитал > 5%").
   oTable:AddCell("Ссудная задолженность").        */

    FUNCTION GetCapital RETURN DECIMAL (INPUT dDate AS DATE).

    FIND LAST forDataBlock WHERE forDataBlock.DataClass-Id EQ "capital"
                             and forDataBlock.end-date <= dDate
                             NO-LOCK NO-ERROR.
            if available forDataBlock then
            DO:

               find first prevDataLine where prevdataline.Sym1 = "Капитал" 
                                         and prevdataline.data-id = fordatablock.data-id
                                         NO-LOCK NO-ERROR.

               if available prevDataLine THEN capital = prevDataLine.Val[1].
                
           end.
        if capital = ? or capital = 0 then capital = GetCapital(dDate - 1).
        RETURN capital.
    END.

   capital = GetCapital(currdate + 1).

  prevDate = (FirstMonDate(currDate)) - 1.



  find last DataBlock WHERE DataBlock.DataClass-ID EQ 'f118n'
                        and DataBlock.end-date = currdate 
			and DataBlock.beg-date = currdate
                        NO-LOCK NO-ERROR.
  if not available DataBlock then message "Не найден класс f118n за " currdate VIEW-AS ALERT-BOX.
  find last PrevDataBlock WHERE PrevDataBlock.DataClass-ID EQ 'f118n'
                            and PrevDataBlock.end-date = prevdate 
			    and PrevDataBlock.beg-date <> prevdate NO-LOCK NO-ERROR.
  if not available PrevDataBlock then message "Не найден класс f118n за " prevdate VIEW-AS ALERT-BOX.


  def var prevTotalF118 AS DECIMAL INIT 0 NO-UNDO.
  def var NewInF118 AS DECIMAL INIT 0 NO-UNDO.

  FOR EACH dataline WHERE dataline.data-id = prevdatablock.data-id AND NOT CAN-DO("ГВК*",dataline.sym3) NO-LOCK:
      prevTotalF118 = prevTotalF118 + DataLine.val[1].
  END.
        oTable:AddRow().
        oTable:AddCell("ГВК/УНКг").

        oTable:AddCell("Анализ формы 118. Сумма за " + STRING(prevdate)).
        oTable:AddCell(STRING(prevTotalF118,"->>,>>>,>>>,>>>,>>9.99")).

  for each dataline where dataline.data-id = datablock.data-id and NOT CAN-DO("ГВК*",dataline.sym3) NO-LOCK:

      find first prevdataline where PrevDataline.Data-ID EQ PrevDataBlock.Data-ID
                                and PrevDataline.sym3 = dataline.sym3 NO-LOCK NO-ERROR.

      if NOT available prevdataline then 
      DO:
        oTable:AddRow().
        oTable:AddCell(Dataline.sym2).
        oTable:AddCell(ENTRY(1,Dataline.txt,"~n")).
        oTable:AddCell(STRING(Dataline.val[1],"->>,>>>,>>>,>>>,>>9.99")).
        NewInF118 = NewInF118 + Dataline.val[1].
      END.


  END.
        oTable:AddRow().
        oTable:AddCell(" ").
        oTable:AddCell("Итого:").
        oTable:AddCell(STRING(NewInF118,"->>,>>>,>>>,>>>,>>9.99")).

        oTable:AddRow().
        oTable:AddCell("").
        oTable:AddCell(" ").

        oTable:AddCell(STRING(ROUND((NewInF118 / prevTotalF118) * 100,2),"->>,>>>,>>9.99") + "%").

        oTable:AddRow().
        oTable:AddCell(" ").

        oTable:AddCell(" ").
        oTable:AddCell(" ").


  find last DataBlock WHERE DataBlock.DataClass-ID EQ 'f117n'
                        and DataBlock.end-date = currdate 
			and DataBlock.beg-date = currdate
                        NO-LOCK NO-ERROR.
  if not available DataBlock then message "Не найден класс f117n за " currdate VIEW-AS ALERT-BOX.
  find last PrevDataBlock WHERE PrevDataBlock.DataClass-ID EQ 'f117n'
                            and PrevDataBlock.end-date = prevdate 
			    and PrevDataBlock.beg-date <> prevdate NO-LOCK NO-ERROR.

  if not available PrevDataBlock then message "Не найден класс f117n за " prevdate VIEW-AS ALERT-BOX.

  def var prevTotalF117 AS DECIMAL INIT 0 NO-UNDO.
  def var NewInF117 AS DECIMAL INIT 0 NO-UNDO.


  FOR EACH dataline WHERE dataline.data-id = prevdatablock.data-id AND NOT CAN-DO("ГВК*",dataline.sym3) NO-LOCK:
      prevTotalF117 = prevTotalF117 + DataLine.val[1].
  END.
        oTable:AddRow().
        oTable:AddCell("").
        oTable:AddCell("Анализ формы 117. Сумма за " + STRING(prevdate)).
        oTable:AddCell(STRING(prevTotalF117,"->>,>>>,>>>,>>>,>>9.99")).



  for each dataline where dataline.data-id = datablock.data-id 
                      and NOT CAN-DO("ГВК*",dataline.sym3) 
                      and ENTRY(1,dataline.txt,"~n") <> "" NO-LOCK:

      find first prevdataline where PrevDataline.Data-ID EQ PrevDataBlock.Data-ID
                                and PrevDataline.sym1 = dataline.sym1 NO-LOCK NO-ERROR.

      if NOT available prevdataline then 
      DO:

        oTable:AddRow().
        oTable:AddCell(" ").
        oTable:AddCell(ENTRY(1,ENTRY(1,Dataline.txt,"~n"),"")).
        oTable:AddCell(STRING(Dataline.val[1],"->>,>>>,>>>,>>>,>>9.99")).
        NewInF117 = NewInF117 + Dataline.val[1].
      END.
  END.

        oTable:AddRow().
        oTable:AddCell("").
        oTable:AddCell("Итого:").
        oTable:AddCell(STRING(NewInF117,"->>,>>>,>>>,>>>,>>9.99")).

        oTable:AddRow().
        oTable:AddCell("").
        oTable:AddCell("").
        oTable:AddCell(STRING(ROUND((NewInF117 / prevTotalF117) * 100,2),"->>,>>>,>>9.99") + "%").


/*
  for each loan where loan.contract = "Кредит" 
		  and loan.open-date > FirstMonDate(currdate) - 1 
                  and loan.open-date <= currdate 
                  NO-LOCK:   
		  find first kredit-in where kredit-in.cont-code begins ENTRY(1,loan.cont-code," ") NO-ERROR.
		  if not available kredit-in then do:
                  create kredit-in.
                  kredit-in.cont-code = loan.cont-code.
                  if loan.cont-code begins "MM" then kredit-in.doc-num = loan.doc-num. 
                                                else kredit-in.doc-num = ENTRY(1,loan.cont-code," ").
                  end.
  end.                                                /*собрали все кредиты по которым была выдача с начала месяца*/

  find last DataBlock WHERE DataBlock.DataClass-ID EQ 'f117n'
                        and DataBlock.end-date < currdate NO-LOCK NO-ERROR.

  find last DataBlock118 WHERE DataBlock118.DataClass-ID EQ 'f118n'
                        and DataBlock118.end-date < currdate NO-LOCK NO-ERROR.

  totalprevkredit = 0. 
  for each dataline where DataLine.Data-ID EQ DataBlock.Data-ID and NOT CAN-DO("*Т*",Dataline.sym3) NO-LOCK.
     totalprevkredit = totalprevkredit + DataLine.val[1]. 
  end.


  totalkredit = 0.
  for each kredit-in NO-LOCK:
     currkredit = 0.
          for each bloan where bloan.cont-code begins ENTRY(1,kredit-in.cont-code," ") and bloan.contract = "Кредит" NO-LOCK:
              RUN PARAM_0_NEW(bloan.contract,bloan.cont-code,0,currdate,OUTPUT temp).
	      currkredit = currkredit + temp.
	      temp = 0.
         end.
     find first loan where loan.contract = "Кредит" and loan.cont-code = kredit-in.cont-code NO-LOCK NO-ERROR.
     
     if loan.cust-cat = "Ч" then iFile = "person".
     if loan.cust-cat = "Ю" then iFile = "cust-corp".
     if loan.cust-cat = "Б" then iFile = "banks".


     UNKg = GetXAttrValueEx(iFile,STRING(loan.cust-id),"УНКг",?).



     find first dataline where DataLine.Data-ID EQ DataBlock.Data-ID and NOT CAN-DO("*Т*",Dataline.sym3) and can-do(ENTRY(1,kredit-in.cont-code," ") + "*",Dataline.sym3) NO-LOCK NO-ERROR.  
     find first dataline118 where DataLine118.Data-id EQ DataBlock118.Data-ID and can-do(UNKg,dataline118.sym3) NO-LOCK NO-ERROR.
     if not Available (dataline) and NOT AVAILABLE (dataline118) then                                                                      
     do:
        if currkredit <> 0 then do:
        oClient = new TClient(loan.cust-cat,loan.cust-id).
        oTable:AddRow().
        oTable:AddCell(kredit-in.doc-num).
        oTable:AddCell(oClient:name-short).
        if (currkredit / capital) > 0.05 then do: tempkredit = tempkredit + currkredit. oTable:AddCell(string(currkredit * 100 / capital,"->>>,>>>,>>9.99")). end.
                                             else oTable:AddCell("").
        oTable:AddCell(STRING(currkredit,"->>>,>>>,>>9.99")).
        DELETE OBJECT oClient.
        end.
     END.
  end.
        oTable:AddRow().
        oTable:AddCell("").
        oTable:AddCell("Итог:").
        oTable:AddCell(tempkredit).
        oTable:AddCell("").
  */


/*теперь сделаем подобную выборку по депозитам*/

  oTable2 =  new TTable(3).

  prevDate = (FirstMonDate(currDate)) - 1.
  find last DataBlock WHERE DataBlock.DataClass-ID EQ 'f157'
                        and DataBlock.end-date = currdate 
			and DataBlock.beg-date = currdate
                        NO-LOCK NO-ERROR.
  if not available DataBlock then message "Не найден класс f157 за " currdate VIEW-AS ALERT-BOX.
  find last PrevDataBlock WHERE PrevDataBlock.DataClass-ID EQ 'f157'
                            and PrevDataBlock.end-date = prevdate 
			    and PrevDataBlock.beg-date <> prevdate NO-LOCK NO-ERROR.
  if not available PrevDataBlock then message "Не найден класс f157 за " prevdate VIEW-AS ALERT-BOX.
  find first dataline where DataLine.Data-ID EQ prevDataBlock.Data-ID 
                        and Dataline.sym1 = "f157_ОСОКО" 
                            NO-LOCK NO-ERROR.

  totalprevdeposit = DataLine.val[3]. 

  DEF VAR totalcurrdeposit AS DECIMAL INIT 0 NO-UNDO.

  find first dataline where DataLine.Data-ID EQ DataBlock.Data-ID 
                        and Dataline.sym1 = "f157_ОСОКО" 
                            NO-LOCK NO-ERROR.

  totalcurrdeposit = DataLine.val[3]. 


  tempdeposit = 0.
  for each dataline where dataline.data-id = datablock.data-id and CAN-DO("00000*,000010*",dataline.sym1) NO-LOCK:

      find first prevdataline where PrevDataline.Data-ID EQ PrevDataBlock.Data-ID
                                and PrevDataline.sym3 = dataline.sym3 NO-LOCK NO-ERROR.

      if available PrevDataLine THEN 
         DO:
            if not can-do("ГВК*",prevdataline.sym3) and DEC(ENTRY(1,prevdataline.sym1,".")) > 10 and DEC(ENTRY(1,prevdataline.sym1,".")) <> DEC(ENTRY(1,dataline.sym1,".")) then /*если в предыдущем отчете  этот клиент был, но в ТОП10 не попадал*/
                DO:
                   find first prevdataline2 where PrevDataline2.Data-ID EQ PrevDataBlock.Data-ID
                                             and PrevDataline2.sym2 = dataline.sym2 
                                             and can-do("ГВК*",prevdataline2.sym3)
                                             NO-LOCK NO-ERROR.
                   if available prevdataline2 then do:
                   if DEC(ENTRY(1,prevdataline2.sym1,".")) > 10 then
                      DO:
                        tempdeposit = tempdeposit + dataline.val[3].
                        oTable2:AddRow().
                        oTable2:AddCell(dataline.sym2).
                         oTable2:AddCell(ENTRY(1,dataline.txt,"~n")).
                        oTable2:AddCell(dataline.val[3]).
                      END.
                  end.
                  else 
                  do:
                     tempdeposit = tempdeposit + dataline.val[3].
                     oTable2:AddRow().
                     oTable2:AddCell(dataline.sym2).
                     oTable2:AddCell(ENTRY(1,dataline.txt,"~n")).
                     oTable2:AddCell(dataline.val[3]).
                  end.




                END.
         END.
      if not available PrevDataLine then /*если клиента вообще небыло в старом отчете*/
         do:
                   /*проверяем была ли эта группа ранее в отчете*/

                   find first prevdataline where PrevDataline.Data-ID EQ PrevDataBlock.Data-ID
                                             and PrevDataline.sym2 = dataline.sym2 
                                             and can-do("ГВК*",prevdataline.sym3)
                                             NO-LOCK NO-ERROR.
                   if available prevdataline then do:
                   if DEC(ENTRY(1,prevdataline.sym1,".")) > 10 then
                      DO:
                         tempdeposit = tempdeposit + dataline.val[3].
                         oTable2:AddRow().
                         oTable2:AddCell(dataline.sym2).
                         oTable2:AddCell(ENTRY(1,dataline.txt,"~n")).
                         oTable2:AddCell(dataline.val[3]).
                      END.
                  end.
                  else 
                  do:
                         tempdeposit = tempdeposit + dataline.val[3].
                         oTable2:AddRow().
                         oTable2:AddCell(dataline.sym2).
                         oTable2:AddCell(ENTRY(1,dataline.txt,"~n")).
                         oTable2:AddCell(dataline.val[3]).

                  end.
         end.

  END.

                         oTable2:AddRow().
                         oTable2:AddCell("Итог:").
                         oTable2:AddCell("").
                         oTable2:AddCell(tempdeposit).
                         oTable2:AddRow().
                         oTable2:AddCell("").
                         oTable2:AddCell("").
                         oTable2:AddCell(STRING(ROUND( (tempdeposit * 100 / totalprevdeposit),2) ,"->>,>>>,>>>,>>9.99")).

                  



{setdest.i}

  PUT UNFORMATTED "Индикатор 13. "  currDate SKIP.
/*  PUT UNFORMATTED "Объем крупных ссуд:" STRING(totalprevkredit) SKIP.*/
  oTable:show().
/*  PUT UNFORMATTED STRING(ROUND(tempkredit / totalprevkredit,2),"->>>9.99") SKIP.*/
  PUT UNFORMATTED SKIP.
  PUT UNFORMATTED SKIP.
  PUT UNFORMATTED "Индикатор 14. "  currDate SKIP.
  PUT UNFORMATTED "Объем крупных вкладов на " STRING(prevdate) + ":  " + STRING(totalprevdeposit) SKIP.  
  PUT UNFORMATTED "Объем крупных вкладов на " STRING(currDate) + ":  " + STRING(totalcurrdeposit)  SKIP.  
  PUT UNFORMATTED "Изменений объема крупных вкладов:  " + STRING(((totalcurrdeposit - totalprevdeposit) * 100 / totalprevdeposit),"->>,>>>,>>9.99") + "%" SKIP.  
  oTable2:show().
  PUT UNFORMATTED STRING(ROUND(tempdeposit / totalprevdeposit,2),"->>>9.99") SKIP.
{preview.i}

