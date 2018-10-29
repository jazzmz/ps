/*Отчет
Автор: Красков А.С.
Процедура формирует распоряжение по начисленнию процентов по договорам ПК в конце месяца
запускается из браузера документов */

{globals.i}
{tmprecid.def}
{ulib.i}


DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик документов */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество документов */

DEF VAR oTable1 AS TTable NO-UNDO.
DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oTAcct AS TAcct NO-UNDO.

DEF VAR months AS CHAR NO-UNDO 
	INITIAL "января,февраля,марта,апреля,мая,июня,июля,августа,сентября,октября,ноября,декабря".
DEF VAR monthss AS CHAR NO-UNDO 
	INITIAL "январь,февраль,март,апрель,май,июнь,июль,август,сентябрь,октябрь,ноябрь,декабрь".
def var i AS integer NO-UNDO.
def var J AS integer NO-UNDO.
def var count AS Integer INIT 0 NO-UNDO.
DEF VAR dItog AS DEC INIT 0 NO-UNDO.
Def Var dOstKredit AS DEC INIT 0 NO-UNDO.
def var rate as DEC INIT 0 NO-UNDO.
def var grrisk as integer INIT 0 NO-UNDO.
def var K_rez as DEC INIT 0 NO-UNDO.
DEF VAR FIO AS CHAR NO-UNDO.
def var begdate as date NO-UNDO.
def var ibegdate as date NO-UNDO.
def var enddate as date NO-UNDO.
def var temp as char NO-UNDO.

def var bBal as Logical NO-UNDO.
DEF BUFFER bfrLoan-acct FOR loan-acct.

def var ofunc as tfunc.

def var vInspector as char no-undo .

if not can-find (first tmprecid)
then do:
    message "Нет ни одного выбранного документа!"
    view-as alert-box.
    return.
end.

{init-bar.i "Обработка документов"}

for each tmprecid, first op where RECID(op) EQ tmprecid.id  NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.

ofunc = new tfunc().

vLnTotalInt = vLnTotalInt * 2.
oTable1 = new TTable(9).
oTable1:addRow().
oTable1:addCell("№ п/п").
oTable1:addCell("Заемщик").
oTable1:addCell("Сумма").
oTable1:addCell("% ставка").
oTable1:addCell("№ Кредитного").
oTable1:addCell("Срок действия").
oTable1:addCell("Категория").
oTable1:addCell("Дебет").
oTable1:addCell("Кредит").

oTable1:addRow().
oTable1:addCell(" ").
oTable1:setBorder(1,oTable1:height,1,0,0,1).
oTable1:addCell(" ").
oTable1:setBorder(2,oTable1:height,1,0,0,1).
oTable1:addCell("начисленных").
oTable1:setBorder(3,oTable1:height,1,0,0,1).
oTable1:addCell("годовых").
oTable1:setBorder(4,oTable1:height,1,0,0,1).
oTable1:addCell("договора").
oTable1:setBorder(5,oTable1:height,1,0,0,1).
oTable1:addCell("договора").
oTable1:setBorder(6,oTable1:height,1,0,0,1).
oTable1:addCell("качества").
oTable1:setBorder(7,oTable1:height,1,0,0,1).
oTable1:addCell(" ").
oTable1:setBorder(8,oTable1:height,1,0,0,1).
oTable1:addCell(" ").
oTable1:setBorder(9,oTable1:height,1,0,1,1).


oTable1:addRow().
oTable1:addCell(" ").
oTable1:setBorder(1,oTable1:height,1,0,0,1).
oTable1:addCell(" ").
oTable1:setBorder(2,oTable1:height,1,0,0,1).
oTable1:addCell("процентов").
oTable1:setBorder(3,oTable1:height,1,0,0,1).
oTable1:addCell("").
oTable1:setBorder(4,oTable1:height,1,0,0,1).
oTable1:addCell("").
oTable1:setBorder(5,oTable1:height,1,0,0,1).
oTable1:addCell("").
oTable1:setBorder(6,oTable1:height,1,0,0,1).
oTable1:addCell("(коэффициент").
oTable1:setBorder(7,oTable1:height,1,0,0,1).
oTable1:addCell(" ").
oTable1:setBorder(8,oTable1:height,1,0,0,1).
oTable1:addCell(" ").
oTable1:setBorder(9,oTable1:height,1,0,1,1).

oTable1:addRow().
oTable1:addCell(" ").
oTable1:setBorder(1,oTable1:height,1,0,0,1).
oTable1:addCell(" ").
oTable1:setBorder(2,oTable1:height,1,0,0,1).
oTable1:addCell("по ссуде").
oTable1:setBorder(3,oTable1:height,1,0,0,1).
oTable1:addCell("").
oTable1:setBorder(4,oTable1:height,1,0,0,1).
oTable1:addCell("").
oTable1:setBorder(5,oTable1:height,1,0,0,1).
oTable1:addCell("").
oTable1:setBorder(6,oTable1:height,1,0,0,1).
oTable1:addCell("резервирования)").
oTable1:setBorder(7,oTable1:height,1,0,0,1).
oTable1:addCell(" ").
oTable1:setBorder(8,oTable1:height,1,0,0,1).
oTable1:addCell(" ").
oTable1:setBorder(9,oTable1:height,1,0,1,1).


DO i=1 to 4:
  do j=1 to 9:
   oTable1:setAlign(j,i,"center").
  end.
end.

FOR EACH tmprecid,
    first op where RECID(op) EQ tmprecid.id NO-LOCK.
             /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


    find first op-entry where op-entry.op = op.op NO-LOCK NO-ERROR.
    IF AVAILABLE(op-entry) then do:
       find first loan-acct where loan-acct.acct = op-entry.acct-db and loan-acct.acct-type = "КредТ" NO-LOCK NO-ERROR.
       IF AVAILABLE(loan-acct) then do:
           find first loan where loan.cont-code = loan-acct.cont-code and loan.contract = loan-acct.contract NO-LOCK NO-ERROR.
           dOstKredit = 0.
           bBal = true.
           if loan.cust-cat eq "Ч" then 
           do:
              FIND FIRST person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.
              FIO = person.name-last + " " +  person.first-names.
           end.
           if loan.cust-cat eq "Ю" then 
           do:
	      FIND FIRST cust-corp where cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
              FIO = cust-corp.name-short.
           END.

	   count = count + 1.

           rate = GetLoanCommission_ULL(loan.contract,loan.cont-code,"%Кред",op.op-date, false).

           FIND FIRST loan-int  WHERE loan-int.op = op-entry.op AND loan-int.op-entry = op-entry.op-entry NO-LOCK NO-ERROR.

           IF count = 1 THEN
	     vInspector = op.user-inspector .

           oTable1:addRow().
	   oTable1:addCell(count).
	   oTable1:addCell(FIO).	
	   if (op-entry.currency = "") OR (op-entry.currency = "810") then oTable1:addCell(TRIM(STRING(round(op-entry.amt-rub,2),">>>,>>>,>>>,>>9.99"))). else oTable1:addCell(TRIM(STRING(round(op-entry.amt-cur,2),">>>,>>>,>>>,>>9.99"))).
	   /* oTable1:addCell(loan.currency).  */
	   oTable1:addCell(STRING(rate * 100,">>9.99") + "%").	
		/* #3081 */
	   /* oTable1:addCell(loan.cont-code). */
	   oTable1:addCell(loan-int.cont-code).	
	   oTable1:addCell("с " + STRING(loan.open-date) + " по " + STRING(loan.end-date)).
	   oTable1:addCell(" " + entry(2,ofunc:getKRez(loan.cont-code,Op.op-date)) + "(" + entry(1,ofunc:getKRez(loan.cont-code,Op.op-date)) + "%)").

           if (op-entry.currency = "") OR (op-entry.currency = "810") then dItog = dItog + (op-entry.amt-rub). else dItog = dItog + (op-entry.amt-cur).

	   oTable1:addCell(op-entry.acct-db).
	   oTable1:addCell(TRIM(op-entry.acct-cr)).
       end.
    end.
    vLnCountInt = vLnCountInt + 1.
END.



FOR EACH tmprecid,
    first op where RECID(op) EQ tmprecid.id NO-LOCK.
             /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


    find first op-entry where op-entry.op = op.op NO-LOCK NO-ERROR.
    IF AVAILABLE(op-entry) then do:
       find first loan-acct where loan-acct.acct = op-entry.acct-db and loan-acct.acct-type = "КредТВ" NO-LOCK NO-ERROR.
       IF AVAILABLE(loan-acct) then do:
           find first loan where loan.cont-code = loan-acct.cont-code and loan.contract = loan-acct.contract NO-LOCK NO-ERROR.
           dOstKredit = 0.
           bBal = false.
           if loan.cust-cat eq "Ч" then 
           do:
              FIND FIRST person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.
              FIO = person.name-last + " " +  person.first-names.
           end.
           if loan.cust-cat eq "Ю" then 
           do:
	      FIND FIRST cust-corp where cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
              FIO = cust-corp.name-short.
           END.

	   count = count + 1.

           rate = GetLoanCommission_ULL(loan.contract,loan.cont-code,"%Кред",op.op-date, false).
	   k_rez = GetLoanCommission_ULL(loan.contract,loan.cont-code,"%Рез",op.op-date, false) * 100.

           FIND FIRST loan-int  WHERE loan-int.op = op-entry.op AND loan-int.op-entry = op-entry.op-entry NO-LOCK NO-ERROR.
	    
	   IF count = 1 THEN
	     vInspector = op.user-inspector .
	   
           oTable1:addRow().
	   oTable1:addCell(count).
	   oTable1:addCell(FIO).	
	   if (op-entry.currency = "") OR (op-entry.currency = "810") then oTable1:addCell(TRIM(STRING(round(op-entry.amt-rub,2),">>>,>>>,>>>,>>9.99"))). else oTable1:addCell(TRIM(STRING(round(op-entry.amt-cur,2),">>>,>>>,>>>,>>9.99"))).
	   /* oTable1:addCell(loan.currency).   */
	   oTable1:addCell(STRING(rate * 100,">>9.99") + "%").	
		/* #3081 */
	   /* oTable1:addCell(loan.cont-code). */
	   oTable1:addCell(loan-int.cont-code).	
	   oTable1:addCell("с " + STRING(loan.open-date) + " по " + STRING(loan.end-date)).
	   oTable1:addCell(" " + entry(2,ofunc:getKRez(loan.cont-code,Op.op-date)) + "(" + entry(1,ofunc:getKRez(loan.cont-code,Op.op-date)) + "%)").
	   
           if (op-entry.currency = "") OR (op-entry.currency = "810") then dItog = dItog + (op-entry.amt-rub). else dItog = dItog + (op-entry.amt-cur).

	   oTable1:addCell(op-entry.acct-db).
	   oTable1:addCell(TRIM(op-entry.acct-cr)).
       end.
    end.
    vLnCountInt = vLnCountInt + 1.
END.


oTable1:addRow().
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(dItog).
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").




oTpl = new TTpl("pir-rasp-pct60.tpl").

/* oTpl:addAnchorValue("DATE",STRING(Day(op.op-date)) + " " + ENTRY(MONTH(op.op-date),months) + " " + STRING(Year(op.op-date))). */
oTpl:addAnchorValue("DATE", STRING(op.op-date,"99/99/9999") ).
oTpl:addAnchorValue("Table1",oTable1).
oTpl:addAnchorValue("Month",ENTRY(MONTH(op.op-date),monthss)).
oTpl:addAnchorValue("YEAR",Year(op.op-date)).  .
if bBal then oTpl:addAnchorValue("BAL/UNBAL","в балансе").
else oTpl:addAnchorValue("BAL/UNBAL","на внебалансовых счетах").



{setdest.i}
  oTpl:show().
{preview.i}
DELETE OBJECT oTpl.
delete object ofunc.



/***********************************************/
/*** #3081 ***/
{intrface.get count}
{pir-c2346u.i}

 vInspector = FGetSetting("PirEArch","RepInspCredit",?). /* #3718 */

DEF VAR oEra    AS TEra                        NO-UNDO.
DEF VAR oConfig AS TAArray                     NO-UNDO.
DEF VAR taxon   AS CHAR    INIT "doc" NO-UNDO.

oConfig = new TAArray().
oConfig:setH("taxon",taxon).
oConfig:setH("opdate",TEra:getDate(gend-date)).
oConfig:setH("num",iCurrOut).
oConfig:setH("expn",iCurrOut).
oConfig:setH("author",USERID("bisquit")).
oConfig:setH("inspector",vInspector).
oConfig:setH("fext","txt").

oEra = new TEra(TRUE).
IF oEra:askAndSave(oConfig,"_spool.tmp") > 0 THEN  
DO:
   FOR EACH tmprecid,
   FIRST op WHERE RECID(op) EQ tmprecid.id,
     EACH op-entry OF op 
   :
      /*** Помечаем документы как отправленные ***/
      UpdateSignsEx('opb',STRING(op.op),"PirA2346U",STRING(iCurrOut)).
      UpdateSignsEx('op-entry',STRING(op-entry.op) + "," + STRING(op-entry.op-entry) ,"PirDEVLink","1").
   END.
END.


DELETE OBJECT oEra.
DELETE OBJECT oConfig.
