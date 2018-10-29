{tmprecid.def}

/*************************************************
 * ��楤�� �����⢫�� ����஫� �� ����������  *
 * ������ � ����饭�� � �������� ��ਮ�.              *
 *************************************************
 * ����: ��᫮� �. �.
 * ��� ᮧ�����: 16:19 07.09.2010
 * ���: #397
 *************************************************/
{snc-print.prm}
{pir-isdeper.i}

/********  ������� ��� ********/
DEF VAR oTpl AS TTpl.
DEF VAR oTable AS TTable.
DEF VAR i AS INTEGER INITIAL 1.

/******** ��������� ������ *********/
DEF BUFFER b2Packet FOR Packet.

oTpl = new TTpl("pir-checkfromks.tpl").
oTable = new TTable(6).

/*** ���������� ***/

FOR EACH tmprecid,
      FIRST Seance WHERE recid(Seance) EQ tmprecid.id NO-LOCK,
      EACH Packet WHERE Packet.SeanceID EQ Seance.SeanceID AND Packet.ParentID EQ 0 NO-LOCK,
            EACH b2Packet WHERE b2Packet.ParentID EQ Packet.PacketID,
                EACH PackObject WHERE PackObject.PacketID EQ b2Packet.PacketID AND PackObject.file-name="op-entry" NO-LOCK,
                FIRST op-entry WHERE op-entry.op = INTEGER(ENTRY(1,PackObject.surrogate)) AND op-entry.op-entry=INTEGER(ENTRY(2,PackObject.surrogate)) 
                                                           AND CAN-DO("{&maskDepozAcctList397}",op-entry.acct-cr) NO-LOCK,                                  
                FIRST op OF op-entry NO-LOCK:
                /* �� ���� ���������� �� ����� */

                     IF NOT isDepozInPermit(op-entry.acct-cr,op-entry.op-date) THEN
                            DO:

                                               oTable:addRow().
                                                  oTable:addCell(i).
                                                  oTable:addCell(op.doc-num).
                                                  oTable:addCell(op-entry.acct-db).
                                                  oTable:addCell(op-entry.acct-cr).
                                                  oTable:addCell(op-entry.amt-rub).
                                                  oTable:addCell(getPermitDate(op-entry.acct-cr)).
                                                  i = i + 1.
                            END.
 END. /* ����� �� �ᥬ ���㬥�⠬ ३� */
IF oTable:HEIGHT<>0 THEN oTpl:addAnchorValue("TABLE1",oTable). ELSE oTpl:addAnchorValue("TABLE1","*** ��� ������ ***").

{setdest.i}
  oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.