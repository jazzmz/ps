
def var vtxt as char no-undo.
form vtxt skip.
disp "รฤฤฤฤฤฤมฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด" @ vtxt.
if num-db>0 then
   put "ณ  โ ฎ ฃ ฎ :" space(16) num-db form ">>>>>>9" "  " sh-db form ">,>>>,>>>,>>>,>>9.99" space(57) "ณ" skip.
if num-db=0 then
   put "ณ  โ ฎ ฃ ฎ :" space(16) num-cr form ">>>>>>9" "  " space(17) sh-cr form ">,>>>,>>>,>>>,>>9.99" space(40) "ณ" skip.
else
   put "ณ            " space(16) num-cr form ">>>>>>9" "  " space(17) sh-cr form ">,>>>,>>>,>>>,>>9.99" space(40) "ณ" skip.

put "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด" skip.

if sh-bal>=0 then
   put "ณ ‘ ซ์คฎ ญ  ชฎญฅๆ คญ๏ :" space(16) sh-bal form ">,>>>,>>>,>>>,>>9.99" space(57) "ณ" skip.
else   
   put "ณ ‘ ซ์คฎ ญ  ชฎญฅๆ คญ๏ :" space(33) - sh-bal form ">,>>>,>>>,>>>,>>9.99" space(40) "ณ" skip.

put "ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ" skip.

   if doubl-v1 then
      put skip(3) "ซ ขญ๋ฉ กใๅฃ ซโฅเ " cBankName FORMAT "x(30)" "_____________________ " FGetSetting("”ใๅ",?,"") FORMAT "x(35)" skip.
