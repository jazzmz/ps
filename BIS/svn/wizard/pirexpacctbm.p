/* ------------------------------------------------------
     File: $RCSfile: pirexpacctbm.p,v $ $Revision: 1.2 $ $Date: 2009-12-01 14:56:10 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: 
     Что делает: Производит экспорт данных в формате AFX о договоре открытия счета для ИП
     Как работает: Для одного выбранного в броузере "Лицевые счета" счета собирает данные и экспортирует их в файл.
     Параметры: Полный путь к файлу, в который экспортируются данные
     Место запуска: Броузер лицевых счетов.
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.1  2007/12/19 14:33:22  buryagin
     Изменения: no message
     Изменения:
------------------------------------------------------ */

{globals.i}

/** Мои процедурки */
{ulib.i}

/** Используем информацию из броузера */
{tmprecid.def}

{intrface.get strng}
{intrface.get xclass}

/** Подпрограммы для подготовки данных в формате экспорта */
FUNCTION exp_agree RETURNS CHAR (INPUT arg1 AS CHAR,
                                 INPUT arg2 AS CHAR).
	
	DEF VAR contruction AS CHAR NO-UNDO.
	contruction = "<agreement>" + CHR(13) + CHR(10).
	contruction = contruction + "no=" + arg1 + CHR(13) + CHR(10).
	contruction = contruction + "date=" + arg2 + CHR(13) + CHR(10).
	contruction = contruction + "</agreement>" + CHR(13) + CHR(10).
	
	RETURN contruction.
	
END FUNCTION.

FUNCTION exp_acct RETURNS CHAR (INPUT arg1 AS CHAR,
                                INPUT arg2 AS CHAR).

	DEF VAR contruction AS CHAR NO-UNDO.
	contruction = "<acct>" + CHR(13) + CHR(10).
	contruction = contruction + "no=" + arg1 + CHR(13) + CHR(10).
	contruction = contruction + "cur=" + arg2 + CHR(13) + CHR(10).
	contruction = contruction + "</acct>" + CHR(13) + CHR(10).
	
	RETURN contruction.
	
END FUNCTION.

FUNCTION exp_client RETURNS CHAR (INPUT arg1 AS CHAR,
                                  INPUT arg2 AS CHAR,
                                  INPUT arg3 AS CHAR,
                                  INPUT arg4 AS CHAR,
                                  INPUT arg5 AS CHAR,
                                  INPUT arg6 AS CHAR,
                                  INPUT arg7 AS CHAR,
                                  INPUT arg8 AS CHAR,
                                  INPUT arg9 AS CHAR).
	DEF VAR contruction AS CHAR NO-UNDO.
	contruction = "<client>" + CHR(13) + CHR(10).
	contruction = contruction + "name=" + arg1 + CHR(13) + CHR(10).
	contruction = contruction + "fio=" + arg2 + CHR(13) + CHR(10).
	contruction = contruction + "address=" + arg3 + CHR(13) + CHR(10).
	contruction = contruction + "document=" + arg4 + CHR(13) + CHR(10).
	contruction = contruction + "phone=" + arg5 + CHR(13) + CHR(10).
	contruction = contruction + "birthday=" + arg6 + CHR(13) + CHR(10).
	contruction = contruction + "inn=" + arg7 + CHR(13) + CHR(10).
	contruction = contruction + "ogrn=" + arg8 + CHR(13) + CHR(10).
	contruction = contruction + "address2=" + arg9 + CHR(13) + CHR(10).
	contruction = contruction + "</client>" + CHR(13) + CHR(10).
	
	RETURN contruction.

END FUNCTION.                                  

/** Реализация */

DEF INPUT PARAM iParam AS CHAR.

DEF VAR out_file_name AS CHAR NO-UNDO.
DEF VAR tmpStr AS CHAR NO-UNDO.
DEF VAR success AS LOGICAL INIT false NO-UNDO.

IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE DO:
	MESSAGE "ОШИБКА! В параметре запуска процедуры не задан файл для экспорта!" VIEW-AS ALERT-BOX.
	RETURN.
END.



/** Задаем вывод в файл */
OUTPUT TO VALUE(out_file_name).

PUT UNFORMATTED StrToWin_ULL("<data>" + CHR(13) + CHR(10)).

FOR FIRST tmprecid NO-LOCK,
    FIRST acct WHERE RECID(acct) = tmprecid.id AND acct.cust-cat = "Ю" NO-LOCK,
    FIRST cust-corp WHERE cust-corp.cust-id = acct.cust-id NO-LOCK
  :
  	/** Экспорт реквизитов договора */
  	tmpStr = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "ДогОткрЛС", ",").
  	PUT UNFORMATTED StrToWin_ULL(exp_agree(ENTRY(2, tmpStr), ENTRY(1, tmpStr))).
  	
  	/** Экспорт реквизитов счета */
  	PUT UNFORMATTED StrToWin_ULL(exp_acct(acct.acct, (IF acct.currency = "" THEN "810" ELSE acct.currency))).
  	
  	/** Экспорт реквизитов клиента */
  	PUT UNFORMATTED StrToWin_ULL(exp_client(
  			/* arg1 */
  			GetCodeName("КодПредп",GetCodeVal("КодПредп", cust-corp.cust-stat)) + " " + cust-corp.name-corp,
  			/* arg2 */
  			cust-corp.name-corp,
  			/* arg3 */
  			DelDoubleChars(
    			(IF cust-corp.addr-of-low[1] <> cust-corp.addr-of-low[2] 
    		 		THEN cust-corp.addr-of-low[1] + " " + addr-of-low[2] 
    		 		ELSE cust-corp.addr-of-low[1]
    			),
    		","),
    		/* arg4 */
    		GetCodeName("КодДокум", 
												GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "document-id", "")) 
												+ " "	+ GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "document", "")
												+ " выдан " + STRING(DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "Document4Date_vid", "")), "99.99.9999")
    										+ " " + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "issue", ""),
    		/* arg5 */							
    		GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "tel", ""),
    		/* arg6 */
    		GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "BirthDay", ""),
    		/* arg7 */
    		cust-corp.inn,
    		/* arg8 */
    		GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "ОГРН", ""),
    		/* arg9 */
    		DelDoubleChars(GetClientInfo_ULL("Ю," + STRING(cust-corp.cust-id), "addr:АдрФакт", false), ",")
    		)).
  			success = true.
END.

PUT UNFORMATTED StrToWin_ULL("</data>" + CHR(13) + CHR(10)).

OUTPUT CLOSE.

IF success THEN
	MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
ELSE
	MESSAGE "В процессе экспорта произошла ошибка! Данные могут быть экспортированы не полностью." VIEW-AS ALERT-BOX.

