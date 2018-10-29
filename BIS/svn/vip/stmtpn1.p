{pirsavelog.p}
/***************************************************************************/
function GetCBDocType1 returns char /* ฎงขเ ้ ฅโ –-่ญ๋ฉ ชฎค คฎชใฌฅญโ      */
         (input in-doc-type as char): /* doc-type.doc-type */
  find first doc-type where doc-type.doc-type = in-doc-type no-lock no-error.
  return if avail doc-type then doc-type.digital else in-doc-type.
end function.
/***************************************************************************/

{stmt-r.i
   &nodetail = yes
   &cnt=16
   &header=stmtpn1.h
   &footer=stmtpn1.f
   &body=stmtpr3.b
   &nodate=yes
   &fcnt=6
   &fstr   = "ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ"
   &linezo = "รฤฤฤฤ €—’…… ’ ฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
   &detwidth=39
}
