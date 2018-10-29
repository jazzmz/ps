/********************************
 * ����.                       *
 * ��� �஢�ન �ࠢ��쭮��,   *
 * ���᫥��� १�ࢠ.          *
 *********************************
 * ����: ��᫮� �. �. (Maslov D. A.)
 * ��� ᮧ�����: ....
 * ���: ....
 ********************************/

DEF VAR oTable    AS TTable    NO-UNDO.
DEF VAR oTableErr AS TTable    NO-UNDO.

DEF VAR oDTInput  AS TDTInput  NO-UNDO.
DEF VAR oTpl           AS TTpl      NO-UNDO.
DEF VAR oAcct     AS TAcct     NO-UNDO.
DEF VAR oUser     AS TUser     NO-UNDO.


DEF BUFFER bAcct FOR acct.

DEF VAR dPos  AS DECIMAL NO-UNDO.
DEF VAR dPos1 AS DECIMAL NO-UNDO.

DEF VAR oDocCollect AS CLASS TDocCollectWPos                            NO-UNDO.
DEF VAR dDifPos            AS DECIMAL INITIAL 0 LABEL "������ ���⪮�" NO-UNDO.
DEF VAR diffTime AS INTEGER LABEL "�६� ᮧ����� ����"            NO-UNDO.


DEF VAR dCurrDate AS Date  NO-UNDO.

DEF VAR itmpOpId AS INTEGER LABEL "�६����� ��� ID ���㬥�� 㢥��祭�� ���⪠"   NO-UNDO.
DEF VAR iDifDate AS INTEGER INITIAL 0 LABEL "���-�� ���� �� ��᫥����� ���᫥���"  NO-UNDO.

DEF VAR cUserList AS CHARACTER NO-UNDO.


oDTInput = new TDTInput(3).
oDTInput:head = "��� �஢�ન?".
oDTInput:X = 210.
oDTInput:Y = 70.
oDTInput:show().

IF oDTInput:isSet THEN
DO:
dCurrDate = oDTInput:beg-date.
oTpl = new TTpl("pir-controlres.tpl").
oTable = new TTable(3).
oTableErr = new TTable(2).


diffTime = TIME.

oUser = new TUser().
cUserList = oUser:getUserList("05-u10-1").

FOR EACH acct WHERE acct BEGINS "47423" AND close-date=? 
                    AND CAN-DO(cUserList,user-id)  NO-LOCK:
      /* �� �ᥬ ��⠬ 47423
         �⢥�ᢥ��� ������
         SUDNIK, SERGEEVA, ZHUKOVA
      */
      /* ��।����塞 ���⮪ �� ᥣ���� */      
     oAcct=new TAcct(acct.acct).
      dPos=oAcct:getLastPos2Date(dCurrDate).       
     DELETE OBJECT oAcct.
     
   IF dPos NE 0 THEN
     DO:
       /* ���⮪ �� �㫥��� */
    FIND FIRST bAcct WHERE CAN-DO("47425" + SUBSTRING(acct.acct,6,3) + "*" + SUBSTRING(acct.acct,17,4),bAcct.acct) 
                                                    AND bAcct.cust-cat=acct.cust-cat AND bAcct.cust-id = acct.cust-id
                                                    NO-LOCK NO-ERROR.

       IF AVAILABLE(bAcct) THEN
         DO:
           /* ����ਬ ���⮪ �� �������筮� 47425 */
           oAcct=new TAcct(bAcct.acct).
             dPos1=oAcct:getLastPos2Date(dCurrDate).
           DELETE OBJECT oAcct.
           dDifPos = dPos - dPos1.
             IF dDifPos <> 0 THEN
               DO:
                  /* 
                     ������� � ���!!! ����� ����� ������� �������!!!
                     1. �� ��� �ॡ������ �� ������ ���㫥��� ���⮪.
                     2. ���⮪ �� ��� १�ࢠ �� ࠢ�� ����� �� ��� ��
                     �ॡ�����ﬨ.
                     3. ������ �뢮� �������� ���ॡ���� �����᫥��� १�ࢠ.
                     4. ����ਬ ��᫥���� ������ �ਢ������ � ᯨᠭ�� � ��� �ॡ������ �� ��稬 ������ � ����.
                     5. ����ਬ ᫥������ �� ��� ������, �ਢ������ � 㢥��祭�� ���⪠ �� ���. �� ���� ��᫥���� ������ �뢮����� ���⮪
�� ���� �� ���.
                     6. ����塞 ������⢮ ���� ����� ⥪�饩 ��⮩ � ��⮩ �⮩ ����樨(�����騩 ���⮪ ���㫥���).
                     7. �᫨ ���-�� ���� ����� 30, � ������塞 100 १��.                 
                */
                                   
                  oDocCollect = new TDocCollectWPos().
                  oDocCollect:minPos = 0.
                  oDocCollect:maxPos = 0.
                  oDocCollect:filter-acct=acct.acct.                  

                  oDocCollect:applyFilter().

                  IF oDocCollect:DocCount > 0 THEN
                    DO:                    
                         itmpOpId=oDocCollect:getDocument(oDocCollect:DocCount):doc-id.
                         FIND FIRST op-entry WHERE op-entry.acct-db=acct.acct AND op-entry.op>itmpOpId NO-LOCK.
                             iDifDate = dCurrDate - op-entry.op-date.
                    END.
                    ELSE
                      DO:
                        /* 
                        ���⮪ �� ��� ���㫥���, ᯨᠭ�� �� �뫮 
                        � ���� ���᫥��� ���� ��ࢠ� ������
                        */
                     FIND FIRST op-entry WHERE op-entry.acct-db=acct.acct NO-LOCK.
                     iDifDate = dCurrDate - op-entry.op-date.                     
                    END.
                   oTable:addRow().
                   oTable:addCell(acct.acct).
                   oTable:addCell(iDifDate).
                   oTable:addCell(dDifPos).

                   DELETE OBJECT oDocCollect.                   

            END. /* ����� ���⪨ �� ࠢ�� */               
         END.        /* ����� ������ ��� 47425*/
         ELSE
           DO:
                oTableErr:addRow().
                oTableErr:addCell(acct.acct).
                oTableErr:addCell("��� १�ࢠ �� ������").
           END.        /* ����� �� ������ ��� 47423 */
     END.
 END.          
diffTime = TIME - diffTime.
oTpl:addAnchorValue("DATE-CREATE",STRING(dCurrDate)).
oTpl:addAnchorValue("TABLE1",oTable).

IF oTableErr:height GT 0 THEN oTpl:addAnchorValue("TABLEERR",oTableErr).
                         ELSE oTpl:addAnchorValue("TABLEERR","�訡�� �� �������.").

oTpl:addAnchorValue("TIME-RUN",STRING(diffTime)).
{setdest.i}
oTpl:show().
{preview.i}
DELETE OBJECT oUser.
DELETE OBJECT oTable.
DELETE OBJECT oTableErr.
DELETE OBJECT oTpl.
END.
DELETE OBJECT oDTInput.