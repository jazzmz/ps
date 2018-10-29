/*
Формирование темп-тейбла из счетов клиентов с прописанным доп.реком PIR-Group
для последующего формирования отчетов по взаимосвязанным клиентам.
*/


{globals.i}
{svarloan.def NEW}          /* Shared переменные модуля "Кредиты и депозиты". */
{intrface.get tmess}    /* Инструменты обработки сообщений. */
{intrface.get xclass} /* Загрузка инструментария метасхемы */
{intrface.get pogcr}
{norm.i new}


{sh-defs.i}
{pir-tclients.i}

DEF VAR proc-name AS CHAR NO-UNDO.
DEFINE NEW SHARED STREAM err.
{setdest.i &stream="stream err" &filename='_spool_recalc.tmp' &append = "APPEND"}

DEF VAR ivAcctA AS CHAR NO-UNDO.
DEF VAR ivAcctP AS CHAR NO-UNDO.
DEF VAR ivAcct AS CHAR NO-UNDO.
DEF VAR izAcctA AS CHAR NO-UNDO.
DEF VAR izAcctP AS CHAR NO-UNDO.
DEF VAR izAcct AS CHAR NO-UNDO.
DEF VAR cCont-code AS CHAR NO-UNDO.
DEF VAR cCont-type AS CHAR NO-UNDO.
DEF VAR cCont-id AS INT INIT 0 NO-UNDO.
DEF VAR trisk AS CHAR NO-UNDO.
DEF VAR tempacct AS CHAR NO-UNDO.
DEF VAR taccttype AS CHAR NO-UNDO.
DEF VAR tccc AS CHAR NO-UNDO.
DEF VAR tsum AS DECIMAL NO-UNDO.
DEF VAR trsv AS DECIMAL NO-UNDO.
DEF VAR loansum AS DECIMAL NO-UNDO.

ivAcctA = "".
ivAcctP = "40*,41*,42*,30601*".
ivAcct = "438*,439*,47405*,47422*".

izAcctA = "47802*,90907*".
izAcctP = "47425*,91316*,91317*,91315*". /* 10000П,20000П,30000П */
izAcct = "450*,451*,452*,453*,454*,455*,456*,457*,458*".

DEF TEMP-TABLE tCacct NO-UNDO
         field cust-cat   as char
         field cust-id    as int
         field acct       as char
	 field amt-rub    as decimal
         field amt-val    as decimal.

DEF TEMP-TABLE tCacctZ NO-UNDO
         field cust-cat   as char
         field cust-id    as int
         field acct       as char
	 field amt-rub    as decimal
         field amt-val    as decimal
         field reserve    as decimal
	 field risk	  as decimal.

DEF TEMP-TABLE tgroup NO-UNDO
         field gid      as int
	 field incnt    as int
	 field sumgrp   as decimal
	 field sumgrpZR as decimal.

DEF BUFFER bloan-acct FOR loan-acct.
DEF BUFFER cloan-acct FOR loan-acct.
DEF BUFFER tloan-acct FOR loan-acct.

FUNCTION CalcPOSreserve RETURNS DECIMAL (INPUT iCont-id AS INT).
DEF VAR tresrv AS DECIMAL INIT 0 NO-UNDO.

FOR EACH loan WHERE loan.cont-code BEGINS ENTRY(1,loan-acct.cont-code," ")
	AND loan.contract = "Кредит"
	AND (loan.close-date = ? or loan.close-date > end-date) NO-LOCK.

	/* проверяем пересчитан ли договор на дату расчета, если нет - то пересчитаем */
	if loan.close-date eq ? and loan.since < end-date + 1 then do:
		RUN SetSysConf IN h_base ("NoProtocol","YES").
	        RUN SetSysConf IN h_base ("PUT-TO-TMESS","").
                {get_meth.i  'Calc' 'loanclc'}
                RUN VALUE(proc-name + ".p") (loan.contract,
                                             loan.cont-code,
                                             end-date + 1).

		RUN DeleteOldDataProtocol IN h_base ("PUT-TO-TMESS").
		RUN DeleteOldDataProtocol IN h_base ("NoProtocol").
        end.

FIND LAST loan-var WHERE loan-var.cont-code = loan.cont-code
	AND loan-var.contract = "Кредит"
	AND loan-var.since <= end-date
	AND loan-var.amt-id = iCont-id NO-LOCK NO-ERROR.

IF AVAILABLE loan-var THEN tresrv = tresrv + loan-var.balance. 
	/*MESSAGE loan.cont-code " / " acct.acct " / " tresrv VIEW-AS ALERT-BOX.
	END.*/
END.
RETURN tresrv.
END FUNCTION.

/*OUTPUT TO VALUE("acct.txt").*/                                                          /*Некрасова Наталья Николаевна Маурин Олег Сергеевич*/
FOR EACH TClients WHERE TClients.gid <> ? and TClients.gid <> "" /*AND TClients.name = "Андреев Григорий Владимирович"*/:
	/* поиск по счетам заемщиков */

      /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }

	FOR EACH acct WHERE acct.cust-cat = TClients.cust-cat 
		AND acct.cust-id = TClients.cust-id

		/*AND acct.acct = "47425810500001123230"*/

		AND (acct.close-date = ? or acct.close-date >= end-date)
		AND (CAN-DO(izAcct,acct.acct) 
			or (acct.side = "А" and CAN-DO(izAcctA,acct.acct)) 
			or (acct.side = "П" and CAN-DO(izAcctP,acct.acct))) NO-LOCK:
                CREATE TCAcctZ.
		ASSIGN
	         TCAcctZ.cust-cat = TClients.cust-cat
        	 TCAcctZ.cust-id  = TClients.cust-id
		 TCAcctZ.acct = acct.acct.
		 trisk = GetTempXAttrValueEx("acct", acct.acct + "," + acct.currency, "deriv", end-date,"").
  		 IF (trisk NE "") THEN trisk = ENTRY(2,trisk,",").
			ELSE ASSIGN TCAcctZ.risk = 1.
		CASE trisk :
	          WHEN "001"  THEN ASSIGN TCAcctZ.risk = 1.
        	  WHEN "002"  THEN ASSIGN TCAcctZ.risk = 0.5.
	          WHEN "003"  THEN ASSIGN TCAcctZ.risk = 0.2.
	          WHEN "004"  THEN ASSIGN TCAcctZ.risk = 0.
	          END CASE.
		RUN acct-pos IN h_base(acct.acct,acct.currency,end-date,end-date,?).
        	 ASSIGN 
		  TCAcctZ.amt-rub   = ABS(sh-bal)
        	  TCAcctZ.amt-val   = ABS(sh-val)
  	  	  TClients.sum-rubZ = TClients.sum-rubZ + ABS(sh-bal).
		 tsum = ABS(sh-bal).
		IF acct.acct BEGINS "47425" THEN ASSIGN TCAcctZ.reserve = ABS(sh-bal). /* зануляем последнюю колонку для резервов */

	/*MESSAGE "1 " acct.acct VIEW-AS ALERT-BOX.*/
            	
		FIND FIRST tloan-acct WHERE tloan-acct.acct = acct.acct
			/*AND tloan-acct.cont-code BEGINS "ПКС-014/13"*/
			AND tloan-acct.contract = "Кредит" 
			AND tloan-acct.since <= end-date NO-LOCK NO-ERROR.
		
		/* данный костыль присутствует из-за кривой реализации кредитных договоров
		   Дудкина Сергея Николаевича в БИСквите (резерв берется по закрытому договору) */
		IF CAN-DO("45506840600002100409",string(acct.acct)) THEN 
			FIND LAST tloan-acct WHERE CAN-DO("45515810700005998953",string(tloan-acct.acct))
			AND tloan-acct.contract = "Кредит" 
			AND tloan-acct.since <= end-date NO-LOCK NO-ERROR.
		/* конец костыля */
		
        	IF AVAILABLE tloan-acct THEN DO:
			cCont-code = TRIM(ENTRY(1,tloan-acct.cont-code," ")).
			cCont-type = ?.
			taccttype = tloan-acct.acct-type.

	/*MESSAGE "2 " tloan-acct.acct " / cont-code= " tloan-acct.cont-code " / acct-type= " tloan-acct.acct-type VIEW-AS ALERT-BOX.*/
			CASE tloan-acct.acct-type:
				WHEN "Кредит" THEN DO:
					cCont-type = "КредРез".
					cCont-id = 21.
					END.
				WHEN "КредПр" THEN DO:
					cCont-type = "КредРез1".
					cCont-id = 46.
					END.
				WHEN "КредЛин" THEN DO:
					cCont-type = "КредРезВб".
					cCont-id = 88.
					END.
				WHEN "КредН" THEN DO:
					cCont-type = "КредРезВб".
					cCont-id = 88.
					END.
				WHEN "КредТ" THEN DO:
					cCont-type = "КредРезП".
					cCont-id = 350.
					END.
				WHEN "КредВГар" THEN DO:
					cCont-type = "КредРезВб".
					/*cCont-id = 350.*/
					END.
				/* чтобы из резерва вычитал его же, такой костылик */
				WHEN "КредРезВб" THEN DO: 
					cCont-type = "КредРезВб". 
					cCont-id = 88.
					END.
				WHEN "КредРез" THEN DO:
					cCont-type = "КредРез".
					cCont-id = 21.
					END.
				WHEN "КредРез1" THEN DO:
					cCont-type = "КредРез1".
					cCont-id = 46.
					END.
				WHEN "КредРезП" THEN DO:
					cCont-type = "КредРезП".
					cCont-id = 350.
					END.
				WHEN "КредРезПени" THEN DO:
					cCont-type = "КредРезПени".
					cCont-id = 357.
					END.
			END CASE.
			
			IF cCont-type <> ? THEN DO:
                        /*
			find last loan-acct where loan-acct.cont-code BEGINS (cCont-code + " ")
				AND loan-acct.acct-type = cCont-type
				AND loan-acct.contract = "Кредит"
				AND loan-acct.since <= end-date and loan-acct.since > (end-date - 30) NO-LOCK NO-ERROR.
			IF AVAILABLE loan-acct THEN message acct.acct loan-acct.acct loan-acct.cont-code loan-acct.acct-type view-as alert-box.
			IF NOT AVAILABLE loan-acct THEN
			*/

			tccc = "".
			for each loan-acct where loan-acct.contract = "Кредит"
                		and loan-acct.cont-code begins (cCont-code + " ")
				and loan-acct.since <= end-date
				and loan-acct.acct-type = cCont-type
			 BY loan-acct.since:
				tccc = loan-acct.acct.
			end.

			find last loan-acct where loan-acct.cont-code BEGINS cCont-code 
				AND loan-acct.acct-type = cCont-type
				AND loan-acct.contract = "Кредит"
				AND loan-acct.acct = tccc NO-LOCK NO-ERROR.
			IF NOT AVAILABLE loan-acct THEN
				find last loan-acct where loan-acct.cont-code BEGINS cCont-code 
				AND loan-acct.acct-type = cCont-type
				AND loan-acct.contract = "Кредит"
				AND loan-acct.since <= end-date NO-LOCK NO-ERROR.
			IF AVAILABLE loan-acct THEN DO:	
			/*message acct.acct tloan-acct.acct loan-acct.acct loan-acct.cont-code cCont-type view-as alert-box.*/
				loansum = 0.
				tempacct = "".
	/*MESSAGE "3 " loan-acct.acct " / cont-code= " loan-acct.cont-code " / acct-type= " loan-acct.acct-type VIEW-AS ALERT-BOX.*/
				/* кусок необходим для распиливания суммы резерва на несколько кред.договоров */
				IF taccttype = "Кредит" THEN DO:
				FOR EACH bloan-acct WHERE bloan-acct.acct-type = "Кредит"
					AND bloan-acct.cont-code BEGINS cCont-code
					AND bloan-acct.contract = "Кредит"
					AND bloan-acct.since <= end-date NO-LOCK:
					/*RUN acct-pos IN h_base (bloan-acct.acct,bloan-acct.currency,end-date,end-date,?).*/
					/*MESSAGE "Распил!" VIEW-AS ALERT-BOX.*/
					IF NOT CAN-DO(string(CHR(42) + string(bloan-acct.acct) + CHR(42)),tempacct) THEN DO:
						RUN acct-pos IN h_base (bloan-acct.acct,bloan-acct.currency,end-date,end-date,?).
						loansum = loansum + ABS(sh-bal).
						tempacct = tempacct + "," + STRING(bloan-acct.acct).
						/*MESSAGE cCont-code "/" cCont-type "/" loan-acct.acct "/" bloan-acct.acct "/" loansum VIEW-AS ALERT-BOX.*/
						/*PUT UNFORMATTED cCont-code " / " cCont-type " / " acct.acct " / " loan-acct.acct " / " bloan-acct.acct " / " loansum SKIP.
						PUT UNFORMATTED CAN-DO(string(CHR(42) + string(bloan-acct.acct) + CHR(42)),tempacct) CHR(9) tempacct SKIP.*/
						END.
					END.
				END.
				
				/* данный блок реализует подсчет резерва по пластикам */
                       		FIND LAST cloan-acct WHERE cloan-acct.contract = "ПОС"
					AND cloan-acct.acct = loan-acct.acct
					/*AND cloan-acct.acct-type = cCont-type*/
					AND cloan-acct.since <= end-date NO-LOCK NO-ERROR.
				IF AVAILABLE cloan-acct THEN DO:
					/*MESSAGE "Пластик!" VIEW-AS ALERT-BOX.*/
					IF tsum <> 0 THEN DO:
					ASSIGN 
					  TCAcctZ.reserve = ABS(CalcPOSreserve(cCont-id)).
			  	  	  TClients.sum-rubZR = TClients.sum-rubZR + (tsum - TCAcctZ.reserve) * TCAcctZ.risk.
					trsv = TCAcctZ.reserve.
					/*message acct.acct "trsv=" trsv cCont-type view-as alert-box.*/
					END.

					IF tloan-acct.acct-type = "Кредит" OR tloan-acct.acct-type = "КредПр" OR tloan-acct.acct-type = "КредЛин"
						 OR tloan-acct.acct-type = "КредН"  OR tloan-acct.acct-type = "КредТ" THEN DO:
					CREATE TCAcctZ.
					ASSIGN
			          	 TCAcctZ.cust-cat = TClients.cust-cat
		        	  	 TCAcctZ.cust-id  = TClients.cust-id
				  	 TCAcctZ.amt-rub = trsv.
					CASE cCont-type:
						WHEN "КредРез" THEN ASSIGN TCAcctZ.acct = ENTRY(1,loan-acct.cont-code," ") + " резерв на ссуду".
						WHEN "КредРез1" THEN ASSIGN TCAcctZ.acct = ENTRY(1,loan-acct.cont-code," ") + " резерв на проср.ссуду".
						WHEN "КредРезВб" THEN ASSIGN TCAcctZ.acct = ENTRY(1,loan-acct.cont-code," ") + " резерв на линию".
						WHEN "КредРезП" THEN ASSIGN TCAcctZ.acct = ENTRY(1,loan-acct.cont-code," ") + " резерв на проценты".
					END CASE.
					/*MESSAGE acct.acct "/" loan-acct.acct "/" cloan-acct.acct "/" TCAcctZ.acct VIEW-AS ALERT-BOX.*/
					END.
				/*PUT UNFORMATTED "--- Счет: " TCAcctZ.acct " резервн.: " cloan-acct.acct " Сумма: " TCAcctZ.amt-rub " резерв: " TCAcctZ.reserve " риск: " TCAcctZ.risk SKIP.
				PUT UNFORMATTED "-------------------------------------------" SKIP.*/
	 			END.
				/* окончание блока по пластикам */

				ELSE DO:
                       		/* не ПОС */
				RUN acct-pos IN h_base (loan-acct.acct,loan-acct.currency,end-date,end-date,?).

		                IF loansum <> 0 THEN ASSIGN TCAcctZ.reserve = TCAcctZ.amt-rub * ABS(sh-bal) / loansum.
					ELSE ASSIGN TCAcctZ.reserve = ABS(sh-bal).

				IF loan-acct.acct = acct.acct THEN ASSIGN TCAcctZ.reserve = TCAcctZ.amt-rub.

				/*MESSAGE "Иначе! loansum=" loansum "/" loan-acct.acct "/" TCAcctZ.reserve VIEW-AS ALERT-BOX.*/
                              
				/* данный костыль присутствует из-за кривой реализации кредитных договоров
				   Дудкина Сергея Николаевича в БИСквите (резерв берется по закрытому договору) */
				IF CAN-DO("45506840600002100409",string(acct.acct)) THEN DO:
					loansum = TCAcctZ.amt-rub.
					RUN acct-pos IN h_base ("45507840400000220315","840",end-date,end-date,?).
					loansum = loansum + ABS(sh-bal).
					ASSIGN TCAcctZ.reserve = TCAcctZ.reserve * TCAcctZ.amt-rub / loansum.
					END.
				/* конец костыля */

				/* не ПОС */                                
		  	  	ASSIGN TClients.sum-rubZR = TClients.sum-rubZR + (tsum - TCAcctZ.reserve) * TCAcctZ.risk.
				END.
				/*PUT UNFORMATTED "--- Счет: " TCAcctZ.acct " резервн.: " loan-acct.acct " Сумма: " TCAcctZ.amt-rub " резерв: " TCAcctZ.reserve " риск: " TCAcctZ.risk SKIP.
				PUT UNFORMATTED "-------------------------------------------" SKIP.*/
                		END.
 			ELSE ASSIGN TClients.sum-rubZR = TClients.sum-rubZR + (tsum - TCAcctZ.reserve) * TCAcctZ.risk.
			END.
		END.
	END.
	FIND FIRST tgroup WHERE tgroup.gid = INT(TClients.gid) NO-ERROR.
	IF AVAILABLE tgroup THEN DO:
		ASSIGN
		 tgroup.incnt = tgroup.incnt + 1
		 tgroup.sumgrp = tgroup.sumgrp + TClients.sum-rub
		 tgroup.sumgrpZR = tgroup.sumgrpZR + TClients.sum-rubZR.
		END.
		ELSE DO:
		CREATE tgroup.
		ASSIGN 
		 tgroup.gid = INT(TClients.gid)
 		 tgroup.incnt = 1
		 tgroup.sumgrp = TClients.sum-rub
		 tgroup.sumgrpZR = TClients.sum-rubZR.	
		END.

    vLnCountInt = vLnCountInt + 1.    

END.
OUTPUT CLOSE.

/* если в группе состоит 1 клиент, то переводим его в группу 0 */
FOR EACH TClients WHERE TClients.gid <> ? and TClients.gid <> "" and INT(TClients.gid) > 1000:
	FIND FIRST tgroup WHERE tgroup.gid = INT(TClients.gid) NO-ERROR.	
	IF AVAILABLE tgroup AND tgroup.incnt = 1 THEN TClients.gid = "0".
END.
/*
OUTPUT TO VALUE("group.txt").
FOR EACH tgroup by tgroup.gid:
PUT UNFORMATTED tgroup.gid " кол-во в группе: " tgroup.incnt SKIP.
END.
OUTPUT CLOSE.
*/