{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{loan.pro}
{norm.i}

/* Add by Maslov D.
   ������ ������砥� �㭪�� ��।������
   ����� ������� �� ����� � ⠡���
*/
{pir-getdocnum.i}

DEF OUTPUT PARAMETER IRes AS DECIMAL NO-UNDO.
DEF INPUT PARAMETER iBegDate as DATE NO-UNDO.
DEF INPUT PARAMETER iEndDate as DATE NO-UNDO.
DEF INPUT PARAMETER iDogType as CHARACTER NO-UNDO.
DEF var loanclasses AS CHAR INIT "loan_allocat,loan_c,loan-transh,l_agr_with*" NO-UNDO.
DEF VAR symb AS char no-undo.
DEF VAR isReady2Close AS CHARACTER INITIAL ?  No-Undo.
DEF VAR oTAcct AS TAcct  No-Undo.
DEF VAR temp AS DEC INIT 0  No-Undo.
def var countVal as INT INIT 0 NO-UNDO.
def var countRUB as INT INIT 0 NO-UNDO.




def var showlog as logical init false  No-Undo.

symb = "-".

   put screen col 1 row 24 color bright-blink-normal 
       "��ࠡ��뢠���� ���� �।���� ������஢" +  STRING(" ","X(50)").

   FOR EACH loan  WHERE ( open-date LE iEndDate )
                    AND ( ( close-date GE iEndDate ) OR ( close-date EQ ? ) )  
		    AND (loan.contract = "�।��")
		    and CAN-DO(loanclasses,loan.class-code) 
           NO-LOCK :

 /* 
      Add By Maslov D. 
*/
     isReady2Close = getXAttrValue("loan",loan.contract + "," + getDocNum(BUFFER loan:HANDLE),"PirReady2Close").

/* �஢��塞 ���⮪ �� ��� � ஫�� �।�� � �।� � �।���, �᫨ ����� 0, � ������� ����襭, �� �।��稪� ���뫨 ������� ��� ���⠢��� ���.४*/
    IF (isReady2Close NE "��") and (loan.contract = "�।��")  THEN 
       DO:
       for each loan-acct where loan-acct.contract eq loan.contract and
                                ((loan-acct.cont-code begins loan.cont-code /*+ " "*/) /*or (loan-acct.cont-code = loan.cont-code)*/) and
                                loan-acct.since le iEndDate and 
			        (loan-acct.acct-type = "�।��" OR loan-acct.acct-type = "�।�" OR loan-acct.acct-type = "�।���" OR loan-acct.acct-type = "�।��" OR loan-acct.acct-type = "�।��%")
                no-lock.


 
                RUN acct-pos IN h_base (loan-acct.acct,
                              loan-acct.currency,
                              iEndDate,
                              iEndDate,
                              ?).

           temp = temp + sh-val + sh-bal.

/*                    if loan.cont-code = "113/11" then message isReady2Close  temp loan-acct.acct loan.cont-code VIEW-AS ALERT-BOX.*/

          if temp = 0 then isReady2Close = "��". else isReady2Close = "���".
/*�.�. ���ᥫ� � ��� ������� �� loan_allocat, �᪫�稬 �� �� ���� 514*/
          if can-do("514*,30233*",loan-acct.acct) then isReady2Close = "��".


       END.
	  temp = 0.
       END.            
                  
/*            if loan.cont-code = "113/11" then message "1 " isReady2Close   loan.cont-code VIEW-AS ALERT-BOX.*/


      put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

      CASE symb :                           
           WHEN "\\"  THEN symb = "|".
           WHEN "|"   THEN symb = "/".
           WHEN "/"   THEN symb = "-".
           WHEN "-"   THEN symb = "\\".
      END CASE.

/*          if loan.cont-code = "113/11" then message isReady2Close   loan.cont-code VIEW-AS ALERT-BOX.    */

   if (isReady2Close NE "��") then do:
/*       put unformatted Skip loan.cont-code " " loan.currency.    */

      if loan.currency = "" then countRub = countRub + 1. 
      if loan.currency <> "" then countVal = countVal + 1. 

   end.



  END. /* �᫨ ������� �� ����祭 � ������� */

/*PUT UNFORMATTED     ';��������            ���                  ���-�� ��.       ���-�� ���. '  SKIP.*/
/*PUT UNFORMATTED '���_�।���         ' TODAY '               ' count_rub_all_card ~ '           '  count_val_all_card SKIP.*/

/*put unformatted skip "���_�।���         " STRING(iEndDate,"99/99/99") '               ' STRING(countRub) '           ' STRING(countval).*/

CASE IDogType:
	WHEN "rub" THEN iRes = countRub.
	WHEN "val" THEN iRes = countval.
   END.
  
put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

RETURN "".
