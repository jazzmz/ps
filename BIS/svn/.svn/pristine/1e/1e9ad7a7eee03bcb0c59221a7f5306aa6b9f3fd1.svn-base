
/*--------------- Определение переменных ---------------*/
Define Variable cBankName        As Character            No-Undo.
Define Variable cClientName      As Character Extent   3 No-Undo.
Define Variable mDay             As Integer              No-Undo.
Define Variable mMonth           As Character            No-Undo.
Define Variable year3            As Integer              No-Undo.

/*--------------- Определение форм для циклов ---------------*/
/* Форма для цикла "header" */
Form
  cBankName format "x(40)" at 40 skip
  "г.Москва" at 40 skip(2)
  "БИК 044585491" at 40 skip(3)
  "Наименование клиента: " at 5 cClientName[1] format "x(63)" skip(1)
  "Настоящим сообщаем, что по состоянию на " at 5 mDay format ">9" /*at 44*/ "-е" /*at 46*/ mMonth format "x(8)" /*at 49*/ year3 format "9999" /*at 62*/ "года остатки на счетах," /*at 57*/ skip
  "открытых в вашем Банке и показанные вами в выписках:" at 5 skip(1)
with frame acctvedh-Frame-1 down no-labels no-underline no-box width 95.

Form
  cBankName format "x(40)" at 40 skip
  "г.Москва" at 40 skip(2)
  "БИК 044585491" at 40 skip(3)
  "Наименование клиента: " at 5 cClientName[1] format "x(63)" skip(1)
  "По состоянию на " at 5 mDay format ">9" /*at 44*/ "-е" /*at 46*/ mMonth format "x(8)" /*at 49*/ year3 format "9999" /*at 62*/ "года остатки на счетах, открытых в вашем Банке" /*at 57*/ skip
  "и показанные вами в выписках:" at 5 skip(1)
with frame acctvedh-Frame-2 down no-labels no-underline no-box width 95.

Def Var FH_acctvedh-1 as integer init 11 no-undo. /* acctvedh-Frame1: мин. строк до перехода на новую страницу */


