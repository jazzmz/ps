/* ========================================================================= */
/** 
    Copyright: ��� ��� ����, ��ࠢ����� ��⮬�⨧�樨 (C) 2013
     Filename: pirexpu5soglpodft.p
      Comment: ��ᯮ�� ������ � �ଠ� afx ��� ������� ��������� 
		�� �������� ��,�� (�।�⭮��, ������⭮��)
   Parameters: ������ ��� 䠩�� �ᯮ��
         Uses:
      Created: ��⮢ �.�., 28.03.2013
     Modified: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>) 
               <���ᠭ�� ���������>                                           
*/
/* ========================================================================= */


{globals.i}		/** �������� ��।������ */
{tmprecid.def}		/** ������祭�� ���������� �ᯮ�짮���� ���ଠ�� ��㧥� */
{intrface.get strng}
{ulib.i}		/** ������⥪� ���-�㭪権 */
{pir_expmaster.fun}     /** ������⥪� �㭪権 ��� ����� */


/* ========================================================================= */
				/** ������� */
/* ========================================================================= */

  /* �室�� ��ࠬ���� ��楤��� */
DEF INPUT PARAM iParam AS CHAR.

DEF VAR out_file_name AS CHAR. 
DEF VAR dogtype AS CHAR. 
DEF VAR name          AS CHAR. 
DEF VAR nameshort     AS CHAR. 
DEF VAR predstfioip   AS CHAR. 
DEF VAR predstpostip  AS CHAR. 


/* ========================================================================= */
				/** ��������� */
/* ========================================================================= */


IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/ssitov/tmp/new_data.afx".


OUTPUT TO VALUE(out_file_name).


FOR FIRST tmprecid 
NO-LOCK,
FIRST loan 
  WHERE RECID(loan) EQ tmprecid.id 
NO-LOCK,
FIRST loan-cond 
  WHERE loan-cond.contract = loan.contract 
  AND  loan-cond.cont-code = loan.cont-code 
NO-LOCK : 


	/** ���뢠�騩 �� */	
	RUN Master_OutStr("<data>").


		/** ������ */
	IF loan.cust-cat = "�" THEN
	DO:
	  FIND FIRST cust-corp WHERE cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
	  IF AVAIL cust-corp THEN
	  DO:
		IF cust-corp.cust-stat = "��" THEN
		DO:
		  name = "�������㠫�� �।�ਭ���⥫� " + cust-corp.name-corp .
		  nameshort = "�� " + cust-corp.name-corp .
		  predstfioip  = cust-corp.name-corp .
		  predstpostip = "" .
		END.
		ELSE
		DO:
		  name = GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"FullName","") .
		  nameshort = cust-corp.name-short .
		  predstfioip  = REPLACE(GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"�����",""),";","")   .
		  predstpostip = LC(GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"�����","")) .
		END.

		RUN Master_OutStr("<client>").
		RUN Master_OutStr("name=" 		+  name ).
		RUN Master_OutStr("nameshort=" 		+  nameshort ).
		RUN Master_OutStr("addrur=" 		+  Master_GetClntAddr(cust-corp.cust-id,"�","�����") ).
		RUN Master_OutStr("addrfakt=" 		+  Master_GetClntAddr(cust-corp.cust-id,"�","�������") ).
		RUN Master_OutStr("inn=" 		+  cust-corp.inn ).
		RUN Master_OutStr("ogrn=" 		+  GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"����","") ).
		RUN Master_OutStr("predstfio=" 		+  predstfioip  ).
		RUN Master_OutStr("predstfioip="	+  predstfioip  ).
		RUN Master_OutStr("predstpost="		+  predstpostip ).
		RUN Master_OutStr("predstpostip="	+  predstpostip ).
		RUN Master_OutStr("predstdoc=" 		+  "��⠢�").
		RUN Master_OutStr("</client>").
	  END.
	END.
	ELSE
	DO:
	  MESSAGE "��� �� �ਭ������� �ਤ��᪮�� ���� / �������㠫쭮�� �।�ਭ���⥫�!" VIEW-AS ALERT-BOX.
	  RETURN.
	END.


		/** ���������� � �������, �� �᭮����� ���ண� ��� �������� */
	IF CAN-DO("loan_allocat,loan-transh,loan-tran-lin",loan.class-code) THEN
	  dogtype = "�।�⭮�� �������" . .
	IF CAN-DO("loan_attract",loan.class-code) THEN
	  dogtype = "������⭮�� �������" .


	RUN Master_OutStr("<agreement>").
	RUN Master_OutStr("number="		+  "" ). /* ���������� � �ଥ ����� */
	RUN Master_OutStr("date="		+  "" ). /* ���������� � �ଥ ����� */
	RUN Master_OutStr("dognumber="		+  loan.cont-code ).
	RUN Master_OutStr("dogdate="		+  STRING(loan.open-date, "99/99/9999") ).
	RUN Master_OutStr("dogcurrency="	+  (if loan.currency = "" then "810" else loan.currency) ).
	RUN Master_OutStr("dogtype="		+  dogtype ).
	RUN Master_OutStr("</agreement>").


		/** ������������ */					
	RUN Master_OutStrUser(userid("bisquit")).

		/** ��������� �������� */					
	RUN Master_OutStr("<expproc>").
	RUN Master_OutStr("procname=" + "pirexpu5soglpodft.p" ).
	RUN Master_OutStr("</expproc>").


	RUN Master_OutStr("</data>").

END. /* ����� 横�� */

OUTPUT CLOSE.

MESSAGE "����� �ᯥ譮 �ᯮ��஢���!" VIEW-AS ALERT-BOX.
