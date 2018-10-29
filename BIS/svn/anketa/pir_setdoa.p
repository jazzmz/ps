{pirsavelog.p}
/** 
   ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2009

   Установка ДР Дата обновления анкеты клиента.
   Борисов А.В., 15.04.2010
*/

{globals.i}           /* Глобальные определения */
{tmprecid.def}        /* Используем информацию из броузера */
{intrface.get xclass}

/******************************************* Определение переменных и др. */

DEFINE INPUT PARAMETER iParam AS CHARACTER.

DEFINE VARIABLE cKlType AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKlNum  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOK     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE I       AS INTEGER    NO-UNDO.

/******************************************* Реализация */

FOR EACH tmprecid
   NO-LOCK
   I = 1 TO 10:
END.

IF (I NE 1)
THEN DO:
   MESSAGE "Пометьте только одного клиента !!!"
      VIEW-AS ALERT-BOX QUESTION BUTTONS OK.
   RETURN.
END.

FIND FIRST tmprecid
   NO-ERROR.

CASE iParam:
   WHEN "Ч" THEN DO:
      FIND FIRST person
         WHERE (RECID(person) EQ tmprecid.id)
         NO-ERROR.
      cKlType = "person".
      cKlNum  = STRING(person.person-id).
   END.
   WHEN "Ю" THEN DO:
      FIND FIRST cust-corp
         WHERE (RECID(cust-corp) EQ tmprecid.id)
         NO-ERROR.
      cKlType = "cust-corp".
      cKlNum = STRING(cust-corp.cust-id).
   END.
   WHEN "Б" THEN DO:
      FIND FIRST banks
         WHERE (RECID(banks) EQ tmprecid.id)
         NO-ERROR.
      cKlType = "banks".
      cKlNum = STRING(banks.bank-id).
   END.
   WHEN "П" THEN DO:
      FIND FIRST cust-role
         WHERE (RECID(cust-role) EQ tmprecid.id)
         NO-ERROR.
      cKlType = ENTRY(LOOKUP(cust-role.cust-cat, "Ч,Ю,Б"), "person,cust-corp,banks").
      cKlNum  = STRING(cust-role.cust-id).
   END.
END CASE.

beg-date = TODAY.
end-date = TODAY.
{getdate.i &DateLabel  = "Дата обновления анкеты" &noinit = "yes"}

RUN UpdateTempSignsPIR(cKlType, cKlNum, "pirSotrObnAnk", end-date, USERID, NO, OUTPUT lOK).

IF (NOT lOK)
THEN DO:
   MESSAGE "ДР установить не удалось"
      VIEW-AS ALERT-BOX QUESTION BUTTONS OK.
   RETURN.
END.

RUN UpdateTempSignsPIR(cKlType, cKlNum, "ДатаОбнАнкеты", end-date, STRING(end-date, "99/99/9999"), YES, OUTPUT lOK).

IF (NOT lOK)
THEN DO:
   MESSAGE "ДР установить не удалось"
      VIEW-AS ALERT-BOX QUESTION BUTTONS OK.
   RETURN.
END.

{intrface.del}

/* Непосредственно сохранение значения ТЕМПОРИРОВАННОГО ДР (UpdateTempSignsExDirect) */
PROCEDURE UpdateTempSignsPIR.
   DEF INPUT  PARAM infile AS CHAR   NO-UNDO.   /* Наименование таблицы (код класса). */         
   DEF INPUT  PARAM insurr AS CHAR   NO-UNDO.   /* Идентификатор (суррогат) записи в таблице. */ 
   DEF INPUT  PARAM incode AS CHAR   NO-UNDO.   /* Код ДР. */                                    
   DEF INPUT  PARAM indate AS DATE   NO-UNDO.   /* Дата ДР */                                    
   DEF INPUT  PARAM inval  AS CHAR   NO-UNDO.   /* Значение ДР. */                               
   DEF INPUT  PARAM inindx AS LOG    NO-UNDO.   /* Признак индексируемости */
   DEF OUTPUT PARAM oFlag  AS LOG    NO-UNDO.   /* Флаг успешного создания ДР */

   DEF VAR vDataType AS CHAR   NO-UNDO. /* Тип ДР */

   DEF BUFFER class        FOR class.
   DEF BUFFER tmpsigns     FOR tmpsigns.
   DEF BUFFER b-tmpsigns   FOR tmpsigns.

   TR:
   DO TRANSACTION
   ON ERROR  UNDO TR, LEAVE TR
   ON ENDKEY UNDO TR, LEAVE TR:
      FIND FIRST tmpsigns
         WHERE tmpsigns.file-name   EQ infile
           AND tmpsigns.code        EQ incode
           AND tmpsigns.surrogate   EQ insurr
           AND tmpsigns.since       EQ indate
      EXCLUSIVE-LOCK NO-ERROR.

      /* если передано ? , то создаем запись с пустым значением ДР */
      IF inval EQ ? THEN inval = "".

      /* Определить тип допреквизита. Знать тип допреквизита нужно
      ** для того, чтобы значения допреквизитов типа integer и decimal
      ** дублировать в поле signs.dec-value, а типа date в поле
      ** signs.date-value. */
      BLK:
      FOR EACH class WHERE class.Progress-Code EQ infile NO-LOCK,
      FIRST xattr WHERE xattr.Class-Code EQ class.Class-Code
                    AND xattr.Xattr-Code EQ incode
      NO-LOCK:
         vDataType = xattr.data-type. 
         LEAVE BLK.
      END.

                     /* Если не найдено существующее значение темпорированного
                     ** ДР на заданную дату, создаем новое, иначе редактируем. */
      IF NOT AVAIL tmpsigns
      THEN DO:
         CREATE tmpsigns.
         ASSIGN
            tmpsigns.file-name   = infile
            tmpsigns.code        = incode
            tmpsigns.surrogate   = insurr
            tmpsigns.since       = indate
         .
      END.
      /* Изменение значение темпорированного ДР */
      ASSIGN
         tmpsigns.code-value  = IF inindx THEN inval ELSE ""
         tmpsigns.xattr-value = IF inindx THEN ""    ELSE inval
         tmpsigns.dec-value   = DEC(inval)  WHEN CAN-DO("integer,decimal",vDataType)
         tmpsigns.date-value  = DATE(inval) WHEN vDataType EQ "date"
      NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO TR, LEAVE TR.
      RELEASE tmpsigns.
      oFlag =  YES.
   END.
END PROCEDURE.
