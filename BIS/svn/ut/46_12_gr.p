/* #4304 
  Выгрузка графика платежей ОД по договору 46/12
*/

{globals.i}
def temp-table tmptermobl no-undo like term-obl. 

for each term-obl WHERE term-obl.cont-code EQ '46/12' AND term-obl.contract EQ 'Кредит' AND term-obl.idnt EQ 3 NO-LOCK:
   create tmptermobl. 
   BUFFER-COPY term-obl to tmptermobl.
end.

TEMP-TABLE tmptermobl:WRITE-XML("file","./46_12_gr.xml",YES,?,?,NO,NO).