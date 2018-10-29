/* #4304 
  Загрузка графика платежей ОД по договору 46/12
Автор: Никитина Ю.А.
*/

{globals.i}
def temp-table tmptermobl no-undo like term-obl. 

temp-table tmptermobl:read-xml("file","./46_12_gr.xml","empty",?,?,?,?).

for each term-obl WHERE term-obl.cont-code EQ '46/12' AND term-obl.contract EQ 'Кредит' AND term-obl.idnt EQ 3:
   delete term-obl.
end.

for each tmptermobl no-lock: 
   create term-obl.
   BUFFER-COPY tmptermobl to term-obl.
end.
