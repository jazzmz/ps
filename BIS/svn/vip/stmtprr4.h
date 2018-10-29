{capsif.i}
{get-bankname.i}
name-bank = cBankname.
   def var db-rub    as char form "x" no-undo.
   def var cr-rub    as char form "x" no-undo.
   def var doubl-chr as char no-undo.
   def var str       as char form "x(60)" no-undo.

   if doubl-v1
   then doubl-chr = trim(ts.name-vip) + " - ��������".
   else doubl-chr = string(" ","x(3)") + "������� �� �������� �����".

   str    = trim(prrate) + " " + icur.

   form
    "�" space(0) stmt.op-date  form "99.99.99"     space(0)
    "�" space(0) stmt.doc-num  form "x(6)"         space(0)
    "�" space(0) stmt.doc-type form "x(3)"         space(0)
    "�" space(0) sacctcur      form "x(20)"        space(0)
    "�" space(0) db-rub        form "x(23)"        space(0)
    "�" space(0) cr-rub        form "x(23)"        space(0)
    "�" space(0) detarr[1] form "x({&detwidth})"   space(0) "�"

   header
   skip(4)
    "�������������������������������������������������������������������������������������������������������������������͸" skip
    "�                                                                                              �ਫ������ N 3 � ��  �" skip
    "�"      name-bank  form "x(95)"                                                                                    "�" at 117 skip
    "�"                                                                                                                 "�" at 117 skip
    "�                                         ������� �������᪮�� ���                                              �" skip
    "�                                              ��" {term2str beg dob} format "x(25)"                               "�" at 117 skip
    "�"                                                                                                                 "�" at 117 skip
    "�       �����ᮢ� ��� : " long-acct format "x(25)"                                                               "�" at 117 skip
    "�"                                                                                                                 "�" at 117 skip
    "� �室�騩 ���� :" str                                                                                             "�" at 117 skip
    "� ���줮 �� ��砫� ��ਮ�� :" incd at 43 inck at 67                                                                "�" at 117 skip
    "�������������������������������������������������������������������������������������������������������������������Ĵ" skip
    "�  ���  � ����ೊ���  ����ᯮ������騩 �                    ������                    �   ����ঠ��� ����樨    �" skip
    "�����.��ﳤ���.�����        ���        �          �����                  �।��        �                          �" skip
    "�������������������������������������������������������������������������������������������������������������������Ĵ" skip
   with no-label no-underline.