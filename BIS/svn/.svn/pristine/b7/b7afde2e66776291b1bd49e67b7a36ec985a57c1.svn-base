{pirsavelog.p}

{globals.i}
{getdates.i}
{setdest.i}

def var acctdb as char init "40817,42301,40820,42601,40802" no-undo.
def var acctcr as char init "20202" no-undo.
DEF var acct-com as char init "70601810000001210201,70601810300001210202" no-undo.
DEF var trans-com as char init "03010104,03010203,03010117,030101+y,030101+x,0301020+,03010202,030102+x,030101x1,030101i1,030102x1" no-undo.


def var details-yes as char init "*%*,*за получение нал*" no-undo.
def var details-no as char init "*пересчет*" no-undo.
def var sum as dec no-undo.
def var stcom as dec no-undo.
def var stsum as dec no-undo.
def var sumcom as dec no-undo.

def buffer bop for op.
def buffer bop1 for op.
def buffer bentry for op-entry.

def temp-table tCom NO-UNDO
	field tCom-entry as recid
	field tCom-op as recid
	field tDoc-entry as recid
	field tDoc-op as recid
	field opCount as integer
	field opdate as date
.



for each op-entry where op-entry.op-date >= beg-date and 
		  op-entry.op-date <= end-date and 
		  lookup(substring(op-entry.acct-db,1,5),acctdb) >0 and 
       		  lookup(op-entry.acct-cr,acct-com) >0 no-lock:

    Create tCom.
	tCom.tCom-entry = Recid(op-entry).
	tCom.opCount = 0.
    Find first op where op.op = op-entry.op no-lock. /* нашли док-т */
    tCom.tCom-op = Recid(op).
    tCom.opdate = op.op-date.

    If lookup(op.op-kind,trans-com) > 0 then do: 
       for each bop where bop.op-transaction = op.op-transaction and bop.op-status <> "А" no-lock: /* все док-ты созданные одной транзакцией */
           tCom.opCount = tCom.opCount + 1.
           for each bentry where bentry.op = bop.op and recid(bentry) <> tCom.tCom-entry no-lock:
             if lookup(substring(bentry.acct-db,1,5),acctdb) >0 and
		lookup(substring(bentry.acct-cr,1,5),acctcr) >0  then do:
		  tCom.tDoc-entry = Recid(bentry).
	        find first op where op.op = bentry.op no-lock.
	        tCom.tDoc-op = recid(op).
	     end.
	   end.
       end.

    End.
    else do:
	if tCom.opCount = 0 then do: /* документ создан другой транзакцией */


          /* проверить содержание и либо оставить либо удалить запись в ттэйбле */
          /* поискать расходную операцию с текущего счета */

        if  op.details matches details-no then do: /* документ чужой, пропускаем */
           delete tCom.
           next.
	end.
	Else do:
	  if op.details matches details-yes then do: /* содержание документа похоже на то что нужно */
		for each bentry where bentry.op-date = op-entry.op-date and
				bentry.acct-db = op-entry.acct-db and
				bentry.acct-cr matches "20202*" no-lock :
                   tCom.opCount = 1.
		end.
	  end. 
	end.
	end.	

	if tCom.opCount = 1 then do: /* один из документов был удален */
/*	
	дата из документа комиссии  
	счет из документа комисиии
	ищем проводки с этого счета в эту дату на 20202.
	усли нет ищем проводки на кассу по валютным счетам...
  еже ли будет нужно это можно будет сделать...:)	
	
*/
	end.	

    end.


end. 

Put unformatted "                Отчет по операциям взимания комиссии за снятие наличных денежных средств" skip
		"                                физическими лицами и предпринимателями" skip
		"                                    за период c " beg-date " по " end-date "." skip(2).
Put unformatted "┌─────────────────────────────────────────────────────┬─┬───────────────────────────────────────────────┐" skip.
Put unformatted "│          Данные документа снятия наличных           │ │       Данные документа списания комиссии      │" skip.                        
Put unformatted "├────────┬──────┬────────────────────┬───┬────────────┤ ├────────┬──────┬───────────────┬───────────────┤" skip.
Put unformatted "│        │      │                    │   │            │ │        │      │      ФАКТ     │     ТАРИФ     │" skip.
Put unformatted "│  Дата  │N Док.│         Счет       │Вал│   Сумма    │ │  Дата  │N Док.├─────┬─────────┼─────┬─────────┤" skip.
Put unformatted "│        │      │                    │   │            │ │        │      │% Ком│Сумма ком│% Ком│Сумма ком│" skip. 
Put unformatted "├────────┼──────┼────────────────────┼───┼────────────┼─┼────────┼──────┼─────┼─────────┼─────┼─────────┤" skip.

for each tCom no-lock by tcom.opdate :
   if tCom.opCount = 2 then do:
      find first op where recid(op) = tCom.tDoc-op no-lock.
      find first op-entry where Recid(op-entry) = tCom.tDoc-entry no-lock.
      stsum = 0.
      stcom = 0.
      /* рубли */
      if op-entry.currency = "" or op-entry.currency = ?  then do:
        sum = op-entry.amt-rub.
        if op.op-date < 04/26/06 and op.op-date >= 07/03/06 then do:
     	     stCom = 0.5.
	      end.
        else do:
          sum = op-entry.amt-rub.
		      if op.op-date >= 12/11/06 then do:
		        if op-entry.amt-rub < 1000000 then do:
		            stsum = round(sum / 100 * 0.5 , 2).
		            stcom = 0.5.
		        end.
		        if op-entry.amt-rub >= 1000000 and op-entry.amt-cur <= 3000000  then stsum = 5000 + round((sum - 1000000 )/ 100 * 0.4 , 2).
		        if op-entry.amt-rub > 3000000 then stsum = 13000 + round((sum - 3000000 )/ 100 * 0.3 , 2).
 		      end.
         if op.op-date < 12/11/06 then do:
	 	      if sum <= 600000 then stCom = 0.5.
		      if sum > 600000 and sum <=1000000 then stcom=1.
	        if sum > 1000000 and sum <= 2000000 then stcom = 2.
	        if sum > 2000000 and sum <= 3000000 then stcom = 3.
	        if sum > 3000000 and sum <= 4000000 then stcom = 4.
	        if sum > 4000000 then stcom = 5.
	       end.
	      end.
	      if stsum = 0 then stsum = round(sum / 100 * stcom,2).
      end.
      else do:
      /* валюта */
		    sum = op-entry.amt-cur.
		    if op.op-date >= 12/11/06 then do:
		      if op-entry.acct-db begins "40702" or 
		         op-entry.acct-db begins "40802" then
		         do:
		           stcom = 1.
		         end.
		      else do:
    		      if op-entry.amt-cur < 50000 then do: 
    		         stsum = round(sum / 100 * 0.5 , 2).
    		         stcom = 0.5.
    		      end.
		          if op-entry.amt-cur >= 50000 and op-entry.amt-cur <= 100000  then stsum = 250 + round((sum - 50000 )/ 100 * 0.4 , 2).
		          if op-entry.amt-cur > 100000 then stsum = 450 + round((sum - 100000 )/ 100 * 0.3 , 2).
		      end.
		      
		    end.

		    if stsum = 0 then stsum = round(sum / 100 * stcom,2).
	    end.

      /* выводим */
      put unformatted "│" string (op.op-date,"99/99/99")
 		      "│" string (op.doc-num,"999999")
		      "│" string (op-entry.acct-db,"x(20)")
		      "│" string (op-entry.currency,"x(3)")
		      "│" string (sum,">>>>>>>>9.99")
                      "│" .

      find first op where recid(op) = tCom.tCom-op no-lock.
      find first op-entry where Recid(op-entry) = tCom.tCom-entry no-lock.

      if op-entry.currency = "" or op-entry.currency = ? then do:
           if op-entry.amt-rub <> stsum then put unformatted "-│" .
           else put unformatted "√│".
           sumcom = op-entry.amt-rub.
      end.
      else do:
           if op-entry.amt-cur <> stsum then put unformatted "-│" .
           else put unformatted "√│".
           sumcom = op-entry.amt-cur.
      end.
      /* выводим */
      put unformatted string (op.op-date,"99/99/99")
 		      "│" string (op.doc-num,"999999")
		      "│" string (sumcom * 100 / sum,">9.99")
		      "│" string (sumcom,">>>>>9.99")
		      "│" string (stcom,">9.99")
		      "│" string (stsum,">>>>>9.99")
                      "│"  skip.


     next.
   end.

   if tCom.opCount = 1 then do: /* выводим */
      find first op where recid(op) = tCom.tCom-op no-lock.
      find first op-entry where Recid(op-entry) = tCom.tCom-entry no-lock.

      if op-entry.currency = "" or op-entry.currency = ? then do:
           sumcom = op-entry.amt-rub.
      end.
      else do:
           sumcom = op-entry.amt-cur.
      end.
      put unformatted "│ Не удалось определить документ снятия наличных      │ "
                      "│" string (op.op-date,"99/99/99")
 		      "│" string (op.doc-num,"999999")
		      "│  -  " 
		      "│" string(sumcom,">>>>>9.99")
		      "│  -  " 
		      "│    -    " 
                      "│" skip.
   end.
end.

put unformatted "└────────┴──────┴────────────────────┴───┴────────────┴─┴────────┴──────┴─────┴─────────┴─────┴─────────┘" skip.

{preview.i}





