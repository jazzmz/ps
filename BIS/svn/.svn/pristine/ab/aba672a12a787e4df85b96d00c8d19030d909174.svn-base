
/*------------------------------------------------------------------------
    File        : pir_f227_2.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : dmaslov
    Created     : Thu Jul 19 11:33:08 MSD 2012
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */



/* ********************  Preprocessor Definitions  ******************** */
{globals.i}
{sv-calc.i}
/* ***************************  Main Block  *************************** */

DEF TEMP-TABLE tAllOperations LIKE DataLine.

DEF TEMP-TABLE tResult
               FIELD tyo     AS  CHAR
               FIELD subtyo  AS  CHAR
               FIELD iMin    AS  DECIMAL
               FIELD iMax    AS  DECIMAL
               FIELD iMinPos AS  DECIMAL
               FIELD iMaxPos AS  DECIMAL
               INDEX idxtyo IS PRIMARY tyo
              .


/**
 *  Процедура производит расчет ТНГ и ТВГ по операциям.
 *  @param TABLE   tAllOper таблица с операциями и ценами
 *  @param TAArray oOper массив операций для которых просчитываем рынок
 *  @param TABLE   tResult таблица с результатом в виде
 **/
 PROCEDURE calcMarketPrice:
     DEF INPUT PARAM TABLE FOR tAllOperations.
     DEF INPUT PARAM oOper AS TAArray NO-UNDO.
     DEF INPUT PARAM TABLE FOR tResult.
 
     DEF VAR key1    AS CHAR     NO-UNDO.
     DEF VAR val1    AS CHAR     NO-UNDO.
     DEF VAR iCount  AS INT      NO-UNDO.

     DEF VAR iMin     AS DEC     NO-UNDO.
     DEF VAR iMin1    AS DEC     NO-UNDO.
     DEF VAR iMin2    AS DEC     NO-UNDO.

     DEF VAR iMax     AS DEC     NO-UNDO.
     DEF VAR iMax1    AS DEC     NO-UNDO.
     DEF VAR iMax2    AS DEC     NO-UNDO.
     
     DEF VAR iMinDelimeter AS DEC INIT 0.25 NO-UNDO.
     DEF VAR iMaxDelimeter AS DEC INIT 0.75 NO-UNDO.

     
{foreach oOper key1 val1}

iCount = 0.

FOR EACH tAllOperations WHERE tAllOperations.Sym2 = key1 BY tAllOperations.val[3] BY tAllOperations.val[9]:
            iCount = iCount + 1.
        END.

iMin = iCount * iMinDelimeter.
iMax = iCount * iMaxDelimeter.



IF iMin - TRUNCATE(iMin,0) = 0 THEN DO:
  /**
   * Получилась целось целое цисло.
   **/
  FIND FIRST tAllOperations WHERE tAllOperations.Sym2=key1 AND tAllOperations.val[3] = iMin    NO-LOCK  NO-ERROR.
  iMin1 = tAllOperations.val[9].
  FIND FIRST tAllOperations WHERE tAllOperations.Sym2=key1 AND tAllOperations.val[3] = iMin + 1 NO-LOCK NO-ERROR.
  iMin2 = tAllOperations.val[9].
  
  iMin1 = (iMin1 + iMin2) / 2.
END. ELSE DO:
    /**
     * Получилось дробное число.
     **/
    FIND FIRST tAllOperations WHERE tAllOperations.Sym2=key1 AND tAllOperations.val[3] = TRUNCATE(iMin,0) + 1 NO-LOCK NO-ERROR.
    iMin1 = tAllOperations.val[9].
END.

IF iMax - TRUNCATE(iMax,0) = 0 THEN DO:
  
  FIND FIRST tAllOperations WHERE tAllOperations.Sym2=key1 AND tAllOperations.val[3] = iMax NO-LOCK NO-ERROR.
  iMax1 = tAllOperations.val[9].

  FIND FIRST tAllOperations WHERE tAllOperations.Sym2=key1 AND tAllOperations.val[3] = iMax + 1 NO-LOCK NO-ERROR.
  iMax2 = tAllOperations.val[9].  
  iMax2 = (iMax1 + iMax2) / 2.
END. ELSE DO:
  FIND FIRST tAllOperations WHERE tAllOperations.Sym2=key1 AND tAllOperations.val[3] = TRUNCATE(iMax,0) + 1 NO-LOCK NO-ERROR.
  iMax1 = tAllOperations.val[9].
END.

CREATE tResult.
 ASSIGN
    tResult.tyo     = key1
    tResult.subtyo  = key1
    tResult.iMin    = iMin1
    tResult.iMax    = iMax1
    tResult.iMinPos = iMin
    tResult.iMaxPos = iMax
   .
{endforeach oOper}
END PROCEDURE.




/**
 * Все операции из родительского
 * класса
 **/

DEF VAR dBegDate  AS DATE INIT 01/10/2012 NO-UNDO.
DEF VAR dEndDate  AS DATE INIT 01/10/2012 NO-UNDO.
DEF VAR i         AS INT  INIT 0          NO-UNDO.
DEF VAR j         AS INT  INIT 0          NO-UNDO.
DEF VAR oAArray   AS TAArray              NO-UNDO.
DEF VAR oAArray1  AS TAArray              NO-UNDO.

DEF BUFFER PDataBlock FOR DataBlock.
DEF BUFFER PDataLine  FOR DataLine.


ASSIGN
  dBegDate = DataBlock.Beg-Date
  dEndDate = DataBlock.End-Date
 .
 
 PROCEDURE fillDataLines.
  DEF INPUT PARAM TABLE FOR tResult.
  FOR EACH tResult NO-LOCK:
     CREATE Tdataline.
     ASSIGN
        TdataLine.data-id = in-data-id
        TdataLine.Sym1    = tResult.tyo
        TdataLine.Sym2    = tResult.subtyo
        TdataLine.Val[1]  = tResult.iMin
        TdataLine.Val[2]  = tResult.iMax
        TdataLine.Val[3]  = tResult.iMinPos
        TdataLine.Val[4]  = tResult.iMaxPos
     .
  END.
END PROCEDURE.

/**
 *              Шаг №1                            
 * Копируем операции из родительского класса      
 * во временную таблицу и одновременно нумеруем.  
 * Попутно при копировании строим сетку операций. 
 **/
oAArray  = NEW TAArray("0").
oAArray1 = NEW TAArray().

FOR EACH PDataBlock WHERE PDataBlock.DataClass-id EQ 'f227_1' 
                      AND PDataBlock.Beg-Date     EQ dBegDate
                      AND PDataBlock.End-Date     EQ dEndDate NO-LOCK,
    EACH PDataLine WHERE  PDataLine.data-id       EQ PDataBlock.data-id AND NOT LOGICAL(PDataLine.Sym3)
    NO-LOCK BREAK BY PDataLine.Sym2 BY PDataLine.val[9]:
     IF FIRST-OF(PDataLine.Sym2) THEN DO:
        i = 0.
        oAArray:setH(PDataLine.Sym2,0).
     END.

     /**
      * Учитываем кол-во операций.
      * В родительском классе хранятся свернутое
      * кол-во операций.
      **/
     DO j = 1 TO PDataLine.val[2]:
       i = i + 1.
       CREATE TAllOperations.
       BUFFER-COPY PDataLine EXCEPT PDataLine.Sym4 TO tAllOperations.
       tAllOperations.Sym4 = PDataLine.Sym4 + "-" + STRING(i).
       tAllOperations.val[3] = i.
     END.
END.

/**
*               Шаг №2                 
* Рассчитываем интервал рыночных цен.
*
**/

RUN calcMarketPrice (TABLE tAllOperations,oAArray,TABLE tResult).


RUN fillDataLines (TABLE tResult).


DELETE OBJECT oAArray.
DELETE OBJECT oAArray1.