{globals.def}

if in-cat <> ? then do:
  {get-fmt.i &obj='" + in-cat + ""-Acct-Fmt"" + "' &nodeffmt=/*}  /**/
end.
ASSIGN
    op-entry.acct-db:format = fmt
    op-entry.acct-cr:format = fmt
.
case in-cat :
    when "d" then do:
        ASSIGN
            op-entry.currency:label  in frame edit = "��� ��"
            op-entry.currency:help   in frame edit = "��� 業��� �㬠��"
            op-entry.currency:format in frame edit = "x(12)"
            op-entry.amt-rub :label  in frame edit = "������⢮"
        .
    end.
end case.

on entry of frame edit do:
    ASSIGN
        op-entry.amt-rub:visible   = in-cat ne "d"
        op-entry.amt-cur:visible   = in-cat ne "d"
        op-entry.symbol:visible    = in-cat ne "d"
        op-entry.type:visible      = in-cat ne "d"
        op-entry.prev-year:visible = in-cat ne "d"
    .
end.

on leave, go of op-entry.currency in frame edit do:
    if (in-cat ne "d" and
    not can-find(currency where currency.currency = input op-entry.currency))
    then do:
        message "��� ⠪�� ������ � �ࠢ�筨��".
        bell.
        return no-apply.
    end.
    else if (in-cat eq "d" and
        not can-find(sec-code where sec-code.sec-code eq input op-entry.currency))
    then do:
        message "��� ⠪�� 業��� �㬠�� � �ࠢ�筨��".
        bell.
        return no-apply.
    end.
    /* �� �஢�ન ��諨 */
    assign op-entry.currency.
end.

on return of op-entry.op-cod in frame edit do:
  if in-cat eq "d"  then apply "go" to frame edit.
end.

/* ������� �㡫����� �������� */
on leave
of op-entry.value-date,
   op-entry.amt-cur
in frame edit do:

    if  op-entry.amt-cur ne 0 and
        (op-entry.value-date:modified or
         op-entry.amt-cur:modified)
    then display
        CurToBase ('����', op-entry.currency,
                    date(op-entry.value-date:screen-value),
                    decimal(op-entry.amt-cur:screen-value))
        @ op-entry.amt-rub
        with frame edit
    .
end.

ON LEAVE OF op-entry.acct-db ANYWHERE DO: /* ����஫� ��� �����               */
   {op-ened.trg "db" "������" "send"}  /* ����஫� ���४����� acct-db       */
END.

ON LEAVE OF op-entry.acct-cr ANYWHERE DO: /* ����஫� ��� �।��              */
  IF op.user-id<>"MCI" THEN DO:
   {op-ened.trg "cr" "�।���" "rec"}  /* ����஫� ���४����� acct-cr       */
  END.

   if lastkey eq 13                                               and
      can-find(acct where acct.acct     eq input op-entry.acct-db
                      and acct.currency eq "")                    and
      can-find(acct where acct.acct     eq input op-entry.acct-cr
                      and acct.currency eq "")                    then do:
      if can-find(first signs where signs.file-name eq "acct"
                                and signs.surrogate eq input op-entry.acct-db + ","
                                and signs.code      eq "sec-code") or
         can-find(first signs where signs.file-name eq "acct"
                                and signs.surrogate eq input op-entry.acct-cr + ","
                                and signs.code      eq "sec-code")
         then next-prompt op-entry.currency.
         else next-prompt op-entry.amt-cur.
   end.
END.

ON GO OF FRAME edit DO:
   DEFINE VARIABLE vDocTypeDig   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vOrderPay     AS INT64   NO-UNDO.
   DEFINE VARIABLE vCustNameLine AS CHARACTER NO-UNDO. 
   DEFINE VAR ans5               AS LOGICAL INITIAL yes NO-UNDO.

   RUN opentrs.p(ROWID(op-entry), INPUT INPUT op-entry.acct-db, INPUT INPUT op-entry.acct-cr, OUTPUT flager).

   IF flager NE 0 THEN
      RETURN no-apply.

/*********************************************
 * ����頥� ।���஢���� ���㬥�⮢       *
 * �� ���.				     *
 *********************************************
 *                                           *
 * ���: #692                              *
 * ����: ��᫮� �. �. Maslov D. A.          *
 * 					     *
 *********************************************/

IF LOGICAL(FGetSetting("PirChkop","DenyEditAuto","TRUE")) THEN DO:

   IF op.user-id EQ "BNK-CL" THEN DO:
	MESSAGE COLOR WHITE/RED  "��������� ������� ��������� ���������� �����������!!!"  
	VIEW-AS ALERT-BOX ERROR TITLE "�訡�� ���㬥�� #692".
	RETURN NO-APPLY.		
   END.
   IF op.user-id EQ "MCI" THEN DO:
	/*************************
         * ��� ��砩
	 *************************/

	IF NOT (op-entry.acct-db:modified 
		OR op-entry.amt-rub:modified 
		OR op.doc-num:modified
		OR op-entry.amt-cur:modified
		OR op-entry.qty:modified
		OR op-entry.symbol:modified
		OR op-entry.prev-year:modified
		OR op-entry.type:modified
	        ) THEN DO:

		/**************************
		 * ��ࠢ��� ⮫쪮 ��� �� ��
		 **************************/
		
		/* #2896 Sitov S.A. */
		IF NOT(REPLACE(op-entry.acct-cr:SCREEN-VALUE,"-","")=getXAttrValue("op",STRING(op.op),"acct-rec") 
		       OR CAN-DO(FGetSetting("PirChkOp","Pir2896List",""),REPLACE(op-entry.acct-cr:SCREEN-VALUE,"-",""))) THEN DO:

			MESSAGE COLOR WHITE/RED  "� ����� �� ������� ����������� �������� ���. ��������� acct-send ��� "  FGetSetting("PirChkOp","Pir2896List","")
			VIEW-AS ALERT-BOX ERROR TITLE "�訡�� ���㬥�� #692".

			RETURN NO-APPLY.		
		END. /* IF op-entry:acct-cr:SCREEN-VALUE */

	END. /* IF MODIFIED */
	ELSE DO:
		MESSAGE COLOR WHITE/RED "� ��������� �� ��� ����� ��������: \n * ���� ������� ��� ������ \n ��������� ��������� ���������!"
		VIEW-AS ALERT-BOX ERROR TITLE "�訡�� ���㬥�� #692".
		RETURN NO-APPLY.
	END.
   END. /* IF MCI */
END. /* IF FGetSetting */

   IF INPUT op-entry.currency NE "" AND INPUT op-entry.amt-cur NE 0 THEN DO:
      FIND LAST instr-rate WHERE instr-rate.instr-code EQ INPUT op-entry.currency
                             AND instr-rate.instr-cat  EQ "currency"
                             AND instr-rate.rate-type  EQ "�������"
                             AND instr-rate.since      LE DATE(op-entry.value-date:SCREEN-VALUE)
         NO-LOCK NO-ERROR.
      IF NOT AVAIL instr-rate THEN
         MESSAGE "���� ������" INPUT op-entry.currency "�� ��⠭����� !"
                 VIEW-AS ALERT-BOX WARNING.
      ELSE IF ROUND(INPUT op-entry.amt-cur * instr-rate.rate-instr / instr-rate.per,2)
               <> INPUT op-entry.amt-rub THEN DO:
         MESSAGE "{&in-CA-NCN}. �������� �� ᮮ⢥����� ⥪�饬� �����!" SKIP
                 "��⠭����� �ࠢ����?"
                 VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE ans5.
         IF ans5 = ? THEN RETURN NO-APPLY.
         IF ans5 THEN DO:
            DISPLAY INPUT op-entry.amt-cur * instr-rate.rate-instr /
                    instr-rate.per @ op-entry.amt-rub WITH FRAME edit.
            APPLY "entry" TO op-entry.amt-rub.
            RETURN NO-APPLY.
         END.
      END.
   END.

   {op-ened.trg "db" "������" "send"}  /* ����஫� ���४����� acct-db       */

  IF op.user-id<>"MCI" THEN DO:
   {op-ened.trg "cr" "�।���" "rec"}  /* ����஫� ���४����� acct-cr       */
  END.

   RUN GetDocTypeDigital IN h_op (op.doc-type, ?, OUTPUT vDocTypeDig).
   vOrderPay = INT64(op.order-pay) NO-ERROR.
   IF  vDocTypeDig <> "02"
   AND vDocTypeDig <> "06"
   AND (       (vOrderPay = ?)
        OR NOT (vOrderPay >= 1 AND vOrderPay <= 3)) THEN DO:
      {find-act.i
         &acct=op-entry.acct-db
         &curr=op-entry.currency
      }
      IF AVAILABLE acct THEN DO:
         RUN chk-blk.p (acct.cust-cat,acct.cust-id).
         IF RETURN-VALUE EQ "0" THEN DO:
            {getcustline.i &cust-cat = "acct.cust-cat" &cust-id = "acct.cust-id" &output-to = "vCustNameLine"}
            RUN Fill-SysMes IN h_tmess ("", "acct43", "", "%s=" + vCustNameLine + "%s=" + STRING(acct.number,GetAcctFmt(acct.acct-cat))).
            RETURN NO-APPLY.
         END.
      END.
   END.
   
   IF Chksgnopint(INPUT op.op) THEN DO:
      {message1
          &text    =  "���㬥�� ᮧ��� �࠭���樥� "" + STRING(op.op-kind) +  "",|�த������ ��������� (�㬬� ���㬥�� ����� 
          |�� ᮢ����� � �㬬�� �����ᨨ �� ���� 47423)?".
          &buttons = YES-NO}
      IF pick-value EQ "NO" THEN  RETURN NO-APPLY.
   END.

end.
