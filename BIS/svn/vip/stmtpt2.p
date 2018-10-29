{pirsavelog.p}
{gt-good.i}
/***************************************************************************/
function GetCBDocType1 returns char /* ฎงขเ ้ ฅโ –-่ญ๋ฉ ชฎค คฎชใฌฅญโ      */
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
   &header=stmtpt2.h
   &footer=stmtpt2.f
   &body=stmtpt4.b
   &initvars="stmtpt2.v "
   &nodate=yes
   &fcnt=6
   &fstr  ="ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ"
   &linezo="รฤฤฤฤ €—’…… ’ ฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"

   &detwidth=35
}
