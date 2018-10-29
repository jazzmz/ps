/* pir_tmp_upd_xattr.p для f808_spr проставляем ДР значением из параметра по фильтру проводок */

{pirsavelog.p}

DEFINE INPUT PARAM ip AS CHAR.

{globals.i}           /* Глобальные определения */
{tmprecid.def}        /** Используем информацию из броузера */
{intrface.get xclass} /* Функции для работы с метасхемой */
{intrface.get strng}  /* Функции для работы со строками */

FOR EACH tmprecid
   NO-LOCK,
   EACH op-entry
      WHERE recid(op-entry) = tmprecid.id
   NO-LOCK
:
/*   cDR = GetXAttrValue("op-entry", STRING(oe.op) + "," + STRING(oe.op-entry)
			, "ПричИзмРезерва").
*/
   IF NOT UpdateSigns ("op-entry", STRING(op-entry.op) + "," + STRING(op-entry.op-entry)
			, "ПричИзмРезерва", ip + "=" + REPLACE(STRING(op-entry.amt-rub, ">>>>>>>>>>9.99"), " ", ""), NO)
   THEN DO:

   END.
END.

{intrface.del}
