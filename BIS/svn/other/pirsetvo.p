{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 2006 КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pirsetvo.p
      Comment: 'Установка дополнительных реквизитов по значению в содержании'
   Parameters:
         Uses: 
      Used by:
      Created: 14.10.2006 anisimov
*/

{globals.i}
{wordwrap.def}
{bank-id.i}
{op-ident.i}
{intrface.get op}
{intrface.get olap}
{intrface.get re}       /* Библиотека регулярных выражений. */
{intrface.get tmess}    /* Библиотека */
{intrface.get xclass}
{intrface.get ps}
{intrface.get strng}

{chkop117.i}

DEF VAR mKodOpVal117 AS CHAR NO-UNDO.
DEF VAR nCountDoc AS INT NO-UNDO.
DEF VAR Rcode AS INT NO-UNDO.

DEFINE BUFFER xop       FOR op.
DEFINE BUFFER xop-entry FOR op-entry.

DEFINE VAR vHandle  AS HANDLE    NO-UNDO.
DEFINE VAR vhTable  AS HANDLE    NO-UNDO.
DEFINE VAR vhQuery  AS HANDLE    NO-UNDO.

DEF VAR vDelimFirst  AS CHAR INITIAL "~{" NO-UNDO. /* Открывающая скобка */
DEF VAR vDelimSecond AS CHAR INITIAL "~}" NO-UNDO. /* Закрывающая скобка */

/************************/

{getdate.i}.

nCountDoc = 0.

FOR EACH xop WHERE xop.op-date GE end-date
              AND xop.op-date LE end-date
         NO-LOCK:
	mKodOpVal117 = "".
	RUN ChkStr2117i(xop.details, vDelimFirst, vDelimSecond,OUTPUT Rcode).
    /* Проверка на принадлежность документа / проводки к требованиям 117-И. */
    IF Rcode  EQ 0 THEN DO:
       FOR EACH xop-entry OF xop NO-LOCK:
           IF GetXAttrValueEx("op",STRING(xop.op),"КодОпВал117","") EQ "" THEN DO:
              RUN pGet117ReqN IN h_op (xop-entry.op, OUTPUT vHandle ).

              IF RETURN-VALUE EQ "0" /* документ с VO */ THEN DO:
                 vhTable = vHandle:DEFAULT-BUFFER-HANDLE.
                 /*а теперь по всем записям КодОпВал117 */
                 CREATE QUERY vhQuery.
                 vhQuery:SET-BUFFERS(vhTable).
                 vhQuery:QUERY-PREPARE("FOR EACH " + vHandle:NAME + " NO-LOCK").
                 vhQuery:QUERY-OPEN().
                 for-each-op-val:
                 {for_dqry.i vhQuery}
                    IF ( vhTable:BUFFER-FIELD(3):BUFFER-VALUE NE 0 ) AND ( vhTable:BUFFER-FIELD(6):BUFFER-VALUE NE 0 ) THEN DO:
                       IF ( mKodOpVal117 NE "" )  THEN  mKodOpVal117 = mKodOpVal117 + "|".
                       mKodOpVal117 = mKodOpVal117 + vhTable:BUFFER-FIELD(1):BUFFER-VALUE + "," +
                                                     vhTable:BUFFER-FIELD(2):BUFFER-VALUE + "," +
                                                     vhTable:BUFFER-FIELD(3):BUFFER-VALUE + "," +
                                                     vhTable:BUFFER-FIELD(4):BUFFER-VALUE + "," +
                                                     vhTable:BUFFER-FIELD(5):BUFFER-VALUE + "," +
                                                     vhTable:BUFFER-FIELD(6):BUFFER-VALUE + "," +
                                                     vhTable:BUFFER-FIELD(7):BUFFER-VALUE + "," +
                                                     vhTable:BUFFER-FIELD(8):BUFFER-VALUE + "," +
                                                     vhTable:BUFFER-FIELD(9):BUFFER-VALUE.
                    END.
                 END.
                 vhQuery:QUERY-CLOSE().
                 DELETE OBJECT vhQuery.
              END.
              nCountDoc = nCountDoc + 1.
/*              message "Назначение " + SUBSTR(xop.details,1,30) + "; Дебет " + xop-entry.acct-db + "; Кредит " + xop-entry.acct-cr view-as alert-box error . */
/*              message "КодОпВал117 " +  mKodOpVal117 view-as alert-box error . */
              IF NOT UpdateSigns("op",string(xop.op),"КодОпВал117",mKodOpVal117,?) THEN message "Ошибка изменения КодОпВал117 " view-as alert-box error .
           END.
       END.
    END.
END.
IF nCountDoc NE 0 THEN 
   message "Найдено " + STRING(nCountDoc,">>>>9") + " документа(ов)" view-as alert-box error.
ELSE
   message "Не найдено документов" view-as alert-box error.



