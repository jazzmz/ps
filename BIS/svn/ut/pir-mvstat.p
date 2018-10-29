/**********************************************
 * ��ࠡ�⪠ ��� ��७�� �������⥫쭮��     *
 * ४����� "����⨪�" �� ������.         *
 **********************************************
 * ���� : ��᫮� �. �. Maslov D. A.          *
 * ���  : 11.07.13                           *
 * ���: #3397                              *
 **********************************************/

 {globals.i}
 {tmprecid.def}
 {intrface.get xclass}
 {intrface.get db2l}

 DEF VAR currStatUnit AS CHAR NO-UNDO.

{setdest.i}

  FOR EACH signs WHERE signs.file-name = "acct" 
                   AND signs.code = "����⨪�" 
                   AND CAN-DO("!,*",xattr-value) NO-LOCK,
   FIRST acct WHERE acct.acct = ENTRY(1,signs.surrogate) NO-LOCK:

   currStatUnit = getXAttrValueEx("acct",GetSurrogateBuffer("acct",BUFFER acct:HANDLE),"����⨪�",?).

   CASE acct.cust-cat:

      WHEN "�" THEN DO:
             PUT UNFORMATTED "������ 䨧. ���" SKIP.
          UpdateSigns("person",STRING(acct.cust-id),"����⨪�",currStatUnit,?).
      END.

      WHEN "�" THEN DO:
             PUT UNFORMATTED "������ ��. ���" SKIP.
          UpdateSigns("cust-corp",STRING(acct.cust-id),"����⨪�",currStatUnit,?).
      END.

   END CASE.

   PUT UNFORMATTED acct.acct "=" currStatUnit SKIP.

 END.

{preview.i}

{intrface.del}