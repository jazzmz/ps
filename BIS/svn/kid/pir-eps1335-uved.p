
{globals.i}
/*{getdate.i}*/
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



def var  total_rash as dec NO-UNDO.
def var	 total_proc as dec NO-UNDO.
def var  total_dolg as dec NO-UNDO.
def var	 total_kom  as dec NO-UNDO.
def var	 total_over as dec NO-UNDO.




DEF VAR outLimit    AS DEC  NO-UNDO.  /*Лимит для вывода*/
DEF VAR mMeasure    AS CHAR NO-UNDO.

def var commsumm    as DEC NO-UNDO.
def var vI as INT NO-UNDO.

def var temp-end-date as date no-undo.
def var prev-temp-date as date no-undo.

def var oTpl as TTpl NO-UNDO.
def var base as int no-undo.
def var prevbase as int no-undo.
def var procent as dec no-undo.

def var cName as char no-undo. /*имя владельца договора*/
def var RowCount as int INIT 0 NO-undo.
def var temp as char no-undo.
def var startTable as int init 26 NO-UNDO. /*начало таблицы в эксел файле*/


FUNCTION ReplChars   RETURNS CHAR PRIVATE (INPUT iStr  AS CHAR) FORWARD.
FUNCTION ReplChars$ RETURNS CHAR PRIVATE (INPUT iStr  AS CHAR) FORWARD.

def var dCurrDate as date no-undo.

DEF VAR mLimit      AS DEC  NO-UNDO.  /* Максимальный кредитный лимит */
def var cCur as CHAR NO-UNDO.	
def var dbeg-date as date no-undo.
def var dend-date as date no-undo.
def var CredPer as INT INIT 45 NO-UNDO.  /*пока так, надо будет сделать на получение с доп.река на договоре.*/
DEF VAR Rate        AS DEC  NO-UNDO.
DEF VAR comm1       AS DEC  NO-UNDO.
DEF VAR comm2       AS DEC  NO-UNDO.






DEFINE VARIABLE cXL            AS CHARACTER NO-UNDO.

{pir_exf_exl.i}

   oTpl = new TTpl("pir-eps1335.tpl").
   startTable = 20.

   temp = "uved".

/**/

for each tmprecid,
    first person where RECID(person) = tmprecid.id NO-LOCK:

UPDATE mLimit LABEL "1.Максимальный лимит овердрафта" FORMAT "->>>,>>>,>>>,>>9.99" SKIP
       cCur LABEL "2.Валюта овердрафта и процентов" FORMAT "x(3)" SKIP
       dBeg-date LABEL "С" dEnd-date LABEL "По" SKIP
       CredPer LABEL "5.Максимальный срок каждого кредита (в днях)" SKIP
       Rate LABEL "6.Процентная ставка"	SKIP
       comm1 LABEL "7.Плата за выпуск пластиковой карты"	SKIP
       comm2 LABEL "8.Комиссии за расчетное и операционное обслуживание"	SKIP
       WITH FRAME frmTmp CENTERED SIDE-LABELS OVERLAY.

         cName = person.name-last + " " + person.first-names.

     RowCount = 0.
     commsumm = 0.


    outLimit = mLimit.
     commsumm = comm1 + comm2.

/*ВОТ ЗДЕСЬ САМОЕ ИНТЕРЕСНОЕ, СТРОИМ ПСЕВДОГРАФИК*/
     temp-end-date = dBeg-date.
                
     CREATE t-table.
     ASSIGN
         t-table.mdate = temp-end-date
         t-table.rash = (-1) * (mLimit) + commsumm    /*Ожидал что что функция NEG есть/существует/работает, но нет...*/
	 t-table.proc = 0
         t-table.dolg = 0
	 t-table.kom = commsumm
	 t-table.over = (-1) * (mLimit).

          prev-temp-date = temp-end-date.

     Base = (IF TRUNCATE(YEAR(temp-end-date) / 4,0) = YEAR(temp-end-date) / 4 THEN 366 ELSE 365).

     REPEAT WHILE dEnd-date <> temp-end-date:

            prev-temp-date = temp-end-date.
            temp-end-date = temp-end-date + CredPer.
            if {holiday.i temp-end-date} then temp-end-date = NextWorkDay(temp-end-date).
            if temp-end-date >= dEnd-date then temp-end-date = dEnd-date.
      
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


            
            CREATE t-table.
            ASSIGN
                   t-table.mdate = temp-end-date
                   t-table.rash  = mLimit + procent
                   t-table.proc  = procent
                   t-table.dolg  = mLimit
                   t-table.kom   = 0
                   t-table.over  = 0.



            temp-end-date = NextWorkDay(temp-end-date).
            if temp-end-date > dEnd-date then temp-end-date = dEnd-date.
            if temp-end-date = dEnd-date then mLimit = 0.


            if temp-end-date < dend-date then do:
                
            CREATE t-table.
            ASSIGN
                   t-table.mdate = temp-end-date
                   t-table.rash  = (-1) * (mLimit)
              	   t-table.proc  = 0
                   t-table.dolg  = 0
                   t-table.kom   = 0
                   t-table.over  = (-1) * (mLimit).
           end. 
           if temp-end-date > dEnd-date then LEAVE.

    end.

/*псевдографик построили, выводим все в чудо EXCEL :( */

outfile = ("/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/" + REPLACE(ReplChars$(ReplChars(GetMangledName(REPLACE(STRING(dbeg-date),"$",CHR(1))))) ,CHR(1) ,"$" ) + "-" + temp  + ".xls").

/*outfile = (REPLACE(ReplChars$(ReplChars(GetMangledName(REPLACE(STRING(dbeg-date),"$",CHR(1))))) ,CHR(1) ,"$" ) + ".xls").*/


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


oTpl:AddAnchorValue("TABLE",cXl).
oTpl:AddAnchorValue("cName",cName).
oTpl:AddAnchorValue("RowCountItog",RowCount - 1).
oTpl:AddAnchorValue("RowCount",RowCount + 2).
oTpl:AddAnchorValue("INDEX-EPS",startTable + RowCount + 2).
oTpl:AddAnchorValue("INDEX-END",startTable + RowCount + 4).
oTpl:AddAnchorValue("Index-SIGN-1",startTable + RowCount + 22).
oTpl:AddAnchorValue("Index-SIGN1",startTable + RowCount + 23).
oTpl:AddAnchorValue("Index-SIGN2",startTable + RowCount + 25).
oTpl:AddAnchorValue("Index-SIGN3",startTable + RowCount + 27).
oTpl:AddAnchorValue("Index-SIGN4",startTable + RowCount + 29).

oTpl:AddAnchorValue("mlimit",TRIM(STRING(outlimit,">>>>>>>>>>>9.99"))).
oTpl:AddAnchorValue("Cur",cCur).
oTpl:AddAnchorValue("loan.open-date",dBeg-date).
oTpl:AddAnchorValue("loan.end-date",dEnd-date).
oTpl:AddAnchorValue("CredPer",CredPer).
oTpl:AddAnchorValue("Rate",STRING(Rate) + " % годовых").
oTpl:AddAnchorValue("Com1",TRIM(STRING(Comm1,">>>>>>>>>>>9.99"))).
oTpl:AddAnchorValue("Com3",TRIM(STRING(Comm2,">>>>>>>>>>>9.99"))).


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