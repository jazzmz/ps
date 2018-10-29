/* ------------------------------------------------------
     File: $RCSfile: pir_imp_img.p,v $ $Revision: 1.2 $ $Date: 2008-07-28 16:01:40 $
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: 
     Причина: 
     Что делает: Импортирует данные формата mime в генератор отчетов 
     Как работает: 
     Параметры: через запятую
     			<код_каталога>,<код_нового_пункта>,<название_нового_пункта>,
     			<файл_mime>,<режим>,<файл_протокола>
                где
                <код_каталога> - цифровой код каталога в Генераторе отчетов, в котором
                                 процедура создаст новый пункт меню
                <код_нового_пункта> - код пункта меню, который создаст процедура
                <название_нового_пункта> - название пункта меню, который создаст процедура
                <файл_mime> - полное имя файла (вклчая путь), данные из которого будут 
                              импортированы процедурой
                <режим> - режим перезаписи, в котором производится импорт, если 
                          указанный пункт меню уже существует
                          
                          yes - перезаписывать без вопросов
                          no  - не перезаписывать (пропускать)
                          
                <файл_протокола> - файл, в который будут добавлятся строки с сообщениями
                                   настоящей процедуры
                                        
     Место запуска: -
     Автор: $Author: Buryagin $ 
     Изменения: $Log: not supported by cvs2svn $
     Изменения: Revision 1.1  2008/05/30 07:36:12  Buryagin
     Изменения: *** empty log message ***
     Изменения:
------------------------------------------------------ */

{globals.i}

/** DEF INPUT PARAM iParam AS CHAR. */
DEF INPUT PARAM iParent AS INTEGER.
DEF INPUT PARAM iProcedure AS CHAR.
DEF INPUT PARAM iNameProc AS CHAR.
DEF INPUT PARAM iMimeFile AS CHAR.
DEF INPUT PARAM iMode AS CHAR.
DEF INPUT PARAM iLogFile AS CHAR.

PAUSE 0.

pick-value = ?.

/** Проверка входных параметров */
/**
IF NUM-ENTRIES(iParam) <> 6 THEN DO:
	MESSAGE "Недостаточное количество параметров! См. описание пукта меню." VIEW-AS ALERT-BOX.
	RETURN.
END.
*/

OUTPUT TO VALUE(iLogFile) APPEND.

/**
PUT UNFORMATTED "pir_imp_img.p: message: Процедура запущена с параметрами: '" + iParam + "'" SKIP.
*/

/** Найдем каталог */
FIND FIRST user-proc WHERE user-proc.public-number = iParent NO-LOCK NO-ERROR.
IF NOT AVAIL user-proc THEN DO:
	PUT UNFORMATTED "pir_img_img.p: error: Не найден каталог c public-number = " + STRING(iParent) SKIP.
	RETURN.
	END. 

/** Проверим существование пунтка меню */
FIND FIRST user-proc WHERE 
	user-proc.parent = iParent
    AND
    user-proc.procedure = iProcedure
    NO-LOCK NO-ERROR.
IF AVAIL user-proc THEN 
	DO:
		/** Если пункт меню был, проверим можно ли перезаписывать данные
		    Если перезапись запрещена, то выходим из процедуры */
		IF LC(iMode) = "no" THEN 
			DO:
				PUT UNFORMATTED "pir_imp_img.p: warning: Пункт меню procedure = " + iProcedure + " уже существует, но перезапись запрещена!" SKIP.
				RETURN.
			END.
		ELSE
			DO:
				/** Иначе удаяем все записи из reports.name = user-proc.procedure */
				PUT UNFORMATTED "pir_imp_img.p: message: Перезаписываю меню procedure = " + iProcedure SKIP. 
				FOR EACH reports WHERE
					reports.name = user-proc.procedure
					:
					PUT UNFORMATTED "pir_imp_img.p: message: Удаляю строку " reports.line reports.txt FORMAT "x(20)" "..." SKIP.
					DELETE reports.
				END.
			END. 
	END.
ELSE
	DO:
		/** Если пункта меню не было, то создаем его */
		CREATE user-proc.
		user-proc.parent = iParent.
		user-proc.procedure = iProcedure.
		user-proc.name-proc = iNameProc.
		PUT UNFORMATTED "pir_imp_img.p: message: Создан пункт меню procedure = " + 
			iProcedure + ", name-proc = '" + iNameProc + "', parent = " +
			STRING(iParent) SKIP. 
	END.


DEF VAR i AS INTEGER. /** Номер строки в reports */
DEF VAR str AS CHAR. /** строка из импортируемого файла */

/** Начинаем импорт */
INPUT FROM VALUE(iMimeFile).
i = 0.
REPEAT:
	i = i + 1.
	IMPORT str.
	CREATE reports.
	reports.name = user-proc.procedure.
	reports.line = i.
	reports.txt = '"' + str + '"'.
	PUT UNFORMATTED "pir_imp_img.p: message: Создаю строку " reports.line reports.txt FORMAT "x(20)" "..." SKIP.
END.
INPUT CLOSE.

OUTPUT CLOSE.

/** процедура вернет */
pick-value = STRING(user-proc.public-number).
