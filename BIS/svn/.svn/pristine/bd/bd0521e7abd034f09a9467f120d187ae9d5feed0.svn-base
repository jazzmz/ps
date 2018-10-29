CREATE xentry.
ASSIGN
   xentry.acct-cat = op-entry.acct-cat
   xentry.acct-db = IF fullacct THEN adb ELSE SUBSTR(adb,1,8)
   xentry.acct-cr = IF fullacct THEN acr ELSE SUBSTR(acr,1,8)
/*   xentry.currency = IF op-entry.amt-cur <> 0 THEN op-entry.currency ELSE ""*/
   /* Бурягин изменил 23.01.2006 16:36 */
   xentry.currency = /* Стало: будет работать для валют 810,840,978*/ 
   	IF op-entry.currency <> "" THEN op-entry.currency ELSE MAX(adbcur,acrcur)
   /* Было: 
   xentry.currency = IF adbcur <> "" or acrcur <> "" THEN op-entry.currency ELSE "" 
   */
   xentry.doc-num = op.doc-num 
   xentry.doc-type = iscash
   /*xentry.amt     = op-entry.amt-rub*/
   xentry.amt     = IF op.acct-cat EQ 'd' THEN op-entry.qty ELSE op-entry.amt-rub
   xentry.debit   = IF op-entry.acct-db NE ? THEN op-entry.amt-rub ELSE 0
   xentry.credit  = IF op-entry.acct-cr NE ? THEN op-entry.amt-rub ELSE 0
   xentry.vamt    = op-entry.amt-cur
   xentry.op      = op.op
   xentry.polupr  = IF op-entry.acct-db EQ ? THEN "d"
                    ELSE IF op-entry.acct-cr EQ ? THEN "c" ELSE ""
   xentry.user-id = cur_user-id    
   xentry.refer   = {&bra}
   xentry.prnum = pr_num
   xentry.user-name = cur_user_name
   xentry.branch_p  = str_p
   xentry.is_poch = is_pochta
   xentry.op-date = op.op-date
   xentry.branch  = {&bra}
.

   /*** В ASSIGN нельзя использовать функцию ***/
   xentry.is_earch = INT64(getXAttrValue("op",STRING(op.op),"PirA2346U")) > 1000.
  

IF pr_num = 1 THEN xentry.refer = xentry.refer + "/" + n_asu.
ELSE IF pr_num = 3 THEN xentry.refer = n_asu.
