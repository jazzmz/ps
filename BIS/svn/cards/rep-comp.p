/* ------------------------------------------------------
     File: $RCSfile: rep-comp.p,v $ $Revision: 1.1 $ $Date: 2008-08-18 07:54:51 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: OutSource from Kuntashev V.
     �� ������: ���� �� ���ਭ�� � ࠧ�� ������
     ��� ࠡ�⠥�: 
     ��ࠬ����:  
     ���� ����᪠:  f1 �� ������� ���ਭ�� � �����⮬
     ����: $Author: Buryagin $ 
     ���������: $Log: not supported by cvs2svn $
------------------------------------------------------ */
                                                      
{globals.i}                                           
{intrface.get card}
{intrface.get instrum}
{intrface.get xclass}
{sh-defs.i}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

{getdates.i}

{get-bankname.i}

DEF VAR    I         AS INTEGER        NO-UNDO.  /* ���稪    */
DEF BUFFER org       FOR loan.                   /* ������᪨� */
DEF BUFFER eqip      FOR loan.                   /* ���ன�⢠ */

DEFINE TEMP-TABLE ttResult
    FIELD fil             AS CHARACTER         /* ����� 䠩�� */
    FIELD nazv_org        AS CHARACTER         /* �������� �࣠����権 */
    FIELD nazv_term       AS CHARACTER         /* �������� �࣮��� �窨 */
    FIELD nom_term        AS CHARACTER         /* ����� �࣮��� �窨 */
    FIELD type_term       AS CHARACTER         /* ⨯ �࣮��� �窨 */
    FIELD system					AS CHARACTER         /* ��⥬� �� */
    FIELD num-card        LIKE loan.doc-num    /* ����� ����� */
    FIELD kod_auto        AS CHARACTER         /* ��� ���ਧ�樨 */
    FIELD date_op         AS DATE              /* ��� ����樨 */
    FIELD date_voz        AS DATE              /* ��� �����饭�� */
    FIELD sum_op          AS DECIMAL           /* �㬬� ����樨 */
    FIELD sum_voz         AS DECIMAL           /* �㬬� �࠭���樨 */
    FIELD kom_op          AS DECIMAL           /* ����� ����樨 ����� */
    FIELD kom_pc          AS DECIMAL           /* �����  ��*/
    
    .

DEF STREAM mStr.

{setdest2.i &stream="stream mStr" &filename=_spool5.tmp &cols=120}

/* ��ନ஢���� ⠡���� � १���⠬� */
FOR EACH tmprecid NO-LOCK,
    FIRST loan     WHERE RECID(loan) = tmprecid.id 
       NO-LOCK,
       EACH eqip  WHERE eqip.parent-cont-code EQ  loan.cont-code AND
                        eqip.class-code EQ "card-equip"
       NO-LOCK:
    
 /* MESSAGE "1"   eqip.cust-cat eqip.contract eqip.cont-code  loan.parent-cont-code. pause. */
     
     FOR EACH pc-trans WHERE pc-trans.pctr-status ne "���"         AND
                        pc-trans.proc-date GE beg-date             AND 
									      pc-trans.proc-date LE end-date             AND 
									      entry(3,pc-trans.pctr-code,chr(1)) eq "1"  AND
									      TRIM(pc-trans.num-equip) EQ eqip.doc-num
									      
			NO-LOCK:
/*			FIRST eqip WHERE eqip.doc-num EQ TRIM(pc-trans.num-equip) AND
			                 eqip.class-code eq "card-equip"
			NO-LOCK,*/
 
 
      CREATE ttResult.                                                                     
      ASSIGN
         ttResult.fil           = "1"
         ttResult.nazv_term     = eqip.user-o[1]
         ttResult.type_term     = GetCodeName("������ன�⢠",eqip.sec-code)
         ttResult.nom_term      = eqip.doc-num
         ttResult.system        = pc-trans.pl-sys         
         ttResult.num-card      = pc-trans.num-card
         ttResult.date_op       = pc-trans.cont-date
         ttResult.date_voz      = pc-trans.proc-date
         ttResult.kod_auto      = pc-trans.auth-code
         .
     
     IF loan.cust-cat EQ "�" THEN ttResult.nazv_org = trim(cBankName).
     IF loan.cust-cat EQ "�" THEN  
     	DO:
     		find first cust-corp where cust-corp.cust-id eq loan.cust-id no-lock no-error.
     		ttResult.nazv_org = cust-corp.name-short.
     	END. 	


   /*   �㬬� ����樨 */		
     FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id  EQ pc-trans.pctr-id
                               AND pc-trans-amt.amt-code EQ "�����" no-lock no-error.
      IF AVAIL pc-trans-amt then                          
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
         ttResult.sum_voz   = ttResult.sum_op +    ttResult.kom_op.    
         .
      END.            
    ELSE
         ttResult.sum_voz   = ttResult.sum_op.    
      

/*   �㬬� �����ᨨ �� */      
 
    FIND FIRST pc-trans-amt  WHERE pc-trans-amt.pctr-id      EQ pc-trans.pctr-id AND 
                                   pc-trans-amt.amt-code EQ "����" no-lock no-error.
    if AVAIL pc-trans-amt then 
    	do:                                   
      ASSIGN
         ttResult.kom_pc    = pc-trans-amt.amt-cur        
         .                  
      END.         

  END.

/*
message "2"   org.cust-cat org.contract org.cont-code pc-trans.pl-sys loan.parent-cont-code. pause.   		
*/
END. /* ����� �ନ஢���� ⠡���� */

/* �뢮� ���ଠ樨 */
 /*�����*/
PUT STREAM mStr UNFORMATTED "                                                       �������   "  SKIP(1)
                            "                                        �� ��ਮ� c " STRING(beg-date) " �� " STRING(end-date)  SKIP(1)
                            "      "  ttResult.nazv_org SKIP(2)
                            "                                                                                                                          �����ᨨ �����"  SKIP
                            "                                                                                                                        VISA  MASTER  FO" SKIP                           
                            SKIP.


/* ���� ����� */
                      FOR EACH tmprecid NO-LOCK,
                               FIRST loan     WHERE RECID(loan) = tmprecid.id NO-LOCK,
                               EACH eqip  WHERE eqip.parent-cont-code EQ  loan.cont-code AND
                                                eqip.class-code EQ "card-equip"
                           NO-LOCK:
                            
                           IF AVAIL eqip THEN
                           DO:
                           PUT STREAM mStr UNFORMATTED 
                            FILL(" ",95) +
                            STRING(GetCodeName("������ன�⢠",eqip.sec-code),"x(25)") +
                            STRING((IF NUM-ENTRIES(eqip.user-o[4],";") > 1 THEN ENTRY(1,eqip.user-o[4],";") ELSE  " ")) + "  "
                            STRING((IF NUM-ENTRIES(eqip.user-o[4],";") > 2 THEN ENTRY(2,eqip.user-o[4],";") ELSE  " ")) + "  " 
                            STRING((IF NUM-ENTRIES(eqip.user-o[4],";") = 3 THEN ENTRY(3,eqip.user-o[4],";") ELSE  " ")) 
                            SKIP.
                           END.                            
                           
                      END.
/* ����� ���᪠ ����� */
                            
                            
                            
PUT STREAM mStr UNFORMATTED " �����                                                                 RUR" SKIP (2)
                            "                                                 ������ ������� �����                                                                    " SKIP
                            "���������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
                            "�    ���    �  ����� �����     �      ��� �����       �   ���     � � ���ன�⢠ �     �㬬�       �     �㬬�       �     �㬬�       �" SKIP
                            "�  ����樨  �                  �                      ����ਧ�樨�              � ����樨, �㡫� � �����ᨩ, �㡫� ������饭��,�㡫� �" SKIP
                            "���������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.                                                 

for EACH ttResult BREAK BY ttResult.fil BY ttResult.date_voz BY ttResult.date_op:


    ACCUMULATE ttResult.sum_op   (TOTAL BY ttResult.fil BY ttResult.date_voz)
               ttResult.kom_op   (TOTAL BY ttResult.fil BY ttResult.date_voz)
               ttResult.sum_voz  (TOTAL BY ttResult.fil BY ttResult.date_voz)
    . 

    PUT STREAM mStr UNFORMATTED
        "� " STRING(ttResult.date_op, "99/99/9999") + " � " + STRING(ttResult.num-card, "x(16)") + " � " + STRING(GetCodeName("���⑨�⥬�",ttResult.system),"x(20)") + " � " + STRING(ttResult.kod_auto, "x(9)") + " � " + STRING(ttResult.nom_term,"x(12)") + " � " + STRING(ttResult.sum_op, "->>>,>>>,>>9.99") + " � " + STRING(ttResult.kom_op, "->>>,>>>,>>9.99")  + " � " + STRING(ttResult.sum_voz, "->>>,>>>,>>9.99") + " �" SKIP.
      
      IF LAST-OF(ttResult.date_voz) THEN
     do: 
       PUT STREAM mStr UNFORMATTED 
       "���������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
       "� �����饭�� ��  " + STRING(ttResult.date_voz)   " � " +  STRING(ACCUM TOTAL BY ttResult.date_voz ttResult.sum_op, "->>>,>>>,>>9.99") + " � " + STRING(ACCUM TOTAL BY ttResult.date_voz ttResult.kom_op, "->>>,>>>,>>9.99")  + " � " + STRING(ACCUM TOTAL BY ttResult.date_voz ttResult.sum_voz, "->>>,>>>,>>9.99") + " �" AT 82 SKIP.
        IF  LAST-OF(ttResult.date_voz) AND LAST-OF(ttResult.fil) THEN
         PUT STREAM mStr UNFORMATTED 
         "���������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
        ELSE
         PUT STREAM mStr UNFORMATTED      
         "���������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.         
     END. 
     else
        PUT STREAM mStr UNFORMATTED       
       "���������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.         

      IF LAST-OF(ttResult.fil) THEN
     do: 
       PUT STREAM mStr UNFORMATTED 
       "� " AT 1  " �����: � " +  STRING(ACCUM TOTAL BY ttResult.fil ttResult.sum_op, "->>>,>>>,>>9.99") + " � " + STRING(ACCUM TOTAL BY ttResult.fil ttResult.kom_op, "->>>,>>>,>>9.99")  + " � " + STRING(ACCUM TOTAL BY ttResult.fil ttResult.sum_voz, "->>>,>>>,>>9.99") + " �" AT 75 SKIP
       "�����������������������������������������������������������������������������������������������������������������������������������������" SKIP (2).         
     END.
      
END.


PUT STREAM mStr UNFORMATTED "                                                 ������ ������� (AmEx)*                                                                 " SKIP
                            "����������������������������������������������������������������������������Ŀ" SKIP
                            "�    ���    �  ����� �����     �   ���     � � ���ன�⢠ �     �㬬�       �" SKIP
                            "�  ����樨  �                  ����ਧ�樨�              � ����樨, �㡫� �" SKIP
                            "����������������������������������������������������������������������������Ĵ" SKIP
                            "�                                           �      ����� : �            0.00 �" SKIP
                            "������������������������������������������������������������������������������" SKIP
                            " * �����饭�� �।�� � �ᯮ�짮������ ���⥦��� ���� AmEx �����⢫���� � ᮮ⢥��⢨� � �����஬ �࣠����樨 � American Express" SKIP(1)
                            " ������������������������������������������������������������������������������������" SKIP
                            " ������������ " SKIP(1).
                            
                      FOR EACH tmprecid NO-LOCK,
                               FIRST loan     WHERE RECID(loan) = tmprecid.id NO-LOCK,
                               EACH eqip  WHERE eqip.parent-cont-code EQ  loan.cont-code AND
                                                eqip.class-code EQ "card-equip"
                           NO-LOCK:
                            
                           IF AVAIL eqip THEN
                           DO:
                           PUT STREAM mStr UNFORMATTED " " + STRING(eqip.doc-num,"x(15)") + 
                                                             STRING(GetCodeName("������ன�⢠",eqip.sec-code),"x(30)") + 
                                                             STRING(eqip.user-o[1],"x(60)")  SKIP.
                           END.                            
                           
                      END.

PUT STREAM mStr UNFORMATTED " ������������������������������������������������������������������������������������" SKIP (4)
                            " ������⥫� �।ᥤ�⥫� �ࠢ�����                                                      __________________ " SKIP(2)
                            " �ᯮ���⥫�                                                                             __________________ " SKIP.
                            

{preview2.i &stream="stream mStr" &filename=_spool5.tmp }
