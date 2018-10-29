/* ------------------------------------------------------
     ����: ��᪮� �.�.
     ��� ����䨪�樨: 28.10.2011
     ���: #764

******************************************************* */

/** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{tmprecid.def}

DEF VAR cDocNum AS CHAR FORMAT "x(6)".
DEF VAR cDocDetails AS CHAR FORMAT "x(300)" VIEW-AS EDITOR SIZE 48 BY 4.

DEF FRAME fSet 
   "����� ���㬥��:" cDocNum SKIP(1) 
   "����ঠ��� ���㬥��:" SKIP cDocDetails 
   WITH CENTERED NO-LABELS TITLE "������ �����" .

/** ⥫� �ணࠬ�� */

/*DISABLE TRIGGERS FOR LOAD OF op.
DISABLE TRIGGERS FOR LOAD OF op-entry.*/

DEF VAR oSysClass AS TSysClass.

oSysClass = new TSysClass().


FOR EACH tmprecid, FIRST op WHERE RECID(op) = tmprecid.id:
    find first op-entry where op-entry.op-date = op.op-date and op-entry.op = op.op NO-LOCK NO-ERROR.
    if MAXIMUM(op.op-status, op-entry.op-status) GE '�' then 
       do:
/*          find first acct-pos where since = op.op-date NO-LOCK NO-ERROR.*/
          if oSysClass:getLastCloseDate() >= op.op-date then
             do:
                MESSAGE COLOR WHITE/RED "����. ���� 㦥 ������! ������஢���� ���㬥�⮢ � �����⮬ ��� ����饭�" VIEW-AS ALERT-BOX. 

             end.
          else
             do:

                if ((can-do("�����*",op-entry.kau-cr)) OR (CAN-DO("�����*",op-entry.kau-db))) AND (op.user-id EQ USERID('bisquit')) then 
                   do:   
                     /** �뢮��� �� ��� ����� ��� ��������� */
                      cDocNum = op.doc-num.
                      cDocDetails = op.details.
 
                      DISPLAY cDocNum cDocDetails WITH FRAME fSet.
 
                      SET cDocNum  cDocDetails WITH FRAME fSet.

                      IF cDocNum NE ? AND cDocNum NE "" THEN 
                         DO:
                            if op.doc-num <> cDocNum THEN op.doc-num = cDocNum.
                         END.


                      IF cDocDetails NE ? AND cDocDetails NE "" THEN 
                         DO:
                            if op.details <> cDocDetails THEN op.details = cDocDetails.
                         END.

                     DISPLAY cDocNum cDocDetails WITH FRAME fSet.
                     HIDE FRAME fSet.
                   END.
                ELSE
                   DO:
                      MESSAGE COLOR WHITE/RED "�� �� ����� �ࠢ� �ࠢ��� ���㬥�� ᮧ����� ��㣨� ���짮��⥫��" VIEW-AS ALERT-BOX. 
                   END.
             END.
       END.
    else
       DO:
          MESSAGE COLOR WHITE/RED "������ ��楤�� �।�����祭� ⮫쪮 ��� �ࠢ�� �ப���஫�஢���� ���㬥�⮢!"
                             SKIP "��ᯮ������ �⠭����� �㭪樮�����" VIEW-AS ALERT-BOX. 
       END.
END.
DELETE OBJECT oSysClass.