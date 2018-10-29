
{globals.i}
{tmprecid.def}
{intrface.get date}
{intrface.get limit}    /*Инструменты для работы с лимитами*/
{intrface.get instrum}

{intrface.get strng}
{intrface.get card}

def input parameter iParam as char no-undo.
def var outfile as char no-undo.

def temp-table t-table NO-UNDO
         field mdate as date
         field rash as dec
	 field proc as dec
         field dolg as dec
	 field kom as dec 
	 field over as dec
   INDEX imdate as primary mdate.

   DEF BUFFER b-loan      FOR loan.
   DEF BUFFER bf-loan      FOR loan.
   
   DEF BUFFER loan-acct   FOR loan-acct.
   DEF BUFFER b-loan-acct FOR loan-acct.

def var  total_rash as dec NO-UNDO.
def var	 total_proc as dec NO-UNDO.
def var  total_dolg as dec NO-UNDO.
def var	 total_kom  as dec NO-UNDO.
def var	 total_over as dec NO-UNDO.

def var card-loan as char no-undo.
def var card-loan-open-date as date no-undo.

DEF VAR mLimit      AS DEC  NO-UNDO.  /* Максимальный кредитный лимит */
DEF VAR outLimit    AS DEC  NO-UNDO.  /*Лимит для вывода*/
DEF VAR mMeasure    AS CHAR NO-UNDO.
DEF VAR Rate        AS DEC  NO-UNDO.
def var commsumm    as DEC NO-UNDO.
def var vI as INT NO-UNDO.
def var CredPer as INT INIT 45 NO-UNDO.  /*пока так, надо будет сделать на получение с доп.река на договоре.*/
def var temp-end-date as date no-undo.
def var prev-temp-date as date no-undo.
def var cCur as CHAR NO-UNDO.	
def var oTpl as TTpl NO-UNDO.
def var dCurrDate as date no-undo.
def var base as int no-undo.
def var prevbase as int no-undo.
def var cName as char no-undo. /*имя владельца договора*/
def var RowCount as int INIT 0 NO-undo.
def var temp as char no-undo.
def var procent as dec init 0 no-undo.
def var startTable as int init 26 NO-UNDO. /*начало таблицы в эксел файле*/
dCurrDate = beg-date.

   DEF VAR vList-Code  AS CHAR NO-UNDO. /* Список операций */
   DEF VAR vList-Comm  AS CHAR NO-UNDO. /* Список комиссий */
      /* OUTPUT функции getCommCard */
   DEF VAR vCommCurr   AS CHAR NO-UNDO. /* Валюта комиссии */
   DEF VAR vValComm    AS DEC  NO-UNDO. /* Значение комиссии/тариф (сумма) */
   DEF VAR vValMinRate AS DEC  NO-UNDO. /* Значение мин.тарифа */
   DEF VAR vPlusRate   AS DEC  NO-UNDO. /* + тариф */
   DEF VAR vPeriodAdd  AS CHAR NO-UNDO. /* Периодичность начисления - М, КМ, М[n], Г, ПГ...*/
   DEF VAR vFixed      AS LOG  NO-UNDO. /* Фиксированная ставка */
   DEF VAR vPeriodDate AS CHAR NO-UNDO. /* Срок оплаты тарифа */
   DEF VAR vScheme     AS CHAR NO-UNDO. /* Схема начисления  */

FUNCTION ReplChars   RETURNS CHAR PRIVATE (INPUT iStr  AS CHAR) FORWARD.
FUNCTION ReplChars$ RETURNS CHAR PRIVATE (INPUT iStr  AS CHAR) FORWARD.


DEFINE VARIABLE cXL            AS CHARACTER NO-UNDO.

{pir_exf_exl.i}
if ENTRY(1,iParam) = "ЭПС" then 
do:
oTpl = new TTpl("pir-eps1335_eps.tpl").
startTable = 27.
temp = "eps".
end.
else
do:
   oTpl = new TTpl("pir-eps1335.tpl").
   startTable = 20.
temp = "uved".
end.
/**/

{getdates.i}

for each tmprecid,
    first loan where RECID(loan) = tmprecid.id NO-LOCK:
     if loan.currency = "840" then cCur = "USD".
     if loan.currency = "978" then cCur = "EUR".
     if loan.currency = ""    then cCur = "RUR".
/*end-date = loan.open-date.*/


     find first person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.

      if available (person) then 
         cName = person.name-last + " " + person.first-names.
      else
      do:
         message "Отчет работает только по договорам ПК физ.лиц" VIEW-AS ALERT-BOX.
         RETURN.
      end. 

     RowCount = 0.
     commsumm = 0.

     RUN get-one-limit-loan ("loan",                                 /*получили лимит выдачи*/
                              loan.contract + "," + loan.cont-code,
                             "limit-l-debts",
                              beg-date,
                              "",
                             OUTPUT mMeasure,
                             OUTPUT mLimit).

    outLimit = mLimit.
    find last comm-rate where comm-rate.kau = loan.contract + "," + loan.cont-code /*получили процентную ставку на момент выдачи договора (ожидается что отчет печатается в самом начале "жизни" договора)*/
			   and comm-rate.commission = "%Кред"
			   and comm-rate.since <= beg-date.
			   NO-LOCK NO-ERROR.
			   
    if AVAILABLE (comm-rate) then rate = comm-rate.rate-comm. else rate = 0.

    /*теперь осталось получить кол-во комиссии которые мы берем с клиента, как и в бисовой процедуре берем список из НП*/
    
    ASSIGN 
      vList-Code = FGetSetting("ЭПС", "ЭПСКартПр" , ?)
      vList-Comm = FGetSetting("ЭПС", "ЭПСКартКом", ?)
     .
      if dCurrDate < loan.open-date then 
	do:
	   dCurrDate = loan.open-date.
	   message "Период расчета должен быть не раньше даты начала договора!!!" SKIP
		   "Начало периода скорректировано на " loan.open-date VIEW-AS ALERT-BOX.
	end.


      FIND LAST loan-acct WHERE 
                loan-acct.acct-type EQ "КредРасч"
         AND    loan-acct.cont-code EQ loan.cont-code
         AND    loan-acct.contract  EQ loan.contract
         AND    loan-acct.since     <= dCurrDate
      NO-LOCK.

      IF AVAIL loan-acct THEN
      DO:
            /* Получаем привязки этого счета к карточному договору с ролью SCS@<Валюта> */
         FIND LAST b-loan-acct WHERE
                   b-loan-acct.acct      EQ loan-acct.acct
            AND    b-loan-acct.acct-type BEGINS "SCS@"
            AND    b-loan-acct.since     LE dCurrDate
         NO-LOCK NO-ERROR.
         IF AVAIL b-loan-acct THEN
         DO:
               /* Находим по счету карточный договор */

	    if not avail b-loan-acct then message "не найден карточный договор, возможны ошибки" VIEW-AS ALERT-BOX.
            FIND FIRST b-loan WHERE
                       b-loan.cont-code EQ b-loan-acct.cont-code
               AND     b-loan.contract  EQ b-loan-acct.contract
            NO-LOCK.
/*            message b-loan-acct.acct b-loan.cont-code view-as alert-box.*/
	    if not avail b-loan then message "не найден карточный договор, возможны ошибки" VIEW-AS ALERT-BOX.
            IF AVAIL b-loan THEN
            do:
                    card-loan = b-loan.cont-code.
		    card-loan-open-date = b-loan.open-date.
                    FOR EACH bf-loan WHERE
                        bf-loan.parent-cont-code EQ b-loan.cont-code
                  AND   bf-loan.parent-contract  EQ b-loan.contract 
		  AND   bf-loan.loan-status = "АКТ"
               NO-LOCK:

      DO vI = 1 TO NUM-ENTRIES(vList-code):
                        RUN getCommCard (bf-loan.contract,         /* Назначение */
                                         bf-loan.cont-code,        /* Номер карты */
                                         ENTRY(vI, vList-comm), /* Код типового условия */ 
                                         dCurrDate,             /* На дату */
                                         OUTPUT vCommCurr,      /* Валюта комиссии */
                                         OUTPUT vValComm,       /* Значение комиссии/тариф (сумма) */
                                         OUTPUT vValMinRate,    /* Значение мин.тарифа */
                                         OUTPUT vPlusRate,      /* + тариф */
                                         OUTPUT vPeriodAdd,     /* Периодичность начисления - М, КМ, М[n], Г, ПГ...*/
                                         OUTPUT vFixed,         /* Фиксированная ставка */
                                         OUTPUT vPeriodDate,    /* Срок оплаты тарифа */
                                         OUTPUT vScheme).       /* Схема начисления  */
                           /* Сравниваем валюту карточного договора с валютой договора */
/*                        IF vCommCurr NE bf-loan.Currency THEN
                           /* Переводим найденную комисию в валюту кредитного договора на дату рассчета */
                           vValComm = CurToCur ("Учетный",       /* Тип курса  */
                                                vCommCurr,       /* Код валюты1 */
                                                bf-loan.Currency,       /* Код валюты2 */
                                                loan.open-date,  /* Дата */
                                                vValComm).       /* Что надо перевести */*/
                        commsumm = commsumm + vValComm.
	/* message bf-loan.contract bf-loan.cont-code vValComm vList-comm View-AS ALERT-BOX.*/
      END.
      end.
      end.
     end.
     end.

     /*вроде все данные получили. теперь можно создавать виртуальный график платежей для расчета ЕПС. для удобства сохраним его в таблицу*/

   if mLimit = 0 then message "Лимит по договору равен 0! ОШИБКА!" VIEW-AS ALERT-BOX.

/*ВОТ ЗДЕСЬ САМОЕ ИНТЕРЕСНОЕ, СТРОИМ ПСЕВДОГРАФИК*/
     temp-end-date = beg-date.
                
     CREATE t-table.
     ASSIGN
         t-table.mdate = temp-end-date
         t-table.rash = (-1) * (mLimit) + commsumm    /*Ожидал что что функция NEG есть/существует/работает, но нет...*/
	 t-table.proc = 0
         t-table.dolg = 0
	 t-table.kom = commsumm
	 t-table.over = (-1) * (mLimit).

   Base = (IF TRUNCATE(YEAR(temp-end-date) / 4,0) = YEAR(temp-end-date) / 4 THEN 366 ELSE 365).
     REPEAT WHILE end-date <> temp-end-date:

            prev-temp-date = temp-end-date.
            temp-end-date = temp-end-date + CredPer.
            if {holiday.i temp-end-date} then temp-end-date = NextWorkDay(temp-end-date).
            if temp-end-date >= end-date then temp-end-date = end-date.

            procent = 0.

            if base <> (IF TRUNCATE(YEAR(temp-end-date) / 4,0) = YEAR(temp-end-date) / 4 THEN 366 ELSE 365)
		THEN 
		do:
		   prevbase = base.                                                                                                  
		   procent = ROUND((mLimit * (DATE(12,31,YEAR(prev-temp-date)) - prev-temp-date) * (Rate / 100)/ PrevBase) + (mLimit * (temp-end-date - DATE(01,01,YEAR(temp-end-date))) * (Rate / 100)/ Base),2).        	
		   Base = (IF TRUNCATE(YEAR(temp-end-date) / 4,0) = YEAR(temp-end-date) / 4 THEN 366 ELSE 365).
		end.
	    else 
		do:
		   Base = (IF TRUNCATE(YEAR(temp-end-date) / 4,0) = YEAR(temp-end-date) / 4 THEN 366 ELSE 365).

		   procent = ROUND((mLimit * (temp-end-date - prev-temp-date) * (Rate / 100)/ Base),2).
		end.

/*		   message procent mLimit (temp-end-date - prev-temp-date) Rate Base VIEW-AS ALERT-BOX.*/
            
            CREATE t-table.
            ASSIGN
                   t-table.mdate = temp-end-date
                   t-table.rash  = mLimit + procent
                   t-table.proc  = procent
/*                   t-table.proc  = ROUND((mLimit * (temp-end-date - prev-temp-date) * (Rate / 100) / Base ),2)*/
                   t-table.dolg  = mLimit
                   t-table.kom   = 0
                   t-table.over  = 0.


            temp-end-date = NextWorkDay(temp-end-date).
            if temp-end-date > end-date then temp-end-date = end-date.
            if temp-end-date = end-date then mLimit = 0.

            if temp-end-date < end-date then do:
            CREATE t-table.
            ASSIGN
                   t-table.mdate = temp-end-date
                   t-table.rash  = (-1) * (mLimit)
              	   t-table.proc  = 0
                   t-table.dolg  = 0
                   t-table.kom   = 0
                   t-table.over  = (-1) * (mLimit).
            end.

           if temp-end-date > end-date then LEAVE.

    end.

/*псевдографик построили, выводим все в чудо EXCEL :( */
outfile = ("/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/" + REPLACE(ReplChars$(ReplChars(GetMangledName(REPLACE(loan.cont-code,"$",CHR(1))))) ,CHR(1) ,"$" ) + "-" + temp  + ".xls").

/*outfile = (REPLACE(ReplChars$(ReplChars(GetMangledName(REPLACE(loan.cont-code,"$",CHR(1))))) ,CHR(1) ,"$" ) + ".xls").*/


OUTPUT TO VALUE(outfile) CONVERT TARGET "UTF-8".
  
total_rash = 0.
total_proc = 0.
total_dolg = 0.
total_kom  = 0.
total_over = 0.


for each t-table BY mdate:
rowcount = rowcount + 1.
cXL = cXl + XLRow(0) + XLDateCellInFormat(t-table.mdate,"s56") + XLNumECellInFormat(t-table.rash,"s66") + XLNumECellInFormat(t-table.proc,"s66")  + XLNumECellInFormat(t-table.dolg,"s66") + XLNumECellInFormat(t-table.kom,"s66") + XLNumECellInFormat(t-table.over,"s66") + XLRowEnd(). 

total_rash = total_rash + t-table.rash.
total_proc = total_proc + t-table.proc.
total_dolg = total_dolg + t-table.dolg.
total_kom  = total_kom  + t-table.kom.
total_over = total_over + t-table.over.

end.
rowcount = rowcount + 1.

oTpl:AddAnchorValue("DataSogl",GetXAttrValueEx("loan",loan.contract + "," + loan.cont-code,"ДатаСогл",STRING(loan.open-date))).


oTpl:AddAnchorValue("TABLE",cXl).
oTpl:AddAnchorValue("cName",cName).
oTpl:AddAnchorValue("RowCountItog",RowCount - 1).
oTpl:AddAnchorValue("RowCount",RowCount + 2).
oTpl:AddAnchorValue("INDEX-EPS",startTable + RowCount + 2).
oTpl:AddAnchorValue("INDEX-END",startTable + RowCount + 4).
oTpl:AddAnchorValue("Index-SIGN1",startTable + RowCount + 22).
oTpl:AddAnchorValue("Index-SIGN2",startTable + RowCount + 24).
 oTpl:AddAnchorValue("Index-SIGN3",startTable + RowCount + 26).
oTpl:AddAnchorValue("Index-SIGN4",startTable + RowCount + 28).
oTpl:AddAnchorValue("Podpis1",Entry(2,iParam)).
oTpl:AddAnchorValue("Podpis2",Entry(3,iParam)).
oTpl:AddAnchorValue("Podpis1",startTable + RowCount + 28).
oTpl:AddAnchorValue("Index-SIGN4",startTable + RowCount + 28).


oTpl:AddAnchorValue("loan.cont-code",loan.cont-code).
oTpl:AddAnchorValue("card-loan",card-loan).
oTpl:AddAnchorValue("card-loan.open-date",card-loan-open-date).
oTpl:AddAnchorValue("mlimit",TRIM(STRING(outlimit,">>>>>>>>>>>9.99"))).
oTpl:AddAnchorValue("Cur",cCur).
oTpl:AddAnchorValue("loan.open-date",beg-date).
oTpl:AddAnchorValue("loan.end-date",end-date).
oTpl:AddAnchorValue("CredPer",CredPer).
oTpl:AddAnchorValue("Rate",STRING(Rate) + " % годовых").
oTpl:AddAnchorValue("Com1",TRIM(STRING(Commsumm,">>>>>>>>>>>9.99"))).
oTpl:AddAnchorValue("Com3",0).


/*{setdest.i}*/

oTpl:show().

/*{preview.i}    */

/*закончили с выводом. вывод в EXCEL - Это ад...*/



MESSAGE "Расчет сохранен в " SKIP outfile VIEW-AS ALERT-BOX.

end.



/*ФУНКЦИИ В НАГЛУЮ ВЗЯЛ У БИСа*/

   /* ==========================================-=-==
   ** Замена неподходящих для имени файла символов */
FUNCTION ReplChars RETURNS CHAR PRIVATE
  (INPUT iStr AS CHAR).
   DEF VAR vCharList1 AS CHAR NO-UNDO EXTENT 3 INIT [" ","-","/"].
   DEF VAR vCharList2 AS CHAR NO-UNDO INIT "_".
   DEF VAR vI         AS INT64  NO-UNDO.
   DO vI = 1 TO EXTENT(vCharList1):
      iStr = REPLACE(iStr, vCharList1[vI], vCharList2).
   END.
   RETURN iStr.
END FUNCTION.
FUNCTION ReplChars$ RETURNS CHAR PRIVATE
  (INPUT iStr AS CHAR).
   DEF VAR vCharList1 AS CHAR NO-UNDO INIT "$".
   DEF VAR vCharList2 AS CHAR NO-UNDO INIT "".
      iStr = REPLACE(iStr, vCharList1, vCharList2).
   RETURN iStr.
END FUNCTION.


   /* =====================================-=-==
   ** Замена символов в суммах                */
FUNCTION AmntToStrng RETURNS CHAR PRIVATE
  (INPUT iAmnt AS DEC).
   DEF VAR vReplChar AS CHAR NO-UNDO.
   DEF VAR vAmnt     AS CHAR NO-UNDO.
   ASSIGN
      vAmnt     = STRING(iAmnt, "->>>>>>>>>>>>>>9.99")
      vReplChar = FGetSetting("ЭПС", "СимвРаздДес", ".")   /* Разделитель целой и дробной части для выгрузки в Excel */
      vAmnt     = IF vReplChar NE "." THEN REPLACE(vAmnt, ".", vReplChar) ELSE vAmnt
   .
   RETURN vAmnt.
END FUNCTION.

DELETE OBJECT oTPL.
{intrface.del}