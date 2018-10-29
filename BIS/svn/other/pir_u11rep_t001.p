{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (C) 2011
     Filename: pir_u11rep_t001.p
      Comment: pir_u11rep_t001.csv - �६���� ���� ��� �11
	       ��室�� �� ������ �������� ��, � ������ �� ����� �������, 
	       �� ���� ��� � ���㫥�묨 ���⪠��
   Parameters: 
       Launch: �� - ������ - �������� ����� 
         Uses:
      Created: Sitov S.A., 16.02.2012
	Basis: ��� ��
     Modified: Sitov S.A., 29.02.2012, ��������� �� �᭮����� �� (�� 28.02.2012). 
*/
/* ========================================================================= */




{globals.i}		/** �������� ��।������ */
{ulib.i}		/** ������⥪� ���-�㭪権 */
{getdate.i}
{sh-defs.i}



/* ========================================================================= */
				/** ������� */
/* ========================================================================= */

DEF VAR i  AS INT INIT 0 NO-UNDO.
DEF VAR iagr  AS INT INIT 0 NO-UNDO.
DEF VAR flag_card_otkr AS LOGICAL NO-UNDO.
DEF VAR flag_card_zakr AS LOGICAL NO-UNDO.
DEF VAR tmp_card_enddate AS DATE NO-UNDO.

DEF VAR Ost408 AS DEC INIT 0 NO-UNDO.
DEF VAR Ost423 AS DEC INIT 0 NO-UNDO.

DEF VAR y  AS INT NO-UNDO.
DEF temp-table SumYear NO-UNDO  
	FIELD StYear AS INT
	FIELD Sum AS DEC 
.

DEF BUFFER card FOR loan.
DEF BUFFER tcard FOR loan.


DEF VAR tmpFile	AS CHAR INIT "pir_u11rep_t001.csv" NO-UNDO.
tmpFile = "/home/bis/quit41d/imp-exp/users/" + LC(userid("bisquit")) + "/" + tmpFile .
DEFINE STREAM rep_excel .



/* ========================================================================= */
				/** ��������� */
/* ========================================================================= */

OUTPUT STREAM rep_excel TO VALUE (tmpFile) CONVERT TARGET "1251".

PUT STREAM rep_excel UNFORM ";���� �� ������ࠬ �� 䨧.���, � ������ ������� �� �����, �� ���� ���⪨ �� ����.��⠬;"  SKIP(2).
PUT STREAM rep_excel UNFORM "��� ����᪠ ����;" today  ";"  SKIP(2).

PUT STREAM rep_excel UNFORM "���� �� ����;" end-date  ";"  SKIP(2).


PUT STREAM rep_excel UNFORM 
	"������" ";" 
	"����� �������" ";" 
	"����� �������" ";"  
	"��� ��᫥����� ������� �����" ";"  
	"���" ";"
	"���⮪ (� ��.)" ";"
SKIP.


DO y = 1995 TO 2015:
  Create SumYear.
  ASSIGN
	SumYear.StYear = y
	SumYear.Sum = 0
  . 
END.



FOR EACH loan WHERE loan.contract   EQ "card-pers" 
		AND loan.class-code EQ "card-loan-pers"
		AND loan.cust-cat  EQ '�'
		/*AND CAN-DO("����,���,����",loan.loan-status)*/
NO-LOCK:

IF loan.cont-code EQ "CORP/RUR/07-001" THEN
	message "1" view-as alert-box.

i = 0.
Ost408 = 0.
Ost423 = 0.
flag_card_otkr = yes.
flag_card_zakr = no.
tmp_card_enddate = ?.

	IF AVAIL(loan) THEN
	  DO:

		FIND FIRST tcard WHERE tcard.contract EQ 'card' 
				AND tcard.parent-cont-code EQ loan.cont-code 
				AND tcard.parent-contract EQ loan.contract
				AND NOT(CAN-DO('����,�,��', TRIM (tcard.loan-status)) )
		NO-LOCK NO-ERROR.

		IF NOT(AVAIL(tcard)) THEN
			flag_card_otkr = no . /* �.�. �� ������� ��� ������� ����. ����� �������� ��� �������� */


		FOR EACH card WHERE card.contract EQ 'card' 
				AND card.parent-cont-code EQ loan.cont-code 
				AND card.parent-contract EQ 'card-pers' 
				AND CAN-DO ('����,�,��', TRIM (card.loan-status) )
		NO-LOCK:
			IF AVAIL(card) THEN
			  DO:
				flag_card_zakr = yes .  /* �.�. �� ������� ���� ������� �����. ����� �������� ��� �������� */

				IF tmp_card_enddate < card.end-date  OR tmp_card_enddate = ? THEN
					tmp_card_enddate = card.end-date .
			  END.
		END.


		IF flag_card_otkr = no AND flag_card_zakr = yes  THEN
		  DO:
			FOR EACH loan-acct OF loan 
				WHERE CAN-DO("40817*,40820*,42309*",loan-acct.acct)
			NO-LOCK:

				IF AVAIL(loan-acct) THEN				  
				  DO:

					RUN acct-pos IN h_base (loan-acct.acct,loan-acct.currency,end-date,end-date,"�").

					Ost408 = IF loan-acct.acct BEGINS "408" THEN ABS(sh-bal) ELSE 0.
					Ost423 = IF loan-acct.acct BEGINS "423" THEN ABS(sh-bal) ELSE 0.

					IF (sh-bal <> 0) OR (sh-val <> 0) THEN
					  DO:

        					i = i + 1 .
						IF ( i = 1 ) THEN iagr = iagr + 1 .

						FIND FIRST person WHERE	person.person-id = loan.cust-id
						NO-LOCK NO-ERROR.

						PUT STREAM rep_excel UNFORM 
							( IF ( i = 1 ) THEN (person.name-last + " " + person.first-names) ELSE "") ";" 
							( IF ( i = 1 ) THEN REPLACE(loan.loan-status,"�","V") ELSE "") ";" 
							( IF ( i = 1 ) THEN loan.cont-code   ELSE "") ";" 
							STRING(YEAR(tmp_card_enddate)) ";"
							"_"  loan-acct.acct ";"
							( IF ( loan-acct.acct BEGINS "408" ) THEN STRING(Ost408)   ELSE STRING(Ost423) ) ";"
						SKIP.

						FOR EACH SumYear NO-LOCK:
						  IF SumYear.StYear = YEAR(tmp_card_enddate) THEN
						    DO:
							SumYear.Sum = SumYear.Sum + Ost423 + Ost408 .
						    END.
						END.

					  END. /* end_if */
				  END. /* end_IF AVAIL(loan-acct) */
			END. /* end_for_each */

		  END. /* end_IF flag_card_otkr = no AND flag_card_zakr = yes */

	END. /* end_IF AVAIL(loan)*/

END.

PUT STREAM rep_excel UNFORM SKIP (2).
PUT STREAM rep_excel UNFORM "�ᥣ� ������஢;" iagr SKIP.


PUT STREAM rep_excel UNFORM "����⨪� �� �����;" SKIP.
PUT STREAM rep_excel UNFORM "���;" "�㬬� (� ��.);" SKIP.

FOR EACH SumYear NO-LOCK:
	PUT STREAM rep_excel UNFORM SumYear.StYear ";" SumYear.Sum ";" SKIP.
END.



OUTPUT STREAM rep_excel CLOSE.


MESSAGE tmpFile VIEW-AS ALERT-BOX  TITLE "���� ��࠭�� �:".
