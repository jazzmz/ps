{pirsavelog.p}

/* 
               ������᪠� ��⥣�஢����� ��⥬� ������� 
    Copyright: (C) 1992-1996 ��� "������᪨� ���ଠ樮��� ��⥬�" 
     Filename: n_vredps.p
      Comment: �ணࠬ�� ��ᬮ�� ������� ������ 
               �� �����䨪���� ree_dpspr ( �஬������ ॥��� ��易⥫��� ��। �����稪��� ), 
               ᮧ������ ������஬ �ணࠬ� gen-sv1.p. 
         Uses: n_vredps.lf,n_vredps.uf,n_vredps.nav,n_vredps.nau,n_vredps.cal
      Created: 20/08/04 SAP
*/  
DEFINE VARIABLE mCat AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mId  AS INTEGER    NO-UNDO.

{form.def}
{sv-form#.i 
    &prg        = "pirn_vredps"
    &total      = "pirn_vredps.cal "
}

form
   DataLine.Sym1 format "999999999" column-label "����"
         help "���⥬�� ����� 䨧.���"
   DataLine.Sym2 format "x(1)" column-label "�"
         help "��㦥��� ᨬ����"
   DataLine.Sym3 format "x(22)" column-label "����� �������"
         help "����� �������"
   DataLine.Sym4 format "x(9)" column-label "���.�����"
         help "�������樮��� ����� ����� (䨫����)"
   Txt[1]  format "x(30)" column-label "���"
         help "������� ��� ����⢮"
   Txt[2]  format "x(30)" column-label "����"
         help "��������� ����"
   Txt[3]  format "x(3)" column-label "���"
         help "��� ���� ���㬥��"
   Txt[4]  format "x(15)" column-label "����� ���."
         help "���� � ����� ���㬥��"
   Txt[5]  format "x(40)" column-label "�뤠�"
         help "��� �뤠�"
/*   Txt[9]  format "x(10)" column-label "���!�뤠�"
         help "��� �뤠� ���㬥��"
*/
   Txt[6]  format "x(10)" column-label "��� ���."
         help "��� ������� ������"
   Txt[7]  format "x(20)" column-label "���"
         help "����� ��楢��� ���"
   Txt[8]  format "x(10)" column-label "����䮭"
         help "����䮭"
   Txt[9]  format "x(10)" column-label "�������"
         help "�������"
   Txt[10]  format "x(10)" column-label "E-mail"
         help "�����஭��� ����"
   Txt[11]  format "x(20)" column-label "����"
         help "���⮢� ����"
	 
   DataLine.Val[1]  format ">>>,>>>,>>>,>>9.99" column-label "�㬬� � �����"
         help "�㬬� � ����� ���"
   DataLine.Val[2]  format "->>>,>>>,>>>,>>9.99" column-label "�㬬� � �㡫��"
         help "�㬬� � �㡫�� �� �� �����"
with frame browse title color bright-white "[ " + (if avail branch then caps(branch.short-name) else "?") + " - " + caps(DataClass.Name) +       " �� " + caps(per) + " ]" width 320  .

