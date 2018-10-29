/* ------------------------------------------------------
File          : $RCSfile: pirraproc.i,v $ $Revision: 1.4 $ $Date: 2007-08-21 13:36:43 $
Copyright     : ��� �� "�p������������"
�����祭��    : AutoSave PrintReports 
���ᠭ��      : ��� ࠡ��� ��楤��� �ॡ���� ��६����� in-end-date ⨯� "���". � �⮩ ��६����� 
              :	������ �࠭����� ���祭�� ���� ���⭮�� ��ਮ��.
              : �᫨ � ���⥪�� ��楤��� ��६����� in-end-date �� ��।�����, � �㦭�
              : �� �����. ���॥ �ᥣ� � ��楤�� ���� �맮� 䠩�� {getdate.i}, � ���஬ ���� 
              : ��।������ ��६����� beg-date � end-date. ���뢠� ��, ����� �������:
              : def var in-end-date like end-date.
              : in-end-date = end-date.
              : �᫨ 㪠���� &prefix="yes", � �㦭� ��।����� ��६����� prefix,
              : def var prefix as char no-undo.
              : prefix = "X" + "Y".
              : �ਬ�� �ᯮ�짮�����:
              : {pirraproc.def} /* define variables */
              : /* � �������� ᪮���� ������祭� ����易⥫�� ��ࠬ���� */
              : {pirraproc.i &arch_file_name="some_name.txt" [&prefix="yes"]} /* Creating archive directory */
              : {setdest.i ... &filename=arch_file_name ...}
              : {preview.i ... &filename=arch_file_name ...}
��ࠬ����     : ��ࠬ���� ��।������ ��楤��/�������
���� ����᪠ : ���ᠭ�� �窨 � ��� "�������", ��㤠 �ந�������� ����� ��楤���
����         : Buryagin
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.3  2007/08/14 11:59:09  Lavrinenko
���������     : ��ࠡ�⪨ ��।�������� ������ ���
���������     :
���������     : Revision 1.2  2007/08/13 12:50:48  Lavrinenko
���������     : 1. �������� ��������� 2. �������� ��ࠬ��� ������� &in-end-date
���������     :
              : 17.11.2005 11:51 
              : Buryagin added the next code
------------------------------------------------------ */

&IF DEFINED (in-end-date) EQ 0 &THEN
      &GLOB in-end-date in-end-date  
&ENDIF

enabled = FGetSetting("PIRReportArch","PIRRAenabled","yes").
if enabled = "yes" then
do:
	arch_dir_name = FGetSetting("PIRReportArch","PIRRArootdir","").
	tmp_str = STRING({&in-end-date}, "99/99/9999").
	
	&IF DEFINED (in-beg-date) NE 0 &THEN
	    IF {&in-beg-date} NE {&in-end-date} THEN
	       tmp_str = SUBSTR (tmp_str,4).
	       
	    IF MONTH({&in-beg-date}) NE MONTH({&in-end-date}) THEN
	       tmp_str = SUBSTR (tmp_str,4).
	&ENDIF
	/* 
			In the next loop creating the tree of directories, such as:
				/root_arch_dir/YYYY/MM/DD
	*/
	DO i_loop = NUM-ENTRIES(tmp_str, '/') TO 0 BY -1 :
		arch_dir_name = arch_dir_name + "/" + ENTRY(i_loop, tmp_str, "/") NO-ERROR.
		OS-CREATE-DIR VALUE(arch_dir_name).
		stat = OS-ERROR.
	END.
	
	&IF DEFINED(arch_file_name) &THEN 
	        &IF DEFINED(arch_file_name_var) EQ 0 &THEN 
		        arch_file_name = "{&arch_file_name}".
		&ELSE
		        arch_file_name = {&arch_file_name}.
		
		&ENDIF
		&IF DEFINED(prefix) &THEN
			arch_file_name = prefix + arch_file_name.
		&ENDIF
	&ELSE 
		/* Now, specify the var "arch_file_name"
			  Get a value of the setting "PIRRAfiles". This value must have the next format
					"class_name=file_name,class_name=file_name,...".
				Find the "class_name" equals the global input param "InputFName". 
				If success, then assign arch_file_name = "file_name",
				else assign arch_file_name = &arch_file_name.
				IF var arch_file_name have a empty value, then set default
		*/
		tmp_str = FGetSetting("PIRReportArch","PIRRAfiles","").
		DO i_loop = 1 TO NUM-ENTRIES(tmp_str):
			IF ENTRY(1,ENTRY(i_loop,tmp_str),"=") = TRIM(InputFName) then
				arch_file_name = ENTRY(2,ENTRY(i_loop,tmp_str),"=").
		END.
	&ENDIF
	
	if arch_file_name = "" then arch_file_name = FGetSetting("PIRReportArch","PIRRAdefault","").

	arch_file_name = arch_dir_name + "/" + arch_file_name.

END.
ELSE
	arch_file_name = "./_spool.tmp".

/* Buryagin end */

