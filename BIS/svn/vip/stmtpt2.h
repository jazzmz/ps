{capsif.i}
{get-bankname.i}
name-bank = cBankname.
   def var db-rub as char no-undo.
   def var cr-rub as char no-undo.
   def var doubl-chr as char no-undo.

   if doubl-v1 then doubl-chr = trim(ts.name-vip) + " - ��������".
               else doubl-chr = string(" ","x(3)") + trim(ts.name-vip).
   prrate = trim(prrate) + " " + icur.
   form
    "�" space(0) stmt.doc-num  form "x(6)"         space(0)
    "�" space(0) stmt.doc-type form "x(3)"         space(0)
    "�" space(0) sacctcur    form "x(20)"        space(0)
    "�" space(0) db-rub      form "x(23)"        space(0) 
    "�" space(0) cr-rub      form "x(23)"        space(0) 
    "�" space(0) detarr[1] form "x({&detwidth})" space(0) "�"
   header
   skip(4)
    "�������������������������������������������������������������������������������������������������������������������͸" skip
    "�"      name-bank  form "x(95)" today form "99.99.99" string(time,"HH:MM:SS") "�" skip
    "�"                                                                                            "�" at 117 skip
    "�" doubl-chr format "x(37)" long-acct format "x(25)" "��" dob form "99/99/99" cur-page-str to 115 "�" at 117 skip
    "�"                                                                                            "�" at 117 skip
    "� ������������ �������� ��� : " capsif(name[1] + " " + name[2]) format "x(82)"               "�" at 117 skip
    "�" capsif(name[3] + " " + name[4]) format "x(90)"                                               "�" at 117 skip
    "� ��� �।��饩 ����樨:" prevop form "99.99.99" " ��� ������:" new-cur2 icur "�室�騩 ���� :" prrate  "�" at 117 skip
    "� ���줮 �� ��砫� ��� :" incd at 34 inck at 58 space(8) "�" at 117 skip
    "�  (� ���.����������) :" inrd at 34 inrk at 58                                                      "�" at 117 skip
    "�" strcurdif "�" at 117 skip
    "�������������������������������������������������������������������������������������������������������������������Ĵ" skip
    "� ����ೊ���  ����ᯮ������騩 �                    ������                    �        ����ঠ��� ����樨        �" skip
    "�����.�����        ���        �          �����                  �।��        �                                   �" skip
    "�������������������������������������������������������������������������������������������������������������������Ĵ" skip
   with no-label no-underline.