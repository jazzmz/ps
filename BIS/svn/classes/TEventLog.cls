CLASS TEventLog INHERITS TDoc:
		/*****************************************
		 *
		 * �����-�஢����� ����㯠 � ��⥬��
		 * ॣ����樨 ᮡ�⨩/ᮮ�饭��.
		 *
		 *****************************************/
&SCOPED-DEFINE typeEngineList curl,file,syslog

{set-prop.i &aa="engine"      &bb="cEngine"              &cc="CHARACTER" &init="\"http\""}			/* �㤠 �ந������ ������ ᮡ��� */
{set-prop.i &aa="eventid"     &bb="iEvent"                 &cc="INTEGER"}							/* �����䨪��� ᮡ��� */
{set-prop.i &aa="eventnum" &bb="iEventNum"          &cc="INTEGER"}							/* ����� ᮡ��� */
{set-prop.i &aa="target"        &bb="cTarget"               &cc="CHARACTER"}						/* ���� ����砥⥫� ᮡ��� */
{set-prop.i &aa="eventtime"  &bb="dEventTime"       &cc="DATETIME"}						/* ��� �६� ����㯫���� ᮡ��� �� �ணࠬ�� */


{set-prop.i &aa="source-code-page"   &bb="csource-code-page" &cc="CHARACTER" &init="\"ibm866\""}				/* ��室��� ����஢�� */
{set-prop.i &aa="target-code-page"   &bb="ctarget-code-page" &cc="CHARACTER" &init="\"utf-8\""}				/* */
{set-prop.i &aa="isEnable" 	     &bb="lisEnable" 	     &cc="LOGICAL"   &init="TRUE"}

CONSTRUCTOR TEventLog(INPUT cTrSysType AS CHARACTER):
		/*************************************
		 *
		 * ������� ��������� �� ⨯�
		 * ��⥬� ॣ����樨 ᮮ�饭��
		 *
		 *************************************/
 SUPER().
	IF CAN-DO("{&typeEngineList}",cTrSysType) THEN
			DO:

			     engine = cTrSysType.
			     user-id = USERID.
			END.

END CONSTRUCTOR.

CONSTRUCTOR TEventLog(INPUT cTrSysType AS CHARACTER, INPUT cTarget AS CHARACTER):
		/*************************************
		 *
		 * ������� ��������� �� ⨯�
		 * ��⥬� ॣ����樨 ᮮ�饭��
		 *
		 *************************************/
 SUPER().
	IF CAN-DO("{&typeEngineList}",cTrSysType) THEN
			DO:

			     engine = cTrSysType.
			     user-id = USERID.
			     Target = cTarget.
			END.

END CONSTRUCTOR.

CONSTRUCTOR TEventLog(INPUT cTrSysType AS CHARACTER, INPUT cTarget AS CHARACTER,INPUT cSourceEnc AS CHARACTER,INPUT cTargetSource AS CHARACTER):
		/*************************************
		 *
		 * ������� ��������� �� ⨯�
		 * ��⥬� ॣ����樨 ᮮ�饭��
		 *
		 *************************************/
 SUPER().
	IF CAN-DO("{&typeEngineList}",cTrSysType) THEN
			DO:

			     engine = cTrSysType.
			     user-id = USERID.
			     Target = cTarget.
			END.
	source-code-page = cSourceEnc.
	target-code-page   = cTargetSource.
END CONSTRUCTOR.

METHOD PUBLIC VOID fillInfo(INPUT iEventNum AS INTEGER,INPUT cDetails AS CHARACTER,INPUT dDate AS DATE):
		/*************************************************
		 * ��⮤ �������� ᮮ�饭��
		 **************************************************/
		details = cDetails.
		IF dDate EQ ? THEN DocDate = TODAY. ELSE DocDate = dDate.
		eventnum = iEventNum.
END METHOD.

METHOD PUBLIC VOID fillInfo(INPUT iEventNum AS INTEGER,INPUT cDetails AS CHARACTER):

	fillInfo(iEventNum,cDetails,?).

END METHOD.

METHOD PUBLIC VOID send():
		/************************************************
		 * ��⮤ �ந������ ��ࠢ�� ᮡ���
		 ************************************************/
DEF VAR oSysClass AS TSysClass NO-UNDO.

IF isEnable THEN DO:
oSysClass = new TSysClass().

CASE engine:

	WHEN "curl" THEN DO:
						/**************************************
						 * ��ࠢ�塞 �१ curl
						 **************************************/
						 OS-COMMAND SILENT VALUE('curl -d "id=' + STRING(eventnum) + '" -d "date=' + oSysClass:DATETIME2STR(DocDate,"%y-%m-%d") + '" -d "details=' + CODEPAGE-CONVERT(details,target-code-page,source-code-page) + '" ' + target).
					END.
	WHEN "syslog" THEN DO:
						/***************************************
						 * ��ࠢ�塞 �१ Syslog
						 ***************************************/
					      END.
	WHEN "file"	THEN DO:
						/**************************************
						 * ��襬 � 䠩�
						 **************************************/
						OUTPUT TO VALUE(target) APPEND.
							PUT UNFORMATTED oSysClass:DATETIME2STR(DocDate,"%y-%m-%d") "|" STRING(eventnum) "|" CODEPAGE-CONVERT(details,target-code-page,source-code-page) SKIP.
						OUTPUT CLOSE.
					   END.

END CASE.

DELETE OBJECT oSysClass.
END. /* isEnable */
END METHOD.

METHOD PUBLIC VOID send(INPUT iEventNum AS INTEGER,INPUT cDetails AS CHARACTER):
						/**************************************************
						 *
						 * ��⮤ ��ࠢ��� ᮡ�⨥ �� �����
						 *
						 **************************************************/
	fillInfo(iEventNum,cDetails).
	send().
END METHOD.

DESTRUCTOR TEventLog():
		/**************************************
		 *
		 * � ⥡� ��த��, � ⥡� � ���!!!
		 *
		 ***************************************/

END DESTRUCTOR.

END CLASS.