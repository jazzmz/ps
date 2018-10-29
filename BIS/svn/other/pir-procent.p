/*
���������     : SStepanov 16/08/11 PIR_LOAN_PERCENT_NEW ���� ��ਮ�� ������
�१ �������� 9 (���������=4 � �������=6)
*/

{globals.i}
{ulib.i}
{getdates.i}


   DEFINE VAR out_Result            AS DECIMAL                NO-UNDO.

{tmprecid.def}
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
   def var oTable AS TTable.
   def var oAcct AS TAcct.
   def var role AS CHAR.
   def var PredSumma AS DEC.
   DEF VAR mainLoan AS CHARACTER NO-UNDO.
   DEF BUFFER bLoan for Loan.
   /** ���� ���� ��業⮢ 365/366 */

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* ���稪 ������஢ */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* ��饥 ������⢮ ������஢ */


   begDate = beg-date.
   endDate = end-date.
   
/*   message begDate endDate VIEW-AS ALERT-BOX.*/

   {setdest.i}

{init-bar.i "��ࠡ�⪠ ������஢"}

for each tmprecid, first Bloan where RECID(Bloan) EQ tmprecid.id NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.

     PUT UNFORMATTED STRING(TODAY) SKIP.
     PUT UNFORMATTED "��砫� ��ਮ��: "  STRING(begDate) SKIP.
     PUT UNFORMATTED "����� ��ਮ��: "  STRING(endDate) SKIP.

FOR EACH tmprecid,
    first bloan where RECID(bloan) EQ tmprecid.id NO-LOCK.
     oTable = new TTable(7).

         /* ������ ��ப� - �������� ࠡ��� ����� */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }

   begDate = end-date - 45.
   endDate = end-date.


                 oTable:AddRow().
             oTable:AddCell("����� �������").
             oTable:AddCell("��砫� ��ਮ��").
             oTable:AddCell("����� ��ਮ��").
             oTable:AddCell("�㬬� �� ��ਮ�").
             oTable:AddCell("�㬬� ����").
             oTable:AddCell("���� ����������").
             oTable:AddCell("���").


   FIND FIRST loan WHERE loan.contract = bloan.contract
                     and loan.cont-code = bloan.cont-code
                     NO-LOCK NO-ERROR.


/* �஢��塞 �뫮 �� ����襭�� ��業⮢ �� ����� ��ਮ� */
   /*message begDate endDate SUBSTRING(loan.cont-code,1,9) VIEW-AS ALERT-BOX.*/
   find last loan-int
  	where (loan-int.id-k = 6) /* ���������=4 � �������=6 ��� �������� 9 */
	  and (loan-int.id-d = 4)

	  and loan-int.cont-code = SUBSTRING(loan.cont-code,1,9)
	  and loan-int.op-date >= begDate 
	  and loan-int.op-date <= endDate 
	NO-LOCK NO-ERROR.

   if AVAILABLE(loan-int) then do:
     PUT UNFORMATTED "�뫮 ����襭�� ��業⮢ " loan-int.op-date SKIP.
     begDate = loan-int.op-date.
   end.

/* �஢��塞 �뫠 �� ᬥ�� ��⥣�ਨ ����⢠ */
   def var startCQ AS DEC.
   def var endCQ AS DEC.
   find first comm-rate where commission begins "���" and kau = "�।��," + loan.cont-code and comm-rate.since >= begDate and comm-rate.since <= endDate NO-LOCK NO-ERROR.
   if AVAILABLE(comm-rate) then do:
      startCQ = comm-rate.rate-comm.
      find last comm-rate where commission begins "���" and kau = "�।��," + loan.cont-code and comm-rate.since >= begDate and comm-rate.since <= endDate NO-LOCK NO-ERROR.
      endCQ = comm-rate.rate-comm.
      if startCQ <> endCQ then do:
      message "���� ����� ��" VIEW-AS ALERT-BOX.

      find last comm-rate where comm-rate.rate-comm = startCQ and commission begins "���" and kau = "�।��," + loan.cont-code and comm-rate.since >= begDate and comm-rate.since <= endDate NO-LOCK NO-ERROR.
      begdate = comm-rate.since.
      if startCQ > 50 then role = "�।�". else role = "�।��".
      find first loan-acct where loan-acct.cont-code = loan.cont-code and loan-acct.acct-type = role and loan-acct.contract = loan.contract.
      if available (loan-acct) then do:
      oAcct = new tAcct(loan-acct.acct).
      PredSumma = oAcct:getlastpos2date(enddate).
      delete object oAcct.
      end.
      end.
   end.


/*   IF NOT AVAIL loan THEN DO:
      RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� '" + iContract + "." + iContCode + "' �� ������!").
      RETURN.
   END.*/

   mainLoan = GetMainLoan_ULL(loan.contract, loan.cont-code, false).
   
/*   begDate = iBegDate. endDate = iEndDate.*/
/*   message begDate endDate VIEW-AS ALERT-BOX.                                */
   periodBegin = MAX(begDate, loan.open-date).
   /** � ����� ����� ��� ����砭�� �࠭� �������� �� ��室��� ����,
       ��� ����砭�� ��ਮ�� ���� ��業⮢ ������ ���� ᫥���騬 ࠡ�稬 ����.
       �����, ����� ��ࠦ���� 
   periodEnd = MIN(endDate, loan.end-date).
       �믮���� ���⮥ ��c������
   */
   periodEnd = endDate. 
  /* message periodbegin view-as alert-box.*/
   /** ���祭�� "��" ��ਮ�� */
   balance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, periodBegin - 1, false).
/*   if balance = 0 then GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, periodBegin, false).
   message balance VIEW-AS ALERT-BOX.*/
   rate = GetLoanCommission_ULL(ENTRY(1, mainLoan), ENTRY(2, mainLoan), "%�।", periodBegin, false).
   
   /** �������� �� ��� */
   DO iDate = periodBegin TO periodEnd:
/*           message iDate balance newBalance VIEW-AS ALERT-BOX.*/
/*         IF loan.since < iDate THEN DO:
                 RUN Fill-SysMes("","", "-1", "PirLoanPercent: ������� " + loan.contract + "." + loan.cont-code + 
                                 " �� �����⠭ �� ���� " + STRING(periodEnd)).
                 RETURN.  
         END.             */

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
/*            message iDate VIEW-AS ALERT-BOX.          */
     IF balance <> newBalance OR rate <> newRate OR (DAY(iDate + 1) = 1 AND iDate < periodEnd) 
        OR iDate = periodEnd THEN
       DO:
             periodEnd = iDate.
             periodBase = (IF TRUNCATE(YEAR(iDate) / 4,0) = YEAR(iDate) / 4 THEN 366 ELSE 365).
/*             period = periodEnd - periodBegin + 1.    */
             period = periodEnd - periodBegin.            
             summa = round(balance * rate / periodBase * period, 2).
                 totalSumma = totalSumma + summa.
             oTable:AddRow().
                oTable:AddCell(loan.cont-code).
             oTable:AddCell(periodBegin).
             oTable:AddCell(periodEnd).
             oTable:AddCell(summa).
             oTable:AddCell(totalsumma).
             oTable:AddCell(balance).
             oTable:AddCell(period).

                 /* � ��砥 �᫨ �㬬������ 㬥��訫��� ����� �� ��業�� ����襭�, ����塞 �� ��業�� ����� ���⠫� �� �⮣�!   */
                 IF newBalance < balance THEN totalSumma = 0 .
                                             
/*             IF iNeedMon THEN */
/*             RUN Fill-SysMes("","", "1", "PirLoanPercent: " +
                                                                         "loan = " + loan.contract + "." + loan.cont-code + 
                                         ", balance = " + ST                RING(balance) + 
                                         ", rate = " + STRING(rate) + 
                                         ", periodBase = " + STRING(periodBase) +
                                         ", period = " + STRING(period) + "(" + STRING(periodBegin) + " - " + STRING(periodEnd) + ")" +
                                         ", summa = balance * rate / periodBase * period = " + STRING(summa) +        
                                         ", totalSumma = " + STRING(totalSumma)).*/
                                         

/*                 periodBegin = periodEnd + 1.*/
                 periodBegin = periodEnd.
                 periodEnd = MIN(endDate, loan.end-date).
                 balance = newBalance.
                 rate = newRate.         
       END.
   END. 


/*if  totalSumma <> 0 then */
 do:   
 oTable:show().
   PUT UNFORMATTED "��業�� � �뭮�� �� ������:" STRING(totalSumma - predSumma) SKIP.
   PUT UNFORMATTED "��業�� �� ������/���������:" STRING(predSumma) SKIP.
 end.
   PUT UNFORMATTED SKIP.
   DELETE OBJECT oTable.
           vLnCountInt = vLnCountInt + 1.
   
   out_Result = totalSumma.
   totalSumma = 0.
/*   message totalSumma VIEW-AS ALERT-BOX.*/
/*   is-ok = 0.*/
end.
   {preview.i}

{intrface.del}
