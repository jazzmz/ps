/*�� ��� 3306. ��楤�� ��� �ନ஢���� ��-ᮮ�饭�� �� ������������ �����⮢ �� �।��� ������ࠬ �� */

{globals.i}

MESSAGE "������ ���� ����襭��" VIEW-AS ALERT-BOX.
{getdate.i &DateLabel  = "��� ����襭��"} /*����訢��� ���� "�� ������ ��ࠢ�塞 ��*/

{lshpr.pro}           /* �����㬥��� ��� ���� ��ࠬ��஢ ������� */

{loan_par.def
    &new = new} /* ��ࠬ���� ������� �� ����� �����뢠���� ��業�� */


{tmprecid.def}

def var vClassList AS CHAR INIT "l_agr_with_diff" NO-UNDO.
def var vContract  as CHAR INIT "�।��" NO-UNDO.

def var i as int init 0 NO-UNDO.
def var enddate as date no-undo.
enddate = end-date.
def var cPhone as CHAR NO-UNDO.

def var temp0 as dec NO-UNDO.
def var temp4 as dec NO-UNDO.
def var temp7 as dec NO-UNDO.
def var temp8 as dec NO-UNDO.
def var temp10 as dec NO-UNDO.
def var temp33 as dec NO-UNDO.


def var smstpl as char no-undo.
def var cursms as char no-undo.
def var count as int init 0 no-undo.
def var cCur as char no-undo.
def var oAcct as TAcct no-undo.
def var oAcct2 as TAcct no-undo.
def var dAmt-all as dec no-undo.

def buffer bloan for loan.
def buffer bloan-acct for loan-acct.

def var oTable as TTable.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* ���稪 ������஢ */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* ��饥 ������⢮ ������஢ */	 

DEF VAR proc-name AS CHAR 	NO-UNDO.
DEFINE NEW SHARED STREAM err.
def var btok as logical init yes no-undo.
def var DoExport as logical init no no-undo.


def temp-table loan-sms NO-UNDO
         field cont-code like loan.cont-code
         field name-last as CHAR
         field gender like person.gender   /*�᫨ ��� = � ���᪨�, �� - ��᪮�*/
         field first-names as CHAR
         field phone as CHAR
         field cur   as char
         field p0    as dec
         field p4    as dec
         field p7    as dec
         field p8    as dec
         field p10   as dec
         field p33   as dec
         field p29   as dec
         field p48   as dec
         field nev   as dec
         field amt-all as dec
         field dDate as Date
         field sms as CHAR
         INDEX icont-code IS PRIMARY cont-code
         INDEX iSms sms.

def temp-table loan-set-attr NO-undo
         field cont-code like loan.cont-code
         field contract  like loan.contract 
         field dDate     as DATE 
         INDEx cont-code IS PRIMARY cont-code.


FUNCTION GetParVal RETURNS DECIMAL (
                                 INPUT iContract as char, INPUT iCont-code as char, INPUT iPar as int, INPUT iDate as Date
				):

def var dT1 as dec NO-UNDO.
def var dT2 as dec NO-UNDO.
def var temp as dec INIT 0 NO-UNDO.

               RUN STNDRT_PARAM(iContract, iCont-code, iPar, iDate, OUTPUT temp, OUTPUT dT1, OUTPUT dT2).

               if temp < 0 then message "����⥫�� ��ࠬ��� " iPar " �� �������� " iCont-code " �� ���� " iDate VIEW-AS ALERT-BOX. 
              
               RETURN temp.
               
END FUNCTION.

PROCEDURE CalcLoan.
DEF INPUT PARAMETER cCont-code as char no-undo.
DEF INPUT PARAMETER cContract as char no-undo.

DEF VAR dDate as Date no-undo.
DEF VAR dPrevDate as Date no-undo.
def buffer bfrLoan2 for loan.

      /*��⠥� �� �� ��������, ��� �⮣� ������뢠�� �� ���� �����饣� � ⥪�饩 ��� �࠭� */ 
   dPrevDate = DATE(GetXAttrValue("loan",cContract + "," + cCont-code,"SMSPrevSend")). /*��� ������襣� ����襭�� �࠭� �� ���ன ��ࠢ�﫨 ��*/

   find first bfrloan2 where bfrloan2.cont-code begins ENTRY(1, cCont-code," ")
                        and bfrloan2.contract = cContract
                        and bfrloan2.end-date >  TODAY 
                        and bfrloan2.end-date <= enddate 
                        and bfrloan2.class-code = "loan_trans_diff"
                        and NOT can-find(first loan-var of bfrloan2 where loan-var.amt-id EQ 0  and loan-var.balance = 0) 
                        NO-LOCK NO-ERROR.
   
   if (available bfrloan2)  then 
      DO:
/*        if dPrevDate <> bfrloan2.end-date then  /*�஢��塞 �� ��ࠢ�﫨 �� �� 㦥 �� �� �⮩ ��� ����襭��*/*/
        DO:
          dDate = bfrloan2.end-date. 
/*          if dDate > TODAY then        */
           DO:
          for each bfrLoan2 where bfrLoan2.cont-code begins ENTRY(1,cCont-code," ")
                              and bfrLoan2.contract = cContract
                              and bfrloan2.class-code = "loan_trans_diff"
                              and bfrLoan2.close-date = ?
                            NO-LOCK.

                  if bfrloan2.since <> dDate then
                  DO:
                     {get_meth.i  'Calc' 'loanclc'}

                
                     RUN VALUE(proc-name + ".p") (bfrloan2.contract,
                                                  bfrloan2.cont-code,
                                                  dDate).

                  END.

                      if bfrloan2.end-date <= dDate then 
                                   loan-sms.p0          =  loan-sms.p0  + GetParVal(bfrloan2.contract,bfrloan2.cont-code,0,dDate).   /*���⮪ ��筮� ������������*/

                                   loan-sms.p4          =  loan-sms.p4  + GetParVal(bfrloan2.contract,bfrloan2.cont-code,4,dDate) + bfrloan2.interest[1].   /*�᭮��� ��業�� */
                                   loan-sms.p7          =  loan-sms.p7  + GetParVal(bfrloan2.contract,bfrloan2.cont-code,7,dDate).   /*����祭�� ������ �।�⢠ */
                                   loan-sms.p8          =  loan-sms.p8  + GetParVal(bfrloan2.contract,bfrloan2.cont-code,8,dDate) + bfrloan2.interest[2].   /*���. %% �� �����. ������ �।�⢠  */
                                   loan-sms.p10         =  loan-sms.p10 + GetParVal(bfrloan2.contract,bfrloan2.cont-code,10,dDate).  /* */
                                   loan-sms.p33         =  loan-sms.p33 + GetParVal(bfrloan2.contract,bfrloan2.cont-code,33,dDate).  /* */
                                   loan-sms.p29         =  loan-sms.p29 + GetParVal(bfrloan2.contract,bfrloan2.cont-code,29,dDate).  /* */
                                   loan-sms.p48         =  loan-sms.p48 + GetParVal(bfrloan2.contract,bfrloan2.cont-code,48,dDate).  /* */    
                                   loan-sms.nev         =  loan-sms.nev + GetParVal(bfrloan2.contract,bfrloan2.cont-code,13,dDate) + GetParVal(bfrloan2.contract,bfrloan2.cont-code,14,dDate)  + GetParVal(bfrloan2.contract,bfrloan2.cont-code,16,dDate)  + GetParVal(bfrloan2.contract,bfrloan2.cont-code,34,dDate) + bfrloan2.interest[6].  /* �� �� 㯠�� �� "�� ���᭥���" */    

        END.
        loan-sms.dDate = dDate.    
        END.
      END.
   END.                          

END PROCEDURE.


/*���뢠�� ��㧥� � �⮡࠭�묨 ������ࠬ�*/

 {empty tmprecid}

DO TRANSACTION:


 RUN browseld.p ("loan_allocat",
                "class-code"  + CHR(1) +
                "contract"    + CHR(1) + "RidRest"    
                ,
                vClassList    + CHR(1) +
                vContract     + CHR(1) + "yes" 
                ,
                "",
                2).

if  lastkey <> 10 then return.

END.
 

MESSAGE "�뢮���� ᮮ�饭�� �� ����������� ������ ⥫�䮭�� ��� ��ࠢ��?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE BtOk. 


{init-bar.i "��ࠡ�⪠ ������஢"}

/* ����⠫� ��饥 ���-�� */
for each tmprecid, first loan where RECID(loan) EQ tmprecid.id NO-LOCK:
    vLnTotalInt = vLnTotalInt + 1.
end.


		RUN SetSysConf IN h_base ("NoProtocol","YES").
	        RUN SetSysConf IN h_base ("PUT-TO-TMESS","").
                {setdest.i &stream="stream err" &filename='_spool_recalc.tmp' &append = "APPEND"}

for each tmprecid,                                               /*����� ��⠥� �� �� ����� � ��� 㦥 ����*/
   first loan where RECID(loan) = tmprecid.id NO-LOCK.

   {move-bar.i vLnCountInt vLnTotalInt}


   find first loan-sms where loan-sms.cont-code = ENTRY(1,loan.cont-code," ") NO-LOCK NO-ERROR.
   if not available loan-sms then
      do: 
          find first person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.
          /*�饬 ����� �����*/
          find first loan-acct where loan-acct.acct-type = "�।����" 
                                 and loan-acct.contract = loan.contract 
                                 and loan-acct.cont-code = ENTRY(1,loan.cont-code," ")
                                 and loan-acct.since <= enddate
                                 NO-LOCK NO-ERROR.
          IF NOT AVAILABLE loan-acct then message "�� ������ ����� ��� �� �������� " loan.cont-code " �� ���� " String(enddate) VIEW-AS ALERT-BOX.
          find first bloan-acct where bloan-acct.contract begins "card"
                                  and bloan-acct.acct-type begins "SCS@"
                                  and bloan-acct.acct = loan-acct.acct
                                  NO-LOCK NO-ERROR.
          IF NOT AVAILABLE bloan-acct then message "�� ������ ������� ����⨪���� ����� ��� �� " loan.cont-code " �� ���� " String(enddate) VIEW-AS ALERT-BOX.
          find last bloan where bloan.contract = "card"
                             and bloan.parent-cont-code = bloan-acct.cont-code
                             and bloan.parent-contract = bloan-acct.contract
                             and bloan.loan-status = "���"
                             NO-LOCK NO-ERROR.
          cPhone = "".
          if available bloan then cPhone = GetXAttrValue("loan","card," + bloan.cont-code,"CliMobPhone").


          if BTOk and cPhone = "" then MESSAGE "�� ������ ⥫�䮭 ������ �� �������� " loan.cont-code "��� ��ࠢ�� ��" VIEW-AS ALERT-BOX.
          dAmt-all = 0.
          for each loan-acct where (loan-acct.acct-type = "�।��"
                                or loan-acct.acct-type = "�।��")
                                and loan-acct.contract = loan.contract
                                and loan-acct.cont-code = loan.cont-code
                                and loan-acct.since <= TODAY 
                                NO-LOCK.
             oAcct = new TAcct(loan-acct.acct).       
             dAmt-all = dAmt-all + oAcct:GetLastPos2Date(TODAY).
             DELETE OBJECT oAcct.
          END.


          CREATE loan-sms.
          ASSIGN 
                loan-sms.cont-code   = ENTRY(1,loan.cont-code," ")
                loan-sms.name-last   = person.name-last 
                loan-sms.first-names = person.first-names
                loan-sms.phone       = cPhone
                loan-sms.cur         = loan.currency 
                loan-sms.gender      = person.gender
                loan-sms.p0          =  0
                loan-sms.p4          =  0
                loan-sms.p7          =  0
                loan-sms.p8          =  0
                loan-sms.p10         =  0
                loan-sms.p33         =  0
                loan-sms.p29         =  0
                loan-sms.p48         =  0
	        loan-sms.nev         =  0
                loan-sms.amt-all     =  dAmt-all
                loan-sms.sms         = ""
                .


      end.   /*ᮧ���� ����� ��ப� � ⥬�-⥩��*/



                RUN CalcLoan(loan.cont-code,loan.contract).


       
       IF loan-sms.phone <> "" and (loan-sms.p0 + loan-sms.p4 + loan-sms.p7 + loan-sms.p8 + loan-sms.p10 + loan-sms.p33 + loan-sms.p29 + loan-sms.p48 + loan-sms.nev) <> 0 THEN 
       DO:
          CREATE loan-set-attr.
          ASSIGN
                loan-set-attr.cont-code = loan.cont-code
                loan-set-attr.contract = loan.contract.
                loan-set-attr.dDate = loan-sms.dDate.
       END.



      vLnCountInt = vLnCountInt + 1.


end.

	 	RUN DeleteOldDataProtocol IN h_base ("PUT-TO-TMESS").
		RUN DeleteOldDataProtocol IN h_base ("NoProtocol").



  DO TRANSACTION:
    RUN browseld.p ("code",
                    "class"   + CHR(1) + "parent",
                    "PIRSMSTPL" + CHR(1) + "PIRSMSTPL",
                    "",
                    1).


    IF KEYFUNCTION(LASTKEY) = "END-ERROR" OR pick-value = ? THEN RETURN.

  END.

    FIND FIRST code WHERE code.class  = "PIRSMSTPL" 
                      AND code.parent = "PIRSMSTPL" 
                      AND code.code   = pick-value NO-LOCK.

    smstpl = code.val.

oTable = new TTable(8).

  oTable:addRow().
  oTable:addCell("").
  oTable:addCell("����� �������").
  oTable:addCell("��� ������").
  oTable:addCell("����䮭 ��� ��ࠢ�� ��").
  oTable:addCell("��� ��㤭�� �����������").
  oTable:addCell("��� ������襣� ����襭��").
  oTable:addCell("�㬬� ������襣� ����襭��").
  oTable:addCell("����� ᮮ�饭��"). 
  oTable:colsWidthList="3,10,25,11,15,10,15,56".

for each loan-sms where loan-sms.dDate <> ?:

    CASE loan-sms.cur:
     WHEN "810" THEN cCur = "RUR".
     WHEN ""    THEN cCur = "RUR".     
     WHEN "840" THEN cCur = "USD".     
     WHEN "978" THEN cCur = "EUR".     
    END CASE.
    IF (loan-sms.p0 + loan-sms.p4 + loan-sms.p7 + loan-sms.p8 + loan-sms.p10 + loan-sms.p33 + loan-sms.p29 + loan-sms.p48) = 0 THEN NEXT.
/*    IF loan-sms.phone = "" THEN NEXT.*/

    /*� ����� ���� ���塞 � 蠡���� � �� ��� �㦭� :)*/

    cursms = smstpl.
    cursms = REPLACE(cursms,"#first-names#",loan-sms.first-names). 
    cursms = REPLACE(cursms,"#gender#",(IF loan-sms.gender then "�" ELSE "��")). 
    cursms = REPLACE(cursms,"#DATE-SEND#",STRING(TODAY)).
    cursms = REPLACE(cursms,"#amt-all#",TRIM(STRING(loan-sms.amt-all,"->>>,>>>,>>>,>>9.99"))). 
    cursms = REPLACE(cursms,"#cur#",cCur). 
    cursms = REPLACE(cursms,"#end-date#",STRING(loan-sms.dDate)).
    cursms = REPLACE(cursms,"#amt-now-all#",TRIM(STRING(loan-sms.p0 + loan-sms.p4 + loan-sms.p7 + loan-sms.p8 + loan-sms.p10 + loan-sms.p3 + loan-sms.p29 + loan-sms.p48 + loan-sms.nev,"->>>,>>>,>>>,>>9.99"))).

    loan-sms.sms = cursms.
  i = i + 1.
  oTable:addRow().
  oTable:addCell(i).
  oTable:addCell(loan-sms.cont-code).
  oTable:addCell(loan-sms.name-last + " " + loan-sms.first-names).
  oTable:addCell(loan-sms.Phone).
  oTable:addCell(loan-sms.amt-all).
  oTable:addCell(loan-sms.dDate).
  oTable:addCell(loan-sms.p0 + loan-sms.p4 + loan-sms.p7 + loan-sms.p8 + loan-sms.p10 + loan-sms.p33 + loan-sms.p29 + loan-sms.p48 + loan-sms.nev).
  oTable:addCell(loan-sms.sms).

end.

/*����� ������ �� �����*/
{setdest.i}
   PUT UNFORMATTED "���� � �����⮢�� ��ࠢ�� ��� �� ������ࠬ ��. ��� ����᪠: " STRING(TODAY) + " " + STRING(TIME,"HH:MM:SS") SKIP.
  oTable:show().
  PUT UNFORMATTED SKIP.
{preview.i}
/*����� ������ ������ �� �����*/

DELETE OBJECT oTable.


MESSAGE "���㧨�� ᮮ�饭�� ��� ��ࠢ��?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE DoExport. 

if DoExport then DO:
/*����� � ����.*/

def var BranchCOde as char NO-UNDO.
def var PathExp as char NO-UNDO.
def var daynum as int NO-UNDO.


BranchCOde = FGetSetting("PIRCard ","BranchCode","0198").
PathExp = FGetSetting("PIRCard ","PathExp","./").
daynum = TODAY - DATE(01,01,YEAR(TODAY)) + 1.

/*message PathExp + "SMS_LIST" + BranchCOde + "in" + "99." + STRING(daynum,"999") VIEW-AS ALERT-BOX.*/

OUTPUT TO VALUE(PathExp + "SMS_LIST" + BranchCOde + "in" + "99." + STRING(daynum,"999")) CONVERT TARGET "1251".



for each loan-sms where loan-sms.sms <> "":
IF loan-sms.phone = "" THEN NEXT.
    count = count + 1.
 PUT UNFORMATTED loan-sms.phone + "     " + loan-sms.sms SKIP.
end.

 PUT UNFORMATTED "Total:" + STRING(count,"999999") SKIP.
END.






