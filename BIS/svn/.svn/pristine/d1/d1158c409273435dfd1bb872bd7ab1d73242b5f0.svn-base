{pirsavelog.p}

/* ------------------------------------------------------
     File: $RCSfile: pirexploanco.p,v $ $Revision: 1.2 $ $Date: 2007-10-18 07:42:23 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: ТЗ от 22.03.2006.
     Что делает: Производит экспорт данных в формате AFX для Мастера договоров.
     Как работает: Для выбранного в броузере договора собирает информацию, которую 
            определенным образом экспортирует в текстовый файл.
     Параметры: Полное имя файла экспорта.
     Место запуска: Броузер кредитных договоров.
     Автор: $Author: anisimov $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.1  2007/07/19 09:32:20  buryagin
     Изменения: *** empty log message ***
     Изменения:
------------------------------------------------------ */

/** Глобальные определения */
{globals.i}

/** Библиотека моих собственных функций */
{ulib.i}

/** Подключение возможности использовать информацию броузера */
{tmprecid.def}

{intrface.get strng}

/** Подпрограммы экспорта конструкций */
FUNCTION exp_agree RETURNS CHAR (
																	INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
																	INPUT arg3 AS CHAR,	INPUT arg4 AS CHAR,
																	INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
																	INPUT arg7 AS CHAR,	INPUT arg8 AS CHAR,
																	INPUT arg9 AS CHAR ).
			
			DEFINE VAR construction AS CHAR NO-UNDO.
			
			construction =                "<agreement>" + CHR(13) + CHR(10).
			construction = construction + "number=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "currency=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "open_date=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "summa=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "end_date=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "rate=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "firstpaypersdate=" + arg7 + CHR(13) + CHR(10).
			construction = construction + "persenttype=" + arg8 + CHR(13) + CHR(10).
			construction = construction + "persentendday=" + arg9 + CHR(13) + CHR(10).
			construction = construction + "</agreement>" + CHR(13) + CHR(10).
			
			RETURN construction.
			
END FUNCTION.

FUNCTION exp_corp RETURNS CHAR (
																	INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
																	INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
																	INPUT arg5 AS CHAR ).

			DEFINE VAR construction AS CHAR NO-UNDO.
			
			construction = 								"<corporation>" + CHR(13) + CHR(10).
			construction = construction + "name=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "inn=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "ogrn=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "address=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "acct=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "</corporation>" + CHR(13) + CHR(10).
			
			RETURN construction.

END FUNCTION.

FUNCTION exp_bos RETURNS CHAR (
																INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
																INPUT arg3 AS CHAR ).
			
			DEFINE VAR construction AS CHAR NO-UNDO.
			
			construction = 								"<bos>" + CHR(13) + CHR(10).
			construction = construction + "fio=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "post=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "order" + arg3 + CHR(13) + CHR(10).
			construction = construction + "</bos>" + CHR(13) + CHR(10).
			
			RETURN construction.
			
END FUNCTION.


/** Реализация */
/* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR.

/* Первый параметр */
DEF VAR out_file_name AS CHAR NO-UNDO. 
DEF VAR summa AS DECIMAL NO-UNDO. 
DEF VAR rate AS DECIMAL NO-UNDO.
DEF VAR rate_type AS CHAR NO-UNDO.
DEF VAR firstpayloandate AS DATE NO-UNDO.
DEF VAR firstpayratedate AS DATE NO-UNDO.

DEF VAR ogrn AS CHAR NO-UNDO.
DEF VAR account AS CHAR NO-UNDO.
DEF VAR address AS CHAR NO-UNDO.

DEF VAR fio AS CHAR NO-UNDO.
DEF VAR post AS CHAR NO-UNDO.


IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/buryagin/tmp/new_data.afx".
		
OUTPUT TO VALUE(out_file_name).

PUT UNFORMATTED StrToWin_ULL("<data>" + CHR(13) + CHR(10)).


FOR FIRST tmprecid 
         NO-LOCK,
   FIRST loan WHERE 
         RECID(loan) EQ tmprecid.id 
         NO-LOCK,
   FIRST loan-cond WHERE
   			 loan-cond.contract = loan.contract AND loan-cond.cont-code = loan.cont-code
   			 NO-LOCK
         
: 

	IF loan.cust-cat <> "Ю" THEN DO:
		MESSAGE "Договор не пренадлежит ЮЛ!" VIEW-AS ALERT-BOX.
		RETURN ERROR.
	END.
	
	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'КредРасч', loan.open-date, false).
	summa = ABS(GetLoanLimit_ULL(loan.contract, loan.cont-code, loan.open-date, false)).
	rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code, "%Кред", loan.open-date, false, rate_type).
	
	PUT UNFORMATTED StrToWin_ULL(exp_agree(
				loan.cont-code,
				(if loan.currency = "" then "810" else loan.currency), 
				STRING(loan.open-date,"99/99/9999"), 
				STRING(summa),
				STRING(loan.end-date,"99/99/9999"),
				STRING(rate),
				STRING(LastMonDate(loan.open-date), "99/99/9999"),
				loan-cond.int-period,
				STRING(loan-cond.int-date))).
				
	FIND FIRST cust-corp WHERE cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
	ogrn = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОГРН", "").
	address = DelDoubleChars(
    		(IF cust-corp.addr-of-low[1] <> cust-corp.addr-of-low[2] 
    		 THEN cust-corp.addr-of-low[1] + " " + addr-of-low[2] 
    		 ELSE cust-corp.addr-of-low[1]
    		),
    "," ).
    
  PUT UNFORMATTED StrToWin_ULL(exp_corp(
  			cust-corp.cust-stat + " " + cust-corp.name-corp,
  			cust-corp.inn,
  			ogrn,
  			address,
  			account)).
	
	fio =	GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ФИОрук", "").
	post = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ДолРук", "").
	
	PUT UNFORMATTED StrToWin_ULL(exp_bos(
				fio,
				"",
				"")).
					
END.

PUT UNFORMATTED StrToWin_ULL("</data>" + CHR(13) + CHR(10)).

OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
