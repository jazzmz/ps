/**********************************************
 * ���� �஢���� ᮮ⢥��⢨� �� acct-send
 * ���� �� �� � �஢����.
 **********************************************
 * 
 * ���� : ��᫮� �. �.
 * ���: #3033
 * ���  : 14.05.13
 **********************************************/
 {globals.i}
 {tmprecid.def}

 {intrface.get db2l}
 {intrface.get xclass}

 
 DEF VAR oTable      AS TTable2 NO-UNDO.

 DEF VAR xAttrAcctDb AS CHAR    NO-UNDO.

 oTable = NEW TTable2().
 oTable:colsHeaderList = "����� ���㬥��,��� ����. ���,��஥ ���祭��,����� ���祭��".

 FOR EACH tmprecid NO-LOCK,
  FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
   FIRST op-entry OF op NO-LOCK:
    xAttrAcctDb = getXAttrValueEx("op",GetSurrogateBuffer("op",BUFFER op:HANDLE),"acct-send","").

   IF xAttrAcctDb <> op-entry.acct-db THEN DO:
     oTable:addRow()
           :addCell(op.doc-num)
           :addCell(op.op-date)
           :addCell(xAttrAcctDb)
           :addCell(op-entry.acct-db)
     .
   END.
   
 END.


 {setdest.i}
  PUT UNFORMATTED "���� �� ���㬥�⠬ � ������ ���� ��ᮮ⢥��⢨� ��� �����" SKIP.
  oTable:show().
  {signatur.i}
 {preview.i}

 DELETE OBJECT oTable.