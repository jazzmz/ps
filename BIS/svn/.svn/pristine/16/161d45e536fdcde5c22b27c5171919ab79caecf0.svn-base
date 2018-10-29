/***********************************
 * Отчет который выводит
 * Соотвествие Балансовый счет Счет КартБлок
 ***********************************
 *********** !!! ВНИМАНИЕ !!! *******
 *
 * Теперь это утилита для простановки
 * ДР картотеки блокированных!
 *
 ***********************************
 * Дата создания: 25.05.12
 * Заявка: #985
 *************************************/
{globals.i}
{intrface.get db2l}
{intrface.get xclass}

DEF VAR cSurrogate AS CHAR NO-UNDO.
DEF VAR currDate   AS DATE NO-UNDO.
DEF BUFFER bAcct FOR acct.


DEF TEMP-TABLE tblRes NO-UNDO
               FIELD name  AS CHARACTE
               FIELD acctB AS CHARACTER
               FIELD acctV AS CHARACTER
          .


{getdate.i}

currDate = end-date.

FOR EACH cust-corp NO-LOCK,
  EACH acct WHERE cust-cat EQ "Ю" 
              AND cust-corp.cust-id=acct.cust-id 
              AND acct.acct-cat EQ "o"
              AND acct.acct BEGINS "90901"
              AND (acct.close-date >= currDate OR acct.close-date = ?) NO-LOCK:

  cSurrogate = getSurrogateBuffer("acct",BUFFER acct:HANDLE).

 /**
  * Пытаемся найти установленную вручную
  * связь.
  **/

  FIND FIRST signs WHERE signs.file-name EQ  "acct"
                        AND code         EQ "КартБВнСчет"
                        AND code-value   EQ cSurrogate
                        NO-LOCK NO-ERROR.

  IF NOT AVAILABLE(signs) THEN DO:

   CREATE tblRes.
     ASSIGN
        tblRes.name  = cust-corp.name-short
        tblRes.acctV = acct.acct + "-"
     .



  FIND FIRST bAcct WHERE bAcct.acct BEGINS "40"
                         AND bAcct.acct-cat EQ "b"  
			 AND SUBSTRING(bAcct.acct,13,8) EQ SUBSTRING(acct.acct,13,8) 
			NO-LOCK NO-ERROR.

  IF AVAILABLE(bAcct) THEN DO:
	  tblRes.acctB=bAcct.acct + "-".
          /***
           * Производим установку ДР
           ***/
           UpdateSignsEx(bAcct.class-code,getSurrogateBuffer("acct",BUFFER bAcct:HANDLE),"КартБВнСчет",cSurrogate).
  END.



  END.


END.
TEMP-TABLE tblRes:WRITE-XML("file","111.xml",TRUE,?,?,NO,NO).

{intrface.del}