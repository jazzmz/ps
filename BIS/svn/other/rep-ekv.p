/* ------------------------------------------------------
     File: $RCSfile: rep-ekv.p,v $ $Revision: 1.1 $ $Date: 2008-08-27 10:58:15 $
     Copyright: ��� �� "�p������������"
     ���������: outsource from Kuntashev V
     ��稭�: 
     �� ������: ���� �� ���ਭ��. 
     ��� ࠡ�⠥�: 
     ��ࠬ����: 
     ���� ����᪠:  
     ����: $Author: Buryagin $ 
     ���������: $Log: not supported by cvs2svn $
------------------------------------------------------ */
/* 

���� �� ��ਭ�� ᢮�� ���ந�⢠�.

*/
                                                      
{globals.i}                                           
{intrface.get card}
{intrface.get instrum}
{intrface.get xclass}
{sh-defs.i}
{get-bankname.i}                                       
{getdate.i}                                       

DEF VAR    I         AS INTEGER        NO-UNDO.  /* ���稪    */
DEF BUFFER org       FOR loan.                   /* ������᪨� */
DEF BUFFER eqip      for loan.                   /* ���ன�⢠ */

/*
DEF VAR kol_VISA_ps_op     as int NO-UNDO.
DEF VAR sum_VISA_ps_op     as DEC NO-UNDO.
DEF VAR sum_VISA_ps_kom_b  as DEC NO-UNDO.
DEF VAR sum_VISA_ps_kom_pc as DEC NO-UNDO.


DEF VAR kol_MC_ps_op     as int NO-UNDO.
DEF VAR sum_MC_ps_op     as DEC NO-UNDO.
DEF VAR sum_MC_ps_kom_b  as DEC NO-UNDO.
DEF VAR sum_MC_ps_kom_pc as DEC NO-UNDO.


DEF VAR system            as char NO-UNDO.
*/

DEFINE TEMP-TABLE ttResult
    FIELD file            AS CHARACTER         /* 䠩� */
    FIELD nazv_org        AS CHARACTER         /* �������� �࣠����権 */
    FIELD nazv_term       AS CHARACTER         /* �������� �࣮��� �窨 */
    FIELD nom_term        AS CHARACTER         /* ����� �࣮��� �窨 */
    FIELD system					AS CHARACTER         /* ��⥬� �� */
    FIELD num-card        LIKE loan.doc-num    /* ����� ����� */
    FIELD kod_auto        AS CHARACTER         /* ��� ���ਧ�樨 */
    FIELD date_op         AS DATE              /* ��� ᮢ��襭�� ����樨 */
    FIELD sum_op          AS DECIMAL           /* �㬬� ����樨 */
    FIELD kom_op          AS DECIMAL           /* ����� ����樨 ����� */
    FIELD kom_pc          AS DECIMAL           /* �����  ��*/
    .

DEFINE TEMP-TABLE ttResFile
    FIELD system					AS CHARACTER         /* ��⥬� �� */
    FIELD kol_ps_op       AS INTEGER         /* ���-�� */
    FIELD sum_ps_op       AS DECIMAL         /* �㬬� ����樨 */
    FIELD sum_ps_kom_b    AS DECIMAL         /* �㬬� ��� ����� */
    FIELD sum_ps_kom_pc   AS DECIMAL         /* �㬬� ��� ����ᨭ�� */
    .


DEF STREAM mStr.

{setdest2.i &stream="stream mStr" &filename=_spool5.tmp &cols=120}

/* ��ନ஢���� ⠡���� � १���⠬� */
FOR EACH pc-trans WHERE pc-trans.pctr-status ne "���"  and
									      pc-trans.proc-date eq end-date and
									     entry(3,pc-trans.pctr-code,chr(1)) eq "1" 
			NO-LOCK,
			FIRST eqip WHERE eqip.doc-num EQ TRIM(pc-trans.num-equip) AND
			                 eqip.class-code eq "card-equip"
			NO-LOCK,
      FIRST org  WHERE org.cont-code  EQ eqip.parent-cont-code AND
      								 org.contract   EQ "card-acq"	          AND
                       org.class-code EQ "card-loan-acqbank" 
      NO-LOCK: 
 
      CREATE ttResult.                                                                     
      ASSIGN
         ttResult.file          = "1"
         ttResult.nazv_term     = eqip.user-o[1]
         ttResult.nom_term      = eqip.doc-num
         ttResult.system        = pc-trans.pl-sys         
         ttResult.num-card      = pc-trans.num-card
         ttResult.date_op       = pc-trans.cont-date
         ttResult.kod_auto      = pc-trans.auth-code
         .
     
     if org.cust-cat eq "�" then ttResult.nazv_org = trim(cBankName).
     if org.cust-cat eq "�" then 
     	do:
     		find first cust-corp where cust-corp.cust-id eq org.cust-id no-lock no-error.
     		ttResult.nazv_org = cust-corp.name-short.
     	end. 	


   /*   �㬬� ����樨 */		
     FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id  EQ pc-trans.pctr-id
                               AND pc-trans-amt.amt-code EQ "�����" no-lock no-error.
      ASSIGN
         ttResult.sum_op    = pc-trans-amt.amt-cur        
         .         
   
   /*   �㬬� �����ᨨ ����� */      
    FIND FIRST pc-trans-amt  WHERE pc-trans-amt.pctr-id      EQ pc-trans.pctr-id AND 
                                   pc-trans-amt.amt-code EQ "�����" no-lock no-error.
   
    if AVAIL pc-trans-amt then 
    	do:
      ASSIGN
         ttResult.kom_op    = pc-trans-amt.amt-cur        
         .
      END.            

/*   �㬬� �����ᨨ �� */      
 
    FIND FIRST pc-trans-amt  WHERE pc-trans-amt.pctr-id      EQ pc-trans.pctr-id AND 
                                   pc-trans-amt.amt-code EQ "����" no-lock no-error.
    if AVAIL pc-trans-amt then 
    	do:                                   
      ASSIGN
         ttResult.kom_pc    = pc-trans-amt.amt-cur        
         .                  
      END.         


/* ������ �⮣�� */

  Find first ttResFile where ttResFile.system = pc-trans.pl-sys no-lock no-error.
  
  	if AVAIL ttResFile then
  		ASSIGN
  		 ttResFile.kol_ps_op      = ttResFile.kol_ps_op + 1
	     ttResFile.sum_ps_op      = ttResFile.sum_ps_op + ttResult.sum_op
	     ttResFile.sum_ps_kom_b   = ttResFile.sum_ps_kom_b  + ttResult.kom_op
	     ttResFile.sum_ps_kom_pc  = ttResFile.sum_ps_kom_pc + ttResult.kom_pc
	    .
	   else
	   	do:
	   	CREATE ttResFile.
	   	ASSIGN
	   	 ttResFile.system         = pc-trans.pl-sys
  		 ttResFile.kol_ps_op      = 1
	     ttResFile.sum_ps_op      = ttResult.sum_op
	     ttResFile.sum_ps_kom_b   = ttResult.kom_op
	     ttResFile.sum_ps_kom_pc  = ttResult.kom_pc
	    .
	   	END.
/*
if pc-trans.pctr-id = 1504 then
	do:
message "2"   org.cust-cat org.contract org.cont-code pc-trans.pl-sys ttResFile.sum_ps_op. pause.   		
end.
*/	   	 

END. /* ����� �ନ஢���� ⠡���� */


/* �뢮� ���ଠ樨 */

PUT STREAM mStr UNFORMATTED "���� �� ��ਭ�� �� " STRING(end-date) "." SKIP(1)
														"�������������������������������������������������������������Ŀ" skip.

for EACH ttResult BREAK BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system BY ttResult.date_op:

   IF FIRST-OF (ttResult.nazv_org) THEN 
   do:
	 I = 0.
    /*�����*/
PUT STREAM mStr UNFORMATTED "�                " STRING(ttResult.nazv_org,"x(45)")   "�" skip
                            "�������������������������������������������������������������Ĵ" skip.
   END.
   
   	  if FIRST-OF (ttResult.system) THEN 
	 do: 	
PUT STREAM mStr UNFORMATTED "�        " STRING(ttResult.nazv_term,"x(20)")  "    �ନ��� "  STRING(ttResult.nom_term,"x(20)")  "�" skip
                            "�������������������������������������������������������������Ĵ" skip.
   END.                        
	  
	  if FIRST-OF (ttResult.nom_term) THEN 
	 do: 	
PUT STREAM mStr UNFORMATTED "����⥦��� ��⥬� : "   STRING(GetCodeName("���⑨�⥬�",ttResult.system),"x(40)")  " �"SKIP
                            "�������������������������������������������������������������Ĵ" SKIP
                            "�    ���    �  ����� �����     �   ���     �     �㬬�       �" SKIP
                            "�  ����樨  �                  ����ਧ�樨� ����樨, �㡫� �" SKIP
                            "�������������������������������������������������������������Ĵ" SKIP.                                                 
   END.                                                                                         



    ACCUMULATE ttResult.sum_op  (TOTAL BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
               ttResult.kom_op  (TOTAL BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
               ttResult.kom_pc  (TOTAL BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
               
    					 ttResult.sum_op  (COUNT BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
    					 ttResult.kom_op  (COUNT BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
    					 ttResult.kom_pc  (COUNT BY ttResult.file BY ttResult.nazv_org BY ttResult.nom_term BY ttResult.system)
    
    . 

    PUT STREAM mStr UNFORMATTED
        "� " STRING(ttResult.date_op, "99/99/9999") + " � " + STRING(ttResult.num-card, "x(16)") + " � " + STRING(ttResult.kod_auto, "x(9)") + " � " + STRING(ttResult.sum_op, "->>>,>>>,>>9.99") + " �"
        
        SKIP.
      
      IF LAST-OF(ttResult.system) THEN
     do: 
       PUT STREAM mStr UNFORMATTED 
         /* �⮣ �� �� */ 
       "�������������������������������������������������������������Ĵ" SKIP
       "� �⮣� �� ���⥦��� ��⥬� "  STRING(GetCodeName("���⑨�⥬�",ttResult.system),"x(29)") STRING(ACCUM COUNT BY ttResult.system ttResult.sum_op,">>9")  " �" SKIP
       "� �㬬� ����権 : " STRING(ACCUM TOTAL BY ttResult.system ttResult.sum_op,"->,>>>,>>>,>>9.99") "�" AT 63 skip
       "� ������� ����� : " STRING(ACCUM TOTAL BY ttResult.system ttResult.kom_op,"->,>>>,>>>,>>9.99") "�" AT 63 skip
       "� ������� ��    : " STRING(ACCUM TOTAL BY ttResult.system ttResult.kom_pc,"->,>>>,>>>,>>9.99") "�" AT 63 skip
       "�������������������������������������������������������������Ĵ" SKIP.         


      IF LAST-OF(ttResult.nom_term) THEN
       PUT STREAM mStr UNFORMATTED 
         /* �⮣ �� �ନ���� */ 
       "� �⮣� �� �ନ���� "  STRING(ttResult.nom_term,"x(37)") STRING(ACCUM COUNT BY ttResult.nom_term ttResult.sum_op,">>9") " �" SKIP
       "� �㬬� ����権 : " STRING(ACCUM TOTAL BY ttResult.nom_term ttResult.sum_op,"->,>>>,>>>,>>9.99") "�" AT 63 skip
       "� ������� ����� : " STRING(ACCUM TOTAL BY ttResult.nom_term ttResult.kom_op,"->,>>>,>>>,>>9.99") "�" AT 63 skip
       "� ������� ��    : " STRING(ACCUM TOTAL BY ttResult.nom_term ttResult.kom_pc,"->,>>>,>>>,>>9.99") "�" AT 63 skip
       "�������������������������������������������������������������Ĵ" SKIP.         

      IF LAST-OF(ttResult.nazv_org) THEN
       PUT STREAM mStr UNFORMATTED 
         /* �⮣ ��  �࣠����樨 */ 
       "� �⮣� �� �࣠����樨 "  STRING(ttResult.nazv_org,"x(35)")  STRING(ACCUM COUNT BY ttResult.nazv_org ttResult.sum_op,">>9") " �" SKIP
       "� �㬬� ����権 : " STRING(ACCUM TOTAL BY ttResult.nazv_org ttResult.sum_op,"->,>>>,>>>,>>9.99") "�" AT 63 skip
       "� ������� ����� : " STRING(ACCUM TOTAL BY ttResult.nazv_org ttResult.kom_op,"->,>>>,>>>,>>9.99") "�" AT 63 skip
       "� ������� ��    : " STRING(ACCUM TOTAL BY ttResult.nazv_org ttResult.kom_pc,"->,>>>,>>>,>>9.99") "�" AT 63 skip
       "�������������������������������������������������������������Ĵ" SKIP.  
     END.
   
     else
       PUT STREAM mStr UNFORMATTED       
       "�������������������������������������������������������������Ĵ" SKIP.         

      IF LAST-OF (ttResult.file)  THEN
      do:	
       PUT STREAM mStr UNFORMATTED 
         /* �⮣ ��  䠩�� */ 
       "� �⮣� �� 䠩��                                              �" SKIP
       "� ������⢮ ����権                                         �" SKIP.
      	for each ttResFile break by ttResFile.system:
           PUT STREAM mStr UNFORMATTED 
           "� � �.�. �� " STRING(GetCodeName("���⑨�⥬�",ttResFile.system),"x(29)") STRING(ttResFile.kol_ps_op,">>9") AT 59 "�" AT 63 skip.
        END.
       
       PUT STREAM mStr UNFORMATTED 
       "� �㬬� ����権                                              �" SKIP.
        	for each ttResFile break by ttResFile.system:
            PUT STREAM mStr UNFORMATTED 
            "� � �.�. �� " STRING(GetCodeName("���⑨�⥬�",ttResFile.system),"x(29)") STRING(ttResFile.sum_ps_op,"->,>>>,>>>,>>9.99") AT 45 "�" AT 63 skip.
          END.
       

       PUT STREAM mStr UNFORMATTED 
       "� ������� �����                                              �" SKIP.
        	for each ttResFile break by ttResFile.system:
            PUT STREAM mStr UNFORMATTED 
            "� � �.�. �� " STRING(GetCodeName("���⑨�⥬�",ttResFile.system),"x(29)") STRING(ttResFile.sum_ps_kom_b,"->,>>>,>>>,>>9.99") AT 45 "�" AT 63 skip.
          END.

       PUT STREAM mStr UNFORMATTED 
       "� ������� ��                                                 �" SKIP.
        	for each ttResFile break by ttResFile.system:
            PUT STREAM mStr UNFORMATTED 
            "� � �.�. �� " STRING(GetCodeName("���⑨�⥬�",ttResFile.system),"x(29)") STRING(ttResFile.sum_ps_kom_pc,"->,>>>,>>>,>>9.99") AT 45 "�" AT 63 skip.
          END.

  
       PUT STREAM mStr UNFORMATTED       
       "���������������������������������������������������������������" SKIP.         
       
       end.
      
END.

{preview2.i &stream="stream mStr" &filename=_spool5.tmp }
