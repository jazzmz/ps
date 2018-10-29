/* ------------------------------------------------------
     File: $RCSfile: spr-nal.p,v $ $Revision: 1.6 $ $Date: 2010-01-19 08:31:58 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: 
     �� ������: ��ࠢ�� � ��������� (���⭠� �ଠ) 
     ��� ࠡ�⠥�: 
     ��ࠬ����:  
     ���� ����᪠: �� - �����  
     ����: $Author: borisov $ 
     ���������: $Log: not supported by cvs2svn $
     ���������: Revision 1.5  2008/08/25 08:04:05  Buryagin
     ���������: Added the correspond account of Bank
     ���������:
------------------------------------------------------ */

{pirsavelog.p}

/* Modifyed by Setpanov S.V. 17/06/1999 - �롮� ��楢��� ��� �� ᯨ᪠ */

{globals.i}
def var v-acct like acct.acct no-undo.
def var nam as character no-undo.
def var tip as character no-undo.
def var cli as character no-undo.

PAUSE 0.
DO TRANSACTION ON ERROR UNDO, LEAVE /* ON ENDKEY UNDO, LEAVE */ WITH FRAME dateframe2:
  UPDATE
    v-acct LABEL "��楢�� ���" HELP "������ ����� ��� ��� ������ F1"
      WITH CENTERED ROW 10 OVERLAY SIDE-LABELS 1 COL
           COLOR MESSAGES TITLE "[ ������� ������� ���� ]"
    EDITING:
       READKEY.
       IF LASTKEY = 301 THEN DO:
           RUN "acct.p"("b", 3) .
           IF (LASTKEY = 13 OR lastkey = 10) AND pick-value <> ? THEN
             DISPLAY ENTRY(1, pick-value) @ v-acct.
       END.
       ELSE
         APPLY LASTKEY.
    END.
  IF INPUT v-acct  <> ? THEN DO:
    FIND FIRST acct WHERE acct.acct = v-acct NO-LOCK NO-ERROR.
    IF NOT AVAIL acct THEN DO:
     {message "��� ⠪��� ���"}
     UNDO,RETRY.
    END.
  END.
END.
HIDE FRAME dateframe2 NO-PAUSE.

if acct.cust-cat ne "�" then do:
        message "��� ��� - �� ��� �ਤ��᪮�� ���.".
        return.
end.

if acct.currency ne "" then
	nam = " ����⭮�� ��� ".
else
	nam = " �㡫����� ��� ".

IF acct.close-date ne ? then
  do:
	tip = " � �����⨨ " + string(acct.close-date).
	cli = "������ ".
	end.
else
	do:
  tip = " �� ����⨨ " + string(acct.open-date).
  cli = "������� ".
  end.
IF /*ENTRY(2,GetXAttrValueEx("acct", acct.acct + "," + acct.curr, "��������",""),",") eq ?  or 
	 ENTRY(2,GetXAttrValueEx("acct", acct.acct + "," + acct.curr, "��������",""),",") eq "" or*/
	 NUM-ENTRIES(GetXAttrValueEx("acct", acct.acct + "," + acct.curr, "��������","")) ne 2
  then 
      do:
         MESSAGE "���ࠢ��쭮 �������� ���. ४����� �������� �� ���!" skip
         VIEW-AS ALERT-BOX.
         RETURN.
      end.

{setdest.i}
find cust-corp of acct no-lock.
put unformatted
skip(2)
"���. N ______" skip
"�� __________" skip(2)
"                       ����������� ����� "  name-bank FORMAT "X(70)" skip
"                          ������� " cust-corp.name-short skip
"                        " + CAPS(substring(tip,2,11)) + " ���������� �����" skip(2)
"       ���� " name-bank + ", ����騩 ����� ॣ����樮����� ���" skip
"���: "FGetSetting("�������",?,"") + " �/�: " + FGetSetting("�����",?,"") + " ���: " + substring(FGetSetting("���",?,""),1,10) + " ���: " FGetSetting("�������",?,"") + " ����: "  FGetSetting("����",?,"")skip
"㢥������" + tip + " ���⭮�� ��� � " + acct.acct skip
cli  cust-corp.name-short /* format "x(40)" */ skip
"� ॣ����樮��묨 ����묨: ���/���: " + cust-corp.inn + "/" + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "���", "") +  " ���: " + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "���", "") skip(2)
/* "� �����祭�� " ENTRY(1,GetXAttrValueEx("acct", acct.acct + "," + acct.curr, "��������",""),",") 
+ " ������� ������᪮�� ���" skip
"�� N: " +  ENTRY(2,GetXAttrValueEx("acct", acct.acct + "," + acct.curr, "��������",""),",")
+ tip nam acct.acct skip(2)*/
"                                                   ����䮭 (495) 974-20-78  " skip(3)
        
"�������⭮� ��� �����   ________________ " ENTRY(2,FGetSetting("PIRboss","PIRbosD6","")) skip      
"                            �������" skip
"                                     �.�." skip        
.
/* {signatur.i}*/
{preview.i}
