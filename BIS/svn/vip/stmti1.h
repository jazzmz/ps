   {capsif.i}
   def var doubl-chr as char no-undo.

   if doubl-v1 then doubl-chr = trim(ts.name-vip) + " - ��������:".
               else doubl-chr = string(" ","x(3)") + trim(ts.name-vip) + ":".
    form
         "�"
         stmt.doc-num
         stmt.doc-type form "x(3)"
         stmt.symbol form "x(2)"
         stmt.bank-code form "x(9)"
         stmt.corr-acct form "x(25)"
         stmt.ben-acct form "x(25)"
         sacctcur
         sh-db format "->>,>>>,>>>,>>>,>>9.99"
         sh-cr format "->>,>>>,>>>,>>>,>>9.99" "�"
       header
    "������������������������������������������������������������������������������������������������������������������������������������������������������͸" skip
    "�" doubl-chr format "x(37)" long-acct format "x(25)" "  ��" dob form "99/99/99"                                                   cur-page-str to 150 "�" at 152 skip
    "�"                                                                                                                                                    "�" at 152 skip
    "� ������������ �������� ��� : " capsif(name[1] + " " + name[2]) format "x(111)"                                                                    "�" at 152 skip
    "�" capsif(name[3] + " " + name[4]) format "x(111)"                                                                                                    "�" at 152 skip
    "� ������������ ��०����� �����: "      name-bank  format "x(91)"                                                                                     "�" at 152 skip
    "�"                                                                                                                                                    "�" at 152 skip
    "� �।. �믨᪠ ��:" prevop space(55) "���줮 �� ��砫� ���:" prev-db format "x(22)" prev-cr  format "x(22)"                                          "�" skip
    "������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" skip
    "� �����  ��������   ���   �     ����ᯮ�����᪨�   �           ���          �         ��楢��         �             ������ � ���. �����            �" skip
    "� ����. �����  �  �����  �       ���    �����     �      ����ᯮ�����     �           ���          �         �����        �         �।��        �" skip
    "������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" skip
    with no-label no-underline.
