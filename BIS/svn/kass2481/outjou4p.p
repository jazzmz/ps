{pirsavelog.p}
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1996 ТОО "Банковские информационные системы"
     Filename: OUTJOU3p.P
      Comment: Кассовый журнал по расходу по документам (чекам) разбивка по подразделениям
   Parameters:
         Uses:
      Used by:
      Created: 18/03/2004 Nav
     Modified:

*/
Form "~n@(#) OUTJOUR3.P 1.0 Serge 12/08/96 Serge 12/08/96 comment"
with frame sccs-id stream-io width 250.

{globals.i}
{pick-val.i}
{getdate.i}
{tmprecid.def}        /** Используем информацию из броузера */

do on error undo, return on endkey undo, return:
    run bran#ot.p ("*", 3).
    if return-value = "error" or keyfunc(lastkey) = "END-ERROR" then
       undo, return.
    if not can-find(first tmprecid) then do:
       message "Не выбраны отделения!" view-as alert-box.
       undo, retry.
    end.
end.

{setdest.i &cols=96}

def var JourName as char init "ЖУРНАЛ ПО РАСXОДУ" no-undo.
def var NameGol as char init "КРЕДИТ" no-undo.
def var NameSh as char init "Д-Т" no-undo.

{jourvtb1.i
           &DESK_ACCT   = acct-cr                /* счет кассы                                   */
           &CLNT_ACCT   = acct-db                /* счет клиента                                 */
           &JOUR_NAME   = JourName
           &NAME_GOL    = NameGol
           &NAME_SH     = NameSh
           }

{preview.i}
/*************************************************************************************************/
