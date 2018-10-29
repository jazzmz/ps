/*************************************************************
 *                                                           *                                      
 *                                                           *
 * Процедура формирует распоряжение на погашение процентов   *     
 * за пользование кредитом предварительной ковертацией.      *
 *                                                           *
 *                                                           *
 *************************************************************
 * Автор: Красков А.С.                                       *
 * Дата создания: 03.09.2012                                 *
 * заявка №1008                                              *
 *************************************************************/

using Progress.Lang.*.
{globals.i}

{get-bankname.i}

{tmprecid.def}

{t-otch.i new}

{intrface.get loan}
{intrface.get cust}

{ulib.i}

{wordwrap.def}

{getdates.i}

DEF VAR dat-per AS DATE NO-UNDO.        /* Дата перехода на 39-П */

DEF VAR oTpl      AS TTpl NO-UNDO.
DEF VAR oTable    AS TTable NO-UNDO.
def var acct_c    AS CHAR NO-UNDO.
def var acct_D    AS CHAR NO-UNDO.
def var cName     AS CHAR NO-UNDO.
def var rPog      AS decimal NO-UNDO.
DEF VAR dNachProc AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dItog     AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR proc-name AS CHARACTER NO-UNDO.
def var i         AS INTEGER NO-UNDO.
def buffer bfracct for acct. 


DEF VAR evidence AS CHAR
        LABEL "Текст основания"
        VIEW-AS 
        EDITOR SIZE 48 BY 7 NO-UNDO.

DEF VAR raspDate AS DATE
        LABEL "Дата распоряжения" NO-UNDO.

def var acct_conv as CHAR FORMAT "x(20)"
        LABEL "Счет для конвертации" NO-UNDO.




def var maintext AS CHAR EXTENT 11 NO-UNDO.
def var SummaStr AS CHAR EXTENT 2 NO-UNDO.
def var SummaStr2 AS CHAR EXTENT 2 NO-UNDO.

maintext[1] = "        Списать в безакцептном порядке со счета № #acct_c# с последующим зачислением на счете № #acct_D# "   
            + "сумму в размере #dItog# (#dItogProp#) #cur_prop# #kopeiki# с предварительной конвертацией со счета "  
            + "#acct_conv# по курсу и на условиях, установленных Банком для проведения конверсионных операций на дату проведения операции в счет "   
            + "погашения процентов за пользование кредитом с #beg-date# по #end-date#, заключенному Кредитному договору №#cont-code# от #DateSogl#, заключенному между "  
            + cBankName + " и #cName#.".



        raspDate = end-date.        

        oTpl = new TTpl("pirloan1008.tpl").

        oTable = new TTable(6).
        oTable:addRow().
        oTable:addCell("").
        oTable:addCell("С").
        oTable:addCell("По").
        oTable:addCell("").
        oTable:addCell("").
        oTable:addCell("").



find first tmprecid NO-LOCK.
find FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK.
do:
         find first loan-acct where loan-acct.cont-code = loan.cont-code and (loan-acct.acct-type eq "КредРасч") NO-LOCK NO-ERROR.
         IF NOT AVAILABLE (loan-acct) then MESSAGE "К договору не привязан счет с ролью КредРасч!!!" VIEW-AS ALERT-BOX.

          acct_c = loan-acct.acct.

          acct_conv = "".

           find first bfracct where bfracct.cust-id = loan.cust-id 
                             and bfracct.currency = "" 
                             and can-do("Расчет,Текущ",bfracct.contract)
                             and (bfracct.close-date >= end-date or bfracct.close-date = ?)
                             and (bfracct.open-date <= end-date)
                             NO-LOCK NO-ERROR. 
           IF NOT AVAILABLE (bfracct) then 
                                          DO:
                                                 MESSAGE "Не найден счет для конвертации!" VIEW-AS ALERT-BOX.
                                             RETURN.
                                          END.

          acct_conv = bfracct.acct.

        /*берем данные из формы*/
      DO TRANSACTION:

      message "Выбирите счет для конвертации" VIEW-AS ALERT-BOX.
      RUN browseld.p ("acct",    /* Класс объекта. */
                      "cust-cat" + CHR(1) + "cust-id", /* Поля для предустановки. */
                      loan.cust-cat + CHR(1) + STRING(loan.cust-id),         /* Список значений полей. */
                      "",           /* Поля для блокировки. */
                      1).          /* Строка отображения фрейма. */

      IF keyfunc(lastkey) NE "end-error"
      THEN DO:
         ASSIGN
            acct_conv = ENTRY(1,pick-value).

      END.

      END.

           UPDATE raspDate evidence acct_conv WITH FRAME frmTmp CENTERED SIDE-LABELS OVERLAY.






        /*Получили данные из формы*/


           find first loan-acct where loan-acct.cont-code = loan.cont-code and (loan-acct.acct-type eq "КредПроц") NO-LOCK NO-ERROR.
           IF NOT AVAILABLE (loan-acct) then MESSAGE "К договору не привязан счет с ролью КредПроц!!!" VIEW-AS ALERT-BOX.
           acct_d = loan-acct.acct.


            if loan.cust-cat eq "Ч" then 
           do:
               FIND FIRST person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.
               cName = person.name-last + " " + person.first-names.
           end.
           if loan.cust-cat eq "Ю" then 
           do:
              FIND FIRST cust-corp where cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
              cName = cust-corp.name-short.
           end.
           if loan.cust-cat eq "Б" then 
           do:
              FIND FIRST banks where banks.bank-id = loan.cust-id NO-LOCK NO-ERROR.
              cName = banks.short-name.
           end.



   {empty otch1}

   {ch_dat_p.i}
                                        

 {get_meth.i 'NachProc' 'nach-pp'}

   run VALUE(proc-name + ".p") (loan.contract,
                 loan.cont-code,
                 beg-date,
                 end-date,
                 dat-per,
                 ?,
                 1).

        FOR EACH otch1,
         FIRST loan-par WHERE TRIM(loan-par.name) EQ TRIM(ENTRY(1,otch1.comment)) 
                              AND CAN-DO("4",STRING(loan-par.amt-id)) NO-LOCK:

               oTable:addRow().
               oTable:addCell(otch1.bal-sum).
               oTable:addCell(otch1.beg-date).
               oTable:addCell(otch1.end-date).
               oTable:addCell(otch1.ndays).
               oTable:addCell(STRING(otch1.rat1) + "%").
               oTable:addCell(otch1.summ_pr).

               ACCUMULATE otch1.summ_pr (TOTAL).
        END.

   dNachProc = (ACCUM TOTAL otch1.summ_pr).


    /*ищем погащение процентов за период формирования распоряги.
при этом учтем что погашение отразится операцией 9 в loan-int*/

         rPog = 0.

       for each loan-int
        where loan-int.cont-code = loan.cont-code

          and loan-int.contract = loan.contract
          and loan-int.mdate >= beg-Date 
          and loan-int.mdate <= end-Date 

          and ((loan-int.id-d = 6) /* НАЧ=6 И СП=4 ЭТО ОПЕРАЦИЯ 9 */
          and (loan-int.id-k = 4)) NO-lock.
          rPog = rPog + loan-int.amt-rub.
       end.                  

/**/

     dItog = dNachProc - rPog.

     if dItog < 0 then Message  "Ошибка расчета процентов" VIEW-AS ALERT-BOX.

     Run x-amtstr.p(dItog, loan.currency, false, true, output SummaStr[1], output SummaStr[2]).
     Run x-amtstr.p(dItog, loan.currency, true, true, output SummaStr2[1], output SummaStr2[2]).

     SummaStr2[1] = REPLACE(summaStr2[1],summastr[1],"").


     oTpl:addAnchorValue("dNachProc",TRIM(STRING(dNachProc,">>>,>>>,>>>,>>9.99"))).
     oTpl:addAnchorValue("dOplProc",TRIM(STRING(rPog,">>>,>>>,>>>,>>9.99"))).
     oTpl:addAnchorValue("dItog",TRIM(STRING(dItog,">>>,>>>,>>>,>>9.99"))).

     oTpl:addAnchorValue("BEG-DATE",beg-date).
     oTpl:addAnchorValue("END-DATE",end-date).
     oTpl:addAnchorValue("CURRENCY",(IF loan.currency EQ "" THEN "810" ELSE loan.currency)).
     oTpl:addAnchorValue("TABLE",oTable).
     oTpl:AddAnchorValue("DATE",raspdate).
     oTpl:AddAnchorValue("evidence",evidence).

     maintext[1] = REPLACE(maintext[1],"#acct_c#",acct_c).
     maintext[1] = REPLACE(maintext[1],"#acct_d#",acct_d).
     maintext[1] = REPLACE(maintext[1],"#acct_conv#",acct_conv).
     maintext[1] = REPLACE(maintext[1],"#ditog#",TRIM(STRiNG(ditog,">>>,>>>,>>>,>>9.99"))).
     maintext[1] = REPLACE(maintext[1],"#ditogProp#",summastr[1]).
     maintext[1] = REPLACE(maintext[1],"#cur_prop#",summastr2[1]).
     maintext[1] = REPLACE(maintext[1],"#kopeiki#",summastr[2]).
     maintext[1] = REPLACE(maintext[1],"#beg-date#",STRING(beg-date)).
     maintext[1] = REPLACE(maintext[1],"#end-date#",STRING(end-date)).
     maintext[1] = REPLACE(maintext[1],"#cont-code#",loan.cont-code).
     maintext[1] = REPLACE(maintext[1],"#DateSogl#",getMainLoanAttr("Кредит",loan.cont-code,"%ДатаСогл")).
     maintext[1] = REPLACE(maintext[1],"#cName#",cName).
    


    {wordwrap.i &s=MainText &l=88 &n=11}

		DO i = 2 TO 11:
			if MainText[i] <> "" then do:
				maintext[1] = maintext[1] + CHR(10) + maintext[i].
			end.
		END.

    oTpl:addAnchorValue("maintext1",maintext[1]).




END. 

{setdest.i}
   oTpl:show().
{preview.i}

        DELETE OBJECT oTable.
        DELETE OBJECT oTpl.

