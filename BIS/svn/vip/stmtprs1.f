   /******
    * �⥯���� �.�. stmtprs �⠭���⭠� (�������)- ������� ������.��� ������� ��������
    * ᤥ���� �� stmtprr1.f - ��ਠ�� �맮�� [X]�� ��� � ��� �믨᪨ �㡫���
    * �ࠫ ��� ���㬥��, ��� ����� � ����� ��� ����ᯮ�����
    *  ���樠�� �㢨���� �. �.
    * ��� ᮧ����� 27.07.2011
    ******/

def var vtxt as char no-undo.
form vtxt skip.
/* display "�������������������������������������������������������������������������������������������������������������������Ĵ" @ vtxt. */
display "��������������������������������������������������������������������������������Ĵ" @ vtxt.

if (num-db > 0)
then
   put  "� �⮣�:" + STRING(sh-db, ">,>>>,>>>,>>9.99") FORMAT "X(24)" space(21) num-db form ">>>>>>9" " � " space(26) "�" skip.

if (num-db = 0)
then
   put  "� �⮣�:" space(17) sh-cr form ">,>>>,>>>,>>9.99" space(4) num-cr form ">>>>>>9" " � " 	    space(26) "�" skip.
else
   put  "�       " space(17) sh-cr form ">,>>>,>>>,>>9.99" space(4) num-cr form ">>>>>>9" " � " 	    space(26) "�" skip.

put     "��������������������������������������������������������������������������������Ĵ" skip.

if (sh-bal >= 0)
then
   put  "� ���줮 �� ����� ��� :"             sh-bal form ">,>>>,>>>,>>>,>>9.99" space(38)                            "�" skip.
else
   put  "� ���줮 �� ����� ��� :" space(17) - sh-bal form ">,>>>,>>>,>>>,>>9.99" space(21)                            "�" skip.

put     "��������������������������������������������������������������������������������;" skip(1)
        "          �⢥�⢥��� �ᯮ���⥫�     _________________________" skip.