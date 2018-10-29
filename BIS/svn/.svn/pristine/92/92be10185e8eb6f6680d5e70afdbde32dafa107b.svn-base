{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1996 ТОО "Банковские информационные системы"
     Filename: INJOUR3P.P
      Comment: Кассовый журнал по приходу по документам (чекам) с разбивкой по подразделениям
   Parameters:
         Uses:
      Used by:
      Created: 18/03/2004 Nav
     Modified: 
*/
Form "~n@(#) INJOUR3.P 1.0 Serge 12/08/96 Serge 12/08/96 comment"
with frame sccs-id stream-io width 250.

{globals.i}
{pick-val.i}
{getdate.i}
{tmprecid.def}        /** Используем информацию из броузера */

{empty tmprecid}

do on error undo, return on endkey undo, return:
    run acct.p ("b", 3).
    if return-value = "error" or keyfunc(lastkey) = "END-ERROR" then
       undo, return.
    if not can-find(first tmprecid) then do:
       message "Не выбраны счета!" view-as alert-box.
       undo, retry.
    end.
end.

{setdest.i &cols=96}

def var JourName as char init "ЖУРНАЛ ПО ПРИXОДУ" no-undo.

{jourvtb3.i
           &DESK_ACCT   = acct-db                /* счет кассы                                   */
           &CLNT_ACCT   = acct-cr                /* счет клиента                                 */
           &JOUR_NAME   = JourName
}

{preview.i}
/*************************************************************************************************/
/*
           &no-totl-op  = yes                    /* исключить итоги по операции                  */
           &no-totl-bal = yes                    /* исключить итоги по счету кассы               */
*/
