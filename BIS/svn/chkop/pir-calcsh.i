/* ------------------------------------------------------
File		: $RCSfile: pir-calcsh.i,v $ $Revision: 1.3 $ $Date: 2007-09-12 10:04:12 $
Copyright	: ��� �� "�p������������"
�����祭��	: ���४�� ���⪠ �����頥���� �㭪樥� acct-pos �� �㬬� ���㬥��
���� ����᪠	: ��뢥��� �� pir-chkop.p
��ࠬ����	: &p-m - ����䨪��� �⢥�⢥��� �� ᫮�����/���⠭�� �㬬� ���㬥��
����		: $Author: lavrinenko $ 
���������	: $Log: not supported by cvs2svn $
���������	: Revision 1.2  2007/06/13 13:29:29  lavrinenko
���������	:  ��ࠡ�⪠ �� ����砭�� �� �६� ���樨
���������	:
------------------------------------------------------ */
ASSIGN 		             
   sh-bal = sh-bal {&p-m} b-op-entry.amt-rub
   sh-val = sh-val {&p-m} IF b-op-entry.curr > "" 
                             THEN (b-op-entry.amt-cur) 
                             ELSE 0
.
