{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pirree_dps.p,v $ $Revision: 1.20 $ $Date: 2011-01-24 11:02:36 $
Copyright     : ��� �� "�p������������"
���������    : ree_dps.p.
��稭�       :  
���� ����᪠ : ���� ��᪢��
����         : $Author: borisov $
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.19  2010/07/23 08:50:45  ermilov
���������     : A new role  - KredT1
���������     :
���������     : Revision 1.18  2009/12/09 06:44:30  ermilov
���������     : Changes in procedures that getting account and amount on it; Now available getting account with main role 3 times ( in past only 2 )
���������     :
���������     : Revision 1.17  2009/09/15 06:32:26  ermilov
���������     : Fixed  post  address
���������     :
���������     : Revision 1.16  2009/06/22 06:47:32  ermilov
���������     : Fixed double output of Moscow and SPB
���������     :
���������     : Revision 1.12  2008/11/17 15:46:18  ermilov
���������     : *** empty log message ***
���������     :
���������     : Revision 1.10  2008/04/10 15:36:19  kuntash
���������     : pasportnye dannye
���������     :
���������     : Revision 1.9  2007/10/19 05:53:40  kuntash
���������     : dobavlena proverka tolko po balansovim acct
���������     :
���������     : Revision 1.8  2007/10/18 07:42:24  anisimov
���������     : no message
���������     :
���������     : Revision 1.7  2007/10/15 11:43:59  kuntash
���������     : dorabotka valuty 47423
���������     :
���������     : Revision 1.6  2007/10/08 07:09:49  kuntash
���������     : доработка адресов
���������     :
���������     : Revision 1.4  2007/09/12 08:26:09  kuntash
���������     : Kuntash ����� ������� ᭠砫� ������ �� ���४� DogPlast, ��⮬ �������� , ��⥬ ����� �������
���������     : Revision 1.3  2007/09/07 08:26:09  kuntash
���������     : Kuntash ��� 60308 ������� �� ���ᮢ� ���㬥�⠬
���������     : Revision 1.2  2007/07/08 08:26:09  kuntash
���������     : Kuntash ������ ������� �� ����� (������� �����⨪�)
���������     :
���������     : 
------------------------------------------------------ */
/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: PIRREE_DPS.P
      Comment: <comment>
   Parameters:
         Uses:
      Used by:
      Created: 19.08.2004 14:27 SAP     
     Modified: 20.08.2004 18:08 SAP      
     Modified: 24.08.2004 12:37 SAP      
     Modified: 26.08.2004 14:26 SAP      
     Modified: 02.09.2004 10:19 SAP      
     Modified: 11.09.2004 13:12 SAP      
     Modified: 18.04.2005 18:08 SAP      
     Modified: 19.04.2005 12:49 SAP      
     Modified: 01.08.2005 15:40 koav     
     Modified: 07.08.2008 Kuntash ������ ������� �� ����� (������� �����⨪�)
*/


{globals.i}
{sv-calc.i}
{sh-defs.i}
{intrface.get xclass}
{intrface.get loan}
{intrface.get dps}
{intrface.get strng}
{intrface.get acct}
{dpsproc.def
    get_param
    Get_Op-templ
    new_dps_prol
    get-beg-date
    get-beg-date-obl    
    get-end-date-obl  
    get-end-date
    chk_date
    Old_Dps
}
{loan.pro}
{ksh-defs.i new}
{bank-id.i}
{f_for_t.i}

{pirsavelog.p}

DEF VAR vUNKg      AS CHAR NO-UNDO. /*����*/
DEF VAR vSymbol    AS CHAR NO-UNDO. /* �।��/����� */
DEF VAR vBranch-id AS CHAR NO-UNDO. /* �।��/����� */

DEF VAR vIndex AS CHAR NO-UNDO.   
DEF VAR vGorod  AS CHAR NO-UNDO.  
DEF VAR vStreet  AS CHAR NO-UNDO.
DEF VAR vDom  AS CHAR NO-UNDO.
DEF VAR vKorpus  AS CHAR NO-UNDO.
DEF VAR vKvart  AS CHAR NO-UNDO.
DEF VAR vRayon  AS CHAR NO-UNDO.
DEF VAR vSeria   AS CHAR NO-UNDO.
DEF VAR vNumDoc  AS CHAR NO-UNDO.
DEF VAR vKem_Vid  AS CHAR NO-UNDO.
DEF VAR vDate_vid   AS CHAR NO-UNDO.
DEF VAR vKodDoc AS CHAR NO-UNDO.
DEF VAR vKodDD AS CHAR NO-UNDO.
DEF VAR vKodReg AS CHAR NO-UNDO.
DEF VAR vAdress AS CHAR NO-UNDO.
DEF VAR vAdressPos AS CHAR NO-UNDO.

DEF VAR adr_uved AS CHAR NO-UNDO.
DEF VAR adr_fakt AS CHAR NO-UNDO.
DEF VAR vStroenie AS CHAR NO-UNDO.
DEF VAR vCountry AS CHAR NO-UNDO.

DEF VAR vEmail AS CHAR NO-UNDO.


DEF VAR vPersID    AS INT  NO-UNDO.

DEF VAR vUNKg2      AS CHAR NO-UNDO. 
DEF VAR vFIO2       AS CHAR NO-UNDO.
DEF VAR vDocument2  AS CHAR NO-UNDO.
DEF VAR vPhone2     AS CHAR NO-UNDO.

DEF VAR vIndex2 AS CHAR NO-UNDO.   
DEF VAR vGorod2  AS CHAR NO-UNDO.  
DEF VAR vStreet2  AS CHAR NO-UNDO.
DEF VAR vDom2  AS CHAR NO-UNDO.
DEF VAR vKorpus2  AS CHAR NO-UNDO.
DEF VAR vKvart2  AS CHAR NO-UNDO.
DEF VAR vRayon2  AS CHAR NO-UNDO.
DEF VAR vSeria2   AS CHAR NO-UNDO.
DEF VAR vNumDoc2  AS CHAR NO-UNDO.
DEF VAR vKem_Vid2  AS CHAR NO-UNDO.
DEF VAR vDate_vid2   AS CHAR NO-UNDO.
DEF VAR vKodDoc2 AS CHAR NO-UNDO.
DEF VAR vKodDD2 AS CHAR NO-UNDO.
DEF VAR vKodReg2 AS CHAR NO-UNDO.
DEF VAR vAdress2 AS CHAR NO-UNDO.
DEF VAR vAdressPos2 AS CHAR NO-UNDO.

DEF VAR adr_uved2 AS CHAR NO-UNDO.
DEF VAR adr_fakt2 AS CHAR NO-UNDO.
DEF VAR vStroenie2 AS CHAR NO-UNDO.
DEF VAR vCountry2 AS CHAR NO-UNDO.

DEF VAR vEmail2 AS CHAR NO-UNDO.


DEF VAR vNomDogPl AS CHAR NO-UNDO.

DEF VAR vAcct   AS CHAR NO-UNDO.
DEF VAR vAcctDog   AS CHAR NO-UNDO.
DEF VAR vAcctDate   AS CHAR NO-UNDO.
DEF VAR vAcctSur   AS CHAR NO-UNDO.
DEF VAR vARole  AS CHAR NO-UNDO.
DEF VAR vBal-rub AS DEC NO-UNDO.
DEF VAR vBal-val AS DEC NO-UNDO.

DEF VAR vAcct_2      AS CHAR NO-UNDO.
DEF VAR vAcctDog_2   AS CHAR NO-UNDO.
DEF VAR vAcctDate_2  AS CHAR NO-UNDO.
DEF VAR vAcctSur_2   AS CHAR NO-UNDO.
DEF VAR vARole_2     AS CHAR NO-UNDO.
DEF VAR vBal-rub_2   AS DEC NO-UNDO.
DEF VAR vBal-val_2   AS DEC NO-UNDO.

DEF VAR vAcct_3      AS CHAR NO-UNDO.
DEF VAR vAcctDog_3   AS CHAR NO-UNDO.
DEF VAR vAcctDate_3  AS CHAR NO-UNDO.
DEF VAR vAcctSur_3   AS CHAR NO-UNDO.
DEF VAR vARole_3     AS CHAR NO-UNDO.
DEF VAR vBal-rub_3   AS DEC NO-UNDO.
DEF VAR vBal-val_3   AS DEC NO-UNDO.


DEF VAR count_acct  AS INT INIT 1 NO-UNDO. /* ������⢮ ��⮢ */
DEF VAR count_cycle AS INT INIT 1 NO-UNDO. /* ����� ��� �� ���浪� */
DEF VAR iFindAcct   AS CHAR INIT "" NO-UNDO.

DEF BUFFER ssmloan FOR loan.
DEF BUFFER ssmloan-acct FOR loan-acct.
DEF BUFFER ssbloan FOR loan.
DEF BUFFER ssbloan-acct FOR loan-acct.

DEF VAR ssbBal-rub   AS DEC NO-UNDO.  
DEF VAR ssbBal-val   AS DEC NO-UNDO.     
DEF VAR ssbAcctDog   AS CHAR NO-UNDO.
DEF VAR ssbAcctDate  AS CHAR NO-UNDO.
DEF VAR ssbAcctSur   AS CHAR NO-UNDO.

   /* ������� ���ᯥ祭�� */
DEF VAR cDOSurr AS CHAR NO-UNDO.
DEF VAR cDONumPP  AS CHAR  NO-UNDO.
DEF VAR cDOVidDog AS CHAR NO-UNDO.


def var temploan as char no-undo.
def buffer bfrtemploan for loan.

DEF BUFFER bfcust-role FOR cust-role.


DEF VAR per as INT NO-UNDO.
DEF VAR max-per as INT NO-UNDO.

/*
vBranch-id = INT(GetXattrValueEx("branch",
                                  STRING(DataBlock.branch-id),
                                  "REGN",
                                  "")).
*/
per = 0.
max-per = 0.
FOR EACH person no-lock:
IF AVAIL person then max-per = max-per + 1.
end.
{init-bar.i "��ࠡ�⪠"}

vBranch-id = bank-regn.

pr:
FOR EACH person  /* where person.person-id = 90  */  NO-LOCK:
per = per + 1.
{move-bar.i per max-per}

    ASSIGN
      vUNKg =   GetXattrValueEx("person",STRING(person.person-id),"���","")
      vIndex =  GetXattrValueEx("person",string(person.person-id),"Address1Indeks","")
      vGorod =  GetXattrValueEx("person",string(person.person-id),"Address2Gorod","")
      vStreet = GetXattrValueEx("person",string(person.person-id),"Address3Street","")
      vDom =    GetXattrValueEx("person",string(person.person-id),"Address4Dom","")
      vKorpus = GetXattrValueEx("person",string(person.person-id),"Address5Korpus","")
      vKvart =  GetXattrValueEx("person",string(person.person-id),"Address6Kvart","")
      vRayon =  GetXattrValueEx("person",string(person.person-id),"Address6Rayon","")
      vSeria  =  GetXattrValueEx("person",string(person.person-id),"Document1Ser_Doc","")
      vNumDoc =  GetXattrValueEx("person",string(person.person-id),"Document2Num_Doc","")
      vKem_Vid = REPLACE (GetXattrValueEx("person",string(person.person-id),"Document3Kem_Vid",""),"~n"," ")
      vDate_vid = GetXattrValueEx("person",string(person.person-id),"Document4Date_vid","")
      vEmail = GetXattrValueEx("person",string(person.person-id),"e-mail","")
      vKodReg   = getXAttrValueEx ("person",
                                   STRING (person.person-id),
                                   "������",
                                   getXAttrValue ("person",
                                                  STRING (person.person-id),
                                                    "���������"))	
      vCountry = person.country-id	 

    NO-ERROR.


       vAdress = (IF  person.address[1] = ? THEN "" ELSE person.address[1]) + " " +
                 (IF  person.address[2] = ? THEN "" ELSE person.address[2]).
 
       ENTRY (1, vAdress) = IF vKodReg eq "00000"   THEN ENTRY (1, vAdress) + "," + vKodReg  ELSE ENTRY (1, vAdress) + "," + getCodeName ("������", vKodReg).




/* VNE 01/06/2009
   ��室�� ���⮢� ���� �� ����᭮�� �������: ���砫� �饬 � ����� "�������", 
   � ��砥 ��� ������⢨� "�������", �᫨  ��� ⮦� ���� - ��६ ��� ४ "���⮆��".
   �᫨ ��᫥ ���� ������ ��祣� �� ��������� � ���ࠩ�� �㤥� ���� ���� 
   ॣ����樨 � ����⢥ ���� ��� ���⮢�� 㢥�������� */

	ASSIGN 
	  vAdressPos = ""
	  adr_uved = ""
	  adr_fakt = ""	.

	RUN GetAddress(INPUT "�������", person.person-id,OUTPUT adr_uved).
	RUN GetAddress(INPUT "�������", person.person-id,OUTPUT adr_fakt).

	IF adr_uved NE "" THEN vAdressPos = adr_uved.
	ELSE 	IF adr_fakt NE "" THEN vAdressPos = adr_fakt.	

/*	IF vAdressPos = "" THEN vAdressPos = GetXattrValueEx("person",string(person.person-id),"���⮆��","") . */

	IF vAdressPos = "" THEN vAdressPos =  vAdress .





      IF  ENTRY (1, vAdress) =  "000000"   THEN ENTRY (1, vAdress) = "" .
      IF  CAN-DO("00000,0",ENTRY(2, vAdress))   THEN ENTRY (2, vAdress) = vCountry .


      IF  ENTRY (1, vAdressPos) =  "000000"   THEN ENTRY (1, vAdressPos) = "" .
      IF  CAN-DO("00000,0",ENTRY(2, vAdressPos))   THEN ENTRY (2, vAdressPos) = vCountry .




/* �஢�ઠ ��� ��� - � ��砥 �᫨ ��� ॣ���� = ���� ��த� (�� ��୮ ⮫쪮 
   ��� ��᪢� � ����) � ���� ��� ��த� �� ����� 
   ����� ������ ���⠬� �뢮� ��஥��� � ����� �������.
*/




IF NUM-ENTRIES (vAdress) GE 4 THEN IF ENTRY (2, vAdress) =  ENTRY (4, vAdress)  THEN ENTRY (4, vAdress) = "" .
IF NUM-ENTRIES (vAdress) = 10 THEN 
	DO:
		vStroenie = TRIM(ENTRY(10, vAdress)).
 		ENTRY(10, vAdress) = ENTRY(9, vAdress).
		ENTRY(9, vAdress) = vStroenie.
	END.


IF NUM-ENTRIES (vAdressPos) GE 4 THEN IF ENTRY (2, vAdressPos) =  ENTRY (4, vAdressPos)  THEN ENTRY (4, vAdressPos) = "" .
IF NUM-ENTRIES (vAdressPos) EQ 10 THEN 
	DO:
		vStroenie = TRIM( ENTRY(10, vAdressPos)).
 		ENTRY(10, vAdressPos) = ENTRY(9, vAdressPos).
		ENTRY(9, vAdressPos) = vStroenie.
	END.






    IF vKem_Vid = "" then 
       vKem_Vid = replace(string(trim(person.issue)),"~n"," ")  + " �� " + trim(vDate_vid). 

/*  ����� ���� ᪮� ������������ � �裡 � ��� � 19 ���� 

    FIND FIRST cust-ident WHERE cust-ident.cust-cat       EQ "�"      
	  AND cust-ident.cust-id        EQ person.person-id
	 /* AND cust-ident.cust-code-type EQ person.document-id
	  AND cust-ident.cust-code      EQ person.document */
	  AND cust-ident.close-date     EQ ""  EQEXCLUSIVE-LOCK NO-WAIT NO-ERROR.
   IF AVAIL cust-ident THEN DO:
      vKem_Vid = replace(trim(cust-ident.issue),"~n"," ") + " �� " + String(cust-ident.open-date).
      end.    
   
    IF ERROR-STATUS:ERROR THEN DO: 
        NEXT pr.
    END.
    
*/    
    vKodDD = GetCodeEx ("�������",person.document-id,"").
    if vKodDD ="21" then vKodDoc="1".
    if vKodDD ="03" then vKodDoc="2".
    if vKodDD ="04" then vKodDoc="3".
    if vKodDD ="27" then vKodDoc="3".
    if vKodDD ="07" then vKodDoc="4".
    if vKodDD ="10" then vKodDoc="6".
    if vKodDD ="12" then vKodDoc="9".
    if vKodDD ="13" then vKodDoc="12".
    if vKodDD ="14" then vKodDoc="13".
    if vKodDD ="01" then vKodDoc="14".
    if vKodDD ="22" then vKodDoc="14".
    
ln:

/*          �������� �� ������ࠬ             */

	
    FOR EACH loan WHERE loan.cust-cat = "�" AND 
			CAN-DO("!loan_trans_ov,!loan-tran-lin,!loan_trans_diff,*",TRIM(loan.class-code)) AND
                        loan.cust-id = person.person-id AND
                        (loan.close-date = ? OR
                        loan.close-date > DataBlock.End-Date)

    NO-LOCK:
        IF loan.contract NE "dps" AND loan.contract NE "�।��"  THEN
            NEXT ln.
        vSymbol = IF loan.contract = "dps"
                  THEN "�"
                  ELSE "�". 
    
       RUN Get_Current_Loan_Acct_bal(loan.contract,
                                      loan.cont-code,
                                      DataBlock.End-Date,
                                      DataBlock.branch-id,
                                      "",
                                      OUTPUT vBal-rub, /*������᭭� � �㡫�� �� ����*/
                                      OUTPUT vBal-val, /*� ����� �������*/
                                      OUTPUT vAcct, /*����� ���*/
                                      OUTPUT vARole /*��� ஫� ���*/
                                      ).

/*****
 message "1:" loan.cont-code vARole vAcct vBal-val vBal-rub VIEW-AS ALERT-BOX. 
*****/

       IF vBal-val ne 0 and vAcct ne "" and vAcct ne ? THEN  
       DO:
      /* ���������� ������������ ������� �� ���४� dogplast �� ��� */ 
       if substr(vAcct,6,3) = "810"
       then do:
         vAcctSur = vAcct + ",".
       end.
       else do:
         vAcctSur = vAcct + "," + substr(vAcct,6,3).
       end. 

       temploan = loan.cont-code.

    if loan.cont-code begins "��" then 
    do:

/*       message loan.cont-code temploan VIEW-AS ALERT-BOX.*/

    end.



       RUN Get_DogDateANDPlast_Acct(vAcct, temploan, loan.class-code, OUTPUT vAcctDate, OUTPUT vAcctDog) .
/*
       vAcctDog = GetXattrValueEx("acct",vAcctSur,"DogPlast","").
       if vAcctDog = "" then vAcctDog = GetEntries(2,GetXattrValueEx("acct",vAcctSur,"��������",""),",","").
       if vAcctDog = "" then vAcctDog = temploan.

       vAcctDate = GetXattrValueEx("acct",vAcctSur,"DogDate","").
       if vAcctDate = "" then getxattrvalueex("loan",string(loan.contract + "," + temploan),"��⠑���","").
       if vAcctDate = "" then vAcctDate = STRING(loan.open-date) .
*/

    if loan.cont-code begins "��" then 
    do:
       temploan = substring(loan.cont-code,4).       

       vAcctDog = temploan.
       if vAcctDate = "" then getxattrvalueex("loan",string(loan.contract + "," + temploan),"��⠑���",""). 
/*       if vAcctDate = "" then */
	  do:
  	    find first bfrtemploan where bfrtemploan.contract = "card-pers" and bfrtemploan.cont-code = TRIM(temploan) NO-LOCK NO-ERROR.
            if available bfrtemploan then vAcctDate = STRING(bfrtemploan.open-date).
	  end.
    end.


       vPersID = person.person-id .
       for first bfcust-role
          where bfcust-role.file-name = "loan"
          and   bfcust-role.surrogate = "dps," + loan.cont-code
          and   bfcust-role.class-code = "�ਮ���⥫삪����"
       no-lock:
        vPersID = INT(bfcust-role.cust-id) .
       end.

		/* �६����� ������⪠ ��� ���襢�� �.�. ���祬, ��� � �ᥣ�� ����� ��।��� ������ */
		/* ���� �� ��� ��楤��� ��९����, �� �� �������, �� � ������ �� �� ���� */
		/* �� ᠬ�� ���� �� �ਬ�⨢�� ���� */
       RUN Get_PersonInfo(
       	  vPersID ,
       	  OUTPUT vFIO2      ,
	  OUTPUT vDocument2 ,
	  OUTPUT vPhone2    , 
	  OUTPUT vUNKg2     ,
	  OUTPUT vIndex2    ,
	  OUTPUT vGorod2    , 
	  OUTPUT vStreet2   ,
	  OUTPUT vDom2      ,
	  OUTPUT vKorpus2   , 
	  OUTPUT vKvart2    ,
	  OUTPUT vRayon2    ,
	  OUTPUT vSeria2    , 
	  OUTPUT vNumDoc2   ,
	  OUTPUT vKem_Vid2 ,
	  OUTPUT vDate_vid2 , 
	  OUTPUT vEmail2    ,
	  OUTPUT vKodReg2   , 
	  OUTPUT vCountry2  ,
	  OUTPUT vAdress2   ,
	  OUTPUT vAdressPos2, 
	  OUTPUT adr_uved2 ,
	  OUTPUT adr_fakt2 ,
	  OUTPUT vStroenie2 , 
	  OUTPUT vKodDoc2   ,
	  OUTPUT vKodDD2   
        ).

       FIND FIRST TDataline OF datablock WHERE 
            TDataline.sym1 = vUNKg2 AND
            TDataline.sym2 = vSymbol AND
            TDataline.sym3 = temploan AND
            TDataline.sym4 = string(vBranch-id)
       NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Tdataline THEN DO:
           create TDataLine.
           assign TDataLine.Data-id = in-Data-Id
                  TDataline.sym1 = vUNKg2 
                  TDataline.sym2 = vSymbol 
                  TDataline.sym3 = temploan
		  TDataline.sym4 = string(vBranch-id)
                  TDataline.txt = vFIO2 + "~n" +
                                  /*txt2 ����: */
                                  vAdress2 + "~n" +
                                  /*txt3 ��� ���㬥��:*/
                                  vKodDoc2 + "~n" + 
                                  /*txt4 ��� � ����� ���㬥��:*/
                                  vDocument2 + "~n" + 
                                  /*txt5 ��� �뤠�:*/ 
                                  vKem_Vid2  + "~n" + 
                                  /*txt6 ��� ������ �������:*/ 
                                  vAcctDate /*STRING(loan.open-date)*/ + "~n" + 
                                  /*txt7 ����� ��� ������� */ 
                                  vAcct + "~n" + 
                                  /*txt8 ⥫�䮭*/ 
                                  vPhone2 + "~n" +
				                          /*txt9  ����� ������� �� ���४�� ��� ����⨪�� */
				                          vAcctDog + "~n" +
				                          /*txt10 �����஭��� ���� */ 
				                          vEmail2 + "~n" +
				                          /*txt11 ���⮢� ���� */ 
				                          vAdressPos2
                  TDataLine.Val[1]  = vBal-val
                  TDataLine.Val[2]  = vBal-rub.

       END.
       END.


/* ----------------------------------------------------  */

/**	������騩 ���� �������� ������ ���������७��� �।���� ����.    
	������ ��ᬠ�ਢ����� �� �࠭�. (2011_09_06)			    */


/* ����᪠�� �⮫쪮 ࠧ, ᪮�쪮 ࠧ��� ��㤭�� ��⮢ (count_acct)
   �� ������� � ��� ��� �࠭�� */

IF loan.contract <> 'dps' and loan.open-date <   DataBlock.End-date THEN 
DO:

   /* 1. ��।��塞 ������⢮ ࠧ��� ��㤭�� ��⮢ �� �।�⭮� ����� */

   iFindAcct = vAcct + "," .
   count_acct  = 1 .
   count_cycle = 1.
   ssbBal-rub = 0 .
   ssbBal-val = 0 .
   ssbAcctDog = "" .
   ssbAcctSur = "" .

   FOR EACH ssmloan WHERE 
		    ssmloan.contract = loan.contract
		AND ssmloan.cont-code begins loan.cont-code 
   NO-LOCK,
   FIRST ssmloan-acct OF ssmloan WHERE 
		    ssmloan-acct.acct-type = "�।��" 
		AND NOT CAN-DO(iFindAcct,ssmloan-acct.acct)
   NO-LOCK:

	IF (AVAILABLE ssmloan) AND (AVAILABLE ssmloan-acct) THEN
	DO:
		iFindAcct = iFindAcct + ssmloan-acct.acct + "," .
		count_acct = count_acct +  1 .
	END.

   END. /* END_FOR_EACH*/
 
 
  /* ��������� ����, ��稭�� � ��ண� ��� */

   DO count_cycle = 2 TO count_acct :

	 /* 2 ��।��塞 ���⪨ �� �� ���⠬ */
	 /* ������ �ᯮ�짮������ ��࠭��� ��楤�� Get_Current_Loan_Acct_bal_ext */

	FIND FIRST ssbloan-acct WHERE 
			    ssbloan-acct.acct-type = "�।��" 
		AND ssbloan-acct.acct = ENTRY(count_cycle, iFindAcct, ",")
	NO-LOCK NO-ERROR.

	FIND FIRST ssbloan OF ssbloan-acct NO-LOCK NO-ERROR.

	 IF  (AVAILABLE ssbloan-acct) THEN
	 DO:

	   RUN acct-pos IN h_base (ssbloan-acct.acct, ssbloan-acct.currency, DataBlock.End-Date, DataBlock.End-Date, ?).

	   IF ssbloan-acct.currency = '' THEN 
		DO:
		ssbBal-rub = ABSOLUTE(sh-bal) .
		ssbBal-val = ssbBal-rub . 
		END.
	   ELSE 
		DO:
		ssbBal-rub = CurToBase ("����", ssbloan-acct.currency, DataBlock.End-Date, ABSOLUTE(sh-val)) .
		ssbBal-val = ABSOLUTE(sh-val) .
		END.

	   IF ssbloan-acct.acct NE vAcct  AND  ( ssbBal-val NE 0 OR ssbBal-rub NE 0 ) AND ssbloan-acct.acct NE ""  AND ssbloan-acct.acct NE ?   THEN  
	   DO:
	        /* ���������� ������������ ������� �� ���४� dogplast �� ��� */ 
         	IF substr(ssbloan-acct.acct,6,3) = "810" THEN	
		DO:
	           ssbAcctSur = ssbloan-acct.acct + ",".
	 	END.
         	ELSE
		DO:
        	   ssbAcctSur = ssbloan-acct.acct + "," + substr(ssbloan-acct.acct,6,3).
	 	END. 

	        RUN Get_DogDateANDPlast_Acct(ssbloan-acct.acct, ssbloan.cont-code, ssbloan.class-code, OUTPUT ssbAcctDate, OUTPUT ssbAcctDog) .

/*
	 	ssbAcctDog = GetXattrValueEx("acct",ssbAcctSur,"DogPlast","").

		if ssbAcctDog = "" then ssbAcctDog = GetEntries(2,GetXattrValueEx("acct",ssbAcctSur,"��������",""),",","").
		if ssbAcctDog = "" then ssbAcctDog = ssbloan.cont-code.

		ssbAcctDate = GetXattrValueEx("acct",ssbAcctSur,"DogDate","").
	        if ssbAcctDate = "" then getxattrvalueex("loan",string(ssbloan.contract + "," + ssbloan.cont-code),"��⠑���","").
		if ssbAcctDate = "" then ssbAcctDate = STRING(ssbloan.open-date) .
*/

         	FIND FIRST TDataline OF datablock WHERE 
	            TDataline.sym1 = vUNKg AND
        	    TDataline.sym2 = vSymbol AND
	            TDataline.sym3 = ssbloan.cont-code + '#' + string(count_cycle) AND
	            TDataline.sym4 = string(vBranch-id)
	        NO-LOCK NO-ERROR.
  
        	IF NOT AVAILABLE Tdataline THEN 
		DO:
	           create TDataLine.
        	   assign TDataLine.Data-id = in-Data-Id
                	  TDataline.sym1 = vUNKg 
	                  TDataline.sym2 = vSymbol 
	                  TDataline.sym3 = ssbloan.cont-code + '#' + string(count_cycle)
		          TDataline.sym4 = string(vBranch-id)
	                  TDataline.txt = person.name-last + " " +  person.first-names + "~n" +
                                  /*txt2 ����: */
                                  vAdress + "~n" +
                                  /*txt3 ��� ���㬥��:*/
                                  vKodDoc + "~n" + 
                                  /*txt4 ��� � ����� ���㬥��:*/
                                  (IF person.document  = ?
                                  THEN ""
                                  ELSE person.document) + "~n" + 
                                  /*txt5 ��� �뤠�:*/ 
                                  vKem_Vid  + "~n" + 
                                  /*txt6 ��� ������ �������:*/ 
                                  ssbAcctDate /*STRING(ssbloan.open-date)*/ + "~n" + 
                                  /*txt7 ����� ��� ������� */ 
                                  ssbloan-acct.acct + "~n" + 
                                  /*txt8 ⥫�䮭*/ 
                                  (IF person.phone[1] = ?
                                   THEN ""
                                   ELSE person.phone[1]) + "~n" +
				                          /*txt9  ����� ������� �� ���४�� ��� ����⨪�� */
				                          ssbAcctDog + "~n" +
				                          /*txt10 �����஭��� ���� */ 
				                          vEmail + "~n" +
				                          /*txt11 ���⮢� ���� */ 
				                          vAdressPos
	                  TDataLine.Val[1]  = ssbBal-val
        	          TDataLine.Val[2]  = ssbBal-rub
        	          .
		END.
		ELSE 
		DO:  
			message "��� ���� ⠪�� ���窠!! " loan.cont-code VIEW-AS ALERT-BOX. 
		END.

	   END. /* END_IF*/

	 END. /* END_IF*/

   END. /* END_DO */

END.

/* ----------------------------------------------------  */


       
       /* �᫨ ��� ��⭮�� ������ ���� ����⠫�� �� �� ���� �� ����ॡ������ - 
          �㦭� �� � �� �� ����ॡ������ �������. � � ���� �� ���� ��業�� �������, 
          � �� �� � ॥��� �� 㢨���. ����! */

       IF loan.contract = "dps" AND vARole <> "loan-dps-p" THEN DO: 
          RUN Get_Current_Loan_Acct_bal(loan.contract,
                                         loan.cont-code,
                                         DataBlock.End-Date,
                                         DataBlock.branch-id,
                                         "loan-dps-p",
                                         OUTPUT vBal-rub, /*������a��� � �㡫�� �� �����*/
                                         OUTPUT vBal-val, /*� ����� �������*/
                                         OUTPUT vAcct, /*����� ���*/
                                         OUTPUT vARole /*��� ஫� ���*/
                                         ).

          IF vBal-val = 0 OR vAcct = "" OR vAcct = ? THEN NEXT ln.

      /* ���������� ������������ ������� �� ���४� dogplast �� ��� */ 
       if substr(vAcct,6,3) = "810"
       then do:
         vAcctSur = vAcct + ",".
       end.
       else do:
         vAcctSur = vAcct + "," + substr(vAcct,6,3).
       end. 
       vAcctDog = GetXattrValueEx("acct",vAcctSur,"DogPlast","").
       if vAcctDog = "" then vAcctDog = GetEntries(2,GetXattrValueEx("acct",vAcctSur,"��������",""),",","").
       if vAcctDog = "" then vAcctDog = loan.cont-code.
       
          FIND FIRST TDataline OF datablock WHERE 
               TDataline.sym1 = vUNKg AND
               TDataline.sym2 = vSymbol AND
               TDataline.sym3 = loan.cont-code AND
               TDataline.sym4 = string(vBranch-id) AND 
               ENTRY(7, TDataline.txt, "~n") = vAcct
          NO-LOCK NO-ERROR.
/*          vAdress = (IF  person.address[1] = ? THEN "" ELSE person.address[1]) + " " +
                    (IF  person.address[2] = ? THEN "" ELSE person.address[2]).
	  IF vAdressPos = "" THEN vAdressPos =  vAdress.
*/
          IF NOT AVAILABLE Tdataline THEN DO:
              create TDataLine.
              assign TDataLine.Data-id = in-Data-Id
                     TDataline.sym1 = vUNKg 
                     TDataline.sym2 = vSymbol 
                     TDataline.sym3 = loan.cont-code + ",��� �� ����ॡ������" /* �� �⮡� ��⥬� �� �㣠���� */
                     TDataline.sym4 = string(vBranch-id)
                     TDataline.txt = person.name-last + " " +  person.first-names + "~n" +
                                     /*txt1 ����: */
                                     vAdress + "~n" +
                                     /*txt2 ��� ���㬥��:*/
                                     vKodDoc + "~n" + 
                                     /*txt3 ��� � ����� ���㬥��:*/
                                     (IF person.document  = ?
                                     THEN ""
                                     ELSE person.document) + "~n" + 
                                     /*txt5 ��� �뤠�:*/ 
                                     vKem_Vid + "~n" + 
                                     /*txt6 ��� ������ �������:*/ 
                                     STRING(loan.open-date) + "~n" + 
                                     /*txt6 ����� ��� ������� */ 
                                     vAcct + "~n" + 
                                     /*txt7 ⥫�䮭*/ 
                                     (IF person.phone[1] = ?
                                      THEN ""
                                      ELSE person.phone[1]) + "~n" +
				      vAcctDog + "~n" +
				      vEmail + "~n" +
				      vAdressPos
                     TDataLine.Val[1]  = vBal-val
                     TDataLine.Val[2]  = vBal-rub.

          END.
       END. /* END OF loan.contract = "dps" AND vARole <> "loan-dps-p"  */



/*     ������ ������ �� �।��� ��⠬ 
  
        ��� �।�⭮�� ������� - 
          �����⠥� �� 45815 
          � �᫨ �� �� � ॥��� �� 㢨���. ����! */
	  
       IF loan.contract NE "dps"  THEN DO: 
          RUN Get_Current_Loan_Acct_bal(loan.contract,
                                         loan.cont-code,
                                         DataBlock.End-Date,
                                         DataBlock.branch-id,
                                         "�।��",
                                         OUTPUT vBal-rub, /*������a��� � �㡫�� �� �����*/
                                         OUTPUT vBal-val, /*� ����� �������*/
                                         OUTPUT vAcct, /*����� ���*/
                                         OUTPUT vARole /*��� ஫� ���*/
                                         ).

          IF vBal-val ne 0 AND vAcct NE "" AND vAcct NE ? THEN 
	  DO:

      /* ���������� ������������ ������� �� ���४� dogplast �� ��� */ 
       if substr(vAcct,6,3) = "810"
       then do:
         vAcctSur = vAcct + ",".
       end.
       else do:
         vAcctSur = vAcct + "," + substr(vAcct,6,3).
       end. 

       RUN Get_DogDateANDPlast_Acct(vAcct, loan.cont-code, loan.class-code, OUTPUT vAcctDate, OUTPUT vAcctDog) .
/*
       vAcctDog = GetXattrValueEx("acct",vAcctSur,"DogPlast","").
       if vAcctDog = "" then vAcctDog = GetEntries(2,GetXattrValueEx("acct",vAcctSur,"��������",""),",","").
       if vAcctDog = "" then vAcctDog = loan.cont-code.

       vAcctDate = GetXattrValueEx("acct",vAcctSur,"DogDate","").
       if vAcctDate = "" then getxattrvalueex("loan",string(loan.contract + "," + loan.cont-code),"��⠑���","").
       if vAcctDate = "" then vAcctDate = STRING(loan.open-date) .
*/       

          FIND FIRST TDataline OF datablock WHERE 
               TDataline.sym1 = vUNKg AND
               TDataline.sym2 = vSymbol AND
               TDataline.sym3 = loan.cont-code AND
               TDataline.sym4 = string(vBranch-id) AND 
               ENTRY(7, TDataline.txt, "~n") = vAcct
          NO-LOCK NO-ERROR.
/*          vAdress = (IF  person.address[1] = ? THEN "" ELSE person.address[1]) + " " +
                    (IF  person.address[2] = ? THEN "" ELSE person.address[2]).
	  IF vAdressPos = "" THEN vAdressPos =  vAdress.
*/
          IF NOT AVAILABLE Tdataline THEN DO:
           create TDataLine.
           assign TDataLine.Data-id = in-Data-Id
                  TDataline.sym1 = vUNKg 
                  TDataline.sym2 = vSymbol
                  TDataline.sym3 = loan.cont-code + "_45815" 
		              TDataline.sym4 = string(vBranch-id)
                  TDataline.txt = person.name-last + " " +  person.first-names + "~n" +
                                  /*txt1 ����: */
                                  vAdress + "~n" +
                                  /*txt2 ��� ���㬥��:*/
                                  vKodDoc + "~n" + 
                                  /*txt3 ��� � ����� ���㬥��:*/
                                  (IF person.document  = ?
                                  THEN ""
                                  ELSE person.document) + "~n" + 
                                  /*txt5 ��� �뤠�:*/ 
                                  vKem_Vid + "~n" + 
                                  /*txt6 ��� ������ �������:*/ 
                                  vAcctDate /*STRING(loan.open-date)*/ + "~n" + 
                                  /*txt6 ����� ��� ������� */ 
                                  vAcct + "~n" + 
                                  /*txt7 ⥫�䮭*/ 
                                  (IF person.phone[1] = ?
                                   THEN ""
                                   ELSE person.phone[1]) + "~n" +
				   vAcctDog + "~n" +
				   vEmail + "~n" +
				   vAdressPos
                  TDataLine.Val[1]  = vBal-val
                  TDataLine.Val[2]  = vBal-rub.

	  END.
          END.
          END. /* END OF loan.contract NE "dps" AND vARole EQ "�।��"  */


       /*------------------------ ��� �।�⭮�� ������� - 45915 ! ---------------------------------------*/
	  
       IF loan.contract NE "dps"  THEN DO: 
          RUN Get_Current_Loan_Acct_bal(loan.contract,
                                         loan.cont-code,
                                         DataBlock.End-Date,
                                         DataBlock.branch-id,
                                         "�।��%",
                                         OUTPUT vBal-rub, /*������a��� � �㡫�� �� �����*/
                                         OUTPUT vBal-val, /*� ����� �������*/
                                         OUTPUT vAcct, /*����� ���*/
                                         OUTPUT vARole /*��� ஫� ���*/
                                         ).

          IF vBal-val ne 0 AND vAcct NE "" AND vAcct NE ? THEN 
	  DO:

      /* ���������� ������������ ������� �� ���४� dogplast �� ��� */ 
       if substr(vAcct,6,3) = "810"
       then do:
         vAcctSur = vAcct + ",".
       end.
       else do:
         vAcctSur = vAcct + "," + substr(vAcct,6,3).
       end. 

       RUN Get_DogDateANDPlast_Acct(vAcct, loan.cont-code, loan.class-code, OUTPUT vAcctDate, OUTPUT vAcctDog) .
/*   
       vAcctDog = GetXattrValueEx("acct",vAcctSur,"DogPlast","").
       if vAcctDog = "" then vAcctDog = GetEntries(2,GetXattrValueEx("acct",vAcctSur,"��������",""),",","").
       if vAcctDog = "" then vAcctDog = loan.cont-code.

       vAcctDate = GetXattrValueEx("acct",vAcctSur,"DogDate","").
       if vAcctDate = "" then getxattrvalueex("loan",string(loan.contract + "," + loan.cont-code),"��⠑���","").
       if vAcctDate = "" then vAcctDate = STRING(loan.open-date) .
*/       
          FIND FIRST TDataline OF datablock WHERE 
               TDataline.sym1 = vUNKg AND
               TDataline.sym2 = vSymbol AND
               TDataline.sym3 = loan.cont-code AND
               TDataline.sym4 = string(vBranch-id) AND 
               ENTRY(7, TDataline.txt, "~n") = vAcct
          NO-LOCK NO-ERROR.
/*          vAdress = (IF  person.address[1] = ? THEN "" ELSE person.address[1]) + " " +
                    (IF  person.address[2] = ? THEN "" ELSE person.address[2]).
	  IF vAdressPos = "" THEN vAdressPos =  vAdress.
*/
          IF NOT AVAILABLE Tdataline THEN DO:
           create TDataLine.
           assign TDataLine.Data-id = in-Data-Id
                  TDataline.sym1 = vUNKg 
                  TDataline.sym2 = vSymbol
                  TDataline.sym3 = loan.cont-code + "_45915" 
		              TDataline.sym4 = string(vBranch-id)
                  TDataline.txt = person.name-last + " " +  person.first-names + "~n" +
                                  /*txt1 ����: */
                                  vAdress + "~n" +
                                  /*txt2 ��� ���㬥��:*/
                                  vKodDoc + "~n" + 
                                  /*txt3 ��� � ����� ���㬥��:*/
                                  (IF person.document  = ?
                                  THEN ""
                                  ELSE person.document) + "~n" + 
                                  /*txt5 ��� �뤠�:*/ 
                                  vKem_Vid + "~n" + 
                                  /*txt6 ��� ������ �������:*/
                                  vAcctDate /*STRING(loan.open-date)*/ + "~n" +  
                                  /*txt6 ����� ��� ������� */ 
                                  vAcct + "~n" + 
                                  /*txt7 ⥫�䮭*/ 
                                  (IF person.phone[1] = ?
                                   THEN ""
                                   ELSE person.phone[1]) + "~n" +
				   vAcctDog + "~n" +
				   vEmail + "~n" +
				   vAdressPos
                  TDataLine.Val[1]  = vBal-val
                  TDataLine.Val[2]  = vBal-rub.

	  END.
          END.
          END. /* END OF loan.contract NE "dps" AND vARole EQ "�।��%"  */




       /*------------------------------------ ��� �।�⭮�� ������� - 91604 -------------------------------------- */
	  
       IF loan.contract NE "dps"  THEN DO: 
          RUN Get_Current_Loan_Acct_bal(loan.contract,
                                         loan.cont-code,
                                         DataBlock.End-Date,
                                         DataBlock.branch-id,
                                         "�।��%�",
                                         OUTPUT vBal-rub, /*������a��� � �㡫�� �� �����*/
                                         OUTPUT vBal-val, /*� ����� �������*/
                                         OUTPUT vAcct, /*����� ���*/
                                         OUTPUT vARole /*��� ஫� ���*/
                                         ).

          IF vBal-val ne 0 AND vAcct NE "" AND vAcct NE ? THEN 
	  DO:

      /* ���������� ������������ ������� �� ���४� dogplast �� ��� */ 
       if substr(vAcct,6,3) = "810"
       then do:
         vAcctSur = vAcct + ",".
       end.
       else do:
         vAcctSur = vAcct + "," + substr(vAcct,6,3).
       end. 

       RUN Get_DogDateANDPlast_Acct(vAcct, loan.cont-code, loan.class-code, OUTPUT vAcctDate, OUTPUT vAcctDog) .
/*
       vAcctDog = GetXattrValueEx("acct",vAcctSur,"DogPlast","").
       if vAcctDog = "" then vAcctDog = GetEntries(2,GetXattrValueEx("acct",vAcctSur,"��������",""),",","").
       if vAcctDog = "" then vAcctDog = loan.cont-code.

       vAcctDate = GetXattrValueEx("acct",vAcctSur,"DogDate","").
       if vAcctDate = "" then getxattrvalueex("loan",string(loan.contract + "," + loan.cont-code),"��⠑���","").
       if vAcctDate = "" then vAcctDate = STRING(loan.open-date) .
*/       
          FIND FIRST TDataline OF datablock WHERE 
               TDataline.sym1 = vUNKg AND
               TDataline.sym2 = vSymbol AND
               TDataline.sym3 = loan.cont-code AND
               TDataline.sym4 = string(vBranch-id) AND 
               ENTRY(7, TDataline.txt, "~n") = vAcct
          NO-LOCK NO-ERROR.
/*          vAdress = (IF  person.address[1] = ? THEN "" ELSE person.address[1]) + " " +
                    (IF  person.address[2] = ? THEN "" ELSE person.address[2]).
	  IF vAdressPos = "" THEN vAdressPos =  vAdress.
*/
          IF NOT AVAILABLE Tdataline THEN DO:
           create TDataLine.
           assign TDataLine.Data-id = in-Data-Id
                  TDataline.sym1 = vUNKg 
                  TDataline.sym2 = vSymbol
                  TDataline.sym3 = loan.cont-code + "_91604" 
		              TDataline.sym4 = string(vBranch-id)
                  TDataline.txt = person.name-last + " " +  person.first-names + "~n" +
                                  /*txt1 ����: */
                                  vAdress + "~n" +
                                  /*txt2 ��� ���㬥��:*/
                                  vKodDoc + "~n" + 
                                  /*txt3 ��� � ����� ���㬥��:*/
                                  (IF person.document  = ?
                                  THEN ""
                                  ELSE person.document) + "~n" + 
                                  /*txt5 ��� �뤠�:*/ 
                                  vKem_Vid + "~n" + 
                                  /*txt6 ��� ������ �������:*/
                                  vAcctDate /*STRING(loan.open-date)*/ + "~n" +  
                                  /*txt6 ����� ��� ������� */ 
                                  vAcct + "~n" + 
                                  /*txt7 ⥫�䮭*/ 
                                  (IF person.phone[1] = ?
                                   THEN ""
                                   ELSE person.phone[1]) + "~n" +
				   vAcctDog + "~n" +
				   vEmail + "~n" +
				   vAdressPos
                  TDataLine.Val[1]  = vBal-val
                  TDataLine.Val[2]  = vBal-rub.

	  END.
          END.
          END. /* END OF loan.contract NE "dps" AND vARole EQ "�।��%�"  */

 /*------------------------------------ ��� �।�⭮�� ������� - 91604 �।��-------------------------------------- */
	  
       IF loan.contract NE "dps"  THEN DO: 
          RUN Get_Current_Loan_Acct_bal(loan.contract,
                                         loan.cont-code,
                                         DataBlock.End-Date,
                                         DataBlock.branch-id,
                                         "�।��",
                                         OUTPUT vBal-rub, /*������a��� � �㡫�� �� �����*/
                                         OUTPUT vBal-val, /*� ����� �������*/
                                         OUTPUT vAcct, /*����� ���*/
                                         OUTPUT vARole /*��� ஫� ���*/
                                         ).

          IF vBal-val ne 0 AND vAcct NE "" AND vAcct NE ? THEN 
	  DO:

      /* ���������� ������������ ������� �� ���४� dogplast �� ��� */ 
       if substr(vAcct,6,3) = "810"
       then do:
         vAcctSur = vAcct + ",".
       end.
       else do:
         vAcctSur = vAcct + "," + substr(vAcct,6,3).
       end. 

       RUN Get_DogDateANDPlast_Acct(vAcct, loan.cont-code, loan.class-code, OUTPUT vAcctDate, OUTPUT vAcctDog) .
/*
       vAcctDog = GetXattrValueEx("acct",vAcctSur,"DogPlast","").
       if vAcctDog = "" then vAcctDog = GetEntries(2,GetXattrValueEx("acct",vAcctSur,"��������",""),",","").
       if vAcctDog = "" then vAcctDog = loan.cont-code.

       vAcctDate = GetXattrValueEx("acct",vAcctSur,"DogDate","").
       if vAcctDate = "" then getxattrvalueex("loan",string(loan.contract + "," + loan.cont-code),"��⠑���","").
       if vAcctDate = "" then vAcctDate = STRING(loan.open-date) .
*/       
          FIND FIRST TDataline OF datablock WHERE 
               TDataline.sym1 = vUNKg AND
               TDataline.sym2 = vSymbol AND
               TDataline.sym3 = loan.cont-code AND
               TDataline.sym4 = string(vBranch-id) AND 
               ENTRY(7, TDataline.txt, "~n") = vAcct
          NO-LOCK NO-ERROR.
/*          vAdress = (IF  person.address[1] = ? THEN "" ELSE person.address[1]) + " " +
                    (IF  person.address[2] = ? THEN "" ELSE person.address[2]).
	  IF vAdressPos = "" THEN vAdressPos =  vAdress.
*/
          IF NOT AVAILABLE Tdataline THEN DO:
           create TDataLine.
           assign TDataLine.Data-id = in-Data-Id
                  TDataline.sym1 = vUNKg 
                  TDataline.sym2 = vSymbol
                  TDataline.sym3 = loan.cont-code + "_91604TB" 
		              TDataline.sym4 = string(vBranch-id)
                  TDataline.txt = person.name-last + " " +  person.first-names + "~n" +
                                  /*txt1 ����: */
                                  vAdress + "~n" +
                                  /*txt2 ��� ���㬥��:*/
                                  vKodDoc + "~n" + 
                                  /*txt3 ��� � ����� ���㬥��:*/
                                  (IF person.document  = ?
                                  THEN ""
                                  ELSE person.document) + "~n" + 
                                  /*txt5 ��� �뤠�:*/ 
                                  vKem_Vid + "~n" + 
                                  /*txt6 ��� ������ �������:*/
                                  vAcctDate /*STRING(loan.open-date)*/ + "~n" +  
                                  /*txt6 ����� ��� ������� */ 
                                  vAcct + "~n" + 
                                  /*txt7 ⥫�䮭*/ 
                                  (IF person.phone[1] = ?
                                   THEN ""
                                   ELSE person.phone[1]) + "~n" +
				   vAcctDog + "~n" +
				   vEmail + "~n" +
				   vAdressPos
                  TDataLine.Val[1]  = vBal-val
                  TDataLine.Val[2]  = vBal-rub.

	  END.
          END.
          END. /* END OF loan.contract NE "dps" AND vARole EQ "�।��"  */





       /* ��� �।�⭮�� ������� - 
          �����⠥� �� 47427 
          � �᫨ �� �� � ॥��� �� 㢨���. ����! */
	  
       IF loan.contract NE "dps"  THEN DO: 
          RUN Get_Current_Loan_Acct_bal(loan.contract,
                                         loan.cont-code,
                                         DataBlock.End-Date,
                                         DataBlock.branch-id,
                                         "�।�",
                                         OUTPUT vBal-rub, /*������a��� � �㡫�� �� �����*/
                                         OUTPUT vBal-val, /*� ����� �������*/
                                         OUTPUT vAcct, /*����� ���*/
                                         OUTPUT vARole /*��� ஫� ���*/
                                         ).

          IF vBal-val ne 0 AND vAcct NE "" AND vAcct NE ? THEN 
	  DO:

      /* ���������� ������������ ������� �� ���४� dogplast �� ��� */ 
       if substr(vAcct,6,3) = "810"
       then do:
         vAcctSur = vAcct + ",".
       end.
       else do:
         vAcctSur = vAcct + "," + substr(vAcct,6,3).
       end. 

       RUN Get_DogDateANDPlast_Acct(vAcct, loan.cont-code, loan.class-code, OUTPUT vAcctDate, OUTPUT vAcctDog) .
/*
       vAcctDog = GetXattrValueEx("acct",vAcctSur,"DogPlast","").
       if vAcctDog = "" then vAcctDog = GetEntries(2,GetXattrValueEx("acct",vAcctSur,"��������",""),",","").
       if vAcctDog = "" then vAcctDog = loan.cont-code.

       vAcctDate = GetXattrValueEx("acct",vAcctSur,"DogDate","").
       if vAcctDate = "" then getxattrvalueex("loan",string(loan.contract + "," + loan.cont-code),"��⠑���","").
       if vAcctDate = "" then vAcctDate = STRING(loan.open-date) .
*/       
          FIND FIRST TDataline OF datablock WHERE 
               TDataline.sym1 = vUNKg AND
               TDataline.sym2 = vSymbol AND
               TDataline.sym3 = loan.cont-code AND
               TDataline.sym4 = string(vBranch-id) AND 
               ENTRY(7, TDataline.txt, "~n") = vAcct
          NO-LOCK NO-ERROR.
/*          vAdress = (IF  person.address[1] = ? THEN "" ELSE person.address[1]) + " " +
                    (IF  person.address[2] = ? THEN "" ELSE person.address[2]).
	  IF vAdressPos = "" THEN vAdressPos =  vAdress.

*/
          IF NOT AVAILABLE Tdataline THEN DO:
           create TDataLine.
           assign TDataLine.Data-id = in-Data-Id
                  TDataline.sym1 = vUNKg 
                  TDataline.sym2 = vSymbol
                  TDataline.sym3 = loan.cont-code + "_47427" 
		              TDataline.sym4 = string(vBranch-id)
                  TDataline.txt = person.name-last + " " +  person.first-names + "~n" +
                                  /*txt1 ����: */
                                  vAdress + "~n" +
                                  /*txt2 ��� ���㬥��:*/
                                  vKodDoc + "~n" + 
                                  /*txt3 ��� � ����� ���㬥��:*/
                                  (IF person.document  = ?
                                  THEN ""
                                  ELSE person.document) + "~n" + 
                                  /*txt5 ��� �뤠�:*/ 
                                  vKem_Vid  + "~n" + 
                                  /*txt6 ��� ������ �������:*/
                                  vAcctDate /*STRING(loan.open-date)*/ + "~n" +  
                                  /*txt6 ����� ��� ������� */ 
                                  vAcct + "~n" + 
                                  /*txt7 ⥫�䮭*/ 
                                  (IF person.phone[1] = ?
                                   THEN ""
                                   ELSE person.phone[1]) + "~n" +
				   vAcctDog + "~n" +
				   vEmail + "~n" +
				   vAdressPos
                  TDataLine.Val[1]  = vBal-val
                  TDataLine.Val[2]  = vBal-rub.

	  END.
          END.
          END. /* END OF loan.contract NE "dps" AND vARole EQ "�।�"  */
       
       
          /* ��� �।�⭮�� ������� - 
          �����⠥� 47427 � ����-஫�� �।�1  
          � �᫨ �� �� � ॥��� �� 㢨���. ����! */
	  
       IF loan.contract NE "dps"  THEN DO: 
          RUN Get_Current_Loan_Acct_bal(loan.contract,
                                         loan.cont-code,
                                         DataBlock.End-Date,
                                         DataBlock.branch-id,
                                         "�।�1",
                                         OUTPUT vBal-rub, /*������a��� � �㡫�� �� �����*/
                                         OUTPUT vBal-val, /*� ����� �������*/
                                         OUTPUT vAcct, /*����� ���*/
                                         OUTPUT vARole /*��� ஫� ���*/
                                         ).

          IF vBal-val ne 0 AND vAcct NE "" AND vAcct NE ? THEN 
	  DO:

      /* ���������� ������������ ������� �� ���४� dogplast �� ��� */ 
       if substr(vAcct,6,3) = "810"
       then do:
         vAcctSur = vAcct + ",".
       end.
       else do:
         vAcctSur = vAcct + "," + substr(vAcct,6,3).
       end. 

       RUN Get_DogDateANDPlast_Acct(vAcct, loan.cont-code, loan.class-code, OUTPUT vAcctDate, OUTPUT vAcctDog) .

/*       vAcctDog = GetXattrValueEx("acct",vAcctSur,"DogPlast","").
       if vAcctDog = "" then vAcctDog = GetEntries(2,GetXattrValueEx("acct",vAcctSur,"��������",""),",","").
       if vAcctDog = "" then vAcctDog = loan.cont-code.

       vAcctDate = GetXattrValueEx("acct",vAcctSur,"DogDate","").
       if vAcctDate = "" then getxattrvalueex("loan",string(loan.contract + "," + loan.cont-code),"��⠑���","").
       if vAcctDate = "" then vAcctDate = STRING(loan.open-date) .
*/       
          FIND FIRST TDataline OF datablock WHERE 
               TDataline.sym1 = vUNKg AND
               TDataline.sym2 = vSymbol AND
               TDataline.sym3 = loan.cont-code AND
               TDataline.sym4 = string(vBranch-id) AND 
               ENTRY(7, TDataline.txt, "~n") = vAcct
          NO-LOCK NO-ERROR.
/*          vAdress = (IF  person.address[1] = ? THEN "" ELSE person.address[1]) + " " +
                    (IF  person.address[2] = ? THEN "" ELSE person.address[2]).
	  IF vAdressPos = "" THEN vAdressPos =  vAdress.

*/
          IF NOT AVAILABLE Tdataline THEN DO:
           create TDataLine.
           assign TDataLine.Data-id = in-Data-Id
                  TDataline.sym1 = vUNKg 
                  TDataline.sym2 = vSymbol
                  TDataline.sym3 = loan.cont-code + "_47427T1" 
		              TDataline.sym4 = string(vBranch-id)
                  TDataline.txt = person.name-last + " " +  person.first-names + "~n" +
                                  /*txt1 ����: */
                                  vAdress + "~n" +
                                  /*txt2 ��� ���㬥��:*/
                                  vKodDoc + "~n" + 
                                  /*txt3 ��� � ����� ���㬥��:*/
                                  (IF person.document  = ?
                                  THEN ""
                                  ELSE person.document) + "~n" + 
                                  /*txt5 ��� �뤠�:*/ 
                                  vKem_Vid  + "~n" + 
                                  /*txt6 ��� ������ �������:*/ 
                                  vAcctDate /*STRING(loan.open-date)*/ + "~n" + 
                                  /*txt6 ����� ��� ������� */ 
                                  vAcct + "~n" + 
                                  /*txt7 ⥫�䮭*/ 
                                  (IF person.phone[1] = ?
                                   THEN ""
                                   ELSE person.phone[1]) + "~n" +
				   vAcctDog + "~n" +
				   vEmail + "~n" +
				   vAdressPos
                  TDataLine.Val[1]  = vBal-val
                  TDataLine.Val[2]  = vBal-rub.

	  END.
          END.
          END. /* END OF loan.contract NE "dps" AND vARole EQ "�।�1"  */
       
       
   END. /* FOR EACH loan */
   
   
   
   ac:
   FOR EACH acct 
	WHERE  (acct.bal-acct = 60308 OR acct.bal-acct = 47423 OR acct.bal-acct = 91414 OR acct.bal-acct = 60312  OR acct.bal-acct = 47422 ) 
	AND    acct.cust-cat = '�' 
	AND    person.person-id = acct.cust-id.
     IF AVAIL acct THEN
     DO:

       IF acct.bal-acct = 47423 or acct.bal-acct = 60308 or acct.bal-acct = 91414 or acct.bal-acct = 60312 THEN 
		vSymbol = "�". else vSymbol = "�".

       vAcct = acct.acct.       	   

      /* ���������� ������������ ������� �� ���४� dogplast �� ��� */ 
       vAcctDog = GetXattrValueEx("acct",acct.acct + "," + acct.currency,"DogPlast","").
       if vAcctDog = "" then vAcctDog = acct.acct.
      
       vAcctDate = GetXattrValueEx("acct",acct.acct + "," + acct.currency,"DogDate","").			

       run acct-pos IN h_base (acct.acct, acct.currency, dataBlock.End-date, dataBlock.End-date, ?).
            vBal-val = sh-val.
	          vBal-rub = IF acct.currency = ''
                THEN sh-bal
                ELSE CurToBase ("����",
                                Acct.currency,
                                dataBlock.End-date,
                                vBal-val).

       IF vBal-rub EQ 0 THEN NEXT ac.       

       IF acct.bal-acct = 60308 then 
       DO:
       		FIND LAST op-entry where 
       			op-entry.acct-cr begins "20202" and
       			op-entry.acct-db EQ acct.acct  and 
       			op-entry.op-date LE DataBlock.End-Date no-lock no-error.
      
       			IF AVAIL op-entry THEN
       				DO:
       				FIND FIRST op where op.op eq op-entry.op no-lock no-error.
       				vAcctDog = op.doc-num.
       				vAcctDate = string(op.doc-date).
       				END.
       END.		
    
       IF acct.bal-acct = 91414 THEN
       DO:
          find last loan-acct where loan-acct.contract = "�।���" and loan-acct.acct = acct.acct NO-LOCK NO-ERROR.
          if available loan-acct then 
          do:
                  find last loan where loan.contract = loan-acct.contract and loan-acct.cont-code = loan.cont-code NO-LOCK NO-ERROR.
	           if available loan then do:
                      vAcctDog = loan.cont-code.
                      vAcctDate = STRING(loan.open-date).
		   end.
          end.
          else
          do:
	      find last loan-acct where loan-acct.contract = "�।��" and loan-acct.acct = acct.acct NO-LOCK NO-ERROR.
              if available loan-acct then 
		do:
                   find last loan where loan.contract = loan-acct.contract and loan-acct.cont-code = loan.cont-code NO-LOCK NO-ERROR.

		    /*** #2317 ***/
  	           if available loan then 
		   do:
                             vAcctDog = loan.cont-code . 
                             vAcctDate = STRING(loan.open-date) .

			     cDOSurr = "" .  cDONumPP = "" .  cDOVidDog = "" .

			     FOR EACH term-obl 
				WHERE term-obl.contract EQ loan.contract
	  			AND term-obl.cont-code  EQ loan.cont-code
				AND term-obl.idnt       EQ 5
			     NO-LOCK:

				cDOSurr = term-obl.contract + "," + term-obl.cont-code + "," + STRING(term-obl.idnt) + "," 
				    + STRING(term-obl.end-date) + "," + STRING(term-obl.nn) .
				cDONumPP  = GetXAttrValueEx ("term-obl", cDOSurr,"�������", "") .
				cDOVidDog = GetXAttrValueEx ("term-obl", cDOSurr, "��������", "") .

				cDOVidDog = cDOVidDog + (IF cDONumPP NE "0" THEN cDONumPP ELSE "") .

				IF loan-acct.acct-type EQ cDOVidDog THEN 
				DO:	
				  vAcctDog  = GetXAttrValueEx("term-obl", cDOSurr, "��������", vAcctDog ) .
				  vAcctDate = STRING(term-obl.fop-date) .	
				  LEAVE.
				END. /* end_if loan-acct.acct-type EQ cDOVidDog */
     
			     END. /* end for_each term-obl */ 

		   end. /* end if available loan */
		end. /* end if available loan-acct */
          end. /* end  else */
                   
       END. /* IF acct.bal-acct = 91414 */


		/*** #3580 ***/
       IF acct.bal-acct = 47422 then 
       DO:

	FIND LAST loan-acct 
		WHERE loan-acct.contract EQ 'card-pers'
		AND   loan-acct.acct-type BEGINS "ObBnk@"
		AND   loan-acct.acct = acct.acct 
	NO-LOCK NO-ERROR.

	IF AVAIL loan-acct THEN
	DO:
		vAcctDog  = GetXattrValueEx("acct",STRING(acct.acct + "," + acct.currency),"DogPlast" ,"") .
		vAcctDate = GetXattrValueEx("acct",STRING(acct.acct + "," + acct.currency),"DogDate"  ,"") .

                find last loan where loan.contract = loan-acct.contract and loan-acct.cont-code = loan.cont-code NO-LOCK NO-ERROR.
                if available loan then 
		do:
		   IF vAcctDog  = "" THEN 
			vAcctDog  =  loan.cont-code .         
		   IF vAcctDate = "" THEN 
			vAcctDate =  STRING(loan.open-date) .
		end.

		vBal-val = ABS(vBal-val) .
		vBal-rub = ABS(vBal-rub) .

	END.

       END.		

    
       FIND FIRST TDataline OF datablock WHERE 
               TDataline.sym1 = vUNKg AND
               TDataline.sym2 = vSymbol AND
               TDataline.sym3 = acct.acct AND
               TDataline.sym4 = string(vBranch-id) AND 
               ENTRY(7, TDataline.txt, "~n") = vAcct
          NO-LOCK NO-ERROR.
/*          vAdress = (IF  person.address[1] = ? THEN "" ELSE person.address[1]) + " " +
                    (IF  person.address[2] = ? THEN "" ELSE person.address[2]).

	  IF vAdressPos = "" THEN vAdressPos =  vAdress.
*/
	  IF vBAl-val = 0 THEN vBal-val = vBal-rub.

          IF NOT AVAILABLE Tdataline THEN DO:
           create TDataLine.
           assign TDataLine.Data-id = in-Data-Id
                  TDataline.sym1 = vUNKg 
                  TDataline.sym2 = vSymbol
                  TDataline.sym3 = vAcctDog
		              TDataline.sym4 = string(vBranch-id)
                  TDataline.txt = person.name-last + " " +  person.first-names + "~n" +
                                  /*txt1 ����: */
                                  vAdress + "~n" +
                                  /*txt2 ��� ���㬥��:*/
                                  vKodDoc + "~n" + 
                                  /*txt3 ��� � ����� ���㬥��:*/
                                  (IF person.document  = ?
                                  THEN ""
                                  ELSE person.document) + "~n" + 
                                  /*txt5 ��� �뤠�:*/ 
                                  vKem_Vid  + "~n" + 
                                  /*txt6 ��� ������ �������:*/ 
				  (IF string(vAcctdate) = ""
                                  THEN STRING(acct.open-date)
                                  ELSE string(vAcctdate)) + "~n" + 
                                  /*txt6 ����� ��� ������� */ 
                                  vAcct + "~n" + 
                                  /*txt7 ⥫�䮭*/ 
                                  (IF person.phone[1] = ?
                                   THEN ""
                                   ELSE person.phone[1]) + "~n" +
				   vAcctDog + "~n" +
				   vEmail + "~n" +
				   vAdressPos
                  TDataLine.Val[1]  = vBal-val
                  TDataLine.Val[2]  = vBal-rub.

	  END.
                 
       
       END.
    END. /* end of 60308 */   
   
END. /* FOR EACH person */


PROCEDURE Get_Current_Loan_Acct.
    DEF INPUT PARAMETER iContr     AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iCont-code AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iDate      AS DATE NO-UNDO.
    DEF OUTPUT PARAMETER oRole     AS CHAR NO-UNDO.
    DEF PARAM BUFFER oAcct FOR acct.

   
    DEF BUFFER mloan FOR loan.
    DEF BUFFER mloan-acct FOR loan-acct.

    DEF VAR mBegDate AS DATE NO-UNDO.
    DEF VAR mEndDate AS DATE NO-UNDO.
    DEF VAR mRole AS CHAR NO-UNDO.
    DEF VAR mAcct AS CHAR NO-UNDO.

    FIND FIRST mloan WHERE mloan.contract = iContr AND
                           mloan.cont-code = iCont-code 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE mLoan THEN RETURN.

    IF mLoan.contract = "dps" THEN DO:
        RUN GetBaseAcct IN h_dps (iContr,
                                  iCont-Code,
                                  iDate, 
                                  OUTPUT mAcct).
        FIND LAST mloan-acct WHERE 
                  mloan-acct.contract  = mloan.contract
              AND mloan-acct.cont-code = mloan.cont-code
              AND mloan-acct.since <= iDate 
              AND mloan-acct.acct = ENTRY(1,mAcct)               
        NO-LOCK NO-ERROR.
    END.
    ELSE DO:
       RUN RE_L_ACCT in h_Loan (iContr,
                                iCont-Code,
                                GetMainAcctRole(iContr,iCont-Code), 
                                iDate,
                                BUFFER mloan-acct).
    END.

    IF AVAILABLE mloan-acct THEN DO:
        FIND FIRST oAcct OF mloan-acct NO-LOCK NO-ERROR.
        oRole = mloan-acct.acct-type.
    END.
    RETURN.

END PROCEDURE.


PROCEDURE Get_Roled_Loan_Acct.
    DEF INPUT  PARAMETER iContr     AS CHAR NO-UNDO.
    DEF INPUT  PARAMETER iCont-code AS CHAR NO-UNDO.
    DEF INPUT  PARAMETER iDate      AS DATE NO-UNDO.
    DEF INPUT  PARAMETER iARole     AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER oRole      AS CHAR NO-UNDO.
    DEF PARAM BUFFER oAcct FOR acct.

    DEF BUFFER mloan FOR loan.
    DEF BUFFER mloan-acct FOR loan-acct.

    DEF VAR mBegDate AS DATE NO-UNDO.
    DEF VAR mEndDate AS DATE NO-UNDO.
    DEF VAR mRole AS CHAR NO-UNDO.
    DEF VAR mAcct AS CHAR NO-UNDO.

    FIND FIRST mloan WHERE mloan.contract = iContr AND
                           mloan.cont-code = iCont-code 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE mLoan THEN RETURN.

    FIND LAST mloan-acct WHERE 
              mloan-acct.contract  =  mloan.contract
          AND mloan-acct.cont-code =  mloan.cont-code
          AND mloan-acct.since     <= iDate
          AND mloan-acct.acct-type = iARole
    NO-LOCK NO-ERROR.

    IF AVAILABLE mloan-acct THEN DO:
        FIND FIRST oAcct OF mloan-acct NO-LOCK NO-ERROR.
        oRole = mloan-acct.acct-type.
    END.
    RETURN.

END PROCEDURE.







PROCEDURE Get_Current_Loan_Acct_bal.
    DEF INPUT PARAMETER iContr     AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iCont-code AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iDate      AS DATE NO-UNDO.
    DEF INPUT PARAMETER iBranch    AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iARole     AS CHAR NO-UNDO. /* �᫨ ஫� �� 㪠���� - �㤥� 
                                                       �᪠�� ��� �� �᭮���� ���㠫쭮� ஫�,
                                                       �᫨ 㪠���� - �� 㪠������ */
    DEF OUTPUT PARAMETER obal-rub  AS DEC  NO-UNDO.
    DEF OUTPUT PARAMETER obal-val  AS DEC  NO-UNDO.
    DEF OUTPUT PARAMETER oAcct     AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER oARole    AS CHAR NO-UNDO. /* ����� ஫� � १���� ����稫���? */
    
    DEF BUFFER mloan FOR loan.
    DEF BUFFER mloan-acct FOR loan-acct.
    DEF BUFFER macct FOR acct.
    DEF BUFFER mkau FOR kau.

    DEF VAR mKauSurr AS CHAR NO-UNDO. /*��� �㡮��⪠*/
    DEF VAR mDb AS DEC NO-UNDO. /*�����誠*/
    DEF VAR mCr AS DEC NO-UNDO. /*�����誠*/
    DEF VAR mtmp-dec1 AS DEC NO-UNDO.
    DEF VAR mtmp-dec2 AS DEC NO-UNDO.

  DEF VAR mtmp-dec3 AS DEC NO-UNDO.
    DEF VAR mtmp-dec4 AS DEC NO-UNDO.
    DEF VAR mtmp-dec5 AS DEC NO-UNDO.
    DEF VAR mtmp-dec6 AS DEC NO-UNDO.


    IF iARole = "" OR iARole = ? THEN 
       RUN Get_Current_Loan_Acct (iContr,
                                  iCont-code,
                                  iDate,
                                  OUTPUT oARole,
                                  BUFFER macct).
    ELSE RUN Get_Roled_Loan_Acct (iContr,
                                  iCont-code,
                                  iDate,
                                  iARole,
                                  OUTPUT oARole,
                                  BUFFER macct).
    IF NOT AVAILABLE mAcct THEN
        RETURN.
    IF macct.branch-id NE iBranch THEN RETURN.

    IF iContr = "dps" THEN
    DO:
/* ������� �㯮 �� ����� , ������� �ਢ�� �����⨪� */
           run acct-pos IN h_base (mAcct.acct, mAcct.currency, iDate, iDate, ?).
           obal-val = IF mAcct.currency = ''
               THEN ABSOLUTE(sh-bal)
               ELSE ABSOLUTE(sh-val).
                    
/*        IF NOT CAN-FIND(FIRST loan-transaction WHERE  loan-transaction.contract = iContr    
                                                 AND loan-transaction.cont-code = iCont-code
                                               NO-LOCK)
        THEN DO:
            mKauSurr = iContr + ',' + iCont-code + ','.
            obal-val = 0. */
            /*���� �� �ᥬ ����⠬ �⮣� ������ ���⮪ + ��業�� (�� ࠧ���塞)*/
/*            FOR EACH mkau WHERE mkau.acct = macct.acct AND 
                                mkau.currency =  macct.currency AND
                                mkau.kau BEGINS mKauSurr
                                NO-LOCK:
                RUN kau-pos.p( macct.acct,
                               macct.currency,
                               iDate  ,
                               iDate  ,
                               gop-status,
                               mkau.kau ).
*/
						/*	
                obal-val  = obal-val + ABSOLUTE( IF mAcct.currency EQ '' 
                                                 THEN ksh-bal 
                                                 ELSE ksh-val ).
               ��஥
              */
/*                  obal-val  = obal-val + IF mAcct.currency EQ ''
                                                 THEN ksh-bal 
                                                 ELSE ksh-val. 
*/
                /*������� ���襢 � �裡 ���� ��業�, ����� ᪫��뢠���� */
/*            END.*/ /*for each*/
/*            obal-val  = ABSOLUTE(obal-val).
        END.
        ELSE DO:
          RUN get-kauost-trans(iContr,
                               iCont-code,
                               "*",
                               "",
                               mAcct.acct,
                               mAcct.currency,
                               "��₪���",
                               iDate,
                               iDate,
                               gop-status,
                               OUTPUT obal-val
                              ).          
          obal-val = ABS(obal-val).
        END.
*/
    END. /*dps*/
    ELSE DO:


		if oARole = "�।��" then
		 DO:  run acct-pos IN h_base (mAcct.acct, mAcct.currency, iDate, iDate, ?).
           obal-val = IF mAcct.currency = ''THEN ABSOLUTE(sh-bal) ELSE ABSOLUTE(sh-val). 

                end.

		if oARole = "�।��" then
		 DO:  run acct-pos IN h_base (mAcct.acct, mAcct.currency, iDate, iDate, ?).
           obal-val = IF mAcct.currency = ''THEN ABSOLUTE(sh-bal) ELSE ABSOLUTE(sh-val). end.

		if oARole = "�।�" then
		 DO:  run acct-pos IN h_base (mAcct.acct, mAcct.currency, iDate, iDate, ?).
           obal-val = IF mAcct.currency = ''THEN ABSOLUTE(sh-bal) ELSE ABSOLUTE(sh-val). end.

		if oARole = "�।�1" then
		 DO:  run acct-pos IN h_base (mAcct.acct, mAcct.currency, iDate, iDate, ?).
           obal-val = IF mAcct.currency = ''THEN ABSOLUTE(sh-bal) ELSE ABSOLUTE(sh-val). end.

		if oARole = "�।��" then
		 DO:  run acct-pos IN h_base (mAcct.acct, mAcct.currency, iDate, iDate, ?).
           obal-val = IF mAcct.currency = ''THEN ABSOLUTE(sh-bal) ELSE ABSOLUTE(sh-val). end.

		if oARole = "�।��%�" then
		 DO:  run acct-pos IN h_base (mAcct.acct, mAcct.currency, iDate, iDate, ?).
           obal-val = IF mAcct.currency = ''THEN ABSOLUTE(sh-bal) ELSE ABSOLUTE(sh-val). end.

		if oARole = "�।��%" then
		 DO:  run acct-pos IN h_base (mAcct.acct, mAcct.currency, iDate, iDate, ?).
           obal-val = IF mAcct.currency = ''THEN ABSOLUTE(sh-bal) ELSE ABSOLUTE(sh-val). end.


    END.

    ASSIGN 
    obal-rub = IF mAcct.currency = ''
               THEN obal-val
               ELSE CurToBase ("����",
                               mAcct.currency,
                               iDate,
                               obal-val)
    oAcct = macct.acct.
END PROCEDURE.


/* ������஢����� ��楤�� ��� ���᪠ ���⪠ �� ����   */ 
PROCEDURE Get_Current_Loan_Acct_bal_ext.
    DEF INPUT PARAMETER iContr     AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iCont-code AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iDate      AS DATE NO-UNDO.
    DEF INPUT PARAMETER iBranch    AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iARole     AS CHAR NO-UNDO. /* ���� = �।��, ��易⥫쭮! */
    DEF INPUT PARAMETER iBadAcct   AS CHAR NO-UNDO.                                                   
    DEF OUTPUT PARAMETER obal-rub  AS DEC  NO-UNDO.
    DEF OUTPUT PARAMETER obal-val  AS DEC  NO-UNDO.
    DEF OUTPUT PARAMETER oAcct     AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER oARole    AS CHAR NO-UNDO.
    
    DEF BUFFER mloan FOR loan.
    DEF BUFFER mloan-acct FOR loan-acct.
    DEF BUFFER macct FOR acct.
    DEF BUFFER mkau FOR kau.
  
    
    FIND FIRST mloan WHERE mloan.contract = iContr AND
                           mloan.cont-code = iCont-code 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE mLoan THEN RETURN.

/* message "inside Get_rolled_loan_ext:"  mLoan.contract mLoan.cont-code iARole iDate iBadAcct VIEW-AS ALERT-BOX. */

    FIND FIRST mloan-acct WHERE 
              mloan-acct.contract  =  mloan.contract
          AND mloan-acct.cont-code =  mloan.cont-code
          AND mloan-acct.acct-type = "�।��"
    NO-LOCK NO-ERROR.

    IF AVAILABLE mloan-acct THEN DO:
         FIND FIRST mAcct OF mloan-acct NO-LOCK NO-ERROR.
         oARole = mloan-acct.acct-type.
    END.

    IF NOT AVAILABLE mAcct THEN
        RETURN.
    IF macct.branch-id NE iBranch THEN RETURN.

		if oARole = "�।��" then
		 DO: 
		  run acct-pos IN h_base (mAcct.acct, mAcct.currency, iDate, iDate, ?).
          obal-val = IF mAcct.currency = ''THEN ABSOLUTE(sh-bal) ELSE ABSOLUTE(sh-val). 
         END.

    ASSIGN 
    obal-rub = IF mAcct.currency = ''
               THEN obal-val
               ELSE CurToBase ("����",
                               mAcct.currency,
                               iDate,
                               obal-val)
    oAcct = macct.acct.
END PROCEDURE.







/* --------------------------------------------------------------------
** GetAddress - ����祭�� ���ᮢ 䨧.���
**              
** ��ࠬ����:
**   oAdress   - ���� 䨧.���
**   oAdressPU - ��᫥���� ������ ���� ���⮢��� 㢥��������
** --------------------------------------------------------------------*/
PROCEDURE GetAddress:
   DEFINE INPUT PARAMETER iType_address AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER iPersId       AS INT NO-UNDO.
   DEFINE OUTPUT PARAMETER oAdressPU AS CHARACTER NO-UNDO.

   DEFINE VARIABLE vKodRegPUChar   AS CHARACTER INIT "" NO-UNDO.
   DEFINE VARIABLE vissue          AS CHARACTER INIT "" NO-UNDO.
   DEFINE VARIABLE vcust-code-type AS CHARACTER INIT "" NO-UNDO.
   DEFINE VARIABLE vcust-code      AS CHARACTER INIT "" NO-UNDO.
   DEFINE VARIABLE vcust-type-num  AS INTEGER   INIT 0  NO-UNDO.
   DEFINE VARIABLE vFind           AS LOGICAL   INIT FALSE NO-UNDO.

   ASSIGN oAdressPU = ""
   .

   /* ��᫥���� ���� ���⮢��� 㢥�������� */
   FOR EACH cust-ident WHERE cust-ident.cust-cat       = "�"
                       AND   cust-ident.cust-id        = iPersId 
                       AND   cust-ident.cust-code-type = iType_address
                       AND   cust-ident.open-date LE datablock.End-Date
                       AND   (cust-ident.close-date EQ ? 
                              OR cust-ident.close-date EQ DATE("") 
                              OR cust-ident.close-date GT datablock.End-Date)
                       NO-LOCK
                       BY  cust-ident.open-date DESC:

            ASSIGN vissue          = cust-ident.issue
                   vcust-code-type = cust-ident.cust-code-type
                   vcust-code      = cust-ident.cust-code
                   vcust-type-num  = cust-ident.cust-type-num
                   vFind = TRUE
            .
            LEAVE.
   END.

   IF vFind THEN DO:
      ASSIGN vKodRegPUChar = GetXattrValue ("cust-ident",vcust-code-type + "," + vcust-code + "," + STRING (vcust-type-num),"������")
		     oAdressPU 	  = vissue
      		 ENTRY (1, oAdressPU) = ENTRY (1, oAdressPU) 		/* ��⠢�塞 � ���� ��� ॣ���� */
			     	      + "," + getCodeName ("������", vKodRegPUChar) 
	  .

      IF NUM-ENTRIES(oAdressPU) < 9 THEN
         	oAdressPU = oAdressPU + FILL(",",9 - NUM-ENTRIES(oAdressPU)).

  /*    ENTRY (7, oAdressPU) = ENTRY (7, oAdressPU) + "," .  ��⠢�塞 � ���� ��஥���, �ᥣ�� ���� */
   END.
   ELSE oAdressPU =  "".

   RETURN.

END PROCEDURE.


PROCEDURE Get_DogDateANDPlast_Acct.
    DEF INPUT PARAMETER iAcct             AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iLoan_Cont-code   AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iLoan_Class-code  AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER oAcct_DogDate    AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER oAcct_DogPlast   AS CHAR NO-UNDO.

    DEF BUFFER rAcct FOR acct.
    DEF BUFFER rLoan FOR loan.
    DEF BUFFER rLoan-acct FOR loan-acct.
    DEF BUFFER tLoan FOR loan.

    DEF VAR  rLoanParent  AS CHAR INIT "" NO-UNDO.

/*for test*/
oAcct_DogDate  = "-" . 
oAcct_DogPlast = "1" .

	FIND FIRST rAcct WHERE rAcct.acct = iAcct NO-LOCK NO-ERROR.
	FIND FIRST rLoan WHERE rLoan.cont-code = iLoan_Cont-code AND rLoan.class-code = iLoan_Class-code NO-LOCK NO-ERROR.
	FIND FIRST rLoan-acct WHERE rLoan-acct.acct = iAcct NO-LOCK NO-ERROR.


	IF (NOT AVAILABLE rLoan) OR (NOT AVAILABLE rAcct) THEN RETURN.

	IF NOT(CAN-DO("loan_trans_ov,loan-tran-lin,loan_trans_diff",TRIM(rLoan.class-code))) THEN
	  DO:

		oAcct_DogPlast = GetXattrValueEx("acct",STRING(rAcct.acct + "," + rAcct.currency),"DogPlast","").		
		IF oAcct_DogPlast = "" THEN
			oAcct_DogPlast = GetEntries(2,GetXattrValueEx("acct",STRING(rAcct.acct + "," + rAcct.currency),"��������",""),",","").
		IF oAcct_DogPlast = "" THEN  
			oAcct_DogPlast = rLoan.cont-code.

		oAcct_DogDate = GetXattrValueEx("acct",STRING(rAcct.acct + "," + rAcct.currency),"DogDate","").		
		IF oAcct_DogDate = "" THEN
			oAcct_DogDate = getxattrvalueex("loan",string(rLoan.contract + "," + rLoan.cont-code),"��⠑���",""). 
		IF oAcct_DogDate = "" THEN  
			oAcct_DogDate = STRING(rLoan.open-date) .

		IF rLoan.cont-code BEGINS "��" THEN
		DO:
			oAcct_DogPlast = rLoan.cont-code.
			oAcct_DogDate = STRING(rLoan.open-date) .
		END.

	  END.

		/* �� �࠭蠬 ��� � ����� ������ ���-� �ᮡ� �������, ���⮬� ���� ��� ⠪�� ��᮪ */
	IF CAN-DO("loan_trans_ov,loan-tran-lin,loan_trans_diff",TRIM(rLoan.class-code)) THEN
	  DO:

		/* �饬 �墠�뢠�騩 ������� */
		IF NUM-ENTRIES(rLoan.cont-code," ") = 2 THEN
			rLoanParent = ENTRY(1,rLoan.cont-code," ") .

		FIND FIRST tLoan WHERE tLoan.cont-code = rLoanParent NO-LOCK NO-ERROR.

		oAcct_DogPlast = GetXattrValueEx("acct",STRING(rAcct.acct + "," + rAcct.currency),"DogPlast","").		
		IF oAcct_DogPlast = "" THEN
			oAcct_DogPlast = GetEntries(2,GetXattrValueEx("acct",STRING(rAcct.acct + "," + rAcct.currency),"��������",""),",","").
		IF oAcct_DogPlast = "" THEN  
			oAcct_DogPlast = tLoan.cont-code  .

		oAcct_DogDate = GetXattrValueEx("acct",STRING(rAcct.acct + "," + rAcct.currency),"DogDate","").		
		IF oAcct_DogDate = "" THEN
			oAcct_DogDate = getxattrvalueex("loan",string(tLoan.contract + "," + tLoan.cont-code),"��⠑���",""). 
		IF oAcct_DogDate = "" THEN  
			oAcct_DogDate = STRING(tLoan.open-date) .
		IF oAcct_DogDate = "" THEN  
			oAcct_DogDate = STRING(rLoan.open-date) .

		IF rLoan.cont-code BEGINS "��" THEN
		DO:
			oAcct_DogPlast = rLoanParent.
			oAcct_DogDate = STRING(rLoan.open-date) .
		END.

	  END.


END PROCEDURE.


PROCEDURE Get_PersonInfo.
    DEF INPUT  PARAMETER  iPersId   AS INT NO-UNDO.

    DEF OUTPUT PARAMETER  outFIO       AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outDocument  AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outPhone     AS CHAR NO-UNDO.

    DEF OUTPUT PARAMETER  outUNKg      AS CHAR NO-UNDO. /*����*/
    DEF OUTPUT PARAMETER  outIndex     AS CHAR NO-UNDO.   
    DEF OUTPUT PARAMETER  outGorod     AS CHAR NO-UNDO.  
    DEF OUTPUT PARAMETER  outStreet    AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outDom       AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outKorpus    AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outKvart     AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outRayon     AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outSeria     AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outNumDoc    AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outKem_Vid   AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outDate_vid  AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outEmail     AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outKodReg    AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outCountry     AS CHAR NO-UNDO.

    DEF OUTPUT PARAMETER  outAdress    AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outAdressPos AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outadr_uved  AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outadr_fakt  AS CHAR NO-UNDO.

    DEF OUTPUT PARAMETER  outStroenie  AS CHAR NO-UNDO.

    DEF OUTPUT PARAMETER  outKodDoc    AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER  outKodDD     AS CHAR NO-UNDO.


    DEF BUFFER prperson FOR person.


    FIND FIRST prperson WHERE prperson.person-id = iPersId  NO-LOCK NO-ERROR.

    ASSIGN
      outFIO = prperson.name-last + " " +  prperson.first-names 
      outDocument = IF prperson.document  = ?  THEN ""  ELSE prperson.document 
      outPhone = IF prperson.phone[1] = ? THEN "" ELSE prperson.phone[1] 
      outUNKg =   GetXattrValueEx("person",STRING(prperson.person-id),"���","")
      outIndex =  GetXattrValueEx("person",string(prperson.person-id),"Address1Indeks","")
      outGorod =  GetXattrValueEx("person",string(prperson.person-id),"Address2Gorod","")
      outStreet = GetXattrValueEx("person",string(prperson.person-id),"Address3Street","")
      outDom =    GetXattrValueEx("person",string(prperson.person-id),"Address4Dom","")
      outKorpus = GetXattrValueEx("person",string(prperson.person-id),"Address5Korpus","")
      outKvart =  GetXattrValueEx("person",string(prperson.person-id),"Address6Kvart","")
      outRayon =  GetXattrValueEx("person",string(prperson.person-id),"Address6Rayon","")
      outSeria  =  GetXattrValueEx("person",string(prperson.person-id),"Document1Ser_Doc","")
      outNumDoc =  GetXattrValueEx("person",string(prperson.person-id),"Document2Num_Doc","")
      outKem_Vid = REPLACE (GetXattrValueEx("person",string(prperson.person-id),"Document3Kem_Vid",""),"~n"," ")
      outDate_vid = GetXattrValueEx("person",string(prperson.person-id),"Document4Date_vid","")
      outEmail = GetXattrValueEx("person",string(prperson.person-id),"e-mail","")
      outKodReg   = getXAttrValueEx ("person",STRING (prperson.person-id),"������",getXAttrValue ("person",STRING (prperson.person-id),"���������"))	
      outCountry = prperson.country-id	 
    NO-ERROR.

    outAdress = (IF  prperson.address[1] = ? THEN "" ELSE prperson.address[1]) + " " +
              (IF  prperson.address[2] = ? THEN "" ELSE prperson.address[2]).
 
    ENTRY (1, outAdress) = IF outKodReg eq "00000"   THEN ENTRY (1, outAdress) + "," + outKodReg  ELSE ENTRY (1, outAdress) + "," + getCodeName ("������", outKodReg).

   /* 
   VNE 01/06/2009
   ��室�� ���⮢� ���� �� ����᭮�� �������: ���砫� �饬 � ����� "�������", 
   � ��砥 ��� ������⢨� "�������", �᫨  ��� ⮦� ���� - ��६ ��� ४ "���⮆��".
   �᫨ ��᫥ ���� ������ ��祣� �� ��������� � ���ࠩ�� �㤥� ���� ���� 
   ॣ����樨 � ����⢥ ���� ��� ���⮢�� 㢥�������� 
   */

   ASSIGN 
     outAdressPos = ""
     outadr_uved = ""
     outadr_fakt = ""	
   .

   RUN GetAddress(INPUT "�������", iPersId, OUTPUT outadr_uved).
   RUN GetAddress(INPUT "�������", iPersId, OUTPUT outadr_fakt).
   IF outadr_uved NE "" THEN outAdressPos = outadr_uved.
   ELSE  IF outadr_fakt NE "" THEN outAdressPos = outadr_fakt.	

   IF outAdressPos = "" THEN outAdressPos =  outAdress .

   IF  ENTRY (1, outAdress) =  "000000"   THEN ENTRY (1, outAdress) = "" .
   IF  CAN-DO("00000,0",ENTRY(2, outAdress))   THEN ENTRY (2, outAdress) = outCountry .

   IF  ENTRY (1, outAdressPos) =  "000000"   THEN ENTRY (1, outAdressPos) = "" .
   IF  CAN-DO("00000,0",ENTRY(2, outAdressPos))   THEN ENTRY (2, outAdressPos) = outCountry .

   /*
   �஢�ઠ ��� ��� - � ��砥 �᫨ ��� ॣ���� = ���� ��த� (�� ��୮ ⮫쪮 
   ��� ��᪢� � ����) � ���� ��� ��த� �� ����� 
   ����� ������ ���⠬� �뢮� ��஥��� � ����� �������.
   */

   IF NUM-ENTRIES (outAdress) GE 4 THEN IF ENTRY (2, outAdress) =  ENTRY (4, outAdress)  THEN ENTRY (4, outAdress) = "" .
   IF NUM-ENTRIES (outAdress) = 10 THEN 
   DO:
      outStroenie = TRIM(ENTRY(10, outAdress)).
      ENTRY(10, outAdress) = ENTRY(9, outAdress).
      ENTRY(9, outAdress) = outStroenie.
   END.

   IF NUM-ENTRIES (outAdressPos) GE 4 THEN IF ENTRY (2, outAdressPos) =  ENTRY (4, outAdressPos)  THEN ENTRY (4, outAdressPos) = "" .
   IF NUM-ENTRIES (outAdressPos) EQ 10 THEN 
   DO:
      outStroenie = TRIM( ENTRY(10, outAdressPos)).
      ENTRY(10, outAdressPos) = ENTRY(9, outAdressPos).
      ENTRY(9, outAdressPos) = outStroenie.
   END.


   IF outKem_Vid = "" then 
       outKem_Vid = replace(string(trim(prperson.issue)),"~n"," ")  + " �� " + trim(outDate_vid). 

   outKodDD = GetCodeEx ("�������",prperson.document-id,"").
   if outKodDD ="21" then outKodDoc="1".
   if outKodDD ="03" then outKodDoc="2".
   if outKodDD ="04" then outKodDoc="3".
   if outKodDD ="27" then outKodDoc="3".
   if outKodDD ="07" then outKodDoc="4".
   if outKodDD ="10" then outKodDoc="6".
   if outKodDD ="12" then outKodDoc="9".
   if outKodDD ="13" then outKodDoc="12".
   if outKodDD ="14" then outKodDoc="13".
   if outKodDD ="01" then outKodDoc="14".
   if outKodDD ="22" then outKodDoc="14".
   

END PROCEDURE.