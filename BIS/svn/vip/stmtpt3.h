{capsif.i}
{get-bankname.i}
name-bank = cBankname.
   def var h-str as char no-undo.
   def var doubl-chr as char no-undo.

   if doubl-v1 then doubl-chr = trim(ts.name-vip) + " - ��������".
               else doubl-chr = string(" ","x(3)") + "������� �� �������� �����".
   if prev-db<>"" then
      h-str = fill(" ",21) + prev-db.
   else
      h-str = fill(" ",38) + prev-cr.
   form
        "�" space(0) stmt.op-date form "99.99.99"      space(0)
        "�" space(0) stmt.doc-num form "x(6)"          space(0)
        "�" space(0) stmt.doc-type form "x(3)"         space(0)
        "�" space(0) stmt.bank-code form "x(9)"        space(0)
        "�" space(0) sacctcur form "x(20)"           space(0)
        "�" space(0) sh-db format "->>>>,>>>,>>9.99" space(0)
        "�" space(0) sh-cr format "->>>>,>>>,>>9.99" space(0)
        "�" space(0) detarr[1] form "x({&detwidth})" space(0) "�"
      header
    skip(4)
    "�������������������������������������������������������������������������������������������������������������������͸" skip
    "�"      name-bank  form "x(95)" today form "99.99.99" string(time,"HH:MM:SS") "�" skip
    "�"                                                                                            "�" at 117 skip
    "�" doubl-chr format "x(37)" long-acct format "x(25)" "��" {term2str beg dob} format "x(25)" cur-page-str to 115 "�" at 117 skip
    "�"                                                                                            "�" at 117 skip
    "� ������������ �������� ��� : " capsif(name[1] + " " + name[2]) format "x(82)"               "�" at 117 skip
    "�" capsif(name[3] + " " + name[4]) format "x(90)"                                               "�" at 117 skip
    "� ���줮 �� ��砫� ��� :" h-str form "x(62)" "�।. �믨᪠ �� :" prevop form "99.99.99" "�" skip
    "�������������������������������������������������������������������������������������������������������������������Ĵ" skip
    "�  ���  � ����ೊ���   ���   �  ����ᯮ������騩 �       ������ � ���. �����     �     ����ঠ��� ����樨      �" skip
    "�����.��ﳤ���.�����  �����  �        ���        �      �����            �।��    �                              �" skip
    "�������������������������������������������������������������������������������������������������������������������Ĵ" skip
    with no-label no-underline.                   
