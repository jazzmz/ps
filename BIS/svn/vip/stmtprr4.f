def var txtc as char format "x(39)".
form "�"
   txtc 
   db-rub form "x(23)" space(1)
   cr-rub form "x(23)" 
   "�" at 117.
put "�������������������������������������������������������������������������������������������������������������������Ĵ".
disp
   "� � � � �  " + trim(string(num-db)) + "�/" + trim(string(num-cr)) + "�:" @ txtc
   string(sh-vdb,"->>,>>>,>>>,>>>,>>9.99") + " " @ db-rub
   string(sh-vcr,"->>,>>>,>>>,>>>,>>9.99") + " " @ cr-rub.
   down.
put "�������������������������������������������������������������������������������������������������������������������Ĵ".
   down.
disp
   "���줮 �� ����� ��ਮ��:" @ txtc
   string(sh-val  ,"->>,>>>,>>>,>>>,>>9.99") when sh-val >= 0 @ db-rub
   string(- sh-val,"->>,>>>,>>>,>>>,>>9.99") when sh-val < 0  @ cr-rub.
   down.
strate = trim(strate) + " " + icur.
put "� ��室�騩 ���� : " strate                                                                                        "�" at 117 skip
    "�������������������������������������������������������������������������������������������������������������������;" skip(1)
    "          �⢥�⢥��� �ᯮ���⥫�     _________________________" skip.