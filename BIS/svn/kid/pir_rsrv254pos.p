{pirsavelog.p}

/*
   Распоряжение по резервам 232-П
   Бурягин Е.П. 10.01.2006 10:19

   Условимся, что броузере выбраны только "правильные" документы, т.е. те,
   которые должны отображаться в настоящем распоряжении.

Modified: 20.05.2009 Borisov - Добавлены колонки обеспечения
*/

{globals.i} /* Подключяем глобалные настройки*/

{ulib.i}    /* Библиотека функций для работы со счетами */
{intrface.get rsrv}
{intrface.get i254}
{intrface.get instrum}
{intrface.get loan}
{intrface.get xclass}   /* Функции работы с метасхемой */
{intrface.get count}

{lshpr.pro}           /* Инструменты для расчета параметров договора */

{pir-gp.i}


/* ============================================== */
DEF VAR oTable AS TTable       NO-UNDO.
DEF VAR oTpl     AS TTpl           NO-UNDO.
DEF VAR oDoc   AS TDocument NO-UNDO.

oTpl = new TTpl("pir_rsrv254pos.tpl").


DEF INPUT PARAM inParam    AS CHARACTER.
DEF VAR acct_rsrv          AS CHARACTER NO-UNDO. /* Счет резерва: определим и сохраним его в этой переменной */
DEF VAR acct_main_no       AS CHARACTER NO-UNDO. /* Внебалансовый счет, который попадает в первый столбец */
DEF VAR acct_main_cur      AS CHARACTER NO-UNDO.
DEF VAR acct_main_pos      AS DECIMAL   NO-UNDO. /* Позиция по счету */
DEF VAR acct_main_pos_rur  AS DECIMAL   NO-UNDO.
DEF VAR acct_rsrv_calc_pos AS DECIMAL   NO-UNDO.
DEF VAR acct_rsrv_real_pos AS DECIMAL   NO-UNDO.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

def var main_acct_type as CHARACTER NO-UNDO.
def var rsrv_accts as CHAR INIT "45515*,45715*,45818*" NO-UNDO.

/* Сумма операции */
DEF VAR amt_create  AS DECIMAL   NO-UNDO.
DEF VAR amt_delete  AS DECIMAL   NO-UNDO.

DEF VAR client_name AS CHARACTER NO-UNDO.
DEF VAR loaninf     AS CHARACTER NO-UNDO.
DEF VAR grrisk      AS INTEGER   NO-UNDO.
DEF VAR prrisk      AS DECIMAL   NO-UNDO.
DEF VAR obesp       AS DECIMAL   NO-UNDO.
DEF VAR o2          AS DECIMAL   NO-UNDO. /* obesp usl dog - ne isp */
DEF VAR ob-cat      AS CHARACTER NO-UNDO.
DEF VAR iob-cat     AS DECIMAL   NO-UNDO.
DEF VAR loannum     AS CHARACTER NO-UNDO.
DEF VAR vSurr       AS CHARACTER NO-UNDO. /* Суррогат обязательства */


def var dt1 as dec no-undo.
def var dt2 as dec no-undo.

def var KursUSD as dec no-undo.
def var KursEUR as dec no-undo.
def var useridp  as char no-undo.

/* Итоговые значения */
DEF VAR total_pos         AS DECIMAL NO-UNDO.
DEF VAR total_pos_rur     AS DECIMAL NO-UNDO.
DEF VAR total_pos_usd     AS DECIMAL NO-UNDO.
DEF VAR total_pos_eur     AS DECIMAL NO-UNDO.
DEF VAR total_calc_rsrv   AS DECIMAL NO-UNDO.
DEF VAR total_real_rsrv   AS DECIMAL NO-UNDO.
DEF VAR total_create_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_delete_rsrv AS DECIMAL NO-UNDO.

DEF VAR traceOn           AS LOGICAL INITIAL false NO-UNDO. /* Вывод ошибок на экран */
DEF VAR tmpStr    AS CHARACTER NO-UNDO. /* Временная для работы */
DEF VAR PIRbos    AS CHARACTER NO-UNDO. /* Должности и подписи */
DEF VAR PIRbosFIO AS CHARACTER NO-UNDO.
DEF VAR userPost  AS CHARACTER NO-UNDO.

DEF BUFFER bfrLA  FOR loan-acct.
def buffer bfropentry for op-entry.

def temp-table tTemp NO-UNDO
           field reserv_acct like loan-acct.acct
         field balanse_acct like loan-acct.acct
         INDEX reserv_acct IS PRIMARY reserv_acct.



def var TempTransh AS DEC NO-UNDO.
def var TempRSRV AS DEC NO-UNDO.
def var temp as dec no-undo.
def var td1 as dec no-undo.

def var par as INTEGER no-undo.

def var rezbase as char no-undo.

def var oAcct as TAcct no-undo.
def var oFunc as tfunc no-undo.
DEF VAR DATE-rasp AS DATE NO-UNDO. /* Дата распоряжения */
/* Таблица выделенных в броузере документов */

{tmprecid.def}

def var tempacct_main_pos_rur as dec NO-UNDO.

Procedure CalcPos.
def var summ as dec no-undo.

def var cPos as char no-undo.
def buffer bfLoan for loan.
cPos = ENTRY(1,loan-acct.cont-code," ").
tempacct_main_pos_rur = 0.
for each bfloan where can-do("loan_trans_diff,l_agr_with_diff",bfloan.class-code) 
		and bfloan.contract = "Кредит" 
		and (bfloan.close-date >= op.op-date or bfloan.close-date = ?)  NO-LOCK,
    LAST term-obl WHERE term-obl.contract EQ "Кредит" 
		     AND term-obl.cont-code EQ bfloan.cont-code 	
		     AND term-obl.idnt EQ 128 
		     AND term-obl.lnk-cont-code eq cPos
	   	     AND term-obl.end-date <= op.op-date 
		     AND (term-obl.sop-date GE op.op-date OR term-obl.sop-date EQ ?) NO-LOCK. 
/*было 
/*RUN STNDRT_PARAM(bfloan.contract, bfloan.cont-code,  par, op.op-date, OUTPUT summ , OUTPUT dT1, OUTPUT dT2).

*/


           if bfloan.currency = '840' then DO:
	      summ = round(summ * kursUSD,2).                        
	   end.

           if bfloan.currency = '978' then DO:
	      summ = round(summ * kursEUR,2).                        
	   end.



tempacct_main_pos_rur = tempacct_main_pos_rur + summ.                                                           */

 /**/
 /*стало*/

summ = getRsrvBase(bfloan.cont-code,op.op-date,rezbase).

           if bfloan.currency = '840' then DO:
	      summ = round(summ * kursUSD,2).                        
	   end.

           if bfloan.currency = '978' then DO:
	      summ = round(summ * kursEUR,2).                        
	   end.


tempacct_main_pos_rur = tempacct_main_pos_rur + summ.
  /**/


end.


END PROCEDURE.


/**** Маслов выгрузка в архив ***/
&IF DEFINED(arch2)<>0 &THEN
&GLOBAL-DEFINE wsd 1
{pir-out2arch.i}
 curr-user-inspector = FGetSetting("PirEArch","RepInspCredit",?). /* #3718 */
&ENDIF


{init-bar.i "Обработка документов"}

for each tmprecid NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.



/** Проверка входящего параметра =================================================== */
IF NUM-ENTRIES(inParam) <> 2 
THEN DO:
   MESSAGE "Недостаточное кол-во параметров. Должно быть <норм_документ>,<код_руководителя_из_PIRBoss>" 
      VIEW-AS ALERT-BOX.
   RETURN.
END.

PIRbos      =  ENTRY(1, FGetSetting("PIRboss", ENTRY(2, inParam), "")).
PIRbosFIO = ENTRY(2, FGetSetting("PIRboss", ENTRY(2, inParam), "")).




/** РЕАЛИЗАЦИЯ **/

/* Из первой операции найдем дату отчета */
DATE-rasp = gend-date.

oTable = new TTable(16).
oFunc = new tfunc().
/* Для всех документов, выбранных в брoузере выполняем... =========================== */
FOR EACH tmprecid NO-LOCK, 
first op where RECID(op) = tmprecid.id.

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i              	
            vLnCountInt
            vLnTotalInt
          }


            FIND FIRST instr-rate WHERE instr-rate.instr-cat EQ 'currency' 
                                                                  AND instr-rate.instr-code EQ STRING(840)
                                                                  AND instr-rate.rate-type EQ 'Учетный' 
                                                                  AND instr-rate.since = op.op-date
                                                    NO-LOCK NO-ERROR.


            IF AVAILABLE(instr-rate) THEN kursusd =  instr-rate.rate-instr. ELSE MESSAGE "Не найден курс USD!!!" VIEW-AS ALERT-BOX.


            FIND FIRST instr-rate WHERE instr-rate.instr-cat EQ 'currency' 
                                                                  AND instr-rate.instr-code EQ STRING(978)
                                                                  AND instr-rate.rate-type EQ 'Учетный' 
                                                                  AND instr-rate.since = op.op-date 
                                                    NO-LOCK NO-ERROR.

            IF AVAILABLE(instr-rate) THEN kursEUR =  instr-rate.rate-instr. ELSE MESSAGE "Не найден курс EUR!!!" VIEW-AS ALERT-BOX.



 oDoc = new TDocument(tmprecid.id).
   ASSIGN
      amt_create = 0
      amt_delete = 0
   .
   /* Найдем счет резерва в проводке. Он либо по дебету, либо по кредиту и начинается с 4 
      попутно сохраним значение суммы проводки в соответствующую переменную  */
   IF oDoc:acct-db BEGINS "4" THEN
      ASSIGN
         acct_rsrv =  oDoc:acct-db
         amt_delete = oDoc:sum
      .
   IF oDoc:acct-cr BEGINS "4" THEN
      ASSIGN
         acct_rsrv = oDoc:acct-cr
         amt_create = oDoc:sum
      .

   /* Если все-таки ни по дебету, ни по кредиту счет, начинающийся на 4 не найден,
      выдаем сообщение и выходим из процедуры */
   IF acct_rsrv = ""
   THEN DO:
      MESSAGE "В проводке документа " + oDoc:doc-num + " нет счета резерва, начинающегося на 4!" VIEW-AS ALERT-BOX.
      RETURN.
   END.

/* по счету в документе определяем какой ПОС и параметр резерва. сделано нехорошо, придумаю как сделать лучше - переделаю */

find first tTemp where reserv_acct = acct_rsrv NO-LOCK NO-ERROR.
                if NOT AVAILABLE(tTemp) then
                 do:

   /*тут небольшой "костыль" для ПОС. позже придумаю как переделать - переделаю */

   if can-do(rsrv_accts,acct_rsrv) then do:
      find last loan-acct where loan-acct.contract = "ПОС" and loan-acct.acct = acct_rsrv and loan-acct.since <= op.op-date and CAN-DO("!ПЛкартС1*,*",loan-acct.cont-code) NO-LOCK NO-ERROR.
      if available (loan-acct) then 
         do:
            acct_main_no = "".                                   
            client_name = "".
            loaninf = "".
           find last comm-rate where comm-rate.commission begins "%Рез" 
                                  and comm-rate.kau = "ПОС," + ENTRY(1,loan-acct.cont-code," ") 
                                 and comm-rate.since <= op.op-date NO-LOCK NO-ERROR.

            if available(comm-rate) then
              do:

                 prrisk = comm-rate.rate-comm.

                 if ENTRY(1,loan-acct.cont-code," ") = 'ПЛКарт1' then loaninf = 'ПОС1'.
                 if ENTRY(1,loan-acct.cont-code," ") = 'ПЛКарт2' then loaninf = 'ПОС2'.
                 if ENTRY(1,loan-acct.cont-code," ") = 'ПЛКарт4' then loaninf = 'ПОС3'.
                 if ENTRY(1,loan-acct.cont-code," ") = 'ПЛКарт5' then loaninf = 'ПОС4'.
                 if ENTRY(1,loan-acct.cont-code," ") = 'ПЛКарт3' then loaninf = 'ПОС5'.
                 if ENTRY(1,loan-acct.cont-code," ") = 'ПЛКарт6' then loaninf = 'ПОС6'.

                 if loaninf <> "ПОС1" then 
	   	    do:	
 			acct_main_no = "45815(17)".
	   	        par = 7. 	
			rezbase = "baddebt".
	   	        RUN calcpos.
                        acct_main_pos_rur = tempacct_main_pos_rur.
		    end.	
                 else
                   do:
                       if loan-acct.acct-type = "КредРез" then 
			 do:
			    acct_main_no = "45509 (45708)".
/*			    par = 0. 	*/

   	 	 	    rezbase = "debt".

	                    RUN calcpos.

	                    acct_main_pos_rur = tempacct_main_pos_rur.



	                 end.
                       else 
			do:
			   acct_main_no = "45708".
/*			   par = 0.*/
	 	 	   rezbase = "debt".
			   RUN calcpos.
                           acct_main_pos_rur = tempacct_main_pos_rur.

			end.
                   end.
                  

              end.
              else MESSAGE "Не найден коэффициент резервирования для " ENTRY(1,loan-acct.cont-code," ") VIEW-AS ALERT-BOX.
                        amt_delete = 0.
			amt_create = 0.
		     for each bfropentry where bfropentry.op-date = op.op-date and (bfropentry.acct-db = acct_rsrv or bfropentry.acct-cr = acct_rsrv) NO-LOCK.
			   IF bfropentry.acct-db BEGINS "4" THEN
			      ASSIGN
			         amt_delete = amt_delete + bfropentry.amt-rub.
			      
			   IF bfropentry.acct-cr BEGINS "4" THEN
			      ASSIGN
			         amt_create = amt_create + bfropentry.amt-rub.
			      
		      end.
                   oAcct = new TAcct(acct_rsrv).
   
                   acct_rsrv_calc_pos = oAcct:getLastPos2date(op.op-date).
                     acct_rsrv_real_pos = oAcct:getLastPos2date(op.op-date) - amt_create + amt_delete.                                     
                   delete object oAcct.

                                   create ttemp.
                      assign 
                            reserv_acct = acct_rsrv
                            balanse_acct = acct_main_no.    
         end.
       else /*если счет не привязан к ПОСу то значит договор на инидивудальной основе */ 
            DO:


/*Тут небольшие переделки из-за того что сначала было сказана группировать все проводки по договору в одну строчку,
 а теперь сказано переделать на то чтобы каждая строка соотвествовала проводке.  */
		  do:
                      /* Найдем название клиента */
                      client_name = GetAcctClientName_UAL(acct_rsrv, traceOn).
                      /* Найдем информацию о договоре */
                      loannum = oDoc:getLnkLoanNum().   

                      IF NOT {assigned client_name} THEN  client_name = GetLoanInfo_ULL("Кредит",loannum, "client_short_name", false).
                      /*loaninf = getMainLoanAttr("Кредит",loannum,"Договор № %cont-code от %ДатаСогл").*/
		      loaninf = loannum.

                      find first loan-acct where loan-acct.contract = "Кредит" 
                                             and loan-acct.cont-code = loannum 
                                             and loan-acct.acct = acct_rsrv NO-LOCK NO-ERROR.

                      if not available (loan-acct) then MESSAGE "Не найдена привязка счета к договору! " loannum acct_rsrv VIEW-AS ALERT-BOX.
/*                      message loannum view-as alert-box.*/
                      main_acct_type = "".
                      if loan-acct.acct-type = "КредРез" then 
			do:
			   main_acct_type = "Кредит".   	
			   RUN STNDRT_PARAM("Кредит", loannum,  0, op.op-date, OUTPUT tempacct_main_pos_rur , OUTPUT dT1, OUTPUT dT2).
                           acct_main_pos = tempacct_main_pos_rur.
			   RUN STNDRT_PARAM("Кредит", loannum,  2, op.op-date, OUTPUT tempacct_main_pos_rur , OUTPUT dT1, OUTPUT dT2).
                           acct_main_pos = acct_main_pos + tempacct_main_pos_rur.
			   RUN STNDRT_PARAM("Кредит", loannum,  21, op.op-date, OUTPUT acct_rsrv_calc_pos , OUTPUT dT1, OUTPUT dT2).
                           acct_rsrv_calc_pos = ABS(acct_rsrv_calc_pos).
			end.
                      if loan-acct.acct-type = "КредРез1" then 
			do:
			   main_acct_type = "КредПр". 
			   RUN STNDRT_PARAM("Кредит", loannum,  7, op.op-date, OUTPUT tempacct_main_pos_rur , OUTPUT dT1, OUTPUT dT2).
                           acct_main_pos = tempacct_main_pos_rur.
			   RUN STNDRT_PARAM("Кредит", loannum,  2, op.op-date, OUTPUT tempacct_main_pos_rur , OUTPUT dT1, OUTPUT dT2).
                           acct_main_pos = acct_main_pos + tempacct_main_pos_rur.
			   RUN STNDRT_PARAM("Кредит", loannum,  46, op.op-date, OUTPUT acct_rsrv_calc_pos , OUTPUT dT1, OUTPUT dT2).
                           acct_rsrv_calc_pos = ABS(acct_rsrv_calc_pos).
			end.


                      find last loan-acct where loan-acct.contract = "Кредит" 
                                             and loan-acct.cont-code begins loannum 
                                             and loan-acct.acct-type = main_acct_type NO-LOCK NO-ERROR.
        
                      if not available (loan-acct) then MESSAGE "Не найдена привязка счета c ролью  " + main_acct_type + " для договора: " + loannum  VIEW-AS ALERT-BOX.

                      acct_main_no = loan-acct.acct.
                      acct_main_cur = getMainLoanAttr("Кредит",loannum,"%currency").


                      acct_main_pos_rur = CurToCur ("УЧЕТНЫЙ", acct_main_cur, "", DATE-rasp, acct_main_pos).


                      /* Определим процентную ставку и группу риска */
/*                      prrisk = GetCommRate_ULL("%Рез", (if acct_main_cur = "810" then "" else acct_main_cur), 0, acct_main_no, 0, DATE-rasp, false) * 100.*/
                      prrisk = DEC(ENTRY(1,ofunc:getKRez(ENTRY(1,loannum," "),op.op-date))).
	              amt_delete = 0.
                      amt_create = 0.

			   IF oDoc:acct-db BEGINS "4" THEN
			      ASSIGN
			         amt_delete = amt_delete + oDoc:sum.
			      
			   IF oDoc:acct-cr BEGINS "4" THEN
			      ASSIGN
			         amt_create = amt_create + oDoc:sum.
			      
/*		      end.*/


                      /* Найдем расчетный резерв. На самом деле, на момент выполнения процедуры это фактически уже 
                         сформированный резерв */
/*                      acct_rsrv_calc_pos = ABS(GetAcctPosValue_UAL(acct_rsrv, "810", oDoc:op-date, traceOn)).*/

                      /* Найдем сформированный резерв. Поскольку распоряжение формируется по факту, т.е. по проводкам, то
                         сумма сформированного резерва = остаток на счете резерва +- сумма проводки */
                      acct_rsrv_real_pos = acct_rsrv_calc_pos - amt_create + amt_delete.

                             
                 END.        


/*КОНЕЦ ПЕРЕДЕЛОК далее непеределаный вариант для возврата если будет надо */
          /*       do:
                      /* Найдем название клиента */
                      client_name = GetAcctClientName_UAL(acct_rsrv, traceOn).

                      /* Найдем информацию о договоре */
                      loannum = oDoc:getLnkLoanNum().   
                      if NUM-ENTRIES(loannum," ") <> 1 then 
                      do: 
                         loaninf = loannum.
                         loannum = ENTRY(1,loannum," ").
                      end.

                      IF NOT {assigned client_name} THEN  client_name = GetLoanInfo_ULL("Кредит",loannum, "client_short_name", false).
                      loaninf = getMainLoanAttr("Кредит",loannum,"Договор № %cont-code от %ДатаСогл").

                      find first loan-acct where loan-acct.contract = "Кредит" 
                                             and loan-acct.cont-code = loannum 
                                             and loan-acct.acct = acct_rsrv NO-LOCK NO-ERROR.

                      if not available (loan-acct) then MESSAGE "Не найдена привязка счета к договору! " loannum acct_rsrv VIEW-AS ALERT-BOX.
        
                      main_acct_type = "".
                      if loan-acct.acct-type = "КредРез" then main_acct_type = "Кредит".
                      if loan-acct.acct-type = "КредРез1" then main_acct_type = "КредПр". 

                      find last loan-acct where loan-acct.contract = "Кредит" 
                                             and loan-acct.cont-code begins loannum 
                                             and loan-acct.acct-type = main_acct_type NO-LOCK NO-ERROR.
        
                      if not available (loan-acct) then MESSAGE "Не найдена привязка счета c ролью  " + main_acct_type + " для договора: " + loannum  VIEW-AS ALERT-BOX.

                      acct_main_no = loan-acct.acct.
                      acct_main_cur = getMainLoanAttr("Кредит",loannum,"%currency").
                      oAcct = new TAcct (acct_main_no).
                      acct_main_pos = oAcct:getLastPos2Date(op.op-date).

/*ABS(GetAcctPosValue_UAL(acct_main_no, acct_main_cur, oDoc:op-date, traceOn)).*/

                      acct_main_pos_rur = CurToCur ("УЧЕТНЫЙ", acct_main_cur, "", DATE-rasp, acct_main_pos).


                      /* Определим процентную ставку и группу риска */
                      prrisk = GetCommRate_ULL("%Рез", (if acct_main_cur = "810" then "" else acct_main_cur), 0, acct_main_no, 0, DATE-rasp, false) * 100.
                      prrisk = DEC(ENTRY(1,ofunc:getKRez(loannum,op.op-date))).
	              amt_delete = 0.
                      amt_create = 0.
		     for each bfropentry where bfropentry.op-date = op.op-date and (bfropentry.acct-db = acct_rsrv or bfropentry.acct-cr = acct_rsrv) NO-LOCK.
			   IF bfropentry.acct-db BEGINS "4" THEN
			      ASSIGN
			         amt_delete = amt_delete + bfropentry.amt-rub.
			      
			   IF bfropentry.acct-cr BEGINS "4" THEN
			      ASSIGN
			         amt_create = amt_create + bfropentry.amt-rub.
			      
		      end.


                      /* Найдем расчетный резерв. На самом деле, на момент выполнения процедуры это фактически уже 
                         сформированный резерв */
                      acct_rsrv_calc_pos = ABS(GetAcctPosValue_UAL(acct_rsrv, "810", oDoc:op-date, traceOn)).

                      /* Найдем сформированный резерв. Поскольку распоряжение формируется по факту, т.е. по проводкам, то
                         сумма сформированного резерва = остаток на счете резерва +- сумма проводки */
                      acct_rsrv_real_pos = acct_rsrv_calc_pos - amt_create + amt_delete.


                 END.        */
                
           END.     
   end.






   /* Накапливаем итоговые суммы */
   total_pos = total_pos + acct_main_pos_rur.
   total_pos_rur = total_pos_rur + acct_main_pos.

   ASSIGN
      total_calc_rsrv = total_calc_rsrv + acct_rsrv_calc_pos
      total_real_rsrv = total_real_rsrv + acct_rsrv_real_pos
      total_create_rsrv = total_create_rsrv + amt_create
      total_delete_rsrv = total_delete_rsrv + amt_delete
   .




                                    
/* Основное тело таблицы */
  if loaninf <> "" then
     do:
	oTable:addRow().
	oTable:addCell(acct_main_no + " " +  client_name + " " + loaninf).
	oTable:addCell(TRIM(STRING(round(acct_main_pos_rur,2),">>>,>>>,>>>,>>9.99"))).
	oTable:addCell(prrisk).
	oTable:addCell(TRIM(STRING(round(acct_rsrv_calc_pos,2),">>>,>>>,>>>,>>9.99"))).
	oTable:addCell(TRIM(STRING(round(acct_rsrv_real_pos,2),">>>,>>>,>>>,>>9.99"))).
	oTable:addCell(TRIM(STRING(round(amt_create,2),">>>,>>>,>>>,>>9.99"))).
	oTable:addCell(TRIM(STRING(round(amt_delete,2),">>>,>>>,>>>,>>9.99"))).
	
	oTable:addCell(oDoc:acct-db).
	oTable:addCell(oDoc:acct-cr).
    end.
end.
DELETE OBJECT oDoc.

vLnCountInt = vLnCountInt + 1.
useridp = op.user-id.

END.

/*заявка 3212 начало*/
FIND FIRST _user WHERE _user._userid = useridp NO-LOCK NO-ERROR.
IF AVAIL _user THEN do:
	useridp = ENTRY(1,_user._user-name," ") + " " + 
		substring(ENTRY(2,_user._user-name," "),1,1) + "." + substring(ENTRY(3,_user._user-name," "),1,1) + ".".
end.
/*заявка 3212 конец*/

/* Итого */
oTable:addRow().
oTable:addCell("ИТОГО:").
oTable:addCell(TRIM(STRING(round(total_pos,2),">>>,>>>,>>>,>>9.99"))).
oTable:addCell("").
oTable:addCell(TRIM(STRING(round(total_calc_rsrv,2),">>>,>>>,>>>,>>9.99"))).
oTable:addCell(TRIM(STRING(round(total_real_rsrv,2),">>>,>>>,>>>,>>9.99"))).
oTable:addCell(TRIM(STRING(round(total_create_rsrv,2),">>>,>>>,>>>,>>9.99"))).
oTable:addCell(TRIM(STRING(round(total_delete_rsrv,2),">>>,>>>,>>>,>>9.99"))).
oTable:addCell("").
oTable:addCell("").




/*oTable:setBorder(1,oTable:height,1,0,1,1).
oTable:setBorder(1,oTable:height - 1,1,0,1,1).
oTable:setAlign(1,oTable:height - 2,"center").*/

oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("date-rasp",date-rasp).
oTpl:addAnchorValue("useridp",useridp).

{setdest.i &cols=220} /* Вывод в preview */
        oTpl:show().
{preview.i}
DELETE OBJECT oTpl.
/*DELETE OBJECT oTable.    */
DELETE OBJECT ofunc.


{send2arch.i}


{intrface.del}