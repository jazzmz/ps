   /******
    * �⥯���� �.�. stmtprs �⠭���⭠� (�������)- ������� ������.��� ������� ��������
    * ᤥ���� �� stmtprr1.p - ��ਠ�� �맮�� [X]�� ��� � ��� �믨᪨ �㡫���
    * �ࠫ ��� ���㬥��, ��� ����� � ����� ��� ����ᯮ�����
    *  ���樠�� �㢨���� �. �.
    * ��� ᮧ����� 27.07.2011
    ******/


{pirsavelog.p}

/***************************************************************************/
function GetCBDocType1 returns char /* �����頥� ��-�� ��� ���㬥��     */
         (input in-doc-type as char): /* doc-type.doc-type */
  find first doc-type where doc-type.doc-type = in-doc-type no-lock no-error.
  return if avail doc-type then doc-type.digital else in-doc-type.
end function.
/***************************************************************************/
/*    &body=stmtpr3.b */

{stmt-r.i
   &nodetail = no
   &cnt=16
   &header=stmtprs1.h
   &footer=stmtprs1.f
   &body=stmtprs3.b
   &fcnt=6
   &fstr   = "�������������������������������������������������������������������������������������������������������������������;"
   &linezo = "����� �������������� ������� ��������������������������������������������������������������������������������������Ĵ"
   &detwidth=39
   &nodate=yes
}
