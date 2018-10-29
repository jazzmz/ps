FOR EACH loan WHERE loan.contract = "Кредит" AND CAN-DO({1},loan.class-code) 
	        AND (loan.close-date >= {2} OR loan.close-date = ?) NO-LOCK,
 LAST term-obl WHERE term-obl.contract  EQ "Кредит" 
		 AND term-obl.cont-code EQ loan.cont-code 
		 AND term-obl.idnt      EQ 128 
		 AND term-obl.end-date  <= {2}
		 AND (term-obl.sop-date >= {2} OR term-obl.sop-date = ?) 
		 AND CAN-DO({3},term-obl.lnk-cont-code)
		NO-LOCK BREAK BY term-obl.lnk-cont-code BY ENTRY(1,loan.cont-code," ") 
			      BY ENTRY(1,(IF NUM-ENTRIES(loan.cont-code)=1 THEN loan.cont-code + " 0" 
										ELSE loan.cont-code)," "):
