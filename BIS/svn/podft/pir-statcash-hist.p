
/***** ================================================================= *****/
/*** 	��楤�� ���� ���ਨ �� ��� �� �뤠�� �������
	�� ���� (�����䨪��� PirStatCash) 
	�室��� ��ࠬ��� - ��� ��.��� ��ୠ�� (�������� - ⨯ CHAR)
	����� - �� ��楤��� pir-statcash-podft.p 		           ***/

/* ��� ��� �������� ����� ���� ����������         
   �� �� ��᫥ ���஢����
*/

/***** ================================================================= *****/



/***** ================================================================= *****/
/*** 	          ������� ���������, ���������� � ��.                      ***/
/***** ================================================================= *****/

DEF INPUT PARAM iCode AS CHAR.
/*
MESSAGE "pir-statcash-hist.p  INPUT PARAM iCode = "  iCode " ww= " ENTRY(2,iCode,",") VIEW-AS ALERT-BOX. 
*/
/*
iCode = "PirStatCash,168_810_�_1107_20121119" .
iCode = "PirStatCash,5196_810_�_3363_20121205_36286" .
*/


DEF VAR dttime		AS CHAR    NO-UNDO.
DEF VAR username	AS CHAR    NO-UNDO.
DEF VAR modify		AS CHAR    NO-UNDO.
DEF VAR fieldvalue	AS CHAR    NO-UNDO.
         
DEF VAR hst_name  	AS CHAR    NO-UNDO. 
DEF VAR hst_name_1	AS CHAR    NO-UNDO. 
DEF VAR hst_name_2	AS CHAR    NO-UNDO. 
DEF VAR hst_name_3	AS CHAR    NO-UNDO. 
DEF VAR hst_name_4 	AS CHAR    NO-UNDO.
           
DEF VAR bhst_name  	AS CHAR    NO-UNDO.
DEF VAR bhst_name_1	AS CHAR    NO-UNDO.
DEF VAR bhst_name_2	AS CHAR    NO-UNDO.
DEF VAR bhst_name_3	AS CHAR    NO-UNDO.
DEF VAR bhst_name_4	AS CHAR    NO-UNDO.

DEF VAR hst_val  	AS CHAR    NO-UNDO. 
DEF VAR hst_val_1	AS CHAR    NO-UNDO. 
DEF VAR hst_val_2	AS CHAR    NO-UNDO. 
DEF VAR hst_val_3	AS CHAR    NO-UNDO. 
DEF VAR hst_val_4 	AS CHAR    NO-UNDO.
           
DEF VAR bhst_val  	AS CHAR    NO-UNDO.
DEF VAR bhst_val_1	AS CHAR    NO-UNDO.
DEF VAR bhst_val_2	AS CHAR    NO-UNDO.
DEF VAR bhst_val_3	AS CHAR    NO-UNDO.
DEF VAR bhst_val_4	AS CHAR    NO-UNDO.

DEF VAR hst_dsc  	AS CHAR    NO-UNDO. 
DEF VAR hst_dsc_1	AS CHAR    NO-UNDO. 
DEF VAR hst_dsc_2	AS CHAR    NO-UNDO. 
DEF VAR hst_dsc_3	AS CHAR    NO-UNDO. 
DEF VAR hst_dsc_4 	AS CHAR    NO-UNDO.
           
DEF VAR bhst_dsc  	AS CHAR    NO-UNDO.
DEF VAR bhst_dsc_1	AS CHAR    NO-UNDO.
DEF VAR bhst_dsc_2	AS CHAR    NO-UNDO.
DEF VAR bhst_dsc_3	AS CHAR    NO-UNDO.
DEF VAR bhst_dsc_4	AS CHAR    NO-UNDO.


DEFINE BUFFER bhist FOR history .


   /*** ���������  ****/ 
DEF VAR oTpl       AS TTpl      NO-UNDO.
DEF VAR oTableDoc  AS TTableCSV NO-UNDO.

oTpl = new TTpl("pir-statcash-hist.tpl").
oTableDoc = new TTableCSV(5).


/*
{setdest.i}
*/

FOR EACH history
    WHERE history.modify NE "RUN"
    AND history.modify NE "PRINT"
    AND history.modify NE "SAVE"
    AND history.field-ref EQ iCode
    AND history.file-name EQ 'code'
NO-LOCK:

  dttime   = "" .
  username = "" .
  modify   = "" .
  fieldvalue = "" .

  hst_name   = "" .
  hst_name_1 = "" .
  hst_name_2 = "" .
  hst_name_3 = "" .
  hst_name_4 = "" .
  
  bhst_name   = "" . 
  bhst_name_1 = "" .
  bhst_name_2 = "" .
  bhst_name_3 = "" .
  bhst_name_4 = "" .

  hst_val     = "" . 
  hst_val_1   = "" . 
  hst_val_2   = "" . 
  hst_val_3   = "" . 
  hst_val_4   = "" . 
                     
  bhst_val    = "" .
  bhst_val_1  = "" .
  bhst_val_2  = "" .
  bhst_val_3  = "" .
  bhst_val_4  = "" .
          
  hst_dsc     = "" . 
  hst_dsc_1   = "" . 
  hst_dsc_2   = "" . 
  hst_dsc_3   = "" . 
  hst_dsc_4   = "" . 
                     
  bhst_dsc    = "" .
  bhst_dsc_1  = "" .
  bhst_dsc_2  = "" .
  bhst_dsc_3  = "" .
  bhst_dsc_4  = "" .

  
  FIND FIRST _user WHERE _user._userid = history.user-id NO-LOCK NO-ERROR.
  IF AVAIL(_user) THEN
    DO:

     IF NUM-ENTRIES(_user._user-name," ") > 2 THEN
	username = history.user-id + " - " + ENTRY(1,_user._user-name," ") + " " + SUBSTRING(ENTRY(2,_user._user-name," "),1,1) + "." + SUBSTRING(ENTRY(3,_user._user-name," "),1,1) + "." .
     ELSE
	username = history.user-id + " - " + _user._user-name .

    END.
  ELSE 
     username = history.user-id .


  dttime = STRING(history.modif-date,"99/99/99") + " " + STRING(history.modif-time,"hh:mm:ss") .


  CASE history.modify:
     WHEN "C" THEN 
     DO:
	modify = "ᮧ�����" .

	FIND FIRST bhist WHERE RECID(bhist) = RECID(history) NO-LOCK NO-ERROR .
	FIND NEXT  bhist 
	    WHERE bhist.modify EQ "W"
	    AND   bhist.field-ref EQ iCode
	    AND   bhist.file-name EQ 'code'
	    AND   LOOKUP("name", bhist.field-value,"," ) > 0
	NO-LOCK NO-ERROR.

	IF AVAIL(bhist) THEN
	  DO:
		bhst_name = ENTRY( LOOKUP("name", bhist.field-value ) + 1, bhist.field-value , ",") .	
		bhst_name = REPLACE(bhst_name,CHR(2),",") .
		fieldvalue = "���: "  + ENTRY(1,bhst_name,";") + "; " + 
			     "�㬬�: " + ENTRY(2,bhst_name,";") + "; " +
			     "��� ��室�: " + ENTRY(3,bhst_name,";") .
	  END.
	ELSE 
	  DO:
		FIND FIRST code 
			WHERE code.class  EQ 'PirStatCash' 
			AND code.code   EQ ENTRY(2,iCode,",")
		NO-LOCK NO-ERROR.
		fieldvalue = "���: "  + ENTRY(1,code.name,";") + "; " + 
			     "�㬬�: " + ENTRY(2,code.name,";") + "; " +
			     "��� ��室�: " + ENTRY(3,code.name,";") .
	  END.
     END.

     WHEN "D" THEN 
     DO:
	modify = "㤠�����" .
	fieldvalue = "��� 㤠���� �� �����䨪��� ���" .
     END.

     WHEN "W" THEN 
     DO:

	modify = "���������".
        fieldvalue = "" . 

/*
message "field-value = " history.field-value view-as alert-box.
*/
/*** �� ���� code.name ***/

	IF LOOKUP("name", history.field-value,"," ) > 0 THEN
	DO:

	  hst_name = ENTRY( LOOKUP("name", history.field-value ) + 1, history.field-value , ",") .	
	  hst_name = REPLACE(hst_name,CHR(2),",") .
	  hst_name_1 = ENTRY(1,hst_name,";") . /* ���    */
	  hst_name_2 = ENTRY(2,hst_name,";") . /* �㬬�   */
	  hst_name_3 = ENTRY(3,hst_name,";") . /* ��室  */
	  hst_name_4 = ENTRY(4,hst_name,";") . /* �ਧ��� */

	  FIND FIRST bhist WHERE RECID(bhist) = RECID(history) NO-LOCK NO-ERROR .

	  FIND NEXT  bhist 
	      WHERE bhist.modify EQ "W"
	      AND   bhist.field-ref EQ iCode
	      AND   bhist.file-name EQ 'code'
	      AND   LOOKUP("name", bhist.field-value,"," ) > 0
	  NO-LOCK NO-ERROR.

	  IF AVAIL(bhist) THEN
	  DO:

		bhst_name = ENTRY( LOOKUP("name", bhist.field-value ) + 1, bhist.field-value , ",") .	
		bhst_name = REPLACE(bhst_name,CHR(2),",") .
		bhst_name_1 = ENTRY(1,bhst_name,";") .  /* ���    */
		bhst_name_2 = ENTRY(2,bhst_name,";") .  /* �㬬�   */
		bhst_name_3 = ENTRY(3,bhst_name,";") .  /* ��室  */
		bhst_name_4 = ENTRY(4,bhst_name,";") .  /* �ਧ��� */

		IF bhst_name_4 <> hst_name_4 THEN
		   fieldvalue = fieldvalue + " �ਧ���: " + bhst_name_4 .

		IF bhst_name_2 <> hst_name_2 THEN
		   fieldvalue = fieldvalue + " �㬬�: " + bhst_name_2 .

		IF bhst_name_3 <> hst_name_3 THEN
		   fieldvalue = fieldvalue + " ��� ��室�: " + bhst_name_3 .

	  END.
	  ELSE
	  DO:

		FIND FIRST code 
			WHERE code.class  EQ 'PirStatCash' 
			AND code.code   EQ ENTRY(2,iCode,",")
		NO-LOCK NO-ERROR.

		IF hst_name_4 <> ENTRY(4,code.name,";") THEN
		   fieldvalue = fieldvalue + " �ਧ���: " + ENTRY(4,code.name,";") .

		IF hst_name_2 <> ENTRY(2,code.name,";") THEN
		   fieldvalue = fieldvalue + " �㬬�: " + ENTRY(2,code.name,";") .

		IF hst_name_3 <> ENTRY(3,code.name,";") THEN
		   fieldvalue = fieldvalue + " ��� ��室�: " + ENTRY(3,code.name,";") .

	  END.
	END. /* end_if LOOKUP("name", history.field-value,"," ) > 0 */



/*** �� ���� code.val ***/

	IF LOOKUP("val", history.field-value,"," ) > 0 THEN
	DO:

	  hst_val = ENTRY( LOOKUP("val", history.field-value ) + 1, history.field-value , ",") .	
	  hst_val = REPLACE(hst_val,CHR(2),",") .
	  hst_val_1 = ENTRY(1,hst_val,";") . /* ����    */
	  hst_val_2 = ENTRY(2,hst_val,";") . /* ��稭� */
	  hst_val_3 = ENTRY(3,hst_val,";") . /* ����   */
	                                                  

	  FIND FIRST bhist WHERE RECID(bhist) = RECID(history) NO-LOCK NO-ERROR .

	  FIND NEXT  bhist 
	      WHERE bhist.modify EQ "W"
	      AND   bhist.field-ref EQ iCode
	      AND   bhist.file-name EQ 'code'
	      AND   LOOKUP("val", bhist.field-value,"," ) > 0
	  NO-LOCK NO-ERROR.

	  IF AVAIL(bhist) THEN
	  DO:

		bhst_val = ENTRY( LOOKUP("val", bhist.field-value ) + 1, bhist.field-value , ",") .	
		bhst_val = REPLACE(bhst_val,CHR(2),",") .
		bhst_val_1 = ENTRY(1,bhst_val,";") .  /* ����    */
		bhst_val_2 = ENTRY(2,bhst_val,";") .  /* ��稭� */
		bhst_val_3 = ENTRY(3,bhst_val,";") .  /* ����   */


		IF bhst_val_1 <> hst_val_1 THEN
		   fieldvalue = fieldvalue + " �����: " + bhst_val_1 .

		IF bhst_val_2 <> hst_val_2 THEN
		   fieldvalue = fieldvalue + (if bhst_val_2 <> "" then " ��稭�: " else "" ) + bhst_val_2 .

		IF bhst_val_3 <> hst_val_3 THEN
		   fieldvalue = fieldvalue + " ����: " + bhst_val_3 .

	  END.
	  ELSE
	  DO:

		FIND FIRST code 
			WHERE code.class  EQ 'PirStatCash' 
			AND code.code   EQ ENTRY(2,iCode,",")
		NO-LOCK NO-ERROR.

		IF hst_val_1 <> ENTRY(1,code.val,";") THEN
		   fieldvalue = fieldvalue + " �����: " + ENTRY(1,code.val,";") .

		IF hst_val_2 <> ENTRY(2,code.val,";") THEN
		   fieldvalue = fieldvalue + (if ENTRY(2,code.val,";") <> "" then " ��稭�: " else "" ) + ENTRY(2,code.val,";") .
      		/***
		IF hst_val_3 <> ENTRY(3,code.val,";") THEN
		   fieldvalue = fieldvalue +  " ����: " + ENTRY(3,code.val,";") .
                */
	  END.
	END. /* end_if LOOKUP("val", history.field-value,"," ) > 0 */



/*** �� ���� code.description[1] ***/

	IF LOOKUP("description[1]", history.field-value,"," ) > 0 THEN
	DO:

	  hst_dsc = ENTRY( LOOKUP("description[1]", history.field-value ) + 1, history.field-value , ",") .	
	  hst_dsc = REPLACE(hst_dsc,CHR(2),",") .
	  hst_dsc_1 = ENTRY(1,hst_dsc,";") . /* �ਧ��� ����� �� �뤠���� */
	  hst_dsc_2 = ENTRY(2,hst_dsc,";") . /* ��⨢�����                */
	  hst_dsc_3 = ENTRY(3,hst_dsc,";") . /* 童� �ࠢ�����            */


	  FIND FIRST bhist WHERE RECID(bhist) = RECID(history) NO-LOCK NO-ERROR .

	  FIND NEXT  bhist 
	      WHERE bhist.modify EQ "W"
	      AND   bhist.field-ref EQ iCode
	      AND   bhist.file-name EQ 'code'
	      AND   LOOKUP("description[1]", bhist.field-value,"," ) > 0
	  NO-LOCK NO-ERROR.

	  IF AVAIL(bhist) THEN
	  DO:

		bhst_dsc = ENTRY( LOOKUP("description[1]", bhist.field-value ) + 1, bhist.field-value , ",") .	
		bhst_dsc = REPLACE(bhst_dsc,CHR(2),",") .
		bhst_dsc_1 = ENTRY(1,bhst_dsc,";") .  /* �ਧ��� ����� �� �뤠����  */  
		bhst_dsc_2 = ENTRY(2,bhst_dsc,";") .  /* ��⨢�����                 */
		bhst_dsc_3 = ENTRY(3,bhst_dsc,";") .  /* 童� �ࠢ�����             */ 

		IF (bhst_dsc_3 <> hst_dsc_3) AND (bhst_dsc_3 <> "") THEN
		   fieldvalue = fieldvalue + " �⢥न� 童� �ࠢ�����: " + bhst_dsc_3 .

	  END.
	  ELSE
	  DO:
		FIND FIRST code 
			WHERE code.class  EQ 'PirStatCash' 
			AND code.code   EQ ENTRY(2,iCode,",")
		NO-LOCK NO-ERROR.

		IF (hst_dsc_3 <> ENTRY(3,code.description[1],";")) AND (ENTRY(3,code.description[1],";") <> "" ) THEN
		   fieldvalue = fieldvalue + " �⢥न� 童� �ࠢ�����: " + ENTRY(3,code.description[1],";") .

	  END.
	END. /* end_if LOOKUP("description[1]", history.field-value,"," ) > 0 */


        IF TRIM(fieldvalue) = "" THEN
	  fieldvalue = "��ᯮ����� �ࠪ�� ��������� �� 㤠����. ����室��� �������஢��� �����䨪��� PirStatCash" .


     END.
     OTHERWISE 
	modify = "�������⭮" .
  END CASE.




  oTableDoc:addRow().
  oTableDoc:addCell(dttime).
  oTableDoc:addCell(modify).
  oTableDoc:addCell(username).
  oTableDoc:addCell(fieldvalue).

  
/*
 PUT UNFORM    "file-name           "    history.file-name              SKIP .
 PUT UNFORM    "field-name          "    history.field-name             SKIP .
 PUT UNFORM    "field-value         "    history.field-value            SKIP .
 PUT UNFORM    "modif-date          "    history.modif-date             SKIP .
 PUT UNFORM    "user-id             "    history.user-id                SKIP .
 PUT UNFORM    "field-ref           "    history.field-ref              SKIP .
 PUT UNFORM    "modif-time          "    history.modif-time             SKIP .
 PUT UNFORM    "last-rec            "    history.last-rec               SKIP .
 PUT UNFORM    "modify              "    history.modify                 SKIP .
 PUT UNFORM    "history-id          "    history.history-id             SKIP .
 PUT UNFORM    "snd-date            "    history.snd-date               SKIP .
 PUT UNFORM    "snd-time            "    history.snd-time               SKIP .
 PUT UNFORM    "obj-transaction-id  "    history.obj-transaction-id     SKIP(2).
*/

END.



IF oTableDoc:HEIGHT <> 0 THEN  oTpl:addAnchorValue("TABLEDOC",oTableDoc). ELSE oTpl:addAnchorValue("TABLEDOC","*** ��� ������ ***").

{setdest.i}
oTpl:show().
{preview.i}


DELETE OBJECT oTableDoc.
DELETE OBJECT oTpl.
