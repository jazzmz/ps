/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1998 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: chdat(op.i
      Comment: ��������� ���� �஢����
   Parameters:
         Uses:
      Used BY:
      Created:
     Modified: 16/03/99 Lera - ��������� ����������� �஢�ન ���४⭮�� �஢���� � ����� ���भ�
     Modified: 22.05.2003 19:31 KAVI     �뤥���� ��ࠡ�⪠ op.due-date
     Modified: 09.06.2003       NIK ����஫� ���㬥�� � 楫��
     Modified: 06.07.2004       abko  22734 ��७�� "���㬥�� ��"
     Modified:


��� ���㬥�⮢ ����� �뫨 ᮧ���� � ������� �࠭���樨 ��� 
��᫥����樮����� ���㦨����� �㬬� �� �������� �� ���������

���� ������� ������਩ 04.08.2006 15:06
�᫨ �஢���� ����⭠�, � ����ᯮ����樨 �஢���� ���� ���ᮢ� ��� "20202", �ਭ������騥 �⤥����� "00002",
� �㡫��� �������� �� ��७�� �� ������뢠����. 

*/
DEF VAR cdate       AS DATE      NO-UNDO.
DEF VAR ctime       AS INT64   NO-UNDO.
DEF VAR cddif       AS LOGICAL   NO-UNDO.
DEF VAR gend-date-t AS DATE      NO-UNDO.

DEF VAR currDoc     AS TDocument NO-UNDO.

DEFINE TEMP-TABLE tt-op-entry 
   FIELD op-entry LIKE op-entry.op-entry
.

/** ���� ������� ��।������ */
DEF VAR afterOperCash AS LOGICAL INITIAL FALSE.
DEF VAR minDate AS DATE. /* ���� ��� ���㬥�� */
DEF VAR position AS DECIMAL.
DEF VAR redAlert AS LOGICAL.
DEF VAR course AS INTEGER. /* ���ࠢ����� ��७��: ���। = 1, ����� = -1 */
/** ���� end */

{intrface.get op}
{intrface.get kau}
{intrface.get xclass}

IF AVAIL op THEN DO:
   ASSIGN
      cdate = TODAY
      ctime = TIME
   .
   /* �᫨ ������� ��� */
   IF cur-op-date NE op.op-date THEN 
      /** ���� ������� �᫮��� */
      IF cur-op-date GT op.op-date THEN course = 1. ELSE course = -1.
      ASSIGN
      minDate = MINIMUM(cur-op-date, op.op-date)
         op.op-date        = (IF mChOpDate
                                 THEN cur-op-date
                                 ELSE op.op-date)
         op.op-value-date  = (IF ChVDate
                                 THEN cur-op-date
                                 ELSE op.op-value-date)
         op.due-date       = (IF mChDDate
                                 THEN cur-op-date
                                 ELSE op.due-date)
         op.ins-date       = (IF ChIDate
                                 THEN cur-op-date
                                 ELSE op.ins-date)
         op.contract-date  = (IF mChContDate
                                 THEN cur-op-date
                                 ELSE op.contract-date)
         op.doc-date       = (IF mChDocDate
                                 THEN cur-op-date
                                 ELSE op.doc-date)
      .

   IF mChSpDate AND GetXattrValue("op",STRING(op.op),"������") NE STRING(cur-op-date) THEN 
      UpdateSigns("op",string(op.op),"������",STRING(cur-op-date),YES).

   cddif = NO.
   FIND FIRST op-entry OF op WHERE op-entry.acct-db EQ ? NO-LOCK NO-ERROR.
   IF AVAIL op-entry THEN
      cddif = YES.
   ELSE DO:
      FIND FIRST op-entry OF op WHERE op-entry.acct-cr EQ ? NO-LOCK NO-ERROR.
      IF AVAIL op-entry THEN cddif = YES.
   END.

   pick-value = "no".
   RUN RunClassMethod IN h_xclass (op.class-code,"chkupd","","",
                              ?,string(recid(op)) + ",date").
   IF NOT CAN-DO("no-method,no-proc",RETURN-VALUE) AND
      pick-value                         NE  "yes" THEN DO:
      {ifdef {&open-undo}} {&open-undo} {else} */ UNDO, RETRY  {endif} */ .
   END.
   {empty tt-op-entry}
   FOR EACH op-entry OF op NO-LOCK:   

/**********************
 * 
 * ����頥��� ��७����
 * ������ ���㬥��� � ��㣮� ����.
 *
 **********************
 * ����: ��᫮� �. �. Maslov D. A.
 * ���: #1535
 * ��� ᮧ�����: 15.10.12
 **********************/

 /***********************************
  * ����뢠�� ����� �����
  * ⮫쪮 ������ᨮ��� ����樨.
  ***********************************
  *
  * ����室��� ��⠭�������� pick-value 
  * � ���祭�� ��-㬮�砭�� YES.
  *
  ***********************************
  *
  * ���� : ��᫮� �. �. Maslov D. A.
  * ���: #1605 
  * ��� ᮧ�����: 24.10.12
  *
  ***********************************/

       IF LOGICAL(FGetSetting("PirChkOp","DenyMoveVal","YES")) THEN DO:

                currDoc = NEW TDocument(op-entry.op).

                IF currDoc:isExchange() AND NOT CAN-DO(FGetSetting("PirChkOp","PermMoveValUsers","!*"),currDoc:user-id) THEN DO:

                       MESSAGE COLOR WHITE/RED
                         "����饭� ��७���� ������ᨮ��� ���㬥���!" SKIP
                         " ������� � �������� ��壠����!!!" SKIP
                         VIEW-AS ALERT-BOX
                         TITLE "�訡�� #1535".
                         pick-value = "NO".
                END. ELSE DO:
                         pick-value = "YES".
                END.

                DELETE OBJECT currDoc NO-ERROR.

                IF pick-value = "NO" THEN DO:
                     {ifdef {&open-undo}} {&open-undo} {else} */ UNDO, RETRY  {endif} */ .
                END.
       END.


/** ���� ������� ���᪨ 04.08.2006 14:55 */
      afterOperCash = FALSE.
      IF op-entry.acct-db BEGINS "20202" THEN 
      	DO:
      		FIND FIRST acct WHERE acct.acct = op-entry.acct-db NO-LOCK NO-ERROR.
      	END.
      ELSE IF op-entry.acct-cr BEGINS "20202" THEN
      	DO:
      		FIND FIRST acct WHERE acct.acct = op-entry.acct-cr NO-LOCK NO-ERROR.
      	END.
      IF AVAIL acct THEN 
      	DO:
      		IF CAN-DO("00002", acct.branch-id) THEN
      			afterOperCash = TRUE. 
      	END.
      /** ���� end */

      IF NOT cddif                          AND
         mChOpDate                          AND 
         cur-op-date NE op-entry.value-date AND
         op-entry.amt-cur NE 0              AND
         op-entry.curr    GT ""             
	/** ���襢 ������� �ࠢ����� � �࠭���樥� ��᫮��� ����  � ���୥�*/
	 AND NOT CAN-DO("030202N*,030102P*,i-tag*",op.op-kind)     
	/** ���� ������� ��᫥����樮���� ���㦨����� 04.08.2006 15:04 */
	 AND NOT afterOperCash THEN DO:
         CREATE tt-op-entry.    
         ASSIGN
            tt-op-entry.op-entry = op-entry.op-entry
         .
      END.
   END.   


   FOR EACH op-entry OF op EXCLUSIVE-LOCK:   
      IF CAN-FIND(FIRST tt-op-entry WHERE tt-op-entry.op-entry EQ op-entry.op-entry)
      THEN DO:               
         ASSIGN
            op-entry.amt-rub    = CurToBase("�������",
                                            op-entry.currency,
                                            cur-op-date,
                                            op-entry.amt-cur).
            op-entry.value-date = cur-op-date
         .
      END.
      ASSIGN
         op-entry.op-date    = op.op-date
      .

      IF op-entry.op-date NE ? THEN
         ASSIGN
            gend-date-t = gend-date
            gend-date   = op-entry.op-date
         .

      RUN KauOpDel IN h_kau (RECID (op-entry)).
      IF pick-value = 'no' THEN DO:
         {ifdef {&del-undo}} {&del-undo} {else} */ UNDO, RETRY  {endif} */ .
      END.

      {op-entry.upd {&*}}                        /* �⠫�� ����஫�        */

      IF op-entry.op-date NE ? THEN              /* �����頥� ���� ��� �뫮 */
         gend-date = gend-date-t.

   END.
   FOR EACH op-impexp OF op EXCLUSIVE-LOCK:
      ASSIGN
         op-impexp.exp-batch  = ""
         op-impexp.exp-date   = ?
         op-impexp.exp-time   = 0.
   END.

   UpdateSigns("op",string(op.op),"num-rkc","",NO).
END.
/******************************************************************************/
