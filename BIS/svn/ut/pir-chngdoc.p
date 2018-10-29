/* ------------------------------------------------------
     Copyright: ��� �� "�p������������"
     ���������: -
     ��稭�: �������� ���. ४����⮢ ���㬥�� 
     �� ������: �����뢠�� ��� � �������騬� ४����⠬� ��� �� ���������
     ��� ࠡ�⠥�: �����뢠�� ��� � �������騬� ४����⠬� ��� �� ���������
     ��ࠬ����: <��⠫��_�ᯮ��>
     ���� ����᪠: ��㧥� ���㬥�⮢           
*******************************************************
     ����: ��砥� �.�.
     ��� ᮧ�����: 14.05.2010
     ���: #290
------------------------------------------------------
     ����: ��᪮� �.�.
     ��� ����䨪�樨: 13.12.2010
     ���: #573
     ��稭� ����䨪�樨: ���������� ��ࠢ�� ᮮ�饭�� �� ���������� ���㬥�� � ��⥬� "������"
******************************************************* */

/** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{tmprecid.def}

DEF VAR oTEventLog AS TEventLog NO-UNDO.

DEF VAR cDocNum  AS CHAR FORMAT "x(6)" NO-UNDO.
DEF VAR cDocType AS CHAR FORMAT "x(5)" NO-UNDO.
DEF VAR cNameBen AS CHAR FORMAT "x(300)" VIEW-AS EDITOR SIZE 48 BY 4    NO-UNDO.
DEF VAR cDocDetails AS CHAR FORMAT "x(300)" VIEW-AS EDITOR SIZE 48 BY 4 NO-UNDO.
DEF VAR cEvent AS CHAR NO-UNDO.
DEF VAR iEventNum AS INTEGER INITIAL 60 NO-UNDO. /* ����� ᮡ��� � ��⥬� ॣ����樨 ᮡ�⨩ */

DEF FRAME fSet 
   "����� ���㬥��:" cDocNum SKIP(1) 
   "��� ���㬥��:" cDocType SKIP(1)
   "��������� ������:" SKIP cNameBen SKIP(1)
   "����ঠ��� ���㬥��:" SKIP cDocDetails 
   WITH CENTERED NO-LABELS TITLE "������ �����".

/** ⥫� �ணࠬ�� */

/*DISABLE TRIGGERS FOR LOAD OF op.
DISABLE TRIGGERS FOR LOAD OF op-entry.  */

FOR EACH tmprecid, FIRST op WHERE RECID(op) = tmprecid.id:
   
   /** �뢮��� �� ��� ����� ��� ��������� */
   cDocNum = op.doc-num.
   cDocType = op.doc-type.
   cNameBen = op.name-ben.
   cDocDetails = op.details.

   DISPLAY cDocNum cDocType cNameBen cDocDetails WITH FRAME fSet.

   SET cDocNum cDocType cNameBen cDocDetails WITH FRAME fSet.
   cEvent = "� ���㬥�� �����: " + op.doc-num + " �� " + STRING(op.op-date) + " ��������:".

   IF cDocNum NE ? AND cDocNum NE "" THEN 
        DO:
           if op.doc-num <> cDocNum THEN cEvent = cEvent + " ����� ���㬥��: ��஥ ���祭��:" + op.doc-num + " ����� ���祭��: " + cDocNum.
           op.doc-num = cDocNum.
        END.

   IF cDocType NE ? AND cDocType NE "" THEN 
        DO:
           if op.doc-type <> cDocType THEN cEvent = cEvent + " ��� ���㬥��: ��஥ ���祭��:" + op.doc-type + " ����� ���祭��: " + cDocType.
             op.doc-type = cDocType.
        END.

   if op.name-ben <> cNameBen THEN cEvent = cEvent + " ४������ ������: ��஥ ���祭��:" + op.name-ben + " ����� ���祭��: " + cNameBen.
   op.name-ben = cNameBen.

   IF cDocDetails NE ? AND cDocDetails NE "" THEN 
        DO:
           if op.details <> cDocDetails THEN cEvent = cEvent + " ����ঠ��� ���㬥��: ��஥ ���祭��:" + op.details + " ����� ���祭��: " + cDocDetails.
           op.details = cDocDetails.
        END.

   DISPLAY cDocNum cDocType cNameBen cDocDetails WITH FRAME fSet.

   HIDE FRAME fSet.

   IF cEvent <> "� ���㬥�� �����: " + op.doc-num + " �� " + STRING(op.op-date) + " ��������:" THEN 
        DO:
           cevent = REPLACE(cevent,CHR(34),"").
/*           Message cevent VIEW-AS ALERT-BOX.*/
           
           oTEventLog = new TEventLog("curl","http://govorun/event").
           oTEventLog:fillInfo(iEventNum,cEvent).
           oTEventLog:Send().
           DELETE OBJECT oTEventLog.
        END.
END.

