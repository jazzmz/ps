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
/*������� �� pir-chngdoc.p, ⥯��� ⮫쪮 ��������� ����஫��*/



/** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{tmprecid.def}

DEF VAR oTEventLog AS TEventLog.

DEF VAR cOrderPay AS CHAR FORMAT "x(8)".

DEF FRAME fSet 

   "����஫��:" cOrderPay SKIP(1) 

   WITH CENTERED NO-LABELS TITLE "������ �����".

/** ⥫� �ணࠬ�� */

DISABLE TRIGGERS FOR LOAD OF op.
DISABLE TRIGGERS FOR LOAD OF op-entry.

FOR EACH tmprecid, FIRST op WHERE RECID(op) = tmprecid.id:
   
   /** �뢮��� �� ��� ����� ��� ��������� */
   cOrderPay = /*op.order-pay.*/ user-inspector.

   DISPLAY  cOrderPay  WITH FRAME fSet.
   PAUSE (0).
   SET  cOrderPay     WITH FRAME fSet.
   PAUSE (0).
   IF corderpay NE ? THEN if op.user-inspector <> corderpay then op.user-inspector = corderpay.


   HIDE FRAME fSet.


END.

