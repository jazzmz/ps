/*
File: vtb-uvdp.p
Date: 5/7/2002 mitr@bis.ru
Comment: "Парсерная" библиотека 

Допиливал Гончаров А.Е. 
01.02.2013
04.02.2013

*/

{gdate.i}
{globals.i}
{norm.i new}


if not this-procedure:persistent then do:
  message "Процедура " this-procedure:file-name " должна запускаться с опцией persistent" view-as alert-box.
  return error.
end.

this-procedure:private-data =
  "parssen library,оп_клиент,оп_дата,оп_дата_календ,оп_счет_кр,оп_сумма,оп_сумма_прописью,оп_код_валюты,док_дата,док_номер".

def var loc-rid as recid no-undo.
function GetParam CHAR (i as INT64, param-str as char).
  def var s1 as char no-undo.
  def var s2 as char no-undo.
  s1 = entry(i, param-str, "|").
  s2 = substring(s1, 1, index(s1, "]", 2)).
  if s2 = "[]" then s2 = substring(s1, index(s1, "[", 2)).
  if s2 matches "[*]" then s2 = substring(s2, 2, length(s2) - 2).
  return trim(s2, """").
end function.


procedure setRECID :
  def input parameter in-recid as recid.
  loc-rid = in-recid.
end procedure.

/*--------------------------------------------------------------------  
  1) оп_дата    дата операции
--------------------------------------------------------------------*/
PROCEDURE оп_дата:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  def var x as char no-undo.
   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    find op where recid(op) = loc-rid no-lock.        
    run date1str.p (output x, op.op-date , ? , " дд_ммм_гггг г.").
    pick-value = printtext.
  END. /* DO */
END PROCEDURE.


/*----------------------------------------------------------------------------------------------  
  2) оп_дата_календ    текущая календарная дата
-----------------------------------------------------------------------------------------------*/
PROCEDURE оп_дата_календ:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  def var x as char no-undo.

  
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    run date1str.p (output x, today , ? , " дд_ммм_гггг г.").
    pick-value = printtext.
  END. /* DO */
END PROCEDURE.


/*----------------------------------------------------------------------------------------------  
  3) оп_счет_кр   номер счета получателя, 
-----------------------------------------------------------------------------------------------*/
PROCEDURE оп_счет_кр:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  def var x as char no-undo.
   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    FIND op WHERE RECID(op) = loc-rid NO-LOCK.        
    FIND FIRST op-entry OF op WHERE op-entry.acct-cr NE ? NO-LOCK NO-ERROR.
    IF AVAIL op-entry THEN
      pick-value = op-entry.acct-cr.
  END. /* DO */
END PROCEDURE.



/*----------------------------------------------------------------------------------------------  
  4) оп_сумма сумма операции цифрами
-----------------------------------------------------------------------------------------------*/
PROCEDURE оп_сумма:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  def var x as char no-undo.
   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    find op where recid(op) = loc-rid no-lock.        
    find first op-entry of op WHERE op-entry.acct-cr NE ? no-lock NO-ERROR.
    IF AVAIL op-entry THEN
      if op-entry.currency eq "" then pick-value = string(op-entry.amt-rub).
                                 else pick-value = string(op-entry.amt-cur).
  END. /* DO */
END PROCEDURE.


/*----------------------------------------------------------------------------------------------  
  5) оп_сумма_прописью  сумма операции проаисью
-----------------------------------------------------------------------------------------------*/
PROCEDURE оп_сумма_прописью:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  def var x as char no-undo.
  def var AmtStr as char no-undo.
  def var AmtDec as char no-undo.

   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    find op where recid(op) = loc-rid no-lock.        
    find first op-entry of op WHERE op-entry.acct-cr NE ? no-lock NO-ERROR.
    IF AVAIL op-entry THEN DO:
      find currency where currency.currency = op-entry.currency NO-LOCK NO-ERROR.
      IF AVAIL currency THEN DO:
          if op-entry.currency eq ""  then do:
            run x-amtstr.p (op-entry.amt-rub, op-entry.currency, yes, yes, output AmtStr, output AmtDec).
            pick-value = trim(string(op-entry.amt-rub, "->>>>>>>>>>>>>>>>>>>>>9.99")) + " " + currency.i-currency + " (" + AmtStr + " " + AmtDec + ")".
          end. else do:
            run x-amtstr.p (op-entry.amt-cur, op-entry.currency, yes, yes, output AmtStr, output AmtDec).
            pick-value = trim(string(op-entry.amt-cur, "->>>>>>>>>>>>>>>>>>>>>9.99")) + " " + currency.i-currency + " (" + AmtStr + " " + AmtDec + ")".
          end.
      END.
    END.

  END. /* DO */
END PROCEDURE.


/*------------------------------------------------------------------------  
  5) оп_клиент название клиента-получателя средств
-------------------------------------------------------------------------*/
PROCEDURE оп_клиент:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  def var name as char extent 2 no-undo.

  

  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    find op where recid(op) = loc-rid no-lock.        
    find first op-entry of op WHERE op-entry.acct-cr NE ? no-lock NO-ERROR.
    IF AVAIL op-entry THEN DO:
       find first acct where acct.acct = op-entry.acct-cr
                         and acct.currency = op-entry.currency
                         NO-LOCK NO-ERROR.
       IF AVAIL acct THEN DO:
          {getcust.i &name=name &offinn=yes}     
          pick-value = trim(name[1]) + " " + trim(name[2]) .
       END.
    END.
  END. /* DO */
END PROCEDURE.


/*------------------------------------------------------------------------  
  6) оп_код_валюты  ISO
-------------------------------------------------------------------------*/
PROCEDURE оп_код_валюты:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  def var name as char extent 2 no-undo.

  

  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    find op where recid(op) = loc-rid no-lock.        
    find first op-entry of op WHERE op-entry.acct-cr NE ? no-lock NO-ERROR.
    IF AVAIL op-entry THEN DO:
       find first acct where acct.acct = op-entry.acct-cr
                         and acct.currency = op-entry.currency
                         NO-LOCK NO-ERROR.
       IF AVAIL acct THEN DO:
         find currency where currency.currency = acct.currency NO-LOCK NO-ERROR.
         IF AVAIL currency THEN
            pick-value = currency.i-currency .
       END.
    END.
  END. /* DO */
END PROCEDURE.

/*--------------------------------------------------------------------  
  7) док_дата    дата операции
--------------------------------------------------------------------*/
PROCEDURE док_дата:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  def var sdate as date no-undo.
  def var x as char no-undo.
   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    find op where recid(op) = loc-rid no-lock.        
    sdate = op.op-date.
    sdate = IncWDay (sdate, 15).
    run date1str.p (output x, sdate , ? , " дд_ммм_гггг г.").
    pick-value = printtext.
  END. /* DO */
END PROCEDURE.

/*--------------------------------------------------------------------  
  8) док_номер    номер документа
--------------------------------------------------------------------*/
PROCEDURE док_номер:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    find op where recid(op) = loc-rid no-lock.        
    pick-value = op.doc-num.
  END. /* DO */
END PROCEDURE.



