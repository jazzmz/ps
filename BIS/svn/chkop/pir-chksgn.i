/* ------------------------------------------------------
     File: $RCSfile: pir-chksgn.i,v $ $Revision: 1.3 $ $Date: 2008-06-04 07:36:07 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: 
     Что делает: Проверка сроков действия полномочий лиц, согласно карточкам с образцами подписей
     Как работает: Существует настроечный параметр "ПИРКартаВажно", который определяет возможность отсутствия данных 
                   о сроках действия полномочий лиц, указанных в карточке с образцами подписей.
                   Проверяется счет дебета. Если счет клиентский, то проверяется наличие данных 
                   о сроках действия полномочий лиц, указанных в банковской карточке с образцами подписей. 
                   Данные о сроках хрянятся в таблице CUST-ROLE.
     Параметры: ope - макрос "имя_буфера_таблицы_op-entry
     Место запуска: 
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.2  2008/06/04 06:51:15  Buryagin
    	 Изменения: Fix: in-line call of pir-chksgn.i needs the macros-param "ope".
     Изменения:
     Изменения: Revision 1.1  2008/06/04 05:41:42  Buryagin
     Изменения: *** empty log message ***
     Изменения:
     Изменения:
------------------------------------------------------ */

DEF VAR doit AS LOGICAL NO-UNDO.
DEF VAR macct AS CHAR NO-UNDO.
DEF VAR mtype AS CHAR NO-UNDO.
DEF VAR t AS CHAR NO-UNDO.

doit = FGetSetting("PirChkOp", "PirChkSignDoit", "нет") EQ "да".
macct = FGetSetting("PirChkOp", "PirChkSignAcct", "*").
mtype = FGetSetting("PirChkOp", "PirChkSignCT", "Ч,Ю,Б").
t = FGetSetting("PirChkOp", "PirChkSignTfT", "person,cust-corp,banks").

IF doit THEN DO:

	/** Клиентский ли счет по дебету? */
	FIND FIRST acct WHERE acct.acct = {&ope}.acct-db 
	                  AND CAN-DO(macct, acct.acct)
	                  AND CAN-DO(mtype, acct.cust-cat) 
	                  NO-LOCK NO-ERROR.
	IF AVAIL acct THEN DO:
		
		/** Найдем информацию о первой подписи, если таковая есть */
		FIND FIRST cust-role WHERE 
			cust-role.file-name = ENTRY(LOOKUP(acct.cust-cat, mtype), t)
			AND
			cust-role.surrogate = STRING(acct.cust-id)
			AND
			cust-role.class-code = "Право_первой_подписи"
			AND (
				cust-role.close-date >= {&ope}.op-date
				OR
				cust-role.close-date = ?
				)
			NO-LOCK NO-ERROR.
		IF NOT AVAIL cust-role THEN DO:
		  MESSAGE COLOR WHITE/RED 
                "Не найдено данных о сроках действий полномочий лица, либо срок действия ПЕРВОЙ ПОДПИСИ истек !!!"
                VIEW-AS ALERT-BOX TITLE "Ошибка документа".
          RETURN.
		END.
		/** Найдем информацию о второй подписи. Ее может не быть, но если она есть, то дата окончания срока 
		    должна быть больше или равна дате операции */
		FIND LAST cust-role WHERE
			cust-role.file-name = ENTRY(LOOKUP(acct.cust-cat, mtype), t)
			AND
			cust-role.surrogate = STRING(acct.cust-id)
			AND
			cust-role.class-code = "Право_второй_подписи"
			NO-LOCK NO-ERROR.
		IF AVAIL cust-role AND cust-role.close-date < {&ope}.op-date THEN DO:
		  MESSAGE COLOR WHITE/RED 
                "Cрок действия ВТОРОЙ ПОДПИСИ истек !!!"
                VIEW-AS ALERT-BOX TITLE "Ошибка документа".
          RETURN.
		END.
			
	END.
	
END.