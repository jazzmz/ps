
      def var txtc as char format "x(30)".
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
      /* disp
         "" @ txtc
        formstr("","(" + trim(string(sh-db,"->>,>>>,>>>,>>>,>>9.99")),22) + ")" @ db-rub
        formstr("","(" + trim(string(sh-cr,"->>,>>>,>>>,>>>,>>9.99")),22) + ")" @ cr-rub.
      down.*/           
      put "�������������������������������������������������������������������������������������������������������������������Ĵ".
      down.
      disp
         "���줮 �� ����� ���:" @ txtc
         string(sh-val,  "->>,>>>,>>>,>>>,>>9.99") when sh-val >= 0 @ db-rub
         string(- sh-val,"->>,>>>,>>>,>>>,>>9.99") when sh-val < 0  @ cr-rub.
      down.
      /* disp
         "(� ���.��������):" @ txtc
         formstr("","(" + trim(string(  sh-bal, "->>,>>>,>>>,>>>,>>9.99")),22) + ")"
            when sh-bal >= 0 @ db-rub
         formstr("","(" + trim(string(- sh-bal, "->>,>>>,>>>,>>>,>>9.99")),22) + ")"
            when sh-bal <  0 @ cr-rub.
      down.*/
      strate = trim(strate) + " " + icur.
      put "� ��室�騩 ����: " strate "�" at 117 skip.
      put "�������������������������������������������������������������������������������������������������������������������;" skip.

   if doubl-v1 then
      put skip(3) "������ ��壠��� " cBankName FORMAT "x(30)" "_____________________ " FGetSetting("������",?,"") FORMAT "x(35)" skip.
