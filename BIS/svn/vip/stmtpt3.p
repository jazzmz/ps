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
   &header=stmtpt3.h
   &footer=stmtpt3.f
   &body=stmtpt3.b
   &fcnt=6
   &fstr  ="�������������������������������������������������������������������������������������������������������������������;"
   &LINEZO="��� �������������� ������� ����������������������������������������������������������������������������������������Ĵ"
   &detwidth=30
}
