/* ��ࠢ���� 25/08/11 SStepanov #732 ���㬥�� ���� ���� name-send ����� ���: "��� //<����>//" � �� �஢������, ���ࠢ���� ������஢����� �஢�ન*/

/* ��ࠡ�⪠ 2281-� c 07.12.2009 */
IF can-do("01*,02,06,016,019",op.doc-type) and op.acct-cat eq "b" and op.op-date GE 07/12/2009  
			and CAN-DO('date,status', iParam ) and can-do("40*",op-entry.acct-db)
			THEN
		DO:	 

				 vINN = "".
				 vDetails1 = "".
				 vDetails2 = "".
				 vDetails3 = "".

				 FIND FIRST b-acct where b-acct.acct eq op-entry.acct-db /* and not can-do("409*",op-entry.acct-db)*/ no-lock no-error.
				 
				 CASE b-acct.cust-cat:
				      WHEN "�"  THEN 
				          DO:
				 	     FIND FIRST cust-corp WHERE cust-corp.cust-id EQ b-acct.cust-id NO-LOCK NO-ERROR.
			 	     
				 	     IF AVAIL cust-corp  THEN
				 	       DO:
				 	          IF cust-corp.country-id EQ "RUS" OR cust-corp.country-id EQ "" 
						    THEN
							vINN-SENDcl = DEC(cust-corp.inn).
						    ELSE
						    DO:				 	          
				 	        	vINN-SENDcl = DEC(GetXAttrValue('cust-corp',STRING(cust-corp.cust-id),'���')).
						        if ((vINN-SENDcl = ?) OR (vINN-SENDcl = 0)) THEN 
							 vINN-SENDcl = DEC(cust-corp.inn). 
						    END.
				 	          .
				 	          			 	          
   			 	               vINN-SENDdoc  = DEC(GetXAttrValue('op',STRING(op.op),'inn-send')).
   			 	               
   			 	        
	 	          
						/* MESSAGE vINNcl '_?_' vINNdoc VIEW-AS ALERT-BOX.	*/    
				
				/*	MESSAGE 'acct' LENGTH(GetXAttrValue('op',STRING(op.op),'acct-send')) '#name'  
					   LENGTH(GetXAttrValue('op',STRING(op.op),'name-send')) '#inn'
					   LENGTH(GetXAttrValue('op',STRING(op.op),'inn-send')) '#' VIEW-AS ALERT-BOX. */ 
				
					/*�᫨ ��������� ���. ४������ */
					IF LENGTH(GetXAttrValue('op',STRING(op.op),'acct-send')) > 0 OR
					   LENGTH(GetXAttrValue('op',STRING(op.op),'name-send')) > 0 OR
					   LENGTH(GetXAttrValue('op',STRING(op.op),'inn-send')) > 0 
					THEN
					DO:			
				 	          IF   vINN-SENDdoc NE vINN-SENDcl    THEN
				 		     	DO:
				 		        MESSAGE COLOR WHITE/RED
				 		        " �訡�� 2281-� !!!" skip
				 		        " ��� 㪠����� � ���⥦��� ���㬥�� (" vINN-SENDdoc ") �⫨砥��� �� ��� ������ (" vINN-SENDcl ") !!!" 
				                        VIEW-AS ALERT-BOX 
		                                        TITLE "�訡�� ���㬥��".
   		      				        IF Error2281 THEN RETURN.
							
				 		     	END.
 			 	       				 	          
	 	     
				 	          IF vINN-SENDdoc eq 0 THEN
				 		     	DO:
				 		        MESSAGE COLOR WHITE/RED
				 		        " �訡�� 2281-� !!!" skip
				 		        " � ���⥦��� ���㬥�� ��������� ��� (���) !!!" skip
				 		        " ����� ࠡ���� � ⠪�� ⨯�� ���㬥�� !!!"
				                        VIEW-AS ALERT-BOX 
		                                        TITLE "�訡�� ���㬥��".
		      				        IF Error2281 THEN RETURN.
				 		     	END.

					
					END. /* �᫨ ��������� ��� ४������*/
					ELSE
					DO:
					
					          IF vINN-SENDcl  = 0    THEN
				 		     	DO:
				 		        MESSAGE COLOR WHITE/RED
				 		        " �訡�� 2281-� !!!" skip
				 		        "  ��� ������ �� �������� (" vINN-SENDcl ") !!!" 
				                        VIEW-AS ALERT-BOX 
		                                        TITLE "�訡�� ���㬥��".
   		      				        IF Error2281 THEN RETURN.
							
				 		     	END.
 			 	    
					
					
					END.      /*�᫨ ��६ �� ������ �����।�⢥���*/			
					     	
				 		     	
				 		     	
				 	       END. /* ����� ��������/���������� */
				    END. /* ����� � */ 
          WHEN "�" THEN
          DO:
            FIND FIRST person WHERE person.person-id  EQ b-acct.cust-id NO-LOCK NO-ERROR.
    
            IF AVAIL person THEN vINN-SENDcl = DEC(person.inn). ELSE vINN-SENDcl = 0.
          
        	vINN-SENDdoc =  DEC(GetXAttrValue('op',STRING(op.op),'inn-send')).
        			
        	
        	
        	/*	MESSAGE 'acct' LENGTH(GetXAttrValue('op',STRING(op.op),'acct-send')) '#name'  
					   LENGTH(GetXAttrValue('op',STRING(op.op),'name-send')) '#inn'
					   LENGTH(GetXAttrValue('op',STRING(op.op),'inn-send')) '#' VIEW-AS ALERT-BOX. */ 
        	
        	/*IF vINN = "7708031739" then vINN = "".*/	
        
        		IF LENGTH(GetXAttrValue('op',STRING(op.op),'acct-send')) > 0 OR
				   LENGTH(GetXAttrValue('op',STRING(op.op),'name-send')) > 0 OR
				   LENGTH(GetXAttrValue('op',STRING(op.op),'inn-send')) > 0    
				THEN
				DO:	
                	
    	           IF vINN-SENDdoc GT 0   AND   vINN-SENDcl GT 0 
    	           AND vINN-SENDdoc NE vINN-SENDcl 
    	           THEN
		     		DO:
		        	    MESSAGE COLOR WHITE/RED
		        	    " �訡�� 2281-� !!!" skip
				    	" ��� 㪠����� � ���⥦��� ���㬥�� �⫨砥��� �� ��� ������ !!!" 				                        
		    	 	    VIEW-AS ALERT-BOX 
            	                TITLE "�訡�� ���㬥��".
			            IF Error2281 THEN RETURN.	                    
					END.
 	        
                   IF vINN-SENDdoc EQ 0 AND vINN-SENDcl GT 0 THEN
		     		DO:
		            	MESSAGE COLOR WHITE
		        	    " �������������� 2281-� !" skip
					    " ��� � ���⥦��� ���㬥�� ���������, ���  ��� �� ������ 㪠��� !!!"
			     	    VIEW-AS ALERT-BOX 
		                    TITLE "�।�०�����".
					END.
/*		            	MESSAGE COLOR WHITE/RED
		        	    " �訡�� 2281-� !!!" skip
					    " ��� � ���⥦��� ���㬥�� ���������, ���  ��� �� ������ 㪠��� !!!" 				                        
			     	    VIEW-AS ALERT-BOX 
		                    TITLE "�訡�� ���㬥��".
			            IF Error2281 THEN RETURN.	                    
					END.
*/
					IF vINN-SENDdoc GT 0 AND vINN-SENDcl EQ 0 THEN
		     		DO:
		            	MESSAGE COLOR WHITE
		        	    " �������������� 2281-� !" skip
					    " ��� �� ������ ���������, ���  ��� � ���⥦��� ���㬥�� 㪠��� !" 				                        
			     	    VIEW-AS ALERT-BOX 
		                    TITLE "�।�०�����".
			            	                    
					END.
					
 				
 				END.   
				ELSE
 			 	DO:    
					vINN-SENDdoc = vINN-SENDcl.
					
				END.      /*�᫨ ��६ �� ������ �����।�⢥���*/							        
        
        
	        current-i = 0.
	 	current-format-name-send = "".
			 		
	 	/** �᫨ ���譨� ���⥦ */
	 	IF CAN-DO("!40911*,40*", op-entry.acct-db) AND CAN-DO("30102*", op-entry.acct-cr) THEN DO:
	 		current-i = 1.
	 	END.
				
		/** �᫨ ����७��� ���⥦ */
	 	IF CAN-DO("!40911*,40*", op-entry.acct-db) AND CAN-DO("!30102*,*", op-entry.acct-cr) THEN DO:
	 		current-i = 2.
	 	END.
			 		
	 	/** �᫨ ��ॢ�� ��� ������ ���譨� */
	 	IF CAN-DO("40911*", op-entry.acct-db) AND CAN-DO("30102*", op-entry.acct-cr) THEN DO:
	 		current-i = 3.
	 	END.
			 		
	 	/** �᫨ ��ॢ�� ��� ������ ����७��� */
	 	IF CAN-DO("40911*", op-entry.acct-db) AND CAN-DO("!30102*,*", op-entry.acct-cr) THEN DO:
	 		current-i = 4.
	 	END.
		IF current-i > 0 THEN DO:
			IF op-entry.amt-rub >= point-sum THEN
				current-format-name-send = format-name-send-ge[current-i].
			ELSE
				current-format-name-send = format-name-send-lt[current-i].
			IF vINN-SENDdoc <> 0 THEN 
				current-format-name-send = format-name-send-inn[current-i].
		END.

/* #732 -- ������ ���������� >> -- ���㬥�� ���� ���� name-send ����� ���: "��� //<����>//" � �� �஢������, ���ࠢ���� ������஢����� �஢�ન
		IF true / * vINN eq ""* / THEN
	 	DO:
	 		vNamePl = REPLACE(GetXAttrValue('op',STRING(op.op),'name-send'),"~n"," ").
	 			
	 		
	 		IF / * �� �஢���� �����, ��⮬� �� ����� ��।����� ���� �� 
	 		      � ������ ��� ��� ���. ��⮬� �� ��� ���� ������, �� ���� 
	 		      ����� ���� ������. ���⮬� ����� ��।����� �㦭� �ࠢ���� �ଠ�
	 		  (
	 		    (current-i = 3 OR current-i = 4) 
	 			AND 
	 			NUM-ENTRIES(vNamePl, char-div) <> NUM-ENTRIES(current-format-name-send, char-div)
	 		   )
	 		   OR
	 		   * /
	 		   (
	 		    current-i = 1 
	 		    AND 
	 		    vINN-SENDdoc = 0
	 		    AND 
	 			NUM-ENTRIES(vNamePl, char-div) <> NUM-ENTRIES(current-format-name-send, char-div)
	 		   )
			THEN 
	 		DO:
	 				MESSAGE COLOR WHITE/RED
	 					" ����室��� ��������� ���४����� name-send " skip
	 					" (�ଠ�:" current-format-name-send ") !!!"
           			VIEW-AS ALERT-BOX 
		            TITLE "�訡�� ���㬥�� 2281-�".
   		  			IF Error2281 THEN RETURN.
	 		END.
   #732 -- ��������� ���������� <<	 	END.  ����� vINN */
          END. /* ����� � */
        END. /* ����� CASE */
END. /* ����� 2281-� */
