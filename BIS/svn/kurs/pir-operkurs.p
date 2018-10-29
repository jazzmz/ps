using Progress.Lang.*.
/***********************************************************
 *                                                                                                                *
 * ��楤�� �ନ��� �ᯮ�殮��� �� ������᪨�                *
 * ���ᠬ.                                                                                                  *
 * �⭮���� � �࠭���樨 ��->��->Insert->������ᨮ���    *
 * ����樨 -> (�������) ������������� ��������     *
 * -> �த���/���㯪� (�� �㡫�)                                                        *
 * �।����������, �� ���짮��⥫� ᠬ����⥫쭮
 * � ������� 䨫��� �⡥�� �஢����
 *                                                                                                                 *
 ************************************************************
 * ����: ��᫮� �. �.                                                                          *
 * ��� ᮧ�����: 16:42 11.05.2010                                                       *
 * ���: #315                                                                                        *
 ***********************************************************/

{tmprecid.def}
{globals.i}
/*****
 !!! �������� !!!! 
�: ���� �� ���㬥�⮢ �� �������� � ����. �� ������?
�: �஢���� ����� �����祭�� �⮨� � ������᪮�� ���. ������ ���� ���� �� ᯨ᪠ SettlementAccountSign
*****/

&SCOPED-DEFINE SettlementAccountSign �����*,�����*,�����*
&SCOPED-DEFINE CommDb ��������
&SCOPED-DEFINE CommCr ��������
&SCOPED-DEFINE kursXAttrName sprate


DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oTable AS TTable NO-UNDO.

DEF VAR oDocument AS TDocument NO-UNDO.
DEF VAR oClient AS TClient NO-UNDO.

DEF VAR iType AS INTEGER INITIAL 2 NO-UNDO.          /* ������⢮ ����� */
DEF VAR i AS INTEGER NO-UNDO.                               

DEF VAR dCurrDate AS DATE NO-UNDO.                  /* ������ ��� */
DEF VAR oSysClass AS TSysClass NO-UNDO.

dCurrDate=gend-date.

oSysClass = new TSysClass().

oTpl = new TTpl("pir-operkurs.tpl").

oTable = new TTable(5 * iType ).
oTable:addRow().
oTable:addCell("�㬬�").
oTable:addCell("���").
oTable:addCell("������������ ������").
oTable:addCell("���").
oTable:addCell("����").
oTable:addCell("�㬬�").
oTable:addCell("���").
oTable:addCell("������������ ������").
oTable:addCell("���").
oTable:addCell("����").


DEF TEMP-TABLE ttRecidEx NO-UNDO
                                     FIELD id AS RECID
                                     FIELD type AS INTEGER
                                     FIELD mark AS LOGICAL
                                     FIELD sum LIKE op-entry.amt-cur
                                     FIELD currency LIKE op-entry.currency
                                     FIELD name-short AS CHARACTER
                                     FIELD comission AS DECIMAL
                                     FIELD k AS DECIMAL
                                .

DEF BUFFER bfrttRecidEx FOR ttRecidEx.

DEF VAR oAcct-Db AS TAcctBal NO-UNDO.
DEF VAR oAcct-Cr AS TAcctBal NO-UNDO.

/********** ���������� ���������� �������� �� ����� ********/

FOR EACH tmprecid,
        FIRST op-entry WHERE RECID(op-entry) = tmprecid.id NO-LOCK,
            FIRST op OF op-entry NO-LOCK:

            oDocument = new TDocument(op.op).
            oAcct-Cr = new TAcctBal(op-entry.acct-cr).

            IF CAN-DO("{&SettlementAccountSign}",oAcct-Cr:getXAttr("�����")) AND oAcct-Cr:val EQ 810  THEN 
                  DO:
                               /* �� �।��� �⮨� ������᪨� �㡫��� ���, ����� �� �த��� ������ */
                              CREATE ttRecidEx.
                                  ASSIGN  
                                       ttRecidEx.id = tmprecid.id
                                       ttRecidEx.type = 1
                                       ttRecidEx.mark = FALSE
                                       ttRecidEx.sum = op-entry.amt-cur
                                       ttRecidEx.currency = op-entry.currency
                                       ttRecidEx.name-short = oAcct-Cr:name-short
                                       ttRecidEx.comission = (DECIMAL(oDocument:getXAttr("PirConvComm")) * 100)
                                       ttRecidEx.k = DECIMAL(oDocument:getXAttr("{&kursXAttrName}"))                                       
                                   .
                   END.
            ELSE
                IF CAN-DO("{&SettlementAccountSign}",oAcct-Cr:getXAttr("�����"))  AND oAcct-Cr:val <> 810 THEN
                    DO:
                              /* �� �।��� �⮨� ������᪨� ������ ��� ����� �� ���㯪� ������ */
                           CREATE ttRecidEx.
                              ASSIGN
                                   ttRecidEx.id = tmprecid.id
                                   ttRecidEx.type = 2
                                   ttRecidEx.mark = FALSE
                                   ttRecidEx.sum = op-entry.amt-cur
                                   ttRecidEx.currency = op-entry.currency
                                   ttRecidEx.name-short = oAcct-Cr:name-short
                                   ttRecidEx.comission = (DECIMAL(oDocument:getXAttr("PirConvComm")) * 100)
                                   ttRecidEx.k = DECIMAL(oDocument:getXAttr("{&kursXAttrName}"))
                                  .
                      END.

        DELETE OBJECT oAcct-Cr.
        DELETE OBJECT oDocument.
END.

/*************** ����� ���������� �� ����� ***********/


/*********** ������������ �������� �� ����� **************/

DO WHILE CAN-FIND(FIRST ttRecidEx WHERE ttRecidEx.mark = FALSE):
                /* �� �� ��� ������ ��� �� ���� �� ����祭�� */
            oTable:addRow().

                DO i = 1 TO iType:
                    /* �ந������ ࠧ����� �� ⨯�� */

                    FIND FIRST ttRecidEx WHERE ttRecidEx.type = i AND ttRecidEx.mark = FALSE NO-LOCK NO-ERROR.

                    IF AVAILABLE(ttRecidEx) THEN
                                    DO:
                                            oTable:addCell(ttRecidEx.sum).
                                            oTable:addCell(ttRecidEx.currency).
                                            oTable:addCell(ttRecidEx.name-short).
                                            oTable:addCell(ttRecidEx.comission).
                                            oTable:addCell(ttRecidEx.k).
                                            ttRecidEx.mark = TRUE.                     /* ����砥� ��� �⮡ࠦ���� */
                                    END.
                                    ELSE 
                                        DO:
                                            oTable:addCell("").
                                            oTable:addCell("").
                                            oTable:addCell("").
                                            oTable:addCell("").
                                            oTable:addCell("").
                                        END.

                  END.
END.

/************** ����� �������� �� ����� *********************/

oTpl:addAnchorValue("TABLE1",oTable).

oTpl:addAnchorValue("DATE",gend-date).

oTpl:addAnchorValue("����1",oSysClass:getCBRKurs(840,gend-date)).
oTpl:addAnchorValue("����2",oSysClass:getCBRKurs(978,gend-date)).
oTpl:addAnchorValue("����3",oSysClass:getCBRKurs(826,gend-date)).


{setdest.i}
  oTpl:show().
{preview.i}

DELETE OBJECT oTable. 
DELETE OBJECT oSysClass.