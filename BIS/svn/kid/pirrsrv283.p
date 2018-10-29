{pirsavelog.p}

/* 
                ���������: 
                ��ᯮ�殮��� �� १�ࢠ� 283-�
                ��ᨭ�� �.�. 07.03.2008.
                
                ��ᯮ�殮��� �� १�ࢠ� 232-�
                ���� �.�. 10.01.2006 10:19
                
                �᫮�����, �� ��㧥� ��࠭� ⮫쪮 "�ࠢ����" ���㬥���, �.�. �,
                ����� ������ �⮡ࠦ����� � �����饬 �ᯮ�殮���.
                
*/

/* �������塞 �������� ����ன��*/
{globals.i}
{intrface.get count}
{get-bankname.i}

{tmprecid.def}

/* �뢮� � preview */
{pir-out2arch.i &postfix=".txt"}
&IF DEFINED(arch2)=0 &THEN
{setdest.i}
&ENDIF

/* ������⥪� �㭪権 ��� ࠡ��� � ��⠬� */
{ulib.i}

{getdate.i}

/** ����������� **/

DEF INPUT PARAM inParam AS CHAR NO-UNDO.
/* ��� १�ࢠ: ��।���� � ��࠭�� ��� � �⮩ ��६����� */
DEF VAR acct_rsrv AS CHAR NO-UNDO.
/* �����ᮢ� ���, ����� �������� � ���� �⮫��� */
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

DEF VAR client_name AS CHAR    NO-UNDO.
DEF VAR loaninf     AS CHAR    NO-UNDO.
DEF VAR grrisk      AS INTEGER NO-UNDO.
DEF VAR prrisk      AS DECIMAL NO-UNDO.
DEF VAR prrisk2     AS DECIMAL NO-UNDO.

/* �⮣��� ���祭�� */
DEF VAR total_pos_rur AS DECIMAL NO-UNDO.
DEF VAR total_pos_usd AS DECIMAL NO-UNDO.
DEF VAR total_pos_eur AS DECIMAL NO-UNDO.

DEF VAR total_calc_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_real_rsrv AS DECIMAL NO-UNDO.

DEF VAR total_create_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_delete_rsrv AS DECIMAL NO-UNDO.
/* �뢮� �訡�� �� �࠭ */
DEF VAR traceOn AS LOGICAL INITIAL false NO-UNDO.
/* �६����� ��� ࠡ��� */
DEF VAR tmpStr AS CHAR NO-UNDO.
/* �������� � ������ */
DEF VAR PIRbos AS CHAR    NO-UNDO.
DEF VAR PIRbosFIO AS CHAR NO-UNDO.
DEF VAR userPost AS CHAR  NO-UNDO.

/* ��६����� ��� op-transaction */
DEF VAR op_trans AS INT NO-UNDO.
DEF VAR op_doc   AS DEC NO-UNDO.
DEF VAR doc_num2 AS DEC NO-UNDO.


/* �஢�ઠ �室�饣� ��ࠬ��� 
IF NUM-ENTRIES(inParam) <> 2 THEN DO:
  MESSAGE "�������筮� ���-�� ��ࠬ��஢. ������ ���� <���_���㬥��>,<���_�㪮����⥫�_��_PIRBoss>" 
          VIEW-AS ALERT-BOX.
  RETURN.
END.

PIRbos = ENTRY(1,FGetSetting("PIRboss",ENTRY(2, inParam),"")).
PIRbosFIO = ENTRY(2,FGetSetting("PIRboss",ENTRY(2, inParam),"")). */
/*
DEF VAR PIRbosU5    AS CHAR NO-UNDO.
DEF VAR PIRbosU5FIO AS CHAR NO-UNDO.

PIRbosU5 = ENTRY(1,FGetSetting("PIRboss","PIRbosU5","")).
PIRbosU5FIO = ENTRY(2,FGetSetting("PIRboss","PIRbosU5","")).

DEF VAR PIRbosD6    AS CHAR NO-UNDO.
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
PUT UNFORMATTED  "�����������������������������Ŀ" SKIP.
PUT UNFORMATTED  "���ᯮ�殮��� �� �ନ஢���� �" SKIP.
PUT UNFORMATTED  "�१�ࢮ� �� �������� ���� �" SKIP.
PUT UNFORMATTED  "�������������������������������                                                                               " SKIP(2).
PUT UNFORMATTED  "                                                                                                               " cBankName SKIP(2).
PUT UNFORMATTED  "                                                                                     ��� ᮢ��襭�� ����権: " STRING(DATE-rasp,"99/99/9999") SKIP(3).
PUT UNFORMATTED  "                                         � � � � � � � � � � � �" skip(1)
                 '    � ᮮ⢥��⢨� � ���������� ����� ���ᨨ �283-� �� 20.03.2006�.  "� ���浪� �ନ஢���� �।��묨 �࣠�����ﬨ १�ࢮ� �� �������� ����"' SKIP
                 '���� ��� �ॣ㫨஢��� १�� �� �����ᮢ� ��⠬, ��騬��� ����⠬� ���⭮� ����:' SKIP
                 "����������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
                "�     � �����        �     ������������ �������          �   �������     ����� ������������� ���. � %  � ����� ������. � ����� �������.�   ���������   �  ������������ �" SKIP
    "�                    �                                   �   �� ����    �   � (��) ���⮪ � �����   � ������� � ���.� ������� � ���.������� (� ���.)������� (� ���.)�" SKIP
                 "�                    �                                   �   (47423)     �   � �� 47423      �         �               �               �               �               �" SKIP
                 "����������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.


/* ��� ��� ���㬥�⮢, ��࠭��� � ��o㧥� �믮��塞... */
FOR EACH tmprecid NO-LOCK, FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK:

    FIND FIRST op-entry OF op NO-LOCK.
              
        ASSIGN amt_create = 0.
               amt_delete = 0.
               /* 
               acct_main_no = op-entry.acct-db.
               acct_main_cur = "810".
               */
         op_trans = op.op-transaction.

END.

/*  
��᫮� �. �. 28.10.2008
��⠭�� �訡�� � ����� ���᪠.
����� �訡�筮 �᪠��� ��᫥���� ���㬥�� ᮧ����� �࠭���樥� op_trans. 
�� �⮬ �� ���뢠���� ���㬥��� ��࠭�� � ��㧥�.
*/

FOR EACH tmprecid NO-LOCK, LAST op WHERE RECID(op) EQ tmprecid.id AND op.op-transaction EQ op_trans NO-LOCK:                  

/*
 ��᫮� �. �.
�� �ᥬ ���㬥�⠬ ��࠭�� � ��㧥� ��⮢. ��室�� ��᫥���� ���㬥�� ����� ��࠭ � ����� ᮧ��� �࠭���樥� op_trans
*/

  FIND LAST op-entry OF op  NO-LOCK.


      IF op-entry.acct-db BEGINS "47425" THEN        ASSIGN acct_rsrv = op-entry.acct-db amt_delete = amt-rub.
            IF op-entry.acct-cr BEGINS "47425" THEN ASSIGN acct_rsrv = op-entry.acct-cr amt_create = amt-rub.

      IF acct_rsrv = "" THEN 
                   DO:
                        MESSAGE "� �஢���� ���㬥�� " + op.doc-num + " ��� ��� १�ࢠ 47425!" VIEW-AS ALERT-BOX.
                        RETURN.
                   END.            
     
                /* ������� ����� �������� ����� ������ */
                
        /* �����᭮ ॠ����樨 १�ࢨ஢���� 232-� � ��������, ����� ��� ������ ���� �ਢ易� 
                 � �����ᮢ��� ���� �१ �������⥫��� ��� � ����� 80. �஢�ਬ ����⢮����� ������ �裡
        */ 
                 
        FIND FIRST links WHERE
                links.link-id = 80
                AND
                ENTRY(1, links.target-id) = acct_rsrv
                NO-LOCK NO-ERROR.

        IF AVAIL links THEN 
                 /* �᫨ ��� �������, � ��࠭�� ����� � ������ ��������ᮢ��� ��� */ 
                DO:
                        acct_main_no = ENTRY(1,links.source-id).
                        acct_main_cur = ENTRY(2,links.source-id).
                        IF acct_main_cur = "" THEN acct_main_cur = "810".
                END.
        ELSE
                 /* ���� �뤠�� ᮮ�饭�� �� �訡�� � �����蠥� ࠡ��� ��楤��� */
                DO:
                        MESSAGE "��� १�ࢠ " + acct_rsrv + " �� �ਢ易� �१ ���.��� � '��������' ����!" VIEW-AS ALERT-BOX.
                        RETURN.
                END.  
        
        



        /* ������ ��� १�ࢠ � �஢����. �� ���� �� ������, ���� �� �।��� � ��稭����� � 47425 
           ����⭮ ��࠭�� ���祭�� �㬬� �஢���� � ᮮ⢥�������� ��६����� 
        */


        /* �᫨ ��-⠪� �� �� ������, �� �� �।��� ���, ��稭��騩�� �� 4 �� ������, 
           �뤠�� ᮮ�饭�� � ��室�� �� ��楤��� */

                    
         /* ������ ���⮪ �� �����ᮢ��� ���� �� ���� */
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
         
         /* ������ �������� ������ */
         client_name = GetAcctClientName_UAL(acct_rsrv, traceOn).


         
                  /* ������ ��業��� �⠢��. ���᫨� �� ��� ��⭮� �� ������� ���⭮�� १�ࢠ �� �㡫��� ���⮪ 
            ��������ᮢ��� ��� 
         */         
         /* prrisk = ROUND(acct_rsrv_calc_pos / acct_main_pos_rur, 2) * 100. */
         /* ������ ��業��� �⠢��. ��� �࠭���� � ���.४����� ��������ᮢ��� ��� */
         
         /*
         tmpStr = GetXAttrValueEx("acct",acct_main_no + "," + (if acct_main_cur="810" then "" else acct_main_cur),"pers-reserve","").
         IF tmpStr <> "" THEN
                         prrisk = DECIMAL(tmpStr).
                         
         */
         
         /*  prrisk = GetCommRate_ULL("%���", "", 0, acct_main_no, 0, end-date, TRUE). */

   /*  ���� ��業� �᪠ �� ���.४����� ���㬥�� "��業� १�ࢠ" */
             prrisk = DEC(GetXAttrValueEx("op", STRING(op.op),"�����",?)).
        
         IF prrisk = ? 
         THEN 
             DO: 
                      MESSAGE "�� ���㬥�� �����: " + op.doc-num + " �� �������� ���.�������� <�����>! ����室��� ��������� ४�����, ���⠢�� � ���� ���祭�� ��業� १�ࢠ �� ������ ����樨, � �������� ���� ����୮." VIEW-AS ALERT-BOX.
                           RETURN. 
                         END.
                  
         /* ��।���� ��㯯� �᪠ �� ��業⭮� �⠢�� */
         IF prrisk = 0 THEN grrisk = 1.
         IF prrisk >= 1 AND prrisk <= 20 THEN grrisk = 2.
         IF prrisk > 20 AND prrisk <= 50 THEN grrisk = 3.
         IF prrisk > 50 AND prrisk < 100 THEN grrisk = 4.
         IF prrisk = 100 THEN grrisk = 5.
         
         /* �뢮��� ��ப� ⠡���� */
         PUT UNFORMATTED 
                 "�" acct_main_no FORMAT "x(20)"
                 "�" client_name FORMAT "x(35)"
                 "�" ABS(acct_main_pos) FORMAT "->>>,>>>,>>9.99"
                 "�" acct_main_cur FORMAT "xxx"
                 "�" ABS(acct_main_pos_rur) FORMAT "->>>,>>>,>>9.99"
                 "�" grrisk FORMAT ">>"
                 "�" prrisk FORMAT ">>9.9" "%"
                 "�" ABS(acct_rsrv_calc_pos) FORMAT "->>>,>>>,>>9.99"
                 "�" ABS(acct_rsrv_real_pos) FORMAT "->>>,>>>,>>9.99"
                 "�" amt_create FORMAT "->>>,>>>,>>9.99"
                 "�" amt_delete FORMAT "->>>,>>>,>>9.99" 
                 "�" SKIP
                 "����������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.

	/***** ��᫮�
	 *
	 * ���㧪� � ��娢 *
	 *
	 ***********************/
	&IF DEFINED(arch2) &THEN
			   /*** ����砥� ���㬥��� ��� ��ࠢ����� ***/
			   UpdateSignsEx('opb',STRING(op.op),"PirA2346U",STRING(iCurrOut)).
	&ENDIF

END.

/* �뢮��� �⮣��� ���祭�� */
PUT UNFORMATTED 
                 "�       �����:       " 
                 "�" SPACE(35)
                 "�" ABS(total_pos_rur) FORMAT "->>>,>>>,>>9.99"
                 "�810"
                 "�" SPACE(15)
                 "�" SPACE(2)
                 "�" SPACE(6)
                 "�" ABS(total_calc_rsrv) FORMAT "->>>,>>>,>>9.99"
                 "�" ABS(total_real_rsrv) FORMAT "->>>,>>>,>>9.99"
                 "�" ABS(total_create_rsrv) FORMAT "->>>,>>>,>>9.99"
                 "�" ABS(total_delete_rsrv) FORMAT "->>>,>>>,>>9.99" 
                 "�" SKIP
          "�                    " 
                 "�" SPACE(35)
                 "�" ABS(total_pos_usd) FORMAT "->>>,>>>,>>9.99"
                 "�840"
                 "�" SPACE(15)
                 "�" SPACE(2)
                 "�" SPACE(6)
                 "�" SPACE(15)
                 "�" SPACE(15)
                 "�" SPACE(15)
                 "�" SPACE(15)
                 "�" SKIP
/* ����� ᪮� ����������� 
                 "�                    " 
                 "�" SPACE(35)
                 "�" SPACE(25)
                 "�" ABS(total_pos_eur) FORMAT "->>>,>>>,>>9.99"
                 "�978"
                 "�" SPACE(15)
                 "�" SPACE(2)
                 "�" SPACE(4)
                 "�" SPACE(15)
                 "�" SPACE(15)
                 "�" SPACE(15)
                 "�" SPACE(15)
                 "�" SKIP
*/
                 "������������������������������������������������������������������������������������������������������������������������������������������������������������������������" SKIP(4).

/* ������ � ������� */

PUT UNFORMATTED PIRbos SPACE(100 - LENGTH(PIRbos)) PIRbosFIO SKIP(5).

FIND FIRST _user WHERE _user._userid EQ userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN DO:
        userPost = GetXAttrValueEx("_user", _user._userid, "���������", "").
        PUT UNFORMATTED userPost FORMAT "x(100)" _user._user-name SKIP.
END.
ELSE
        PUT UNFORMATTED "�ᯮ���⥫�:" SKIP.


/* �⮡ࠦ��� ᮤ�ন��� preview */
&IF DEFINED(arch2)=0 &THEN
{preview.i}
&ELSE
{preview.i &filename=cPath}
&ENDIF