def var vtxt as char no-undo.
form vtxt skip.
display "쳐컴컴컴컨컴컴컴좔컴좔컴컴컴컴좔컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�" @ vtxt.
if num-db>0 then
   put "� � � � � � :" space(25) num-db form ">>>>>>9" " � " sh-db form ">,>>>,>>>,>>>,>>9.99" space(48) "�" skip.
if num-db=0 then
   put "� � � � � � :" space(25) num-cr form ">>>>>>9" " � " space(17) sh-cr form ">,>>>,>>>,>>>,>>9.99" space(31) "�" skip.
else
   put "�            " space(25) num-cr form ">>>>>>9" " � " space(17) sh-cr form ">,>>>,>>>,>>>,>>9.99" space(31) "�" skip.

put "쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�" skip.

if sh-bal>=0 then
   put "� 몺レㄾ 췅 ぎ�ζ ㄽ� :" space(25) sh-bal form ">,>>>,>>>,>>>,>>9.99" space(48) "�" skip.
else   
   put "� 몺レㄾ 췅 ぎ�ζ ㄽ� :" space(42) - sh-bal form ">,>>>,>>>,>>>,>>9.99" space(31)"�" skip.

put "突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴�" skip.
