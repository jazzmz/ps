{pirsavelog.p}

/*
                           ОАО АКБ АВТОБАНК
          ***   Отдел Программного Обеспечения Филиалов   ***

   Назначение  :     Показывает удаленные за задаваемый период документы
   
   Параметры   :   


  Используемые
  инклюд-файлы :

  Используется
  в процедурах :

   Создание    :      23.01.2004 г.   [AK] - knalebor

   Исправление :


*/
/*
      Программа выдает ведомость удаленных документов

*/
   
def var spisok as c no-undo.
def var spis-entry as c no-undo.
def var spis-bank as c no-undo.
def var spis-impexp as c no-undo.
def var cur-op-trans like op.op-transaction no-undo.
def var cur-op-date like op.op-date no-undo.
def var dddate like op.op-date no-undo.
def var nhi like history.field-ref no-undo.
def var dhi like history.modif-date no-undo.
def var thi like history.modif-time no-undo.
def buffer xop for op.
def var j as int no-undo.
def var i as int no-undo.
def var str as c no-undo.
def var zna as c no-undo.
def buffer bhis for history.

def temp-table oop NO-UNDO like op.
def temp-table oope NO-UNDO like op-entry.

{globals.def}
{globals.i}
pause 0.
/***********************************************************************/
DEF VAR sinc1     AS DATE    NO-UNDO LABEL "Удален  с" init today.
DEF VAR sinc2     AS DATE    NO-UNDO LABEL "Удален по" init today.
DEF VAR opers     AS LOGICAL NO-UNDO LABEL "Режим выбора"
    VIEW-AS RADIO-SET RADIO-BUTTONS
     " все удаленные документы"                       , YES,
     " выбор документов по маске счета и сумме"       , NO.

DEF VAR mask as char label "Маска счетов" format "x(41)" init "*" no-undo .
        

DEF VAR sum1  AS dec NO-UNDO LABEL "сумма от" 
 init 0 format "->>>>>>>>>>>9.99".
DEF VAR sum2  AS dec NO-UNDO  LABEL "сумма до" 
 init 999999999.99 format "->>>>>>>>>>>>>9.99".

DEFINE FRAME d  SKIP(1)
  sinc1   HELP "Начало периода, в который было производено удаление" SKIP(1)
  sinc2   HELP "Конец  периода, в который было производено удаление" SKIP(1)
  opers   HELP "Режим настройки"                                     SKIP(1)
  mask    HELP "Маска счета, сравнивается со счетом  по дебету или по кредиту " SKIP(1)
  sum1    AT 15  HELP "Задайте нижний  предел суммы проводки"         SKIP(1)
  sum2    AT 15  HELP "Задайте верхний предел суммы проводки"         SKIP(1)
WITH CENTERED ROW 5 OVERLAY SIDE-LABELS 1 COL
        TITLE COLOR bright-white "[ Ведомость удаленных документов ]".

ON "VALUE-CHANGED" OF opers IN FRAME d DO:
  ASSIGN
    mask   :VISIBLE = (INPUT opers = NO)
    sum1   :VISIBLE = (INPUT opers = NO).
    sum2   :VISIBLE = (INPUT opers = NO).
END.

ON "ENTER" OF opers, mask, sum1, sum2 IN FRAME d DO:
  APPLY "Tab" TO SELF.
END.
  PAUSE 0.
  update
    sinc1
    sinc2
    opers
    mask
    sum1
    sum2
  WITH FRAME d.
hide frame d.
/************************************************************************/

{setdest.i}
/**** Проверяем, есть ли удаленные документы в этом периоде ****/
if not can-find (first history where history.file-name = "op" and
  history.modif-date <= sinc2 and history.modif-date >= sinc1 
and   history.modify = "d") then do:
  message
    "За данный  период документы не удалялись"
    view-as alert-box.
  return.
end.

put unformatted
"               ВЕДОМОСТЬ УДАЛЕННЫХ ДОКУМЕНТОВ" skip
fill("-",50) skip 
"| КТО | Дата док |Номер д.|   ДБ                |    Кр"
 "               |Дата и время уд-ия|Сумма руб/вал |" 
skip
fill("-",70) skip.

/****************************************************/

for each history where history.file-name = "op" and
    history.modif-date <= sinc2 and history.modif-date >= sinc1 and
    history.modify = "D"   /* D - удаленные */
 no-lock   use-index file-date-time:

  assign
    nhi = history.field-ref
    dhi = history.modif-date
    thi = history.modif-time
    spisok = history.field-value.
  j = j + 1.

  /* Создаем документ, затем проводки */
  create oop.
/*
  find last xop use-index op no-lock no-error.
  j = if avail xop and xop.op ne ? then xop.op + 1 else 1.
  release xop.
  do on error undo, retry:
    if retry then do:
      hide message no-pause.
      j = j + 1.
    end.
    assign oop.op = j.
  end.
******************************************************************/

  do i = 1 to (num-entries(spisok)) / 2:
    assign
      str = entry((i + i - 1),spisok)
      zna = entry((i + i),spisok).
    case str:
    when  "acct-cat"    then   oop.acct-cat      = string(zna).
    when "ben-acct"     then   oop.ben-acct      = string(zna).
    when "branch-id"    then   oop.branch-id     = string(zna).
    when "Class-Code"   then   oop.Class-Code    = string(zna).
    when "contract-date" then  oop.contract-date = date(zna).
    when "details"      then   oop.details       = string(zna).
    when "doc-date"     then   oop.doc-date      = date(zna).
    when "doc-kind"     then   oop.doc-kind      = string(zna).
    when "doc-num"      then   oop.doc-num       = string(zna).
    when "doc-type"     then   oop.doc-type      = string(zna).
    when "due-date"     then   oop.due-date      = date(zna).
    when "inn"          then   oop.inn           = string(zna).
    when "ins-date"     then   oop.ins-date      = date(zna).
    when "misc[1]"      then   oop.misc[1]       = string(zna).
    when "misc[2]"      then   oop.misc[2]       = string(zna).
    when "name-ben"     then   oop.name-ben      = string(zna).
    when "op"           then   oop.op            = int(zna) . 
    when "op-date"      then   oop.op-date       = date(zna) .
    when "op-error"     then   oop.op-error      = string(zna).
    when "op-kind"      then   oop.op-kind       = string(zna).
    when "op-status"    then   oop.op-status     = "0".
    when "op-template"  then   oop.op-template   = int(zna).
    when "op-transaction" then oop.op-transaction = int(zna).
    when "op-value-date" then  oop.op-value-date = date(zna).
    when "order-pay"    then   oop.order-pay     = string(zna).
    when "user-id"      then   oop.user-id       = string(zna).
    when "user-inspector" then oop.user-inspector = string(zna).
    end case.
  end.
 /***-------------------------------------------------------***/
 for each bhis where    bhis.file-name = "op-entry" and
    bhis.modif-date = dhi and bhis.modif-time = thi and
    bhis.modify = "D" no-lock :
  
  spis-entry  = bhis.field-value.
  create oope.
  do i = 1 to (num-entries(spis-entry)) / 2:
    assign
      str = entry((i + i - 1),spis-entry)
      zna = entry((i + i),spis-entry).
    case str:
    when  "acct-cat" then oope.acct-cat =  zna.
    when "acct-cr"then oope.acct-cr =  zna.
    when "acct-db" then oope.acct-db =  zna.
    when "amt-cur" then oope.amt-cur = dec(zna).
    when "amt-rub" then oope.amt-rub = dec(zna).
    when "Class-Code" then oope.Class-code =  zna.
    when "currency" then oope.currency =  zna.
    when "kau-cr" then oope.kau-cr =  zna.
    when "kau-db" then oope.kau-db =  zna.
    when "op" then if int(zna) = oop.op then oope.op = oop.op. else
            oope.op = 0.
    when "op-cod" then oope.op-cod =  zna.
    when "op-date" then oope.op-date = ?.
    when "op-entry" then oope.op-entry = int(zna).
    when "op-status" then oope.op-status =  oop.op-status.
    when "prev-year" then oope.prev-year = (zna = "yes").
    when "qty" then oope.qty = dec(zna).
    when "symbol" then oope.symbol =  zna.
    when "type" then oope.type =  zna.
    when "user-id" then oope.user-id = zna.
    when "value-date" then oope.value-date = date(zna).
    end case.
  end.
  if oope.op = 0 then do: delete oope.
       end.
  else do:
   
   if opers                                                                          
     or (avail oope                                                                  
           and (can-do(mask,oope.acct-cr) or can-do(mask,oope.acct-db))              
           and (oope.amt-rub >= sum1 and oope.amt-rub <= sum2))                      
                                                                                     
   then do:                                                                          
      put unformatted                                                                
   
        "|"  history.user-id format "x(5)" "| "  oop.op-date                         
        if oop.op-date = ?  then "0/00/00" ELSE ""  " |"                             
        oop.doc-num format "x(7)" " |".                                              
        if avail oope then put unformatted                                           
          oope.acct-db format "x(20)" " |"                                           
          oope.acct-cr  format "x(20)" " |" .                                        
        else put unformatted "                     |                     |" .        
      put unformatted history.modif-date " "                                         
        string(history.modif-time,"hh:mm:ss") " |" .                                 
        if avail oope then put unformatted   oope.amt-rub "|" oope.amt-cur "|".      
      put unformatted      skip.                                                     
   end.                                                                              
   
   assign spisok = " " spis-entry = " " spis-bank = " " spis-impexp = " ".
  end.
 end.   /* закончено создание op-entry  */


  /* display op.doc-num dddate with centered overlay row 5 no-labels down
  frame qq1000
    title "Восстановленные документы".
    down with frame qq1000. */

end.
{preview.i}

