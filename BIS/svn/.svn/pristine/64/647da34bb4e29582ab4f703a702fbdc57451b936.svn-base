{pirsavelog.p}

/*
                           ОАО АКБ АВТОБАНК
          ***   Отдел Программного Обеспечения Филиалов   ***

   Назначение  :

   Параметры   :

  Используемые
  инклюд-файлы :

  Используется
  в процедурах :

   Создание    : Zemskov  01.01.2003 г.
                 на основе dacc.p
   Исправление : ZV 29/04/2004 - for Patch17-00


*/

{globals.i}
def input param contr like loan.contract  no-undo.
def input param contc like loan.cont-code no-undo.
def input param dd    as   int            no-undo.
def input param dd1   as   int            no-undo.
def input param level as   int            no-undo.

def new shared var dat-t as date no-undo.

find loan where
          loan.contract  = contr and
          loan.cont-code = contc
          no-lock no-error.
/* if loan.since <> ? then
  dat-t = loan.since.
else
  dat-t = loan.open-date.  */
if gend-date < loan.open-date then
 dat-t = loan.open-date .
else
 dat-t = gend-date. /*По запросу автобанка*/

a:
repeat:
/*Zemskov-begin*/
/*
  run dacct.p(contr,contc,level).
  if lastkey <> keycode(" ") then leave a.
  run dacct1.p(contr,contc,level).
  if lastkey <> keycode(" ") then leave a.
*/
  run acc1-dps.p(contr,contc,level).
  if lastkey <> keycode(" ") then leave a.
  run acc2-dps.p(contr,contc,level).
  if lastkey <> keycode(" ") then leave a.
/*Zemskov-end*/

end.
