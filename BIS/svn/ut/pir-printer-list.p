/**************************************************
 *
 * ���� �� �ਭ�ࠬ ��� "��᪢��" � ������
 * ��������� ���祭�� ���� ४�����
 *
 **************************************************
 * ����: ��᫮� �. �.
 * ��� ᮧ�����: 02.11.2010
 * ���: #494
 **************************************************/

{globals.i}
DEF VAR cPrinterLocation AS CHARACTER NO-UNDO.
DEF VAR cPrinterName     AS CHARACTER INITIAL "" NO-UNDO.
DEF VAR oldPrinterName   AS CHARACTER INITIAL "" NO-UNDO.

DEF VAR oTable AS TTable NO-UNDO.

oTable = new TTable(2).
oTable:addRow().
oTable:addCell("�������� �ਭ��").
oTable:addCell("��ᯮ�������").
oTable:setAlign(1,1,"center").
oTable:setAlign(2,1,"center").

FOR EACH printer NO-LOCK:
  cPrinterName  = printer.printer.
  cPrinterLocation = getXAttrValue("printer",printer.printer + "," + STRING(printer.page-cols),"�ਬ�砭��").
 IF (cPrinterLocation NE ? AND cPrinterLocation NE "" AND cPrinterName <> oldPrinterName) THEN
   DO:
     oTable:addRow().
      oTable:addCell(cPrinterName).
      oTable:addCell(cPrinterLocation).
   END.
     oldPrinterName = cPrinterName.
END.
{setdest.i}
 oTable:show().
{preview.i}
DELETE OBJECT oTable.