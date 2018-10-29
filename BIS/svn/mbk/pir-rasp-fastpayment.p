/***********************************************************
 *                                                         *                                      
 *                                                         *
 * ��楤�� �ନ��� �ᯮ�殮��� �� ��筮� ᤥ���.     *                                                                                                  *
 *                                                         *
 *                                                         *
 ***********************************************************
 * ����: ��᪮� �.�.                                     *
 * ��� ᮧ�����: 21.04.2010                               *
 * ��� �684                                             *
 ***********************************************************/
{globals.i}

DEF VAR oTpl AS TTpl.

DEF VAR PIRispl AS Char.
DEF VAR userpost AS Char.
DEF VAR cSummProp AS CHAR.
DEF VAR cSummProp_Kopp AS CHAR.

DEF VAR Summa_rasp AS DECIMAL.
Summa_rasp = ?.

oTpl = new TTpl("pir-rasp-fastpayment.tpl").

  FORM
     Summa_rasp
        FORMAT "9999999999.99" 
        LABEL  "�㬬� ���⥦�"  
        HELP   "�㬬� ���⥦�"
  WITH FRAME frParam 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ������� ����� ]".

  PAUSE 0.

  UPDATE
     Summa_rasp
  WITH FRAME frParam.

  HIDE FRAME frParam NO-PAUSE.

  oTpl:addAnchorValue("DATE",TODAY).
  oTpl:addAnchorValue("Summa",Summa_rasp).

   RUN x-amtstr.p(Summa_rasp,"810",FALSE,FALSE, OUTPUT cSummProp, OUTPUT cSummProp_Kopp).

  oTpl:addAnchorValue("Summa_stroka",TRIM(cSummProp)).
  oTpl:addAnchorValue("Summa_Kopeek",TRIM(cSummProp_Kopp)).


IF PIRispl = "" 
THEN DO:

        FIND FIRST _user WHERE _user._userid EQ userid NO-LOCK NO-ERROR.
        IF AVAIL _user THEN DO:
                userPost = GetXAttrValueEx("_user", _user._userid, "���������", "").
                oTpl:addAnchorValue("USER_POST",userPost).
        END.
        ELSE
                oTpl:addAnchorValue("USER_POST","�ᯮ���⥫�:").
END.
ELSE         IF PIRispl <> '0' THEN do:
                oTpl:addAnchorValue("USER_POST","�ᯮ���⥫�:").
                end.

{setdest.i}
  oTpl:show().
{preview.i}

DELETE OBJECT oTpl.