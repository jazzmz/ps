{pirsavelog.p}

/**
	Процедура подготовки документов к вводу функционала по работе со счетами-фактурами.
	Процедура должна найти все "первые" документы по договорам аренды ИБС, заполнить их 
	доп.реквизиты соответствующими значениями. 
	
	Бурягин Е.П., 20.12.2006 14:02
*/

{globals.i}
{tmprecid.def}        /** Используем информацию из броузера */

DEF VAR tmpstr AS CHAR.
DEF VAR sfnumber AS CHAR LABEL "Номер СФ" FORMAT "x(6)".
DEF VAR sfdate AS DATE LABEL "Дата СФ" FORMAT "99/99/9999".
def var sfinfo AS CHAR LABEL "PISSFInfo" FORMAT "x(60)".
def var sfdetails AS CHAR LABEL "PIRSFDetails" FORMAT "x(60)".
def var sfprolong AS LOGICAL LABEL "Пролонгирован?" FORMAT "Да/Нет".
def var sfamount AS DECIMAL LABEL "PIRSFAmount" FORMAT ">>>,>>>,>>9.99".
def var safeperiod AS INT LABEL "Период аренды (мес.)".
def var result as char extent 4.
def var i as int.

def buffer b-op-entry for op-entry.

PAUSE 0.

/** Для каждого выбранной записи договора, найдем договор, последнее условие договора и счет с ролью */
FOR EACH tmprecid NO-LOCK,
    FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK,
    LAST loan-cond WHERE loan-cond.contract = loan.contract AND loan-cond.cont-code = loan.cont-code NO-LOCK,
    FIRST loan-acct OF loan WHERE acct-type = "ДепСейфППП1" NO-LOCK
  :
    /** Теперь найдем первую проводку по кредиту данного счета */ 
    FIND LAST op-entry WHERE 
    		op-entry.acct-db = loan-acct.acct 
    		AND 
    		op-entry.acct-cr BEGINS "61304"
				NO-LOCK.
				
    FIND FIRST op WHERE op.op = op-entry.op NO-LOCK.
    
    /** Значения доп.рекв. op.PIRSFNumber */
    tmpstr = GetXAttrValueEx("op", STRING(op.op), "PIRSFNumber", "").
    if num-entries(tmpstr) = 2 then do: 
    	sfnumber = ENTRY(1,tmpstr).
    	sfdate = DATE(ENTRY(2,tmpstr)).
    end. 
    else 
    do:
    	sfnumber = "".
    	sfdate = op.doc-date.
    end.	
    
    /** Значение доп.рекв. op.PIRSFInfo */
    sfinfo = GetXAttrValueEx("op", STRING(op.op), "PIRSFInfo", "").
    if (sfinfo = "") then sfinfo = "sf-out,а/о,оплата,1," + loan.contract + "." + loan.cont-code.
    
    /** Значение доп.рекв. loan.SafePeriod */
    SafePeriod = INT(GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "SafePeriod", "1")).
    
    /** Значение доп.рекв. op.PIRSFDetails */
    sfdetails = GetXAttrValueEx("op", STRING(op.op), "PIRSFDetails", "").
    if (sfdetails = "") then 
       sfdetails = "Аренда сейфа Дог. №" + loan.cont-code + " от " + STRING(loan.open-date,"99/99/9999") 
       + ",10000001," + STRING(SafePeriod - 1).
    
    /** Значение доп.рекв. op.PIRSFAmount */
    sfamount = DEC(GetXAttrValueEx("op", STRING(op.op), "PIRSFAmount", "0")).
    /** Если сумма равна 0, то найдем проводку 408* - loan-acct.acct */
    if (sfamount = 0) then do:
    		find last b-op-entry where b-op-entry.acct-cr = loan-acct.acct and b-op-entry.acct-db begins "408" NO-LOCK no-error.
    		if avail b-op-entry then sfamount = b-op-entry.amt-rub.
    end.
    	
    
    if loan.open-date NE loan-cond.since then sfprolong = true. else sfprolong = false.
    
    DISPLAY "---------------------------- Договор ---------------------------" SKIP
            loan.cont-code SKIP loan.open-date FORMAT "99/99/9999" SKIP sfprolong SKIP
            "---------------------------- Документ --------------------------" SKIP
            op.doc-num op.doc-date LABEL "От" FORMAT "99/99/9999" SKIP
            op.details VIEW-AS EDITOR SIZE 40 BY 4 SKIP
            "----------------------- Доп.рекв. документа --------------------" SKIP
            sfnumber SKIP sfdate SKIP 
            sfinfo SKIP
            sfdetails SKIP
            sfamount SKIP
                        
            WITH FRAME ff SIDE-LABELS CENTERED OVERLAY TITLE "Начальное решение по СФ-ИБС".
    
    UPDATE sfnumber sfdate sfinfo sfdetails sfamount WITH FRAME ff.
    
    /** Заполнение таблицы результатов. Формат: <код_доп_рек>,<значение> */
    
    result[1] = "PIRSFAmount;" + STRING(sfamount).
    result[2] = "PIRSFDetails;" + sfdetails.
    result[3] = "PIRSFInfo;" + sfinfo.
    result[4] = "PIRSFNumber;" + sfnumber + "," + STRING(sfdate,"99/99/9999").
    
    
    /** Создание или изменение дополнительных реквизитов документа */
    /** PIRSFNumber */
    
    DO i = 1 TO 4 :
    		
    		find first signs where 
    				file-name = "op"
    				and
    				surrogate = string(op.op)
    				and 
    				code = ENTRY(1, result[i], ";")
    				NO-ERROR.
    		if avail signs then 
    		  if i = 1 then 
    		    signs.code-value = ENTRY(2, result[i], ";").
    		  else
    				signs.xattr-value = ENTRY(2, result[i], ";").
    		else do:
    		  create signs.
    		  assign
    		  			 signs.file-name = "op"
    		  			 signs.surrogate = STRING(op.op)
    		  			 signs.code = ENTRY(1, result[i], ";").
    		  if i = 1 then 
    		    signs.code-value = ENTRY(2, result[i], ";").
    		  else
    		    signs.xattr-value = ENTRY(2, result[i], ";").
    		end.
    END.
    
    HIDE FRAME ff.
END.