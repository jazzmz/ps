/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1997 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: promake.p
      Comment: ���ࠪ⨢�� ��������� 䠩���
   Parameters:
         Uses: compile.p
      Used by:
      Created: ?        Serge
     Modified: 14/07/97 Serge ��ࠬ��� 䠩� � ᯨ᪮� 䠩��� ��� �������樨
*/

&GLOBAL-DEFINE PFILE "./pfiles.lst"

DEFINE VAR fnames     AS CHAR INIT ?   NO-UNDO.
DEFINE VAR mFlNames   AS CHAR          NO-UNDO. /* ��������� ᯨ᮪ 䠩���. */
DEFINE VAR promakedir AS CHAR INIT ?   NO-UNDO.
DEFINE VAR mFlList    AS CHAR          NO-UNDO. /* ��������� 䠩� � ᯨ᪮�.*/
DEFINE VAR slash      AS CHAR INIT "/" NO-UNDO.

DEFINE STREAM sInpFileDir. /* �室��� ��⮪. */
DEFINE STREAM outf.        /* ��室��� ��⮪. */

{globals.i new} /* NEW ����室���, �.�. ����� �㤥� �����⢫�����
                ** �� ⮫쪮� �� ��� ��᪢��. */

     /* ����㧪� �����㬥�⮢ �� ࠡ�� � ������⥪���. */
{face-pp.ld}

RUN CheckHandle IN h_base NO-ERROR.
IF ERROR-STATUS:ERROR
   THEN RUN base-pp.p PERSISTENT SET h_base.

{compile.def}   /* ��।������ ��६����� ��� �������樨. */
{compile.pro}   /* �����㬥��� ��� �������樨. */
{pfiles.pro}    /* �����㬥��� ��� ࠡ��� � 䠩����. */
{promake.i}     /* �����㬥��� ��� �������樨. */

IF rdir = ""
   THEN rdir = ENTRY (1, PROPATH).

FORM
   fnames
      FORMAT "x(60)"
      LABEL "�����" 
      HELP "������ ��᪨ 䠩��� �१ �஡�� ��� �������"
   promakedir
      FORMAT "x(60)"
      LABEL "���� � ᯨ᪮� 䠫��"
      HELP "��� 䠩��, ᮤ�ঠ饣� ᯨ᮪ ��������㥬�� 䠩��� ��� ?"
   rdir
      HELP "��� ��⠫���, ᮤ�ঠ饣� r-䠩��"
   modpropath
      AT 18
      HELP "��������� � PROPATH ��⠫�� c ��室�� 䠩��� � �����⠫�� 'i'?"
WITH
   1 COL
   CENTERED
   1 DOWN
   ROW 8
   OVERLAY
   FRAME inp-dir
   TITLE color bright-white "[ ���������� ������ ]".

ON RETURN OF modpropath IN FRAME inp-dir APPLY "GO" TO SELF.

REPEAT:
   PAUSE 0.
   UPDATE
      fnames
      promakedir
      rdir
      modpropath
   with frame inp-dir.

   IF fnames EQ ""
      THEN fnames = ?.

   IF promakedir EQ ""
      THEN promakedir = ?.

   IF    fnames      EQ ?
      OR promakedir  EQ ?
   THEN RETRY.

   RUN ParsStr (fnames,          /* ��ப� � ᯨ᪮� 䠩���. */
                promakedir,      /* ���� � ᯨ᪮� 䠩��� ��� �������樨. */
                OUTPUT mFlNames, /* ���祭�� ��� �������樨. */
                OUTPUT mFlList). /* ���祭�� ��� �������樨. */

   /* ����� �������樨. */
   RUN compile.p (
      mFlNames,      /* ���� ��� �������樨 */
      mFlList,       /* ���᮪ 䠩��� ��� �������樨 */
      rdir,          /* �㤠 ������ R-�� */
      YES,           /* preview always Yes */
      ?,             /* ���� � ������������ LOG 䠩�� */
      modpropath).   /* ������஢��� propath. */

END.

HIDE frame inp-dir no-pause.

RETURN.

/* ������ ��ப� ��� �������樨. */
PROCEDURE ParsStr:
   DEFINE INPUT  PARAM iFiles  AS CHAR        NO-UNDO. /* ��᪨ ���� 䠩��. */
   DEFINE INPUT  PARAM IPfList AS CHAR        NO-UNDO. /* ���᮪ 䠩���. */
   DEFINE OUTPUT PARAM oFile   AS CHAR INIT ? NO-UNDO. /* ���� ��� �������樨. */
   DEFINE OUTPUT PARAM oPflist AS CHAR INIT ? NO-UNDO. /* ���� � ᯨ᪮�. */
   
   DEFINE VAR vCnt    AS INT64  NO-UNDO. /* ���稪. */
   DEFINE VAR vMask   AS CHAR NO-UNDO. /* ��᪠ 䠩��. */
   DEFINE VAR vPath   AS CHAR NO-UNDO. /* ����� ��� ���᪠ �� ��᪥. */
   DEFINE VAR vSchPth AS CHAR NO-UNDO. /* ���᮪ ��⥩ ���᪠. */

   /* ������ ���� 䠩�. */
   IF NUM-ENTRIES (iFiles) EQ 1
      AND NOT FileOrMask (iFiles)
   THEN DO:
      oFile = iFiles.
      RETURN.
   END.

   /* ������� ��᪠ 䠩���. */
   ELSE DO:

      IF iFiles EQ ?
      THEN DO:
         oPflist = IPfList.
         RETURN.
      END.
      ELSE DO:

         /* �������� 䠩�� � ᯨ᪮� �������樨. */
         OS-DELETE VALUE ({&PFILE}).
         oPflist = {&PFILE}.

         DO vCnt = 1 TO NUM-ENTRIES (iFiles):

            /* ������ ��ப� �� ���� � ����. */
            RUN GetNmPth (
               ENTRY (vCnt, iFiles),   /* ��室��� ��ப�. */
               OUTPUT vPath,           /* ����, � ���஬ ����� 㪠����� 䠩�. */
               OUTPUT vMask).          /* ��᪠ 䠩�� / ��� 䠩��. */

            /* ���� 䠫�� �� ��᪥. */
            RUN GetFileByMask (
               vPath,         /* ��⠫�� ���᪠. */
               vMask,         /* ��᪠ 䠩��. */
               YES,           /* �ਧ��� ���᪠ 䠩��� � �����⠫����. */
               YES,           /* ����뢠�� ����� ���� � 䠩���. */
               OUTPUT vSchPth /* ���᮪ ��⠫���� ���᪠. */
            ).
         END.
      END.
   END.
   
   RETURN.
END PROCEDURE.

