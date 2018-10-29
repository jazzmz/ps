USING Progress.Lang.*.
/* ---------------------------------------------------------------------
File       : $RCSfile: pir-chkop.p,v $ $Revision: 1.69 $ $Date: 2011-02-15 14:45:58 $
Copyright  : ��� �� "�p������������"
Function   : ��楤�� ��⮤� chkupd ����� op.
           : �믮���� �஢��� �����塞�� �஢���� �� ������������� ��᭮�� ᠫ줮.	
Created    : 29.05.2007 lavrinenko
Modified   : $Log: not supported by cvs2svn $
Modified   : Revision 1.67  2010/12/28 13:02:08  borisov
Modified   : U Maslova ne rabotaet CVS
Modified   :
Modified   : Revision 1.64  2010/11/13 08:26:05  maslov
Modified   : Izmenen spisok schetov. Ispravlen visov includnikov. Event #505.
Modified   :
Modified   : Revision 1.63  2010/09/13 09:14:52  maslov
Modified   : *** empty log message ***
Modified   :
Modified   : Revision 1.59  2010/07/23 11:06:00  ermilov
Modified   : Remove  checking  for Val control
Modified   :
Modified   : Revision 1.58  2010/04/22 18:06:00  ermilov
Modified   : Return to previos version (1.56)
Modified   :
Modified   : Revision 1.57  2010/03/18 10:33:43  maslov
Modified   : Add changes for Marcheva
Modified   :
Modified   : Revision 1.56  2009/12/07 06:25:26  Buryagin
Modified   : New check for 2281-U. The check #8-2
Modified   :
Modified   : Revision 1.55  2009/11/30 16:02:41  Buryagin
Modified   : Fix the check #5. Excepted from check the op-status "FKS"
Modified   :
Modified   : Revision 1.54  2009/11/30 10:10:04  Buryagin
Modified   : New check #6 (PODFT)
Modified   :
Modified   : Revision 1.53  2009/11/10 06:02:46  ermilov
Modified   : Remove doc-type 06 from Check #14
Modified   :
Modified   : Revision 1.52  2009/11/05 11:50:37  Buryagin
Modified   : Fix the check #2, add status 'V'
Modified   :
Modified   : Revision 1.51  2009/10/30 06:29:17  ermilov
Modified   : Some changes in CARD control
Modified   :
Modified   : Revision 1.50  2009/10/23 10:38:53  Buryagin
Modified   : Fix the check #3. Need for the cash docs, which created in the 'V' status.
Modified   :
Modified   : Revision 1.49  2009/10/22 13:01:19  Buryagin
Modified   : Fix the check #3. vStatus changed to '√' as a constant.
Modified   :
Modified   : Revision 1.48  2009/10/22 12:46:02  Buryagin
Modified   : Uncommented the check #3.
Modified   :
Modified   : Revision 1.47  2009/10/13 11:58:54  ermilov
Modified   : Check #10 from  1.40
Modified   :
Modified   : Revision 1.46  2009/10/02 07:15:39  ermilov
Modified   : Changes in CARD control
Modified   :
Modified   : Revision 1.45  2009/10/02 06:46:27  ermilov
Modified   : Added CARD control
Modified   :
Modified   : Revision 1.44  2009/09/30 13:30:56  Buryagin
Modified   : Come back to old version 1.42 from 09.09.2009
Modified   :
Modified   : Revision 1.42  2009/09/09 05:11:11  ermilov
Modified   : *** empty log message ***
Modified   :
Modified   : Revision 1.41  2009/09/09 04:56:02  ermilov
Modified   : Fixing VO control for ben-acct
Modified   :
Modified   : Revision 1.40  2009/08/21 10:26:14  ermilov
Modified   : Reconfigure VO control for suspicius operations
Modified   :
Modified   : Revision 1.39  2009/07/15 13:01:27  Buryagin
Modified   : Fix the check #11.3. Commented AND NOT CAN-DO("1,2,3,4",op.order-pay)
Modified   :
Modified   : Revision 1.38  2009/06/16 12:03:24  Buryagin
Modified   : Added the new check 11.4
Modified   :
Modified   : Revision 1.37  2009/06/08 08:09:46  borisov
Modified   : Proverka 6, test "11:00" - proverka statusa: GE 'V' vmesto 'VV'
Modified   :
Modified   : Revision 1.36  2009/03/18 06:08:12  ermilov
Modified   : Added interface.get ps,strng
Modified   :
Modified   : Revision 1.35  2009/02/11 16:11:53  ermilov
Modified   : some fixes fo VO control #2
Modified   :
Modified   : Revision 1.34  2009/02/10 11:28:57  ermilov
Modified   : Added control of a canceletion a docs with extended attribute "PIRCHECKVO"
Modified   :
Modified   : Revision 1.33  2009/02/09 17:20:47  ermilov
Modified   : TZ from D.Savina: kass operation with VO codes must be controlled by U10-1
Modified   :
Modified   : Revision 1.32  2008/11/21 07:13:15  Buryagin
Modified   : Fixed the Check #11.3
Modified   :
Modified   : Revision 1.31  2008/11/20 19:26:19  ermilov
Modified   : Added forbidden of update/remove docs with VO  control
Modified   :
Modified   : Revision 1.30  2008/11/20 13:41:13  ermilov
Modified   : *** empty log message ***
Modified   :
Modified   : Revision 1.29  2008/11/18 08:17:32  Buryagin
Modified   : Fix the check #6.
Modified   : Logic expression "op.op-status < vStatus" changed with "op.op-status <= vStatus".
Modified   :
Modified   : Revision 1.28  2008/11/07 09:15:27  Buryagin
Modified   : 1. Formatted the all code.
Modified   : 2. Fixed the Check #11.3: controlling only the changing from FBN to FBO of the document status.
Modified   :
Modified   : Revision 1.27  2008/08/18 11:54:41  Buryagin
Modified   : GetLoanLimit_ULL(..., true -> false)
Modified   :
Modified   : Revision 1.26  2008/08/18 11:36:40  Buryagin
Modified   : Fix the control of position of account and commission for pay out. Limit.
Modified   :
Modified   : Revision 1.25  2008/08/13 12:27:53  Buryagin
Modified   : Fix the account position control. Operations created by user PLASTIC is checking now.
Modified   :
Modified   : Revision 1.24  2008/08/11 14:01:17  Buryagin
Modified   : Fix the errors in commission for pays out
Modified   :
Modified   : Revision 1.23  2008/08/08 13:53:57  Buryagin
Modified   : Fix the control of the needed account position for the getting of commission by the client's pay out
Modified   :
Modified   : Revision 1.22  2008/07/08 13:56:43  Buryagin
Modified   : Fix: Exclude the TaxPay from the calculate procedure of total count/amount for the checking of needed position of account for out payments with the commission by the payment.
Modified   :
Modified   : Revision 1.21  2008/06/19 06:54:35  Buryagin
Modified   : Fixed the checking of available position in the client's account for getting rate for out transfer.
Modified   :
Modified   : Revision 1.20  2008/06/04 08:49:58  kuntash
Modified   : dorabotka PODFT
Modified   :
Modified   : Revision 1.19  2008/06/04 06:51:15  Buryagin
Modified   : Fix: in-line call of pir-chksgn.i needs the macros-param "ope".
Modified   :
Modified   : Revision 1.18  2008/06/04 05:41:31  Buryagin
Modified   : Added the code which checking the period of validity for the card of customer's signs.
Modified   :
Modified   : Revision 1.17  2008/05/26 10:37:17  kuntash
Modified   : kontrol komissii
Modified   :
Modified   : Revision 1.16  2008/02/22 13:17:35  kuntash
Modified   : dorabotka 222-p
Modified   :
Modified   : Revision 1.15  2008/01/17 17:20:57  kuntash
Modified   : dorabotka 275 FZ
Modified   :
Modified   : Revision 1.14  2007/12/19 13:09:53  kuntash
Modified   : dorabotka
Modified   :
Modified   : Revision 1.13  2007/12/17 18:46:25  kuntash
Modified   : dorabotka do 35 patcha
Modified   :
Modified   : Revision 1.11  2007/09/25 06:50:56  lavrinenko
Modified   : ��ࠡ�⠭� ��।������ ���⪠ �� ���� �� ��७�� ���㬥�⮢ � ��㣮� ����.
Modified   :
Modified   : Revision 1.10  2007/09/04 07:30:53  lavrinenko
Modified   : ��ࠡ�⪠ ��楤���� ����஫� ��᭮�� ᠫ쭮�� �� ��⨢�� ��⠬
Modified   :
Modified   : Revision 1.9  2007/08/07 12:53:47  lavrinenko
Modified   : ��࠭� �஢�ઠ �� ।���஢���� ���㬥�⮢ � ��᮪�� �����ᮬ. �஢�ઠ �� ᠬ�����஫�  �������� �஢�મ� �� �᮪ �᪫�祭��
Modified   :
Modified   : Revision 1.8  2007/08/06 07:09:13  lavrinenko
Modified   : ����������� �஢�ન �� ���졥 ����ᮢ��: 1. ����� ᠬ�����஫�, 2. ����� ।���஢���� ���㬥�⮢ � ��᮪�� ����ᮬ �� ����஫���
Modified   :
Modified   : Revision 1.7  2007/07/30 11:17:08  lavrinenko
Modified   : ��������� �������⥫�� �������ਨ
Modified   :
Modified   : Revision 1.6  2007/07/24 07:27:27  lavrinenko
Modified   : ����������� �஢�ઠ ࠧ��୮�� �����祭�� ���⥦� � ���㬥��� ��ࠢ�塞�� � ���, �4, ����ॢ�
Modified   :
Modified   : Revision 1.5  2007/06/28 12:20:20  lavrinenko
Modified   : ����������� ��⮤� �������⥫쭮�� ����஫� ���㬥�⮢ ��ࠢ������ � ���
Modified   :
Modified   : Revision 1.4  2007/06/21 12:59:49  lavrinenko
Modified   : ��ࠡ�⠭� ��ࠡ�⪠ 㤠����� ���㬥�
Modified   :
Modified   : Revision 1.3  2007/06/20 11:44:39  lavrinenko
Modified   : ��������� ��ࠡ�⪠ 㤠����� ���㬥��
Modified   : 
Modified   :
Modified   : Revision 1.2  2007/06/13 13:29:29  lavrinenko
Modified   :  ��ࠡ�⪠ �� ����砭�� �� �६� ���樨
Modified   : 
Modified   : Revision 1.1  2007/06/07 09:33:21  lavrinenko
Modified   : процедура проверки на красное сальдо
Modified   :
---------------------------------------------------------------------- */
{globals.i}
{intrface.get xclass}
{intrface.get acct}
{intrface.get count}

{wordwrap.def}
{tmprecid.def}

{intrface.get bank}
{intrface.get swi}
{intrface.get terr}
{intrface.get instrum}
{intrface.get re}
{intrface.get tmess}
{intrface.get comm}

{intrface.get ps}
{intrface.get strng}

{chkop117.i}
{sh-defs.i}

/** ��� ����஫� �����ᨨ �� ������� �ᯮ��㥬...*/
{ulib.i}
{pir-chkop-6.def}
{pir-chkop-8-2.def}

&SCOP line-status "���"

DEFINE INPUT PARAMETER iRecOp AS RECID.
DEFINE INPUT PARAMETER iParam AS CHAR.

DEFINE BUFFER b-op-entry FOR op-entry.
DEFINE BUFFER b-acct FOR acct.
DEFINE BUFFER b-op FOR op.

DEFINE VARIABLE vDate        AS DATE    NO-UNDO.
DEFINE VARIABLE vSumSaldo    AS DECIMAL NO-UNDO.
DEFINE VARIABLE vSumOld      AS DECIMAL NO-UNDO.
DEFINE VARIABLE vCom         AS DECIMAL NO-UNDO.
DEFINE VARIABLE vSumFlag     AS LOGICAL NO-UNDO.
DEFINE VARIABLE vStatus      AS CHAR    NO-UNDO.
DEFINE VARIABLE vSelfList    AS CHAR    NO-UNDO.
DEFINE VARIABLE vUserList    AS CHAR    NO-UNDO.
DEFINE VARIABLE vOp-kindList AS CHAR    NO-UNDO.
DEFINE VARIABLE vI           AS INT     NO-UNDO.
/* ��� 275-�� */
DEFINE VARIABLE vINN           AS CHAR    NO-UNDO.
DEFINE VARIABLE vNamePl        AS CHAR    NO-UNDO.
DEFINE VARIABLE vDetails1       AS CHAR    NO-UNDO.
DEFINE VARIABLE vDetails2       AS CHAR    NO-UNDO.
DEFINE VARIABLE vDetails3      AS CHAR    NO-UNDO.

DEFINE VARIABLE TEMP AS CHAR NO-UNDO.

DEF VAR oAcct AS TAcctBal NO-UNDO.


ASSIGN  
   vStatus       = FGetSetting('��������', '', '��' )
   vSelfList     = FGetSetting('PIRSelf','',?)
   vUserList     = FGetSetting('PIRUser','',?)
   vOp-kindList  = FGetSetting('���थ��','Befcl',?)
   pick-value    = 'no'
. 

/* message ' ��襫 ����� pir-chkop.p iparam = ' iParam VIEW-AS ALERT-BOX ERROR . */

/* �஢�ઠ �� ����稥 ���㬥�� */
FIND FIRST op WHERE RECID(op) = iRecOp NO-LOCK NO-ERROR.
IF NOT AVAIL op THEN DO:
  BELL.
  MESSAGE COLOR MESSAGE "�� ������� ������ <op>"
  VIEW-AS ALERT-BOX ERROR
  TITLE "������".
  RETURN.
END.

/***************************
 * ��� #683
 * �� ����室��� ��� ⮣�,
 * �⮡� ��।����� ���ࠢ�����
 * ��������� �����.
 ***************************/
DEF VAR direct AS CHARACTER INITIAL ? NO-UNDO.

DEF VAR oPoValid  AS TPOValid  NO-UNDO.
DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR lResult   AS LOG       NO-UNDO.

DEF VAR newDate   AS DATE INIT ? NO-UNDO.
DEF VAR oldDate   AS DATE INIT ? NO-UNDO.

ASSIGN
  newDate = op.op-date
  oldDate = op.op-date
.

DEF BUFFER fOp-entry FOR op-entry.
FIND FIRST fOp-entry OF op NO-LOCK NO-ERROR.

/*** ����� #683 ***/

IF AVAILABLE(fOp-entry) THEN DO:
	IF op.op-status>fop-entry.op-status THEN direct="up".
	IF op.op-status<fop-entry.op-status THEN direct="down".

        ASSIGN 
          oldDate = fop-entry.op-date
          newDate = op.op-date
        .

END.



 oPoValid  = new TPOValid(iRecOp).
 oSysClass = NEW TSysClass().

IF (iParam EQ "status") THEN
   DO:
	   /*********************************************
	    *                                    			      *
	    * �������� ����� ��� �믮������     *
	    * �� ᬥ�� �����.                 		      *
            * ����⨥: onStatusChange                     *
	    * �������� �� ᫥���騥                    *
	    * ���㬥���:                                            *
            *  1. ������� ����� ���㬥��;           *
	    *  2. �������� ����� ���㬥��;           *
	    *  3. �⪠��� ���㬥��;                          *
	    *  4. ���㫨஢��� ���㬥��.                 *
	    *                                                                *
	    ********************************************
	    * ����: ��᫮� �. �. (Maslov D. A.)     *
	    * ���: #638                                        *
	    * ��� ᮧ�����: 17.02.11                     *
	    *********************************************/
		{pir-onstatuschange.i}

   END.


	   /**************************************************
	    *
	    * �������� ����� ��� �믮������
	    * ���� ࠧ!
	    * ����⨥: 
	    * onDocChangeState
	    * �������� �� ᫥���騥 ����⢨�:
	    *    1. ��ᬮ���� ���㬥��;
	    *    2. ������஢��� ���㬥��;
	    *    3. �������� ����� ���㬥��;
	    *    4. ������஢��� �஢����.
	    *   
            *
	    **************************************************/

IF (iParam EQ "status" AND op.op-status EQ "�") OR iParam EQ "" THEN
    DO:
	   {pir-ondocchstate.i} 
    END.

DELETE OBJECT oPOValid  NO-ERROR.   
DELETE OBJECT oSysClass NO-ERROR.

/*  �஢�ઠ �࠭� 23/07/2010 � �裡 � ��������ﬨ � 60�� ����. ������ ��� ����� � base-pp.p)   
    �ନ��� �.�.: ���������,।���஢���� ���㬥�⮢ 㦥 ����祭��� ������ ����஫�� 
	FOR EACH op-entry OF op NO-LOCK:
	IF ( iParam = ''  )   	
				
				AND    op.op-status EQ op-entry.op-status   
				AND   NOT CAN-DO ('�-10-2,�-2-3',GetXAttrValueEx("_User", USERID('bisquit'),"group-id",?))    
				AND    GetXattrValueEx("op", string(op.op), "PIRcheckVO","") EQ "��"  
	THEN	DO:
			  MESSAGE COLOR WHITE/RED 
		    		" ���㬥�� �஬�ન஢�� ���㤭���� ����⭮�� ����஫� !!!" skip
		    		" ��������� �᭮���� ४����⮢ ���������� !!!" skip
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		      			RETURN.  				
		END.
	 ELSE message "!!!!! " iParam .	
END.
�����  */



/* ᬥ�� ����/����� ���㬥��/㤠����� */
IF CAN-DO('date,status,op-entry,delete', iParam ) and NOT CAN-DO(vOp-kindList,op.op-kind) THEN DO:  
   FOR EACH op-entry OF op NO-LOCK:

   vDate         = MAXIMUM (op.op-date,op-entry.op-date).


/**********
  ��������� �������� ��� �������� ������������ �������� ������
 **********/

IF op.op-date >= 01/01/2013 
  AND ( CAN-DO(FGetSetting('PirChkOp','DenyAcct','!*'),op-entry.acct-db) OR CAN-DO(FGetSetting('PirChkOp','DenyAcct','!*'),op-entry.acct-cr)) THEN DO:

   MESSAGE COLOR WHITE/RED 
          "�� ��⠥��� �ᯮ�짮���� �訡��� ��室��/��室�� ���."
          VIEW-AS ALERT-BOX TITLE "�訡�� ���㬥��".
       RETURN. 

END.


/**********************************************************************
 * Check #1
 **********************************************************************/

/** �஢�ઠ ����窨 � ��ࠧ栬� �����ᥩ */
{pir-chksgn.i &ope=op-entry}







/**********************************************************************
 * Check #2
 **********************************************************************/

/* �஢�ઠ ����⮪ ᠬ�����஫� */		


IF op.user-id EQ USERID('bisquit') AND 
          op.op-status GT op-entry.op-status AND
          MAXIMUM(op.op-status, op-entry.op-status) GE '�' AND   
          NOT CAN-DO(vSelfList,GetXAttrValueEx("_User", USERID('bisquit'),"group-id",?)) THEN DO:
              MESSAGE COLOR WHITE/RED 
                " �� �� ����� �ࠢ� ����஫�஢��� ᮡ�⢥��� ���㬥��� !!!"
                VIEW-AS ALERT-BOX TITLE "�訡�� ���㬥��".
          RETURN. 
END.  






/**********************************************************************
 * Check #3
 **********************************************************************/

/* ����� ।���஢���� ���㬥�⮢ � ��᮪�� �����ᮬ ���㤭��� �� ��饬��� ����஫��஬ ������� ���㬥�� */

IF op.user-inspector NE "" AND op.user-inspector NE ? AND op.user-inspect NE USERID('bisquit') AND MAXIMUM(op.op-status, op-entry.op-status) GE '�' THEN DO:
				MESSAGE COLOR WHITE/RED 
		    		" �� �� ����� �ࠢ� ।���஢��� �ப���஫�஢���� ���㬥�� !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		      			RETURN.  				
END. 
 






/**********************************************************************
 * Check #4
 **********************************************************************/

/* �஢�ઠ ��७�� �����  � ��㣮� �����*/
/*
IF  CAN-DO('date', iParam ) and (op-entry.acct-db begins "202" or op-entry.acct-cr begins "202") THEN
      DO:
        IF month(today) ne month(op-entry.op-date) and month(op-entry.op-date) ne month(op.op-date) THEN
        DO:
			  MESSAGE COLOR WHITE/RED 
		    		" ���㬥�� �� ���� �ᯮ����� � ��㣮� ����� !!!" skip
		    		" �������� 202 ���⭮��� 㦥 ᤠ�� !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		      			RETURN.  				
		END.        
END. */ 







/**********************************************************************
 * Check #5
 **********************************************************************/
define variable accts_vo as character init 
"*30111*,*30114*,*30122*,*30123*,*30230*,*30231*,*40803*,*40804*,*40805*,*40806*,*40807*,*40808*,*40809*,*40810*,
*40811*,*40812*,*40813*,*40814*,*40815*,*40818*,*40819*,*40820*,*42501*,*42502*,*42503*,*42504*,
*42505*,*42506*,*42507*,*42607*,*42601*,*42602*,*42603*,*42604*,*42605*,*42606*,*42607*,*42608*,*42609*,*42610*,
*42611*,*42612*,*42613*,*42614*,*42615*,*44001*,*44002*,*44003*,*44004*,*44005*,*44006*,*44007*" no-undo.

define variable accts_vo2 as character init 
"30111*,30114*,30122*,30123*,30230*,30231*,40803*,40804*,40805*,40806*,40807*,40808*,40809*,40810*,
40811*,40812*,40813*,40814*,40815*,40818*,40819*,40820*,42501*,42502*,42503*,42504*,
42505*,42506*,42507*,42607*,42601*,42602*,42603*,42604*,42605*,42606*,42607*,42608*,42609*,42610*,
42611*,42612*,42613*,42614*,42615*,44001*,44002*,44003*,44004*,44005*,44006*,44007*" no-undo.

define variable accts_vo3 as character init "405*,406*,407*,408*,421*,422*,423*,424*,425*,426*" no-undo. /* ��� ����⮢ */

/* �஢�ઠ ����⭮�� ����஫� */
/* #3541 */ 
if logical (FGetSetting("PirChkOp","Pir3541","YES"))  then do:
	if (op.op-status GT "���") and 
	(op.op-status NE "���") and 
	can-do("!09,*",op.doc-type)
	and not can-do("05*",op.op-kind) 
        and can-do (accts_vo2 + ",30102*" + accts_vo3, op-entry.acct-cr) /* ��� �� �� + ������᪨� ��� + ����.����*/
	and can-do (accts_vo3, op-entry.acct-db) then do:
		find first acct where acct.acct eq op-entry.acct-db no-lock no-error.
		if available acct and acct.cust-cat eq "�" then do:
			if  GetXattrValueEx("op", string(op.op), "PIRcheckVO","") NE "��" and
			(can-do (accts_vo2, string (op.ben-acct)) or 
			can-do (accts_vo, string (op.name-ben)) or 
			can-do (accts_vo, string (op.details))) then do:
				message color white/red " ���㬥�� �� �஢�७ ������ ����஫��! " skip
				" ���쭥��� ࠡ�� � ��� ����������! "
				view-as alert-box
				title "�訡�� #3541".
				return.
			end.
		end.
	end.
end.




IF  (op.op-status GT "���") and 
	(op.op-status NE "���") and (
				ChckAcctNecessary(op-entry.acct-db,"��,��") or 
				ChckAcctNecessary(op-entry.acct-cr,"��,��") or 
      				CAN-DO('40807*,40820*,426*,425*,30111*,30231*', TRIM (op.ben-acct))	
				) and 

      			
			 not can-do("05*",op.op-kind)
      			 THEN


      DO:
        
	IF  GetXattrValueEx("op", string(op.op), "PIRcheckVO","") NE "��" AND
	(  
				/* 1) Vznos-snyatie po kasse */ 
	
		(op-entry.acct-db BEGINS "20202"  and op-entry.acct-cr BEGINS "40807" and substring(op-entry.acct-cr,14,3) NE "050") OR
		(op-entry.acct-db BEGINS "40807"  and op-entry.acct-cr BEGINS "20202" and substring(op-entry.acct-db,14,3) NE "050") 
		
		OR		/* 2) Perevodi rez-nerez  vnutri banka */ 
	
		(						
		 CAN-DO('40807*,40820*,426*,425*', TRIM (op-entry.acct-db)) AND 
		 CAN-DO('401*,402*,403*,404*,405*,406*,407*,40802*,40817*,423*,40807*,40820*,426*,425*', TRIM (op-entry.acct-cr))		
		) 
		OR		
		(						
		 CAN-DO('40807*,40820*,426*,425*', TRIM (op-entry.acct-cr)) AND 
		 CAN-DO('401*,402*,403*,404*,405*,406*,407*,40802*,40817*,423*,40807*,40820*,426*,425*', TRIM (op-entry.acct-db))		
		) 

		OR		/* 3) Vneshnie perevodi rezov */ 

		(							
		 CAN-DO('!.............050....,401*,402*,403*,404*,405*,406*,407*,40802*,40817*,423*', TRIM (op-entry.acct-db)) AND 
		 CAN-DO('30102*,30110*,30109*', TRIM (op-entry.acct-cr)) AND
		 CAN-DO('40807*,40820*,426*,425*,30111*,30231*', TRIM (op.ben-acct))		
		) 


		OR		/* 4) Vneshnie perevodi nerezov */ 

		(						
		 CAN-DO('40807*,40820*,426*,425*', TRIM (op-entry.acct-db)) AND 
		 CAN-DO('30102*,30110*,30109*', TRIM (op-entry.acct-cr))		
		) 
	   )
        THEN
        DO:
			  MESSAGE COLOR WHITE/RED 
		    		" ���㬥�� �� �஢�७ ������ ����஫��! " skip
		    		" ���쭥��� ࠡ�� � ��� ����������! "
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		      			RETURN.  				
		    END.        
END. 


/* �஢�ઠ ����⭮�� ����஫� 2: ����� ���㫨஢��� ���㬥�⮢ � ���⠢����� ��� ४�� PIRcheckVO */
IF  ((op.op-status EQ "�") OR (op-entry.op-status EQ "�")) AND  GetXattrValueEx("op", string(op.op), "PIRcheckVO","") EQ "��" THEN
        DO:
			  MESSAGE COLOR WHITE/RED 
		    		" ���㬥�� �ப���஫�஢�� ������ ����஫�� !!!" skip
		    		" ��㫨஢��� ��� ����� !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		      			RETURN.  				
END. 


/**********************************************************************
 * Check #6
 **********************************************************************/

/* �஢�ઠ ����� */
{pir-chkop-6.i}




/**********************************************************************
 * Check #7
 **********************************************************************/

/* �஢�ઠ �஢�ન ��ࠢ�� ����⨪� */
IF GetXAttrValueEx("op-entry",STRING(op-entry.op) + "," + STRING(op-entry.op-entry),"CardStatus","") eq "����" 
        THEN
        DO:
			  MESSAGE COLOR WHITE/RED 
		    		" ���㬥�� ��ࠢ��� � ����ᨭ� UCS !!!" skip
		    		" ���쭥��� ࠡ�� � ��� ���������� !!!" skip
		    		" ��� �襭�� ����� ����� �������� � ��ࠢ����� ����⨪���� ���� !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		      			RETURN.  				
		END.
/* ����� �஢�ન ��ࠢ�� ����⨪� */








/**********************************************************************
 * Check #8
 **********************************************************************/

/* ��ࠡ�⪠ 275-�� c 15.01.2008 */
IF can-do("01*,02,06,016,019",op.doc-type) and op.acct-cat eq "b" and op.op-date GT 01/14/2008 and op.op-date LT 12/07/2009 and not can-do("70*,60*",op-entry.acct-cr) 
			and CAN-DO('date,status', iParam ) and can-do("40*",op-entry.acct-db)
			THEN
		DO:	 

				 vINN = "".
				 vDetails1 = "".
				 vDetails2 = "".
				 vDetails3 = "".
				 
				 
				 
				 FIND FIRST b-acct where b-acct.acct eq op-entry.acct-db /* and not can-do("409*",op-entry.acct-db)*/ no-lock no-error.
				 
				 CASE b-acct.cust-cat:
				      WHEN "�"  THEN 
				          DO:
				 	     FIND FIRST cust-corp WHERE cust-corp.cust-id EQ b-acct.cust-id NO-LOCK NO-ERROR.


/*
   �஢��塞 ���� �� ������ १����⮬.
   �᫨ ������ १�����, ⮣�� �஢��塞 ��� ���.
   �᫨ ������ ��१�����, � �� ��� �� ᬮ�ਬ �����.
   � ����⢥ 䫠�� ��������/���������� �ᯮ��㥬 �᭮���� ४�����
   country-id.
*/				 	     
				 	     IF cust-corp.country-id EQ "RUS" OR cust-corp.country-id EQ "" THEN
				 	       DO:
				 	          vINN = REPLACE(cust-corp.inn,"0","").
				 	          IF vINN eq "" then vINN = GetXAttrValue('op',STRING(op.op),'inn-send').
				 	          vINN = REPLACE(vINN,"0","").
				 	     
				 	          IF vINN eq "" THEN
				 		     DO:
				 		        MESSAGE COLOR WHITE/RED
				 		        " �訡�� 275-�� !!!" skip
				 		        " � �ਤ��᪮�� ��� ��������� ��� (���) !!!" skip
				 		        " ����� ࠡ���� � ⠪�� ⨯�� ���㬥�� !!!"
				                        VIEW-AS ALERT-BOX 
		                                        TITLE "�訡�� ���㬥��".
		      				       RETURN.
				 		     END.
				 	       END. /* ����� ��������/���������� */
				    END. /* ����� � */ 
          WHEN "�"  THEN
          DO:
            FIND FIRST person WHERE person.person-id  EQ b-acct.cust-id NO-LOCK NO-ERROR.
            vINN = REPLACE(person.inn,"0","").
            IF vINN eq "" then vINN = GetXAttrValue('op',STRING(op.op),'inn-send').
				 		vINN = REPLACE(vINN,"0","").
				 		IF vINN eq "" THEN
				 		DO:
				 		vNamePl = REPLACE(GetXAttrValue('op',STRING(op.op),'name-send'),"~n"," ").
				 		vNamePl = REPLACE(vNamePl,","," ").
				 		vNamePl = REPLACE(vNamePl,"."," ").
				 		IF NUM-ENTRIES(vNamePl," ") < 5 THEN
				 		DO:
				 		MESSAGE COLOR WHITE/RED
				 				" �訡�� 275-�� !!!" skip
				 				" � 䨧��᪮�� ��� ��������� ��� (���) !!!" skip
				 				" ����室��� ��������� ���४����� name-send (������. ������ + ���� �஦������) !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		      			RETURN.
				 		END.
				 		END. /* ����� vINN */
          END. /* ����� � */
         END. /* ����� CASE */

END. /* ����� 275 �� */

{pir-chkop-8-2.i}


/**********************************************************************
 * Check #9
 **********************************************************************/

/* ����� ।���஢���� ���� ���㬥�⮢  
IF ((op.user-inspector NE USERID('bisquit') and op.user-inspector ne "") 
			    or  (op.user-id NE USERID('bisquit') and  NOT CAN-DO(vUserList,op.user-id))
			    )
		     and CAN-DO('date,op-entry', iParam )
		THEN DO:
				MESSAGE COLOR WHITE/RED 
		    		" �� �� ����� �ࠢ� ।���஢��� �㦮� ���㬥�� !!!"
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		      			RETURN.  				
END. */ /* IF op.user-inspector NE USERID('bisquit') AND op.user-id NE USERID('bisquit') */






/**********************************************************************
 * Check #10
 **********************************************************************/

/* �஢�ઠ ���㬥�⮢ ᮧ������ ����� �࠭���樥� */
/*	
FIND FIRST b-op where b-op.op-transaction EQ op.op-transaction and  b-op.op NE op.op  no-lock no-error.
	  IF AVAIL b-op and ((CAN-DO('date,op-entry,delete', iParam )) or (CAN-DO('status',iParam) and op.op-status EQ "�")) THEN
DO:
	  	MESSAGE COLOR WHITE/RED 
		  " ���㬥�� ����� ।���஢���, ��⮬� �� �� ����� �易��� ���㬥�� !!!"
		  VIEW-AS ALERT-BOX 
		  TITLE "�訡�� ���㬥��".
		  RETURN.
END.
*/





/**********************************************************************
 * Check #11
 **********************************************************************/

/* ��ࠡ�⪠ ���㬥�⮢ ��� ��� */
IF op-entry.acct-cr BEGINS "30102" THEN 
      DO:



/**********************************************************************
 * SUB Check #11.1
 **********************************************************************/
/* �஢�ઠ �� ࠧ��୮��� �����祭�� ���⥦� �� ��ࠢ�� ���㬥�⮢ � ��� */
	IF LENGTH (op.details) GT 210 THEN 
	DO: 
		MESSAGE " � ���㬥�� � " op.doc-num SKIP " �����祭�� ���⥦� ����� 210 ᨬ�����" SKIP
            	" ��ࠢ�� � ��� ���������� !"
            	VIEW-AS ALERT-BOX WARNING
            	TITLE "�।�०�����".
    END.

/**********************************************************************
 * SUB Check #11.2
 **********************************************************************/
/* ��ࠡ�⪠ ���㬥�⮢ ��ࠢ������ � ��� */
IF (MINIMUM(op.op-status, op-entry.op-status) EQ '�' OR CAN-DO('date,delete',iParam)) THEN 
	DO:

/*��᮪ �� ��� 3458 */
		if can-find (first PackObject where PackObject.file-name eq 'op-entry' and 
			PackObject.Surrogate eq string(op-entry.op) + "," + string(op-entry.op-entry) and
			PackObject.kind eq "RKCReturn") and
			not can-find (first PackObject where PackObject.file-name eq 'op-entry' and 
			PackObject.Surrogate eq string(op-entry.op) + "," + string(op-entry.op-entry) and
			PackObject.kind ne "RKCReturn") and
			can-do (FGetSetting("PirChkOp","Pir3458",""), userid('bisquit')) and 
			can-do (op.user-id, "MCI") and
			(can-do (op.doc-type, "02") or can-do (op.doc-type, "015"))
		then do:
			if op.op-status ne op-entry.op-status then do:
				run Fill-SysMes IN h_tmess ("","",3,"��������! #3458\n�� 㢥७�, �� ��� ���㫨஢��� ���㬥�� ����祭�� �� ���?\n|��,���").
				if pick-value="2" then return.
			end.
		end. 
/*����� ��᪠ �� ��� 3458 */
		else do:
/* ����� ��।��塞 ����稥 䠪� ���㧪� � ������ᢨ� �訡�� */	
			FIND FIRST PackObject WHERE 
				PackObject.Surrogate EQ (STRING (op-entry.op) + ',' + STRING(op-entry.op-entry)) AND
				PackObject.File-Name   EQ "op-entry" 
				NO-LOCK NO-ERROR.
			IF AVAIL PackObject THEN 
				FIND FIRST Packet WHERE 
					PackObject.PacketID EQ Packet.PacketID AND
					NOT {assigned Packet.PackError} 
					NO-LOCK NO-ERROR.
				IF AVAIL Packet AND
				NOT CAN-FIND(Packet WHERE 
				PackObject.PacketID EQ Packet.PacketID AND
				{assigned Packet.PackError} ) THEN 
				DO:
					MESSAGE COLOR WHITE/RED 
					" ���㬥�� � " op.doc-num " ��ࠢ��� � ��� " SKIP
					" ��������� ����饭� !!!"
					VIEW-AS ALERT-BOX 
					TITLE "�訡�� ���㬥��".
					RETURN.
				END.
		end.
	END. 		 	

/**********************************************************************
 * SUB Check #11.3
 **********************************************************************/
/* �஢�ઠ �� ������� �� ��� (��ॢ��) 
	१����� ���᫥��� ������ �஢�ન ���� �ᯮ�짮������ 
	� �஢�થ 11.4
*/	

def buffer bfrAcct for Acct.
def var temp40821 as char INIT "" NO-UNDO.
IF LOGICAL(FGetSetting("PirChkOp","PirRKOStatus","YES")) THEN DO:

vCom = 0.
IF CAN-DO('status',iParam) THEN 
  DO:			
       if op-entry.acct-db begins "40821" then 
        do:

           oAcct = NEW TAcctBal(op-entry.acct-db).
	     TEMP = oAcct:getAlias40821(op-entry.op-date).
           DELETE OBJECT oAcct.

           FIND FIRST b-acct WHERE b-acct.acct = TEMP NO-LOCK NO-ERROR.

        end.
        else
        do:
  	   FIND FIRST b-acct WHERE b-acct.acct = op-entry.acct-db NO-LOCK NO-ERROR.
        end.

       if op-entry.acct-db BEGINS "40702" then
       do:
           temp40821 = "".
          FIND FIRST bfracct WHERE bfracct.cust-id = b-acct.cust-id 
                               AND bfracct.acct begins "40821*" NO-LOCK NO-ERROR.
          IF AVAILABLE (bfrAcct) then temp40821 = bfracct.acct.

       end.

		IF AVAIL b-acct AND GetXAttrValueEx("acct", b-acct.acct + "," + b-acct.currency,"�������줮",?) EQ "�����" 
		          AND MAXIMUM(op.op-status, op-entry.op-status) GE "���"	and b-acct.cust-cat ne "�"   
		          AND NOT CAN-DO("40101810*,40201810*,40402810*",op.ben-acct)
		          /* AND NOT CAN-DO("1,2,3,4",op.order-pay) */
		          AND NOT CAN-DO("016",op.doc-type)
		          AND can-do("30109*,30110*,405*,406*,407*,40802*,40803*,40804*,40805*,40817*,423*",b-acct.acct)
		          THEN 
		DO:
/*		                message b-acct.acct VIEW-AS ALERT-BOX.*/
				RUN acct-pos IN h_base (b-acct.acct, b-acct.currency, vDate, vDate, {&line-status}).
				
				/** ���뢠�� ����� �� ���� */
				/** �ਢ易� �� ��� � �������� �����? */
				FIND FIRST loan-acct WHERE 
					loan-acct.contract = "�����"
					AND
					loan-acct.acct-type = "�����"
					AND
					loan-acct.since <= vDate
					AND
					loan-acct.acct = b-acct.acct
					NO-LOCK NO-ERROR.
				IF AVAIL loan-acct THEN DO:
					/** �᫨ ��� ������, � ��⥬ ����� �� ����� ���, ��ᯮ�짮������ 
					�㭪樥� �� �������� */
					sh-bal = ABS(sh-bal) - ABS(GetLoanLimit_ULL(loan-acct.contract, loan-acct.cont-code, vDate, false)).
				END.
									
				/* ������� �� ��ॢ�� */
				vI = 0.
				FOR EACH b-op-entry where 
						(b-op-entry.acct-db eq b-acct.acct or
						b-op-entry.acct-db eq op-entry.acct-db or 
						b-op-entry.acct-db eq temp40821) and
						b-op-entry.acct-cr BEGINS "30102" and 
						b-op-entry.op-status >= "���" and 
						b-op-entry.op-date eq vDate 
						NO-LOCK,
					FIRST b-op OF b-op-entry WHERE
					    b-op.op-status >= "���"
					    AND NOT CAN-DO("40101810*,40201810*,40402810*", b-op.ben-acct)
						/* AND NOT CAN-DO("1,2,3,4",b-op.order-pay) */
						AND NOT CAN-DO("016",b-op.doc-type)
		          		AND can-do("30109*,30110*,405*,406*,407*,40802*,40803*,40804*,40805*,40817*,423*,40821*,40807*",b-op-entry.acct-db)
		         :
/*                message b-acct.acct sh-bal VIEW-AS ALERT-BOX.	*/
				 /** ��� ������ ��������� �஢���� ���⠥� �㬬� �����ᨨ � �ਡ���� �� � ࠭�� ���⠭��� */
				 vCom = vCom + GetSumRate_ULL("K01TAR", b-acct.currency, b-op-entry.amt-rub, b-acct.acct, 0, vDate, false).
				 vI = vI + 1.
				END.
        
				Sh-bal = ABS(sh-bal) - (vCom).

				IF Sh-bal < 0 THEN 
				DO:
        MESSAGE COLOR WHITE/RED 
      	  "�� " (IF iParam EQ 'delete' THEN "㤠�����" 
      	  ELSE ("��������� " + (IF iParam EQ 'date' THEN "����" ELSE (IF iParam EQ 'status'THEN "�����" ELSE "�஢����" ))))
      	        " ���㬥�� � " op.doc-num SKIP
/*                " �� ���� � " b-acct.acct "~n" */
                " �� ���� � " op-entry.acct-db "~n" 
                " �� 墠⠥� �।�� ��� ���� �����ᨨ �� ��ॢ�� "
               TRIM(STRING(ABS(Sh-bal),"->>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>9.99"))
              "��" STRING(lastmove,"99.99.9999")
              VIEW-AS ALERT-BOX ERROR
              TITLE "�訡�� ���㬥��".
        RETURN.  
        END. 
    END.    
	END. /* ����� �஢��� ����ᨨ �� ��� 20 �� */
END.  /* IF op-entry.acct-cr BEGINS "30102" ��� */


/**********************************************************************
 * SUB Check #11.4
 **********************************************************************/
/* �஢�ઠ �� ������� �� ��� (����⮢�����) 
   ���뢠�� �㬬� vCom �� �஢�ન 11.3 */
   	

 IF CAN-DO('status',iParam) THEN 
  	DO:			
/*	  FIND FIRST b-acct WHERE b-acct.acct = op-entry.acct-db NO-LOCK NO-ERROR.*/
       if op-entry.acct-db begins "40821" then 
        do:
           oAcct = NEW TAcctBal(op-entry.acct-db).
                TEMP = oAcct:getAlias40821(op-entry.op-date).
           DELETE OBJECT oAcct.

           FIND FIRST b-acct WHERE b-acct.acct = TEMP NO-LOCK NO-ERROR.

        end.
        else
        do:
 	   FIND FIRST b-acct WHERE b-acct.acct = op-entry.acct-db NO-LOCK NO-ERROR.
        end.


		IF AVAIL b-acct AND GetXAttrValueEx("acct", b-acct.acct + "," + b-acct.currency,"�������줮",?) EQ "�����" 
		          AND MAXIMUM(op.op-status, op-entry.op-status) GE "���" and b-acct.cust-cat ne "�"
		          AND CAN-DO("0199", op.op-kind)
		THEN DO:
		
			RUN acct-pos IN h_base (b-acct.acct, b-acct.currency, vDate, vDate, {&line-status}).
	
			/** ���뢠�� ����� �� ���� */
			/** �ਢ易� �� ��� � �������� �����? */
			FIND FIRST loan-acct WHERE 
					loan-acct.contract = "�����"
					AND
					loan-acct.acct-type = "�����"
					AND
					loan-acct.since <= vDate
					AND
					loan-acct.acct = b-acct.acct
					NO-LOCK NO-ERROR.

			IF AVAIL loan-acct THEN DO:
					/** �᫨ ��� ������, � ��⥬ ����� �� ����� ���, ��ᯮ�짮������ 
					�㭪樥� �� �������� */
					sh-bal = ABS(sh-bal) - ABS(GetLoanLimit_ULL(loan-acct.contract, loan-acct.cont-code, vDate, false)).
			END.
			
			vCom = vCom + GetSumRate_ULL("K40911", b-acct.currency, op-entry.amt-rub, b-acct.acct, 0, vDate, false).

			Sh-bal = ABS(sh-bal) - (vCom).

			IF Sh-bal < 0 THEN DO:
		        MESSAGE COLOR WHITE/RED 
      	  			"�� " (IF iParam EQ 'delete' THEN "㤠�����" 
      	  					ELSE ("��������� " + (IF iParam EQ 'date' THEN "����" ELSE (IF iParam EQ 'status'THEN "�����" ELSE "�஢����" ))))
      	        	" ���㬥�� � " op.doc-num SKIP
                	" �� ���� � " b-acct.acct "~n" 
                	" �� 墠⠥� �।�� ��� ���� �����ᨨ �� ����⮢����� "
               		TRIM(STRING(ABS(Sh-bal),"->>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>>,>>9.99"))
              		"��" STRING(lastmove,"99.99.9999")
              		VIEW-AS ALERT-BOX ERROR
              		TITLE "�訡�� ���㬥��".
        		RETURN.  
        	END. 

			
		END.
	END.

END. /* �᫨ �஢�ઠ ����祭� */

			
/**********************************************************************
 * Check #12
 **********************************************************************/
		 /*********************************
		  * �᫨ ���짮��⥫� ����᫥� �
		  * ��, � ��� ���� ����砥��� �����
		  * �஢�ઠ �� ��᭮� ᠫ줮.
		  * !!! �������� !!!
		  * ���� �� �⮬ �⪫�砥���.
		  * 05.05.11 9:40
		  **********************************/
IF NOT CAN-DO(FGetSetting("PirChkop","PirRedSaldoV2","!*"),USERID("bisquit")) THEN DO:
/* �஢�ન �� ��᭮� ᠫ줮 */		
IF (MAXIMUM(op.op-status, op-entry.op-status) GE {&line-status} OR 'delete' EQ iParam) THEN 
DO:
	RELEASE history.

	{pir-chkac.i &suff=db &p-m="+" {&*}}
	{pir-chkac.i &suff=cr &p-m="-" {&*}}

	IF 'op-entry' EQ iParam THEN 
	DO:
		FIND LAST history WHERE history.file-name  EQ 'op-entry' AND 
								history.field-ref  EQ STRING(op.op) + ',' + STRING(op-entry.op-entry) AND 
				 				history.modif-date EQ TODAY AND
				 				history.modif-time GE (TIME - 10)
				 				NO-LOCK NO-ERROR. 
		IF AVAIL history THEN 
		DO:
			{pir-chkac.i &suff=db &p-m="+" {&*}}
	 		{pir-chkac.i &suff=cr &p-m="-" {&*}}
		END.
				
	END. 
			
END.

END.


/**********************************************************************
 * Check #13
 **********************************************************************/

/*
/* ��ࠡ�⪠ ���㬥�⮢ ������ - ����� �� ��ࠢ�� �⢥⮢ � ����ᮢ */
IF op.user-id eq "BNK-CL" and CAN-DO('status', iParam ) THEN
DO:	
		
	/* ������⥫�� �⢥� */		
	IF op-entry.op-status eq "�" and op.op-status > op-entry.op-status THEN 
	DO:
		auto = yes.
        RUN pir_e-tel195.p (op.op,"2557",op-entry.acct-db,substr(op-entry.acct-db,6,3),"196"). 
    END.
    
    
    /* ����⥫�� ����� �� ��㫨஢���� � � �訡�� */
	IF op.op-status eq "�"  or op.op-status eq "�" /* and op-entry.op-status ne "�" */ THEN 
	DO:
		auto = no.
		RUN pir_e-tel195.p (op.op,"2557",op-entry.acct-db,substr(op-entry.acct-db,6,3),"195").
    END.
END. /* ����� BNK-CL */

*/
/**********************************************************************
 * Check #14
 **********************************************************************/


/* �஢�ઠ ����஫� ���㬥�⮢ �ࠢ������ ����⨪���� ���� */

/*****************************************************
 * �믮����� ��ࠡ�⪨ ��					*
 * ��������� �᫮���, �� ���஬
 * �� ��।�� ���㬥�⮢ � ����⭮�
 * �ࠢ����� ������ ����� ���� 
 * �ࠢ����� ����⨪���� ����.
 *
 * ��� ᮧ�����: 11:20 16.05.2011
 * ���: #698
 * ����: ��᫮� �. �.
 ********************************/

IF LOGICAL(FGetSetting("PirChkOp","PirPlVisaStatus","YES")) THEN DO:

IF  (op.op-status GT "���") 
    AND CAN-DO('40817....000.050*,40820....000.050*',op-entry.acct-db)  
    AND GetXattrValueEx("op", string(op.op), "PIRcheckCARD","") NE "��" 
THEN
  DO:

	    /*** ������� �������� ��������� ***/
	     IF CAN-DO("!302*,30*",op-entry.acct-cr) THEN DO:
			  MESSAGE COLOR WHITE/RED 
		    		"�������� " + op.doc-num + " �� �㬬� " + STRING(op-entry.amt-rub) " ������� ���� �-11!" SKIP
				"��� ������� �������� �� ����� ���������." SKIP
		    	 	"���������� ������ � ��� ����������!"
		            VIEW-AS ALERT-BOX TITLE "������ #698".
		      			RETURN.  				
		
	     END.
	     ELSE DO:
		/***
		 * 100% �� �롮ન 㡨���
		 * �����ᨨ, �� ��筨�� ���ਨ
		 * ���� �� � ���� :-(
		 * 13:23 16.05.2011
		 ***/
		IF CAN-DO('01,015,016,016�,02',op.doc-type) THEN DO:
			  MESSAGE COLOR WHITE/RED 
		    		" ���㬥�� �� �஢�७ ��ࠢ������ ����⨪���� ����! " skip
		    		" ���쭥��� ࠡ�� � ��� ����������! "
		            VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥��".
		      			RETURN.  				
		END. /*  CAN-DO */
	     END. /* ELSE */
    END.        

END.

/**********************************************************************
 * Check #16                                                          *
 **********************************************************************/
/*
 * �뢮� ᮮ�饭�� �� ������� (mess)
****************************************************/

DEFINE VARIABLE cAcctDb  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAcctCr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKlAcct  AS CHARACTER INIT "405*,406*,407*,408*,42301*,42601*" NO-UNDO.

IF     (iParam EQ 'op-entry')
   AND NOT CAN-DO(FGetSetting("PIRNoMess", ?, ?), op.op-kind)
THEN DO:

   cAcctDb = op-entry.acct-db.
   cAcctCr = op-entry.acct-cr.

   IF (cAcctDb EQ ?)
   THEN DO:
      FIND FIRST b-op-entry OF op
         WHERE (b-op-entry.acct-cr EQ ?)
         NO-LOCK NO-ERROR.
      IF (AVAIL b-op-entry)
      THEN cAcctDb = b-op-entry.acct-db.
   END.

   IF (cAcctCr EQ ?)
   THEN DO:
      FIND FIRST b-op-entry OF op
         WHERE (b-op-entry.acct-db EQ ?)
         NO-LOCK NO-ERROR.
      IF (AVAIL b-op-entry)
      THEN cAcctCr = b-op-entry.acct-cr.
   END.

   IF     CAN-DO(cKlAcct, cAcctDb)
      AND NOT CAN-DO("70601*", cAcctCr)
   THEN
      RUN KlMess(cAcctDb).

   IF     CAN-DO(cKlAcct, cAcctCr)
      AND CAN-DO("202*", cAcctDb)
   THEN
      RUN KlMess(cAcctCr).
END.

PROCEDURE KlMess:
DEFINE INPUT PARAMETER icAcct AS CHARACTER NO-UNDO.
DEFINE VARIABLE        cMess  AS CHARACTER NO-UNDO.

   FIND FIRST acct
      WHERE (acct.acct EQ icAcct)
      NO-LOCK NO-ERROR.

   IF AVAIL acct
      AND (acct.cust-cat NE "�")
   THEN DO:
      cMess = GetXAttrValue(ENTRY(LOOKUP(acct.cust-cat, "�,�,�"), "cust-corp,person,banks"), STRING(acct.cust-id), "mess").
      IF (cMess NE "")
      THEN
         MESSAGE COLOR WHITE
            GetAcctClientName_UAL(icAcct, NO) SKIP
            cMess
            VIEW-AS ALERT-BOX
            TITLE "����饭�� �� �������".
   END.
END PROCEDURE.

/************************** END CHECK #16 ***************************/
/************************************************************************
* Check #17                                                             *
* ��� #931. �஢��塞, �⮡� � ��७�ᨬ�� ���㬥�� �� �뫮 ⥪��, *
* ᮤ�ঠ饣� ���� ����.���, � �᫨ ⠪�� �������, �뤠� ���짮��⥫�  *
* �।�०�����.                                                       *
************************************************************************/

IF (iParam EQ "date") THEN DO:
	IF (op.op-date NE op-entry.op-date) THEN DO:
		IF CAN-DO ("*" + STRING(op-entry.op-date,"99/99/9999") + "*,*"  + STRING(op-entry.op-date,"99.99.9999") + "*", STRING(op.details)) THEN DO:
			RUN Fill-SysMes IN h_tmess ("","",3,"��������! #931\n� ᮤ�ঠ��� ���㬥�� ���� ��� ᮢ������� � ⥪�騩 ����. ����.|�த������,�⬥����").
			IF pick-value="2" THEN Return.
		END. /* IF CAN-DO */
	END. /* IF (op.op-date) */
END. /* IF iParam */

/************************** END CHECK #17 ***************************/

/***********************************************************************
* Check #18                                                            *
* ��� #916. �஢��塞, �� ᮤ�ন� �� ��୮ᨬ� � ��㣮� ����.     *
* ���� ���㬥�� �痢� ⨯� PirLnkCom � ��㣨� ���㬥�⮬. ��        *
* ����稨 ⠪����, ��� ���짮��⥫� ����� - ��७��� �� �易��� *
* ���㬥��� ��� �� ��७���� ��祣�.                                  *
***********************************************************************/

DEF VAR chD        AS CHAR NO-UNDO INIT "".
DEF VAR pWhat      AS INT  NO-UNDO.
DEF VAR pWHERE     AS DATE NO-UNDO.
DEF VAR lRes       AS LOG  NO-UNDO.
DEF VAR trList     AS CHAR NO-UNDO.
DEF VAR roleList   AS CHAR NO-UNDO.
DEF VAR oSysClass3 AS TSysClass NO-UNDO.
DEF VAR oUser      AS TUser     NO-UNDO.

DEF VAR currDoc AS TDocument NO-UNDO.
DEF VAR lnkDocs AS TAArray   NO-UNDO.


 oUser = new TUser().
     roleList = oUser:getRoleList("05*").
 DELETE OBJECT oUser.

 oSysClass3 = new TSysClass().
    trList = oSysClass3:getCodeValue("PirLnkTrList",roleList,"!*").
 DELETE OBJECT oSysClass3.

IF CAN-DO(trList,op.op-kind) THEN DO:

chD = GetSysConf("pirchkop18-disabled").
IF (iParam EQ "date") AND NOT {assigned chd} THEN DO:
	IF (op.op-date NE op-entry.op-date) THEN DO:
                /**
                 * ��᫮� �. �. Maslov D. A.
                 * �� ��� #2063
                 * ��ॢ��� �� ������.
                 **/
                  currDoc = NEW TDocument(op.op).
                       lnkDocs = currDoc:getLnkDocs().

                       IF lnkDocs:length > 0 THEN DO:

                       RUN Fill-SysMes IN h_tmess ("","",3,"��������! #916\n� ���㬥�⮬ �易�� " + STRING(lnkDocs:length) + " ���㬥�⮢!\n|��७��� �� �易���,�⬥����").

                       IF pick-value="2" THEN DO:
                   	 RUN DeleteOldDataProtocol IN h_base ("pirchkop18-disabled").
                         DELETE OBJECT currDoc.
                         DELETE OBJECT lnkDocs.
                         RETURN.
                       END.
                     RUN SetSysConf IN h_base ("pirchkop18-disabled","yes").
                     RUN pir-lnk-move.p(lnkDocs:toList(),op.op-date,OUTPUT lRes).

                     IF NOT lRes THEN DO:
 		       RUN DeleteOldDataProtocol IN h_base ("pirchkop18-disabled").
                       DELETE OBJECT currDoc.
	               DELETE OBJECT lnkDocs.
                       RETURN.
                     END.

                  DELETE OBJECT currDoc.
                  DELETE OBJECT lnkDocs.
		RUN DeleteOldDataProtocol IN h_base ("pirchkop18-disabled").
               END. /* lnkDocs:length > 0 */
	END. /* IF (op.op-date) */
END. /* IF iParam */
END. /* �᫨ ���㬥�� �⭮���� � �易��� �࠭����� */

/************************** END CHECK #18 ***************************/


/* �᫨ �ந������ ��७�� ���㬥�� � ��㣮� ���� */
IF iParam = "date" THEN DO:
 {pir-onmovedate.i}
END.



/**********************************************************************
 * Check # NEW NEW NEW NEW NEW NEW NEW
 **********************************************************************/

/**
 * !!!!!!!!!!!!!!!!!!!!!!! 
 * �᫨ �㦭� �������� �஢���, ᤥ���� �� ��� ������� ���������
 */
 
END. /* FOR EACH op-entry OF op */
END. /* IF CAN-DO('date,status,op-entry,delete', iParam ) */





pick-value = "yes". 

{intrface.del}	
RETURN.
