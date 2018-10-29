{tmprecid.def}
{ttreestr.def}

DEF VAR currDate AS DATE.

FOR EACH tmprecid,
   FIRST op-entry WHERE recid(op-entry) EQ tmprecid.id  NO-LOCK,
    FIRST op OF op-entry NO-LOCK:

            CREATE TTReestr.
            ASSIGN TTReestr.doc-num    =  op.doc-num 
				 TTReestr.op-status = op.op-status
            			 TTReestr.amt-rub    =  op-entry.amt-rub
            			 TTReestr.acct       =  op-entry.acct-db
            			 TTReestr.ben-acct   =  op.ben-acct
            			 TTReestr.order-pay  =  op.order-pay
            			 TTReestr.inn        =  op.inn
            			 TTReestr.name-ben   =  op.name-ben
            			 TTReestr.op         =  op-entry.op
            			 TTReestr.details    =  op.details				 
            .
  currDate = op-entry.op-date.

END. /* FOR EACH */

{setdest.i}

{pir-chkexp665.i}

{preview.i}

/*** äéçÖñ #665 ***/
