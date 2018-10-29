{globals.i}
{getdate.i}   
{tmprecid.def}
{filleps.def}           /* ������� ��.⠡���� ttReportTable */
{intrface.get strng}
{intrface.get date}
{intrface.get tmess}
{get-bankname.i}

   /* Function Prototypes */
FUNCTION ToCP1251    RETURNS CHAR PRIVATE (INPUT iStr  AS CHAR) FORWARD.
FUNCTION ReplChars   RETURNS CHAR PRIVATE (INPUT iStr  AS CHAR) FORWARD.
FUNCTION ReplChars$ RETURNS CHAR PRIVATE (INPUT iStr  AS CHAR) FORWARD.
FUNCTION AmntToStrng RETURNS CHAR PRIVATE (INPUT iAmnt AS DEC ) FORWARD.

def TEMP-TABLE ReportTable LIKE ttReportTable.
def var otchDate as date no-undo.
DEF VAR outfile AS char NO-UNDO.
DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR strTable AS CHAR EXTENT 10 NO-UNDO.
DEF VAR count AS int init 0 NO-UNDO.
DEF VAR oClient AS TClient NO-UNDO.
DEF VAR oLoan AS TLoan NO-UNDO.
def var cur as CHAR NO-UNDO.
def var cVariants AS CHAR INIT "�।��� �������,�������⥫쭮� ᮣ��襭��,������� ������,�����������" NO-UNDO.
def var dopsogl as char no-undo.
def var DateZalog as DATE NO-UNDO.
def var temp as char INIT "" NO-UNDO.
def var temp1 as char INIT "" NO-UNDO.
def var temp2 as char INIT "" NO-UNDO.
def var tempost as dec no-undo.
DEF VAR mRegim      AS CHAR NO-UNDO.
def var i as int INIT 1 no-undo.
def var j as int INIT 1 no-undo.
otchDate = end-date.

def var blankvar as char INIT "" no-undo.

DEF BUFFER loan FOR loan.
oSysClass = new TSysClass().

PROCEDURE AddCom.
    
    DEF INPUT PARAMETER iAtt as CHAR NO-UNDO.
    DEF INPUT PARAMETER iTpl as CHAR NO-UNDO.


         temp2 = GetXAttrValueEx("loan",loan.contract + "," + loan.cont-code,iAtt,?).


         if temp2 <> ? then 
         do:
            if NUM-ENTRIES(temp2) = 2 then 
               do:
                  find last reportTable where reportTable.tf_payment-date <= DATE(ENTRY(2,temp2)).
                  tempost = reportTable.tf_rest-debts.        

	          oTpl:AddAnchorValue(iTpl,ENTRY(1,temp2)).
		  CREATE ReportTable.
	          ASSIGN 
			ReportTable.tf_payment-date = DATE(ENTRY(2,temp2))
			ReportTable.tf_additional-charges = DEC(ENTRY(1,temp2)).
                        ReportTable.tf_rest-debts = tempost.
               end.
         end.
	 else oTpl:AddAnchorValue(iTpl,blankvar).

END PROCEDURE.




FOR EACH tmprecid,
    FIRST loan WHERE tmprecid.id = RECID(loan) NO-LOCK:
         count = 0.
         strTable = "".
            /* �����⮢�� ������ */
         oClient = new TClient(loan.cust-cat,loan.cust-id).
         oLoan = new TLoan(RECID(loan)).

         mRegim = GetXAttrValueEx("loan",loan.contract + "," + loan.cont-code,"�����",?).
         IF (mRegim EQ "�����������") OR (mRegim EQ "����뤇��") OR  (mRegim EQ "����������" ) THEN temp1 = "-kredlin". else temp1 = "".

RUN Fill-SysMes IN h_tmess ("","",3,"�롥�� ⨯ ���� ��� ������� " + loan.cont-code + "|" + cVariants).
if INT(pick-value) = 0 then RETURN.
CASE ENTRY(INT(pick-value),cVariants,","):
   WHEN "�।��� �������" THEN DO:
                                    oTpl = new TTpl("pir-psk" + temp1 + ".tpl").
                                    oTpl:splitter = "|".
                                    end-date = loan.open-date.
				    temp = "kred".
				 END.

   WHEN "�������⥫쭮� ᮣ��襭��" THEN DO:
					PAUSE 0.
					/** ������ ���� � ������� �� ���짮��⥫� ;) */
		                        end-date = TODAY.
					DISPLAY end-date LABEL "��� ���.ᮣ��襭��" SKIP
						dopsogl  LABEL "����� ���.ᮣ��襭��"
					WITH FRAME fSet OVERLAY CENTERED SIDE-LABELS.
					SET end-date dopsogl WITH FRAME fSet.
					HIDE FRAME fSet.	

                                        oTpl = new TTpl("pir-psk-dopsogl" + temp1 + ".tpl").
                                        oTpl:splitter = "|".
				        oTpl:AddAnchorValue("DopSogl",dopsogl).
				        oTpl:AddAnchorValue("DateDopSogl",end-date).
					temp = "dopsogl".
				 END.
   WHEN "������� ������" THEN    DO:
					PAUSE 0.
					/** ������ ���� � ������� �� ���짮��⥫� ;) */
		                        end-date = TODAY.
					DISPLAY DateZalog LABEL "��� ������� ������" SKIP
						dopsogl  LABEL "����� ������� ������"
					WITH FRAME fSet1 OVERLAY CENTERED SIDE-LABELS.
					SET DateZalog dopsogl WITH FRAME fSet1.
					HIDE FRAME fSet1.	

                                        oTpl = new TTpl("pir-psk-zalog" + temp1 + ".tpl").
                                        oTpl:splitter = "|".
                                        oTpl:AddAnchorValue("DopSogl",dopsogl).
				        oTpl:AddAnchorValue("DateDopSogl",DateZalog).
				        temp = "zalog".
				 END.

   WHEN "�����������" THEN DO:
                                    oTpl = new TTpl("pir-psk-uved" + temp1 + ".tpl").
                                    oTpl:splitter = "|".
                                    end-date = loan.open-date.
				    temp = "uved".
				 END.

END CASE.

/*�஢��塞 �।�� � ��� ��� �।�⭠� �����*/



         IF (mRegim EQ "�����������") OR  (mRegim EQ "����뤇��") OR  (mRegim EQ "����������" )THEN
         DO:
            oTpl:AddAnchorValue("loan.type","���ᨬ���� �।��� �����:").
         END.
         ELSE
	 DO:
            oTpl:AddAnchorValue("loan.type","�㬬� �।��:").
	 END.

         case loan.currency:
	     WHEN "" THEN cur = "�㡫�".
	     WHEN "840" THEN cur = "������� ���".
	     WHEN "978" THEN cur = "���".
	     WHEN "926" THEN cur = "���".
	 END CASE.
         oTpl:AddAnchorValue("BankName",cBankName).
         oTpl:AddAnchorValue("dDate",otchDate).
         oTpl:AddAnchorValue("loan.cont-code",loan.cont-code).
         oTpl:AddAnchorValue("DateSogl",oLoan:GetXattr("��⠑���")).
         oTpl:AddAnchorValue("cName",oClient:name-short).
         oTpl:AddAnchorValue("loan.cur",cur).
         oTpl:AddAnchorValue("loan.open-date",loan.open-date).
         oTpl:AddAnchorValue("loan.end-date",loan.end-date).

         oTpl:AddAnchorValue("loan.long",ROUND( (loan.end-date - loan.open-date) / 30,0)).

                                  
         find first comm-rate where comm-rate.since <= end-date
				and comm-rate.commission = "%�।"
				and comm-rate.kau = loan.contract + "," + loan.cont-code
				NO-LOCK NO-ERROR.
	 if available comm-rate then  oTpl:AddAnchorValue("loan.rate",STRING(comm-rate.rate-comm,">>9.99") + "%").
	 else message "�� ������� �⠢�� %�। �� ���� " end-date VIEW-AS ALERT-BOX.

         find first comm-rate where comm-rate.since <= end-date
				and comm-rate.commission = "���ᯊ"
				and comm-rate.kau = loan.contract + "," + loan.cont-code
				NO-LOCK NO-ERROR.
	 if available comm-rate then oTpl:AddAnchorValue("rate.kredn",STRING(comm-rate.rate-comm,">>9.99") + "%"). else oTpl:AddAnchorValue("rate.kredn","").


         {empty ttReportTable}                        /* ��⮢�� �६����� ⠡���� ��� ������� */
         {empty ReportTable}                          /* ��⮢�� �६����� ⠡���� ��� ������� */

         RUN filleps.p (loan.contract,                /* �����祭�� ������� */
                        loan.cont-code,               /* ����� ������� */
                        end-date,                     /* ��� */
                        OUTPUT TABLE ttReportTable).  /* �६����� ⠡��� ���� */
         find first ttReportTable NO-LOCK.
	 
         oTpl:AddAnchorValue("loan.amount",ABS(ttReportTable.tf_rest-debts)).

/* ��� �㤥� ࠡ�� � ⥬�-����� :) */
         for each ttReportTable by ttReportTable.tf_id:
             if  {holiday.i ttReportTable.tf_payment-date} then ttReportTable.tf_payment-date = PrevWorkDay(ttReportTable.tf_payment-date).
             find first ReportTable where ttReportTable.tf_payment-date = ReportTable.tf_payment-date NO-ERROR.
	     if available reportTable then /*�᫨ ��ப� � ⠪�� ��⮩ 㦥 ����, � ���� �㬬��㥬 ���祭��. */
		do:
		   ASSIGN
		   ReportTable.tf_sum-percent = ReportTable.tf_sum-percent + ttReportTable.tf_sum-percent 
		   ReportTable.tf_basic-sum-loan = ReportTable.tf_basic-sum-loan + ttReportTable.tf_basic-sum-loan
                   ReportTable.tf_additional-charges = ReportTable.tf_additional-charges + ttReportTable.tf_additional-charges.
                   if  ReportTable.tf_rest-debts = 0 then ReportTable.tf_rest-debts = ttReportTable.tf_rest-debts.
		end.
	     else 
		do:  /* ���� �����㥬 ��ப�*/
		   BUFFER-COPY ttReportTable TO ReportTable.
		end.	
         END.

         blankvar = "0.00".



         RUN AddCom("���-�業��","rate.ocenka").
         RUN AddCom("���-���客����","rate.insuriance").
         RUN AddCom("���-������","rate.note").
         RUN AddCom("���-���","rate.other").

         oTpl:AddAnchorValue("rate.vidacha",blankvar).
         oTpl:AddAnchorValue("rate.vedenie",blankvar).
         oTpl:AddAnchorValue("rate.rassmotr",blankvar).
         oTpl:AddAnchorValue("rate.rko",blankvar).

         FOR EACH ReportTable
         BY ReportTable.tf_id:
         count = count + 1.

         if ReportTable.tf_sum-percent = ? then ReportTable.tf_sum-percent = 0.
	 if ReportTable.tf_basic-sum-loan = ? then ReportTable.tf_basic-sum-loan = 0.
	 if ReportTable.tf_additional-charges = ? then ReportTable.tf_additional-charges = 0.
	 if ReportTable.tf_rest-debts = ? then ReportTable.tf_rest-debts = 0.
         if ReportTable.tf_actual-payment = ? then ReportTable.tf_actual-payment = 0.


         if length (strTable[i]) > 31500 then i = i + 1.
         strTable[i] = strTable[i] +
                 "  <Row ss:AutoFitHeight=""0"" ss:Height=""15.75"">" + CHR(10) +
                 "   <Cell ss:Index=""2"" ss:StyleID=""s51""><Data ss:Type=""DateTime"">" + oSysClass:DATETIME2STR(ReportTable.tf_payment-date,"%Y-%m-%d")+ "</Data></Cell>" + CHR(10) + 
                 "   <Cell ss:StyleID=""s52""><Data ss:Type=""Number"">" + AmntToStrng(ReportTable.tf_sum-percent + ReportTable.tf_basic-sum-loan + ReportTable.tf_additional-charges + ReportTable.tf_actual-payment) + "</Data></Cell>" + CHR(10) +
                 "   <Cell ss:StyleID=""s52""><Data ss:Type=""Number"">" + AmntToStrng(ReportTable.tf_sum-percent) + "</Data></Cell>" + CHR(10) +
                 "   <Cell ss:StyleID=""s52""><Data ss:Type=""Number"">" + (IF (ReportTable.tf_basic-sum-loan > 0) THEN AmntToStrng(ReportTable.tf_basic-sum-loan) ELSE AmntToStrng(0)) + "</Data></Cell>" + CHR(10) +
                 "   <Cell ss:StyleID=""s52""><Data ss:Type=""Number"">" + AmntToStrng(ReportTable.tf_additional-charges + ReportTable.tf_actual-payment) + "</Data></Cell>" + CHR(10) +
                 "   <Cell ss:StyleID=""s52""><Data ss:Type=""Number"">" + AmntToStrng(ReportTable.tf_rest-debts) + "</Data></Cell>" + CHR(10) +
                 "  </Row> " + CHR(10).

	  END.

     do j = 1 to 10:
        oTpl:AddAnchorValue("Table" + STRING(j),strTable[j]).
     end.

     oTpl:AddAnchorValue("count",count).
     oTpl:AddAnchorValue("count1",count + 2).
     outfile = ("/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/" + REPLACE(ReplChars$(ReplChars(GetMangledName(REPLACE(loan.cont-code,"$",CHR(1))))) ,CHR(1) ,"$" ) + "-" + temp + ".xls").
     OUTPUT TO VALUE(outfile) CONVERT TARGET "UTF-8".
     
     oTpl:show().

     OUTPUT CLOSE.

     MESSAGE "����� ��࠭�� � " SKIP outfile VIEW-AS ALERT-BOX.

     DELETE OBJECT oClient.
     DELETE OBJECT oTpl.
     DELETE OBJECT oLoan.

END.



/* ************************  Function Implementations ***************** */
   /* =====================================-=-==
   ** �������஢���� ��ப                   */
FUNCTION ToCP1251 RETURNS CHAR PRIVATE
  (INPUT iStr AS CHAR).
   RETURN CODEPAGE-CONVERT (iStr,  "1251", SESSION:CHARSET).
END FUNCTION.

   /* ==========================================-=-==
   ** ������ �����室��� ��� ����� 䠩�� ᨬ����� */
FUNCTION ReplChars RETURNS CHAR PRIVATE
  (INPUT iStr AS CHAR).
   DEF VAR vCharList1 AS CHAR NO-UNDO EXTENT 3 INIT [" ","-","/"].
   DEF VAR vCharList2 AS CHAR NO-UNDO INIT "_".
   DEF VAR vI         AS INT64  NO-UNDO.
   DO vI = 1 TO EXTENT(vCharList1):
      iStr = REPLACE(iStr, vCharList1[vI], vCharList2).
   END.
   RETURN iStr.
END FUNCTION.
FUNCTION ReplChars$ RETURNS CHAR PRIVATE
  (INPUT iStr AS CHAR).
   DEF VAR vCharList1 AS CHAR NO-UNDO INIT "$".
   DEF VAR vCharList2 AS CHAR NO-UNDO INIT "".
      iStr = REPLACE(iStr, vCharList1, vCharList2).
   RETURN iStr.
END FUNCTION.


   /* =====================================-=-==
   ** ������ ᨬ����� � �㬬��                */
FUNCTION AmntToStrng RETURNS CHAR PRIVATE
  (INPUT iAmnt AS DEC).
   DEF VAR vReplChar AS CHAR NO-UNDO.
   DEF VAR vAmnt     AS CHAR NO-UNDO.
   ASSIGN
      vAmnt     = STRING(iAmnt, "->>>>>>>>>>>>>>9.99")
/*      vReplChar = FGetSetting("���", "�����������", ".")   /* �������⥫� 楫�� � �஡��� ��� ��� ���㧪� � Excel */*/
      vReplChar = "."
      vAmnt     = IF vReplChar NE "." THEN REPLACE(vAmnt, ".", vReplChar) ELSE vAmnt
   .
   RETURN TRIM(vAmnt).
END FUNCTION.

DELETE OBJECT oSysClass.

{intrface.del}