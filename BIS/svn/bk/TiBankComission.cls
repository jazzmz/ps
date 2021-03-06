CLASS TiBankComission IMPLEMENTS ISysComprasion:

/*************************************************************
 *													                                                                   *
 * ���ઠ �����ᨨ ����-������			                                               *
 * 														                                                           *
 * ������:                                                                                                *
 * 1. ���짮��⥫� �� ��娢� ���㬥�⮢ �� 䨫���� �⡨ࠥ�     *
 * ���㬥��� ᯨᠭ�� �����ᨨ;                                                         *
 * 2.  ���室�� � Ctrl + G -> ��孮�����᪨� ����樨 ->             *
 * ���ઠ �����ᨨ ����-������;                                                         *
 * 3. ��楤�� �ନ��� ��������� ��⮢ �� �� �� �����    *
 * ���� ᯨᠭ��;                                                                                         *
 * 4. ����稢���� ��������� ��।����� � ��⠫�� �� �ࢥ�    *
 * �� (�� scp);                                                                                              *
 * 5. ��� ����᪠���� �ਯ� ����஫� �����⮢ �� �����         *
 * ᯨᠭ� �������.                                                                                  *
 * 6. ������� ࠡ��� ���ண� �⮡ࠦ����� �� ��࠭� ���        *
 *************************************************************
 * ����: ��᫮� �. �.                                                                              *
 * ��� ᮧ�����: 10:44 05.05.2010                                                           *
 * ���: #223                                                                                            *
 **************************************************************/

DEF VAR httTable    AS HANDLE NO-UNDO.
DEF PUBLIC VAR oTpl AS TTpl   NO-UNDO.

{set-prop.i &aa="firstSource"  &bb="cfirstSource"  &cc="CHARACTER"}       /* ���� � ����� �������� ����� ��᫥ ���㧪� �� ����   */
{set-prop.i &aa="secSource"   &bb="csecSource"   &cc="CHARACTER"}       /* ���� � ���஬ �����頥��� १���� �� ����-������� */
{set-prop.i &aa="secProvider" &bb="csecProvide" &cc="CHARACTER"}       /* ��������� ������ �� ���� �� ����-������                      */

CONSTRUCTOR TiBankComission():
    oTpl = new TTpl("TiBankComission.tpl").
END CONSTRUCTOR.

METHOD PUBLIC LOGICAL load2First():
			/***********************************
             *                                                                 *
			 * ����砥� ����� �� ���.  		        *
             * ����� ��⥬ ���㦠�� � XML *
             *                                                                 *
             ***********************************/
/*
CREATE TEMP-TABLE httTable.
httTable:ADD-NEW-FIELD("cAcct","CHARACTER",0,"cAcct","").

     FOR EACH tmprecid, 
        FIRST op WHERE tmprecid.id = RECID(op), 
            FIRST op-entry WHERE op-entry.op = op.op:

                     /* �� �ᥬ �⮡࠭�� ���㬥�⠬ */
                    httTable:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE().
                    httTable::cAcct = op-entry.acct-db.

END.
httTable:SAVE-XML("FILE",firstSource,?,?,?,?).

EMPTY TEMP-TABLE httTable.
httTable = ?.
*/
END METHOD.

METHOD PUBLIC LOGICAL load2Second():

                    /********************************************
                     * ����� ����祭�� �� ���,                            *
                     * ��।��� � ����-������. ����᪠�� ⠬       *
                     * ��ࠡ��稪 � ������� �⢥�. ����祭���  *
                     * ���ଠ�� ����頥� � ⠡����.                  *
                     *                                                                                   *
                     *********************************************/
 
    OS-COMMAND SILENT VALUE('scp ' + firstSource + ' mover@ciklop:/tmp/vigr.xml').                              /* �����㥬 䠩� ���㧪� */
/*    OS-COMMAND SILENT VALUE("rm -f " + firstSource).                                                                               /* ����塞 䠩� � ����묨 */*/
    OS-COMMAND SILENT 'ssh mover@ciklop "/usr/local/iBank2Bisquit/bin/getXmlCompCom.php"'.         /* ����᪠�� ���㧪� ������ �� �� */
    OS-COMMAND SILENT VALUE('scp mover@ciklop:/tmp/res.xml ' + secSource).         /* �����㥬 䠩� */
    OS-COMMAND SILENT 'ssh mover@ciklop "rm -f /tmp/res.xml"'.                                                               /* ����塞 䠩� � �� */

    CREATE TEMP-TABLE httTable.                                 /* ������� �६����� ⠡���� � १���⮬ */
    httTable:READ-XML("FILE",secSource,?,?,?,?).       /* ����㦠�� � ��� ����� */

/*    OS-COMMAND SILENT 'rm -f /home2/bis/quit41d/imp-exp/bifit/res.xml'.         /* ����塞 䠩� � ���*/ */

END METHOD.

METHOD PROTECTED VOID inFirstButNotInSec():
                /**********************************************
                 *                                                                                      *
                 * �뢮��� ��� �����⮢ ����� ����                *
                 * � ��, �� � ������ �� �������                       *
                 * �������.                                                                   *
                 *                                                                                      *
                 **********************************************/
    DEF VAR hQuery  AS HANDLE NO-UNDO.
    DEF VAR hBuffer AS HANDLE NO-UNDO.

    DEF VAR oTable AS TTable NO-UNDO.
    oTable = new TTable(2).

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(httTable:DEFAULT-BUFFER-HANDLE).
    hQuery:QUERY-PREPARE("FOR EACH httTable WHERE lStatus='2'").
    hQuery:QUERY-OPEN(). 
    hQuery:GET-FIRST(NO-LOCK).

   hBuffer=hQuery:GET-BUFFER-HANDLE.
    
    REPEAT WHILE NOT hQuery:QUERY-OFF-END:
            oTable:addRow().
               oTable:addCell(hBuffer::iClientId).
               oTable:addCell(hBuffer::cClientName).
             hQuery:GET-NEXT(NO-LOCK).
    END.

  IF oTable:height GT 0 THEN  oTpl:addAnchorValue("TABLE-",oTable). ELSE oTpl:addAnchorValue("TABLE-","*** ������ ��� ***").
END METHOD.

METHOD PROTECTED VOID inSecButNotInFirst():

                /**********************************************
                 *                                                                                        *
                 * �뢮��� ��� �����⮢ �����                           *
                 * �������஢��� � ��, �� � ������  �������  *
                 * �������.                                                                     *
                 *                                                                                        *
                 ***********************************************/

    DEF VAR hQuery  AS HANDLE NO-UNDO.
    DEF VAR hBuffer AS HANDLE NO-UNDO.
    DEF VAR oTable  AS TTable NO-UNDO.
    
    oTable = new TTable(2).

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(httTable:DEFAULT-BUFFER-HANDLE).
    hQuery:QUERY-PREPARE("FOR EACH httTable WHERE lStatus='1'").
    hQuery:QUERY-OPEN(). 
    hQuery:GET-FIRST(NO-LOCK).

   hBuffer=hQuery:GET-BUFFER-HANDLE.
    
    REPEAT WHILE NOT hQuery:QUERY-OFF-END:
            oTable:addRow().
               oTable:addCell(hBuffer::iClientId).
               oTable:addCell(hBuffer::cClientName).
               hQuery:GET-NEXT(NO-LOCK).
    END.

   IF oTable:height GT 0 THEN oTpl:addAnchorValue("TABLE+",oTable). ELSE oTpl:addAnchorValue("TABLE+","*** ������ ��� ***").

END METHOD.

METHOD PUBLIC LOGICAL exec():
load2First().
load2Second().

inFirstButNotInSec().

inSecButNotInFirst().

oTpl:show().

END METHOD.

DESTRUCTOR TiBankComission():
    DELETE OBJECT oTpl.
END DESTRUCTOR.

END CLASS.