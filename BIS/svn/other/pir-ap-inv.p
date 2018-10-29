/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2007 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: ap-inv.p
      Comment: ������ਧ�樮���� ����� �� ��࠭�栬
   Parameters:
         Uses:
      Used by:
      Created: 14/07/2007 BMS
     Modified:            BMS
*/

{globals.i}
{a-defs.i}

{tmprecid.def}

/*��� �६������ �࠭���� recid'�� ����ᥩ*/
DEF TEMP-TABLE tmprecid-tmp NO-UNDO LIKE tmprecid.

/* ��६����, ����訢���� � ���짮��⥫� */
DEF VAR mMol        AS CHAR NO-UNDO. /* ���᮪ ⠡. ����஢ ���   */
DEF VAR mDocNum     AS CHAR NO-UNDO. /* �������� ����� ���㬥�� */
DEF VAR mPlace      AS CHAR NO-UNDO. /* ��������� ���⮭�宦����� */

DEF VAR mAbsen      AS LOG  NO-UNDO
   VIEW-AS RADIO-SET
   RADIO-BUTTONS "���뢠��"   , YES,
                 "�� ���뢠��", NO.

/* -------------------------------------------------------- */

/* ��� ��楤��� � �����묨 �㭪�ﬨ ���   */
DEF VAR mH           AS HANDLE  NO-UNDO.
/* �ਧ��� ����室����� 㤠����� ��楤��      */
DEF VAR remove-mH    AS LOGICAL NO-UNDO INIT NO.

DEF VAR in-dataclass-id  LIKE DataClass.DataClass-Id NO-UNDO. /*��� norm.i*/
DEF VAR in-branch-id     LIKE DataBlock.Branch-id    NO-UNDO. /*��� norm.i*/
DEF VAR in-beg-date      LIKE DataBlock.Beg-Date     NO-UNDO. /*��� norm.i*/
DEF VAR in-end-date      LIKE DataBlock.End-Date     NO-UNDO. /*��� norm.i*/

FORM
   WITH FRAME dateframe2 CENTERED ROW 10 OVERLAY 1 COL SIDE-LABELS COLOR MESSAGES
   TITLE "[ ��������� ��� ������ ]".


MAIN:
DO ON ERROR UNDO MAIN, LEAVE MAIN:
   FOR EACH tmprecid:
      CREATE tmprecid-tmp.
      BUFFER-COPY tmprecid TO tmprecid-tmp.
   END.

   {getdate.i
      &DispBeforeDate = "
                         mDocNum
                            FORMAT 'x(6)'
                            LABEL '����� ���㬥��'
                            HELP  '������ ����� ���㬥��'
                        "
      &UpdBeforeDate  = "mDocNum"
      &DispAfterDate  = "
                         mPlace
                            FORMAT 'x(50)'
                            LABEL  '���⮭�宦�����'
                            HELP   '���⮭�宦����� (F1 - �롮� �� �ࠢ�筨��)'
                            VIEW-AS FILL-IN SIZE 20 BY 1
                         mMol
                            FORMAT 'x(50)'
                            HELP  '��� (F1 - �롮� �� �ࠢ�筨��)'
                            LABEL '���'
                            VIEW-AS FILL-IN SIZE 20 BY 1

                         '----------------'

                         mAbsen
                            LABEL '������⢨� �� '
                            HELP  '���뢠�� �������⥫�� ४����� ����窨 <���������> ?'
                        "
      &UpdAfterDate   = "mPlace mMol mAbsen"
      &DateLabel      = "��� ���㬥��"
      &DateHelp       = "������ ���� ���㬥��"
      &AddLookUp      = "
                         IF     LASTKEY     EQ 301
                            AND FRAME-FIELD EQ 'mPlace'
                         THEN DO TRANS:
                            RUN pclass.p ('����',
                                          '����',
                                          '����� ������������',
                                          6).
                            IF     pick-value NE ?
                               AND (LASTKEY = 10 OR LASTKEY = 13)
                            THEN DO:
                               mPlace = GetCodeName('����', pick-value).
                               DISPLAY mPlace.
                            END.
                         END.
                         ELSE IF     LASTKEY     EQ 301
                                 AND FRAME-FIELD EQ 'mMol' THEN
                         DO TRANS:
                            /* ��� ���४��� ࠡ��� ���� mMol */
                            ASSIGN mMol.

                            RUN a-emptab.p (?, 4).

                            IF CAN-FIND(FIRST tmprecid) THEN
                            FOR EACH tmprecid NO-LOCK,
                               EACH employee     WHERE
                                    RECID(employee) EQ tmprecid.id
                               NO-LOCK:
                               IF NOT(CAN-DO(mMol, STRING(employee.tab-no))) THEN
                                  mMol = mMol + (IF mMol NE '' THEN ',' ELSE '')
                                       + STRING(employee.tab-no).
                            END.

                            ELSE
                            IF     pick-value        NE ?
                               AND NOT(CAN-DO(mMol, pick-value))
                            THEN
                               mMol =   mMol + (IF mMol NE '' THEN ',' ELSE '')
                                      + pick-value.

                            DISPLAY mMol.

                         END.
                         ELSE
                        "
      &AddPostUpd     = "
                         IF NUM-ENTRIES(mMol) GT 3 THEN
                         DO:
                            MESSAGE '����� ������� ����� ��� ���!'
                            VIEW-AS ALERT-BOX.
                            UNDO, RETRY.
                         END.
                        "
      &return         = " LEAVE MAIN "
   }

   {empty tmprecid}
   FOR EACH tmprecid-tmp:
      CREATE tmprecid.
      BUFFER-COPY tmprecid-tmp TO tmprecid.
   END.

   {justasec}

/*----------------------------------------------------------------------------*/
/*  ������ ������᪨� ����                                                   */
/*----------------------------------------------------------------------------*/

   mH = SESSION:FIRST-PROCEDURE.
   DO WHILE mH NE ?:
      IF     mH:FILE-NAME    EQ "a-obj.p"
         AND mH:PRIVATE-DATA NE "Slave"   THEN
         LEAVE.
         mH = mH:NEXT-SIBLING.
   END.

   IF VALID-HANDLE(mH) THEN
      RUN Save IN mH.
   ELSE
   DO:
     RUN "a-obj.p" PERSISTENT SET mH ("Slave", "", "").
     remove-mH = YES.
   END.

   RUN SetSysConf IN h_base ("in-dt:doc-num", mDocNum).
   RUN SetSysConf IN h_base ("in-dt:op-date", STRING(end-date,"99/99/9999")).
   RUN SetSysConf IN h_base ("in-dt:place"  , mPlace).
   RUN SetSysConf IN h_base ("in-dt:absen"  , mAbsen).
   RUN SetSysConf IN h_base ("in-dt:molrole", mMol).

   ASSIGN
      in-beg-date = end-date
      in-end-date = end-date
   .

   {norm.i new}
   {norm-beg.i
      &title     = "'��������� ������' "
      &nodate    = YES
      &is-branch = YES
      &nofil     = YES
   }

   IF work-module EQ "���"
   THEN DO:
      {setdest.i
          &stream   = "stream fil"
          &cols     = 122
      }
   END.
   ELSE DO:
      {setdest.i
          &stream   = "stream fil"
          &cols     = 175
      }
   END.

   IF work-module EQ "��" THEN
      RUN norm-rpt.p ("" , "pirosinv", in-branch-id, in-beg-date, in-end-date).

   ELSE
   IF work-module EQ "���" THEN
      RUN norm-rpt.p ("" , "nmainv", in-branch-id, in-beg-date, in-end-date).

   ELSE
   IF CAN-DO("���,�����", work-module) THEN
      RUN norm-rpt.p ("" , "mbpinv", in-branch-id, in-beg-date, in-end-date).
END.
/*----------------------------------------------------------------------------*/
/*  ������� ������᪨� ����                                                   */
/*----------------------------------------------------------------------------*/
IF     remove-mH
   AND VALID-HANDLE(mH) THEN
   DELETE PROCEDURE (mH).
ELSE
IF     NOT remove-mH
   AND VALID-HANDLE(mH) THEN
   RUN Restore IN mH.

RUN DeleteOldDataProtocol IN h_base ("in-dt:").

{intrface.del}