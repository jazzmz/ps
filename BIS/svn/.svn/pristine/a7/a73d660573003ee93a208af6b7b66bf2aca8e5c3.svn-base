/* ------------------------------------------------------
     File: $RCSfile: pir_mm_def.i,v $ $Revision: 1.2 $ $Date: 2007-12-13 14:57:16 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: Внедрение модуля Денежный рынок
     Что делает: Объявляет временные таблицы и общие функции
     Как работает: 
     Параметры: 
     Место запуска: in-line including... 
     Автор: $Author: buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
------------------------------------------------------ */

DEF TEMP-TABLE ttCurrentLoan NO-UNDO LIKE loan
	FIELD loan-acct AS CHAR
	FIELD pers-acct AS CHAR
	/*FIELD risk AS CHAR
	FIELD gr-risk AS CHAR*/
.

DEF TEMP-TABLE ttBankCorrespond NO-UNDO LIKE banks
	FIELD bic AS CHAR
	FIELD corr-acct AS CHAR
	FIELD swift AS CHAR
	FIELD engl-name AS CHAR
.

FUNCTION SetUserDetails RETURNS CHAR (INPUT users-id AS CHAR).
	
	/*  Заполняет данные о должности и ФИО пользователя по их коду.
			Input: <код_пользователя>[|<код_пользователя>...]
			Output: <<код_пользователя>,<Должность>,<ФИО>[|<код_пользователя>...]>
	*/
	DEF VAR i AS INTEGER.
	DEF VAR user-id AS CHAR.
	DEF VAR post AS CHAR.
	
	IF NUM-ENTRIES(users-id, "|") = 0 THEN 
		RETURN ",______________,______________".
		
	DO i = 1 TO NUM-ENTRIES(users-id, "|") :

	  user-id = ENTRY(i, users-id, "|") + ",,".
	  
		FIND FIRST _user WHERE _user._userid = ENTRY(1, user-id) NO-LOCK NO-ERROR.
		IF AVAIL _user THEN
			DO:
				post = GetXAttrValueEx("_user", _user._userid, "Должность", "<не определен>").
				ENTRY(2,user-id) = post.
				ENTRY(3,user-id) = _user._user-name.
			END.
		ELSE
			DO:
				ENTRY(2, user-id) = "______________".
				ENTRY(3, user-id) = "______________".
			END.
		
		ENTRY(i, users-id, "|") = user-id.

	END.

	RETURN users-id.
	
END FUNCTION.
