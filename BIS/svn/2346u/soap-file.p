DEF INPUT  PARAMETER num          AS LONGCHAR  NO-UNDO.
DEF INPUT  PARAMETER opdate	  AS LONGCHAR  NO-UNDO.
DEF INPUT  PARAMETER expn	  AS LONGCHAR  NO-UNDO.
DEF INPUT  PARAMETER author       AS LONGCHAR  NO-UNDO.
DEF INPUT  PARAMETER inspector    AS LONGCHAR  NO-UNDO.
DEF INPUT  PARAMETER fileName	  AS CHAR      NO-UNDO.
DEF OUTPUT PARAMETER iRes         AS INTEGER   NO-UNDO.



DEF VAR AAA AS LONGCHAR       NO-UNDO.
DEF VAR BBB AS MEMPTR         NO-UNDO.
DEF VAR hGD AS HANDLE         NO-UNDO.
DEF VAR hWebService AS HANDLE NO-UNDO.
DEF VAR lRes AS LOGICAL       NO-UNDO.
DEF VAR hpt AS HANDLE NO-UNDO.

DEF VAR details      AS LONGCHAR NO-UNDO.


CREATE SERVER hWebService.

hWebService:CONNECT("-WSDL " + OS-GETENV("EARCH") + " ") NO-ERROR.

IF NOT hWebService:CONNECTED() THEN DO:
 MESSAGE "�訡��! ���������� ����������� � ��⥬� �࠭����!" VIEW-AS ALERT-BOX.
 RETURN.
END.


RUN WfControllerPortType SET hpt ON SERVER hWebService.

COPY-LOB FROM FILE fileName TO BBB.
details=BASE64-ENCODE(BBB).

RUN addDoc IN hpt ({cpc num},{cpc opdate},{cpc expn},{cpc author},{cpc inspector},{cpc details},OUTPUT iRes).

hWebService:DISCONNECT().
DELETE OBJECT hWebService.