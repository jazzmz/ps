{pirsavelog.p}

{globals.i}		/** Глобальные определения */
{ulib.i}			/** Библиотека моих собственных функций */
{tmprecid.def}		/** Подключение возможности использовать информацию броузера */

{intrface.get strng}

/** Подпрограммы экспорта конструкций */
FUNCTION exp_agree RETURNS CHAR (
				INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
				INPUT arg3 AS CHAR,	INPUT arg4 AS CHAR,
				INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
				INPUT arg7 AS CHAR, INPUT arg8 AS CHAR ).
			
			DEFINE VAR construction AS CHAR NO-UNDO.
			
			construction =                "<plagreement>" + CHR(13) + CHR(10).
			/** replace нужен для замены русской С на латинскую С (спасибо Пластиководам ;) */
			construction = construction + "number=" + REPLACE(arg1, "С", "C") + CHR(13) + CHR(10).
			construction = construction + "date=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "accountmain=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "accountcurusdmain=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "accountcureurmain=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "accountminpos=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "card=" + arg7 + CHR(13) + CHR(10).
			construction = construction + "currency=" + arg8 + CHR(13) + CHR(10).
			construction = construction + "</plagreement>" + CHR(13) + CHR(10).
			
			RETURN construction.
			
END FUNCTION.

FUNCTION exp_client RETURNS CHAR (
				INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
				INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
				INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
				INPUT arg7 AS CHAR, INPUT arg8 AS CHAR,
				INPUT arg9 AS CHAR, INPUT arg10 AS CHAR,
				INPUT arg11 AS CHAR, INPUT arg12 AS CHAR,
				INPUT arg13 AS CHAR, INPUT arg14 AS CHAR 
				).
			
			DEFINE VAR construction AS CHAR NO-UNDO.
			
		construction = "<client>" + CHR(13) + CHR(10).
			construction = construction + "corpname=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "corpshortname=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "corpdelegate=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "corpdocdelegate=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "corpaddrfact=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "corpaddrur=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "corpaddrpost=" + arg7 + CHR(13) + CHR(10).
			construction = construction + "corptel=" + arg8 + CHR(13) + CHR(10).
			construction = construction + "corpcertifreg=" + arg9 + CHR(13) + CHR(10).
			construction = construction + "corpinn=" + arg10 + CHR(13) + CHR(10).
			construction = construction + "corpkpp=" + arg11 + CHR(13) + CHR(10).
			construction = construction + "corpogrn=" + arg12 + CHR(13) + CHR(10).
			construction = construction + "corpokpo=" + arg13 + CHR(13) + CHR(10).
			construction = construction + "corpokonx=" + arg14 + CHR(13) + CHR(10).
		construction = construction + "</client>" + CHR(13) + CHR(10).
			
			RETURN construction.
																					
END FUNCTION.

/** Реализация */
/* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR.

/* Первый параметр */
DEF VAR out_file_name AS CHAR NO-UNDO. 
DEF VAR account AS CHAR NO-UNDO.
DEF VAR account_usd AS CHAR NO-UNDO.
DEF VAR account_eur AS CHAR NO-UNDO.
DEF VAR account_minpos AS CHAR NO-UNDO.

DEF BUFFER card FOR loan.

IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/sitov/tmp/new_data.afx".
		
OUTPUT TO VALUE(out_file_name).

PUT UNFORMATTED StrToWin_ULL("<data>" + CHR(13) + CHR(10)).


FOR FIRST tmprecid 
         NO-LOCK,
   FIRST loan WHERE 
         RECID(loan) EQ tmprecid.id 
         NO-LOCK,
   FIRST card WHERE card.contract = "card"
                AND card.parent-contract = loan.contract
                AND card.parent-cont-code = loan.cont-code
                AND card.loan-work = YES
                AND CAN-DO("АКТ,ЗВЛ,ИЗГ",card.loan-status)
                AND card.close-date = ?
                NO-LOCK 
: 

	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@', loan.open-date, false).
	account_usd = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@840', loan.open-date, false).
	account_eur = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@978', loan.open-date, false).
	account_minpos = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SGP@' + loan.currency, loan.open-date, false).
	
	PUT UNFORMATTED StrToWin_ULL(exp_agree(
				loan.cont-code,
				STRING(loan.open-date,"99/99/9999"), 
				account, account_usd, account_eur, account_minpos,
				card.doc-num,
				loan.currency
				)).
		

	/* Информация по клиенту */
	IF loan.cust-cat = "Ю" THEN
		DO:
			FIND FIRST cust-corp WHERE
				cust-corp.cust-id = loan.cust-id
				NO-LOCK NO-ERROR.
			IF AVAIL cust-corp THEN
				DO:

					PUT UNFORMATTED StrToWin_ULL(exp_client(
						  	replace(GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false), CHR(34),"``")  ,
							replace(cust-corp.name-short,chr(34),"``")  ,		/*  GetClientName ("Ч" , cust-corp.cust-stat , cust-corp.name-corp , "short")  , */ 
							GetXAttrValueEx("cust-corp" , string(cust-corp.cust-id) , "ФИОрук" , " ")  ,
							" "  ,
							cust-corp.addr-of-low[1]   , 		/* GetStructAddr("Ч" , cust-corp.addr-of-low[1] , cust-corp.addr-of-low[2] , "АдрФакт" ) */
							GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_address", false) ,
							cust-corp.addr-of-post[1]  ,  	/* GetStructAddr("Ч" , cust-corp.addr-of-low[1] , cust-corp.addr-of-low[2] , "АдрПочт" ) */
						  	GetXAttrValueEx("cust-corp" , string(cust-corp.cust-id) , "tel" , " ")  ,
							GetXAttrValueEx("cust-corp" , string(cust-corp.cust-id) , "УчДокГр" , " ")  ,
							cust-corp.inn , 
							GetXAttrValueEx("cust-corp" , string(cust-corp.cust-id) , "КПП" , " ")  ,
							GetXAttrValueEx("cust-corp" , string(cust-corp.cust-id) , "ОГРН" , " ") ,
							cust-corp.okpo ,		
							GetXAttrValueEx("cust-corp" , string(cust-corp.cust-id) , "ОКОНХ" , " ") 						
						)
					).
				END.
		END.
	ELSE
		DO:
			MESSAGE "Счет не принадлежит юридическому лицу!" VIEW-AS ALERT-BOX.
			RETURN.
		END.


END.

PUT UNFORMATTED StrToWin_ULL("</data>" + CHR(13) + CHR(10)).

OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
