{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir_wpcls.p,v $ $Revision: 1.7 $ $Date: 2007-10-18 07:42:22 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Назначение    : Печать рабочего плана счетов.
Место запуска : БМ/Печать/Отчеты по счетам 2-го порядка/Разное/рабочий план счетов.
Автор         : ???
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.6  2007/08/14 11:59:09  Lavrinenko
Изменения     : Доработки определенияты открытия счета
Изменения     :
Изменения     : Revision 1.5  2007/08/14 10:58:30  lavrinenko
Изменения     : Доработки определенияты открытия счета
Изменения     :
Изменения     : Revision 1.4  2007/08/10 06:03:56  lavrinenko
Изменения     : Поставлено нижнее ограничение по дате открытия счета
Изменения     :
Изменения     : Revision 1.3  2007/08/09 06:05:56  lavrinenko
Изменения     : Убрано задваивание балансовых счтов
Изменения     :
Изменения     : Revision 1.2  2007/08/08 12:12:46  lavrinenko
Изменения     :  1. ДОбавлен стандартный заголовок. 2. Переработана процедура формирования отчета о рабочем плане счетов
Изменения     :
              : 
              : 23.01.2007 9:58  исправленна ошибка сверки
              : 19.01.2007 15:44 сверяемся с *post и *pos (округление/корректировки *post)
              : 10.01.2007 15:29 сверяемся с *post
              : 16.11.2006 10:32 дата открытия счета
------------------------------------------------------ */

{globals.i}

DEF VAR bname     AS CHAR EXTENT 10 NO-UNDO.
DEF VAR mCount    AS INTEGER NO-UNDO.
DEF VAR itog      AS INTEGER NO-UNDO INITIAL 0.
DEF VAR fd        AS DATE NO-UNDO.
DEF VAR i         AS INTEGER NO-UNDO.
DEF VAR j         AS INTEGER NO-UNDO.
DEF VAR testsum   AS DEC NO-UNDO.
DEF VAR incat     AS CHAR NO-UNDO.
DEF VAR bal-cat   AS LOGICAL EXTENT 8 NO-UNDO.
DEF VAR cat-all   AS CHAR INITIAL "b,o,d,f,t,u,x,n".
DEF VAR tmtStr    AS CHAR NO-UNDO.

DEF TEMP-TABLE ttResult NO-UNDO
  FIELD cat         AS CHAR 
  FIELD balacct     LIKE bal-acct.bal-acct
  FIELD balacct1    LIKE bal-acct.bal-acct1
  FIELD side        LIKE bal-acct.side
  FIELD name-bal    LIKE bal-acct.name-bal-acc
  FIELD DataClassID LIKE DataBlock.DataClass-ID
  FIELD DataID      LIKE DataBlock.Data-ID
  FIELD OpENDate    LIKE acct.open-date
  FIELD tsum        AS DECIMAL 
.

DEF BUFFER bcode FOR code.

{pir_wpp.i}
{getdates.i} 
   
{setdest.i}
{wordwrap.def}

FUNCTION GetFirsAcct RETURNS DATE (ipBalCat AS CHAR, ipBalAcct AS INTEGER, ipCloseDate AS DATE).
    DEF VAR lDate LIKE acct.open-date NO-UNDO INIT 01/01/1998.     

    FOR EACH acct WHERE acct.acct-cat  EQ ipBalCat   AND 
                        acct.bal-acct  EQ ipBalAcct  AND 
                        acct.open-date GE 01/01/1900 NO-LOCK BY acct.open-date:
        lDate = acct.open-date.
        LEAVE.
    END.

    IF lDate LT 01/01/1998 THEN lDate = 01/01/1998.

    RETURN lDate.
END FUNCTION. /* GetFirsAcct */

DO i = 1 TO NUM-ENTRIES(incat): 
  /* ищем нужный класс, с чем сверяемся */
  tmtStr = ENTRY(i,incat) + "pos".
  
  FIND LAST DataBlock WHERE DataBlock.dataclass-id = tmtStr   AND
                            DataBlock.beg-date     = beg-date AND
                            DataBlock.end-date     = end-date NO-LOCK NO-ERROR.
                            
  IF NOT AVAIL(DataBlock) THEN DO: /* не нашли :( */
     PUT UNFORMATTED  "Не расчитан класс данных " tmtStr " за период с "  STRING(beg-date,"99/99/9999") ' по ' STRING(end-date,"99/99/9999") skip.
     NEXT.
  END.

  /* перебираем DataLine и выбираем не нулевые */ 
  FOR EACH DataLine WHERE DataLine.data-id = DataBlock.data-id NO-LOCK,
    FIRST bal-acct WHERE bal-acct.bal-acct = INTEGER(DataLine.sym1) NO-LOCK BY DataLine.sym1:
        
    FIND FIRST ttresult WHERE ttResult.cat  = ENTRY(i,incat) AND 
                              ttResult.balacct = bal-acct.bal-acct NO-LOCK NO-ERROR.
    IF NOT AVAIL ttresult THEN DO:                                  
        testsum = 0.
        DO j = 1 TO 4:
        ASSIGN 
           testsum = testsum + absolute(val[j * 3]).
        END. /* DO j = 1 TO 4 */
        IF testsum GT 0 THEN DO:
           CREATE ttresult.
           ASSIGN
              ttResult.cat         = ENTRY(i,incat)
              ttResult.balacct     = bal-acct.bal-acct
              ttResult.balacct1    = bal-acct.bal-acct1
              ttResult.side        = bal-acct.side
              ttResult.name-bal    = bal-acct.name-bal-acc
              ttresult.DataClassId = DataBlock.dataclass-id
              ttresult.DataId      = DataBlock.data-id
              ttResult.tsum        = testsum
              ttResult.OpENDate    = GetFirsAcct(ttResult.cat,ttResult.balacct, beg-date)
           .
        END. /* IF testsum GT 0 */
    END. /* IF NOT AVAIL ttresult */
  END. /* FOR */
END. /* DO */


PUT UNFORMATTED "                                                              У Т В Е Р Ж Д А Ю" skip(2).
PUT UNFORMATTED "                                                         Зам.Председателя Правления" skip(2).
PUT UNFORMATTED "                                                         _____________ Шлогина Е.Г." skip (2).
PUT UNFORMATTED "                                                         _____ _____________ "    "_____г." skip(2).
PUT UNFORMATTED "                          Р А Б О Ч И Й   П Л А Н   С Ч Е Т О В" skip (2).
PUT UNFORMATTED "┌─────────────┬────────────────────────────────────────────────┬───────┬───────────────┐" skip.
PUT UNFORMATTED "│ Номер счета │         Наименование разделов и счетов         │Признак│ Дата открытия │" skip.
PUT UNFORMATTED "│    1 (2)    │                     баланса                    │ счета │     счета     │" skip.
PUT UNFORMATTED "│   порядка   │                                                │  А,П  │               │" skip.
PUT UNFORMATTED "├─────┬───────┼────────────────────────────────────────────────┼───────┼───────────────┤" skip.
PUT UNFORMATTED "│  1  │   2   │                       3                        │   4   │       5       │" skip.

DO i = 1 TO num-entries(incat): 
  FIND FIRST bcode WHERE bcode.class = "acct-cat" AND bcode.code = ENTRY(i,incat) NO-LOCK.

  PUT UNFORMATTED "├─────┴───────┴────────────────────────────────────────────────┴───────┴───────────────┤" skip.
  PUT UNFORMATTED "│               " STRING(bcode.name,"x(62)") "         │" skip.                        
  PUT UNFORMATTED "├─────┬───────┬────────────────────────────────────────────────┬───────┬───────────────┤" skip.

  
  tmtStr = ENTRY(i,incat) + "-acct1".
  
  FOR EACH code WHERE code.class = tmtStr  AND
		      code.parent = code.class NO-LOCK,
     EACH ttResult WHERE ttResult.cat      = ENTRY(i,incat) AND 
                         ttResult.balacct1 = code.code NO-LOCK BREAK BY ttResult.balacct1:

         IF FIRST-OF (ttResult.balacct1) THEN DO:
            ASSIGN     
                mCount = 2
                bname = ""
                bname[1] = code.name
            .
            {wordwrap.i &s = bname &l = 46 &n = 10}
         
            PUT UNFORMATTED "│"space STRING (code.code,"x(3)") space "│" space(7) "│ " STRING(bname[1],"x(46)") " │       │               │" skip.
            DO WHILE (bname[mCount] NE ""):
               PUT UNFORMATTED "│     │       │ " STRING(bname[mCount],"x(46)") " │       │               │" SKIP.
               mCount = mCount + 1.
            END. /* DO WHILE (bname[mCount] NE "") */
         END. /* IF FIRST-OF (ttResult.balacct)  */

         ASSIGN 
             itog = itog + 1   
             mCount = 2
             bname = ""
             bname[1] = ttResult.name-bal
         .
        
	 {wordwrap.i &s =bname &l = 46 &n = 10}
	       
         PUT UNFORMATTED "│     ├───────┼────────────────────────────────────────────────┼───────┼───────────────┤" SKIP.
         PUT UNFORMATTED "│     │ " STRING(ttResult.balacct,"99999") 
	  		  " │ " STRING (bname[1],"x(46)") " │   " STRING(ttResult.side,"x(2)") "  │   " STRING (ttResult.OpENDate,"99/99/9999") "  │"  SKIP. 
         DO WHILE (bname[mCount] NE ""):
            PUT UNFORMATTED "│     │       │ " STRING(bname[mCount],"x(46)") " │       │               │"  SKIP.
            mCount = mCount + 1.
         END. /* DO WHILE (bname[mCount] NE "") */
     
         IF LAST-OF (ttResult.balacct1) THEN DO:
            PUT UNFORMATTED "├─────┼───────┼────────────────────────────────────────────────┼───────┼───────────────┤" SKIP.
         END. /* IF LAST-OF  */

    END. /* FOR EACH code, EACH ttResult */
END. /* DO i = 1 TO num-entries(incat) */

PUT UNFORMATTED "└─────┴───────┴────────────────────────────────────────────────┴───────┴───────────────┘" SKIP(3).

PUT UNFORMATTED space(5) "Всего счетов:" STRING (itog,">>>>>>9") SKIP(3).
PUT UNFORMATTED space(10) FGetSetting("ДолжнБух","","") SPACE(4)
		"_______________" SPACE(5)
		FGetSetting("ФИОБух","","") SKIP.
		
{pir-log.i &module="$RCSfile: pir_wpcls.p,v $" &comment="Печать рабочего плана счетов"}
{preview.i}


 