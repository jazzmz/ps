/* ------------------------------------------------------
File          : $RCSfile: pir-log.i,v $ $Revision: 1.1 $ $Date: 2007-08-08 11:55:03 $
Copyright     : ��� �� "�p������������"
�����祭��    : �ப������ ��᫥���� �����/�맮� �����/������� � ����� pir-log
              : ��㦨� ��� �⫮�� "������ ��室�����"
��ࠬ����     : module  - ��� �����/������� - �㦥� ��易⥫쭮
	      : comment - �������਩ ࠧࠡ��稪�
	      :	nodef   - �⪫�祭�� ��।������ ����஢ ��� DataBlock/DataLine
	      :	�ਬ��� �맮��:
	      :    1. {pir-log.i &module="��� ����� ��� �������"}
	      :    2. {pir-log.i &module="$_RCSfile$"} 
	      :    3. {pir-log.i &module="$_RCSfile$" &comment="�������ਨ ��� ������ ��������� ࠧࠡ��稪��"}
	      : �� ��ਠ�⮢ 2 � 3 ����ન����� ��᫥ $ �㦭� ���� ��� ����⠭���� ���祢�� ᫮� CVS-��
���� ����᪠ : ����砥��� � ⥫� "�����ॢ�����" ��楤���
����         : $Author: lavrinenko $ 
���������     : $Log: not supported by cvs2svn $
------------------------------------------------------ */

&IF DEFINED (module) &THEN
    DO TRANS:
	&IF DEFINED (nodef-pir-log) EQ 0 &THEN
	    DEF BUFFER pir-DB for DataBlock.
	    DEF BUFFER pir-DL for DataLine.
	    &GLOBAL nodef-pir-log
	&ENDIF
	FIND FIRST pir-DB WHERE pir-DB.DataClass-ID = 'pir-log'    AND
	                        pir-DB.Branch-ID    = dept.branch  NO-LOCK NO-ERROR.
	IF AVAILABLE pir-DB THEN DO:
	   FIND FIRST pir-DL WHERE pir-DL.Data-ID  = pir-DB.Data-ID AND
	                           pir-DL.Sym1     = "{&module}" EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

 	  IF AVAIL pir-DL THEN ASSIGN 
		pir-DL.Sym3   = STRING (TODAY) + ' ' + STRING(TIME,"HH:MM:SS")
	        pir-DL.Sym4   = USERID('bisquit')
	        pir-DL.val[1] = pir-DL.val[1] + 1
		pir-DL.txt    = "{&comment}"
	  . /* IF AVAIL pir-DL */
	  ELSE IF NOT LOCKED(pir-DL) THEN DO:
		CREATE pir-DL.
		ASSIGN
	  	   pir-DL.Data-ID = pir-DB.Data-ID
		   pir-DL.Sym1    = "{&module}"
		   pir-DL.Sym2    = STRING (TODAY) + ' ' + STRING(TIME,"HH:MM:SS")
		   pir-DL.Sym3 	  = STRING (TODAY) + ' ' + STRING(TIME,"HH:MM:SS")
		   pir-DL.Sym4 	  = USERID('bisquit')
		   pir-DL.val[1]  = 1
		   pir-DL.txt  	  = "{&comment}"
		.
	  END. /* ELSE IF NOT LOCKED(pir-DL) */
        END. /* IF AVAILABLE pir-DB THEN */	
			
	RELEASE pir-DL.
	RELEASE pir-DB.
END. /* DO TRANS */
&ELSE 
       &MESSAGE ** ������ -- �� �맮�� $RCSfile: pir-log.i,v $: ��ࠬ��� module ������ ���� ��।���� !!!
&ENDIF