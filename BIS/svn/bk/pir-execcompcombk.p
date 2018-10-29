/************************************************
 * ��楤�� ���⮫� �����ᨨ.                                   *
 ************************************************
 * ����: ��᫮� �. �.                                                      *
 * ��� ᮧ�����: 11:41 06.05.2010                                   *
 * ���: #223                                                                    *
 ************************************************/
{tmprecid.def}

DEF VAR oCompComBK AS TiBankComission  No-Undo.

/***********************************************
 *  ���㦠�� ����� �� ���.                                     *
 * � ABL ����� � ������                                              *
 * ������� ����� � shared                                            *
 * ��६���� ���⮬� ��� ��᮪                              *
 * �� ���� �������� � ����� TiBankComission           *
************************************************/

DEF VAR firstSource AS CHARACTER INITIAL "/home2/bis/quit41d/imp-exp/bifit/vigr.xml"  No-Undo.

DEF VAR httTable AS HANDLE  No-Undo.

CREATE TEMP-TABLE httTable.
 httTable:ADD-NEW-FIELD("cAcct","CHARACTER",0,"cAcct","").
 httTable:TEMP-TABLE-PREPARE("httTable").

     FOR EACH tmprecid, 
        FIRST op WHERE tmprecid.id = RECID(op), 
            FIRST op-entry WHERE op-entry.op = op.op:

                     /* �� �ᥬ �⮡࠭�� ���㬥�⠬ */
                    httTable:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE().
                    httTable::cAcct = op-entry.acct-db.

END.
httTable:WRITE-XML("FILE",firstSource,?,?,?,?).

/*EMPTY TEMP-TABLE httTable.*/
httTable = ?.
/***************** ����� �������� ������ **********************/

/***************** �������� � �������� ��������� *****************/

oCompComBK = new TiBankComission().
oCompComBK:firstSource = firstSource.
oCompComBK:secSource = "/home2/bis/quit41d/imp-exp/bifit/res.xml".


{setdest.i}
   oCompComBK:exec().
{preview.i}

DELETE OBJECT oCompComBK.