
def var vtxt as char no-undo.
form vtxt skip.
display "รฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด" @ vtxt.
if num-db>0 then
   put "ณ  โ ฎ ฃ ฎ :" space(25) num-db form ">>>>>>9" "  " sh-db form ">,>>>,>>>,>>>,>>9.99" space(48) "ณ" skip.
if num-db=0 then
   put "ณ  โ ฎ ฃ ฎ :" space(25) num-cr form ">>>>>>9" "  " space(17) sh-cr form ">,>>>,>>>,>>>,>>9.99" space(31) "ณ" skip.
else
   put "ณ            " space(25) num-cr form ">>>>>>9" "  " space(17) sh-cr form ">,>>>,>>>,>>>,>>9.99" space(31) "ณ" skip.

put "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด" skip.

if sh-bal>=0 then
   put "ณ ‘ ซ์คฎ ญ  ชฎญฅๆ คญ๏ :" space(25) sh-bal form ">,>>>,>>>,>>>,>>9.99" space(48) "ณ" skip.
else   
   put "ณ ‘ ซ์คฎ ญ  ชฎญฅๆ คญ๏ :" space(42) - sh-bal form ">,>>>,>>>,>>>,>>9.99" space(31)"ณ" skip.

put "ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ" skip.

   if doubl-v1 then
      put skip(3) "ซ ขญ๋ฉ กใๅฃ ซโฅเ " cBankName FORMAT "x(30)" "_____________________ " FGetSetting("”ใๅ",?,"") FORMAT "x(35)" skip.
