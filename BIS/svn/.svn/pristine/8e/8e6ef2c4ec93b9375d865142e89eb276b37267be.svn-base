/*Отчет Индикаторы банка*/




  {globals.i}
  {intrface.get date}
  {lshpr.pro}
  {wordwrap.def}

  DEF INPUT PARAM in-data-id LIKE DataBlock.Data-Id NO-UNDO.   
  DEF INPUT PARAM iParam as char NO-UNDO.         


  def var oTable as TTable NO-UNDO.
  def buffer prevDataBlock for DataBlock.
  DEF BUFFER currDataBLock for DataBlock.
  DEF BUFFER forDataBLock for DataBlock.
  DEF BUFFER currDataLine for DataLine.
  DEF BUFFER prevDataLine for DataLine.
  DEF BUFFER prevDataLine2 for DataLine.
  DEF BUFFER DataBlock118 for DataBlock.
  DEF BUFFER DataLine118 for DataLine.

  DEF BUFFER bloan for loan.
  DEF VAR count AS INT INIT 0 NO-UNDO.
  def var mailto as char no-undo.
  DEF VAR currDate as DATE NO-UNDO.
  DEF VAR prevDate as DATE NO-UNDO. 
  DEF VAR TimePeriod as char no-undo.
  DEF VAR tempResult as decimal NO-UNDO.
  DEF VAR TempOborot as decimal NO-UNDO.
  DEF VAR Temp as decimal NO-UNDO.
  DEF VAR TempOborot1 as decimal NO-UNDO.
  DEF VAR TotalOborot as decimal NO-UNDO.
  def var tempstring as char extent 20 no-undo.
  def var f_11 as decimal no-undo.
  def var f_11_prev as decimal no-undo.
  def var capital as decimal no-undo.
  def var prevcapital as decimal no-undo.
  def var indicatavalue as decimal EXTENT 6 NO-UNDO.
  def var maxvalue as decimal extent 6 NO-UNDO.
  def var f_18 as decimal no-undo.
  def var f_18_prev as decimal no-undo.
  def var i as integer no-undo.
  def var j as integer no-undo.
  def var tempdate as date no-undo.


  def var iFile as Char NO-UNDO.
  def var UNKg AS CHAR NO-UNDO.
  def var GVK AS CHAR NO-UNDO.

  def var totalprevdeposit AS DEC NO-UNDO.
  def var tempkredit AS DEC NO-UNDO.
  def var tempdeposit AS DEC NO-UNDO.
  def temp-table tf157 
            field sym1 like dataline.sym1
            field val3 like dataline.val[3]
            Index sym1 sym1.


def var currkredit as decimal no-undo.	
def var prevkredit as decimal no-undo.	
def var totalkredit as decimal no-undo.
def var	totalprevkredit as decimal no-undo.

  def var oAcct AS TAcct.

  def temp-table kredit-in
            field cont-code as char
            field doc-num as char
            INDEX cont-code cont-code.

  def var ClassCod As CHAR NO-UNDO.

  def temp-table balans 
           field st as char
           field val as decimal
           field prev as decimal.

  mailto = FGetSetting("f69t","f_69_mail","bis@pirbank.ru").

  oTable = new TTable(5).   
  oTable:colsWidthList="3,40,25,8,12".

  oTable:AddRow().
  oTable:AddCell("").
  oTable:AddCell("Содерждание ситуации (обстоятельства)").
  oTable:AddCell("Пороговые значения").
  oTable:AddCell("Значение").
  oTable:AddCell("Превышение значения над пороговым").
  oTable:setAlign(1,1,"center").
  oTable:setAlign(2,1,"center").
  oTable:setAlign(3,1,"center").
  oTable:setAlign(4,1,"center").
  oTable:setAlign(5,1,"center").

  FIND FIRST currDataBlock WHERE currDataBlock.Data-Id EQ in-data-id NO-LOCK NO-ERROR.

  currDate = currDataBlock.End-Date.
  FIND FIRST currDataBlock WHERE currDataBlock.DataClass-Id EQ 'f_69t' 
			     and currDataBlock.beg-date = currDate 
                             and currDataBlock.end-date = currDate NO-LOCK NO-ERROR.

  FUNCTION CalcOborot RETURN DECIMAL (INPUT FormulaName AS CHAR).

         TempOborot1 = 0.

         FOR EACH forDataBLock WHERE forDataBLock.DataClass-Id EQ currDataBlock.DataClass-Id 
                               and forDataBLock.end-date >= FirstMonDate(currdate)
                               and forDataBlock.end-date <= currdate
			       and forDataBlock.beg-date = forDataBlock.end-date
                               NO-LOCK,
            first currDataLine where currdataline.Sym1 = FormulaName
                                 and currdataline.data-id = fordatablock.data-id
                                 NO-LOCK:
            TempOborot1 = TempOborot1 + currDataLine.Val[1].
         END.
         RETURN TempOborot1.

  END FUNCTION.

  FUNCTION GetFuncVal RETURN DECIMAL (INPUT FormulaName AS CHAR, INPUT dDate AS DATE).
            

            FIND LAST forDataBlock WHERE forDataBlock.DataClass-Id EQ ClassCod
                             and forDataBlock.beg-date = dDate
                             and forDataBlock.end-date = dDate
                             NO-LOCK NO-ERROR.
            if available forDataBlock then
            DO:

               find first prevDataLine where prevdataline.Sym1 = FormulaName 
                                         and prevdataline.data-id = fordatablock.data-id
                                         NO-LOCK NO-ERROR.

               if available prevDataLine THEN RETURN prevDataLine.Val[1].
               else message "не найдено значение формулы " FormulaName VIEW-AS ALERT-BOX.
  
          END. else message "не найден класс данных " ClassCod dDate VIEW-AS ALERT-BOX.

  END FUNCTION.

    FUNCTION GetCapital RETURN DECIMAL (INPUT dDate AS DATE).

    FIND LAST forDataBlock WHERE forDataBlock.DataClass-Id EQ "capital"
                             and forDataBlock.end-date < dDate
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
    END FUNCTION.

  PROCEDURE CalcBalanse.
  DEF INPUT PARAMETER FormulaName as CHAR.
  DEF INPUT PARAMETER Comp as dec.
  DEF INPUT PARAMETER st as CHAR.
/*   message FormulaName GetFuncVal(FormulaName,prevdate) comp (GetFuncVal(FormulaName,prevdate) * 1000 / comp) VIEW-AS ALERT-BOX. */
   if  (GetFuncVal(FormulaName,prevdate) * 1000 / comp) >= 0.3 then 
    do:
          find last formula where formula.DataClass-Id = ClassCod and formula.var-id = FormulaName NO-LOCK NO-ERROR.
          Create balans.
          balans.st = st + formula.var-name.

          if (GetFuncVal(FormulaName,prevdate)) <> 0 then balans.val = (GetFuncVal(FormulaName,currdate) - GetFuncVal(FormulaName,prevdate)) / (GetFuncVal(FormulaName,prevdate)). else balans.val = 0.

          if balans.val > 1 then balans.prev = balans.val - 1. 
         else balans.prev = 0.
    end.

  END PROCEDURE.

/*определяем дату с которой будем сравнивать текущий класс*/
/*если последний день месяца - то нас интересует последний рабочий день предыдушего месяца, если не последний - то предыдущий рабочий день*/
 
  prevDate = PrevWorkDay(currDate).
/*  TimePeriod = "ежедневно".
    if currDate = PrevWorkDay(LastMonDate(currDate) + 1) then */
  DO: 
    prevDate = PrevWorkDay(FirstMonDate(currDate)).
    TimePeriod = "за месяц".
  END.
   ClassCod = "f_69t".
   f_11 = GetFuncVal("f_11",currdate).
   f_11_prev = GetFuncVal("f_11",prevdate).  

   f_18 = GetFuncVal("f_18",currdate).
   f_18_prev = GetFuncVal("f_18",prevdate).  
  



/*индикатор 1.*/
   FIND LAST prevDataBlock WHERE prevDataBlock.DataClass-Id EQ currDataBlock.DataClass-Id 
                             and prevDataBlock.end-date = prevDate
                                  NO-LOCK NO-ERROR.  /*ищем необходимые данные для расчета*/
   if not available prevDataBlock THEN
     DO:
        message "Не найден блок данный f_69t за " prevdate VIEW-AS ALERT-BOX.
     END.


     DO:

         tempresult = 0. 

         if GetFuncVal("f_15_2_3",prevdate) <> 0 then
         tempresult = (GetFuncVal("f_15_2_3",currdate) - GetFuncVal("f_15_2_3",prevdate)) / (GetFuncVal("f_15_2_3",prevdate)).
        
         oTable:AddRow().
         oTable:AddCell("1.").
         oTable:AddCell("Существенное увеличение остатков на счетах и во вкладах физических лиц в целом по кредитной организации").
         oTable:AddCell("более 20% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>>9.99") + "%").
         indicatavalue[1] = tempresult.
         maxvalue[1] = 0.2.
         if tempresult > 0.2 then oTable:AddCell(STRING(tempresult * 100 - 20,"->>>9.99") + "%").
		             else oTable:AddCell("").
     END.
/*конец индикатор 1.*/

/*индикатор 2.*/

         tempresult = 0.
         if CalcOborot("dop_f_1_2_1_5") <> 0 then 
         tempresult = (CalcOborot("dop_f_1_2_1_5")) / CalcOborot("dop_PSn").
/*         message CalcOborot("dop_f_1_2_1_5") CalcOborot("dop_PSn") VIEW-AS ALERT-BOX.*/
         oTable:AddRow().
         oTable:AddCell("2.").
         oTable:AddCell("Отношение дебетовых оборотов по корсчету в Банке России к кредитовым оборотам по вкладам физических лиц").
         oTable:AddCell("менее 100% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>>9.99") + "%").
         indicatavalue[2] = tempresult.
         maxvalue[2] = 1.
         if tempresult < 1 then oTable:AddCell(STRING(100 - tempresult * 100,"->>>9.99") + "%").
		             else oTable:AddCell("").



/*конец индикатор 2.*/

/*индикатор 3.*/

         tempresult = 0. 
         if f_11 <> 0 then
         tempresult = GetFuncVal("dop_bs202",currdate) / f_11.
         
         oTable:AddRow().
         oTable:AddCell("3.").
         oTable:AddCell("Остатки в кассе составляют существенный удельный вес в активах кредитной организаций").
         oTable:AddCell("более 25% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>>9.99") + "%").
         indicatavalue[3] = tempresult.
         maxvalue[3] = 0.25.
         if tempresult > 0.25 then oTable:AddCell(STRING(tempresult * 100 - 25,"->>>9.99") + "%").
		             else oTable:AddCell("").


/*конец индикатор 3.*/
/*индикатор 4.*/

         tempresult = 0. 
         tempstring[1] = "Существенное изменение структуры баланса (увеличение или сокращение удельного веса за отчетный месяц хотя бы одной статьи балансового отчета, определенной в соответствии с ""Разработочной таблицей для составления бухгалтерского баланса (публикуемая форма)"" Порядка составления и представления отчетности по форме 0409806 ""Бухгалтерский баланс (публикуемая форма)"", установленной приложением 1 к Указанию Банка России N 2332-У, удельный вес которой на начало отчетного месяца составлял 30% и более за исключением статей ""Средства акционеров (участников)"" и ""Эмессионный доход"", ""Средства кредитных организаций в Центральном банке Российской Федерации""".
       {wordwrap.i &s=tempstring &n=20 &l=80}
          ClassCod = "f806".

         RUN CalcBalanse("f806_01",f_11_prev,"1.").
         RUN CalcBalanse("f806_03",f_11_prev,"3.").
         RUN CalcBalanse("f806_04",f_11_prev,"4.").
         RUN CalcBalanse("f806_05",f_11_prev,"5.").
         RUN CalcBalanse("f806_06",f_11_prev,"6.").
         RUN CalcBalanse("f806_07",f_11_prev,"7.").
         RUN CalcBalanse("f806_08",f_11_prev,"8.").
         RUN CalcBalanse("f806_10",f_11_prev,"9.").

         RUN CalcBalanse("f806_12",f_18_prev,"11.").
         RUN CalcBalanse("f806_13",f_18_prev,"12.").
         RUN CalcBalanse("f806_14",f_18_prev,"13.").
         RUN CalcBalanse("f806_1401",f_18_prev,"13.1.").
         RUN CalcBalanse("f806_15",f_18_prev,"14.").
         RUN CalcBalanse("f806_17",f_18_prev,"15.").
         RUN CalcBalanse("f806_18",f_18_prev,"16.").
         RUN CalcBalanse("f806_2203",f_18_prev,"17.").
         RUN CalcBalanse("f806_23",f_18_prev,"22.").
         RUN CalcBalanse("f806_25",f_18_prev,"23.").
         RUN CalcBalanse("f806_26",f_18_prev,"24.").
         RUN CalcBalanse("f806_27",f_18_prev,"25.").
         RUN CalcBalanse("f806_29",f_18_prev,"26.").

         i = 1.

         maxvalue[4] = 1.
         oTable:AddRow().
         oTable:AddCell("4.").
         oTable:AddCell(tempstring[i]).
         oTable:AddCell("").
         oTable:AddCell("").
         oTable:AddCell("").

         for each balans no-lock:
         i = i + 1.
         oTable:AddRow().
         oTable:AddCell("").

         if i <= 20 then oTable:AddCell(tempstring[i]). else oTable:AddCell("").
         oTable:setBorder(1,oTable:height,1,0,0,1). oTable:setBorder(2,oTable:height,1,0,0,1).
         oTable:AddCell(balans.st).
         oTable:AddCell(STRING(balans.val * 100,"->>>9.99") + "%").
/*         if balans.val > 1 then oTable:AddCell(STRING(balans.val * 100 - 100,"->>9.99") + "%").
		             else oTable:AddCell("").*/
         oTable:AddCell(STRING(balans.prev,"->>>9.99") + "%").
         end.
         if i < 20 then 
         do:
            do j = i + 1 to 20:
             oTable:AddRow().
             oTable:AddCell("").
             oTable:AddCell(tempstring[j]).
             oTable:setBorder(1,oTable:height,1,0,0,1). oTable:setBorder(2,oTable:height,1,0,0,1). 
             oTable:AddCell("").
             oTable:AddCell("").
             oTable:AddCell("").
            end.
         end.
/*конец индикатор 4.*/

         ClassCod = "f_69t".

/*индикатор 5.*/
         TempOborot = CalcOborot("dop_f_2_1_5").
         tempresult = 0. 

         if f_11 <> 0 then
         tempresult = TempOborot / f_11.

         TempOborot = CalcOborot("dop2_f_2_1_5"). 
         if f_11 <> 0 then         
         if tempresult < (TempOborot / f_11) then tempresult = TempOborot / f_11.

         oTable:AddRow().
         oTable:AddCell("5.").
         oTable:AddCell("Существенный объем операций по продаже (приобретению) учтенных векселей (отношение дебетовых(кредитовых) оборотов за месяц по счетам по учету векселей к активам)").
         oTable:AddCell("более 30% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>>9.99") + "%").
         indicatavalue[5] = tempresult.
         maxvalue[5] = 0.3.
         if tempresult > 0.30 then oTable:AddCell(STRING(tempresult * 100 - 30,"->>9.99") + "%").
		             else oTable:AddCell("").


/*конец индикатор 5.*/
/*индикатор 6.*/
    tempresult = 0.
    if GetFuncVal("dop_bs523",currdate) / f_18 >= 0.1 then 
    if GetFuncVal("dop_bs523",prevdate) <> 0 then
    tempresult = (GetFuncVal("dop_bs523",currdate) - GetFuncVal("dop_bs523",prevdate)) / GetFuncVal("dop_bs523",prevdate).

         oTable:AddRow().
         oTable:AddCell("6.").
         oTable:AddCell("Существенный рост остатков на счетах по учету выпущенных кредитной организацией векселей и банковских акцептов при удельном весе остатков на счета по учету выпущенных кредитной организацией векселей и акцептов в пассивах 10% и более").
         oTable:AddCell("более 100% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>>9.99") + "%").
         indicatavalue[6] = tempresult.
         maxvalue[6] = 1.
         if tempresult > 1 then oTable:AddCell(STRING(tempresult * 100 - 100,"->>>9.99") + "%").
		             else oTable:AddCell("").

/*конец индикатор 6.*/

/*индикатор 7.*/
       tempstring[1] = "Количественное значение хотя бы одной ситуации (одного обстоятельства), содержание которого определено пунктами 1-6 приложения 1 к настоящему письму, состовляет не менее 70% от порогового значения, установленного соответствующими пунктами указанного выше приложения".
       {wordwrap.i &s=tempstring &n=10 &l=79}
       do i = 1 to 6:
         oTable:AddRow().
         if i = 1 then oTable:AddCell("7."). else oTable:AddCell("").
         oTable:AddCell(tempstring[i]).
  	 if i <> 1 then do: oTable:setBorder(1,oTable:height,1,0,0,1). oTable:setBorder(2,oTable:height,1,0,0,1). end.
/*         oTable:AddCell("более " + TRIM(STRING(maxvalue[i] * 100,"->>>9.99")) + "% " + TimePeriod).*/
         oTable:AddCell(STRING(i) + ". " + STRING(maxvalue[i] * 100 * 0.7,"->>>9.99") + "%").

if i <> 2 then do:
         oTable:AddCell(STRING(indicatavalue[i] * 100,"->>>9.99") + "%").
         if indicatavalue[i] > 0.7 then oTable:AddCell(STRING((indicatavalue[i] - 0.7) * 100,"->>>9.99") + "%").
		             else oTable:AddCell("").
   end.
else
    do:
         oTable:AddCell(STRING(indicatavalue[i] * 100,"->>>9.99") + "%").
         if indicatavalue[i] < 1 and (1 - indicatavalue[i]) >= 0.7  then oTable:AddCell(STRING(((1 - indicatavalue[i]) - 0.7) * 100,"->>>9.99") + "%").
		             else oTable:AddCell("").
    end.
       end.

/*конец индикатор 7.*/


/*индикатор 8.*/

   tempresult = 0.
   tempoborot = 0.
   totaloborot = 0.
   for each formula where formula.DataClass-Id = "f_69t_ob" NO-LOCK:
    tempoborot = 0.
    for each prevDataBlock where prevDataBlock.DataClass-Id EQ "f_69t_ob" 
                             and prevDataBlock.end-date >= FirstMonDate(currdate)
                             and prevDataBlock.end-date <= currdate
                             and prevDataBlock.beg-date = prevDataBlock.end-date
                             NO-LOCK,
     each prevdataline where prevdataline.data-id = prevDataBlock.data-id 
                             and prevdataline.Sym1 = formula.Var-Id   	
                             NO-LOCK:
        tempoborot = tempoborot + prevDataLine.Val[1].
   END.
      if TempOborot > f_11 then 
      do:
/*         oTable:AddRow().
         oTable:AddCell("8.").
         oTable:AddCell(formula.Var-Name).
         oTable:AddCell(tempoborot).
         oTable:AddCell("").                   */
      totaloborot = totaloborot + tempoborot.
      end.
   end.

   if totaloborot <> 0 then tempresult = (CalcOborot("dop_bs20202") + CalcOborot("dop_bs20209")) / TotalOborot.

         oTable:AddRow().
         oTable:AddCell("8.").
         oTable:AddCell("Соотношение суммарных оборотов за месяц по кассе (счет 20202) и по счетам по учету денежных средств в пути (счет 20209) к сумме оборотов по счетам, которые превышают величину активов-нетто").
         oTable:AddCell("более 10% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>>9.99") + "%").
         if tempresult > 0.1 then oTable:AddCell(STRING(tempresult * 100 - 10,"->>>9.99") + "%").
		             else oTable:AddCell("").


/*конец индикатор 8.*/
/*индикатор 9.*/
         tempresult = 0.
         tempoborot = 0.
         tempoborot = (CalcOborot("dop_f_1_2_1_5kt") + CalcOborot("dop_1_2_2_1_kt") + CalcOborot("dop_1_2_2_2_kt")).

         if tempoborot <> 0 then 
         tempresult = (CalcOborot("dop_KVu_dt") + CalcOborot("dop_KVf_dt ") + CalcOborot("dop_f_2_1_5")) / tempoborot.
         oTable:AddRow().
         oTable:AddCell("9.").
         oTable:AddCell("Соотношение общего объема дебетовых оборотов по счетам выданных кредитов (учтенных векселей) за месяц к общему объему денежных средств, списанных с корреспондентских счетов кредитной организации (кредитовые обороты за месяц по счетам НОСТРО)").
         oTable:AddCell("более 25% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>9.99") + "%").
         if tempresult > 0.25 then oTable:AddCell(STRING(tempresult * 100 - 25,"->>>9.99") + "%").
		             else oTable:AddCell("").

/*конец индикатор 9.*/
/*индикатор 10.*/
         tempresult = 0.
         tempoborot = 0.
         tempoborot = (CalcOborot("dop_f_1_2_1_5") + CalcOborot("dop_1_2_2_1_dt") + CalcOborot("dop_1_2_2_2_dt")).

         if tempoborot <> 0 then 
         tempresult = (CalcOborot("dop_KVu_kt") + CalcOborot("dop_KVf_kt ") + CalcOborot("dop_f_2_1_5kt")) / tempoborot.
         oTable:AddRow().
         oTable:AddCell("10.").
         oTable:AddCell("Соотношение общего объема кредитовых оборотов по счетам выданных кредитов (учтенных векселей) за месяц к общему объему денежных средств, списанных с корреспондентских счетов кредитной организации (дебетовые обороты за месяц по счетам НОСТРО)").
         oTable:AddCell("более 25% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>>9.99") + "%").
         if tempresult > 0.25 then oTable:AddCell(STRING(tempresult * 100 - 25,"->>>9.99") + "%").
		             else oTable:AddCell("").                          
/*конец индикатор 10.*/


/*индикатор 11.*/

         tempresult = 0.
         if f_18 <> 0 then 
         tempresult = CalcOborot("dop_bs523kt") / f_18.
         oTable:AddRow().
         oTable:AddCell("11.").
         oTable:AddCell("Обороты за месяц по выпуску векселей и банковских акцептов в процентах от общего объема пассивов").
         oTable:AddCell("более 10% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>>9.99") + "%").
         if tempresult > 0.1 then oTable:AddCell(STRING(tempresult * 100 - 10,"->>>9.99") + "%").
		             else oTable:AddCell("").


/*конец индикатор 11.*/
/*индикатор 12.*/

         tempresult = 0.
         if GetFuncVal("f_2",prevdate) <> 0 then 
         tempresult = (GetFuncVal("f_2",currdate) - GetFuncVal("f_2",prevdate)) / (GetFuncVal("f_2",prevdate)).
         oTable:AddRow().
         oTable:AddCell("12.").
         oTable:AddCell("Существенный рост объема ссудной задолженности по кредитной организации в целом").
         oTable:AddCell("более 10% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>>9.99") + "%").
         if tempresult > 0.1 then oTable:AddCell(STRING(tempresult * 100 - 10,"->>>9.99") + "%").
		             else oTable:AddCell("").


/*конец индикатор 12.*/
/*индикатор 13.*/
 
/*получим значение капитала на дату*/
       tempdate = PrevWorkDay(LastMonDate(currDate)).
       prevcapital = GetCapital(tempdate + 1).
       capital = GetCapital(currdate + 1).

  prevdate = FirstMonDate(currdate) - 1.

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

  for each dataline where dataline.data-id = datablock.data-id and NOT CAN-DO("ГВК*",dataline.sym3) NO-LOCK:

      find first prevdataline where PrevDataline.Data-ID EQ PrevDataBlock.Data-ID
                                and PrevDataline.sym3 = dataline.sym3 NO-LOCK NO-ERROR.

      if NOT available prevdataline then 
      DO:
        NewInF118 = NewInF118 + Dataline.val[1].
      END.


  END.

  	

         tempresult = NewInF118 / prevTotalF118.

         oTable:AddRow().
         oTable:AddCell("13.").
         oTable:AddCell("Существенное изменение по данным ").
         oTable:AddCell("ф.118: более 30% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>9.99") + "%").
         if tempresult > 0.3 then oTable:AddCell(STRING(tempresult * 100 - 30,"->>9.99") + "%").
	                     else oTable:AddCell("").

         oTable:AddRow().
         oTable:AddCell(" ").
         oTable:AddCell("отчетности по форме 0409117 ""Данные о крупных ссудах"" ").
         oTable:setBorder(1,oTable:height,1,0,0,1). oTable:setBorder(2,oTable:height,1,0,0,1).
         oTable:AddCell("ф.118: более 50% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>9.99") + "%").
         if tempresult > 0.5 then oTable:AddCell(STRING(tempresult * 100 - 50,"->>9.99") + "%").
	                     else oTable:AddCell("").



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

  for each dataline where dataline.data-id = datablock.data-id 
                      and NOT CAN-DO("ГВК*",dataline.sym3) 
                      and ENTRY(1,dataline.txt,"~n") <> "" NO-LOCK:

      find first prevdataline where PrevDataline.Data-ID EQ PrevDataBlock.Data-ID
                                and PrevDataline.sym1 = dataline.sym1 NO-LOCK NO-ERROR.

      if NOT available prevdataline then 
      DO:
        NewInF117 = NewInF117 + Dataline.val[1].
      END.
  END.

         tempresult = NewInF117 / prevTotalF117.


         oTable:AddRow().
         oTable:AddCell("").
         oTable:AddCell("и по форме 0409118 ""Данные о ").
         oTable:setBorder(1,oTable:height,1,0,0,1). oTable:setBorder(2,oTable:height,1,0,0,1).
         oTable:AddCell("ф.117: более 30% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>9.99") + "%").
         if tempresult > 0.3 then oTable:AddCell(STRING(tempresult * 100 - 30,"->>9.99") + "%").
		             else oTable:AddCell("").

         oTable:AddRow().
         oTable:AddCell("").
         oTable:AddCell("концентрации кредитного риска"" состава крупных заемщиков, а также такое изменение состава заемщиков, при котором произошло существенное изменение объема крупных ссуд кредитной организации").
         oTable:setBorder(1,oTable:height,1,0,0,1). oTable:setBorder(2,oTable:height,1,0,0,1).
         oTable:AddCell("ф.117: более 50% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>9.99") + "%").
         if tempresult > 0.5 then oTable:AddCell(STRING(tempresult * 100 - 50,"->>9.99") + "%").
		             else oTable:AddCell("").

                 
                 

/*конец индикатор 13.*/

/*индикатор 14.*/

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
                      END.
                  end.
                  else 
                  do:
                     tempdeposit = tempdeposit + dataline.val[3].
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
                         END.
                  end.
                  else 
                  do:
                         tempdeposit = tempdeposit + dataline.val[3].
                  end.
         end.

  END.


         if totalprevdeposit  <> 0 then 
         tempresult = tempdeposit / totalprevdeposit.
         tempresult = tempresult.
         oTable:AddRow().
         oTable:AddCell("14.").
         oTable:AddCell("Существенное измениен по данным отчетности по форме 0409157 ""Сведения о крупных кредиторах (вкладчиках) кредитной организации""").
         oTable:AddCell("более 10% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>9.99") + "%").
         if tempresult > 0.1 then oTable:AddCell(STRING(tempresult * 100 - 10,"->>9.99") + "%").
		             else oTable:AddCell("").
         oTable:AddRow().
         oTable:AddCell("").
         oTable:AddCell("состава крупных кредторов (вкладчиков), а также такое изменение состава крупных кредиторов (вкладчиков), при котором произошло изменение объема средств крупных кредторов (вкладчиков) кредитной организации").
         oTable:setBorder(1,oTable:height,1,0,0,1). oTable:setBorder(2,oTable:height,1,0,0,1).                                                                                                                  
         oTable:AddCell("более 50% " + TimePeriod).
         oTable:AddCell(STRING(tempresult * 100,"->>9.99") + "%").
         if tempresult > 0.5 then oTable:AddCell(STRING(tempresult * 100 - 50,"->>9.99") + "%").
		             else oTable:AddCell("").



/*конец индикатор 14.*/
     
if iParam = "Print" then DO:

   {setdest.i}
END.
ELSE
DO:
OUTPUT TO VALUE("69t.txt") .
PUT UNFORMAT "To: " + mailto								SKIP
						 "Content-Type: text/plain; charset = ibm866" SKIP
						 "Content-Transfer-Encoding: 8bit" 						SKIP
						 "Subject: Отчет по 69т за " currdate  SKIP(2).
END.
PUT UNFORMATTED "                    Индикаторы банка в соотв. с 69-Т" SKIP.
PUT UNFORMATTED "                           за " STRING(currdate) SKIP.
 oTable:show().


if iParam = "Print" then DO:
   {preview.i}
END.
ELSE
DO:

   PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Start'  SKIP.
  
OUTPUT CLOSE.			  

IF OPSYS = "UNIX" THEN DO:
	 OS-COMMAND SILENT VALUE("/usr/sbin/sendmail -t -oi < 69t.txt").
END.

OS-DELETE VALUE("69t.txt").
end.


DELETE OBJECT oTable.
