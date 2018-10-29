{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-redrep.p,v $ $Revision: 1.6 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ��� �� "�p������������"
�����祭��    : ���� �� ��⠬, �� ������ ��������� ��᭮� ᠫ줮, � ���뫪�� ���� �� ����.
��稭�	      : �ᨫ���� ����� ��⨢ ��᭮�� ᠫ줮
���� ����᪠ : �����஢騪 �����.
��ࠬ����     : �室��� ��ࠬ��� (iParam) �������� ᫥���騥 ���祭�� (ࠧ������� ;):
                - ��� �६������ 䠩��
                - ��� ���⮢��� �ਯ� � ��ࠬ��ࠬ� (sendmail)
                - ���᮪ ���ᮢ ��� ���뫪� 㢥�������� ࠧ�������� �����묨
����         : $Author: anisimov $ 
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.5  2007/09/05 13:48:31  Lavrinenko
���������     : ��࠮⪠ ���� �� ��⠬ � ���� ᠫ줮 - �����뢠���� ����稥 ��୮�� ���
���������     :
���������     : Revision 1.4  2007/07/05 11:46:44  lavrinenko
���������     : 1. ��࠭�  ��ࠬ���� ����᪠���譥�� �ਯ� �� ����. 2. ���ࠢ��� ���������
���������     :
���������     : Revision 1.3  2007/06/25 07:44:44  lavrinenko
���������     : ������� ���冷� ᫥������� �����, �������� �����祭�� �鸞 �����
���������     :
���������     : Revision 1.2  2007/06/22 12:03:17  lavrinenko
���������     : ���� �� ��⠬ � ���� ᠫ줮
���������     :
���������     : Revision 1.1  2007/06/22 12:02:24  lavrinenko
���������     : ���� �� ��⠬ � ���� ᠫ줮
���������     :
----------------------------------------------------- */

{globals.i}
{sh-defs.i}
{intrface.get xclass}

DEFINE INPUT PARAMETER iParam AS CHAR.
DEFINE VARIABLE vSumSaldo AS DECIMAL NO-UNDO.
DEFINE VARIABLE vCount    AS INTEGER NO-UNDO INITIAL 0.

OUTPUT TO VALUE(ENTRY(1,iParam,';')) .
PUT UNFORMAT "To: " ENTRY(3,iParam,';') 									SKIP
						 "Content-Type: text/plain; charset = ibm866" SKIP
						 "Content-Transfer-Encoding: 8bit" 						SKIP
						 "Subject: ��᭮� ᠫ줮 �� ��⠬ �� " STRING(TIME,"HH:MM:SS") " " TODAY "" SKIP(2).
						 
PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Start'  SKIP.

FOR EACH acct 
	  WHERE acct.acct-cat EQ 'b' AND acct.close EQ ? NO-LOCK:
	  	
    RUN acct-pos IN h_base (acct.acct, acct.currency, TODAY, TODAY, "���").
		
		vSumSaldo = IF acct.currency EQ "" THEN sh-bal ELSE sh-val.

	  IF ((vSumSaldo > 0) AND (acct.side = "�")) OR  
	  	 ((vSumSaldo < 0) AND (acct.side = "�")) THEN DO:
	  	 	vCount = vCount + 1.	
				PUT UNFORMAT acct.acct ' ' acct.side ' ' STRING(vSumSaldo,"->>>,>>>,>>>,>>>,>>9.99") ' '  
				             GetXAttrValueEx("acct", acct.acct + "," + acct.currency,"�������줮",?) ' ' (IF {assigned acct.contr-acct} THEN "(���� ���� ���)" ELSE "") SKIP.
		END.
		  	
END.
PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Finish' SKIP.

OUTPUT CLOSE.			  

IF vCount NE 0 AND OPSYS = "UNIX" THEN DO:
	 OS-COMMAND SILENT VALUE(ENTRY(2,iParam,';') + " < " + ENTRY(1,iParam,';')).
END.

OS-DELETE VALUE(ENTRY(1,iParam,';')).
