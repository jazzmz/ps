/* ------------------------------------------------------
File          : $RCSfile: pir-log.i,v $ $Revision: 1.1 $ $Date: 2007-08-08 11:55:03 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Назначение    : Проколирует последний запуск/вызов модуля/инклюдника в класс pir-log
              : Служит для отлова "мертных исходников"
Параметры     : module  - имя модуля/инклюдника - нужен обязательно
	      : comment - Комментарий разработчика
	      :	nodef   - отключение определения буфферов для DataBlock/DataLine
	      :	Примеры вызова:
	      :    1. {pir-log.i &module="имя модуля или инклюдника"}
	      :    2. {pir-log.i &module="$_RCSfile$"} 
	      :    3. {pir-log.i &module="$_RCSfile$" &comment="Комментарии для грядущих поколений разработчиков"}
	      : При вариантов 2 и 3 подчеркивание после $ нужно убрать для подстановки ключевых слов CVS-ом
Место запуска : Включается в тело "подозреваемой" процедуры
Автор         : $Author: lavrinenko $ 
Изменения     : $Log: not supported by cvs2svn $
------------------------------------------------------ */

&IF DEFINED (module) &THEN
    DO TRANS:
	&IF DEFINED (nodef-pir-log) EQ 0 &THEN
	    DEF BUFFER pir-DB for DataBlock.
	    DEF BUFFER pir-DL for DataLine.
	    &GLOBAL nodef-pir-log
	&ENDIF
	FIND FIRST pir-DB WHERE pir-DB.DataClass-ID = 'pir-log'    AND
	                        pir-DB.Branch-ID    = dept.branch  NO-LOCK NO-ERROR.
	IF AVAILABLE pir-DB THEN DO:
	   FIND FIRST pir-DL WHERE pir-DL.Data-ID  = pir-DB.Data-ID AND
	                           pir-DL.Sym1     = "{&module}" EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

 	  IF AVAIL pir-DL THEN ASSIGN 
		pir-DL.Sym3   = STRING (TODAY) + ' ' + STRING(TIME,"HH:MM:SS")
	        pir-DL.Sym4   = USERID('bisquit')
	        pir-DL.val[1] = pir-DL.val[1] + 1
		pir-DL.txt    = "{&comment}"
	  . /* IF AVAIL pir-DL */
	  ELSE IF NOT LOCKED(pir-DL) THEN DO:
		CREATE pir-DL.
		ASSIGN
	  	   pir-DL.Data-ID = pir-DB.Data-ID
		   pir-DL.Sym1    = "{&module}"
		   pir-DL.Sym2    = STRING (TODAY) + ' ' + STRING(TIME,"HH:MM:SS")
		   pir-DL.Sym3 	  = STRING (TODAY) + ' ' + STRING(TIME,"HH:MM:SS")
		   pir-DL.Sym4 	  = USERID('bisquit')
		   pir-DL.val[1]  = 1
		   pir-DL.txt  	  = "{&comment}"
		.
	  END. /* ELSE IF NOT LOCKED(pir-DL) */
        END. /* IF AVAILABLE pir-DB THEN */	
			
	RELEASE pir-DL.
	RELEASE pir-DB.
END. /* DO TRANS */
&ELSE 
       &MESSAGE ** ОШИБКА -- при вызове $RCSfile: pir-log.i,v $: параметер module должен быть определен !!!
&ENDIF