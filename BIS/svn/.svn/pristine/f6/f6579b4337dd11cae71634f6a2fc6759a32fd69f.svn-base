{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-shdrep.p,v $ $Revision: 1.10 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Причина       : Реализация приказа №64 от 25.10.05
Назначение    : Запуск процедур создания отчетов по приказу №64 от 25.10.05
Место запуска : Планировкщик задач
Автор         : $Author: anisimov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.9  2007/08/22 13:29:55  lavrinenko
Изменения     : Реализован корреткный поиск последнего раобочего дня месяца
Изменения     :
Изменения     : Revision 1.8  2007/08/21 13:36:43  lavrinenko
Изменения     : Реализовано сохранение в месячные и годовые е каталоги
Изменения     :
Изменения     : Revision 1.7  2007/08/21 07:37:07  lavrinenko
Изменения     : Реализован запуск отчетов но классу данных
Изменения     :
Изменения     : Revision 1.6  2007/08/17 13:02:44  lavrinenko
Изменения     : РЕализован безопастный вызов процедур
Изменения     :
Изменения     : Revision 1.5  2007/08/16 13:12:30  Lavrinenko
Изменения     : изменение формата вызова
Изменения     :
Изменения     : Revision 1.4  2007/08/13 13:21:51  Lavrinenko
Изменения     : изменен интерфейс вызова на боее универсальны
Изменения     : й
Изменения     :
Изменения     : Revision 1.3  2007/08/13 12:52:28  Lavrinenko
Изменения     : Разработан формат выхова ежедневных отчетов
Изменения     :
Изменения     : Revision 1.2  2007/08/13 10:33:19  Lavrinenko
Изменения     : *** empty log message ***
Изменения     :
------------------------------------------------------ */
{globals.i}             /* Глобальные переменные сессии. */
{norm.i new}
{sv-temp.i new}

{intrface.get separate} /* Библиотека для работы с категориями. */

DEFINE TEMP-TABLE tt-Date
    FIELD  fDate LIKE op-date.op-date
    INDEX iDate IS UNIQUE PRIMARY fDate
.
   
{empty tt-Date}
ASSIGN 
    gRemote = YES
.
            
/* ищем все закрытые сегодня дни */
FOR EACH history WHERE 
	 history.modif-date = TODAY     AND
	 history.file-name  = "op-date" AND
	 history.modify     = "W" 			AND 
	 history.field-value MATCHES "*закрыт*"  NO-LOCK:
		 
  /* проверяем закрытость обязательных категорий */
  IF Chk_Date_Cats(DATE(history.field-ref),Get_StatClose_Cats()) AND 
    NOT CAN-FIND(FIRST tt-Date WHERE tt-Date.fDate EQ DATE(history.field-ref)) THEN DO:
     CREATE tt-Date.
     ASSIGN 
        tt-Date.fDate = DATE(history.field-ref).
  END. /* IF Chk_Date_Cats...*/
END. /* FOR EACH history...  */

/* отчет по всем закрытым дням */
FOR EACH tt-Date:
    RUN pir-reports (tt-Date.fDate).	 				
END. /* FOR EACH tt-Date */

FUNCTION GetLastOpDay RETURNS DATE (iDate AS DATE): /* перед датой  */
    FIND LAST op-date WHERE op-date.op-date LT iDate NO-LOCK NO-ERROR.
    
    RETURN (IF AVAIL op-date THEN op-date.op-date ELSE ?).
END FUNCTION. /*GetLastCloseOpDay*/

/* процедура запуска отчетов по закрытому дню */
PROCEDURE pir-reports.
DEFINE INPUT PARAMETER in-op-date LIKE op-date.op-date NO-UNDO.

DEFINE VARIABLE lBegDate  AS DATE NO-UNDO.
DEFINE VARIABLE lEndDate  AS DATE NO-UNDO.
DEFINE VARIABLE year-num  AS INT  NO-UNDO.
DEFINE VARIABLE month-num AS INT  NO-UNDO.

ASSIGN 
       month-num = MONTH(in-op-date)
       year-num  = YEAR(in-op-date)
.

FOR EACH code WHERE code.class EQ "PirRepSystem" NO-LOCK:

        CASE ENTRY(1,CODE.Val,':'):
          WHEN "D" THEN DO: /* для ежедневных форм отчетности */
                ASSIGN 
                       lBegDate  = in-op-date
                       lEndDate  = in-op-date
                .
          END.
          WHEN "M" THEN DO:
               ASSIGN
                  lBegDate = DATE(month-num,1,year-num)
                  lEndDate = DATE(IF month-num = 12 THEN 1 ELSE month-num + 1, 1, IF month-num = 12 THEN year-num + 1 ELSE year-num) - 1
               .
                
               IF in-op-date NE GetLastOpDay(lEndDate + 1) THEN NEXT.
          END.
          WHEN "Y" THEN DO:
               ASSIGN
                  lBegDate = DATE(1,1,year-num)
                  lEndDate = DATE(1, 1, year-num + 1) - 1
               .
               
               IF in-op-date NE GetLastOpDay(lEndDate + 1) THEN NEXT.
          END.
        END CASE. /* CASE ENTRY(1,CODE.Val,':') */
        
        IF NOT {assigned CODE.name} THEN DO:       /* Отчет ФОиА             */
           PUT UNFORMAT ENTRY(3,CODE.Val,':') ' : ' CODE.descr ' за ' lBegDate ' - ' lEndDate SKIP.        

           FIND LAST DataBlock WHERE DataBlock.dataclass-id = ENTRY(4,CODE.Val,':')   AND
                           DataBlock.Branch-Id    = ENTRY(2,CODE.Val,':')             AND
                           DataBlock.IsFinal                                          AND  
                           DataBlock.beg-date     = lBegDate                          AND
                           DataBlock.end-date     = lEndDate NO-LOCK NO-ERROR.
  
           FIND FIRST user-proc WHERE user-proc.procedure EQ ENTRY(3,CODE.Val,':') NO-LOCK NO-ERROR. 
           
           IF AVAIL DataBlock AND AVAIL user-proc THEN DO:
              RUN runuprocdc.p (STRING(ROWID(user-proc)),DataBlock.Data-Id,4).
          END. ELSE IF NOT AVAIL DataBlock THEN
              PUT UNFORMAT 'Класс данных ' ENTRY(4,CODE.Val,':') ' не расчитан за период с ' lBegDate ' по ' lEndDate SKIP.          
          ELSE IF NOT AVAIL user-proc THEN
              PUT UNFORMAT 'Отсутствует шаблон отчета '  ENTRY(3,CODE.Val,':') SKIP.          
        END. ELSE IF SEARCH(CODE.name + ".r") EQ ? AND SEARCH(CODE.name + ".p") EQ ? THEN DO:
                
           PUT UNFORMAT 'Процедура ' CODE.name ' (' CODE.descr ') не найдена ' SKIP.          
           
        END. ELSE DO: /* Запуск процедуры генерации отчета */
           PUT UNFORMAT CODE.name ' : ' CODE.descr ' за ' lBegDate ' - ' lEndDate SKIP.        
           RUN VALUE (CODE.name)(lBegDate,                    /* начальная дата         */
                                 lEndDate,                    /* конечная дата          */
                                 ENTRY(2,CODE.Val,':'),       /* Код подразделения      */
                                 ENTRY(3,CODE.Val,':'),       /* передаваемое имя файла */
                                 ENTRY(4,CODE.Val,':'),       /* список балансовых категорий счетов участвующих в построении отчета    */
                                 ENTRY(5,CODE.Val,':')).      /* параметры процедуры    */
        END.
END. /* FOR EACH code... */
END PROCEDURE. /* PROCEDURE pir-reports */

