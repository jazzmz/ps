{pirsavelog.p}
/***************************************************************************/
function GetCBDocType1 returns char /* �����頥� ��-�� ��� ���㬥��     */
         (input in-doc-type as char): /* doc-type.doc-type */
  find first doc-type where doc-type.doc-type = in-doc-type no-lock no-error.
  return if avail doc-type then doc-type.digital else in-doc-type.
end function.
/***************************************************************************/

{stmt-r.i
   &nodetail = yes
   &cnt=16
   &header=stmtpt1.h
   &footer=stmtpt1.f
   &body=stmtpt3.b
   &nodate=yes
   &fcnt=6
   &fstr   = "�������������������������������������������������������������������������������������������������������������������;"
   &linezo = "����� �������������� ������� ��������������������������������������������������������������������������������������Ĵ"
   &detwidth=39
}
