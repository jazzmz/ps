
def var vtxt as char no-undo.
form vtxt skip.
disp "�������������������������������������������������������������������������������������������������������������������Ĵ" @ vtxt.
if num-db>0 then
   put "� � � � � � :" space(16) num-db form ">>>>>>9" " � " sh-db form ">,>>>,>>>,>>>,>>9.99" space(57) "�" skip.
if num-db=0 then
   put "� � � � � � :" space(16) num-cr form ">>>>>>9" " � " space(17) sh-cr form ">,>>>,>>>,>>>,>>9.99" space(40) "�" skip.
else
   put "�            " space(16) num-cr form ">>>>>>9" " � " space(17) sh-cr form ">,>>>,>>>,>>>,>>9.99" space(40) "�" skip.

put "�������������������������������������������������������������������������������������������������������������������Ĵ" skip.

if sh-bal>=0 then
   put "� ���줮 �� ����� ��� :" space(16) sh-bal form ">,>>>,>>>,>>>,>>9.99" space(57) "�" skip.
else   
   put "� ���줮 �� ����� ��� :" space(33) - sh-bal form ">,>>>,>>>,>>>,>>9.99" space(40) "�" skip.

put "�������������������������������������������������������������������������������������������������������������������;" skip.

   if doubl-v1 then
      put skip(3) "������ ��壠��� " cBankName FORMAT "x(30)" "_____________________ " FGetSetting("������",?,"") FORMAT "x(35)" skip.
