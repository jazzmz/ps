{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-vip.p,v $ $Revision: 1.5 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ��� �� "�p������������"
���������    : stmt(dd).p, �� ����������� ��७���� ��ࠡ�⪨
��稭�       : �ਪ�� �64 �� 25.10.2005
�����祭��    : �믨᪨ �� ��ਮ�
��ࠬ����     : - ��砫쭠� ���
              : - ����筠� ���
              : - ��� ���ࠧ�������
              : - ��� 䠩��
              : - C�뫪� �� 䨫��� �� ��⠬ 
              : - �������⥫�� ��ࠬ���� ��楤��� �१ ","              
���� ����᪠ : �����஢騪 �����, ��楤�� pir-shdrep.p 
����         : $Author: anisimov $ 
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.4  2007/08/21 13:39:00  lavrinenko
���������     : ����������� ��࠭���� � ������ � ������ � ��⠫���
���������     :
���������     : Revision 1.3  2007/08/20 13:53:49  Lavrinenko
���������     : ��������� �ଠ� �맮��
���������     :
���������     : Revision 1.2  2007/08/20 06:53:32  lavrinenko
���������     : ��楤�� ७��樨 �믨᮪ �� ��⠬ �����⮢
���������     :
���������     : Revision 1.1  2007/08/17 13:03:38  lavrinenko
���������     : ��楤��  ॣ���樨 �믨᮪ � ��⮬���᪮� ०��@
���������     :
------------------------------------------------------ */
{globals.i}
{sh-defs.i}
{pick-val.i}
{chkacces.i}
DEF INPUT PARAM iBegDate    AS DATE NO-UNDO. /* ��砫쭠� ���         */
DEF INPUT PARAM iEndDate    AS DATE NO-UNDO. /* ����筠� ���          */
DEF INPUT PARAM iBranch     AS CHAR NO-UNDO. /* ��� ���ࠧ�������      */
DEF INPUT PARAM iFile       AS CHAR NO-UNDO. /* ��।������� ��� 䠩�� */
DEF INPUT PARAM iFlt        AS CHAR NO-UNDO. /* C�뫪� �� 䨫��� �� ��⠬  */
DEF INPUT PARAM iParam      AS CHAR NO-UNDO. /* �������⥫�� ��ࠬ���� ��楤��� �१ "," */

{pirraproc.def}
&GLOB filename arch_file_name

ASSIGN
   gRemote   = YES 
   beg-date = iBegDate 
   end-date = iEndDate
.

{pirraproc.i &in-beg-date=iBegDate &in-end-date=iEndDate &arch_file_name=iFile &arch_file_name_var=yes} /* PIR */

DEFINE VARIABLE mIsSeparate AS LOGICAL NO-UNDO. 

mIsSeparate = FGetSetting("�믨᪨", "���冷�", "���") EQ "�믨᪠".

{tmprecid.def}          /* ������ �⬥⮪. */
{empty TmpRecId}  /* ���㫥��� ⠡���� �⬥⮪. */

{flt-file.i NEW}            /* ��।������ �������� �������᪮�� 䨫���. */

RUN acct-flt.p ("acctb").

DEF VAR list-class   AS CHAR NO-UNDO. /* ᯨ᮪ ����� � �������ᮢ*/
DEF VAR num-class    AS INT  NO-UNDO. /* N ����� */

IF GetFltVal ("acct-cat") EQ ""
THEN DO:
   RUN SetFltFieldList ("acct-cat", "*"). /* �����뢠�� � ��ப�. */
   RUN SetFltField     ("acct-cat", "*"). /* �����뢠�� ��������. */
END.


FIND FIRST user-config WHERE
        user-config.user-id    = entry(1,iFlt)           AND 
        user-config.proc-name  = entry(2,iFlt) AND 
        user-config.sub-code   = entry(3,iFlt) AND 
        user-config.descr      = entry(4,iFlt) NO-LOCK NO-ERROR.
  
IF NOT AVAIL user-config THEN DO:
        PUT UNFORMAT "�� ������ 䨫��� " iFlt SKIP.
        RETURN.
END.
                       
RAW-TRANSFER user-config.config-data TO tt-table.
                       
{flt-attr.set}

PUT UNFORMAT "�ᯮ������ 䨫��� " iFlt.


FOR EACH acct WHERE CAN-DO(GetFltVal('acct'), acct.acct) AND 
                    CAN-DO(GetFltVal('currency'), acct.currency) NO-LOCK:
    CREATE tmprecid.
    tmprecid.id = RECID(acct).
END.
{flt-file.end}

{empty flt-cat}
{empty flt-attr}
{empty tt-table}


FIND FIRST user-config WHERE
        user-config.user-id    = entry(1,iFlt)        AND 
        user-config.proc-name  = "stmt(dd).p"           AND 
        user-config.sub-code   = "stmt"                 AND 
        user-config.descr      = entry(4,iFlt)        NO-LOCK NO-ERROR.
        
IF AVAIL user-config THEN 
        RAW-TRANSFER user-config.config-data TO tt-table.

{stmt.i new }

/* ����� {getstmt.i} */
DEFINE VARIABLE vmode-proc-scr AS CHAR FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE proc-post-scr  AS CHAR FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE last-F5        AS CHAR                NO-UNDO.
DEFINE VARIABLE vDtZo          AS CHAR                NO-UNDO.
DEFINE VARIABLE Cols           AS INT                 NO-UNDO.
DEFINE VARIABLE vSortPoz       AS INT  INIT 10        NO-UNDO.

{setdest.i &custom=" if not pgd then 0 else " &cols=" + cols"}

IF mIsSeparate AND ts.cmode EQ 3 THEN
DO:
   ts.cmode = 1.

   FOR EACH tmprecid NO-LOCK,
       FIRST acct WHERE RECID(acct) = tmprecid.id NO-LOCK
                  BY acct.bal-acct
                  BY SUBSTRING(acct.acct,vSortPoz):

      {on-esc RETURN}

      IF NOT {acctlook.i} THEN
         NEXT.
      {stmt-prt.i &NEXT    ="NEXT"
                  &begdate = beg-date
                  &enddate = end-date
                  &bufacct = acct
      }
   END.
   ts.cmode = 2.
   ts.name-vip = "������� �� �������� �����".
END.

for each tmprecid no-lock,
   first acct where recid(acct) = tmprecid.id no-lock
        by acct.bal-acct
        by substr(acct.acct,vSortPoz):

   {on-esc return}
   if not {acctlook.i} then next.
   {stmt-prt.i &NEXT    ="NEXT"
               &begdate = beg-date
               &enddate = end-date
               &bufacct = acct
   }
end.

{pirstmtview.i}

