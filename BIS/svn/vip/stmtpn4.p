{pirsavelog.p}
{gt-good.i}
/***************************************************************************/
function GetCBDocType1 returns char /* �����頥� ��-�� ��� ���㬥��     */
         (input in-doc-type as char): /* doc-type.doc-type */
  find first doc-type where doc-type.doc-type = in-doc-type no-lock no-error.
  return if avail doc-type then doc-type.digital else in-doc-type.
end function.
/***************************************************************************/

{stmt-c.i
   &nodetail = yes
   &cnt=17
   &in-format="->>,>>>,>>>,>>>,>>9.99"
   &EquivalentInBracket = ()
   &header=stmtpn4.h
   &footer=stmtpn4.f
   &body=stmtpn4.b
   &initvars="stmtpn2.v "
   &fcnt=7
   &fstr   ="�������������������������������������������������������������������������������������������������������������������;"
   &LINEZO ="������� �������������� ������� ������������������������������������������������������������������������������������Ĵ"
   &detwidth=26
}
