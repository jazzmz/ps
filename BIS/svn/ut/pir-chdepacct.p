/**********************************************************
 * ��ࠡ�⪠ ��� ��ࠢ����� ���. ४����� "��������".    *
 *                                                                                                                *
 * �ࠪ��᪨ �� ��� ���� ४����� �������� � �ଠ�     *
 * "�_�������,���", � ���� ������� "���,�_�������"      *
 * �� ��ࠡ�⪠ ��� ࠧ � ��ࠢ��� �ଠ�.                               *
 *                                                                                                                *
 * ������:                                                                                            *
 * 1. �� �ᥬ ��⠬ ᮣ��᭮ ����� 㪠����� ������ �.;*
 * 2. �᫨ �������⥫�� ४����� �� ���⮩ � ᮤ�ন�          *
 * ���ࠢ��쭮� ���祭��, � ��ࠢ�塞 ���;                                *
 * 3.  ��஥ � ����� ���祭�� �����뢠�� � ���                            *
 ***********************************************************
 * ����: ��᫮� �. �.                                                                          *
 * ���: 15:13 05.05.2010                                                                       *
 * ���: #70                                                                                          *
 ************************************************************/

DEF VAR cDogNo AS CHARACTER INITIAL "" NO-UNDO.
DEF VAR newValue AS CHARACTER INITIAL "" NO-UNDO.
DEF VAR oAcct AS TAcct NO-UNDO.
DEF VAR end-date AS DATE INITIAL 12/31/2009 NO-UNDO.
DEF VAR oTable AS TTableCSV NO-UNDO.

oTable = new TTableCSV(3).
FOR EACH acct WHERE ((acct.bal-acct > 42102 AND acct.bal-acct<42107) 
                  OR (acct.bal-acct >42202 AND acct.bal-acct<42207)
                  OR (acct.bal-acct >42302 AND acct.bal-acct<42307) 
                  OR (acct.bal-acct >42502 AND acct.bal-acct<42507)
                  OR (acct.bal-acct >42602 AND acct.bal-acct<42607))
                  AND acct.open-date < end-date
                  AND (acct.close-date=? OR acct.close-date>01/01/2009)                   
               :

oAcct = new TAcct(acct.acct).
  
  /* ���������� ������� �� ����� */
 cDogNo = oAcct:getXAttr("��������").

IF cDogNo NE "" AND cDogNo NE ? THEN 
 IF  CAN-DO('42*',ENTRY(1,cDogNo,"")) THEN 
   DO:
     newValue = ENTRY(2,cDogNo," ") + "," + ENTRY(1,cDogNo," ").  
      oTable:addRow().
      oTable:addCell(acct.acct).
      oTable:addCell(cDogNo).
      oTable:addCell(newValue).
      oAcct:setXAttr("��������",newValue).
   END.

DELETE OBJECT oAcct.
END.
oTable:SAVE-TO("/home/maslov/clear/changelog.log").
DELETE OBJECT oTable.