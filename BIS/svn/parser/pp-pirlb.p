{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pp-pirlb.p,v $ $Revision: 1.24 $ $Date: 2011-02-08 10:32:35 $
Copyright     : ��� �� "�p������������"
���������    : pp-comm.p, extrpars.fun. �� ���������� ᬮ���� �� �ࠢ��쭮��� ����䥩ᮢ.
��稭�       : ����室������ �ᯮ�짮����� ᮡ�⢥���� �㭪権 ����� 
�����祭��    : ������⥪� �㭪権 ��� �� �p������������ ��� 㭨���ᠫ��� �࠭���権 
���� ����᪠ : ��堭��� ����� ������ᠫ��� �࠭���権 � ����奬� (���������� �/�)
����         : $Author: ermilov $ 
���������     : $Log: not supported by cvs2svn $

���������     : SStepanov 19/08/11 PIR_LOAN_PERCENT_NEW ���=6 � ��=4 ��� �������� 9 � ��� �१ op-int.mdate

���������     : SStepanov 16/08/11 PIR_LOAN_PERCENT_NEW ���� ��ਮ�� ������
�१ �������� 9 (���������=4 � �������=6)

���������     : Revision 1.23  2011/01/26 11:06:12  borisov
���������     : Novaja funkcija NOVAJ_UNK
���������     :
���������     : Revision 1.21  2010/10/27 10:56:54  ermilov
���������     : Changes in PIR_LOAN_PROCENT
���������     :
���������     : Revision 1.20  2010/09/24 10:32:57  borisov
���������     : Funkcija KLIENT_SOKR - dlja schetov 'V' = naim.scheta
���������     :
���������     : Revision 1.18  2010/09/17 11:53:00  borisov
���������     : Dobavil funkciyu ADRES_KLADR
���������     :
���������     : Revision 1.17  2010/09/14 12:09:37  borisov
���������     : Dobavil funkciyu NAIM_KLSOKR
���������     :
���������     : Revision 1.16  2010/07/21 08:30:49  ermilov
���������     : A new parameter for function PirComAcq - type of commision...
���������     :
���������     : Revision 1.15  2010/03/23 06:56:26  ermilov
���������     : fix some mistakes
���������     :
���������     : Revision 1.14  2010/03/18 10:12:43  ermilov
���������     : Updating PirComEkv function & added new func  PirSummProp
���������     :
���������     : Revision 1.13  2009/12/03 06:40:08  ermilov
���������     : Fix   some errors
���������     :
���������     : Revision 1.12  2009/11/24 07:30:16  ermilov
���������     : *** empty log message ***
���������     :
���������     : Revision 1.11  2009/11/24 07:28:18  ermilov
���������     : Delete unusual functions with "_51"
���������     :
���������     : Revision 1.10  2009/11/10 15:01:45  ermilov
���������     : added 2 new functions: PirComAcq for 51 and 53 patches
���������     :
���������     : Revision 1.9  2009/02/04 12:02:34  Buryagin
���������     : Added SysMess logging for Function card loan commissions
���������     :
���������     : Revision 1.8  2009/02/04 10:51:23  Buryagin
���������     : Added new Function for card loan commissions
���������     :
���������     : Revision 1.7  2009/01/22 12:06:33  ermilov
���������     : Added new function for finding pcard comission!
���������     :
���������     : Revision 1.6  2008/06/10 06:50:45  Buryagin
���������     : Fix the method of assign of the 'periodEnd' variable.
���������     :
���������     : Revision 1.5  2008/04/22 13:51:29  Buryagin
���������     : Added the new function witch returns the percent of loan by period
���������     :
���������     : Revision 1.4  2007/10/18 07:42:24  anisimov
���������     : no message
���������     :
���������     : Revision 1.3  2007/09/26 07:35:21  lavrinenko
���������     : ��������� �㭪�� PirTurn ��� ������ ����⮢ ������ , � 祫�� ॠ����樨 �襭�� �ࠢ����� �� 06,09,2007 �� ��⠭������� ᯥ樠���� ��䮢 ��� �鸞 �����⮢
���������     :
���������     : Revision 1.2  2007/08/28 14:13:39  lavrinenko
���������     : ��������� ��楤��  pir-GetAttrValue - ��� ����������  �/� �� ����奬�
���������     :
���������     : Revision 1.1  2007/07/12 14:20:11  lavrinenko
���������     : ᮡ�⢥��� � �㭪樨 ��� 㭨���ᠫ��� �࠭���権
���������     :
------------------------------------------------------ */


{globals.i}
{form.def}

{xattrpar.def}
{intrface.get xclass}
{intrface.get comm}
{intrface.get tmess}
{intrface.get pbase}
{intrface.get data}
{intrface.get card}
{intrface.get cust}
{intrface.get count}
{intrface.get instrum}
{intrface.get trans}
{intrface.get pkid}

{ulib.i}








{pfuncdef
   &LIBDEF        = "YES"
   &NAME          = "PIRLB"
   &LIBNAME       = "������⥪� �㭪権 ��� �� �p������������ ��� 㭨���ᠫ��� �࠭���権"
   &DESCRIPTION   = "����ন� �㭪樨 ࠧࠡ�⠭�� � ��� �� �p������������."
   }
   
{pfuncdef
   &NAME          = "������"
   &DESCRIPTION   = "�ந������ ���� �����ᨨ. ~
����易⥫�� ��ࠬ��஬ �������� ���������� ��।����� �த����⥫쭮��� ������ ~
�� �������� �� ���� ����樨. � ����⢥ ���祭�� ��ࠬ��� ����� ���� �ᯮ�짮���� ~
�㭪�� ��� �����।�⢥��� �᫮. ~
~~n� ��砥, �᫨ ������� �� �������, �㭪�� �����頥� �訡��, ~
� ��⨢��� ��砥 ������ �����⢫���� ��� �訡��, �����頥��� ���祭�� - 0. ~
��⠭���������� �� 㬮�砭�� ���祭�� �� ����易⥫쭮�� ��ࠬ��� ���������� ~
���ᯥ稢��� �뢮� �� ��࠭ ᮮ�饭�� �� �訡��."
   &PARAMETERS    = "���� ����������,��� ��������,C���,������[,������ ���������� = 0,[���������� = ��]]"
   &RESULT        = "�����"
   &SAMPLE        = "������(100,'%��_��','10201810000000010019','') = 2.2"
   }
   DEFINE INPUT  PARAMETER iSumm          AS DECIMAL    NO-UNDO.
   DEFINE INPUT  PARAMETER iCommName      AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER iAcct          AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER iCurrency      AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER iPeriod        AS INTEGER    NO-UNDO.
   DEFINE INPUT  PARAMETER iInterruption  AS LOGICAL    NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result     AS DECIMAL    NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok          AS INTEGER    NO-UNDO.


   DEFINE BUFFER commission FOR commission.  
   DEFINE BUFFER comm-rate  FOR comm-rate.
   DEFINE BUFFER acct       FOR acct.        

   out_result = 0.
   is-ok      = 0.

   {pchkpar iSumm iCommName iAcct}

   IF iCurrency <> "" THEN
   DO:
      {pchkpar iCurrency}
   END.

   IF iPeriod = ? THEN iPeriod = 0.
   IF iInterruption = ? THEN iInterruption = YES.
   
   RUN GET_HEAD_COMM(iCommName,iCurrency,iSumm,iPeriod,BUFFER commission).
   
   IF NOT AVAIL commission THEN 
   DO:
      IF iInterruption THEN
      DO:
         RUN Fill-SysMes("","commis01","","%s=" + iCommName).
         is-ok = -1.
      END.
      RETURN.
   END.

   IF iAcct NE "" AND iAcct NE ? THEN
      FIND FIRST acct WHERE 
                  acct.acct      = iAcct     AND 
                  acct.currency  = iCurrency NO-LOCK NO-ERROR.

   /* ����祭�� ���� ����ᨨ. */   
  
   RUN GET_COMM_BUF (iCommName,
                     IF AVAIL acct THEN RECID (acct) ELSE ?,
                     IF AVAIL acct THEN ? ELSE iCurrency,
                     "",
                     iSumm,iPeriod,GetBaseOpDate(),BUFFER comm-rate).

	 IF NOT AVAIL comm-rate THEN  DO:
      IF iInterruption THEN
      DO:
         RUN Fill-SysMes("","commis01","","%s=" + iCommName).
         is-ok = -1.
      END.
      RETURN.
   END.
   out_result = (IF AVAILABLE comm-rate
                 THEN (IF comm-rate.rate-fixed
                       THEN  comm-rate.rate-comm
                       ELSE (comm-rate.rate-comm / 100) * (iSumm - commission.min-value))
                 ELSE 0 ).
      
END PROCEDURE.


{pfuncdef
   &NAME          = "pir-GetAttrValue"
   &DESCRIPTION   = "����祭�� ���祭�� ४����� ��������� ����� ������ (��뫪� ������ �� ������쭮� ��६����� XATTR_Params), �ᯮ������ �� ��⠭���� ���祭�� �� 㬮�砭�� ��� �/� ���।�⢮� �����"
   &PARAMETERS    = "��� ��������� [�������� �� ���������]"
   &RESULT        = "���祭�� �/�"
   &SAMPLE        = "pir-GetAttrValue('op-enntry')"
   }
   DEFINE INPUT  PARAMETER iAttrName      AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER iDefault       AS CHARACTER  NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result     AS CHARACTER  NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok          AS INTEGER    NO-UNDO.

   DEFINE VARIABLE vClass     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vSurr      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vInstance  AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vHBuffer   AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vXattrs    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vOk        AS LOGICAL    NO-UNDO.

   DEFINE VARIABLE i          AS INTEGER    NO-UNDO.
   DEFINE BUFFER xattr FOR xattr.   /* ���������� ����. */

   ASSIGN     
      i = 2
      is-ok = 0
      out_result = iDefault
      
   .

   DO WHILE PROGRAM-NAME(i) <> ?:
     IF PROGRAM-NAME(i) MATCHES "*pir-GetAttrValue*" THEN RETURN.
     IF PROGRAM-NAME(i) MATCHES "*xattr-ed.p*"       THEN LEAVE.
     i = i + 1.
   END.

   IF NUM-ENTRIES(XATTR_Params) GT 1 AND 
      PROGRAM-NAME(i) MATCHES "*xattr-ed.p*" THEN DO:
        ASSIGN
           vClass = ENTRY(1,XATTR_Params)
           vSurr  = XATTR_Params
           ENTRY(1,vSurr) = ""
           vSurr  = SUBSTRING (vSurr,2) 
        .

           RUN PrepareInstance("").
           RUN GetInstance(vClass,vSurr,OUTPUT vInstance,OUTPUT vOk).
           IF vOk <> YES THEN DO:
              IF iDefault = ? THEN is-ok = -1.
              ELSE out_result = iDefault.
           END. ELSE DO:
              out_result = GetInstanceProp2(vInstance,iAttrName).
              IF out_result = {&RET-ERROR} THEN DO:
                 IF iDefault = ? THEN is-ok = -1.
                 ELSE out_result = iDefault.
              END.
          END.
/*          RUN DelEmptyInstance(vInstance). */
   END. /* IF NUM-ENTRIES(XATTR_Params) GT 1 */
     
END PROCEDURE. /* pir-GetAttrValue */

{pfuncdef
   &NAME          = "PirTurn"
   &DESCRIPTION   = "�ந������ ���� ����� �� �� ��� �� ��⮢ ������~
                     � ����ᯮ����樨 � ��⠬� 㪠����묨 � ��᪥~
                     ��稭�� � 㪠������ ����, १���� �����頥��� � �㡫��"
   &PARAMETERS    = "��� ������� - ��/��, ���� �������, ����� ������ � �������� ����������� ������, [���� � ������� ����������� ������]"
   &RESULT        = "����� � ������"
   &SAMPLE        = "PirTurn('��','40702810000000010019','20202*','','01/10/2005')"
   }
   
   DEFINE INPUT  PARAMETER iTurn          AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iAcct          LIKE acct.acct NO-UNDO.
   DEFINE INPUT  PARAMETER iMask          AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iBegDt         AS DATE        NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result     AS DECIMAL     NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok          AS INTEGER     NO-UNDO.

   DEFINE VARIABLE vBegDt  AS DATE                       NO-UNDO.
   DEFINE VARIABLE vEndDt  AS DATE                       NO-UNDO.
   
   DEFINE BUFFER   bacct     FOR  acct.
   DEFINE BUFFER   bacct-cli FOR  acct.
   DEFINE BUFFER   bop-entry FOR  op-entry.

   
   ASSIGN 
      vEndDt     = GetBaseOpDate()
      vBegDt     = IF iBegDt NE ? THEN iBegDt ELSE DATE (MONTH(vEndDt), 01, YEAR(vEndDt))
      out_Result = 0
      is-ok      = -1
  . 

   FIND FIRST bacct-cli WHERE bacct-cli.acct EQ iAcct NO-LOCK NO-ERROR.
   
   IF NOT AVAIL bacct-cli THEN DO:
      RUN Fill-SysMes("","", "0", "� �㭪樨 PirTurn �� ������ ��� " + iAcct + "!").
      RETURN.
   END. 
   
   IF bacct-cli.cust-cat EQ '�' THEN DO:
      RUN Fill-SysMes("","", "0", "� �㭪樨 PirTurn ��� " + iAcct + " �� ����� ���� ����७��� !").
      RETURN.
   END. 
   
   FOR EACH bacct WHERE bacct.cust-cat EQ bacct-cli.cust-cat AND  
                        bacct.cust-id  EQ bacct-cli.cust-id NO-LOCK,
       EACH bop-entry WHERE bop-entry.op-date GE vBegDt   AND  
                            bop-entry.op-date LE vEndDt AND  
                            (IF iTurn EQ '��' 
                              THEN (bop-entry.acct-db EQ bacct.acct AND
                                    CAN-DO(iMask,bop-entry.acct-cr)) 
                              ELSE (bop-entry.acct-cr EQ bacct.acct AND
                                    CAN-DO(iMask,bop-entry.acct-db)))
                            NO-LOCK:
       
        out_Result = out_Result + bop-entry.amt-rub.                      
        
   END. /* FOR EACH bacct WHERE*/

   is-ok = 0.
END PROCEDURE. /* PirTurn */

{pfuncdef
   &NAME          = "PIR_LOAN_PERCENT"
   &DESCRIPTION   = "�ந������ ���� ��業⮢ �� �।�⭮�� (����) �������� �� ��।��塞� ���짮��⥫��~
   ��ਮ�. ���뢠�� ��������� ���祭�� ��ࠬ��� 0, ��������� ��業⭮� �⠢�� �।%,~
   ������� �ᥣ� ��ਮ�� ���᫥��� �� �����ਮ�� �� 䠪�� ��� ���饭��� ��業⮢,~
   ᫥��� �� ���������� ���� ���᫥��� 365/366 ����. �᫨ ��᫥���� ��ࠬ��� "
   &PARAMETERS    = "���������� ��������, ����� ��������, ������ �������, ����� �������[, ������� ������� = ���]"
   &RESULT        = "����� ���������"
   &SAMPLE        = "@__amt = PIR_LOAN_PERCENT(@contract(10), @cont-code(10), @__beg-date, @__end-date)"
   }
   
   DEFINE INPUT  PARAMETER iContract        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iContCode        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iBegDate         AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate			AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iNeedMon			AS LOGICAL	NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result    	AS DECIMAL		NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok          	AS INTEGER		NO-UNDO.

   DEF VAR begDate AS DATE NO-UNDO.
   DEF VAR endDate AS DATE NO-UNDO.
   DEF VAR balance AS DECIMAL NO-UNDO.
   DEF VAR newBalance AS DECIMAL NO-UNDO.
   DEF VAR rate AS DECIMAL NO-UNDO.
   DEF VAR newRate AS DECIMAL NO-UNDO.
   DEF VAR summa AS DECIMAL NO-UNDO.
   DEF VAR totalSumma AS DECIMAL NO-UNDO.
   DEF VAR period AS INTEGER NO-UNDO.
   DEF VAR iDate AS DATE NO-UNDO.
   DEF VAR periodBegin AS DATE NO-UNDO.
   DEF VAR periodEnd AS DATE NO-UNDO.
   DEF VAR periodBase AS INTEGER NO-UNDO.
   
   DEF VAR mainLoan AS CHARACTER NO-UNDO.
   
   /** ���� ���� ��業⮢ 365/366 */
   
   FIND FIRST loan WHERE loan.contract = iContract
                     and loan.cont-code = iContCode
                     NO-LOCK NO-ERROR.
                     
   IF NOT AVAIL loan THEN DO:
      RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� '" + iContract + "." + iContCode + "' �� ������!").
      RETURN.
   END.

   mainLoan = GetMainLoan_ULL(loan.contract, loan.cont-code, false).
   
   begDate = iBegDate. endDate = iEndDate.
   
   periodBegin = MAX(begDate, loan.open-date + 1).
   /** � ����� ����� ��� ����砭�� �࠭� �������� �� ��室��� ����,
       ��� ����砭�� ��ਮ�� ���� ��業⮢ ������ ���� ᫥���騬 ࠡ�稬 ����.
       �����, ����� ��ࠦ���� 
   periodEnd = MIN(endDate, loan.end-date).
       �믮���� ���⮥ ��c������
   */
   periodEnd = endDate. 
   
   /** ���祭�� "��" ��ਮ�� */
   balance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, periodBegin - 1, false).
   rate = GetLoanCommission_ULL(ENTRY(1, mainLoan), ENTRY(2, mainLoan), "%�।", periodBegin, false).
   
   /** �������� �� ��� */
   DO iDate = periodBegin TO periodEnd :
	
	 IF loan.since < iDate THEN DO:
	 	RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + 
	 	                " �� �����⠭ �� ���� " + STRING(periodEnd)).
	 	RETURN. 
	 END.

     newBalance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, iDate, false).
     newRate = GetLoanCommission_ULL(ENTRY(1, mainLoan), ENTRY(2, mainLoan), "%�।", iDate + 1, false).
     
     /**    ����:
     	1) ��������� ���⮪
     	2) ���������� ��業⭠� �⠢��
     	3) ��᫥���� ���� �����
 		4) ��᫥���� ���� ���⭮�� ��ਮ��,
 			��:
 		"ᮧ����" �����ਮ�, ����뢠�� ���祭��, ����㫨�㥬 ����� �㬬�,
 		���� ���祭�� �⠭������ ⥪�騬�!
 	*/
 	 
     IF balance <> newBalance OR rate <> newRate OR (DAY(iDate + 1) = 1 AND iDate < periodEnd) 
        OR iDate = periodEnd THEN
       DO:
       	
	     periodEnd = iDate.
	     periodBase = (IF TRUNCATE(YEAR(iDate) / 4,0) = YEAR(iDate) / 4 THEN 366 ELSE 365).
	     period = periodEnd - periodBegin + 1.
	     summa = round(balance * rate / periodBase * period, 2).
		 totalSumma = totalSumma + summa.

		 /* � ��砥 �᫨ �㬬������ 㬥��訫��� ����� �� ��業�� ����襭�, ����塞 �� ��業�� ����� ���⠫� �� �⮣�!   */
		 IF newBalance < balance THEN totalSumma = 0 .
		 
	     IF iNeedMon THEN 
	     RUN Fill-SysMes("","", "1", "PirLoanPercent: " +
									 "loan = " + loan.contract + "." + loan.cont-code + 
	                                 ", balance = " + STRING(balance) + 
	                                 ", rate = " + STRING(rate) + 
	                                 ", periodBase = " + STRING(periodBase) +
	                                 ", period = " + STRING(period) + "(" + STRING(periodBegin) + " - " + STRING(periodEnd) + ")" +
	                                 ", summa = balance * rate / periodBase * period = " + STRING(summa) +
	                                 ", totalSumma = " + STRING(totalSumma)).
	                                 

		 periodBegin = periodEnd + 1.
		 periodEnd = MIN(endDate, loan.end-date).
		 balance = newBalance.
		 rate = newRate.         
       END.
   END. 
   
   out_Result = totalSumma.
   
   is-ok = 0.
END PROCEDURE. /* PirTurn */


{pfuncdef
   &NAME          = "���������"
   &DESCRIPTION   = "���� �����ᨨ �� ������� �����ਭ��. �� ������� ��ࠬ��ࠬ:~ 
	⨯� � ������ ������� �����ਭ��, ⨯� �����ᨨ �뢮��� ���祭�� �������� �����ᨨ �� �������� ���� � � �ॡ㥬�� �����"
   &PARAMETERS    = "���������� ��������, ����� ��������, ��� ��������, ���� �������, ��� ��������� ������� "
   &RESULT        = "������� ��������"
   &SAMPLE        = "���������('card-acq','1885/1/06/��','�������','01/10/2009','VS')"
   }
	DEFINE INPUT 	PARAMETER icontract   	AS CHAR  	NO-UNDO.
	DEFINE INPUT 	PARAMETER icont-code	AS CHAR  	NO-UNDO.
	DEFINE INPUT 	PARAMETER itype-com    	AS CHAR		NO-UNDO.
	DEFINE INPUT 	PARAMETER idate   		AS DATE  	NO-UNDO.
	DEFINE INPUT 	PARAMETER itype-pl    	AS CHAR		NO-UNDO.

	DEFINE OUTPUT PARAMETER out_Result    	AS DECIMAL		NO-UNDO.
	DEFINE OUTPUT PARAMETER is-ok          	AS INTEGER		NO-UNDO.

  DEFINE VAR i_date   AS DATE        NO-UNDO. 
  DEFINE VAR tCodeComm AS CHAR 	     NO-UNDO.
  


     i_date = idate.
	out_Result = 0.
	is-ok      = 0.


  /* ���� ������� */
  FIND FIRST loan WHERE loan.contract  EQ icontract
                      AND loan.cont-code EQ icont-code
                    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE loan THEN RETURN ERROR. 

   


  /*��।������ ��᫥����� �᫮��� �� �������*/
  FIND LAST loan-cond WHERE loan-cond.contract  EQ loan.contract
                        AND loan-cond.cont-code EQ loan.cont-code
                        AND loan-cond.since     LE i_date
                        NO-LOCK NO-ERROR.  
  IF NOT AVAIL loan-cond THEN MESSAGE "�� ������� �᫮��� �� �������!" VIEW-AS ALERT-BOX.
  
  /*��।������ ���� �����ᨨ*/
  tCodeComm = GetXAttrInit(loan-cond.class-code,itype-com).
  tCodeComm = tCodeComm + '@' + itype-pl.

  /*���� ���祭�� ��������� �� ���� ��業⭮� �⠢�� ��� ������ �����ᨨ*/
 FIND FIRST comm-rate WHERE comm-rate.commission    BEGINS tCodeComm
/*                       AND comm-rate.currency EQ loan.trade-sys*/
                         AND comm-rate.since    LE i_date   
                         NO-LOCK NO-ERROR.

  IF AVAIL comm-rate THEN  out_Result = comm-rate.rate-comm .
  ELSE MESSAGE "�� ������� ������� " + tCodeComm   VIEW-AS ALERT-BOX.

   
END PROCEDURE. /*���������*/



/** ==================================================================================================*/


{pfuncdef
   &NAME          = "������_�������"
   &DESCRIPTION   = "������ ����୮� �㭪樨 ���⊬� �� �⠭���⭮� �࠭���樨 tcg-open. �� ������� ��ࠬ��ࠬ:~ 
	⨯� � ������ �������, ⨯� �����ᨨ �뢮��� ���祭�� �������� �����ᨨ �� �������� ���� � � �ॡ㥬�� �����"
   &PARAMETERS    = "���������� ��������, ����� ��������, ����� �����, ��� ��������, ���� �������, ��� ��������� ������  "
   &RESULT        = "����� ��������"
   &SAMPLE        = "������_�������('card-pers','�/USD/04-034','4237400040008772','������','01/10/2009','840')~
    ������_�������(@mLoan_contract,@mLoan_cont-code,@mCard_cont-code,'������',����(),@mLoan_currency)"
   
   }
	DEFINE INPUT 	PARAMETER icontract   	AS CHAR  	NO-UNDO.
	DEFINE INPUT 	PARAMETER icont-code		AS CHAR  	NO-UNDO.
	DEFINE INPUT 	PARAMETER icard-cont-code	AS CHAR 	NO-UNDO.
	DEFINE INPUT 	PARAMETER itype-comm 		AS CHAR   	NO-UNDO.
	DEFINE INPUT 	PARAMETER idate   		AS DATE  	NO-UNDO.
	DEFINE INPUT 	PARAMETER icurrency    	AS CHAR	NO-UNDO.

	DEFINE OUTPUT PARAMETER out_Result    	AS DECIMAL		NO-UNDO.
	DEFINE OUTPUT PARAMETER is-ok          	AS INTEGER		NO-UNDO.

  	DEFINE VAR tValComm    AS DECIMAL     NO-UNDO. /*���祭�� �����ᨨ/���*/
  	DEFINE VAR ttValComm    AS DECIMAL     NO-UNDO. /*���祭�� �����ᨨ/���*/
  	DEFINE VAR tCodeComm           AS CHARACTER   NO-UNDO. /*��� �����ᨨ*/
  	
  	DEFINE BUFFER bfrCard FOR loan.



	out_Result = 0.
	is-ok      = 0.


  /* ���� ������� */
  FIND FIRST loan WHERE loan.contract  EQ icontract
                      	AND loan.cont-code EQ icont-code
                    	NO-LOCK NO-ERROR.
  
  IF NOT AVAILABLE loan THEN 
  	DO:
		RUN Fill-SysMes("","", "-1", "������_�������: ������� " + icontract + "." + icont-code + " �� ������!").
  		RETURN ERROR.
  	END. 

  /*��।������ ��᫥����� �᫮��� �� �������*/
  FIND LAST loan-cond WHERE loan-cond.contract  EQ loan.contract
                        AND loan-cond.cont-code EQ loan.cont-code
                        AND loan-cond.since     LE idate
  	                    NO-LOCK NO-ERROR.  
  
  IF NOT AVAIL loan-cond THEN 
  	DO:
		RUN Fill-SysMes("","", "-1", "������_�������: �᫮��� ������� " + icontract + "." + icont-code + " �� �������!").
  		RETURN ERROR.
  	END. 

  
  /*��।������ ���� �����ᨨ*/
  tCodeComm = GetXAttrInit(loan-cond.class-code,itype-comm).

  
  /** ���� ����� */
  FIND FIRST bfrCard WHERE bfrCard.parent-contract = loan.contract
  						AND bfrCard.parent-cont-code = loan.cont-code
  						AND bfrCard.cont-code = icard-cont-code
  						NO-LOCK NO-ERROR.
  						
  IF NOT AVAIL bfrCard THEN 
  	DO:
		RUN Fill-SysMes("","", "-1", "������_�������: ���� " + icard-cont-code + " ������� " + icontract + "." + icont-code + " �� �������!").
  		RETURN ERROR.
  	END. 

  
/*  MESSAGE bfrCard.sec-code + " | " + tCodeComm + " | " + bfrCard.doc-num VIEW-AS ALERT-BOX. */
   tCodeComm = tCodeComm + '@' + bfrCard.sec-code.
  
  /*���� ���祭�� ��������� �� ���� ��業⭮� �⠢�� ��� ������ �����ᨨ*/
  FIND LAST comm-rate WHERE	comm-rate.commission    EQ tCodeComm
/*    					AND comm-rate.currency EQ bfrCard.sec-code */
			     		AND comm-rate.since    LE idate
    					NO-LOCK NO-ERROR.

  IF AVAIL comm-rate THEN  
  	out_Result = comm-rate.rate-comm. 
  ELSE
  	DO:
		RUN Fill-SysMes("","", "-1", "������_�������: ������� " + itype-comm + " ��� ����� " + bfrCard.doc-num + " ������� " + icontract + "." + icont-code + " �� �������!").
  		RETURN ERROR.
  	END. 


END PROCEDURE. /*������_�������*/
/** ==================================================================================================*/

{pfuncdef
   &NAME          = "�����������"
   &DESCRIPTION   = "�� �������� ����� � �������� ���� � ���� ������ ���������� ����� ��������"
   &PARAMETERS    = "����� �������, ������ "
   &RESULT        = "����� ��������"
   &SAMPLE        = "�����������('80952.75','978')"
   }
	DEFINE INPUT 	PARAMETER isummdec   	AS DEC  	NO-UNDO.
	DEFINE INPUT 	PARAMETER ivalsumm		AS CHAR  	NO-UNDO.
	

	DEFINE OUTPUT PARAMETER out_Result    	AS CHAR		NO-UNDO.
	DEFINE OUTPUT PARAMETER is-ok          	AS INTEGER		NO-UNDO.

  DEFINE VAR i_date		AS DATE        		NO-UNDO. 
  DEFINE VAR amtstr 	AS CHAR EXTENT 2 	NO-UNDO.
  
	Run x-amtstr.p(isummdec,ivalsumm,true,true,output amtstr[1], output amtstr[2]).
  	
  	AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2].
	Substr(AmtStr[1],1,1) = Caps(Substr(AmtStr[1],1,1)).

   out_Result = AmtStr[1].
     
   
END PROCEDURE. /*�����������*/
/** ==================================================================================================*/

{pfuncdef
   &NAME          = "����_������"
   &DESCRIPTION   = "�����頥� ᮪�.������������ ��ꥪ�. ~
�㭪�� ����� 2 ����易⥫��� ��ࠬ���. ~
�᫨ ��� ��ࠬ��� ��।��� - ��।������ ������������ ������ �� ��ࠬ��஢. ~
�᫨ ��ࠬ���� �� ��।��� - � ���� �࠭���樨 ����� ⥪�騩 ��ࠡ��뢠��� ~
��ꥪ� (������ᨬ� �� �����) � ��।������ ������������ ������ �⮣� ��ꥪ� ~
(�᫨ ��� ������� ��ꥪ� ������ ����)"
   &PARAMETERS    = "[��� ��������, ������������� ��������]"
   &RESULT        = "������������ ��ꥪ� (������)"
   &SAMPLE        = "����_������ ('�', 123) ~~n~
����_������()"
   }
   DEFINE INPUT  PARAMETER iCustCat    AS CHARACTER   NO-UNDO. /* ��� ������. */
   DEFINE INPUT  PARAMETER iCustId     AS CHARACTER   NO-UNDO. /* �����䨪��� ������. */
   DEFINE OUTPUT PARAMETER out_Result  AS CHARACTER   NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok       AS INTEGER     NO-UNDO.

   DEF VAR vName     AS CHAR   NO-UNDO.
   DEF VAR vCustInn  AS CHAR   NO-UNDO.
   DEF VAR vCustCat  AS CHAR   NO-UNDO.   /* ��⥣��� ������ */
   DEF VAR vCustId   AS CHAR   NO-UNDO.   /* ������. ������ */
   DEF VAR vInstance AS HANDLE NO-UNDO.   /* handle �� ⥪�騩 ��ࠡ��뢠��� ��ꥪ� �࠭���樨 */
   DEF VAR vBuffer   AS HANDLE NO-UNDO.   /* ����� ⥪�饣� ��ࠡ��뢠����� ��ꥪ� �࠭���樨 */
   
   ASSIGN
      vCustCat =  iCustCat
      vCustId  =  iCustId.

   PROC:
   DO ON ERROR UNDO PROC, LEAVE PROC:
      /* ��ࠬ���� �㭪樨 �� ������ */
      IF    vCustCat EQ ?
         OR vCustId  EQ ?
      THEN DO:
         /* ������� ⥪�騩 ��ࠡ��뢠��� ��ꥪ� �࠭���樨 */
         vInstance = GetBaseInstance(GetBaseOpkind(), GetBaseTemplate()).
         /* �᫨ handle �� ��ꥪ� ����祭 */
         IF vInstance NE ? THEN DO:
            /* ���� � ᯮ��樮��஢��� ���� */
            vBuffer = vInstance:DEFAULT-BUFFER-HANDLE NO-ERROR.
            /* ������� �� ���� ���� cust-cat � cust-id  */
            ASSIGN
               vCustCat = vBuffer:BUFFER-FIELD("cust-cat"):BUFFER-VALUE
               vCustId  = vBuffer:BUFFER-FIELD("cust-id" ):BUFFER-VALUE
            NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
               RUN Fill-SysMes IN h_tmess ("", "", "-1", "��������� '��� ������' � 'N ������' �� ������� ��� ⥪�饣� ��ꥪ�").
               is-ok = -1.
               LEAVE PROC.
            END.
         END.
         ELSE DO:
            RUN Fill-SysMes IN h_tmess ("", "", "-1", "��� ��ꥪ� ��ࠡ��뢠����� �࠭���樥�").
            is-ok = -1.
            LEAVE PROC.
         END.
      END.

      CASE vCustCat:
         WHEN "�" THEN DO:
            FIND cust-corp
               WHERE cust-corp.cust-id EQ INT(vCustId)
               NO-LOCK NO-ERROR.
            IF AVAIL cust-corp
            THEN vName = cust-corp.name-short.
         END.
         WHEN "�" THEN DO:
            FIND FIRST person
               WHERE person.person-id EQ INT(vCustId)
               NO-LOCK NO-ERROR.
            IF AVAIL person
            THEN vName = person.name-last + " " + person.first-names.
         END.
         WHEN "�" THEN DO:
            FIND banks
               WHERE banks.bank-id EQ INT(vCustId)
               NO-LOCK NO-ERROR.
            IF AVAIL banks
            THEN vName = banks.short-name.
         END.
      END CASE.

      out_Result = TRIM(vName).
   END.  /* of PROC block */
   RETURN.
END PROCEDURE.

/* ========================================================================= */
{pfuncdef
   &NAME          = "������_����"
   &DESCRIPTION   = "�����頥� ������������ ��� �� ��� ������, ���� ������ � ���� 䨫����."
   &PARAMETERS    = "����� ����� [,������] [,������]"
   &RESULT        = "����������� ������������ �������"
   &SAMPLE        = "������_����('30122978100090000055','978')='��� ��᮫��'~~n~
������_����('10201810300020010029')='��� ���⠧��'"
}
   DEFINE INPUT  PARAMETER iAcct       AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER iCurr       AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER iFilial     AS CHARACTER  NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result  AS CHARACTER  NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok       AS INTEGER    NO-UNDO.

   DEFINE VARIABLE vName         AS CHARACTER NO-UNDO.

   IF iFilial EQ ? THEN
      iFilial = ShFilial.
   IF iCurr EQ ? THEN
      {find-act.i
          &bacct  = acct
          &acct   = iAcct
          &filial = iFilial
      }
   ELSE
      {find-act.i 
          &bacct  = acct
          &acct   = iAcct
          &filial = iFilial
          &curr   = iCurr
      }
   IF AVAILABLE (acct)
   THEN DO:

      vName = "".
      case acct.cust-cat:
         when "�" then do:
            find first banks
               where (banks.bank-id eq acct.cust-id)
               no-lock no-error.
            if avail banks then
               vName = banks.short-name.
         end.
         when "�" then do:
            find first cust-corp
               where (cust-corp.cust-id eq acct.cust-id)
               no-lock no-error.
            if avail cust-corp
               then vName = cust-corp.name-short.
         end.
         when "�" then do:
            find first person
               where (person.person-id eq acct.cust-id)
               no-lock no-error.
            if avail person
            then vName = person.name-last + " " + person.first-names.
         end.
         otherwise do:
            vName = acct.details.
         end.
      end case.

      if (vName eq ?)
         then vName = "".

      out_Result = TRIM(vName).
      is-OK = 0.
   END.
   ELSE DO:
      out_Result = "������".
      is-OK = 0.
   END.

END PROCEDURE.

/* ========================================================================= */
FUNCTION RegGNI RETURNS CHARACTER
   (INPUT cR AS CHARACTER):

   IF    (cR EQ ?)
      OR (cR EQ "")
      OR (cR EQ "77")
      OR (cR EQ "78")
      OR (cR EQ "0")
      OR (cR EQ "00000")
      OR (cR EQ "00040")
      OR (cR EQ "00045")
   THEN
      RETURN "".
   ELSE
      CASE LENGTH(cR):
         WHEN 2 THEN
            RETURN REPLACE(REPLACE(GetCodeName ("���������", cR), "�������", "���."), "��⮭���� ����", "��") + ",".
         WHEN 5 THEN
            RETURN REPLACE(REPLACE(GetCodeName ("������",    cR), "�������", "���."), "��⮭���� ����", "��") + ",".
         OTHERWISE
            RETURN "".
      END CASE.
END.
/* ========================================================================= */
/* �८�ࠧ������ ���� � �ଠ� ����� � 㤮���⠥���� ����                   */
/* �ଠ� �����: ������,ࠩ��,��த,���.�㭪�,㫨�,���,�����,������,��஥��� */
/* ��祬 ���.2-5 ᮯ஢�������� ���������ﬨ �,�-�,� � �.�., � ���.6-9 ����������� ������ ��ࠬ� */
FUNCTION Kladr RETURNS CHARACTER
   (INPUT cReg AS CHARACTER, /* Country,GNI */
    INPUT cAdr AS CHARACTER):

   DEFINE VARIABLE cAdrPart AS CHARACTER EXTENT 9 INITIAL "".
   DEFINE VARIABLE cAdrKl   AS CHARACTER.
   DEFINE VARIABLE iI       AS INTEGER.
   DEFINE VARIABLE iNzpt    AS INTEGER.

   iNzpt = MINIMUM(NUM-ENTRIES(cAdr), 9).

   DO iI = 1 TO iNzpt:
      cAdrPart[iI] = ENTRY(iI, cAdr).
   END.

   IF (ENTRY(1, cReg) NE "RUS")
   THEN DO:
      FIND FIRST country
         WHERE (country.country-id EQ ENTRY(1, cReg))
         NO-LOCK NO-ERROR.
      cAdrKl = IF (AVAIL country) THEN TRIM(country.country-name) ELSE "".

      IF     (cAdrPart[1] NE "")
         AND (cAdrPart[1] NE "000000")
      THEN
         cAdrKl = TRIM(cAdrKl + "," + cAdrPart[1], ",").

      DO iI = 2 TO MINIMUM(iNzpt, 9) :
         IF (cAdrPart[iI] NE "") THEN cAdrKl = cAdrKl + "," + cAdrPart[iI].
      END.
   END.
   ELSE DO:
      cAdrKl = TRIM((IF ((cAdrPart[1] NE "") AND (cAdrPart[1] NE "000000"))
                     THEN (cAdrPart[1] + ",")
                     ELSE "")
                   + RegGNI(ENTRY(2, cReg)), ",").
      DO iI = 2 TO MINIMUM(iNzpt, 5) :
         IF (cAdrPart[iI] NE "") THEN cAdrKl = cAdrKl + "," + cAdrPart[iI].
      END.

      IF     (cAdrPart[6] NE "")
         AND (iNzpt GE 6)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[6], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",�.")
                + cAdrPart[6].
      END.

      IF     (cAdrPart[9] NE "")
         AND (iNzpt EQ 9)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[9], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",���.")
                + cAdrPart[9].
      END.

      IF     (cAdrPart[7] NE "")
         AND (iNzpt GE 7)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[7], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",���.")
                + cAdrPart[7].
      END.

      IF     (cAdrPart[8] NE "")
         AND (iNzpt GE 8)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[8], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",��.")
                + cAdrPart[8].
      END.
   END.

   RETURN TRIM(cAdrKl, ",").
END.

/** ==================================================================================================*/

{pfuncdef
   &NAME          = "�����_�����"
   &DESCRIPTION   = "�����頥� '��ᨢ�' ����. ~
�㭪�� ����� 3 ��易⥫��� ��ࠬ���."
   &PARAMETERS    = "[������, ������, ����� (address[1]+address[2])]"
   &RESULT        = "'��ᨢ�' ����"
   &SAMPLE        = "�����_����� ('RUS', '77', '121002,��᪢� �,,�ਢ��ࡠ�᪨� ���,15,,9,1') ~~n~
�����_�����()"
   }
   DEFINE INPUT  PARAMETER iCountry    AS CHARACTER   NO-UNDO. /* ��� ������. */
   DEFINE INPUT  PARAMETER iReg        AS CHARACTER   NO-UNDO. /* �����䨪��� ������. */
   DEFINE INPUT  PARAMETER iAddress    AS CHARACTER   NO-UNDO. /* �����䨪��� ������. */
   DEFINE OUTPUT PARAMETER out_Result  AS CHARACTER   NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok       AS INTEGER     NO-UNDO.

   DEFINE VARIABLE vCountry AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE vReg     AS CHARACTER    NO-UNDO.

   vCountry = IF (iCountry EQ ?) THEN "" ELSE iCountry.
   vReg     = IF (iReg     EQ ?) THEN "" ELSE iReg.

   IF     (vCountry EQ "")
      AND (vReg     NE "")
   THEN vCountry = "RUS".

   out_Result = Kladr(vCountry + "," + vReg, iAddress).
   RETURN.
END PROCEDURE.


/** ==================================================================================================*/

{pfuncdef
   &NAME          = "�����_���"
   &DESCRIPTION   = "�����頥� ��� ������ ������. ~
�㭪�� ����� 1 ��易⥫�� ��ࠬ���."
   &PARAMETERS    = "[��� ������]"
   &RESULT        = "���� ���"
   &SAMPLE        = "�����_��� ('person') = 000098765 ~~n~
�����_���()"
   }
   DEFINE INPUT  PARAMETER iFileName   AS CHARACTER NO-UNDO. /* ��� ������. */
   DEFINE OUTPUT PARAMETER out_Result  AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok       AS INTEGER   NO-UNDO.

   out_Result = STRING(NewUnk(iFileName), GetXAttrEx(iFileName, "���", "data-format")).
   RETURN.
END PROCEDURE.

/** ==================================================================================================*/

{pfuncdef
   &NAME          = "USER_SIGN"
   &DESCRIPTION   = "�����頥� ������� � ���樠�� ���짮��⥫�. ~
�㭪�� ����� 1 ��易⥫�� ��ࠬ���."
   &PARAMETERS    = "[User-ID]"
   &RESULT        = "������� � ���樠��"
   &SAMPLE        = "USER_SIGN ('03000KOV') = ����ᮢ� �.�."
   }
   DEFINE INPUT  PARAMETER iFileName   AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result  AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok       AS INTEGER   NO-UNDO.

   DEFINE VARIABLE cTmp                AS CHARACTER NO-UNDO.

   FIND FIRST _user
      WHERE (_user._userid EQ iFileName)
      NO-LOCK NO-ERROR.

   IF NOT AVAIL _user
   THEN DO:
      is-OK = 0.
      out_Result = "".
   END.
   ELSE DO:
      cTmp = _user._User-Name.
      out_Result = ENTRY(1, cTmp, " ") + " "
                 + SUBSTRING(ENTRY(2, cTmp, " "), 1, 1) + "."
                 + IF (NUM-ENTRIES(cTmp, " ") LE 2) THEN "" ELSE (SUBSTRING(ENTRY(3, cTmp, " "), 1, 1) + ".").
   END.

   RETURN.
END PROCEDURE.

/** ==================================================================================================*/

{pfuncdef
   &NAME          = "PirBlocQuery"
   &DESCRIPTION   = "sdfg"
   &PARAMETERS    = "[acct,currency]"
   &RESULT        = "ssdfg"
   &SAMPLE        = "asdfa"
   }

   DEFINE INPUT  PARAMETER acct   AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER currency   AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result  AS CHARACTER NO-UNDO.
      DEFINE OUTPUT PARAMETER is-ok       AS INTEGER   NO-UNDO.

def var temp as char INIT ""  No-Undo.
def var i as int  No-Undo.
for each blockobject where file-name = 'acct' and surrogate = acct + "," + currency and end-datetime = ?.
if temp <> "" then temp = temp + ",".
temp = temp + blockobject.block-type + ",".
  DO i = 1 to 9:
  temp = temp  + string(val[i]) + CHR(127).
end.
  temp = temp + string(val[10]).

end. 
      is-ok = 0.
      out_Result = temp.
   return.
END PROCEDURE.   

/** ==================================================================================================*/

{pfuncdef
   &NAME          = "PirDoverDate"
   &DESCRIPTION   = "�����頥� ���� ��砫� ����⢨� ����७���� �� ���� 䨧.���"
   &PARAMETERS    = "[cAcct,cClient,dOpDate,iType]"
   &RESULT        = "1"
   &SAMPLE        = "1"
   }
/* ����䨪���: #3679 Sitov S.A. */

   DEFINE INPUT  PARAMETER cAcct	AS CHAR  NO-UNDO.
   DEFINE INPUT  PARAMETER cClient	AS CHAR  NO-UNDO.
   DEFINE INPUT  PARAMETER cOpDate	AS DATE  NO-UNDO.
   DEFINE INPUT  PARAMETER iType	AS CHAR  NO-UNDO.

   DEFINE OUTPUT PARAMETER out_Result	AS CHAR  NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok	AS INT   NO-UNDO.

   DEF VAR cDover         AS Char INIT ""  NO-UNDO.
   DEF VAR cAcctOwner     AS Char INIT ""  NO-UNDO.
   DEF VAR cTemp          AS Char INIT ""  NO-UNDO.


   FIND FIRST acct WHERE acct.acct = cAcct NO-LOCK NO-ERROR.
   FIND FIRST person WHERE person.person-id =  acct.cust-id NO-LOCK NO-ERROR.
   IF AVAILABLE (person) THEN
 	cAcctOwner = person.name-last + " " + person.first-names.
 
 
 	/* ��।��塞, �㦭� �� �஢����� ����७����� */
   IF acct.cust-cat = "�"  AND  TRIM(cClient) <> TRIM(cAcctOwner) 
 	AND  (cClient <> ? AND cClient <> "" AND cClient <> "0" ) 
   THEN 
   DO:
 	RUN pir-proxy-check.p( cAcct , cClient , cOpDate , OUTPUT cDover ) .  /* �஢����� �㦭� !*/
 	IF cDover = "" THEN 
 	DO:
 	  MESSAGE COLOR WHITE/RED "��� ������������ ��� ������� �������" VIEW-AS ALERT-BOX .
 	END.
   END.
 
 
   IF iType = "in" THEN 
 	cTemp = "����� �������� �।�� �� " + ( IF acct.currency = "" THEN "�㡫���" ELSE "������" ) + " ��� ������ " .
 
   IF iType = "out" THEN 
   DO:
	IF acct.acct MATCHES '47422........050....' THEN
	  cTemp = "������ �������� �।�� ��᫥ ������� ����筮�� ���." .
	ELSE
	  cTemp = "�뤠� �������� �।�� � " + ( IF acct.currency = "" THEN "�㡫�����" ELSE "����⭮��" ) + " ��� ������ " .

 	IF (cDover <> "" OR cDover <> " ")  THEN 
           cTemp = cTemp + cAcctOwner .
   END.
 
   IF iType <> "dov" THEN 
 	cDover = cTemp + " " + cDover.
 
   IF cDover = "" THEN cDover = " ".
   out_Result = cDover.
   is-ok = 0.
   RETURN.

END PROCEDURE.   


PROCEDURE PIR_LOAN_PERCENT_AMT_DATE. /* �� ���� �९���୮�, �ᯮ����� �९����묨 ��楤�ࠬ� PIR_LOAN_PERCENT_NEW, PIR_LOAN_PERCENT_DATE */
   DEFINE INPUT  PARAMETER iContract        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iContCode        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iBegDate         AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate			AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iNeedMon			AS LOGICAL	NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result    	AS DECIMAL		NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Date    		AS DATE			NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok          	AS INTEGER		NO-UNDO.

   DEF VAR begDate AS DATE NO-UNDO.
   DEF VAR endDate AS DATE NO-UNDO.
   DEF VAR balance AS DECIMAL NO-UNDO.
   DEF VAR newBalance AS DECIMAL NO-UNDO.
   DEF VAR rate AS DECIMAL NO-UNDO.
   DEF VAR newRate AS DECIMAL NO-UNDO.
   DEF VAR summa AS DECIMAL NO-UNDO.
   DEF VAR totalSumma AS DECIMAL NO-UNDO.
   DEF VAR period AS INTEGER NO-UNDO.
   DEF VAR iDate AS DATE NO-UNDO.
   DEF VAR periodBegin AS DATE NO-UNDO.
   DEF VAR periodEnd AS DATE NO-UNDO.
   DEF VAR periodBase AS INTEGER NO-UNDO.
   DEF VAR PredSumma AS DEC.
   
   DEF VAR mainLoan AS CHARACTER NO-UNDO.
   
   begDate = iBegDate.
   endDate = iEndDate.

   /** ���� ���� ��業⮢ 365/366 */
   
   FIND FIRST loan WHERE loan.contract = iContract
                     and loan.cont-code = iContCode
                     NO-LOCK NO-ERROR.
                     
   IF NOT AVAIL loan THEN DO:
      RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� '" + iContract + "." + iContCode + "' �� ������!").
      RETURN.
   END.

   /*��������� � ��ன �㭪樨: */


/* �஢��塞 �뫮 �� ����襭�� ��業⮢ � ⥪�饬 ��� (���� �஡����:
��� ���᪠ ����襭�� ��業⮢ �饬 ��⮬���᪨� ����樨 ����� ᮧ������ �� ������ �� ᫥���騩 ���� */

def var cKredProc as char  No-Undo.
def var v-ok as logical  No-Undo.
find last loan-acct where loan-acct.contract = loan.contract and loan-acct.cont-code = SUBSTRING(loan.cont-code,1,9) 
and loan-acct.acct-type = "�।���" NO-LOCK NO-ERROR.


if available(loan-acct) then
do:

   cKredProc = loan-acct.acct.
   find last loan-acct where loan-acct.contract = loan.contract and loan-acct.cont-code = SUBSTRING(loan.cont-code,1,9) 
   and loan-acct.acct-type = "�।����" NO-LOCK NO-ERROR.
   if available(loan-acct) then do:
   find last op-entry where op-entry.acct-db = loan-acct.acct and op-entry.acct-cr = cKredProc and op-entry.op-date = enddate NO-LOCK NO-ERROR.

  if available(op-entry) then do:
/*                  MESSAGE
               "� ⥪�饬 ����樮���� ���"
               "�뫮 ����襭�� �� �������� " loan-acct.cont-code SKIP
               "��業�� ����襭�? ?"
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v-ok.
     if v-ok then do:   */

      ibegdate = enddate + 1.
      begdate = enddate + 1.
/*     end.       */
   end.
   end.
end.




/* �஢��塞 �뫮 �� ����襭�� ��業⮢ �� ����� ��ਮ� */
   mainLoan = GetMainLoan_ULL(loan.contract, loan.cont-code, false).

/*message mainloan view-as alert-box.*/

  find last loan-int
	where loan-int.cont-code = ENTRY(2, mainLoan)
				   /* ENTRY(2, mainLoan) */
	  and loan-int.contract = loan.contract
	  and loan-int.mdate >= begDate 
	  and loan-int.mdate <= endDate 

	  and (loan-int.id-d = 6) /* ���=6 � ��=4 ��� �������� 9 */
	  and (loan-int.id-k = 4)

	NO-LOCK NO-ERROR.
/* ���ࠢ�� �����, �⮡� ���४⭮ ��ࠡ��뢠� ��� Index
pu    prim                          16        4 + cont-code
                                                + contract
                                                + mdate
                                                + nn
*/

   if AVAILABLE(loan-int) then do:
     begDate = loan-int.mdate + 1. /* ���뢠�� �� ������塞 1 ���� ��� ���� */
     out_Date = begdate.
     RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + " �뫮 ����襭�� � ᤢ����� ��砫��� ���� �� " + STRING(begDate)).
   end.

/* �஢��塞 �뫠 �� ᬥ�� ��⥣�ਨ ����⢠ */
   def var startCQ AS DEC NO-UNDO.
   def var endCQ AS DEC NO-UNDO.
   DEF BUFFER bcomm-rate for comm-rate.
   DEF BUFFER bloan-acct for loan-acct.
   DEF BUFFER bterm-obl for term-obl.

   def var bPOS as LOGICAL.
   find last bterm-obl WHERE bterm-obl.cont-code EQ ENTRY(2, mainLoan) AND bterm-obl.contract EQ '�।��' AND bterm-obl.idnt EQ 128 NO-LOCK NO-ERROR.
   if AVAILABLE (bterm-obl) then do:
/*      if sop-date <> ? then do:*/
      if bterm-obl.end-date >=iBegdate and bterm-obl.end-date <= iEndDate then do:
         iBegDate = bterm-obl.end-date + 1.
         begdate = bterm-obl.end-date + 1.
         bPos = true.
      end.
      if bterm-obl.sop-date >=iBegDate and bterm-obl.sop-date <= iEndDate then do:
	iBegDate = bterm-obl.sop-date + 1. 
	begdate = bterm-obl.sop-date + 1.
        bPos = true.
      end.
      RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + " ,�뫨 ����⢨� � ����䥫�� � " + STRING(iBegDate, "99/99/99")).
/*      end.                         */
   end. /*AVAILABLE (term-obl)*/




   find first bcomm-rate
	where bcomm-rate.commission begins "%���"
	  and bcomm-rate.kau = "�।��," + ENTRY(2, mainLoan)
	  and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate ᤢ�������, �᫨ �뫮 ����襭��  */
	  and bcomm-rate.since <= endDate
	NO-LOCK NO-ERROR.
   

   if AVAILABLE(bcomm-rate) then do:
      startCQ = bcomm-rate.rate-comm.
/* message " loan.cont-code" loan.cont-code begDate endDate bcomm-rate.since startCQ view-as alert-box. / * !!! */
      find last bcomm-rate
	where bcomm-rate.commission begins "%���"
	  and bcomm-rate.kau = "�।��," + ENTRY(2, mainLoan)
	  and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate ᤢ�������, �᫨ �뫮 ����襭��  */
	  and bcomm-rate.since <= endDate
	NO-LOCK NO-ERROR.
      endCQ = bcomm-rate.rate-comm.
      if ((startCQ <> endCQ) and ((startCQ > 50 and endCQ <= 50) OR (startCQ <= 50 and endCQ > 50))) OR bPOS then do:

        find /* last */ first bcomm-rate
	  where bcomm-rate.rate-comm = /* startCQ */ endCQ
            and bcomm-rate.commission begins "%���"
   	    and bcomm-rate.kau = "�।��," + ENTRY(2, mainLoan)
	    and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate ᤢ�������, �᫨ �뫮 ����襭�� */
 	    and bcomm-rate.since <= endDate
	  NO-LOCK NO-ERROR.

        RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + " ���� ����� �� " + STRING(startCQ) + "->" + STRING(endCQ)
+ " c " + STRING(bcomm-rate.since, "99/99/99")).
        begdate = bcomm-rate.since + 1.
        ibegdate = begdate.
	out_Date = begdate.
        DEF VAR role AS CHAR NO-UNDO.
        role = if startCQ > 50
	  then "�।�"
	  else "�।��".
        find first bloan-acct
	  where bloan-acct.cont-code = ENTRY(2, mainLoan)
	    and bloan-acct.contract  = loan.contract
	    and bloan-acct.acct-type = role
	    NO-LOCK NO-ERROR.
        if available (bloan-acct) then do:
   	  DEF VAR oAcct AS TAcct NO-UNDO.
          oAcct = new tAcct(bloan-acct.acct).
          PredSumma = oAcct:getlastpos2date(enddate).
          delete object oAcct.
        end.
      end. /* if startCQ <> endCQ then do: */
   end. /* if AVAILABLE(bcomm-rate) then do: */

   periodBegin = MAX(begDate, loan.open-date). /* SSV �뫮 + 1  */
   out_Date    = periodBegin.

   /** � ����� ����� ��� ����砭�� �࠭� �������� �� ��室��� ����,
       ��� ����砭�� ��ਮ�� ���� ��業⮢ ������ ���� ᫥���騬 ࠡ�稬 ����.
       �����, ����� ��ࠦ���� 
   periodEnd = MIN(endDate, loan.end-date).
       �믮���� ���⮥ ��c������
   */
   periodEnd = endDate. 
   
   /** ���祭�� "��" ��ਮ�� */
   balance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, periodBegin - 1, false).
   rate = GetLoanCommission_ULL(ENTRY(1, mainLoan), ENTRY(2, mainLoan), "%�।", periodBegin, false).
   /** �������� �� ��� */
   DO iDate = periodBegin TO periodEnd :
	
	 IF loan.since < iDate THEN DO:
	 	RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + 
	 	                " �� �����⠭ �� ���� " + STRING(periodEnd)).
	 	RETURN. 
	 END.

     newBalance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, iDate, false).
     newRate = GetLoanCommission_ULL(ENTRY(1, mainLoan), ENTRY(2, mainLoan), "%�।", iDate + 1, false).
     
     /**    ����:
     	1) ��������� ���⮪
     	2) ���������� ��業⭠� �⠢��
     	3) ��᫥���� ���� �����
 		4) ��᫥���� ���� ���⭮�� ��ਮ��,
 			��:
 		"ᮧ����" �����ਮ�, ����뢠�� ���祭��, ����㫨�㥬 ����� �㬬�,
 		���� ���祭�� �⠭������ ⥪�騬�!
 	*/
/* 	 
RUN Fill-SysMes("","", "-1", "6 " + " " + loan.cont-code + " " + STRING(iDate)
 + " balance <> newBalance " + STRING(balance) + " " + STRING(newBalance)
 + " rate <> newRate " + STRING(rate) + " " + STRING(newRate)
 + " (DAY(iDate + 1) = 1 AND iDate < periodEnd) " + STRING(DAY(iDate + 1)) + " " + STRING((iDate < periodEnd))
 + "iDate = periodEnd " + STRING(iDate) + " " + STRING(periodEnd)
).
*/
     IF    balance 	   <> newBalance
	OR rate            <> newRate 
	OR (DAY(iDate + 1) = 1 AND iDate < periodEnd) 
        OR iDate 	   = periodEnd THEN
       DO:
	     periodEnd = iDate.
	     periodBase = (IF TRUNCATE(YEAR(iDate) / 4,0) = YEAR(iDate) / 4 THEN 366 ELSE 365).
             period = periodEnd - periodBegin + 1.

	     summa = round(balance * rate / periodBase * period, 2).
		 totalSumma = totalSumma + summa.

		 /* � ��砥 �᫨ �㬬������ 㬥��訫��� ����� �� ��業�� ����襭�, ����塞 �� ��業�� ����� ���⠫� �� �⮣�!   */
		 IF newBalance < balance
			THEN
				ASSIGN
					totalSumma = 0
					out_Date   = periodEnd + 1
				.
		 
/*	     IF iNeedMon THEN  */
	     RUN Fill-SysMes("","", "1", /* "PirLoanPercent: " +
					 "loan = " + loan.contract + "." + loan.cont-code + */
	                                 ", bal = " + STRING(balance) + 
	                                 ", rate = " + STRING(rate) + 
	                                 ", perBase = " + STRING(periodBase) +
	                                 ", per = " + STRING(period) + "(" + STRING(periodBegin) + " - " + STRING(periodEnd) + ")" +
	                                 ", summa = balance * rate / periodBase * period = " + STRING(summa) +
	                                 ", total = " + STRING(totalSumma)).

                 periodBegin = periodEnd + 1.
		 periodEnd = MIN(endDate, loan.end-date).
		 balance = newBalance.
		 rate = newRate.         
       END.
   END. 
   
   out_Result = totalSumma.
   
   is-ok = 0.
END PROCEDURE. /* "PIR_LOAN_PERCENT_AMT_DATE" */


PROCEDURE PIR_LOAN_PERCENT_AMT_DATE_VIRT. /* �� ���� �९���୮�, �ᯮ����� �९����묨 ��楤�ࠬ� PIR_LOAN_PERCENT_NEW, PIR_LOAN_PERCENT_DATE */
   DEFINE INPUT  PARAMETER iContract        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iContCode        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iBegDate         AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate			AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iNeedMon			AS LOGICAL	NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result    	AS DECIMAL		NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Date    		AS DATE			NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok          	AS INTEGER		NO-UNDO.

   DEF VAR begDate AS DATE NO-UNDO.
   DEF VAR endDate AS DATE NO-UNDO.
   DEF VAR balance AS DECIMAL NO-UNDO.
   DEF VAR newBalance AS DECIMAL NO-UNDO.
   DEF VAR rate AS DECIMAL NO-UNDO.
   DEF VAR newRate AS DECIMAL NO-UNDO.
   DEF VAR summa AS DECIMAL NO-UNDO.
   DEF VAR totalSumma AS DECIMAL NO-UNDO.
   DEF VAR period AS INTEGER NO-UNDO.
   DEF VAR iDate AS DATE NO-UNDO.
   DEF VAR periodBegin AS DATE NO-UNDO.
   DEF VAR periodEnd AS DATE NO-UNDO.
   DEF VAR periodBase AS INTEGER NO-UNDO.
   DEF VAR PredSumma AS DEC.
   
   DEF VAR mainLoan AS CHARACTER NO-UNDO.
   
   begDate = iBegDate.
   endDate = iEndDate.

   /** ���� ���� ��業⮢ 365/366 */
   
   FIND FIRST loan WHERE loan.contract = iContract
                     and loan.cont-code = iContCode
                     NO-LOCK NO-ERROR.
                     
   IF NOT AVAIL loan THEN DO:
      RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� '" + iContract + "." + iContCode + "' �� ������!").
      RETURN.
   END.

   /*��������� � ��ன �㭪樨: */


/* �஢��塞 �뫮 �� ����襭�� ��業⮢ � ⥪�饬 ��� (���� �஡����:
��� ���᪠ ����襭�� ��業⮢ �饬 ��⮬���᪨� ����樨 ����� ᮧ������ �� ������ �� ᫥���騩 ���� */

   mainLoan = GetMainLoan_ULL(loan.contract, loan.cont-code, false).

  find last loan-int
	where loan-int.cont-code = ENTRY(2, mainLoan)
				   /* ENTRY(2, mainLoan) */
	  and loan-int.contract = loan.contract
	  and loan-int.mdate = endDate 

	  and (loan-int.id-d = 5) /* ���=6 � ��=4 ��� �������� 9 */
	  and (loan-int.id-k = 6)

	NO-LOCK NO-ERROR.


   if AVAILABLE(loan-int) then do:

     begDate = loan-int.mdate + 1. /* ���뢠�� �� ������塞 1 ���� ��� ���� */
     out_Date = begdate.
     RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + " �뫮 ����襭�� � ᤢ����� ��砫��� ���� �� " + STRING(begDate)).

   end.


  find last loan-int
	where loan-int.cont-code = ENTRY(2, mainLoan)
				   /* ENTRY(2, mainLoan) */
	  and loan-int.contract = loan.contract
	  and loan-int.mdate >= begDate 
	  and loan-int.mdate <= endDate 

	  and (loan-int.id-d = 6) /* ���=6 � ��=4 ��� �������� 9 */
	  and (loan-int.id-k = 4)

	NO-LOCK NO-ERROR.

/* �஢��塞 �뫮 �� ����襭�� ��業⮢ �� ����� ��ਮ� */


   if AVAILABLE(loan-int) then do:
     begDate = loan-int.mdate + 1. /* ���뢠�� �� ������塞 1 ���� ��� ���� */
     out_Date = begdate.
     RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + " �뫮 ����襭�� � ᤢ����� ��砫��� ���� �� " + STRING(begDate)).
   end.

/* �஢��塞 �뫠 �� ᬥ�� ��⥣�ਨ ����⢠ */
   def var startCQ AS DEC.
   def var endCQ AS DEC.
   DEF BUFFER bcomm-rate for comm-rate.
   DEF BUFFER bloan-acct for loan-acct.
   DEF BUFFER bterm-obl for term-obl.
   def var bPOS as LOGICAL.
   find last bterm-obl WHERE bterm-obl.cont-code EQ ENTRY(2, mainLoan) AND bterm-obl.contract EQ '�।��' AND bterm-obl.idnt EQ 128 NO-LOCK NO-ERROR.
   if AVAILABLE (bterm-obl) then do:
/*      message bterm-obl.cont-code bterm-obl.end-date bterm-obl.sop-date  view-as alert-box.*/
      if bterm-obl.end-date >=iBegdate and bterm-obl.end-date <= iEndDate then do:
         iBegDate = bterm-obl.end-date + 1.
         begdate = bterm-obl.end-date + 1.
         bPos = true.
      RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + " ,�뫨 ����⢨� � ����䥫�� � " + STRING(iBegDate, "99/99/99")).
      end.
      if bterm-obl.sop-date >=iBegDate and bterm-obl.sop-date <= iEndDate then do:
	iBegDate = bterm-obl.sop-date + 1. 
	begdate = bterm-obl.sop-date + 1.
        bPos = true.
      RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + " ,�뫨 ����⢨� � ����䥫�� � " + STRING(iBegDate, "99/99/99")).
      end.


   end. /*AVAILABLE (term-obl)*/

   find first bcomm-rate
	where bcomm-rate.commission begins "%���"
	  and bcomm-rate.kau = "�।��," + ENTRY(2, mainLoan)
	  and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate ᤢ�������, �᫨ �뫮 ����襭��  */
	  and bcomm-rate.since <= endDate
	NO-LOCK NO-ERROR.
   

   if AVAILABLE(bcomm-rate) then do:
      startCQ = bcomm-rate.rate-comm.
      find last bcomm-rate
	where bcomm-rate.commission begins "%���"
	  and bcomm-rate.kau = "�।��," + ENTRY(2, mainLoan)
	  and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate ᤢ�������, �᫨ �뫮 ����襭��  */
	  and bcomm-rate.since <= endDate
	NO-LOCK NO-ERROR.
      endCQ = bcomm-rate.rate-comm.
      if ((startCQ <> endCQ) and ((startCQ > 50 and endCQ <= 50) OR (startCQ <= 50 and endCQ > 50))) OR bPOS then do:

        find /* last */ first bcomm-rate
	  where bcomm-rate.rate-comm = /* startCQ */ endCQ
            and bcomm-rate.commission begins "%���"
   	    and bcomm-rate.kau = "�।��," + ENTRY(2, mainLoan)
	    and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate ᤢ�������, �᫨ �뫮 ����襭�� */
 	    and bcomm-rate.since <= endDate
	  NO-LOCK NO-ERROR.

        RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + " ���� ����� �� " + STRING(startCQ) + "->" + STRING(endCQ)
+ " c " + STRING(bcomm-rate.since, "99/99/99")).
        begdate = bcomm-rate.since + 1.
        ibegdate = begdate.
	out_Date = begdate.
        DEF VAR role AS CHAR NO-UNDO.
        role = if startCQ > 50
	  then "�।�"
	  else "�।��".
        find first bloan-acct
	  where bloan-acct.cont-code = ENTRY(2, mainLoan)
	    and bloan-acct.contract  = loan.contract
	    and bloan-acct.acct-type = role
	    NO-LOCK NO-ERROR.
        if available (bloan-acct) then do:
   	  DEF VAR oAcct AS TAcct NO-UNDO.
          oAcct = new tAcct(bloan-acct.acct).
          PredSumma = oAcct:getlastpos2date(enddate).
          delete object oAcct.
        end.
      end. /* if startCQ <> endCQ then do: */
   end. /* if AVAILABLE(bcomm-rate) then do: */

   periodBegin = MAX(begDate, loan.open-date). /* SSV �뫮 + 1  */
   out_Date    = periodBegin.

   /** � ����� ����� ��� ����砭�� �࠭� �������� �� ��室��� ����,
       ��� ����砭�� ��ਮ�� ���� ��業⮢ ������ ���� ᫥���騬 ࠡ�稬 ����.
       �����, ����� ��ࠦ���� 
   periodEnd = MIN(endDate, loan.end-date).
       �믮���� ���⮥ ��c������
   */
   periodEnd = endDate. 
   
   /** ���祭�� "��" ��ਮ�� */
   balance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, periodBegin - 1, false).
   rate = GetLoanCommission_ULL(ENTRY(1, mainLoan), ENTRY(2, mainLoan), "%�।", periodBegin, false).
   /** �������� �� ��� */
   DO iDate = periodBegin TO periodEnd :
	
	 IF loan.since < iDate THEN DO:
	 	RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + 
	 	                " �� �����⠭ �� ���� " + STRING(periodEnd)).
	 	RETURN. 
	 END.

     newBalance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, iDate, false).
     newRate = GetLoanCommission_ULL(ENTRY(1, mainLoan), ENTRY(2, mainLoan), "%�।", iDate + 1, false).
     
     /**    ����:
     	1) ��������� ���⮪
     	2) ���������� ��業⭠� �⠢��
     	3) ��᫥���� ���� �����
 		4) ��᫥���� ���� ���⭮�� ��ਮ��,
 			��:
 		"ᮧ����" �����ਮ�, ����뢠�� ���祭��, ����㫨�㥬 ����� �㬬�,
 		���� ���祭�� �⠭������ ⥪�騬�!
 	*/
     IF    balance 	   <> newBalance
	OR rate            <> newRate 
	OR (DAY(iDate + 1) = 1 AND iDate < periodEnd) 
        OR iDate 	   = periodEnd THEN
       DO:
	     periodEnd = iDate.
	     periodBase = (IF TRUNCATE(YEAR(iDate) / 4,0) = YEAR(iDate) / 4 THEN 366 ELSE 365).
             period = periodEnd - periodBegin + 1.

	     summa = round(balance * rate / periodBase * period, 2).
		 totalSumma = totalSumma + summa.

		 /* � ��砥 �᫨ �㬬������ 㬥��訫��� ����� �� ��業�� ����襭�, ����塞 �� ��業�� ����� ���⠫� �� �⮣�!   */
		 IF newBalance < balance
			THEN
				ASSIGN
					totalSumma = 0
					out_Date   = periodEnd + 1
				.
		 
	     RUN Fill-SysMes("","", "1", /* "PirLoanPercent: " +
					 "loan = " + loan.contract + "." + loan.cont-code + */
	                                 ", bal = " + STRING(balance) + 
	                                 ", rate = " + STRING(rate) + 
	                                 ", perBase = " + STRING(periodBase) +
	                                 ", per = " + STRING(period) + "(" + STRING(periodBegin) + " - " + STRING(periodEnd) + ")" +
	                                 ", summa = balance * rate / periodBase * period = " + STRING(summa) +
	                                 ", total = " + STRING(totalSumma)).

                 periodBegin = periodEnd + 1.
		 periodEnd = MIN(endDate, loan.end-date).
		 balance = newBalance.
		 rate = newRate.         
       END.
   END. 
   
   out_Result = totalSumma.
   
   is-ok = 0.
END PROCEDURE. /* "PIR_LOAN_PERCENT_AMT_DATE_VIRT" */



{pfuncdef
   &NAME          = "PIR_LOAN_PERCENT_NEW"
   &DESCRIPTION   = "����������� �㭪�� PIR_LOAN_PERCENT_NEW, ⥯��� ���뢠�� ᬥ�� �� � ����筮� ����襭��."
   &PARAMETERS    = "���������� ��������, ����� ��������, ������ �������, ����� �������[, ������� ������� = ���]"
   &RESULT        = "����� ���������"
   &SAMPLE        = "@__amt = PIR_LOAN_PERCENT_NEW(@contract(10), @cont-code(10), @__beg-date, @__end-date)"
   }
   
   DEFINE INPUT  PARAMETER iContract        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iContCode        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iBegDate         AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate			AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iNeedMon			AS LOGICAL	NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result    	AS DECIMAL		NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok          	AS INTEGER		NO-UNDO.

   DEF VAR out_Date AS DATE NO-UNDO.

   RUN PIR_LOAN_PERCENT_AMT_DATE(iContract, iContCode, iBegDate, iEndDate, iNeedMon
				, OUTPUT out_Result, OUTPUT out_Date, OUTPUT is-ok).

END PROCEDURE. /* "PIR_LOAN_PERCENT_NEW" */

{pfuncdef
   &NAME          = "PIR_LOAN_PERCENT_NEW_VIRT"
   &DESCRIPTION   = "����������� �㭪�� PIR_LOAN_PERCENT_NEW, ⥯��� ���뢠�� ᬥ�� �� � ����筮� ����襭��."
   &PARAMETERS    = "���������� ��������, ����� ��������, ������ �������, ����� �������[, ������� ������� = ���]"
   &RESULT        = "����� ���������"
   &SAMPLE        = "@__amt = PIR_LOAN_PERCENT_NEW(@contract(10), @cont-code(10), @__beg-date, @__end-date)"
   }
   
   DEFINE INPUT  PARAMETER iContract        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iContCode        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iBegDate         AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate			AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iNeedMon			AS LOGICAL	NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result    	AS DECIMAL		NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok          	AS INTEGER		NO-UNDO.

   DEF VAR out_Date AS DATE NO-UNDO.

   RUN PIR_LOAN_PERCENT_AMT_DATE_VIRT(iContract, iContCode, iBegDate, iEndDate, iNeedMon
				, OUTPUT out_Result, OUTPUT out_Date, OUTPUT is-ok).

END PROCEDURE. /* "PIR_LOAN_PERCENT_NEW" */


{pfuncdef
   &NAME          = "PIR_LOAN_PERCENT_DATE"
   &DESCRIPTION   = "����������� �㭪�� PIR_LOAN_PERCENT_NEW, ⥯��� ���뢠�� ᬥ�� �� � ����筮� ����襭��."
   &PARAMETERS    = "���������� ��������, ����� ��������, ������ �������, ����� �������[, ������� ������� = ���]"
   &RESULT        = "����"
   &SAMPLE        = "@__amt = PIR_LOAN_PERCENT_DATE(@contract(10), @cont-code(10), @__beg-date, @__end-date)"
   }
   
   DEFINE INPUT  PARAMETER iContract        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iContCode        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iBegDate         AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate			AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iNeedMon			AS LOGICAL	NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result    	AS DATE			NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok          	AS INTEGER		NO-UNDO.

   DEF VAR out_Date AS DATE NO-UNDO.

   RUN PIR_LOAN_PERCENT_AMT_DATE(iContract, iContCode, iBegDate, iEndDate, iNeedMon
				, OUTPUT out_Result, OUTPUT out_Date, OUTPUT is-ok).

   out_Result = out_Date.

/* RUN Fill-SysMes("","", "1", "PirLoanPercent: " +
"loan = " + loan.contract + "." + STRING(out_Result, "99/99/99")). /* !!! */
* /
MESSAGE
"loan = " + loan.contract + " " + STRING(out_Result, "99/99/99") VIEW-AS ALERT-BOX. /* !!! */
*/

END PROCEDURE. /* "PIR_LOAN_PERCENT_DATE" */





{pfuncdef
   &NAME          = "PirFindBankBySwift"
   &DESCRIPTION   = "�㭪�� �����頥� ������������ ����� �� swift ����"
   &PARAMETERS    = "Swift ���"
   &RESULT        = "����� ���������"
   &SAMPLE        = "@__bank_name = PirFindBankBySwift(@_swift)"
   }
                                                          
  				/************************************************************
				 * �㭪�� �����頥� ������������ ����� �� swift ����      *
				 *               					    *
				 *                      				    *
				 *    1. cSwift - swift ���				    *
                                 *                                                          *
			 	 * ����: ��᪮� �.�.					    *
				 * ��� ᮧ�����: 29.02.2010			 	    *
				 * ���: #852						    *
				 ************************************************************/

  DEFINE INPUT  PARAMETER cSwift as CHAR NO-UNDO.
  def var temp as CHAR INIT "" NO-UNDO.
  DEFINE OUTPUT PARAMETER out_Result AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER is-ok AS INTEGER NO-UNDO.


  find first banks-code where banks-code.bank-code-type = "bic" and banks-code.bank-code Begins Substring(cSwift,1,8) no-lock no-error.
  if available banks-code then 
     find first banks where banks.bank-id = banks-code.bank-id NO-LOCK No-error.
 
  if available banks then temp = banks.name.



       out_result = temp.
       is-ok = 0.

END PROCEDURE. /* "PirFindBankBySwift" */

{pfuncdef
   &NAME          = "PIR_LOAN_PERCENT_NACH"
   &DESCRIPTION   = "����������� �㭪�� PIR_LOAN_PERCENT �।�����祭� ��� ������ ��業⮢ ����室��� ��� ��७�� � 47427 �� 45915."
   &PARAMETERS    = "���������� ��������, ����� ��������, ������ �������, ����� �������[, ������� ������� = ���]"
   &RESULT        = "����� ���������"
   &SAMPLE        = "@__amt = PIR_LOAN_PERCENT_NEW(@contract(10), @cont-code(10), @__beg-date, @__end-date)"
   }

   DEFINE INPUT  PARAMETER iContract        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iContCode        AS CHARACTER	NO-UNDO.
   DEFINE INPUT  PARAMETER iBegDate         AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate			AS DATE	NO-UNDO.
   DEFINE INPUT  PARAMETER iNeedMon			AS LOGICAL	NO-UNDO.
   DEFINE OUTPUT PARAMETER out_Result    	AS DECIMAL		NO-UNDO.
   DEFINE OUTPUT PARAMETER is-ok          	AS INTEGER		NO-UNDO.

   DEF VAR begDate AS DATE NO-UNDO.
   DEF VAR endDate AS DATE NO-UNDO.
   def var startBegDate AS Date NO-UNDO.
   def var startendDate AS Date NO-UNDO.
   DEF VAR balance AS DECIMAL NO-UNDO.
   DEF VAR newBalance AS DECIMAL NO-UNDO.
   DEF VAR rate AS DECIMAL NO-UNDO.
   DEF VAR newRate AS DECIMAL NO-UNDO.
   DEF VAR summa AS DECIMAL NO-UNDO.
   DEF VAR totalSumma AS DECIMAL NO-UNDO.
   DEF VAR period AS INTEGER NO-UNDO.
   DEF VAR iDate AS DATE NO-UNDO.
   DEF VAR periodBegin AS DATE NO-UNDO.
   DEF VAR periodEnd AS DATE NO-UNDO.
   DEF VAR periodBase AS INTEGER NO-UNDO.
   DEF VAR PredSumma AS DEC.
   
   DEF VAR mainLoan AS CHARACTER NO-UNDO.
   
   begDate = iBegDate.
   endDate = iEndDate.
   
   /** ���� ���� ��業⮢ 365/366 */

   
   FIND FIRST loan WHERE loan.contract = iContract
                     and loan.cont-code = iContCode
                     NO-LOCK NO-ERROR.
                     
   IF NOT AVAIL loan THEN DO:
      RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� '" + iContract + "." + iContCode + "' �� ������!").
      RETURN.
   END.
/*message "1" VIEW-AS ALERT-BOX.*/
/* �஢��塞 ���� �� ����� ����� ��-���� */
if loan.gr-riska <> 0 then
 do:
   /*��������� � ��ன �㭪樨: */

/* �஢��塞 �뫮 �� ����襭�� ��業⮢ � ⥪�饬 ��� (���� �஡����:
��� ���᪠ ����襭�� ��業⮢ �饬 ��⮬���᪨� ����樨 ����� ᮧ������ �� ������ �� ᫥���騩 ���� */

def var cKredProc as char  No-Undo.

find last loan-acct where loan-acct.contract = loan.contract and loan.cont-code = SUBSTRING(loan.cont-code,1,9) 
and loan-acct.acct-type = "�।���" NO-LOCK NO-ERROR.
if available(loan-acct) then
do:
   cKredProc = loan-acct.acct.
   find last loan-acct where loan-acct.contract = loan.contract and loan.cont-code = SUBSTRING(loan.cont-code,1,9) 
   and loan-acct.acct-type = "�।����" NO-LOCK NO-ERROR.
   find last op-entry where op-entry.acct-db = loan-acct.acct and op-entry.acct-db = loan-acct.acct and op-entry.op-date = end-date NO-LOCK NO-ERROR.
   if available(op-entry) then do:
      ibegdate = end-date + 1.
      begdate = end-date + 1.
/*message begdate VIEW-AS ALERT-BOX.*/
   end.
end. 



/* �஢��塞 �뫮 �� ����襭�� ��業⮢ �� ����� ��ਮ� */
   mainLoan = GetMainLoan_ULL(loan.contract, loan.cont-code, false).
   find last loan-int
	where loan-int.cont-code = ENTRY(2, mainLoan)
				   /* ENTRY(2, mainLoan) */
	  and loan-int.contract = loan.contract
	  and loan-int.mdate >= begDate 
	  and loan-int.mdate <= endDate 

	  and (loan-int.id-d = 6) /* ���=6 � ��=4 ��� �������� 9 */
	  and (loan-int.id-k = 4)

	NO-LOCK NO-ERROR.


   if AVAILABLE(loan-int) then do:
     begDate = loan-int.mdate + 1. /* ���뢠�� �� ������塞 1 ���� ��� ���� */
/*     out_Date = begdate.*/
     RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + " �뫮 ����襭�� � ᤢ����� ��砫��� ���� �� " + STRING(begDate)).
   end.

   startBegDate = begDate.
   startEndDate = endDate.

/* �஢��塞 �뫠 �� ᬥ�� ��⥣�ਨ ����⢠ */
   def var startCQ AS DEC.
   def var endCQ AS DEC.
   DEF BUFFER bcomm-rate for comm-rate.
   DEF BUFFER bloan-acct for loan-acct.
   DEF BUFFER bterm-obl for term-obl.
   def var bPOS as LOGICAL.
   find last bterm-obl WHERE bterm-obl.cont-code EQ ENTRY(2, mainLoan) AND bterm-obl.contract EQ '�।��' AND bterm-obl.idnt EQ 128 NO-LOCK NO-ERROR.
   if AVAILABLE (bterm-obl) then do:


      if bterm-obl.end-date >=iBegdate and bterm-obl.end-date <= iEndDate then do:
         ienddate = bterm-obl.end-date.
         enddate = bterm-obl.end-date.
         bPos = true.
      end.
      if bterm-obl.sop-date >=iBegDate and bterm-obl.sop-date <= iEndDate then do:
	 ienddate = bterm-obl.sop-date + 1. 
  	 enddate = bterm-obl.sop-date + 1.
         bPos = true.
      end.
      RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + " ,�뫨 ����⢨� � ����䥫�� � " + STRING(iBegDate, "99/99/99")).

   end. /*AVAILABLE (term-obl)*/


   find first bcomm-rate
	where bcomm-rate.commission begins "%���"
	  and bcomm-rate.kau = "�।��," + ENTRY(2, mainLoan)
	  and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate ᤢ�������, �᫨ �뫮 ����襭��  */
	  and bcomm-rate.since <= endDate
	NO-LOCK NO-ERROR.
   

   if AVAILABLE(bcomm-rate) then do:
      startCQ = bcomm-rate.rate-comm.
/* message " loan.cont-code" loan.cont-code begDate endDate bcomm-rate.since startCQ view-as alert-box. / * !!! */
      find last bcomm-rate
	where bcomm-rate.commission begins "%���"
	  and bcomm-rate.kau = "�।��," + ENTRY(2, mainLoan)
	  and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate ᤢ�������, �᫨ �뫮 ����襭��  */
	  and bcomm-rate.since <= endDate
	NO-LOCK NO-ERROR.
      endCQ = bcomm-rate.rate-comm.
      if ((startCQ <> endCQ) and ((startCQ > 50 and endCQ <= 50) OR (startCQ <= 50 and endCQ > 50))) OR bPOS then do:

        find /* last */ first bcomm-rate
	  where bcomm-rate.rate-comm = /* startCQ */ endCQ
            and bcomm-rate.commission begins "%���"
   	    and bcomm-rate.kau = "�।��," + ENTRY(2, mainLoan)
	    and bcomm-rate.since >= iBegDate /* SSV #747 iBegDate begDate ᤢ�������, �᫨ �뫮 ����襭�� */
 	    and bcomm-rate.since <= endDate
	  NO-LOCK NO-ERROR.

        RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + " ���� ����� �� " + STRING(startCQ) + "->" + STRING(endCQ)
+ " c " + STRING(bcomm-rate.since, "99/99/99")).
        enddate = bcomm-rate.since + 1.
        ienddate = enddate.
/*	out_Date = enddate.*/
        DEF VAR role AS CHAR NO-UNDO.
        role = if startCQ > 50
	  then "�।�"
	  else "�।��".
        find first bloan-acct
	  where bloan-acct.cont-code = ENTRY(2, mainLoan)
	    and bloan-acct.contract  = loan.contract
	    and bloan-acct.acct-type = role
	    NO-LOCK NO-ERROR.
        if available (bloan-acct) then do:
   	  DEF VAR oAcct AS TAcct NO-UNDO.
          oAcct = new tAcct(bloan-acct.acct).
          PredSumma = oAcct:getlastpos2date(enddate).
          delete object oAcct.
        end.
      end. /* if startCQ <> endCQ then do: */
   end. /* if AVAILABLE(bcomm-rate) then do: */

   periodBegin = MAX(begDate, loan.open-date). /* SSV �뫮 + 1  */
/*   out_Date    = periodBegin.*/


if startbegdate = begdate and startenddate = enddate then do:
 totalsumma = 0.
end.
else
do:

   /** � ����� ����� ��� ����砭�� �࠭� �������� �� ��室��� ����,
       ��� ����砭�� ��ਮ�� ���� ��業⮢ ������ ���� ᫥���騬 ࠡ�稬 ����.
       �����, ����� ��ࠦ���� 
   periodEnd = MIN(endDate, loan.end-date).
       �믮���� ���⮥ ��c������
   */
   periodEnd = endDate. 
   
   /** ���祭�� "��" ��ਮ�� */
   balance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, periodBegin - 1, false).
   rate = GetLoanCommission_ULL(ENTRY(1, mainLoan), ENTRY(2, mainLoan), "%�।", periodBegin, false).
   /** �������� �� ��� */
   DO iDate = periodBegin TO periodEnd :
	
	 IF loan.since < iDate THEN DO:
	 	RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + 
	 	                " �� �����⠭ �� ���� " + STRING(periodEnd)).
	 	RETURN. 
	 END.

     newBalance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, iDate, false).
     newRate = GetLoanCommission_ULL(ENTRY(1, mainLoan), ENTRY(2, mainLoan), "%�।", iDate + 1, false).
     
     /**    ����:
     	1) ��������� ���⮪
     	2) ���������� ��業⭠� �⠢��
     	3) ��᫥���� ���� �����
 		4) ��᫥���� ���� ���⭮�� ��ਮ��,
 			��:
 		"ᮧ����" �����ਮ�, ����뢠�� ���祭��, ����㫨�㥬 ����� �㬬�,
 		���� ���祭�� �⠭������ ⥪�騬�!
 	*/
/* 	 
RUN Fill-SysMes("","", "-1", "6 " + " " + loan.cont-code + " " + STRING(iDate)
 + " balance <> newBalance " + STRING(balance) + " " + STRING(newBalance)
 + " rate <> newRate " + STRING(rate) + " " + STRING(newRate)
 + " (DAY(iDate + 1) = 1 AND iDate < periodEnd) " + STRING(DAY(iDate + 1)) + " " + STRING((iDate < periodEnd))
 + "iDate = periodEnd " + STRING(iDate) + " " + STRING(periodEnd)
).
*/
     IF    balance 	   <> newBalance
	OR rate            <> newRate 
	OR (DAY(iDate + 1) = 1 AND iDate < periodEnd) 
        OR iDate 	   = periodEnd THEN
       DO:
	     periodEnd = iDate.
	     periodBase = (IF TRUNCATE(YEAR(iDate) / 4,0) = YEAR(iDate) / 4 THEN 366 ELSE 365).
             period = periodEnd - periodBegin + 1.

	     summa = round(balance * rate / periodBase * period, 2).
		 totalSumma = totalSumma + summa.

		 /* � ��砥 �᫨ �㬬������ 㬥��訫��� ����� �� ��業�� ����襭�, ����塞 �� ��業�� ����� ���⠫� �� �⮣�!   */
		 IF newBalance < balance
			THEN
				ASSIGN
					totalSumma = 0
/*					out_Date   = periodEnd + 1*/
				.
		 
/*	     IF iNeedMon THEN  */
	     RUN Fill-SysMes("","", "1", /* "PirLoanPercent: " +
					 "loan = " + loan.contract + "." + loan.cont-code + */
	                                 ", bal = " + STRING(balance) + 
	                                 ", rate = " + STRING(rate) + 
	                                 ", perBase = " + STRING(periodBase) +
	                                 ", per = " + STRING(period) + "(" + STRING(periodBegin) + " - " + STRING(periodEnd) + ")" +
	                                 ", summa = balance * rate / periodBase * period = " + STRING(summa) +
	                                 ", total = " + STRING(totalSumma)).

                 periodBegin = periodEnd + 1.
		 periodEnd = MIN(endDate, loan.end-date).
		 balance = newBalance.
		 rate = newRate.         
       END.
   END. 
end.
end.
else
do:
 totalSumma = 0.
end.
   
   out_Result = totalSumma.
   
   is-ok = 0.

   
END PROCEDURE. /* "PIR_LOAN_PERCENT_NACH" */

{pfuncdef
   &NAME          = "PirAcctCom"
   &DESCRIPTION   = "�㭪�� PirAcctCom, �����頥� �� ������ ���� ᭨���� ������� �᫨ ���⥦ �� � 40821"
   &PARAMETERS    = "���, ���"
   &RESULT        = "���"
   &SAMPLE        = "@__a��t = PirAcctCom(@acct(10), Date())"
   }

  DEFINE INPUT PARAMETER cAcct       AS CHAR NO-UNDO. 
  DEFINE INPUT PARAMETER dOpDate     AS DATE NO-UNDO.
  DEFINE OUTPUT PARAMETER out_Result AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER is-ok      AS INT  NO-UNDO.



  DEF VAR cAcctKom AS CHAR     NO-UNDO. 
  DEF VAR oAcct    AS TAcctBal NO-UNDO.


       oAcct = NEW TAcctBal(cAcct).
         cAcctKom = oAcct:getAlias40821(dOPDate).
       DELETE OBJECT oAcct.


       out_result = cAcctKom.
       is-ok = 0.

END PROCEDURE. /* "PirAcctCom" */

{pfuncdef
   &NAME          = "PirKursPositiveMove"
   &DESCRIPTION   = "�����頥� ������⥫��� ࠧ���� ���ᮢ �� ��ਮ�" 
   &PARAMETERS    = "���, ���,[doSplit]"
   &RESULT        = "���"
   &SAMPLE        = "@pm=PirKursPositiveMove(DATE('01/01/2011'),DATE('31/12/2012'),'840'); - �����頥�
����⥫��� ���ᮢ�� ࠧ���� ��� ࠧ����� �� �।��騩, ⥪�騩 ���.
                     @pm=PirKursPositiveMove(DATE('01/01/2011',DATE('31/12/2012'),YES)) - �����頥� 
����⥫��� ���ᮢ�� ࠧ���� � ࠧ������ �� �।��騩 � ⥪�騩 ���. ���᮪ �१ �������. ���ਬ��,
� ������ ��砥 ����� ������ '+12.29,+10.5'  "
   }

DEF INPUT PARAM begDate AS DATE            NO-UNDO.
DEF INPUT PARAM endDate AS DATE            NO-UNDO.
DEF INPUT PARAM cVal    AS CHAR            NO-UNDO.
DEF INPUT PARAM doSplit AS LOG  INIT FALSE NO-UNDO.
DEF INPUT PARAM showLog AS LOG  INIT FALSE NO-UNDO.

DEFINE OUTPUT PARAMETER out_Result AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER is-ok      AS INT  NO-UNDO.


DEF VAR oAArray AS TAArray NO-UNDO.

DEF VAR key1   AS CHARACTER         NO-UNDO.
DEF VAR value1 AS CHARACTER         NO-UNDO.
DEF VAR res       AS CHAR           NO-UNDO.

DEF VAR splitPoints AS CHAR         NO-UNDO.

DEF VAR oSysClass AS TSysClass      NO-UNDO.

DEF VAR currSegment AS INT          NO-UNDO.

DEF VAR prevLine  AS DATE           NO-UNDO.
DEF VAR currLine  AS DATE           NO-UNDO.

DEF VAR otherYear AS DECIMAL INIT 0 NO-UNDO.
DEF VAR prevYear  AS DECIMAL INIT 0 NO-UNDO.
DEF VAR currYear  AS DECIMAL INIT 0 NO-UNDO.

DEF VAR oTable    AS TTable         NO-UNDO.

oSysClass = NEW TSysClass().
oTable    = NEW TTable(2).

prevLine = DATE(01,01,YEAR(endDate) - 1).
currLine = DATE(01,01,YEAR(endDate)).

splitPoints = "0" + "," + STRING(YEAR(prevLine)) + "," + STRING(YEAR(currLine)).

oAArray = TSysClass:calcKursMove(begDate,endDate,cVal).


{foreach oAArray key1 value1}
    IF DECIMAL(value1) > 0 THEN DO:

      currSegment = oSysClass:getLineSegmentByList(YEAR(DATE(key1)),splitPoints).

   
      CASE currSegment:

         WHEN 1 THEN DO:
               otherYear = otherYear + DECIMAL(value1).
         END.
         WHEN 2 THEN DO:
               prevYear  = prevYear  + DECIMAL(value1).
         END.
         WHEN 3 THEN DO:
               currYear  = currYear  + DECIMAL(value1).
         END.

      END CASE.
     oTable:addRow().
     oTable:addCell(key1).
     oTable:addCell(value1).

    END.
{endforeach oAArray}

 IF doSplit THEN DO:
     res = STRING(otherYear) + "," + STRING(prevYear) + "," + STRING(currYear).
 END.
 ELSE DO:
     res = STRING(otherYear + prevYear + currYear).
 END.

IF showLog THEN DO:
   OUTPUT TO "./pir-pos.log".
     PUT UNFORMATTED "*** ������ ������������ ������������� ���������� ***" SKIP.
     PUT UNFORMATTED "�� ������ � " begDate " �� " endDate SKIP.
     oTable:show().
   OUTPUT CLOSE.
END.


DELETE OBJECT oAArray.
DELETE OBJECT oSysClass.
DELETE OBJECT oTable.
is-ok = 0.
out_Result = res.

END PROCEDURE.

{pfuncdef
   &NAME          = "PirKursNegativeMove"
   &DESCRIPTION   = "�����頥� ����⥫��� ࠧ���� ���ᮢ �� ��ਮ�. �᫨ 㪠��� ��ࠬ��� showLog, 
� ��� ������ ஦������ 䠩� pir-neg.log"
   &PARAMETERS    = "���, ���,[doSplit],[showLog]"
   &RESULT        = "���"
   &SAMPLE        = "@pm = PirKursPositiveMove(DATE('01/01/2011'),DATE('31/12/2012'),'840'); - �����頥�
����⥫��� ���ᮢ�� ࠧ���� ��� ࠧ����� �� �।��騩, ⥪�騩 ���.
                     @pm = PirKursPositiveMove(DATE('01/01/2011',DATE('31/12/2012'),YES)) - �����頥� 
����⥫��� ���ᮢ�� ࠧ���� � ࠧ������ �� �।��騩 � ⥪�騩 ���. ���᮪ �१ �������. ���ਬ��,
� ������ ��砥 ����� ������ '-12.29,-10.5'  "

   }

DEF INPUT PARAM begDate AS DATE            NO-UNDO.
DEF INPUT PARAM endDate AS DATE            NO-UNDO.
DEF INPUT PARAM cVal    AS CHAR            NO-UNDO.
DEF INPUT PARAM doSplit AS LOG  INIT FALSE NO-UNDO.
DEF INPUT PARAM showLog AS LOG  INIT FALSE NO-UNDO.

DEFINE OUTPUT PARAMETER out_Result AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER is-ok      AS INT  NO-UNDO.


DEF VAR oAArray AS TAArray NO-UNDO.

DEF VAR key1   AS CHARACTER         NO-UNDO.
DEF VAR value1 AS CHARACTER         NO-UNDO.
DEF VAR res       AS CHAR           NO-UNDO.

DEF VAR splitPoints AS CHAR         NO-UNDO.

DEF VAR oSysClass AS TSysClass      NO-UNDO.

DEF VAR currSegment AS INT          NO-UNDO.

DEF VAR prevLine  AS DATE           NO-UNDO.
DEF VAR currLine  AS DATE           NO-UNDO.

DEF VAR otherYear AS DECIMAL INIT 0 NO-UNDO.
DEF VAR prevYear  AS DECIMAL INIT 0 NO-UNDO.
DEF VAR currYear  AS DECIMAL INIT 0 NO-UNDO.

DEF VAR oTable    AS TTable         NO-UNDO.


oTable = NEW TTable(2).

oSysClass = NEW TSysClass().

prevLine = DATE(01,01,YEAR(endDate) - 1).
currLine = DATE(01,01,YEAR(endDate)).

splitPoints = "0" + "," + STRING(YEAR(prevLine)) + "," + STRING(YEAR(currLine)).

oAArray = TSysClass:calcKursMove(begDate,endDate,cVal).


{foreach oAArray key1 value1}
    IF DECIMAL(value1) < 0 THEN DO:

      currSegment = oSysClass:getLineSegmentByList(YEAR(DATE(key1)),splitPoints).

   
      CASE currSegment:

         WHEN 1 THEN DO:
               otherYear = otherYear + DECIMAL(value1).
         END.
         WHEN 2 THEN DO:
               prevYear  = prevYear  + DECIMAL(value1).
         END.
         WHEN 3 THEN DO:
               currYear  = currYear  + DECIMAL(value1).
         END.

      END CASE.

      oTable:addRow().
      oTable:addCell(key1).
      oTable:addCell(value1).

    END.
{endforeach oAArray}

 IF doSplit THEN DO:
     res = STRING(otherYear) + "," + STRING(prevYear) + "," + STRING(currYear).
 END.
 ELSE DO:
     res = STRING(otherYear + prevYear + currYear).
 END.

IF showLog THEN DO:
   OUTPUT TO "./pir-neg.log".
     PUT UNFORMATTED "*** ������ ������������ ������������� ���������� ***" SKIP.
     PUT UNFORMATTED "�� ������ � " begDate " �� " endDate SKIP.
     oTable:show().
   OUTPUT CLOSE.
END.
DELETE OBJECT oAArray.
DELETE OBJECT oSysClass.
DELETE OBJECT oTable.
is-ok = 0.
out_Result = res.
END PROCEDURE.

{pfuncdef
   &NAME          = "���ᖡ������"
   &DESCRIPTION   = "�����頥� ���� �� �� ����"
   &PARAMETERS    = "���"
   &RESULT        = "����"
   &SAMPLE        = "@pm=���ᖡ������("840",01/01/2011);"
   }

DEF INPUT  PARAM val        AS CHARACTER NO-UNDO.
DEF INPUT  PARAM dDate      AS DATE      NO-UNDO.
DEF OUTPUT PARAM out_Result AS DECIMAL   NO-UNDO.
DEF OUTPUT PARAM is-ok      AS INTEGER   NO-UNDO.


DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR res       AS DECIMAL   NO-UNDO.

IF val = "" THEN val = "810".

oSysClass = new TSysClass().
 res = oSysClass:getCBRKurs(INT(val),dDate).
DELETE OBJECT oSysClass.

out_Result = reS.
is-ok = 0.
END PROCEDURE.

{pfuncdef
   &NAME          = "���፠����"
   &DESCRIPTION   = "�����頥� ������� ���� �� ����"
   &PARAMETERS    = "���"
   &RESULT        = "����"
   &SAMPLE        = "@pm=���፠����("840",01/01/2011,"�ূ�脡");"
   }

DEF INPUT  PARAM val        AS CHAR NO-UNDO.
DEF INPUT  PARAM dDate      AS DATE NO-UNDO.
DEF INPUT  PARAM typeOper   AS CHAR NO-UNDO.

DEF OUTPUT PARAM out_Result AS DECIMAL   NO-UNDO.
DEF OUTPUT PARAM is-ok      AS INTEGER   NO-UNDO.


DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR res       AS DEC       NO-UNDO.

IF val = "" THEN val = "810".

oSysClass = new TSysClass().
 res = oSysClass:getKursByType(typeOper,INT(val),dDate).
DELETE OBJECT oSysClass.
                	
out_Result = res.
is-ok = 0.
END PROCEDURE.


{pfuncdef
   &NAME          = "PirFirstZeroExit"
   &DESCRIPTION   = "����頥� ��������� ���� ��室� ��� ������������ �� ���"
   &PARAMETERS    = "����� �������,������ ���"
   &RESULT        = "���"
   &SAMPLE        = "@pm=PirFirstZeroExit(01/01/2011);"
   }
DEF INPUT  PARAM cCont-Code AS CHARACTER NO-UNDO.
DEF INPUT  PARAM currDate   AS DATE      NO-UNDO.

DEF OUTPUT PARAM out_Result AS DATE    NO-UNDO.
DEF OUTPUT PARAM is-ok      AS INTEGER NO-UNDO.

DEF BUFFER bloan-var FOR loan-var.

FIND LAST loan-var WHERE loan-var.amt-id    EQ 0
                     AND loan-var.cont-code EQ cCont-Code
                     AND loan-var.contract  EQ "�।��"
                     AND loan-var.balance   EQ 0
		     AND loan-var.since     LE currDate
                     NO-LOCK NO-ERROR.

IF AVAILABLE(loan-var) THEN DO:
   /*************
    * ��ࠬ��� �室�� � ����.
    *************/
   FIND FIRST bloan-var WHERE bloan-var.amt-id EQ 0
                          AND bloan-var.cont-code = cCont-Code
                          AND bloan-var.contract  = "�।��"
			  AND bloan-var.since     > loan-var.since
			  AND bloan-var.since     <= currDate
                          AND bloan-var.balance   > 0
                          NO-LOCK NO-ERROR.
   IF AVAILABLE(bloan-var) THEN DO:
        /**************
         * ��ࠬ��� ��襫 �� ���.
         **************/
        out_Result = bloan-var.since.
   END. 
   ELSE DO:
       /***************
        * ��ࠬ��� ⠪ � �� ��襫 �� ���.
        ****************/
     out_Result = currDate.
   END.
 END.
 ELSE DO:
           /**************************
	    * ��室�� ����� �뤠��  *
	    **************************/
	FIND FIRST loan-int WHERE loan-int.cont-code EQ cCont-Code
			      AND (loan-int.id-k = 0 OR loan-int.id-d = 0)
			      AND loan-int.contract = "�।��"
			      NO-LOCK.
	IF AVAILABLE(loan-int) THEN DO:
		out_Result = loan-int.mdate.
	END.
 END.
is-ok = 0.
END PROCEDURE.

{pfuncdef
   &NAME          = "ReversMask"
   &DESCRIPTION   = "������ �� ��᪨ ���栭��"
   &PARAMETERS    = "��᪠"
   &RESULT        = "��᪠ � ���栭���"
   &SAMPLE        = "@notmask=ReversMask("40702*,40703*");"
   }
DEF INPUT  PARAM mask       AS CHAR    NO-UNDO.
DEF OUTPUT PARAM out_Result AS CHAR    NO-UNDO.
DEF OUTPUT PARAM is-ok      AS INT     NO-UNDO.

DEF VAR i AS INT NO-UNDO.

DO i = 1 TO NUM-ENTRIES(mask):
   ENTRY(i,mask) = "!" + ENTRY(i,mask).
END.
out_Result = mask.
is-ok = 0.
END PROCEDURE.

{pfuncdef
   &NAME          = "���������ₐ㡫��"
   &DESCRIPTION   = "�����뢠�� ������ ���������� �㬬� �������� � �㡫�� �� ����� ��"
   &PARAMETERS    = "�㬬� � �㡫��,��� ������,��� �� ������ �����뢠��"
   &RESULT        = "DECIMAL"
   &SAMPLE        = "@e=���������ₐ㡫��(1000,'840',01/01/2012);"
   }

   DEF INPUT  PARAM dSum       AS DECIMAL NO-UNDO.
   DEF INPUT  PARAM dVal       AS CHAR    NO-UNDO.
   DEF INPUT  PARAM dDate      AS DATE    NO-UNDO.

   
   DEF OUTPUT PARAM out_Result AS DECIMAL NO-UNDO.
   DEF OUTPUT PARAM is-ok      AS INT     NO-UNDO.
                                                     
   DEF VAR oSysClass AS TSysClass         NO-UNDO.
   DEF VAR dSumVal   AS DECIMAL           NO-UNDO.

   oSysClass = NEW TSysClass().

       dSumVal = oSysClass:getValEq(dSum,dVal,dDate).

   DELETE OBJECT oSysClass.

  out_Result = dSumVal.
  is-ok = 0.
END PROCEDURE.



{pfuncdef
   &NAME          = "PirFindSF"
   &DESCRIPTION   = "���� ���-䠪���� �� �������� ������� � ���� 業���� � ������� ��ਮ�� � �����頥� �����."
   &PARAMETERS    = "��������,����������,��砫���ਮ��,����揥ਮ��"
   &RESULT        = "CHARACTER"
   &SAMPLE        = "PIRSFNumber=PirFindSF(@__cust,@__asset,@__beg-date,@__end-date)"
   }

   DEF INPUT  PARAM iCust      AS CHARACTER NO-UNDO.
   DEF INPUT  PARAM iAsset_ID  AS CHARACTER NO-UNDO.
   DEF INPUT  PARAM iBeg-date  AS DATE    NO-UNDO.
   DEF INPUT  PARAM iEnd-date  AS DATE    NO-UNDO.

   
   DEF OUTPUT PARAM out_Result AS CHARACTER NO-UNDO.
   DEF OUTPUT PARAM is-ok      AS INT     NO-UNDO.
   out_result = "".

   if iAsset_ID <> "*" then do:
   for each loan where loan.contract begins "sf"
		   and loan.cust-cat = entry(1,iCust)
		   and loan.cust-id = INT(entry(2,iCust))
		   and loan.open-date >= iBeg-date
		   and loan.open-date <= iEnd-date
                   NO-LOCK,
      first term-obl where term-obl.cont-code = loan.cont-code
		       and term-obl.contract = loan.contract
		       and term-obl.idnt = 1
		       and term-obl.symbol =iAsset_ID 
		  NO-LOCK:

/*	      message "������� C� " iAsset_ID  loan.doc-num loan.conf-date  VIEW-AS ALERT-BOX.*/

	      out_result = loan.doc-num + "," + STRING(loan.conf-date).
      end.
   end.                                                  
   else
   do:
      find last loan where loan.contract begins "sf"
  	 	       and loan.cust-cat = entry(1,iCust)
		       and loan.cust-id = INT(entry(2,iCust))
		       and loan.open-date >= iBeg-date
		       and loan.open-date <= iEnd-date
                       NO-LOCK NO-ERROR.

      if available(loan) then out_result = loan.doc-num + "," + STRING(loan.conf-date).

   end.

  is-ok = 0.
END PROCEDURE.



{pfuncdef
   &NAME          = "GetVoCod"
   &DESCRIPTION   = "�����頥� ��� VO ��室� �� ⮣� �� ��।��� � �㭪��"
   &PARAMETERS    = "���,����VO,����� �஢����,"
   &RESULT        = "CHARACTER"
   &SAMPLE        = "VoCod=GetVoCod(@__acct,@__VOcodes,@__cur)"
   }


   DEF INPUT  PARAM cAcct AS CHAR NO-UNDO.
   DEF INPUT  PARAM iKodVO AS CHAR NO-UNDO.
   def INPUT  PARAM iCur as char NO-UNDO.

   DEF VAR cCountry AS CHAR NO-UNDO.
   DEF VAR i AS INT INIT 0 NO-UNDO.

   DEF OUTPUT PARAM out_Result AS Char NO-UNDO.
   DEF OUTPUT PARAM is-ok      AS INT     NO-UNDO.

   
   FIND FIRST acct WHERE acct.acct = cAcct NO-LOCK NO-ERROR.
   if available(acct) then 
	DO:
	   if acct.cust-cat = "�" then 
	     do:
	        find first person where person.person-id = acct.cust-id.
	        if available(person) then cCountry = person.country-id.
	     end.
	   if acct.cust-cat = "�" then 
	     do:
	        find first cust-corp where cust-corp.cust-id = acct.cust-id.
	        if available(cust-corp) then cCountry = cust-corp.country-id.
	     end.


    if cCountry = "RUS" then i = 1. else i = 2.	

    if acct.cust-cat = "�" then i = 0.    /*��� 䨧���� �� ���⠢����� ����� ��� VO, ⠪ �� ��� � ��� �㡫���� ���⥦�� १����⮢.*/
    if cCountry = "Rus" and (iCur = "" OR iCur = "810") then i = 0.
    if cCountry = "RUS" and acct.currency = "" then i = 0. /*��� १����⮢ ����樨 � �㡫���� ��⮢ �� �ॡ��� ��� VO*/
    if cCountry <> "RUS" and acct.currency = "" and acct.cust-cat <> "�" then i = 2. 
    if cCountry <> "RUS" and acct.currency <> "" and acct.cust-cat <> "�" then i = 3.
	END.
    if i = 3 and NUM-ENTRIES(iKodVO) < i then i = 2.	

    if i = 0 then     
        out_Result = "".  
    else
        out_Result = (ENTRY(i,iKodVO)).

  is-ok = 0.

END PROCEDURE.


{pfuncdef
   &NAME          = "����������Ꮾ��"
   &DESCRIPTION   = "������뢠�� �㬬� ����権 �� ����� ��"
   &PARAMETERS    = "��� 1,��� 2,�㬬� � ����� 1,�㬬� � ����� 2,��� ����樨"
   &RESULT        = "�㬬� � ����� 1, �㬬� � ����� 2 - �१ �������"
   &SAMPLE        = "@pm=����������Ꮾ��("40817840...1","40817978...2",100,?,01/01/2011);"
   }

DEF INPUT  PARAM v-db       AS CHAR NO-UNDO.
DEF INPUT  PARAM v-cr       AS CHAR NO-UNDO.
DEF INPUT  PARAM sum-db     AS DEC  NO-UNDO.
DEF INPUT  PARAM sum-cr     AS DEC  NO-UNDO.
DEF INPUT  PARAM currDate   AS DATE NO-UNDO.

DEF OUTPUT PARAM out_Result AS CHAR    NO-UNDO.
DEF OUTPUT PARAM is-ok      AS INTEGER NO-UNDO.

DEF VAR oKross1 AS TKross1 NO-UNDO.
DEF VAR oAArray AS TAArray NO-UNDO.

IF sum-db = 0 THEN sum-db = ?.
IF sum-cr = 0 THEN sum-cr = ?.

oKross1 = NEW TKross1(v-db,v-cr,sum-db,sum-cr).

oAArray = NEW TAArray().

oKross1:setDate(currDate):calcCrossByCb().
oAArray:push(STRING(oKross1:sum-db)).
oAArray:push(STRING(oKross1:sum-cr)).

out_Result = oAArray:toList().

DELETE OBJECT oAArray.
DELETE OBJECT oKross1.

is-ok = 0.
END PROCEDURE.

{pfuncdef
   &NAME          = "PirSplit"
   &DESCRIPTION   = "��������� ᯨ᮪ � ��६����"
   &PARAMETERS    = "��६����� 1, ��६����� 2, ��६����� 3"
   &RESULT        = ""
   &SAMPLE        = ""
   }
DEF INPUT PARAM var1 AS CHAR NO-UNDO.
DEF INPUT PARAM var2 AS CHAR NO-UNDO.
DEF INPUT PARAM var3 AS CHAR NO-UNDO.

END PROCEDURE.

{pfuncdef
   &NAME          = "�������㬬㏥८業��"
   &DESCRIPTION   = "������뢠�� �㬬� ��८業�� �� ����筮� ���থ��� ������"
   &PARAMETERS    = "���,���,�⠢�� �� ��������,�⠢�� �����,�����뢠�쐠���"
   &RESULT        = "�㬬� p+ ���� ���, �㬬� p+ ⥪�騩 ���,�㬬� p- ���� ���, �㬬� p- ⥪�騩 ���, - �१ �������"
   &SAMPLE        = "@pm=�������㬬㏥८業��(01/01/2012,"47426840500000000433",5.5,0.1,no);"
   }

DEF INPUT PARAMETER currDate AS DATE    NO-UNDO.
DEF INPUT PARAMETER cAcct    AS CHAR    NO-UNDO.
DEF INPUT PARAMETER rate     AS DECIMAL NO-UNDO.
DEF INPUT PARAMETER badRate  AS DECIMAL NO-UNDO.
DEF INPUT PARAMETER showLog  AS Logical NO-UNDO.

DEF OUTPUT PARAM out_Result AS CHAR    NO-UNDO.
DEF OUTPUT PARAM is-ok      AS INTEGER NO-UNDO.

  run pir-func-1636.p(currDate,cAcct,rate,badRate,showLog, OUTPUT out_Result).

  is-ok = 0.


END PROCEDURE.

{pfuncdef
   &NAME          = "First_Mon_Day"
   &DESCRIPTION   = "�����頥� ���� ���� �����"
   &PARAMETERS    = "���"
   &RESULT        = "���"
   &SAMPLE        = "@mDate=First_Mon_Day(@op-date);"
   }

DEF INPUT PARAMETER currDate AS DATE    NO-UNDO.


DEF OUTPUT PARAM out_Result AS DATE    NO-UNDO.
DEF OUTPUT PARAM is-ok      AS INTEGER NO-UNDO.

  out_Result = DATE(MONTH(currDate),01,YEAR(currDate)).

  is-ok = 0.


END PROCEDURE.

{pfuncdef
   &NAME          = "Last_Loan_op"
   &DESCRIPTION   = "�����頥� ���� ��᫥���� ����樨 �� ��������,�᫨ ��� - ��� ��砫� �������"
   &PARAMETERS    = "iContract,iCont-code,idOp,idate"
   &RESULT        = "���"
   &SAMPLE        = "@mDate=Last_Loan_op(@iContract,@iCont-code,@idOp,@iDate);"
   }

DEF INPUT PARAMETER iContract AS CHAR    NO-UNDO.
DEF INPUT PARAMETER iCont-code AS CHAR    NO-UNDO.
DEF INPUT PARAMETER idOp AS INT    NO-UNDO.
DEF INPUT PARAMETER iDate AS DATE    NO-UNDO.



DEF OUTPUT PARAM out_Result AS DATE    NO-UNDO.
DEF OUTPUT PARAM is-ok      AS INTEGER NO-UNDO.

  find first loan where loan.contract = iContract and loan.cont-code = iCont-code NO-LOCK NO-ERROR.

  if not available loan then MESSAGE "�� ������ ������� " iContract iCont-code VIEW-AS ALERT-BOX.
  out_Result = loan.open-date.

  find first chowhe where chowhe.id-op = idOp NO-LOCK NO-ERROR.

  if available chowhe then 
	do:
	   find last loan-int where loan-int.cont-code = iCont-code  
				and loan-int.contract = iContract
				and loan-int.id-k = chowhe.id-k
				and loan-int.id-d = chowhe.id-d
				and loan-int.mdate <= iDate
				NO-LOCK NO-ERROR.
	   if available loan-int then out_Result = loan-int.mdate.
	end.

  is-ok = 0.

END PROCEDURE.

{pfuncdef
   &NAME          = "First_Sf_of_loan"
   &DESCRIPTION   = "�����頥� ����� � ��ࢮ� �� � ��������"
   &PARAMETERS    = "@op,@Op-date,@contract,@cont-code,@isince"
   &RESULT        = "@doc-num,@open-date,@OpPay,@isince"
   &SAMPLE        = "@mcont-code=First_Sf_of_loan(@op,@Op-date,@contract,@cont-code,@isince);"
   }

DEF INPUT PARAMETER iOp AS int    NO-UNDO.
DEF INPUT PARAMETER iOp-date AS Date    NO-UNDO.
DEF INPUT PARAMETER icontract  AS char    NO-UNDO.
DEF INPUT PARAMETER icont-code AS char    NO-UNDO.
DEF INPUT PARAMETER isince AS date    NO-UNDO.
DEF OUTPUT PARAM out_Result AS CHAR    NO-UNDO.
DEF OUTPUT PARAM is-ok      AS INTEGER NO-UNDO.

def buffer bop-entry for op-entry.


  find first loan where loan.contract = "sf-out"
                    and loan.parent-contract = iContract 
		    and loan.parent-cont-code = iCont-code
		    and loan.l-int-date = iSince
                    NO-LOCK NO-ERROR.
  if available loan then out_Result = loan.cont-code.
  else do:

  find first op where op.op = iOp and op.op-date = iOp-Date NO-LOCK NO-ERROR.
  if not available op then message "�� ������ ���㬥��:" iOp VIEW-AS ALERT-BOX.
  find first op-entry where op-entry.op = op.op no-lock no-error.
  
  find last bop-entry where bop-entry.acct-cr = op-entry.acct-db NO-LOCK NO-ERROR. 	


  find first links where links.target-id = STRING(bop-entry.op) + "," + STRING(bop-entry.op-entry)
		     and links.link-id = 27 NO-LOCK NO-ERROR.

  out_Result = ENTRY(2,links.source-id).
  end.

  is-ok = 0.


END PROCEDURE.


{pfuncdef
   &NAME          = "�뫮������襭����"
   &DESCRIPTION   = "�뫮 �� ����襭�� �� ��ࠧ�襭���� �������� � ���� ��᫥����� ��室� �� ��� PirFirstZeroExit"
   &PARAMETERS    = "�������,���"
   &RESULT        = "yes-no"
   &SAMPLE        = "@pm=�뫮������襭����("��-B/EUR/11-002",����());"
   }

DEF INPUT PARAMETER iLoan    AS CHAR    NO-UNDO.
DEF INPUT PARAMETER iDateBeg AS DATE    NO-UNDO.

DEF OUTPUT PARAM out_Result  AS CHAR    NO-UNDO.
DEF OUTPUT PARAM is-ok       AS INTEGER NO-UNDO.

DEF VAR LnAcctKred 	AS CHAR NO-UNDO.
DEF VAR LnAcctRasch     AS CHAR NO-UNDO.
DEF VAR fl	 	AS CHAR INIT "no" NO-UNDO.

  LnAcctKred  = GetLoanAcct_ULL('�।��', iLoan, '�।��'  , iDateBeg, false) .
  LnAcctRasch = GetLoanAcct_ULL('�।��', iLoan, '�।����', iDateBeg, false) .

  FOR EACH op-entry 
	WHERE 
	( op-entry.acct-db EQ  LnAcctRasch 
	  AND op-entry.acct-cr EQ  LnAcctKred
	  AND op-entry.op-date >= iDateBeg
	  AND op-entry.op-date <= TODAY
	)
	OR
	( op-entry.acct-db EQ  LnAcctRasch 
	  AND op-entry.acct-cr BEGINS "70601"
	  AND op-entry.op-date >= iDateBeg
	  AND op-entry.op-date <= TODAY
	)
  NO-LOCK,
  FIRST op OF op-entry 
  NO-LOCK:
	IF op.op-kind = "pirpco76" THEN
		fl = "yes".  /* ⨯� ����襭�� 㦥 �뫮 */
  END.

   out_Result = fl .
   is-ok = 0.

END PROCEDURE.


{pfuncdef
   &NAME          = "getPosNumById"
   &DESCRIPTION   = "���४���� �訡�� � ���������� ����䥫�� ���"
   &PARAMETERS    = "�������� ����䥫�,����� ����䥫�"
   &RESULT        = "����䥫�"
   &SAMPLE        = "@pm=getPosNumById("������",3);"
   }

DEF INPUT PARAMETER cName AS CHAR    NO-UNDO.
DEF INPUT PARAMETER iNum  AS INT    NO-UNDO.

DEF OUTPUT PARAM out_Result  AS CHAR    NO-UNDO.
DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.

out_Result = DYNAMIC-FUNCTION("getPosNumById" IN h_pkid,cName,iNum).

is-ok = 0.
END PROCEDURE.

{pfuncdef
   &NAME          = "GetBankName"
   &DESCRIPTION   = "������������ ����� �� ��, � ����ᨬ��� �� ������쭮� ���� � ⨯�"
   &PARAMETERS    = "���"
   &RESULT        = "��� ��� ����"
   &SAMPLE        = "@bankname=GetBankName(1);"
   }

DEF INPUT PARAMETER iType AS INT NO-UNDO.

DEF OUTPUT PARAM out_Result  AS CHAR    NO-UNDO.
DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.

{get-bankname.i}

if iType = 1 then out_Result = cBankName.
else
if iType = 2 then out_Result = cBankNameFull.
else 
out_Result = cBankName.

is-ok = 0.

END PROCEDURE.



{pfuncdef
   &NAME          = "�������㬬ㄮ�����₪����"
   &DESCRIPTION   = "������뢠�� �㬬� �� ����筮� ���থ��� ������"
   &PARAMETERS    = "�����������,��⠐���থ���,�⠢��������ॡ������,��⠑���,�������쐠���"
   &RESULT        = "�㬂믫��悥��,�㬂믫��撥�,�㬂믫�����,�㬂믫�������,�㬍���悥��,�㬍���撥�,�㬍������,�㬍���揮�����,�㬍������悥��,�㬍������撥�,�㬍���������,�㬍������揮�����,�㬄��������� - �१ �������"
   &SAMPLE        = "@pm=�������㬬ㄮ�����₪����('42305810700000001702',12/10/2012,0.01,YES,YES);"
   }

DEF INPUT PARAMETER iLoanNum   AS CHAR  NO-UNDO.
DEF INPUT PARAMETER iRaspDate  AS DATE  NO-UNDO.
DEF INPUT PARAMETER iRatePen   AS DEC   NO-UNDO.
DEF INPUT PARAMETER iSPODDate  AS DATE  NO-UNDO.
DEF INPUT PARAMETER ShowTabl   AS LOGICAL NO-UNDO.
DEF INPUT PARAMETER ShowRasp   AS LOGICAL NO-UNDO.

DEF OUTPUT PARAM out_Result  AS CHAR    NO-UNDO.
DEF OUTPUT PARAM is-ok       AS INTEGER NO-UNDO.

DEFINE BUFFER loan FOR loan .


   FIND FIRST loan WHERE loan.cont-code = iLoanNum AND loan.contract = "dps" NO-LOCK NO-ERROR.

   IF AVAIL(loan) THEN
   DO:
	IF loan.currency = "" THEN
	  RUN pir-drast-trans.p( iLoanNum, iRaspDate, iRatePen, iSPODDate, ShowTabl , ShowRasp , OUTPUT out_Result )  NO-ERROR.	   
	ELSE
	  RUN pir-drast-trans-v.p( iLoanNum, iRaspDate, iRatePen, iSPODDate, ShowTabl , ShowRasp , OUTPUT out_Result )  NO-ERROR.
   END.

  is-ok = 0.

END PROCEDURE.


	/* �� �६����� �����窠 */
{pfuncdef
   &NAME          = "����������"
   &DESCRIPTION   = "�뢮��� �㬬� ���᫥���� ��業⮢. �᫨ 㪠�뢠���� �⠢��, � ��業�� ������뢠���� �� �⮩ �⠢��  "
   &PARAMETERS    = "�����,��砫���ਮ�����᫥���,����揥ਮ�����᫥���,�⠢��"
   &RESULT        = "�㬬�"
   &SAMPLE        = "@pm=����������("42305810100000001687",����(),����(),0.01);"
   }

DEF INPUT PARAMETER iLoan    AS CHAR    NO-UNDO.
DEF INPUT PARAMETER iDateBeg AS DATE    NO-UNDO. 
DEF INPUT PARAMETER iDateEnd AS DATE    NO-UNDO.
DEF INPUT PARAMETER iRate    AS DEC     NO-UNDO.

DEF OUTPUT PARAM out_Result  AS DEC    NO-UNDO.
DEF OUTPUT PARAM is-ok       AS INTEGER NO-UNDO.

DEF VAR Sum     	AS DEC INIT 0 NO-UNDO.
DEF VAR LoanSumBeg	AS DEC INIT 0 NO-UNDO.
DEF VAR LoanSumEnd	AS DEC INIT 0 NO-UNDO.
DEF VAR LoanSumPodPer	AS DEC INIT 0 NO-UNDO.
DEF VAR Period  	AS INT INIT 1 NO-UNDO.
DEF VAR BaseNach  	AS INT NO-UNDO. 
DEF VAR d		AS INT NO-UNDO. 

      Sum = 0.
      FIND FIRST loan WHERE loan.contract  EQ "dps" AND   loan.cont-code EQ iLoan NO-LOCK NO-ERROR.

      IF MONTH(today) = MONTH(loan.open-date) AND  YEAR(today) = YEAR(loan.open-date) 
      THEN
	iDateBeg = loan.open-date + 1.

      FIND FIRST loan-acct WHERE loan-acct.contract  EQ "dps" AND   loan-acct.cont-code EQ iLoan AND loan-acct.acct-type EQ "loan-dps-int" NO-LOCK NO-ERROR.

      IF AVAIL(loan-acct) THEN
      DO:

        FOR EACH  kau-entry
          WHERE kau-entry.acct   EQ loan-acct.acct
          AND kau-entry.currency EQ loan-acct.currency
          AND kau-entry.op-status NE '�'
          AND kau-entry.kau  BEGINS "dps" + ',' + iLoan + ',����'
	  AND kau-entry.op-date >= iDateBeg 
	  AND kau-entry.op-date <= iDateEnd 
	  AND kau-entry.op-code = "000000"
	NO-LOCK,
	FIRST op OF kau-entry WHERE op.op-date <= iDateEnd
	NO-LOCK,
	FIRST op-entry OF op 
	  WHERE op-entry.acct-db BEGINS "70606" AND   op-entry.acct-cr = loan-acct.acct
        NO-LOCK: 

          IF AVAIL(kau-entry) THEN
	   DO:
	    IF iRate = ?  THEN
	    DO:
		Sum = Sum + ( IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur ) .
	    END.
	    ELSE /* ������뢠�� �� �⠢�� iRate */ 
	    DO:
		LoanSumBeg = ABS(GetAcctPosValueEx_UAL(iLoan, loan.currency, iDateBeg, CHR(251), false)).
  		LoanSumEnd = ABS(GetAcctPosValueEx_UAL(iLoan, loan.currency, iDateEnd, CHR(251), false)).
 	        BaseNach = (DATE('31/12/' + STRING(YEAR(op.contract-date))) - DATE('01/01/' + STRING(YEAR(op.contract-date))) + 1).			
		  /* �᫨ �뫮 ��������� ���⪠, ⮣�� ���� ������� */
		IF LoanSumBeg <> LoanSumEnd THEN
		DO:
		  Period = op.contract-date - iDateBeg + 1 .
    		  BaseNach = (DATE('31/12/' + STRING(YEAR(op.contract-date))) - DATE('01/01/' + STRING(YEAR(op.contract-date))) + 1).			
		  DO d = 0 TO Period :
		    LoanSumPodPer = ABS(GetAcctPosValueEx_UAL(iLoan, loan.currency, iDateBeg + d, CHR(251), false)).
		    Sum = Sum + LoanSumPodPer * 1 * iRate / BaseNach .
		    d = d + 1 .			    
		  END.
		END.
		ELSE
		 DO:
		  Period = op.contract-date - iDateBeg + 1 .
/*  		message LoanSumBeg Period iRate BaseNach ROUND( LoanSumBeg * Period * iRate / BaseNach , 2) VIEW-AS ALERT-BOX.*/
		  Sum = Sum + ROUND( LoanSumBeg * Period * iRate / (BaseNach * 100), 2).
		 END.
	    END. /* end IF iRate <> ?  */

	   END. /* end IF AVAIL(kau-entry)*/
        END. /* end FOR each */

      END. /* end_IF AVAIL(loan-acct) */
/*   message sum view-as alert-box.    */
   out_Result = Sum .
   is-ok = 0.

END PROCEDURE.


	/* �� �६����� �����窠 */
{pfuncdef
   &NAME          = "������⠢��"
   &DESCRIPTION   = "�����뢠�� ��業��� �⠢�� �� ����"
   &PARAMETERS    = "�����,���,����⠢��"
   &RESULT        = "�㬬�"
   &SAMPLE        = "@pm=������⠢��("42305810100000001687",����(),"����");"
   }

DEF INPUT PARAMETER iLoan    AS CHAR    NO-UNDO.
DEF INPUT PARAMETER iDateEnd AS DATE    NO-UNDO.
DEF INPUT PARAMETER iType    AS CHAR    NO-UNDO.

DEF OUTPUT PARAM out_Result  AS DEC    NO-UNDO.
DEF OUTPUT PARAM is-ok       AS INTEGER NO-UNDO.

DEF VAR LnRate		AS DEC  INIT 0 NO-UNDO.
DEF VAR LnRateType	AS CHAR NO-UNDO.

   IF iType = "����" THEN
	LnRateType = 'pen-commi'  .
   ELSE
	LnRateType = 'commission' .

   FIND FIRST loan WHERE loan.cont-code = iLoan AND loan.contract = "dps" NO-LOCK NO-ERROR.

   IF AVAIL(loan) THEN
	LnRate = GetDpsCommission_ULL(loan.cont-code, LnRateType, iDateEnd, false) * 100.

   out_Result = LnRate .
   is-ok = 0.

END PROCEDURE.




/***********************************
 * �㭪�� �����頥� TRUE
 * ��� ���� ����� � ������
 * ���� ���� ������������� �஬� 
 * ��ࠧ�襭���� �������.
 ***********************************
 * ���� : ��᫮� �. �. Maslov D. A.
 * ���: #2577
 * ���  : 26.03.13
 ***********************************/

{pfuncdef
   &NAME          = "�������������썎"
   &DESCRIPTION   = "�����頥� TRUE, �᫨ � 䨧. ��� ���� ��㣠� ������������, �஬� ��।����� � ��ࠬ���."
   &PARAMETERS    = "PK ⥪�饩 ������������,��� ����. ���"
   &RESULT        = "TRUE ��� FALSE"
   &SAMPLE        = "@pm=��������������("��-C/RUR/05-035",12/10/2012);"
   }

 DEF INPUT PARAM iLoanNum   AS CHAR  NO-UNDO.
 DEF INPUT PARAM currDate   AS DATE  NO-UNDO.

 DEF OUTPUT PARAM out_Result AS LOG  NO-UNDO.
 DEF OUTPUT PARAM is-ok      AS INT  NO-UNDO.

 DEF BUFFER currLoan   FOR loan.
 DEF BUFFER otherLoan  FOR loan.

 DEF VAR findClasses AS CHAR NO-UNDO.

  findClasses = FGetSetting("PirActualKK","PirOtherLoans","loan_allocat,loan-transh,l_agr_with_diff").


  FIND FIRST currLoan WHERE currLoan.cont-code EQ iLoanNum NO-LOCK NO-ERROR.
  

  /*************************
   * ����襬� ��ࠧ�襭�� ������ 
   * ���� �뤥���� � �⤥��� �����
   *************************/
         FIND FIRST otherLoan WHERE otherLoan.cust-cat  =  currLoan.cust-cat  AND otherLoan.cust-id = currLoan.cust-id 
                                AND otherLoan.cont-code <> currLoan.cont-code AND NOT otherLoan.cont-code BEGINS "��"
                                AND otherLoan.open-date <= currDate AND (otherLoan.close-date > currDate OR otherLoan.close-date = ?)
                                AND CAN-DO(findClasses,otherLoan.class-code) NO-LOCK NO-ERROR.

           IF AVAILABLE(otherLoan) THEN DO:
              out_Result = TRUE.
           END. ELSE DO:
              out_Result = FALSE.
           END.
 is-ok = 0.
END PROCEDURE.

{pfuncdef
   &NAME          = "NeedCorrectSf"
   &DESCRIPTION   = "����室��� �� ��ᮧ������ ���-䠪���� � ஫�� sf-in"
   &PARAMETERS    = "Op,op-date"
   &RESULT        = "cont-code"
   &SAMPLE        = "@fist-sf-cont-code=(@op,@op-date);"
   }

DEF INPUT PARAMETER iOp AS INT NO-UNDO.
DEF INPUT PARAMETER iOp-date AS DATE NO-UNDO.

DEF VAR bFindIn AS LOGICAL INIT FALSE NO-UNDO.
DEF VAR bFindOut AS LOGICAL INIT FALSE NO-UNDO.
DEF VAR TempChar AS CHAR NO-UNDO.
DEF VAR parentSF AS CHAR NO-UNDO.
DEF BUFFER bLoan FOR loan.
DEF BUFFER bop-entry FOR op-entry.

DEF OUTPUT PARAM out_Result  AS CHAR    NO-UNDO.
DEF OUTPUT PARAM is-ok       AS INT     NO-UNDO.

   out_Result = "".

   FOR EACH op-entry WHERE op-entry.op      = iOp
                       AND op-entry.op-date = iOp-date 
	               AND op-entry.acct-db begins "61304"
	               AND op-entry.acct-cr begins "70601"
                           NO-LOCK,
       FIRST op WHERE op.op = op-entry.op NO-LOCK.

	     FOR EACH links WHERE (links.end-date = ? OR links.end-date <= ?)
			      AND links.link-id EQ 27 
			      AND links.target-id = STRING(op-entry.op) + "," + STRING(op-entry.op-entry) 
  	 	 	 	  NO-LOCK:

  	 	 	      IF links.source-id BEGINS "sf-out" THEN 
				DO:	
				   bFindOut = true.
                                   parentSF = links.source-id.
				END.
  	 	 	      IF links.source-id BEGINS "sf-in" THEN bFindIn = true.

	     END.

             IF bFindOut AND NOT bFindIn THEN                             	
                DO:
                   TempChar = GetXattrValueEx("op",STRING(op.op),"PIRSFInfo",?).
                   IF TempChar <> ? THEN 
                    DO:
                      TempChar = ENTRY(3,TempChar).

                      FIND FIRST bloan WHERE bloan.contract =  ENTRY(1,TempChar,".")
					 AND bloan.cont-code = ENTRY(2,TempChar,".")
					 NO-LOCK NO-ERROR.

		      IF available (bloan) THEN DO:
                                               find last loan-cond where loan-cond.contract = bloan.contract 
								      and loan-cond.cont-code EQ bloan.cont-code
					                              and loan-cond.since <= op.op-date
                                                                      NO-LOCK NO-ERROR.
                                               END.

                     IF AVAILABLE (bloan) AND  AVAILABLE (loan-cond) THEN
				        FIND FIRST loan WHERE loan.contract = "sf-out"
                                        AND loan.parent-contract = bloan.contract
                       	   	        AND loan.parent-cont-code = bloan.cont-code
    	   	                        AND loan.l-int-date = loan-cond.since
                                        NO-LOCK NO-ERROR.

                     IF AVAILABLE loan THEN out_Result = loan.cont-code  + "," + parentSF. /*��諨 ����� ���-䠪����*/
                     else
                     do:                                          
                      FIND LAST bop-entry WHERE bop-entry.acct-cr = op-entry.acct-db and bop-entry.op-date <= op-entry.op-date NO-LOCK NO-ERROR. 	

                      FIND FIRST links WHERE links.target-id = STRING(bop-entry.op) + "," + STRING(bop-entry.op-entry)
	   	             AND links.link-id = 27 
		             AND links.source-id BEGINS "sf-out"
		             NO-LOCK NO-ERROR.
		         IF NOT AVAILABLE links THEN message "������" SKIP "������� screenshot � �������������" SKIP bop-entry.op bop-entry.op-entry op-entry.acct-db op-entry.acct-cr op-entry.op VIEW-AS ALERT-BOX.
                         out_Result = ENTRY(2,links.source-id) + "," + parentSF.
		     END.
		   END.
		END.


   END.

is-ok = 0.

END PROCEDURE.

{pfuncdef
   &NAME          = "PirTarifComm"
   &DESCRIPTION   = "�����頥� ࠧ��� �����ᨨ � ����ᨬ��� �� ��⠭��������� ��䭮�� �����"
   &PARAMETERS    = "���,�㬬� ����樨,���,�����"
   &RESULT        = "DEC"
   &SAMPLE        = "@Com = PirTarifComm(cAcct,dSumm,dDate,cCur)"
   }

				/*********************************************
				 * �㭪�� �����頥� ࠧ��� ������ �� ����*
                                 * ������                                   *
				 * �� ��䭮�� �����                        *				 
				 *    1. cAcct - ����� ��� ������;        *
				 *    2. dSumm - ��� �࠭���樨;             *
				 *    3. dDate - ��� ���भ�;	 	     *
				 *    4. cCur  - �����                      *
				 * ����: ��᪮� �.�.                       *
				 * ��� ᮧ�����: 01.04.13                   *
				 * ���: #                                 *
				 *********************************************/

    DEF INPUT PARAMETER cAcct   AS CHAR NO-UNDO.
    DEF INPUT PARAMETER dSumm   AS DEC NO-UNDO.
    DEF INPUT PARAMETER dDate   AS DATE NO-UNDO.
    DEF INPUT PARAMETER cCur    AS CHAR NO-UNDO.

    DEF OUTPUT PARAM out_Result AS DEC  NO-UNDO.
    DEF OUTPUT PARAM is-ok      AS INT  NO-UNDO.

    Def var outComm As dec no-UNDO.
    def var oTarif as TTarif NO-UNDO.

    DEF VAR str AS CHAR NO-UNDO. 

    oTarif = new TTarif(cAcct,dDate).

    str = GetCallOpkind(1,"OPKIND") + "," + GetCallOpkind(1,"TMPLID"). 
   
    outComm = oTarif:GetCommission(str,dSumm,cCur,dDate).

    out_Result = outComm.
                                
    is-ok = 0.

END PROCEDURE.


/**
 * ��楤�� �����頥� ���ଠ�� �� �������.
 * �᫨ ��।�� ���� ��ࠬ���, � ID ������ 
 * ���� �� tmp-person-id ��� g_buysel.
 * �᫨ 㪠���� 2 ��ࠬ���, � ��ன ��⠥���
 * ID ������.
 * @var INT ipType 
 * @var INT personId
 * @return CHAR
 **
 * ����: ��᫮� �. �. Maslov D. A.
 * ��� ᮧ�����: 17.01.13
 * ���: #2149
 ***************/

{pfuncdef
   &NAME          = "GetCustInfoGBuySel"
   &DESCRIPTION   = "��楤�� �����頥� ���ଠ�� �� �������."
   &PARAMETERS    = "��� ���ଠ樨, [ID ������]"
   &RESULT        = "DEC"
   &SAMPLE        = "GetCustInfoGBuySel(6,1234)"
   }
 DEF INPUT PARAM ipType   AS INT64        NO-UNDO.
 DEF INPUT PARAM personId AS INT64 INIT ? NO-UNDO.

 DEF OUTPUT PARAM out_Result AS CHAR NO-UNDO.
 DEF OUTPUT PARAM is-ok      AS INT  NO-UNDO. 		/* �ᯥ譮 �� �믮����� ? */
 

  IF ipType > 0 THEN DO:
      RUN GetCustInfoBlock IN h_cust ("�",(IF personId = ? THEN INT64(GetSysConf("tmp-person-id")) ELSE personId),OUTPUT out_Result) .

      IF NUM-ENTRIES(out_Result, CHR(1)) < ipType
      THEN out_Result = "".
      ELSE out_Result = ENTRY(ipType, out_Result, CHR(1)).
   END.
   ELSE out_Result = "".


 is-ok = 0.
END PROCEDURE.




{pfuncdef
   &NAME          = "PirGetCodeVOall"
   &DESCRIPTION   = "�����頥� ��� VO. ����� ���������. �।����������, �� � ���� ����������� �஢�ન, � ᠬ� ����ୠ� �㭪�� �㤥� ��⠢������ �� �� �࠭���樨"
   &PARAMETERS    = "��℁, ��⊐, ���, ��-����썠���饥"
   &RESULT        = "CHAR"
   &SAMPLE        = "PirGetCodeVOall(@��℁,@��⊐,@���, '��-����썠���饥' )"
   }
 DEF INPUT PARAM vAcctDb	AS CHAR NO-UNDO.
 DEF INPUT PARAM vAcctCr	AS CHAR NO-UNDO.
 DEF INPUT PARAM vVal		AS CHAR NO-UNDO.
 DEF INPUT PARAM vSomething	AS CHAR NO-UNDO.

 DEF OUTPUT PARAM out_Result AS CHAR NO-UNDO.
 DEF OUTPUT PARAM is-ok      AS INT  NO-UNDO. 		/* �ᯥ譮 �� �믮����� ? */

   DEF VAR oVOCode	AS CHAR INIT "" NO-UNDO.

/**** #4102*/
   RUN pir-u102-codevo.p( vAcctDb , vAcctCr , vVal , vSomething , OUTPUT oVOCode ) .  
/*****/

   IF oVOCode = "" THEN oVOCode = " ".

 out_Result = oVOCode .
 is-ok = 0.
END PROCEDURE.


{pfuncdef
   &NAME          = "PirGetCardCCode"
   &DESCRIPTION   = "�����頥� cont-code � ����⨪���� ����� �� ������஢������ ����� (⮫쪮  ��� ���� ��� �����)"
   &PARAMETERS    = "������,����������"
   &RESULT        = "CHAR"
   &SAMPLE        = "PirGetCardCCode(@������,@����������)"
   }

 DEF INPUT PARAM  vEmbName	AS CHAR NO-UNDO.
 DEF INPUT PARAM  vCardNum	AS CHAR NO-UNDO.
 DEF OUTPUT PARAM out_Result	AS CHAR NO-UNDO.
 DEF OUTPUT PARAM is-ok		AS INT  NO-UNDO. 		/* �ᯥ譮 �� �믮����� ? */

 DEFINE BUFFER card FOR loan.

 FIND FIRST card  WHERE  card.class-code = "card"  AND  card.doc-num = ""  AND    card.user-o[2]  = vEmbName NO-LOCK NO-ERROR.
 IF AVAIL(card ) THEN
   out_Result = card.cont-code .
 ELSE
 DO:
   FIND FIRST card  WHERE  card.class-code = "card"  AND  card.doc-num = vCardNum  AND    card.user-o[2]  = vEmbName NO-LOCK NO-ERROR.
   IF AVAIL(card ) THEN
     out_Result = "bis" .
   ELSE
     out_Result = " ".
 END.
 is-ok = 0.
END PROCEDURE.


{pfuncdef
   &NAME          = "PirLoanPlanDate"
   &DESCRIPTION   = "�����頥�  �������� ���� ���⥦� �� ��業⠬"
   &PARAMETERS    = "���, ����� �������"
   &RESULT        = "Date"
   &SAMPLE        = "PirLoanPlanMonth(����(),'01/13')"
   }
 DEF INPUT PARAM iDate	        AS DATE NO-UNDO.
 DEF INPUT PARAM vCont-code	AS CHAR NO-UNDO.
 
 DEF OUTPUT PARAM out_Result AS DATE NO-UNDO.
 DEF OUTPUT PARAM is-ok      AS INT  NO-UNDO. 		/* �ᯥ譮 �� �믮����� ? */

  find first term-obl where term-obl.contract = "�।��"
                   and term-obl.cont-code = vCont-code
                   and term-obl.end-date >= iDate
                   and term-obl.idnt = 1 NO-LOCK NO-ERROR.

   out_Result = iDate.

  if not AVAILABLE term-obl then MESSAGE "�� ������� �������� ��� ����襭�� ��業⮢" VIEW-AS ALERT-BOX.
  else
  DO:
     out_result = term-obl.end-date.
  END.



 is-ok = 0.
END PROCEDURE.

{pfuncdef
   &NAME          = "PirPeriodProc"
   &DESCRIPTION   = "�����頥� ��ਮ�� ������ ��業⮢ �� �������� � ����ᨬ��� �� �������� ����"
   &PARAMETERS    = "�������� ���, ����� �������"
   &RESULT        = "CHAR"
   &SAMPLE        = "PirPeriodProc(����(),'01/13')"
   }
 DEF INPUT PARAM iDate	        AS DATE NO-UNDO.
 DEF INPUT PARAM vCont-code	AS CHAR NO-UNDO.
 
 DEF OUTPUT PARAM out_Result AS CHAR NO-UNDO.
 DEF OUTPUT PARAM is-ok      AS INT  NO-UNDO. 		/* �ᯥ譮 �� �믮����� ? */

 DEF VAR iPeriodStart AS DATE NO-UNDO.
 DEF VAR iPeriodEnd AS DATE NO-UNDO.
 DEF VAR iPeriodMidle AS DATE NO-UNDO.

  find first loan where loan.contract = "�।��"
                    and loan.cont-code = vCont-code
                    NO-LOCK NO-ERROR.
   
  if not AVAILABLE loan then MESSAGE "�� ������ ������� " loan.cont-code VIEW-AS ALERT-BOX.
  
  iPeriodStart = loan.open-date.
  iPeriodEnd = iDate.


  find last loan-int where loan-int.contract = "�।��"                      /*�饬 ��᫥���� ������ ��業⮢ �� ��������*/
                       and loan-int.cont-code = vCont-code
                       and loan-int.id-d = 6
                       and loan-int.id-k = 4
                       and loan-int.mdate <= iDate
                       NO-LOCK NO-ERROR.
  

  if available(loan-int) then iPeriodStart = loan-int.mdate + 1.
  
  iPeriodMidle = MIN(LastMonDate(iPeriodStart),LastMonDate(iPeriodEnd)). 

  IF MONTH(iPeriodStart) <> MONTH(iPeriodEnd) THEN 
  out_Result = "� " + STRING(iPeriodStart) + " �� " + STRING(iPeriodMidle) + ",c " +  STRING(iPeriodMidle + 1) + " �� " + STRING(iPeriodEnd).
  ELSE 
  out_Result = "� " + STRING(iPeriodStart) + " �� " + STRING(iPeriodEnd) + ",c " +  STRING(iPeriodStart) + " �� " + STRING(iPeriodEnd).


 is-ok = 0.
END PROCEDURE.

/* #4106 �����㥬 op-impexp � msg-impexp � ����㯨�襣� �� �� �஢���� �/� �஥�� */
{pfuncdef
   &NAME          = "PirCopyOP-IMPEXP"
   &DESCRIPTION   = "������� ���祭�� �� ��ப� � op-impexp �� ��ண� op � ����"
   &PARAMETERS    = "��ப� �� op-impexp, �㦭� op"
   &RESULT        = "LOGICAL"
   &SAMPLE        = "PirPeriodProc(����(),'01/13')"
   }

 DEF INPUT PARAM iOpOld		AS INT  NO-UNDO.
 DEF INPUT PARAM iOpNew		AS INT  NO-UNDO.
 DEF OUTPUT PARAM out_Result 	AS LOGICAL NO-UNDO.
 DEF OUTPUT PARAM is-ok      	AS INT  NO-UNDO. 		/* �ᯥ譮 �� �믮����� ? */

 DEF BUFFER Top-impexp FOR op-impexp.
 DEF BUFFER Tmsg-impexp FOR msg-impexp.

 find first op-impexp where op-impexp.op = int(iOpOld) no-lock no-error.
 if not available op-impexp then do:
	message "�� ������� ᮮ⢥������� �஢����!" view-as alert-box.
	out_Result = NO.
	end.
 else do:
	CREATE Top-impexp.
	BUFFER-COPY op-impexp EXCEPT op-impexp.op TO Top-impexp.
	Top-impexp.op = iOpNew.
	FOR each msg-impexp WHERE msg-impexp.msg-cat EQ 'op' AND msg-impexp.object-id = STRING(iOpOld):
		CREATE Tmsg-impexp.
		BUFFER-COPY msg-impexp EXCEPT msg-impexp.object-id TO Tmsg-impexp.
		Tmsg-impexp.object-id = STRING(iOpNew).
	END.

   is-ok = 0.
   out_Result = YES.

 end.

END PROCEDURE.

{pfuncdef
   &NAME          = "PirClearingInitF"
   &DESCRIPTION   = "�����頥� ����� �� ���ਭ�� �� init0198.*"
   &PARAMETERS    = "filename"
   &RESULT        = "CHAR"
   &SAMPLE        = "PirClearingInitF(INITF.ucs)"
   }
 DEF INPUT PARAM filename        AS CHAR NO-UNDO.
 DEF OUTPUT PARAM out_Result AS CHAR NO-UNDO.
 DEF OUTPUT PARAM is-ok      AS INT  NO-UNDO. 		/* �ᯥ譮 �� �믮����� ? */

	if search("pir-clearinginitf.r") <> ? then
		run value ("pir-clearinginitf.r")(filename, output out_Result).
	else
		if search("pir-clearinginitf.p") <> ? then run value("pir-clearinginitf.p")(filename, output out_Result).
		else message "��楤��  pir-clearinginitf �� �������!" view-as alert-box.
   is-ok = 0.
END PROCEDURE.

{pfuncdef
   &NAME          = "PirLinkLoan"
   &DESCRIPTION   = "�����⢫�� �ਢ離� ��� 9999*"
   &PARAMETERS    = "iNum,iDate"
   &RESULT        = "CHAR"
   &SAMPLE        = "PirLinkLoan("I/RUR/13-010","17/12/2013")"
   }
 DEF INPUT PARAM iNum        AS CHAR NO-UNDO.
 DEF INPUT PARAM iDate        AS CHAR NO-UNDO.
 DEF OUTPUT PARAM out_Result AS CHAR NO-UNDO.
 DEF OUTPUT PARAM is-ok      AS INT  NO-UNDO. 		/* �ᯥ譮 �� �믮����� ? */

	if search("pir-linkloan.r") <> ? then
		run value ("pir-linkloan.r")(iNum, iDate, output out_Result).
	else
		if search("pir-linkloan.p") <> ? then run value("pir-linkloan.p")(iNum, iDate, output out_Result).
		else message "��楤��  pir-linkloan �� �������!" view-as alert-box.
   is-ok = 0.
END PROCEDURE.

{pfuncdef
   &NAME          = "PirUnLinkLoan"
   &DESCRIPTION   = "�����⢫�� ��離� ��� 9999*"
   &PARAMETERS    = "iNum"
   &RESULT        = "CHAR"
   &SAMPLE        = "PirUnLinkLoan("I/RUR/13-010")"
   }
 DEF INPUT PARAM iNum        AS CHAR NO-UNDO.
 DEF OUTPUT PARAM out_Result AS CHAR NO-UNDO.
 DEF OUTPUT PARAM is-ok      AS INT  NO-UNDO. 		/* �ᯥ譮 �� �믮����� ? */

	if search("pir-unlinkloan.r") <> ? then
		run value ("pir-unlinkloan.r")(iNum, output out_Result).
	else
		if search("pir-unlinkloan.p") <> ? then run value("pir-unlinkloan.p")(iNum, output out_Result).
		else message "��楤��  pir-unlinkloan �� �������!" view-as alert-box.
   is-ok = 0.
END PROCEDURE.

{pfuncdef
   &NAME          = "PirGetCounter"
   &DESCRIPTION   = "��ᢠ����� ��।��� ����� �� ���稪�"
   &PARAMETERS    = "CHAR"
   &RESULT        = "INT64"
   &SAMPLE        = "PirGetCounter("AllBankDoc")"
   }

 DEF INPUT PARAM iCount      AS CHAR NO-UNDO. 
 DEF OUTPUT PARAM iCurrOut   AS INT64 NO-UNDO.
 DEF OUTPUT PARAM is-ok      AS INT  NO-UNDO. 		/* �ᯥ譮 �� �믮����� ? */

	iCurrOut = GetCounterCurrentValue("AllBankDoc",TODAY). 	/* ����稫� ⥪�騩 ����� ���稪� */

	IF iCurrOut EQ ? THEN DO:
		MESSAGE "�� ����饭 �ࢥ� ��⮭㬥�樨!\n" VIEW-AS ALERT-BOX.
	END.
	SetCounterValue("AllBankDoc",?,TODAY).			/* ��� �� ��� ���६���஢��� */

   is-ok = 0.
END PROCEDURE.