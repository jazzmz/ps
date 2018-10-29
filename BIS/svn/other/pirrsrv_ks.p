{pirsavelog.p}

/* 
		��ᯮ�殮��� �� १�ࢠ� 232-�
		���� �.�. 10.01.2006 10:19
		
		�᫮�����, �� ��㧥� ��࠭� ⮫쪮 "�ࠢ����" ���㬥���, �.�. �,
		����� ������ �⮡ࠦ����� � �����饬 �ᯮ�殮���.
*/

/* �������塞 �������� ����ன��*/
{globals.i}
/* �뢮� � preview */
{setdest.i}
/* ������⥪� �㭪権 ��� ࠡ��� � ��⠬� */
{ulib.i}
{intrface.get instrum}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{get-bankname.i}
/** ����������� **/

/* ��� १�ࢠ: ��।���� � ��࠭�� ��� � �⮩ ��६����� */
DEF VAR acct_rsrv AS CHAR NO-UNDO.
/* ��������ᮢ� ���, ����� �������� � ���� �⮫��� */
DEF VAR acct_main_no  AS CHAR NO-UNDO.
DEF VAR acct_main_cur AS CHAR NO-UNDO.
/* ������ �� ���� */
DEF VAR acct_main_pos AS DECIMAL NO-UNDO.
DEF VAR acct_main_pos_rur AS DECIMAL NO-UNDO.
DEF VAR acct_rsrv_calc_pos AS DECIMAL NO-UNDO.
DEF VAR acct_rsrv_real_pos AS DECIMAL NO-UNDO.

/* �㬬� ����樨 */
DEF VAR amt_create AS DECIMAL NO-UNDO.
DEF VAR amt_delete AS DECIMAL NO-UNDO.
DEF VAR amt_korr   AS DECIMAL NO-UNDO.

DEF VAR client_name AS CHAR extent 2 no-undo.
DEF VAR loaninf AS CHAR NO-UNDO.
DEF VAR grrisk AS INTEGER NO-UNDO.
DEF VAR prrisk AS INTEGER NO-UNDO.
DEF VAR mEnd AS INTEGER NO-UNDO.
DEF VAR kursop AS DECIMAL NO-UNDO.

/* �⮣��� ���祭�� */
DEF VAR total_pos_rur AS DECIMAL NO-UNDO.
DEF VAR total_pos_usd AS DECIMAL NO-UNDO.
DEF VAR total_pos_eur AS DECIMAL NO-UNDO.
DEF VAR total_calc_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_real_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_create_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_delete_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_korr_rsrv AS DECIMAL NO-UNDO.

def var PIRbosKazna as char NO-UNDO.
def var PIRbosKaznaFIO as char NO-UNDO.

/* �뢮� �訡�� �� �࠭ */
DEF VAR traceOn AS LOGICAL INITIAL false NO-UNDO.
/* �६����� ��� ࠡ��� */
DEF VAR tmpStr AS CHAR NO-UNDO.
/* �������� � ������ */
DEF VAR PIRbosloan AS CHAR NO-UNDO.
DEF VAR PIRbosloanFIO AS CHAR NO-UNDO.
PIRbosloan = ENTRY(1,FGetSetting("PIRboss","PIRbosloan","")).
PIRbosloanFIO = ENTRY(2,FGetSetting("PIRboss","PIRbosloan","")).
/*
DEF VAR PIRbosU5 AS CHAR NO-UNDO.
DEF VAR PIRbosU5FIO AS CHAR NO-UNDO.
PIRbosU5 = ENTRY(1,FGetSetting("PIRboss","PIRbosU5","")).
PIRbosU5FIO = ENTRY(2,FGetSetting("PIRboss","PIRbosU5","")).
DEF VAR PIRbosD6 AS CHAR NO-UNDO.
DEF VAR PIRbosD6FIO AS CHAR NO-UNDO.
PIRbosD6 = ENTRY(1,FGetSetting("PIRboss","PIRbosD6","")).
PIRbosD6FIO = ENTRY(2,FGetSetting("PIRboss","PIRbosD6","")).
*/
/* ��� �ᯮ�殮��� */
DEF VAR DATE-rasp AS DATE NO-UNDO.

/** ���������� **/

/* �� ��ࢮ� ����樨 ������ ���� ���� */
DATE-rasp = TODAY.
FOR FIRST tmprecid NO-LOCK,
		FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK
		:
		DATE-rasp = op.op-DATE.
END.

/* ����� ���� */
PUT UNFORMATTED  "                                                                                                               � �����⠬���-3" SKIP.
PUT UNFORMATTED  "                                                                                                               " cBankName SKIP(2).
PUT UNFORMATTED  "                                                                                                               " STRING(DATE-rasp,"99/99/9999") SKIP(3).
PUT UNFORMATTED  "                                         � � � � � � � � � � � �" skip(1)
	 	'             � ᮮ⢥��⢨� � ���������� ����� ���ᨨ "� ���浪� �ନ஢���� �।��묨 �࣠�����ﬨ १�ࢮ� �� �������� ����"' SKIP
	 	'���� ��� �ॣ㫨஢��� १�� �� ��������ᮢ� ��⠬, ��騬��� ����⠬� ���⭮� ����:' SKIP
	 	"������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
		"�                    �                                   �  ���   �  ����  � �㬬� ���⪠ � �㬬� ���⪠ ���⥣-�          �㬬� १�ࢠ        �     �㬬�     �" SKIP
                "�    ����� ���     �     ������������ ����ࠣ���      � ������ � ������ ��� �/� � ����⥳�� �/� � �㡫�峪��-�� �������������������������������Ĵ ���४�஢�� �" SKIP 		
                "�                    �                                   �        �        �               �               � � %   �   ���⭮��  �   ᮧ�������  �               �" SKIP
	 	"������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.

  find last tmprecid no-lock.
  if avail tmprecid then mEnd = tmprecid.id.
/* ��� ��� ���㬥�⮢, ��࠭��� � ��o㧥� �믮��塞... */
FOR EACH tmprecid 
         NO-LOCK,
   FIRST op WHERE 
         RECID(op) EQ tmprecid.id 
         NO-LOCK, 
   FIRST op-entry OF op
         NO-LOCK
: 
	
	ASSIGN amt_create = 0 amt_delete = 0.
	/* ������ ��� १�ࢠ � �஢����. �� ���� �� ������, ���� �� �।��� � ��稭����� � 4 
	   ����⭮ ��࠭�� ���祭�� �㬬� �஢���� � ᮮ⢥�������� ��६����� 
	*/
	IF op-entry.acct-db BEGINS "3" THEN	ASSIGN acct_rsrv = op-entry.acct-db amt_delete = amt-rub amt_korr = amt_delete.
	IF op-entry.acct-cr BEGINS "3" THEN ASSIGN acct_rsrv = op-entry.acct-cr amt_create = amt-rub amt_korr = amt_create.

	/* �᫨ ��-⠪� �� �� ������, �� �� �।��� ���, ��稭��騩�� �� 4 �� ������, 
	   �뤠�� ᮮ�饭�� � ��室�� �� ��楤��� */
	IF acct_rsrv = "" THEN 
		DO:
			MESSAGE "� �஢���� ���㬥�� " + op.doc-num + " ��� ��� १�ࢠ, ��稭��饣��� �� 4!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
	/* �����᭮ ॠ����樨 १�ࢨ஢���� 232-� � ��������, ����� ��� ������ ���� �ਢ易� 
		 � ��������ᮢ��� ���� �१ ���.४�����. �஢�ਬ ����⢮����� ������ �裡 */
	FIND FIRST signs WHERE 
		file-name = "acct"	
		AND
		code = "acct-reserve"
		AND
		code-value = acct_rsrv
		NO-LOCK NO-ERROR.
	IF AVAIL signs THEN 
		/* �᫨ ��� �������, � ��࠭�� ����� � ������ ��������ᮢ��� ��� */
		DO:
			acct_main_no = ENTRY(1,surrogate).
			acct_main_cur = ENTRY(2,surrogate).
			IF acct_main_cur = "" THEN acct_main_cur = "810".
	        END.
	ELSE
		/* ���� �뤠�� ᮮ�饭�� �� �訡�� � �����蠥� ࠡ��� ��楤��� */
		DO:
			MESSAGE "��� १�ࢠ " + acct_rsrv + " �� �ਢ易� �१ ���.४����� � ��������ᮢ��� ����!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
	
/* ���� */
	IF acct_main_cur ne "" THEN
	    kursop = FindRateSimple("����",acct_main_cur,op.op-date).
	       
	    
	 /* ������ ���⮪ �� ��������ᮢ��� ���� �� ���� */
	 acct_main_pos     = ABS(GetAcctPosValue_UAL(acct_main_no, acct_main_cur, op.op-DATE, traceOn)).
	 acct_main_pos_rur = ABS(GetAcctPosValue_UAL(acct_main_no, "810", op.op-DATE, traceOn)).
	 
	 /* ������ ����� १��. �� ᠬ�� ����, �� ������ �믮������ ��楤��� �� 䠪��᪨ 㦥 
	    ��ନ஢���� १��
	 */
	 acct_rsrv_calc_pos = ABS(GetAcctPosValue_UAL(acct_rsrv, "810", op.op-DATE, traceOn)).
	 
	 /* ������ ��ନ஢���� १��. ��᪮��� �ᯮ�殮��� �ନ����� �� 䠪��, �.�. �� �஢�����, �
	 	  �㬬� ��ନ஢������ १�ࢠ = ���⮪ �� ��� १�ࢠ +- �㬬� �஢���� 
	 */
	 acct_rsrv_real_pos = acct_rsrv_calc_pos - amt_create + amt_delete.
	 
	 /* ����������� �⮣��� �㬬� */
	 IF acct_main_cur = "810" THEN
	   total_pos_rur = total_pos_rur + acct_main_pos.
	 IF acct_main_cur = "840" THEN
	   total_pos_usd = total_pos_usd + acct_main_pos.
	 /* ����� ᪮� ����������� 
	 IF acct_main_cur = "978" THEN
	   total_pos_eur = total_pos_eur + acct_main_pos.
	 */
	 ASSIGN  
	   total_calc_rsrv = total_calc_rsrv + acct_rsrv_calc_pos
	   total_real_rsrv = total_real_rsrv + acct_rsrv_real_pos
	   total_create_rsrv = total_create_rsrv + amt_create
	   total_delete_rsrv = total_delete_rsrv + amt_delete.
	   total_korr_rsrv = total_korr_rsrv + amt_create + amt_delete.
	   
	 
	 /* ������ �������� ������ */
        FIND FIRST acct WHERE acct.acct EQ acct_rsrv NO-LOCK NO-ERROR.
        {getcust.i &name=client_name &OFFinn = "/*" &OFFsigns = "/*"}
        client_name[1]= client_name[1] + " " + Client_Name[2].
	 
	
	/* ������ ���� */
	 /* ������ ���ଠ�� � ������� */
	 FIND FIRST loan-acct WHERE
	 		loan-acct.acct = acct_rsrv
	 		AND
	 		loan-acct.contract = "�।��"
	 		NO-LOCK NO-ERROR.
	 IF AVAIL loan-acct THEN
	   DO:
	     FIND FIRST loan WHERE
	       loan.contract = loan-acct.contract
	       AND
	       loan.cont-code = loan-acct.cont-code
	       NO-LOCK NO-ERROR.
	     IF AVAIL loan THEN
	       DO:
	       	 loaninf = loan.cont-code + " �� ". 
				   prrisk = loan.risk.
				   FIND FIRST signs WHERE  
									signs.code = "��⠑���"
									AND 
									signs.file-name = "loan"
									AND 
									signs.surrogate = "�।��," + loan.cont-code
									NO-LOCK NO-ERROR.
					 IF AVAIL signs THEN
					   DO:
							 loaninf = loaninf + signs.code-value.
						 END.
					 ELSE
					 	 DO:
						   loaninf = loaninf + STRING(loan.open-DATE,"99/99/9999").
						 END.
	       END.
	   END.
   ELSE 
	 	 loaninf = "�� ��।����".

	 /* ������ ��業��� �⠢��. ���᫨� �� ��� ��⭮� �� ������� ���⭮�� १�ࢠ �� �㡫��� ���⮪ 
	    ��������ᮢ��� ��� 
	 */	 
	 /* prrisk = ROUND(acct_rsrv_calc_pos / acct_main_pos_rur, 2) * 100. */
	 /* ������ ��業��� �⠢��. ��� �࠭���� � ���.४����� ��������ᮢ��� ��� */
	 tmpStr = GetXAttrValueEx("acct",acct_main_no + "," + (if acct_main_cur="810" then "" else acct_main_cur),"pers-reserve","").
	 IF tmpStr <> "" THEN
	 		prrisk = DECIMAL(tmpStr).
	 tmpStr = GetXAttrValueEx("acct",acct_main_no + "," + (if acct_main_cur="810" then "" else acct_main_cur),"����᪠","").
	 IF tmpStr <> "" THEN
	 		grrisk = integer(substring(tmpStr,1,1)).

	 
	 /* ��।���� ��㯯� �᪠ �� ��業⭮� �⠢�� */
	/* IF prrisk = 0 THEN grrisk = 1.
	 IF prrisk >= 1 AND prrisk <= 20 THEN grrisk = 2.
	 IF prrisk > 20 AND prrisk <= 50 THEN grrisk = 3.
	 IF prrisk > 50 AND prrisk < 100 THEN grrisk = 4.
	 IF prrisk = 100 THEN grrisk = 5.
*/
	 
	 /* �뢮��� ��ப� ⠡���� */
	 PUT UNFORMATTED 
	 	"�" acct_main_no FORMAT "x(20)"
	 	"�" client_name[1] FORMAT "x(35)"
	 	"�" acct_main_cur FORMAT "xxx" at 62
	 	"�"  at 67 kursop format ">>9.9999" 
		"�" ABS(acct_main_pos) FORMAT "->>>,>>>,>>9.99"
	 	"�" ABS(acct_main_pos_rur) FORMAT "->>>,>>>,>>9.99"
	 	"�" grrisk FORMAT ">>"
	 	"�" prrisk FORMAT ">>9" "%"
	 	"�" ABS(acct_rsrv_calc_pos) FORMAT "->>>,>>>,>>9.99"
	 	"�" ABS(acct_rsrv_real_pos) FORMAT "->>>,>>>,>>9.99"
	 	"�" amt_korr FORMAT "->>>,>>>,>>9.99"
/*	 	"�" amt_delete FORMAT "->>>,>>>,>>9.99" 
*/
	 	"�" SKIP.
	if tmprecid.id eq mEnd then
PUT UNFORMATTED "������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
       else
PUT UNFORMATTED	"������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.


END.
/* �뢮��� �⮣��� ���祭�� */
PUT UNFORMATTED "�                                                                                                                             �⮣� ᮧ����:       �" + string(total_create_rsrv,"->>>,>>>,>>9.99") + "�" skip.
PUT UNFORMATTED "�                                                                                                                             �⮣� ����⠭�����:  �" + string(total_delete_rsrv,"->>>,>>>,>>9.99") + "�" skip.
PUT UNFORMATTED "�                                                                                                                             �ᥣ�:               �" + string(total_korr_rsrv,"->>>,>>>,>>9.99") + "�" skip.
PUT UNFORMATTED "��������������������������������������������������������������������������������������������������������������������������������������������������������������������" skip(2).

/* ������ � ������� */
PIRbosKazna = ENTRY(1,FGetSetting("PIRboss","PIRbosKazna","")).
PIRbosKaznaFIO = ENTRY(2,FGetSetting("PIRboss","PIRbosKazna","")).

PUT UNFORMATTED PIRbosKazna SPACE(100 - LENGTH(PIRboskazna)) PIRbosKaznaFIO SKIP(5).

FIND FIRST _user WHERE _user._userid EQ userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	PUT UNFORMATTED "��砫쭨� �⤥�� ����権"  SKIP
	                "�� 䨭������ �뭪��:     " SPACE(75) _user._user-name SKIP.
ELSE
	PUT UNFORMATTED "��砫쭨� �⤥�� ����権"  SKIP
	                "�� 䨭������ �뭪��:" SKIP.


/* �⮡ࠦ��� ᮤ�ন��� preview */
{preview.i}