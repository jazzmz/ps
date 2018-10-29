&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 Character
&ANALYZE-RESUME
/* Connected Databases
          bisquit          PROGRESS
*/
&Scoped-define WINDOW-NAME TERMINAL-SIMULATION



/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-amount NO-UNDO LIKE term-obl
       FIELD viddogob$ AS CHARACTER /* �������� (��� ������� ���ᯥ祭��) */
       FIELD vidob$ AS CHARACTER /* ����� (��� �।��� ���ᯥ祭��) */
       FIELD datapost$ AS DATE /* ��⠏��� (��� ����㯫����) */
       FIELD dopinfo$ AS CHARACTER /* ������ (�������⥫쭠� ���ଠ��) */
       FIELD mestonahowzdenie$ AS CHARACTER /* ���⮭�宦����� (���⮭�宦����� �����⢠) */
       FIELD nomdogob$ AS CHARACTER /* �������� (����� ������� ���ᯥ祭��) */
       FIELD nomerpp$ AS INT64 /* ������� (���浪��� �����) */
       FIELD opisanie$ AS CHARACTER /* ���ᠭ�� (���ᠭ�� �।��� ���ᯥ祭��) */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-amount" "amount" }
       .
DEFINE TEMP-TABLE tt-broker NO-UNDO LIKE cust-role
       FIELD contract AS CHARACTER /* contract (����� �������) */
       FIELD HiddenFields AS CHARACTER /* HiddenFields (���᮪ ��. ����� � �����. �� Ver-format) */
       FIELD is_mandatory AS LOGICAL /* is_mandatory (�᭮���� ஫�) */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
       INDEX cust-role-id cust-role-id
       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-broker" "broker" }
       .
DEFINE TEMP-TABLE tt-comm-rate NO-UNDO LIKE comm-rate
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
       FIELD min_value       AS DECIMAL HELP "�������쭮� ���祭�� �� ���� ��ਮ� ����窨"  /* �������쭮� ���祭�� */
       INDEX local__id IS UNIQUE local__id
       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-comm-rate" "loan-cond:comm-rate" }
       .
DEFINE TEMP-TABLE tt-comm-cond NO-UNDO LIKE comm-cond
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
       INDEX local__id IS UNIQUE local__id
       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-comm-cond" "loan-cond:comm-cond" }
       .
DEFINE TEMP-TABLE tt-commrate NO-UNDO LIKE comm-rate
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-commrate" "commrate" }
       .
DEFINE TEMP-TABLE tt-contragent NO-UNDO LIKE cust-role
       FIELD contract AS CHARACTER /* contract (����� �������) */
       FIELD HiddenFields AS CHARACTER /* HiddenFields (���᮪ ��. ����� � �����. �� Ver-format) */
       FIELD is_mandatory AS LOGICAL /* is_mandatory (�᭮���� ஫�) */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
       INDEX cust-role-id cust-role-id
       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-contragent" "contragent" }
       .
DEFINE TEMP-TABLE tt-dealer NO-UNDO LIKE cust-role
       FIELD contract AS CHARACTER /* contract (����� �������) */
       FIELD HiddenFields AS CHARACTER /* HiddenFields (���᮪ ��. ����� � �����. �� Ver-format) */
       FIELD is_mandatory AS LOGICAL /* is_mandatory (�᭮���� ஫�) */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
       INDEX cust-role-id cust-role-id
       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-dealer" "dealer" }
       .
DEFINE TEMP-TABLE tt-loan NO-UNDO LIKE loan
       FIELD akt_vzv$ AS CHARACTER /* ���_��� (��⨢� ���襭�� � ��⮬ �᪠) */
       FIELD grup_dog$ AS CHARACTER /* ���_��� (��㯯� �������) */
       FIELD datasogl$ AS DATE /* ��⠑��� (��� �����祭�� �।�⭮�� �������) */
       FIELD data_uar$ AS CHARACTER /* ���_��� (����� � ��� ���⢥ত���� ���) */
       FIELD dosroka$ AS CHARACTER /* ������� (����� ᭨���� �।�⢠ �� �ப�) */
       FIELD igndtokwc$ AS LOGICAL /* ����⎪� (�����஢��� ���� ����砭�� �������) */
       FIELD nesno$ AS CHARACTER /* ��᭎ (��᭨����� ������) */
       FIELD okrugsum$ AS LOGICAL /* ���㣑� (���㣫���� �㬬� �������� ���⥦��) */
       FIELD rewzim$ AS CHARACTER /* ����� (���� ������஢ �ਢ��祭��) */
       FIELD sindkred$ AS LOGICAL /* �����। (������஢���� �।��) */
       FIELD BankCust AS CHARACTER /* BankCust (��� ������ �ᯮ����饣� �����) */
       FIELD Bfnc AS CHARACTER /* Bfnc (��� �㭪樨 Bfnc � DBI) */
       FIELD CallAcct AS CHARACTER /* CallAcct (DBI ��� �ॡ������ �� ���।�⨢�) */
       FIELD dateend AS DATE /* dateend (��� ����砭��/������� �� ldmfDD.txt) */
       FIELD DTKind AS CHARACTER /* DTKind (������������� ᤥ��� ��� Decision Table) */
       FIELD DTType AS CHARACTER /* DTType (��� ������� ��� Decision Table) */
       FIELD Exec_D AS LOGICAL /* Exec_D (�� ���뢠�� �� ������ ���-�� ���.) */
       FIELD IntAcct AS CHARACTER /* IntAcct (��業�� DBI ���) */
       FIELD list_type AS CHARACTER /* list_type (���᮪ ⨯�� ��⮢ ��� ���. �������) */
       FIELD main-loan-acct AS CHARACTER /* main-loan-acct (���� ���) */
       FIELD main-loan-cust AS CHARACTER /* main-loan-cust (�᭮���� ஫� ������) */
       FIELD OblAcct AS CHARACTER /* OblAcct (DBI ��� ��易⥫��� �� ���।�⨢�) */
       FIELD op-date AS CHARACTER /* op-date (1111) */
       FIELD PrevLoanID AS CHARACTER /* PrevLoanID (��뫪� �� �஫����஢����� ᤥ���) */
       FIELD ProfitCenter AS CHARACTER /* ProfitCenter (��� ���ࠧ������� �����/ProfitCenter) */
       FIELD rel_type AS CHARACTER /* rel_type (���᮪ ⨯�� ��⮢ ��� �ਢ離�) */
       FIELD ReplDate AS DATE /* ReplDate (��� �⬥�� ᤥ���) */
       FIELD RevRef1 AS CHARACTER /* RevRef1 (��뫪� �� ����� ᤥ���) */
       FIELD RevRef2 AS CHARACTER /* RevRef2 (��뫪� �� �⬥������ ᤥ���) */
       FIELD round AS LOGICAL /* round (���㣫����) */
       FIELD TermKey AS CHARACTER /* TermKey (��� ��筮�� � DBI) */
       FIELD TicketNumber AS CHARACTER /* TicketNumber (����� ⨪�� DBI (DocNum)) */
       FIELD ovrpr$ AS INT64
       FIELD ovrstop$ AS INT64
       FIELD ovrstopr$ AS CHARACTER /* �� ����⮯� */
       FIELD tranwspertip$ AS LOGICAL /* �� �࠭菥���� */
       FIELD prodkod$ AS CHARACTER /* �த��� ���:��� �த�� */
       FIELD svodgravto$ AS LOGICAL /* �� ��������� */
       FIELD svodgrafik$ AS LOGICAL /* �� ������䨪 */
       FIELD svodskonca$ AS LOGICAL /* �� ��������� */
       FIELD svodform$ AS LOGICAL /* �� ������� */
       FIELD svodspostr$ AS LOGICAL /* �� ��������� */
       FIELD UniformBag AS CHARACTER /* �� UniformBag */
       FIELD sum-depos AS DECIMAL /* �� �㬬� �易����� ������ */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
       FIELD rate-list AS CHARACTER
       FIELD stream-show AS LOGICAL
       FIELD AgrCounter  AS CHARACTER     /* ����� ������� �� ���稪� */
       FIELD LimitGrafDate AS DATE
       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-loan" "" }
       .
DEFINE TEMP-TABLE tt-loan-acct NO-UNDO LIKE loan-acct
       FIELD class-code AS CHARACTER /* class-code (����� loan-acct) */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-loan-acct" "loan-acct" }
       .
DEFINE TEMP-TABLE tt-loan-acct-cust NO-UNDO LIKE loan-acct
       FIELD class-code AS CHARACTER /* class-code (����� loan-acct) */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-loan-acct-cust" "loan-acct-cust" }
       .
DEFINE TEMP-TABLE tt-loan-acct-main NO-UNDO LIKE loan-acct
       FIELD class-code AS CHARACTER /* class-code (����� loan-acct) */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-loan-acct-main" "loan-acct-main" }
       .
DEFINE TEMP-TABLE tt-loan-cond NO-UNDO LIKE loan-cond
       FIELD annuitplat$  AS DECIMAL /* ����⏫�� (�㬬� �����⭮�� ���⥦�) */
       FIELD end-date AS DATE /* end-date (��� ����砭��) */
       FIELD EndDateBeforeProl AS DATE /* EndDateBeforeProl (��� ����砭�� ������ �� �஫����樨) */
       FIELD kollw#gtper$ AS INT64 /* �����⏥� (������⢮ �죮��� ��ਮ���) */
       FIELD kollw#gtperprc$ AS INT64 /* �����⏥���� (������⢮ �죮��� ��ਮ��� (��業��)) */
       FIELD cred-offset AS CHARACTER
       FIELD int-offset AS CHARACTER
       FIELD delay-offset AS CHARACTER
       FIELD delay-offset-int AS CHARACTER
       FIELD cred-mode AS CHARACTER /* cred-mode (���ᮡ ������� ����.��ਮ�� (��.����)) */
       FIELD int-mode AS CHARACTER /* int-mode (���ᮡ ������� ����.��ਮ�� (��業��)) */
       FIELD DateDelay AS INT64 /* DateDelay (���� ����砭�� ����.��ਮ�� (��.����)) */
       FIELD DateDelayInt AS INT64 /* DateDelayInt (���� ����砭�� ����.��ਮ�� (��業��)) */
       FIELD cred-work-calend AS LOGICAL /* cred-work-cale (����� ���� �த���.��ਮ�� (��.����)) */
       FIELD cred-curr-next AS LOGICAL /* cred-curr-next (����� ���� ����砭�� ��ਮ��(��.����) */
       FIELD int-work-calend AS LOGICAL /* int-work-calen (����� ���� �த���.��ਮ�� (��業��)) */
       FIELD int-curr-next AS LOGICAL /* int-curr-next (����� ���� ����砭�� ��ਮ�� (���.)) */
       FIELD Prolong AS LOGICAL /* Prolong (�஫����� ������) */
       FIELD interest AS CHAR /* �奬� ��稫���� */
       FIELD shemaplat$ AS LOGICAL /* �奬����� (�奬� ���⥦�) */
       FIELD isklmes$ AS LOGICAL /* �᪫��� (����稥 �᪫�祭�� ����楢) */
       FIELD NDays AS INT64 /* ������⢮ ���� ����⢨� �᫮��� */
       FIELD NMonthes AS INT64 /* ������⢮ ����楢 ����⢨� �᫮��� */
       FIELD NYears AS INT64 /* ������⢮ ��� ����⢨� �᫮��� */
       FIELD Test01 AS CHARACTER /* Test01 (Test01) */
       FIELD kredplat$ AS DECIMAL /* �।���� (�㬬� ��ਮ���.���⥦� �����. ��.�����) */
       FIELD prodtrf$ AS CHARACTER /* ��� ��� �த�� */
       FIELD annuitkorr$ AS INT64       /* �� ����⊮�� */
       FIELD grperiod$ AS LOG /* �� ����ਮ� */
       FIELD grdatas$ AS DATE /* �� ����⠑ */
       FIELD grdatapo$ AS DATE /* �� ����⠏� */
       FIELD PartAmount AS DECIMAL /* �� ���� �।�� ��ࢮ�� ��ਮ�� */
       FIELD FirstPeriod AS INTEGER /* �� �த����⥫쭮��� ��ࢮ�� ��ਮ�� � ������ */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-loan-cond" "loan-cond" }
       .
DEFINE TEMP-TABLE tt-MonthOut NO-UNDO LIKE term-obl
       FIELD viddogob$ AS CHARACTER /* �������� (��� ������� ���ᯥ祭��) */
       FIELD vidob$ AS CHARACTER /* ����� (��� �।��� ���ᯥ祭��) */
       FIELD datapost$ AS DATE /* ��⠏��� (��� ����㯫����) */
       FIELD dopinfo$ AS CHARACTER /* ������ (�������⥫쭠� ���ଠ��) */
       FIELD mestonahowzdenie$ AS CHARACTER /* ���⮭�宦����� (���⮭�宦����� �����⢠) */
       FIELD nomdogob$ AS CHARACTER /* �������� (����� ������� ���ᯥ祭��) */
       FIELD nomerpp$ AS INT64 /* ������� (���浪��� �����) */
       FIELD opisanie$ AS CHARACTER /* ���ᠭ�� (���ᠭ�� �।��� ���ᯥ祭��) */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-MonthOut" "loan-cond:MonthOut" }
       .
DEFINE TEMP-TABLE tt-MonthSpec NO-UNDO LIKE term-obl
       FIELD viddogob$ AS CHARACTER /* �������� (��� ������� ���ᯥ祭��) */
       FIELD vidob$ AS CHARACTER /* ����� (��� �।��� ���ᯥ祭��) */
       FIELD datapost$ AS DATE /* ��⠏��� (��� ����㯫����) */
       FIELD dopinfo$ AS CHARACTER /* ������ (�������⥫쭠� ���ଠ��) */
       FIELD mestonahowzdenie$ AS CHARACTER /* ���⮭�宦����� (���⮭�宦����� �����⢠) */
       FIELD nomdogob$ AS CHARACTER /* �������� (����� ������� ���ᯥ祭��) */
       FIELD nomerpp$ AS INT64 /* ������� (���浪��� �����) */
       FIELD opisanie$ AS CHARACTER /* ���ᠭ�� (���ᠭ�� �।��� ���ᯥ祭��) */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-MonthSpec" "loan-cond:MonthSpec" }
       .
DEFINE TEMP-TABLE tt-percent NO-UNDO LIKE term-obl
       FIELD viddogob$ AS CHARACTER /* �������� (��� ������� ���ᯥ祭��) */
       FIELD vidob$ AS CHARACTER /* ����� (��� �।��� ���ᯥ祭��) */
       FIELD datapost$ AS DATE /* ��⠏��� (��� ����㯫����) */
       FIELD dopinfo$ AS CHARACTER /* ������ (�������⥫쭠� ���ଠ��) */
       FIELD mestonahowzdenie$ AS CHARACTER /* ���⮭�宦����� (���⮭�宦����� �����⢠) */
       FIELD nomdogob$ AS CHARACTER /* �������� (����� ������� ���ᯥ祭��) */
       FIELD nomerpp$ AS INT64 /* ������� (���浪��� �����) */
       FIELD opisanie$ AS CHARACTER /* ���ᠭ�� (���ᠭ�� �।��� ���ᯥ祭��) */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-percent" "percent" }
       .
DEFINE TEMP-TABLE tt-term-obl NO-UNDO LIKE term-obl
       FIELD viddogob$ AS CHARACTER /* �������� (��� ������� ���ᯥ祭��) */
       FIELD vidob$ AS CHARACTER /* ����� (��� �।��� ���ᯥ祭��) */
       FIELD datapost$ AS DATE /* ��⠏��� (��� ����㯫����) */
       FIELD dopinfo$ AS CHARACTER /* ������ (�������⥫쭠� ���ଠ��) */
       FIELD mestonahowzdenie$ AS CHARACTER /* ���⮭�宦����� (���⮭�宦����� �����⢠) */
       FIELD nomdogob$ AS CHARACTER /* �������� (����� ������� ���ᯥ祭��) */
       FIELD nomerpp$ AS INT64 /* ������� (���浪��� �����) */
       FIELD opisanie$ AS CHARACTER /* ���ᠭ�� (���ᠭ�� �।��� ���ᯥ祭��) */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-term-obl" "term-obl" }
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS TERMINAL-SIMULATION
/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: F-MM.P
      Comment: ��࠭��� �ଠ �������/ᤥ��� �ਢ��祭��/ࠧ��饭�� �।��
   Parameters:
         Uses:
      Used by:
     Modified: 16.04.2004 20:02 KSV      (0019947) ���䨪��� ���� � ���㫥�
                                         �������� �����.
     Modified: 19.05.2004 ����          (0027778) ��ࠡ�⪨ ᥪ樨 �᫮���
                                         ��� �����⭮� �奬� ���⥦��

     Modified: 21.02.2005 18:44 KSV      (0041920) ��������� ���������� ����
                                         CONT-CODE.
     Modified: 26.02.2006 ZIAL (0045121) �17: �������� �ଠ� ����. ᮧ�����
                                              १�ࢠ �� ��㤥
     Modified: 21.04.2006 ZIAL (0045121) �17: �������� �ଠ� ����. ᮧ�����
                                              १�ࢠ �� ��㤥
     Modified: 04.10.2007 JADV (0082676) - ��ࠢ���� ����⪠ ᮮ�饭��
     Modified: 18.10.2007 JADV (0077319) - ��������� �஢�ન �� ����室������
                                           ᤢ��� ���
     Modified: 07.11.2007 JADV (0082850) - �஢�ઠ ����� ���� "��" �� 0 ���
                                           ���祭�� ��ਮ�� �, ��, �
     Modified: 23.11.2007 JADV (0084482) - ࠧ��୮��� ����� "����", "���"
                                           㢥��祭� �� 3-� ᨬ�����
     Modified: 23.11.2007 JADV (0084483) - ������� ���冷� ᫥�.� �����
                                           ����� "�����" � "��"
     Modified: 23.11.2007 JADV (0046190)
     Modified: 26.09.2008 19:06 KSV      (0097966) QBIS. ��������
                                         ����/��������� � 㤠����� ���. �⠢��
     Modified: 10.10.2008 12:14 Chumv    <comment>
     Modified: 06.10.2009 16:27 ksv      (0118160) ��ࠢ����� �������樨 10.1B

     Modified: 27.08.2010 16:27 ches     (0054602) ��� ���������
     Modified: 21.09.2010 16:27 ches     (0129479) ���� ����䥫� �� ᮧ����� �������

*/
/*          This file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Commented by KSV: ����� 蠡��� �।�����祭 ��� ᮧ����� �࠭��� ���
** �����⢫��饩 ����������, ��������� � ��ᬮ�� ���ଠ樨 �� ��ꥪ�
** ����奬� �������� ��� �����।�⢥����� ���饭�� � ���� ������.
**
** ���� �� ᮧ����� �࠭��� ���:
**    0. ����ன� PROPATH AppBuilder �� SRC ��⠫�� ��������. �����, �⮡�
**       �㦥��� ��⠫��� PROGRESS ��室����� ��᫥ ��⠫��� SRC/TOOLS.
**       ���������� � ���� ������ ��������.
**    1. �롥�� �㭪� ���� AppBuilder Tools - Procedure Settings. �����
**       ������ ������ Temp-Table Definition, � ���襬�� ������� ������
**       ������ BISQUIT � �롥�� ����� ����奬�, ��ꥪ� ���ண� �㤥�
**       ��ࠡ��뢠���� �ମ�. �� �᭮�� ��࠭���� ����� � ��� ���������
**       ������� �६����� ⠡��� ��� ��� ��࠭���� �����, ⠪ � ���
**       ��� ���ॣ�஢����� �� ��� ����ᮢ.
**    2. �������� ���� �६����� ⠡��� �� �३��. ��� �裡 ������ �
**       ����� �� �६����� ⠡���� � �ଥ ᢮��� ���� 饫���� �� ������
**       Database Field �ࠢ�� ������ ��� � � ���襬�� ���� �롥��
**       �㭪� Bisquit.
**       ��  ����� ᮧ���� ᯥ樠��� ���� ࠧ����⥫�, ��� �⮣� ����室���
**       ᮧ���� FILL-IN c �����䨪��஬ SEPARATOR# (��� # - �� �᫮ ��
**       2, ���� FILL-IN ����� �����䪠�� ��� �����) � ���ਡ�⮬
**       VIES-AS TEXT. � ������� ࠧ����⥫�� �� ����� ���㠫쭮 �뤥����
**       ��㯯� �����.
**    3. ��ꥤ���� ���� � ᯨ᪨ � ����ᨬ��� �� ⮣� � ����� �� ०����
**       ���� ������ ���� ����㯭� ��� ।���஢����. ��� ���������� ����
**       � ᯨ᮪ � ������� ��� ��ਡ�⮢ ������ ������ Advanced � ���⠢��
**       ����� � ����� LIST-1, LIST-2 ��� LIST-3. �����祭�� ᯨ᪮�:
**       -  LIST-1 - ���� ����㯭� ��� ।���஢���� � ०��� ����������
**                   �����
**       -  LIST-2 - ���� ����㯭� ��� ।���஢���� � ०��� ।���஢����
**                   �����
**       -  LIST-3 - ���� ����㯭� ��� ।���஢���� � ०��� ��ᬮ��.
**                   (���筮 �� ����, �⮡ࠦ���� � ������ EDITOR ���
**                   ����饭�� �� ��������� ��ᯮ������ ��ਡ�⮬ READ-ONLY)
**       -  LIST-4 - ���� ��� ������ ��ਡ�� �ଠ� ��।������ � �ଥ.
**                   ��� ��㣨� �� ���������� �� ����奬�.
**    4. ����஫� �� ���祭��� ����� ������ ���� ��।���� �� �ਣ��� LEAVE
**       ����, ����� � ��砥 ��ᮮ⢥��⢨� ���祭�� �ॡ㥬��� ������
**       �������� ���祭�� {&RET-ERROR}.
**       �ࠢ��쭠� ��������� �ਣ���:

   .......

   IF <������> THEN
   DO:
      MESSAGE '......'
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   APPLY "LEAVE" TO FRAME {&MAIN-FRAME}. /* �⠭���⭠� �஢�ઠ */
   IF RETURN-VALUE EQ {&RET-ERROR}
      THEN RETURN NO-APPLY.

**    5. ��� �롮� ���祭�� ���� �� ᯨ᪠ ������ ���� ��।��� �ਣ��� F1 ����
**       (�� ����� � �ਣ��஬ �� ᮡ�⨥ HELP � TTY - �� ࠧ�� ᮡ���)
**    6. �᫨ � �ଥ ��������� ������� �� �⭮��騥�� � ���� �६�����
**       ⠡����, ���ਬ�� ������, �� ����� �.�. ����㯭� � ०����
**       ।���஢���� � ���������� ������� �� � ᯨ᮪ LIST-4.
**    7. ����� ⮭��� ����ன�� ��������� ��� �� ����� 㪠���� � ��楤��
**       LocalEnableDisable, ����� �㤥� ��뢠����, � c��砥 �᫨ ���
**       ��।�����, � ���� EnableDisable.
**    8. �ᯮ���� ��楤��� LocalSetObject, ����� �㤥� ��뢠����,
**       � c��砥 �᫨ ��� ��।�����, ��। ������� ������ � ��.
**    9. ��� ��।�� ᯥ���᪨� ��ࠬ��஢ ��楤�� �࠭��� ���
**       ��ᯮ����� �㭪�ﬨ ������⥪� PP-TPARA.P
**   10. ���ᠭ�� ��६����� ��� �ࠢ����� �࠭��� �ମ� ��室���� � ᥪ樨
**       Definitions ������⥪� bis-tty.pro
**   11. ���ᠭ�� TEMP-TABL ��
*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE MAIN-FRAME fMain
/* ���᪮�����஢��� � ��砥 �맮�� �� NAVIGATE.CQR
{navigate.cqr
   ...
   &UseBisTTY=YES
   &edit=bis-tty.ef
   ...
}
   �᫨ ��।����� &UseBisTTY - � ��뫪� �� ���������� ⠡���� ���孥�� �����
�㤥� �࠭����� � ��६����� IInstance.
   �᫨ ��।����� &InstanceFile - � �㤥� ��।����� � ��������� ����᪠�
TEMP-TABLE tt-instance LIKE {&InstanceFile}

&GLOBAL-DEFINE UseBisTTY
&GLOBAL-DEFINE InstanceFile ���_�������_��������_���_��������_������
*/

&GLOBAL-DEFINE xDEBUG-INSTANCE-GET
&GLOBAL-DEFINE xDEBUG-INSTANCE-SET

/* ����᫮���� ����祭��\�⪫�祭�� �맮�� xattr-ed
(���� �� ��뢠���� �� ����稥 ������������� ��易⥫��� ४����⮢ */
/*
&GLOBAL-DEFINE XATTR-ED-OFF
&GLOBAL-DEFINE XATTR-ED-ON
*/
{globals.i}
{svarloan.def}          /* Shared ��६���� ����� "�।��� � ��������". */
{intrface.get fx}
{intrface.get mm}
{intrface.get i254}
{intrface.get bag}      /* ������⥪� ��� ࠡ�� � ���. */
{intrface.get loan}     /* �����㬥��� ��� ࠡ��� � ⠡��窮� loan. */
{intrface.get loanc}
{intrface.get loanx}
{intrface.get limit}
{intrface.get tmcod}
{intrface.get refer}
{intrface.get ovl}
{deal.def}
{dtterm.i}
{loan.pro}
{mf-loan.i}             /* �㭪樨 addFilToLoan � delFilFromLoan �८�ࠧ������
                        ** ����� loan.doc-ref � loan.cont-code � �������. */
DEFINE VARIABLE mNameCommi    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mListContract AS CHARACTER  NO-UNDO INIT "�।��,�����".

DEFINE VARIABLE mRateList          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mI                 AS INT64    NO-UNDO.
DEFINE VARIABLE mBrowseCommRateOFF AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mChangedField      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mHandCalcAnnuitet  AS LOGICAL    NO-UNDO.  /* �ਧ���, �� �㬬� ���⥦� ������� ������ */

DEFINE VARIABLE mEndDate     AS DATE       NO-UNDO.
DEFINE VARIABLE mAmount      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE mCredPeriod  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mCredDate    AS INT64    NO-UNDO.
DEFINE VARIABLE mIntPeriod   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mIntDate     AS INT64    NO-UNDO.
DEFINE VARIABLE mDelay1      AS INT64    NO-UNDO.
DEFINE VARIABLE mCredOffset  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mCountPer    AS INT64    NO-UNDO.
DEFINE VARIABLE mSurrcr      AS CHAR       NO-UNDO. /* ���ண�� comm-rate, ����室��� �� ᮧ����� ����� �� �� ������� */
DEFINE VARIABLE mSurrcr2     AS CHAR       NO-UNDO. /* ���ண�� comm-rate, ����室��� �� ��ᬮ�� ����� �� F1 � F9 ( �� ������� ) */
DEFINE VARIABLE mOffsetVld   AS CHARACTER  NO-UNDO. /* �ଠ� ����� "��" (�����) */
DEFINE VARIABLE mNDays       AS INT64    NO-UNDO.
DEFINE VARIABLE mNMonth      AS INT64    NO-UNDO.
DEFINE VARIABLE mNYear       AS INT64    NO-UNDO.
DEFINE VARIABLE mSrokChange  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mSumma-sd    AS DECIMAL    NO-UNDO. /* ��� �㬬� �祭�� */
DEFINE VARIABLE mModeBrowse  AS INT64    NO-UNDO. /* ��� �஢�ப ���⥫쭮 �����ᨩ */
DEFINE VARIABLE mDateEnd     AS DATE       NO-UNDO. /* ��� �஢�ப ���� "��" */
DEFINE VARIABLE vEndRasch    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mCounterVal  AS INT64    NO-UNDO. /* ���稪 ���.�� ��⮣����樨 */
DEFINE VARIABLE mUniformBag AS CHARACTER  NO-UNDO. /* �������⥫�� ४����� UniformBag */
DEFINE VARIABLE mHiddenField AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mProdCode    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mSvodROnly   AS LOG        NO-UNDO. /* ����㯭���� �� ���������, ������䨪, ���������, ��������� ��� ।���஢���� */
DEFINE VARIABLE md1          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE md2          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE vCredPlav    AS CHAR       NO-UNDO.
DEFINE VARIABLE vCounter     AS INT64      NO-UNDO. /* ���稪 */
DEFINE VARIABLE vRatePS      AS DEC        NO-UNDO. /* ���祭�� ������饩 �⠢�� */
DEFINE VARIABLE mFindLoanCond AS CHARACTER NO-UNDO. /* ���祭�� �� �।��� */
DEFINE VARIABLE mLstDR        AS CHAR      NO-UNDO. /*ᯨ᮪ ��᫥�㥬�� ��*/
/* ���祭�� ����� �����, �⮡ࠦ����� ����� ���⮩ ��ப� */
DEFINE VARIABLE mOffsetNone AS CHARACTER   NO-UNDO INIT "--".
DEFINE VARIABLE mSummaDog    AS DEC        NO-UNDO. /* �㬬� �� �������� */
DEFINE VARIABLE mdate2       AS DATE       NO-UNDO .
DEFINE VARIABLE mNewEndDate  AS DATE       NO-UNDO.

DEFINE VARIABLE mIsChanGRisk    AS LOGICAL    NO-UNDO INIT NO.
DEFINE NEW SHARED VARIABLE mask AS CHARACTER NO-UNDO INITIAL ?.

&GLOBAL-DEFINE BASE-TABLE tt-loan
   /* ��� loan-trg.pro */
&GLOBAL-DEFINE CorrectAnnuitet YES

DEFINE TEMP-TABLE tmp-loan NO-UNDO LIKE loan.
DEFINE TEMP-TABLE ttTermObl NO-UNDO LIKE term-obl.

DEFINE BUFFER b-comm-rate FOR tt-comm-rate.
DEFINE BUFFER t-comm-rate FOR comm-rate.
DEFINE BUFFER xbcomm-rate FOR comm-rate.
DEFINE BUFFER b-comm-cond FOR tt-comm-cond.
DEFINE BUFFER b-monthout  FOR tt-monthout.
DEFINE BUFFER b-monthspec FOR tt-monthspec.
DEFINE BUFFER xxloan-cond FOR loan-cond.

&GLOBAL-DEFINE InstanceFile loan
&GLOBAL-DEFINE mGlobalErr  yes


DEFINE VARIABLE hDefaultRate AS HANDLE NO-UNDO.
DEF VAR ii AS INT64 NO-UNDO .
DEFINE VARIABLE mTxtPercent AS CHARACTER NO-UNDO INIT "��業��:".
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME br-comm

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-comm-rate tt-comm-cond

/* Definitions for BROWSE br-comm                                       */
&Scoped-define FIELDS-IN-QUERY-br-comm tt-comm-rate.commission /* tt-comm-rate.local__id */ tt-comm-rate.rate-fixed ENTRY(1, GetBufferValue( "commission", "WHERE commission.commission = '" + tt-comm-rate.commission + "'", "name-comm"),CHR(1)) @ mNameCommi tt-comm-rate.rate-comm tt-comm-rate.min_value tt-comm-cond.commission tt-comm-cond.since
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-comm tt-comm-rate.commission ~
tt-comm-rate.rate-fixed ~
tt-comm-cond.FloatType ~
tt-comm-rate.rate-comm ~
tt-comm-rate.min_value
&Scoped-define ENABLED-TABLES-IN-QUERY-br-comm tt-comm-rate tt-comm-cond
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-comm tt-comm-rate
&Scoped-define SELF-NAME br-comm
&Scoped-define QUERY-STRING-br-comm PRESELECT EACH tt-comm-rate WHERE tt-comm-rate.since EQ tt-loan-cond.since SHARE-LOCK, LAST tt-comm-cond OUTER-JOIN WHERE tt-comm-cond.commission EQ tt-comm-rate.commission AND tt-comm-cond.since LE tt-loan-cond.since SHARE-LOCK BY tt-comm-rate.since INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-comm OPEN QUERY {&SELF-NAME} PRESELECT EACH tt-comm-rate WHERE tt-comm-rate.since EQ tt-loan-cond.since SHARE-LOCK, LAST tt-comm-cond OUTER-JOIN WHERE tt-comm-cond.commission EQ tt-comm-rate.commission AND tt-comm-cond.since LE tt-loan-cond.since SHARE-LOCK BY tt-comm-rate.commission INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-comm tt-comm-rate tt-comm-cond
&Scoped-define FIRST-TABLE-IN-QUERY-br-comm tt-comm-rate


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-br-comm}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-loan-cond.NDays tt-loan-cond.NMonthes ~
tt-loan-cond.NYears tt-loan-cond.cred-month tt-loan-cond.cred-offset ~
tt-loan-cond.cred-mode tt-loan-cond.cred-work-calend ~
tt-loan-cond.cred-curr-next tt-loan-cond.DateDelay ~
tt-loan-cond.delay-offset tt-loan-cond.kredplat$ tt-loan-cond.int-month ~
tt-loan-cond.int-offset tt-loan-cond.kollw#gtperprc$ ~
tt-loan-cond.int-work-calend tt-loan-cond.int-curr-next ~
tt-loan-cond.DateDelayInt tt-loan-cond.delay-offset-int ~
tt-loan-cond.isklmes$
&Scoped-define ENABLED-TABLES tt-loan-cond
&Scoped-define FIRST-ENABLED-TABLE tt-loan-cond
&Scoped-Define ENABLED-OBJECTS cred-offset_ delay-offset_ int-offset_ ~
delay-offset-int_ mBag mSvod mLimit mLimitRest
&Scoped-Define DISPLAYED-FIELDS tt-loan.branch-id tt-loan.datasogl$ ~
tt-loan.cust-cat tt-loan.cust-id tt-loan.doc-num tt-loan.doc-ref ~
tt-loan.cont-type tt-loan.DTType tt-loan.DTKind tt-amount.amt-rub ~
tt-loan.currency tt-loan.open-date tt-loan-cond.NDays tt-loan-cond.NMonthes ~
tt-loan-cond.NYears tt-loan.end-date tt-percent.amt-rub tt-loan.ovrstop$ tt-loan.ovrstopr$ ~
tt-loan.ovrpr$ tt-loan.tranwspertip$ tt-loan-acct-main.acct tt-loan-acct-cust.acct ~
tt-loan-cond.cred-period tt-loan-cond.cred-date tt-loan-cond.cred-month ~
tt-loan-cond.cred-offset tt-loan-cond.kollw#gtper$ tt-loan-cond.cred-mode ~
tt-loan-cond.cred-work-calend tt-loan-cond.cred-curr-next ~
tt-loan-cond.delay1 tt-loan-cond.DateDelay tt-loan-cond.delay-offset ~
tt-loan-cond.kredplat$ tt-loan-cond.annuitplat$ tt-loan-cond.int-period ~
tt-loan-cond.int-date tt-loan-cond.int-month tt-loan-cond.int-offset ~
tt-loan-cond.kollw#gtperprc$ tt-loan-cond.int-mode ~
tt-loan-cond.int-work-calend tt-loan-cond.int-curr-next tt-loan-cond.delay ~
tt-loan-cond.DateDelayInt tt-loan-cond.delay-offset-int ~
tt-loan-cond.isklmes$ tt-loan.rewzim$ tt-loan-cond.disch-type ~
tt-loan.user-id tt-loan.loan-status tt-loan.close-date tt-loan.trade-sys ~
tt-dealer.cust-cat tt-dealer.cust-id tt-broker.cust-cat tt-broker.cust-id ~
tt-loan.comment
&Scoped-define DISPLAYED-TABLES tt-loan tt-amount tt-loan-cond tt-percent ~
tt-loan-acct-main tt-loan-acct-cust tt-dealer tt-broker
&Scoped-define FIRST-DISPLAYED-TABLE tt-loan
&Scoped-define SECOND-DISPLAYED-TABLE tt-amount
&Scoped-define THIRD-DISPLAYED-TABLE tt-loan-cond
&Scoped-define FOURTH-DISPLAYED-TABLE tt-percent
&Scoped-define FIFTH-DISPLAYED-TABLE tt-loan-acct-main
&Scoped-define SIXTH-DISPLAYED-TABLE tt-loan-acct-cust
&Scoped-define SEVENTH-DISPLAYED-TABLE tt-dealer
&Scoped-define EIGHTH-DISPLAYED-TABLE tt-broker
&Scoped-Define DISPLAYED-OBJECTS mBranchName CustName1 mNameCredPeriod ~
cred-offset_ delay-offset_ mNameIntPeriod int-offset_ delay-offset-int_ ~
mBag mSvod mLimit  mNameDischType mLimitRest mGrRiska mRisk CustName2 CustName3

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 tt-loan.branch-id tt-loan.datasogl$ tt-loan.cust-cat ~
tt-loan.cust-id tt-loan.doc-num tt-loan.doc-ref tt-loan.cont-type ~
tt-loan.DTType tt-loan.DTKind tt-amount.amt-rub tt-loan.currency ~
tt-loan.open-date tt-loan.sum-depos tt-loan-cond.PartAmount tt-loan-cond.FirstPeriod tt-loan-cond.NDays tt-loan-cond.NMonthes ~
tt-loan-cond.NYears tt-loan.end-date tt-percent.amt-rub tt-loan.ovrstop$ tt-loan.ovrstopr$ ~
tt-loan.ovrpr$ tt-loan.tranwspertip$ tt-loan-acct-main.acct tt-loan-acct-cust.acct ~
tt-loan-cond.cred-period tt-loan-cond.cred-date tt-loan-cond.cred-month ~
cred-offset_ tt-loan-cond.kollw#gtper$ tt-loan-cond.cred-mode ~
tt-loan-cond.cred-work-calend tt-loan-cond.cred-curr-next ~
tt-loan-cond.delay1 tt-loan-cond.DateDelay delay-offset_ ~
tt-loan-cond.kredplat$ tt-loan-cond.annuitplat$ tt-loan-cond.int-period ~
tt-loan-cond.int-date tt-loan-cond.int-month int-offset_ ~
tt-loan-cond.kollw#gtperprc$ tt-loan-cond.int-mode ~
tt-loan-cond.int-work-calend tt-loan-cond.int-curr-next tt-loan-cond.delay ~
tt-loan-cond.DateDelayInt delay-offset-int_ tt-loan-cond.isklmes$ ~
tt-loan.rewzim$ mLimit tt-loan-cond.disch-type mGrRiska mRisk ~
tt-loan.user-id tt-loan.loan-status tt-loan.trade-sys tt-dealer.cust-cat ~
tt-dealer.cust-id tt-broker.cust-cat tt-broker.cust-id tt-loan.comment mSvod ~
tt-loan-cond.annuitkorr$ mBag tt-loan-cond.grperiod$
&Scoped-define List-2 tt-loan.branch-id tt-loan.datasogl$ tt-loan.doc-num ~
tt-loan.cont-type tt-loan.DTType tt-loan.DTKind tt-loan-cond.NDays ~
tt-loan-cond.NMonthes tt-loan-cond.NYears tt-loan.end-date tt-loan.ovrstop$ tt-loan.ovrstopr$ ~
tt-loan.ovrpr$ tt-loan.tranwspertip$ tt-loan.rewzim$ tt-loan.user-id tt-loan.loan-status ~
tt-loan.close-date tt-loan.trade-sys tt-dealer.cust-cat tt-dealer.cust-id ~
tt-broker.cust-cat tt-broker.cust-id tt-loan.comment mSvod ~
tt-loan-cond.grperiod$
&Scoped-define List-3 tt-loan.branch-id tt-loan.datasogl$ tt-loan.cust-id ~
tt-loan.doc-num tt-loan.doc-ref tt-loan.cont-type tt-loan.DTType ~
tt-loan.DTKind tt-amount.amt-rub tt-loan.currency tt-loan.open-date ~
tt-loan-cond.NDays tt-loan-cond.NMonthes tt-loan-cond.NYears ~
tt-loan.end-date tt-percent.amt-rub tt-loan.ovrstop$ tt-loan.ovrstopr$ tt-loan.ovrpr$ tt-loan.tranwspertip$ ~
tt-loan-acct-main.acct tt-loan-acct-cust.acct tt-loan-cond.cred-period ~
tt-loan-cond.cred-date tt-loan-cond.cred-month cred-offset_ ~
tt-loan-cond.kollw#gtper$ tt-loan-cond.cred-mode ~
tt-loan-cond.cred-work-calend tt-loan-cond.cred-curr-next ~
tt-loan-cond.delay1 tt-loan-cond.DateDelay delay-offset_ ~
tt-loan-cond.kredplat$ tt-loan-cond.annuitplat$ tt-loan-cond.int-period ~
tt-loan-cond.int-date tt-loan-cond.int-month int-offset_ ~
tt-loan-cond.kollw#gtperprc$ tt-loan-cond.int-mode ~
tt-loan-cond.int-work-calend tt-loan-cond.int-curr-next tt-loan-cond.delay ~
tt-loan-cond.DateDelayInt delay-offset-int_ tt-loan-cond.isklmes$ mBag mSvod ~
tt-loan.rewzim$ tt-loan-cond.disch-type mGrRiska mRisk tt-loan.user-id ~
tt-loan.loan-status tt-loan.close-date tt-loan.trade-sys tt-dealer.cust-id ~
tt-broker.cust-id tt-loan.comment mSvod tt-loan.prodkod$ ~
tt-loan-cond.grperiod$
&Scoped-define List-4 tt-amount.amt-rub tt-percent.amt-rub ~
tt-loan-cond.cred-period tt-loan-cond.kollw#gtper$ tt-loan-cond.cred-mode ~
tt-loan-cond.cred-work-calend tt-loan-cond.cred-curr-next ~
tt-loan-cond.DateDelay tt-loan-cond.kredplat$ tt-loan-cond.kollw#gtperprc$ ~
tt-loan-cond.int-mode tt-loan-cond.int-work-calend ~
tt-loan-cond.int-curr-next tt-loan-cond.DateDelayInt tt-loan-cond.isklmes$ ~
mLimit  mLimitRest tt-loan-cond.annuitkorr$
&Scoped-define List-5 mBranchName CustName1 mNameCredPeriod mNameIntPeriod ~
mNameDischType CustName2 CustName3

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CheckCliAcct TERMINAL-SIMULATION
FUNCTION CheckCliAcct RETURNS LOGICAL
  ( INPUT iAcctType AS CHAR,
    INPUT iAcct AS CHAR,
    INPUT iCurr AS CHAR,
    INPUT iCat AS CHAR,
    INPUT iId AS INT64 )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetQntPer TERMINAL-SIMULATION
FUNCTION GetQntPer RETURNS INT64 (
   INPUT iBegDate  AS DATE, /* ��� ������ ������� */
   INPUT iEndDate  AS DATE, /* ��� ������� ������� */
   INPUT iPayDay   AS INT64,  /* �᫮, ���. �ந����. ������ (⮫쪮 � � �) */
   INPUT iGlInt    AS CHAR, /* ���ࢠ� �/� ������묨 �����ﬨ */
   INPUT iCondBegD AS DATE  /* ��� ��砫� �᫮���, �ᯮ������ �� ���� ���� �� � ��� ��
                             ** �᫨ ? � ��ࠡ��뢠�� ���.�஢�ઠ �� �㤥� */
) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cred-offset_ AS CHARACTER FORMAT "XX":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
     &ELSE SIZE 2 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE CustName1 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 41 BY 1
     &ELSE SIZE 41 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE CustName2 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 43 BY 1
     &ELSE SIZE 43 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE CustName3 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 43 BY 1
     &ELSE SIZE 43 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE delay-offset-int_ AS CHARACTER FORMAT "XX":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
     &ELSE SIZE 2 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE delay-offset_ AS CHARACTER FORMAT "XX":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
     &ELSE SIZE 2 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE int-offset_ AS CHARACTER FORMAT "XX":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
     &ELSE SIZE 2 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mBag AS CHARACTER FORMAT "X(256)":U
     LABEL "����䥫�"
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
     &ELSE SIZE 11 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mBranchName AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 30 BY 1
     &ELSE SIZE 30 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mGrRiska AS INT64 FORMAT "9" INITIAL 0
     LABEL "��"
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 1 BY 1
     &ELSE SIZE 1 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mLimit AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0
     LABEL "�����"
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
     &ELSE SIZE 13 BY 1 &ENDIF NO-UNDO.


DEFINE VARIABLE mLimitRest AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0
     LABEL "���.���."
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
     &ELSE SIZE 13 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mNameCredPeriod AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mNameDischType AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 32 BY 1
     &ELSE SIZE 32 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mNameIntPeriod AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mRisk AS DECIMAL FORMAT ">>9.99999" INITIAL 0
     LABEL "���"
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
     &ELSE SIZE 9 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE separator AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 42 BY 1
     &ELSE SIZE 42 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE separator-2 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 78 BY 1
     &ELSE SIZE 78 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE separator-3 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE separator-4 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 70 BY 1
     &ELSE SIZE 70 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE Separator-5 AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
     &ELSE SIZE 5 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE mSvod AS LOGICAL
     LABEL "���� "
     VIEW-AS TOGGLE-BOX
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1 &ENDIF NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-comm FOR
      tt-comm-rate, tt-comm-cond SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-comm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-comm TERMINAL-SIMULATION _FREEFORM
  QUERY br-comm NO-LOCK DISPLAY
      tt-comm-rate.commission FORMAT "x(10)":U
      /*
      tt-comm-rate.local__id FORMAT 9
      */
      tt-comm-rate.rate-fixed FORMAT "=/%":U
      ENTRY(1,
            GetBufferValue(
               "commission",
               "WHERE commission.commission = '" + tt-comm-rate.commission + "'",
               "name-comm"),CHR(1))
         @ mNameCommi FORMAT "x(25)":U
      tt-comm-cond.FloatType FORMAT "��/���":U
      tt-comm-rate.rate-comm FORMAT ">>>>>>>>>>>9.99999":U WIDTH 18
      tt-comm-rate.min_value FORMAT "->>>>>>>>9.99":U WIDTH 13
  ENABLE
      tt-comm-rate.commission
      tt-comm-rate.rate-fixed
      tt-comm-cond.FloatType
      tt-comm-rate.rate-comm
      tt-comm-rate.min_value
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-BOX NO-LABELS NO-ROW-MARKERS SIZE 78 BY 2 ROW-HEIGHT-CHARS 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     Separator-5
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 78 RIGHT-ALIGNED
          &ELSE AT ROW 4 COL 78 RIGHT-ALIGNED &ENDIF NO-LABEL
     tt-loan.branch-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 16 COLON-ALIGNED
          &ELSE AT ROW 1 COL 16 COLON-ALIGNED &ENDIF
          LABEL "���ࠧ�������"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     mBranchName
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 25 COLON-ALIGNED
          &ELSE AT ROW 1 COL 25 COLON-ALIGNED &ENDIF NO-LABEL
     tt-loan.datasogl$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 66 COLON-ALIGNED
          &ELSE AT ROW 1 COL 66 COLON-ALIGNED &ENDIF
          LABEL "    ����"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-loan.cust-cat
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 16 COLON-ALIGNED
          &ELSE AT ROW 2 COL 16 COLON-ALIGNED &ENDIF
          LABEL "     ����ࠣ���"
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
          &ELSE SIZE 5 BY 1 &ENDIF
     tt-loan.cust-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 26 COLON-ALIGNED
          &ELSE AT ROW 2 COL 26 COLON-ALIGNED &ENDIF
          LABEL "���"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     CustName1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 35 COLON-ALIGNED
          &ELSE AT ROW 2 COL 35 COLON-ALIGNED &ENDIF NO-LABEL
     tt-loan.doc-num
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 16 COLON-ALIGNED
          &ELSE AT ROW 3 COL 16 COLON-ALIGNED &ENDIF
          LABEL "   ����� ᤥ���" FORMAT "X(1022)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
          &ELSE SIZE 22 BY 1 &ENDIF
     tt-loan.doc-ref
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 16 COLON-ALIGNED
          &ELSE AT ROW 2.99 COL 16 COLON-ALIGNED &ENDIF
          LABEL "����� �������" FORMAT "x(22)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 23 BY 1
          &ELSE SIZE 23 BY 1 &ENDIF
     tt-loan.cont-type
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 44 COLON-ALIGNED
          &ELSE AT ROW 3 COL 44 COLON-ALIGNED &ENDIF
          LABEL "���"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
          &ELSE SIZE 9 BY 1 &ENDIF
     tt-loan.DTType
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 62 COLON-ALIGNED
          &ELSE AT ROW 3 COL 62 COLON-ALIGNED &ENDIF
          LABEL "  ������" FORMAT "x(256)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
          &ELSE SIZE 13 BY 1 &ENDIF
     tt-loan.DTKind
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 62 COLON-ALIGNED
          &ELSE AT ROW 3 COL 62 COLON-ALIGNED &ENDIF HELP
          "������������� ᤥ���"
          LABEL "�த��" FORMAT "x(12)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
          &ELSE SIZE 13 BY 1 &ENDIF
     tt-loan.prodkod$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 62 COLON-ALIGNED
          &ELSE AT ROW 3 COL 62 COLON-ALIGNED &ENDIF HELP
          "��� �த��"
          LABEL "�த." FORMAT "x(12)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
          &ELSE SIZE 13 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-amount.amt-rub
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 16 COLON-ALIGNED
          &ELSE AT ROW 5 COL 16 COLON-ALIGNED &ENDIF
          LABEL "         �㬬�"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-loan.currency
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 44 COLON-ALIGNED
          &ELSE AT ROW 5 COL 44 COLON-ALIGNED &ENDIF
          LABEL "���" FORMAT "x(3)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan.open-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 51 COLON-ALIGNED
          &ELSE AT ROW 5 COL 51 COLON-ALIGNED &ENDIF
          LABEL "�"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-loan-cond.NDays
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 48 COLON-ALIGNED
          &ELSE AT ROW 4 COL 48 COLON-ALIGNED &ENDIF
          LABEL "����" FORMAT ">>>>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
          &ELSE SIZE 5 BY 1 &ENDIF
     tt-loan-cond.NMonthes
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 59 COLON-ALIGNED
          &ELSE AT ROW 4 COL 59 COLON-ALIGNED &ENDIF
          LABEL "���" FORMAT ">>>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 4 BY 1
          &ELSE SIZE 4 BY 1 &ENDIF
     tt-loan-cond.NYears
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 69 COLON-ALIGNED
          &ELSE AT ROW 4 COL 69 COLON-ALIGNED &ENDIF
          LABEL "���" FORMAT ">>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan.end-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 66 COLON-ALIGNED
          &ELSE AT ROW 5 COL 66 COLON-ALIGNED &ENDIF
          LABEL "��"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-loan.sum-depos
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 16 COLON-ALIGNED
          &ELSE AT ROW 6 COL 16 COLON-ALIGNED &ENDIF
          LABEL " �㬬� ������"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-loan-cond.PartAmount 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 44 COLON-ALIGNED
          &ELSE AT ROW 6 COL 44 COLON-ALIGNED &ENDIF
          LABEL " ����(%)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.FirstPeriod 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 66 COLON-ALIGNED
          &ELSE AT ROW 6 COL 66 COLON-ALIGNED &ENDIF
          LABEL " ��ਮ� �."
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 4 BY 1
          &ELSE SIZE 4 BY 1 &ENDIF
     tt-percent.amt-rub
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 16 COLON-ALIGNED
          &ELSE AT ROW 6 COL 16 COLON-ALIGNED &ENDIF
          LABEL "      ��業��"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-loan.ovrstop$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 30 COLON-ALIGNED
          &ELSE AT ROW 6 COL 30 COLON-ALIGNED &ENDIF HELP
          "������⢮ ���� �� ����砭�� �ப� �।�⮢����, �� ���஥ ��"
          LABEL "�४���� �뤠�� �࠭� ��" FORMAT ">>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan.ovrstopr$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 34 COLON-ALIGNED
          &ELSE AT ROW 6 COL 34 COLON-ALIGNED &ENDIF 
&IF DEFINED(MANUAL-REMOTE) &THEN
          VIEW-AS COMBO-BOX INNER-LINES 3 DROP-DOWN-LIST  
&ELSE
          HELP "�����୮��� �� ����砭�� �ப� �।�⮢����, �� ���஥ ��"
          NO-LABEL   FORMAT "�/�"  
          VIEW-AS FILL-IN 
&ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan.ovrpr$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 50 COLON-ALIGNED
          &ELSE AT ROW 6 COL 50 COLON-ALIGNED &ENDIF HELP
          "��ਮ� ������⭮�� �।�⮢����"
          LABEL "����.�࠭�" FORMAT ">>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan.tranwspertip$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 70 COLON-ALIGNED
          &ELSE AT ROW 6 COL 70 COLON-ALIGNED &ENDIF HELP
          "����襭� ������� �࠭� � ���ᥪ��騬�� ��ਮ���"
          LABEL "���ᥪ.�࠭� " FORMAT "��/���"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-loan-acct-main.acct
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 16 COLON-ALIGNED
          &ELSE AT ROW 7 COL 16 COLON-ALIGNED &ENDIF
          LABEL "��楢�� ���" FORMAT "x(20)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-loan-acct-cust.acct
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 56 COLON-ALIGNED
          &ELSE AT ROW 7 COL 56 COLON-ALIGNED &ENDIF
          LABEL "������᪨� ���" FORMAT "x(20)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     separator
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 1
          &ELSE AT ROW 4 COL 1 &ENDIF NO-LABEL
     separator-2
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 8 COL 1
          &ELSE AT ROW 8 COL 1 &ENDIF NO-LABEL
     br-comm
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 1
          &ELSE AT ROW 9 COL 1 &ENDIF
     separator-3
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 1
          &ELSE AT ROW 11 COL 1 &ENDIF NO-LABEL
     mSvod
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 1
          &ELSE AT ROW 11 COL 1 &ENDIF HELP
          "������ F1 ��� ।���஢����"
     separator-4
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 9
          &ELSE AT ROW 11 COL 9 &ENDIF NO-LABEL
     tt-loan-cond.cred-period
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 9 COLON-ALIGNED
          &ELSE AT ROW 14 COL 9 COLON-ALIGNED &ENDIF
          LABEL "��.����"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     mNameCredPeriod
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 12 COLON-ALIGNED
          &ELSE AT ROW 14 COL 12 COLON-ALIGNED &ENDIF NO-LABEL
     tt-loan-cond.cred-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 21 COLON-ALIGNED
          &ELSE AT ROW 14 COL 21 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     tt-loan-cond.cred-month
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 24 COLON-ALIGNED
          &ELSE AT ROW 14 COL 24 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     tt-loan-cond.cred-offset
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 27 COLON-ALIGNED
          &ELSE AT ROW 14 COL 27 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Item 1"
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     cred-offset_
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 27 COLON-ALIGNED
          &ELSE AT ROW 14 COL 27 COLON-ALIGNED &ENDIF HELP
          "����� ᬥ饭�� ���� ����襭�� (�᭮���� ����)" NO-LABEL
     tt-loan-cond.kollw#gtper$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 30 COLON-ALIGNED
          &ELSE AT ROW 14 COL 30 COLON-ALIGNED &ENDIF HELP
          "" NO-LABEL FORMAT ">>9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-loan-cond.cred-mode
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 34 COLON-ALIGNED
          &ELSE AT ROW 14 COL 34 COLON-ALIGNED &ENDIF HELP
          "���ᮡ ������� ���⥦���� ��ਮ�� (�᭮���� ����)" NO-LABEL FORMAT "x(12)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
     tt-loan-cond.cred-work-calend
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 49 COLON-ALIGNED
          &ELSE AT ROW 14 COL 49 COLON-ALIGNED &ENDIF HELP
          "����� ���� �த����⥫쭮�� ��ਮ�� (�᭮���� ����)" NO-LABEL FORMAT "������/�����"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
     tt-loan-cond.cred-curr-next
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 49 COLON-ALIGNED
          &ELSE AT ROW 14 COL 49 COLON-ALIGNED &ENDIF HELP
          "����� ���� ����砭�� ��ਮ�� (�᭮���� ����)." NO-LABEL FORMAT "�����/����"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
     tt-loan-cond.delay1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 60 RIGHT-ALIGNED
          &ELSE AT ROW 14 COL 60 RIGHT-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.DateDelay
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 56 COLON-ALIGNED
          &ELSE AT ROW 14 COL 56 COLON-ALIGNED &ENDIF HELP
          "��� ����砭�� (���� �����) ����砭�� ���⥦���� ��ਮ�� �� ��" NO-LABEL FORMAT ">9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.delay-offset
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 60 COLON-ALIGNED
          &ELSE AT ROW 14 COL 60 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Item 1"
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     delay-offset_
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 60 COLON-ALIGNED
          &ELSE AT ROW 14 COL 60 COLON-ALIGNED &ENDIF HELP
          "����� ᬥ饭�� ���� ����砭�� ���⥦���� ��ਮ�� (�᭮���� ����)" NO-LABEL
     tt-loan-cond.kredplat$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 63 COLON-ALIGNED
          &ELSE AT ROW 14 COL 63 COLON-ALIGNED &ENDIF NO-LABEL FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
     tt-loan-cond.annuitplat$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 63 COLON-ALIGNED
          &ELSE AT ROW 14 COL 63 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     mTxtPercent
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 1
          &ELSE AT ROW 14.99 COL 1 &ENDIF
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
          NO-LABEL FORMAT "x(9)"
     tt-loan-cond.int-period
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 9 COLON-ALIGNED
          &ELSE AT ROW 14.99 COL 9 COLON-ALIGNED &ENDIF
          LABEL "��業��"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     mNameIntPeriod
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 12 COLON-ALIGNED
          &ELSE AT ROW 15 COL 12 COLON-ALIGNED &ENDIF NO-LABEL
     tt-loan-cond.int-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 21 COLON-ALIGNED
          &ELSE AT ROW 15 COL 21 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     tt-loan-cond.int-month
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 24 COLON-ALIGNED
          &ELSE AT ROW 15 COL 24 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     tt-loan-cond.int-offset
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 27 COLON-ALIGNED
          &ELSE AT ROW 15 COL 27 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Item 1"
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     int-offset_
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 27 COLON-ALIGNED
          &ELSE AT ROW 15 COL 27 COLON-ALIGNED &ENDIF HELP
          "����� ᬥ饭�� ���� ����襭�� (��業��)" NO-LABEL
     tt-loan-cond.kollw#gtperprc$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 30 COLON-ALIGNED
          &ELSE AT ROW 15 COL 30 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.int-mode
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 34 COLON-ALIGNED
          &ELSE AT ROW 15 COL 34 COLON-ALIGNED &ENDIF HELP
          "���ᮡ ������� ���⥦���� ��ਮ�� (��業��)" NO-LABEL FORMAT "x(12)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
     tt-loan-cond.int-work-calend
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 49 COLON-ALIGNED
          &ELSE AT ROW 15 COL 49 COLON-ALIGNED &ENDIF HELP
          "����� ���� �த����⥫쭮�� ��ਮ�� (��業��)" NO-LABEL FORMAT "������/�����"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
     tt-loan-cond.int-curr-next
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 49 COLON-ALIGNED
          &ELSE AT ROW 15 COL 49 COLON-ALIGNED &ENDIF HELP
          "����� ���� ����砭�� ��ਮ�� (���.)" NO-LABEL FORMAT "�����/����"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-loan-cond.delay
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 56 COLON-ALIGNED
          &ELSE AT ROW 15 COL 56 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.DateDelayInt
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 56 COLON-ALIGNED
          &ELSE AT ROW 15 COL 56 COLON-ALIGNED &ENDIF HELP
          "��� ����砭�� (���� �����) ���⥦���� ��ਮ�� �� ��業⠬" NO-LABEL FORMAT ">9"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     tt-loan-cond.delay-offset-int
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 60 COLON-ALIGNED
          &ELSE AT ROW 15 COL 60 COLON-ALIGNED &ENDIF NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Item 1"
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     delay-offset-int_
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 60 COLON-ALIGNED
          &ELSE AT ROW 15 COL 60 COLON-ALIGNED &ENDIF HELP
          "����� ᬥ饭�� ���� ����砭�� ���⥦���� ��ਮ�� (��業��)" NO-LABEL
     tt-loan-cond.annuitkorr$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 75 COLON-ALIGNED
          &ELSE AT ROW 15 COL 75 COLON-ALIGNED &ENDIF
          LABEL "����." FORMAT "-9"
          HELP "���. �᫠ ��ਮ�. ������, ? - �� �� ����┮�"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
     tt-loan-cond.grperiod$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 63 COLON-ALIGNED
          &ELSE AT ROW 15 COL 63 COLON-ALIGNED &ENDIF HELP
          "��䨪 �� - ��������� � ��ਮ���᪨� ���㫥���� (F1/�஡�� - ��ਮ�� ����஥���)"
          LABEL " ��. ��"
          VIEW-AS TOGGLE-BOX      
     tt-loan-cond.isklmes$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 1
          &ELSE AT ROW 16 COL 1 &ENDIF HELP
          "������ F1 ��� ।���஢���� �᫮���"
          LABEL "�᪫. ���."
          VIEW-AS TOGGLE-BOX
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
          &ELSE SIZE 13 BY 1 &ENDIF
     mBag
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 23 COLON-ALIGNED
          &ELSE AT ROW 16 COL 23 COLON-ALIGNED &ENDIF
     tt-loan.rewzim$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 42 COLON-ALIGNED
          &ELSE AT ROW 16 COL 42 COLON-ALIGNED &ENDIF HELP
          "���� ������஢ �ਢ��祭��"
          LABEL "�����" FORMAT "x(256)"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
          &ELSE SIZE 11 BY 1 &ENDIF
     mLimit
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 64 COLON-ALIGNED
          &ELSE AT ROW 16 COL 64 COLON-ALIGNED &ENDIF HELP
          "����� �뤠� �� ���� ���ﭨ�"
     tt-loan-cond.disch-type
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 14 COLON-ALIGNED
          &ELSE AT ROW 17 COL 14 COLON-ALIGNED &ENDIF
          LABEL "��ଠ ����"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
     mNameDischType
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 18 COLON-ALIGNED
          &ELSE AT ROW 17 COL 18 COLON-ALIGNED &ENDIF NO-LABEL DISABLE-AUTO-ZAP
     mLimitRest
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 64 COLON-ALIGNED
          &ELSE AT ROW 17 COL 64 COLON-ALIGNED &ENDIF HELP
          "��⠢訩�� ����� �뤠� �� ���� ���ﭨ�"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     mGrRiska
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 4 COLON-ALIGNED
          &ELSE AT ROW 18 COL 4 COLON-ALIGNED &ENDIF HELP
          "��⥣��� ����⢠"
     mRisk
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 12 COLON-ALIGNED
          &ELSE AT ROW 18 COL 12 COLON-ALIGNED &ENDIF HELP
          "��� ������ ����樨, ��������� ���짮��⥫��"
     tt-loan.user-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 33 COLON-ALIGNED
          &ELSE AT ROW 18 COL 33 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     tt-loan.loan-status
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 50 COLON-ALIGNED
          &ELSE AT ROW 18 COL 50 COLON-ALIGNED &ENDIF
          LABEL "�����"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
     tt-loan.close-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 66 COLON-ALIGNED
          &ELSE AT ROW 18 COL 66 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-loan.trade-sys
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 14 COLON-ALIGNED
          &ELSE AT ROW 19 COL 14 COLON-ALIGNED &ENDIF
          LABEL "���.��⥬�"
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
     tt-dealer.cust-cat
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 12 COLON-ALIGNED
          &ELSE AT ROW 18 COL 12 COLON-ALIGNED &ENDIF
          LABEL "    �����" FORMAT "x(5)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
          &ELSE SIZE 5 BY 1 &ENDIF
     tt-dealer.cust-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 24 COLON-ALIGNED
          &ELSE AT ROW 19 COL 24 COLON-ALIGNED &ENDIF
          LABEL "���"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
     CustName2
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 33 COLON-ALIGNED
          &ELSE AT ROW 19 COL 33 COLON-ALIGNED &ENDIF NO-LABEL
     tt-broker.cust-cat
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 13 COLON-ALIGNED
          &ELSE AT ROW 19 COL 13 COLON-ALIGNED &ENDIF
          LABEL "    �ப��" FORMAT "x(5)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
          &ELSE SIZE 5 BY 1 &ENDIF
     tt-broker.cust-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 24 COLON-ALIGNED
          &ELSE AT ROW 19 COL 24 COLON-ALIGNED &ENDIF
          LABEL "���"
          VIEW-AS FILL-IN
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
          &ELSE SIZE 8 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     CustName3
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 33 COLON-ALIGNED
          &ELSE AT ROW 19 COL 33 COLON-ALIGNED &ENDIF NO-LABEL
     tt-loan.comment
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 1
          &ELSE AT ROW 19 COL 1 &ENDIF HELP
          "������ �������਩." NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP LARGE NO-BOX
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 78 BY 1
          &ELSE SIZE 78 BY 1 &ENDIF
     "����襭��" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
          &ELSE SIZE 9 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 1
          &ELSE AT ROW 12 COL 1 &ENDIF
     "��" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 58
          &ELSE AT ROW 12 COL 58 &ENDIF
     "�㬬� ���⥦�" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 65
          &ELSE AT ROW 12 COL 65 &ENDIF
     "--" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 26
          &ELSE AT ROW 13 COL 26 &ENDIF
     "---------" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
          &ELSE SIZE 9 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 1
          &ELSE AT ROW 13 COL 1 &ENDIF
     "--" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 23
          &ELSE AT ROW 13 COL 23 &ENDIF
     "--------------" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 36
          &ELSE AT ROW 13 COL 36 &ENDIF
     "--" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 29
          &ELSE AT ROW 13 COL 29 &ENDIF
     "---" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 58
          &ELSE AT ROW 13 COL 58 &ENDIF
     "---" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 32
          &ELSE AT ROW 13 COL 32 &ENDIF
     "------" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 51
          &ELSE AT ROW 13 COL 51 &ENDIF
     "--------------" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 65
          &ELSE AT ROW 13 COL 65 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     "��ਮ�" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
          &ELSE SIZE 11 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 11
          &ELSE AT ROW 12 COL 11 &ENDIF
     "--" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 62
          &ELSE AT ROW 13 COL 62 &ENDIF
     "��" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 29
          &ELSE AT ROW 12 COL 29 &ENDIF
     "��" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 23
          &ELSE AT ROW 12 COL 23 &ENDIF
     "����. ��ਮ�" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 36
          &ELSE AT ROW 12 COL 36 &ENDIF
     "��" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 26
          &ELSE AT ROW 12 COL 26 &ENDIF
     "��" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 3 BY 1
          &ELSE SIZE 3 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 32
          &ELSE AT ROW 12 COL 32 &ENDIF
     "��" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
          &ELSE SIZE 2 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 62
          &ELSE AT ROW 12 COL 62 &ENDIF
     "�����" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 6 BY 1
          &ELSE SIZE 6 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 51
          &ELSE AT ROW 12 COL 51 &ENDIF
     "-----------" VIEW-AS TEXT
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
          &ELSE SIZE 11 BY 1 &ENDIF
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 11
          &ELSE AT ROW 13 COL 11 &ENDIF
     mHiddenField
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 34 COLON-ALIGNED
          &ELSE AT ROW 12 COL 34 COLON-ALIGNED &ENDIF
          VIEW-AS EDITOR
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 43 BY 2
          &ELSE SIZE 43 BY 2 &ENDIF NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 80 BY 21
        TITLE "".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Temp-Tables and Buffers:
      TABLE: tt-amount T "?" NO-UNDO bisquit term-obl
      ADDITIONAL-FIELDS:
          FIELD viddogob$ AS CHARACTER /* �������� (��� ������� ���ᯥ祭��) */
          FIELD vidob$ AS CHARACTER /* ����� (��� �।��� ���ᯥ祭��) */
          FIELD datapost$ AS DATE /* ��⠏��� (��� ����㯫����) */
          FIELD dopinfo$ AS CHARACTER /* ������ (�������⥫쭠� ���ଠ��) */
          FIELD mestonahowzdenie$ AS CHARACTER /* ���⮭�宦����� (���⮭�宦����� �����⢠) */
          FIELD nomdogob$ AS CHARACTER /* �������� (����� ������� ���ᯥ祭��) */
          FIELD nomerpp$ AS INT64 /* ������� (���浪��� �����) */
          FIELD opisanie$ AS CHARACTER /* ���ᠭ�� (���ᠭ�� �।��� ���ᯥ祭��) */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-amount" "amount" }

      END-FIELDS.
      TABLE: tt-broker T "?" NO-UNDO bisquit cust-role
      ADDITIONAL-FIELDS:
          FIELD contract AS CHARACTER /* contract (����� �������) */
          FIELD HiddenFields AS CHARACTER /* HiddenFields (���᮪ ��. ����� � �����. �� Ver-format) */
          FIELD is_mandatory AS LOGICAL /* is_mandatory (�᭮���� ஫�) */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
          INDEX cust-role-id cust-role-id
          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-broker" "broker" }

      END-FIELDS.
      TABLE: tt-comm-rate T "?" NO-UNDO bisquit comm-rate
      ADDITIONAL-FIELDS:
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
          FIELD min_value       AS DECIMAL help "�������쭮� ���祭�� �� ���� ��ਮ� ����窨"  /* �������쭮� ���祭�� */
          INDEX local__id IS UNIQUE local__id
          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-comm-rate" "loan-cond:comm-rate" }

      END-FIELDS.

      TABLE: tt-comm-cond T "?" NO-UNDO bisquit comm-cond
      ADDITIONAL-FIELDS:
         FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
         FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
         FIELD local__id       AS INT64   /* �����䨪��� �����     */
         FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
         FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
         INDEX local__id IS UNIQUE local__id
         /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
         {ln-tthdl.i "tt-comm-cond" "loan-cond:comm-cond" }
         .

      END-FIELDS.

      TABLE: tt-commrate T "?" NO-UNDO bisquit comm-rate
      ADDITIONAL-FIELDS:
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-commrate" "commrate" }

      END-FIELDS.

      TABLE: tt-contragent T "?" NO-UNDO bisquit cust-role
      ADDITIONAL-FIELDS:
          FIELD contract AS CHARACTER /* contract (����� �������) */
          FIELD HiddenFields AS CHARACTER /* HiddenFields (���᮪ ��. ����� � �����. �� Ver-format) */
          FIELD is_mandatory AS LOGICAL /* is_mandatory (�᭮���� ஫�) */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
          INDEX cust-role-id cust-role-id
          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-contragent" "contragent" }

      END-FIELDS.
      TABLE: tt-dealer T "?" NO-UNDO bisquit cust-role
      ADDITIONAL-FIELDS:
          FIELD contract AS CHARACTER /* contract (����� �������) */
          FIELD HiddenFields AS CHARACTER /* HiddenFields (���᮪ ��. ����� � �����. �� Ver-format) */
          FIELD is_mandatory AS LOGICAL /* is_mandatory (�᭮���� ஫�) */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
          INDEX cust-role-id cust-role-id
          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-dealer" "dealer" }

      END-FIELDS.
      TABLE: tt-loan T "?" NO-UNDO bisquit loan
      ADDITIONAL-FIELDS:
          FIELD akt_vzv$ AS CHARACTER /* ���_��� (��⨢� ���襭�� � ��⮬ �᪠) */
          FIELD grup_dog$ AS CHARACTER /* ���_��� (��㯯� �������) */
          FIELD datasogl$ AS DATE /* ��⠑��� (��� �����祭�� �।�⭮�� �������) */
          FIELD data_uar$ AS CHARACTER /* ���_��� (����� � ��� ���⢥ত���� ���) */
          FIELD dosroka$ AS CHARACTER /* ������� (����� ᭨���� �।�⢠ �� �ப�) */
          FIELD igndtokwc$ AS LOGICAL /* ����⎪� (�����஢��� ���� ����砭�� �������) */
          FIELD nesno$ AS CHARACTER /* ��᭎ (��᭨����� ������) */
          FIELD okrugsum$ AS LOGICAL /* ���㣑� (���㣫���� �㬬� �������� ���⥦��) */
          FIELD rewzim$ AS CHARACTER /* ����� (���� ������஢ �ਢ��祭��) */
          FIELD sindkred$ AS LOGICAL /* �����। (������஢���� �।��) */
          FIELD BankCust AS CHARACTER /* BankCust (��� ������ �ᯮ����饣� �����) */
          FIELD Bfnc AS CHARACTER /* Bfnc (��� �㭪樨 Bfnc � DBI) */
          FIELD CallAcct AS CHARACTER /* CallAcct (DBI ��� �ॡ������ �� ���।�⨢�) */
          FIELD dateend AS DATE /* dateend (��� ����砭��/������� �� ldmfDD.txt) */
          FIELD DTKind AS CHARACTER /* DTKind (������������� ᤥ��� ��� Decision Table) */
          FIELD DTType AS CHARACTER /* DTType (��� ������� ��� Decision Table) */
          FIELD Exec_D AS LOGICAL /* Exec_D (�� ���뢠�� �� ������ ���-�� ���.) */
          FIELD IntAcct AS CHARACTER /* IntAcct (��業�� DBI ���) */
          FIELD list_type AS CHARACTER /* list_type (���᮪ ⨯�� ��⮢ ��� ���. �������) */
          FIELD main-loan-acct AS CHARACTER /* main-loan-acct (���� ���) */
          FIELD main-loan-cust AS CHARACTER /* main-loan-cust (�᭮���� ஫� ������) */
          FIELD OblAcct AS CHARACTER /* OblAcct (DBI ��� ��易⥫��� �� ���।�⨢�) */
          FIELD op-date AS CHARACTER /* op-date (1111) */
          FIELD PrevLoanID AS CHARACTER /* PrevLoanID (��뫪� �� �஫����஢����� ᤥ���) */
          FIELD ProfitCenter AS CHARACTER /* ProfitCenter (��� ���ࠧ������� �����/ProfitCenter) */
          FIELD rel_type AS CHARACTER /* rel_type (���᮪ ⨯�� ��⮢ ��� �ਢ離�) */
          FIELD ReplDate AS DATE /* ReplDate (��� �⬥�� ᤥ���) */
          FIELD RevRef1 AS CHARACTER /* RevRef1 (��뫪� �� ����� ᤥ���) */
          FIELD RevRef2 AS CHARACTER /* RevRef2 (��뫪� �� �⬥������ ᤥ���) */
          FIELD round AS LOGICAL /* round (���㣫����) */
          FIELD TermKey AS CHARACTER /* TermKey (��� ��筮�� � DBI) */
          FIELD TicketNumber AS CHARACTER /* TicketNumber (����� ⨪�� DBI (DocNum)) */
          FIELD ovrpr$ AS INT64
          FIELD ovrstop$ AS INT64
          FIELD ovrstopr$ AS CHARACTER /* �� ����⮯� */
          FIELD tranwspertip$ AS LOGICAL /* �� �࠭菥���� */
          FIELD prodkod$ AS CHARACTER /* �த��� ���:��� �த�� */
          FIELD svodgravto$ AS LOGICAL /* �� ��������� */
          FIELD svodgrafik$ AS LOGICAL /* �� ������䨪 */
          FIELD svodskonca$ AS LOGICAL /* �� ��������� */
          FIELD svodspostr$ AS LOGICAL /* �� ��������� */
          FIELD sum-depos AS DECIMAL /* �� �㬬� �易����� ������ */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
          FIELD rate-list AS CHARACTER
          FIELD stream-show AS LOGICAL
          FIELD AgrCounter  AS CHARACTER     /* ����� ������� �� ���稪� */
          FIELD LimitGrafDate AS DATE
          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-loan" "" }

      END-FIELDS.
      TABLE: tt-loan-acct T "?" NO-UNDO bisquit loan-acct
      ADDITIONAL-FIELDS:
          FIELD class-code AS CHARACTER /* class-code (����� loan-acct) */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-loan-acct" "loan-acct" }

      END-FIELDS.
      TABLE: tt-loan-acct-cust T "?" NO-UNDO bisquit loan-acct
      ADDITIONAL-FIELDS:
          FIELD class-code AS CHARACTER /* class-code (����� loan-acct) */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-loan-acct-cust" "loan-acct-cust" }

      END-FIELDS.
      TABLE: tt-loan-acct-main T "?" NO-UNDO bisquit loan-acct
      ADDITIONAL-FIELDS:
          FIELD class-code AS CHARACTER /* class-code (����� loan-acct) */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-loan-acct-main" "loan-acct-main" }

      END-FIELDS.
      TABLE: tt-loan-cond T "?" NO-UNDO bisquit loan-cond
      ADDITIONAL-FIELDS:
          FIELD annuitplat$  AS DECIMAL /* ����⏫�� (�㬬� �����⭮�� ���⥦�) */
          FIELD end-date AS DATE /* end-date (��� ����砭��) */
          FIELD EndDateBeforeProl AS DATE /* EndDateBeforeProl (��� ����砭�� ������ �� �஫����樨) */
          FIELD kollw#gtper$ AS INT64 /* �����⏥� (������⢮ �죮��� ��ਮ���) */
          FIELD kollw#gtperprc$ AS INT64 /* �����⏥���� (������⢮ �죮��� ��ਮ��� (��業��)) */
          FIELD cred-offset AS CHARACTER
          FIELD int-offset AS CHARACTER
          FIELD delay-offset AS CHARACTER
          FIELD delay-offset-int AS CHARACTER
          FIELD cred-mode AS CHARACTER /* cred-mode (���ᮡ ������� ����.��ਮ�� (��.����)) */
          FIELD int-mode AS CHARACTER /* int-mode (���ᮡ ������� ����.��ਮ�� (��業��)) */
          FIELD DateDelay AS INT64 /* DateDelay (���� ����砭�� ����.��ਮ�� (��.����)) */
          FIELD DateDelayInt AS INT64 /* DateDelayInt (���� ����砭�� ����.��ਮ�� (��業��)) */
          FIELD cred-work-calend AS LOGICAL /* cred-work-cale (����� ���� �த���.��ਮ�� (��.����)) */
          FIELD cred-curr-next AS LOGICAL /* cred-curr-next (����� ���� ����砭�� ��ਮ��(��.����) */
          FIELD int-work-calend AS LOGICAL /* int-work-calen (����� ���� �த���.��ਮ�� (��業��)) */
          FIELD int-curr-next AS LOGICAL /* int-curr-next (����� ���� ����砭�� ��ਮ�� (���.)) */
          FIELD Prolong AS LOGICAL /* Prolong (�஫����� ������) */
          FIELD interest AS CHAR /* �奬� ��稫���� */
          FIELD shemaplat$ AS LOGICAL /* �奬����� (�奬� ���⥦�) */
          FIELD isklmes$ AS LOGICAL /* �᪫��� (����稥 �᪫�祭�� ����楢) */
          FIELD NDays AS INT64 /* ������⢮ ���� ����⢨� �᫮��� */
          FIELD NMonthes AS INT64 /* ������⢮ ����楢 ����⢨� �᫮��� */
          FIELD NYears AS INT64 /* ������⢮ ��� ����⢨� �᫮��� */
          FIELD Test01 AS CHARACTER /* Test01 (Test01) */
          FIELD kredplat$ AS DECIMAL /* �।���� (�㬬� ��ਮ���.���⥦� �����. ��.�����) */
          FIELD prodtrf$ AS CHARACTER /* ��� ��� �த�� */
          FIELD PartAmount AS DECIMAL /* �� ���� �।�� ��ࢮ�� ��ਮ�� */
          FIELD FirstPeriod AS INTEGER /* �� �த����⥫쭮��� ��ࢮ�� ��ਮ�� � ������ */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-loan-cond" "loan-cond" }

      END-FIELDS.
      TABLE: tt-MonthOut T "?" NO-UNDO bisquit term-obl
      ADDITIONAL-FIELDS:
          FIELD viddogob$ AS CHARACTER /* �������� (��� ������� ���ᯥ祭��) */
          FIELD vidob$ AS CHARACTER /* ����� (��� �।��� ���ᯥ祭��) */
          FIELD datapost$ AS DATE /* ��⠏��� (��� ����㯫����) */
          FIELD dopinfo$ AS CHARACTER /* ������ (�������⥫쭠� ���ଠ��) */
          FIELD mestonahowzdenie$ AS CHARACTER /* ���⮭�宦����� (���⮭�宦����� �����⢠) */
          FIELD nomdogob$ AS CHARACTER /* �������� (����� ������� ���ᯥ祭��) */
          FIELD nomerpp$ AS INT64 /* ������� (���浪��� �����) */
          FIELD opisanie$ AS CHARACTER /* ���ᠭ�� (���ᠭ�� �।��� ���ᯥ祭��) */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-MonthOut" "loan-cond:MonthOut" }

      END-FIELDS.
      TABLE: tt-MonthSpec T "?" NO-UNDO bisquit term-obl
      ADDITIONAL-FIELDS:
          FIELD viddogob$ AS CHARACTER /* �������� (��� ������� ���ᯥ祭��) */
          FIELD vidob$ AS CHARACTER /* ����� (��� �।��� ���ᯥ祭��) */
          FIELD datapost$ AS DATE /* ��⠏��� (��� ����㯫����) */
          FIELD dopinfo$ AS CHARACTER /* ������ (�������⥫쭠� ���ଠ��) */
          FIELD mestonahowzdenie$ AS CHARACTER /* ���⮭�宦����� (���⮭�宦����� �����⢠) */
          FIELD nomdogob$ AS CHARACTER /* �������� (����� ������� ���ᯥ祭��) */
          FIELD nomerpp$ AS INT64 /* ������� (���浪��� �����) */
          FIELD opisanie$ AS CHARACTER /* ���ᠭ�� (���ᠭ�� �।��� ���ᯥ祭��) */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-MonthSpec" "loan-cond:MonthSpec" }

      END-FIELDS.
      TABLE: tt-percent T "?" NO-UNDO bisquit term-obl
      ADDITIONAL-FIELDS:
          FIELD viddogob$ AS CHARACTER /* �������� (��� ������� ���ᯥ祭��) */
          FIELD vidob$ AS CHARACTER /* ����� (��� �।��� ���ᯥ祭��) */
          FIELD datapost$ AS DATE /* ��⠏��� (��� ����㯫����) */
          FIELD dopinfo$ AS CHARACTER /* ������ (�������⥫쭠� ���ଠ��) */
          FIELD mestonahowzdenie$ AS CHARACTER /* ���⮭�宦����� (���⮭�宦����� �����⢠) */
          FIELD nomdogob$ AS CHARACTER /* �������� (����� ������� ���ᯥ祭��) */
          FIELD nomerpp$ AS INT64 /* ������� (���浪��� �����) */
          FIELD opisanie$ AS CHARACTER /* ���ᠭ�� (���ᠭ�� �।��� ���ᯥ祭��) */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-percent" "percent" }

      END-FIELDS.
      TABLE: tt-term-obl T "?" NO-UNDO bisquit term-obl
      ADDITIONAL-FIELDS:
          FIELD viddogob$ AS CHARACTER /* �������� (��� ������� ���ᯥ祭��) */
          FIELD vidob$ AS CHARACTER /* ����� (��� �।��� ���ᯥ祭��) */
          FIELD datapost$ AS DATE /* ��⠏��� (��� ����㯫����) */
          FIELD dopinfo$ AS CHARACTER /* ������ (�������⥫쭠� ���ଠ��) */
          FIELD mestonahowzdenie$ AS CHARACTER /* ���⮭�宦����� (���⮭�宦����� �����⢠) */
          FIELD nomdogob$ AS CHARACTER /* �������� (����� ������� ���ᯥ祭��) */
          FIELD nomerpp$ AS INT64 /* ������� (���浪��� �����) */
          FIELD opisanie$ AS CHARACTER /* ���ᠭ�� (���ᠭ�� �।��� ���ᯥ祭��) */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */

          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-term-obl" "term-obl" }

      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW TERMINAL-SIMULATION ASSIGN
         HIDDEN             = YES
         TITLE              = "   <insert window title>"
         HEIGHT             = 26.28
         WIDTH              = 91.43
         MAX-HEIGHT         = 26.28
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 26.28
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = YES
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = YES
         THREE-D            = YES
         MESSAGE-AREA       = YES
         SENSITIVE          = YES.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB TERMINAL-SIMULATION
/* ************************* Included-Libraries *********************** */

{bis-tty.pro}
{termobl.pro}           /* �����㬥��� ��� ࠡ��� � ������묨 ��魮��ﬨ. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME fMain
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-comm separator-2 fMain */
/* SETTINGS FOR FILL-IN tt-loan-acct-cust.acct IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR FILL-IN tt-loan-acct-main.acct IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR FILL-IN tt-amount.amt-rub IN FRAME fMain
   NO-ENABLE 1 3 4 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-percent.amt-rub IN FRAME fMain
   NO-ENABLE 1 3 4 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan-cond.annuitplat$ IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR BROWSE br-comm IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-loan.branch-id IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan.close-date IN FRAME fMain
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR EDITOR tt-loan.comment IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
ASSIGN
       tt-loan.comment:RETURN-INSERTED IN FRAME fMain  = TRUE.

/* SETTINGS FOR FILL-IN tt-loan.cont-type IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan-cond.cred-curr-next IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan-cond.cred-date IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN tt-loan-cond.cred-mode IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
ASSIGN
       tt-loan-cond.cred-mode:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan-cond.cred-month IN FRAME fMain
   1 3 EXP-LABEL                                                        */
/* SETTINGS FOR FILL-IN cred-offset_ IN FRAME fMain
   1 3                                                                  */
ASSIGN
       cred-offset_:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan-cond.cred-period IN FRAME fMain
   NO-ENABLE 1 3 4 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan-cond.cred-work-calend IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan.currency IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR COMBO-BOX tt-loan.cust-cat IN FRAME fMain
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR COMBO-BOX tt-dealer.cust-cat IN FRAME fMain
   NO-ENABLE 1 2 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR COMBO-BOX tt-broker.cust-cat IN FRAME fMain
   NO-ENABLE 1 2 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR FILL-IN tt-dealer.cust-id IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-broker.cust-id IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan.cust-id IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN CustName1 IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       CustName1:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN CustName2 IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       CustName2:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN CustName3 IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       CustName3:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan.datasogl$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan-cond.DateDelay IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan-cond.DateDelayInt IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan-cond.delay IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN delay-offset-int_ IN FRAME fMain
   1 3                                                                  */
ASSIGN
       delay-offset-int_:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN delay-offset_ IN FRAME fMain
   1 3                                                                  */
ASSIGN
       delay-offset_:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan-cond.delay1 IN FRAME fMain
   NO-ENABLE ALIGN-R 1 3 EXP-LABEL                                      */
/* SETTINGS FOR FILL-IN tt-loan-cond.disch-type IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN tt-loan.doc-num IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT                                 */
/* SETTINGS FOR FILL-IN tt-loan.doc-ref IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL EXP-FORMAT                                   */
/* SETTINGS FOR FILL-IN tt-loan.DTKind IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan.DTType IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT                                 */
/* SETTINGS FOR FILL-IN tt-loan.end-date IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan-cond.int-curr-next IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan-cond.int-date IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN tt-loan-cond.int-mode IN FRAME fMain
   NO-ENABLE 1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                        */
ASSIGN
       tt-loan-cond.int-mode:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan-cond.int-month IN FRAME fMain
   1 3 EXP-LABEL                                                        */
/* SETTINGS FOR FILL-IN int-offset_ IN FRAME fMain
   1 3                                                                  */
ASSIGN
       int-offset_:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN tt-loan-cond.int-period IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN tt-loan-cond.int-work-calend IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR TOGGLE-BOX tt-loan-cond.isklmes$ IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-loan-cond.kollw#gtper$ IN FRAME fMain
   NO-ENABLE 1 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan-cond.kollw#gtperprc$ IN FRAME fMain
   1 3 4 EXP-LABEL                                                      */
/* SETTINGS FOR FILL-IN tt-loan-cond.kredplat$ IN FRAME fMain
   1 3 4 EXP-LABEL EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tt-loan.loan-status IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN mBag IN FRAME fMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN mBranchName IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       mBranchName:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN mGrRiska IN FRAME fMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN mLimit IN FRAME fMain
   1 4                                                                  */
/* SETTINGS FOR FILL-IN mLimitRest IN FRAME fMain
   4                                                                    */
/* SETTINGS FOR FILL-IN mNameCredPeriod IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       mNameCredPeriod:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN mNameDischType IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       mNameDischType:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN mNameIntPeriod IN FRAME fMain
   NO-ENABLE 5                                                          */
ASSIGN
       mNameIntPeriod:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN mRisk IN FRAME fMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN tt-loan-cond.NDays IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tt-loan-cond.NMonthes IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tt-loan-cond.NYears IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT                                           */
/* SETTINGS FOR FILL-IN tt-loan.open-date IN FRAME fMain
   NO-ENABLE 1 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN tt-loan.ovrpr$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan.ovrstop$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan.ovrstopr$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan.tranwspertip$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN tt-loan.rewzim$ IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                        */
/* SETTINGS FOR FILL-IN separator IN FRAME fMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN
       separator:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN separator-2 IN FRAME fMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN separator-3 IN FRAME fMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN separator-4 IN FRAME fMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN Separator-5 IN FRAME fMain
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
/* SETTINGS FOR COMBO-BOX tt-loan.trade-sys IN FRAME fMain
   NO-ENABLE 1 2 3 EXP-LABEL                                            */
/* SETTINGS FOR FILL-IN tt-loan.user-id IN FRAME fMain
   NO-ENABLE 1 2 3                                                      */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(TERMINAL-SIMULATION)
THEN TERMINAL-SIMULATION:HIDDEN = YES.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-comm
/* Query rebuild information for BROWSE br-comm
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} PRESELECT EACH tt-comm-rate WHERE tt-comm-rate.since EQ tt-loan-cond.since SHARE-LOCK, LAST tt-comm-cond OUTER-JOIN WHERE tt-comm-cond.commission EQ tt-comm-rate.commission AND tt-comm-cond.since LE tt-comm-rate.since SHARE-LOCK BY tt-comm-rate.commission INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-comm */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME

/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME tt-loan-acct-main.acct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-acct-main.acct TERMINAL-SIMULATION
ON F1 OF tt-loan-acct-main.acct IN FRAME fMain /* ��楢�� ��� */
,tt-loan-acct-cust.acct
DO:
   DEFINE VARIABLE vFields AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vFieldsValue AS CHARACTER  NO-UNDO.
   IF iMode EQ {&MOD_VIEW} THEN DO:
      {find-act.i
         &acct    = SELF:SCREEN-VALUE
         &curr    = tt-loan.currency:SCREEN-VALUE
         }
      IF AVAIL acct THEN
         RUN formld.p(acct.class-code,
                      acct.acct + "," + acct.currency, "", "{&MOD_VIEW}",
                      iLevel + 1) NO-ERROR.
   END.
   ELSE
   DO TRANS:
      vFields =
         "OffLdFlt|" +
         "acct-cat" + CHR(1) +
         "cust-cat" + CHR(1) +
         "cust-id" + CHR(1) +
         "currency".
      vFieldsValue =
         "YES|" +
         "b" + CHR(1) +
         tt-loan.cust-cat:SCREEN-VALUE + CHR(1) +
         STRING(tt-loan.cust-id:INPUT-VALUE) + CHR(1) +
         tt-loan.currency:SCREEN-VALUE.
      RUN browseld.p ("acct",
                vFields,
                vFieldsValue,
                "cust-cat"  + CHR(1) + "cust-id",
                iLevel + 1).
      IF LASTKEY = 10 AND pick-value <> ? THEN
         SELF:SCREEN-VALUE = ENTRY(1,pick-value).
   END.
   RUN PutHelp("",FRAME {&MAIN-FRAME}:HANDLE).
   /* ����� ��頫�� */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mLimitGraf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mLimitGraf TERMINAL-SIMULATION
ON F6 OF FRAME fMain ANYWHERE
DO:
DEFINE VARIABLE vRez AS LOGICAL NO-UNDO .

  /* ��ଠ ���������� �᫮��� ࠧ���稢���� ��䨪�� ����⮢ */
  IF tt-loan.rewzim$:SCREEN-VALUE  NE ? AND
     tt-loan.rewzim$:SCREEN-VALUE  NE ""  THEN DO:

      mDate2  = tt-loan.LimitGrafDate .
      RUN limgru.p (
          iMode ,
          tt-loan.contract  ,
          tt-loan.cont-code ,
          tt-loan.open-date ,
          DATE(tt-loan.end-date:SCREEN-VALUE ),
          INPUT-OUTPUT mDate2  ,
          OUTPUT  vRez
          ).
      IF iMode NE {&MOD_VIEW} THEN DO:
         tt-loan.LimitGrafDate = mdate2.
      END.
  END.
  ELSE DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "�� ����� ०�� �।�⭮� �����!" ).
      RETURN NO-APPLY .
  END.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-acct-main.acct TERMINAL-SIMULATION
ON LEAVE OF tt-loan-acct-main.acct IN FRAME fMain /* ��楢�� ��� */
,tt-loan-acct-cust.acct
DO:
   {&BEG_BT_LEAVE}
   IF iMode NE {&MOD_VIEW} THEN
   DO:
      IF     SELF:SCREEN-VALUE NE ""
         AND SELF:SCREEN-VALUE NE "?"  THEN
      DO:
         {find-act.i
            &acct    = SELF:SCREEN-VALUE
            &curr    = tt-loan.currency:SCREEN-VALUE
         }

         IF AVAIL acct THEN
         DO:
            IF acct.branch-id NE tt-loan.branch-id:SCREEN-VALUE
            THEN DO:
               RUN Fill-SysMes IN h_tmess (
                  "", "", "4",
                  "��� ���ࠧ������� ������� �� ᮢ������\n� ����� ���ࠧ������� " +
                  "��࠭���� ���.\n�த������?"
               ).
               IF pick-value NE "YES"
               THEN DO:
                  RUN Fill-SysMes IN h_tmess (
                     "", "", "0",
                     "�롥�� ��㣮� ���� ��� ������� ��� ���ࠧ�������"
                  ).

                  RETURN NO-APPLY .
               END.
            END.
         END.
         ELSE
         DO:
            {find-act.i
               &filial  = tt-loan.filial-id
               &acct    = SELF:SCREEN-VALUE
               &curr    = tt-loan.currency:SCREEN-VALUE
            }

            IF NOT AVAIL acct THEN
            DO:
               RUN Fill-SysMes IN h_tmess (
                  "", "", "0",
                  "��� ��������� � �ࠢ�筨�� ��� �� ᮮ⢥����� ����� �������"
               ).

               RETURN NO-APPLY {&RET-ERROR}.
            END.
         END.
         /* �᫨ ���� ���, � ���� ��⠭����� acct-type �.�. �� ���⠭����
         ** �� �����⨪� �஢������ ஫� ��� */
         ASSIGN
            SELF:SCREEN-VALUE           = acct.acct
            tt-loan-acct-main.acct-type = "�।��"   WHEN tt-loan-acct-main.acct:SCREEN-VALUE NE "?"
            tt-loan-acct-cust.acct-type = "�।����" WHEN tt-loan-acct-cust.acct:SCREEN-VALUE NE "?"
         .
      END.
      ELSE
         ASSIGN
            tt-loan-acct-main.acct-type = "" WHEN tt-loan-acct-main.acct:SCREEN-VALUE EQ "?"
            tt-loan-acct-cust.acct-type = "" WHEN tt-loan-acct-cust.acct:SCREEN-VALUE EQ "?"
         .
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mBag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mBag TERMINAL-SIMULATION
ON LEAVE OF mBag IN FRAME fMain /* ����䥫� */
DO:
  {&BEG_BT_LEAVE}

  ASSIGN
    mBag
  .

   IF  iMode EQ {&MOD_ADD}
   THEN DO:
      RUN bagadd.p (
         INPUT tt-loan.contract,
         INPUT tt-loan.cont-code,
         INPUT mBag,
         INPUT tt-loan.open-date,
         INPUT gEnd-date
         ) NO-ERROR .
         IF ERROR-STATUS :ERROR THEN DO:
            RUN Fill-SysMes IN h_tmess ("", "", "0", RETURN-VALUE ).
            mBag = "".
            DISPLAY mBag WITH FRAME {&FRAME-NAME} .
            RETURN NO-APPLY {&RET-ERROR}.
         END.
    END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-amount.amt-rub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-amount.amt-rub TERMINAL-SIMULATION
ON LEAVE OF tt-amount.amt-rub IN FRAME fMain /*          �㬬� */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan.sum-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.sum-depos TERMINAL-SIMULATION
ON LEAVE OF tt-loan.sum-depos IN FRAME fMain /*          �㬬� */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   ASSIGN tt-loan.sum-depos.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.sum-depos TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan.sum-depos IN FRAME fMain /* cred-date */
DO:
   mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.PartAmount
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.PartAmount TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.PartAmount IN FRAME fMain /*          �㬬� */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   ASSIGN tt-loan-cond.PartAmount.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.PartAmount TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.PartAmount IN FRAME fMain /* cred-date */
DO:
   mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.FirstPeriod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.FirstPeriod TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.FirstPeriod IN FRAME fMain /*          �㬬� */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   ASSIGN tt-loan-cond.FirstPeriod.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.FirstPeriod TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.FirstPeriod IN FRAME fMain /* cred-date */
DO:
   mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-percent.amt-rub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-percent.amt-rub TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-percent.amt-rub IN FRAME fMain /*       ��業�� */
DO:
   IF SELF:INPUT-VALUE NE 0 THEN ASSIGN
      tt-loan-cond.int-period:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = "��"
      mNameIntPeriod:SCREEN-VALUE =
         GetDomainCodeName(tt-loan-cond.class-code,
                           "int-period",
                           tt-loan-cond.int-period:SCREEN-VALUE)
      tt-loan-cond.disch-type:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = "-1"
      mNameDischType:SCREEN-VALUE =
         GetBufferValue("disch-type",
                        "where disch-type = " + tt-loan-cond.disch-type:SCREEN-VALUE,
                        "name").
   ELSE ASSIGN
      tt-loan-cond.disch-type:SCREEN-VALUE = STRING(tt-loan-cond.disch-type)
      mNameDischType:SCREEN-VALUE =
         GetBufferValue("disch-type",
                        "where disch-type = " + STRING(tt-loan-cond.disch-type),
                        "name").
      /*
   APPLY "LEAVE" TO tt-loan-cond.disch-type IN FRAME {&MAIN-FRAME}.
   RETURN NO-APPLY.
   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.annuitplat$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.annuitplat$ TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.annuitplat$ IN FRAME fMain /* annuitplat$ */
DO:
   mHandCalcAnnuitet = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.annuitplat$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.annuitplat$ TERMINAL-SIMULATION
ON ENTRY OF tt-loan-cond.annuitplat$ IN FRAME fMain /* annuitplat$ */
DO:
   IF    iMode EQ {&MOD_ADD}
      OR iMode EQ {&MOD_EDIT}
   THEN DO:
      SetHelpStrAdd(mHelpStrAdd + "F5 ������ �㬬� ���⥦�").
      RUN PutHelp("",FRAME {&MAIN-FRAME}:HANDLE).
   END.
   {&BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.annuitplat$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.annuitplat$ TERMINAL-SIMULATION
ON F5 OF tt-loan-cond.annuitplat$ IN FRAME fMain /* �᪫. ���. */
DO:
   IF    iMode EQ {&MOD_ADD}
      OR iMode EQ {&MOD_EDIT}
   THEN DO:
      /* �ਭ㤨⥫�� ������ �㬬� �����⭮�� ���⥦� */
      mChangedField = YES.

      ASSIGN
         tt-loan.end-date
         tt-amount.amt-rub
         tt-loan-cond.cred-date
         tt-loan-cond.cred-period
         tt-loan-cond.cred-month
         tt-loan-cond.kollw#gtper$
         tt-loan-cond.cred-offset
         tt-loan-cond.annuitkorr$
         tt-loan.sum-depos
         tt-loan-cond.PartAmount
         tt-loan-cond.FirstPeriod
      .
      {loan-trg.pro
         &RecalcAnnuitet = YES
         &LogVarChanged  = mChangedField
         &tt-loan        = tt-loan
         &tt-loan-cond   = tt-loan-cond
         &tt-comm-rate   = tt-comm-rate
         &tt-amount      = tt-amount
         &br-comm        = br-comm
      }
      mHandCalcAnnuitet = NO.
   END.
   RETURN NO-APPLY.
END.

&Scoped-define SELF-NAME tt-loan-cond.annuitplat$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.annuitplat$ TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.annuitplat$ IN FRAME fMain /* annuitplat$ */
DO:
   IF    iMode EQ {&MOD_ADD}
      OR iMode EQ {&MOD_EDIT}
   THEN DO:
      SetHelpStrAdd(REPLACE(mHelpStrAdd,"F5 ������ �㬬� ���⥦�","")).
      RUN PutHelp("",FRAME {&MAIN-FRAME}:HANDLE).
   END.
   {&BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan.rewzim$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.rewzim$ TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan.rewzim$ IN FRAME fMain /* rewzim$ */
DO:
   IF NOT (   tt-loan.rewzim$:SCREEN-VALUE EQ "����뤇��"
           OR tt-loan.rewzim$:SCREEN-VALUE EQ "�����������"
           OR tt-loan.rewzim$:SCREEN-VALUE EQ "����������") THEN
      ASSIGN
         mLimit:VISIBLE IN FRAME fMain     = NO
         mLimitRest:VISIBLE IN FRAME fMain = NO
      .
   ELSE DO:
      ASSIGN
         mLimit:VISIBLE IN FRAME fMain     = YES
         mLimitRest:VISIBLE IN FRAME fMain = YES
      .
      APPLY "ENTRY" TO mLimit IN FRAME fMain.
      RETURN NO-APPLY.
      END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define BROWSE-NAME br-comm
&Scoped-define SELF-NAME br-comm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON CTRL-F2 OF br-comm IN FRAME fMain
ANYWHERE
DO:
   DEF VAR vRwd      AS ROWID                  NO-UNDO.
   DEF VAR vNewRate  LIKE comm-rate.rate-comm  NO-UNDO.
   DEF VAR vNewFixed LIKE comm-rate.rate-fixed NO-UNDO.
   DEF VAR vCommSpec AS CHARACTER              NO-UNDO.

   APPLY "VALUE-CHANGED" TO tt-comm-rate.rate-comm IN BROWSE br-comm.
   IF iMode NE {&MOD_ADD} THEN
      RETURN NO-APPLY.
   APPLY "LEAVE" TO FOCUS.
   IF RETURN-VALUE = {&RET-ERROR} THEN
      RETURN NO-APPLY.
   /* �������� ����� ������ �� �६����� ⠡��� �����ᨩ c ���⮩ �����ᨥ� */
   FIND FIRST tt-comm-rate WHERE tt-comm-rate.since EQ tt-loan-cond.since
      AND tt-comm-rate.commission = "" NO-ERROR.
   IF NOT AVAIL tt-comm-rate THEN
   DO:
      CREATE tt-comm-rate.
      FOR EACH b-comm-rate BY b-comm-rate.Local__Id DESC:
         LEAVE.
      END.
      BUFFER-COPY b-comm-rate EXCEPT local__id local__rowid commission rate-comm
         TO tt-comm-rate.
      tt-comm-rate.commission = "".
      tt-comm-rate.Local__UpId = tt-loan-cond.local__Id.
      tt-comm-rate.since = tt-loan-cond.since.
      tt-comm-rate.Local__Id = MAX(GetInstanceId("tt-comm-rate"),
                                   b-comm-rate.Local__Id) + 1.
      /* �������� �����  ������ �� �६����� ⠡��� �������� �⠢�� �������筮 */
      FIND FIRST tt-comm-cond WHERE tt-comm-cond.since EQ tt-loan-cond.since
                                AND tt-comm-cond.commission = "" NO-ERROR.
      IF NOT AVAIL tt-comm-cond THEN
      DO:
         FOR EACH b-comm-cond BY b-comm-cond.Local__Id DESC:
            LEAVE.
         END.
         CREATE tt-comm-cond.
         ASSIGN
            tt-comm-cond.contract  = tt-loan.contract
            tt-comm-cond.cont-code = tt-loan.cont-code
            tt-comm-cond.commission = tt-comm-rate.commission
            tt-comm-cond.since = tt-comm-rate.since
            tt-comm-cond.class-code = "comm-cond"
            tt-comm-cond.local__UpId = tt-loan-cond.local__Id.
            tt-comm-cond.local__Id = MAX(GetInstanceId("tt-comm-cond"),
                                            b-comm-cond.Local__Id) + 1.
      END.
   END.
   vRwd = ROWID(tt-comm-rate).
   {&OPEN-QUERY-br-comm}
   REPOSITION br-comm TO ROWID vRwd.
   APPLY "F1" TO tt-comm-rate.commission IN BROWSE br-comm.
   vNewRate = ?.

   IF     LASTKEY    EQ 10
      AND pick-value NE ? THEN
   DO:
      IF CAN-FIND(FIRST b-comm-rate WHERE
                  b-comm-rate.commission EQ pick-value AND
                  b-comm-rate.since      EQ tt-loan-cond.since AND
                  RECID(b-comm-rate) NE RECID(tt-comm-rate)) THEN
      DO:
         MESSAGE
            COLOR MESSAGES
            SUBSTITUTE("������� <&1> 㦥 ����  !" , pick-value )
            VIEW-AS ALERT-BOX.

         DELETE tt-comm-rate.
         br-comm:DELETE-SELECTED-ROW(1).
         vRwd = ROWID(tt-comm-rate).
         {&OPEN-QUERY-br-comm}
         REPOSITION br-comm TO ROWID vRwd.
         &IF DEFINED(MANUAL-REMOTE) &THEN
         RUN UpdateBrowser(br-comm:HANDLE).
         &ENDIF
         APPLY "entry" TO FOCUS.
         RETURN.
      END.


      /* �஢�ਬ , ����� �� �������� ��� ������� */
      vCommSpec = FGetSettingEx("����脮����",
                                 IF tt-loan.Contract EQ "�����"
                                    THEN "���������"
                                    ELSE "�।������",
                                 "",
                                 NO).

      IF LOOKUP(pick-value, vCommSpec) = 0 THEN DO:
         MESSAGE
            COLOR MESSAGES
            SUBSTITUTE("������� <&1> �� ���室�� ��� �।�⮢/������⮢ !" , pick-value )
            VIEW-AS ALERT-BOX.

         DELETE tt-comm-rate.
         br-comm:DELETE-SELECTED-ROW(1).
         vRwd = ROWID(tt-comm-rate).
         {&OPEN-QUERY-br-comm}
         REPOSITION br-comm TO ROWID vRwd.
         &IF DEFINED(MANUAL-REMOTE) &THEN
         RUN UpdateBrowser(br-comm:HANDLE).
         &ENDIF
         APPLY "entry" TO FOCUS.
         RETURN.
      END.
      tt-comm-rate.commission = pick-value.
      RUN getDefaultRate IN hDefaultRate ('init-rate' , /* ��� �ࠢ�筨��. */
                                          tt-loan.open-date:INPUT-VALUE,
                                          tt-loan.class-code,
                                          tt-loan.currency:INPUT-VALUE,
                                          tt-loan.cont-type:INPUT-VALUE,
                                          tt-comm-rate.commission,
                                          OUTPUT vNewRate).
      /* ��।��塞 ⨯ �����ᨨ �� 㬮�砭�� (= / %) */
      RUN getDefaultFixed IN hDefaultRate ('init-fixed',
                                           tt-loan.open-date:INPUT-VALUE,
                                           tt-loan.class-code,
                                           tt-loan.currency:INPUT-VALUE,
                                           tt-loan.cont-type:INPUT-VALUE,
                                           tt-comm-rate.commission,
                                           OUTPUT vNewFixed).
      IF vNewFixed NE ? THEN
         tt-comm-rate.rate-fixed = vNewFixed.
      ELSE
         tt-comm-rate.rate-fixed = GET_HEAD_COMM_TYPE (tt-comm-rate.commission,
                                                       tt-loan.currency:INPUT-VALUE,
                                                       tt-loan.open-date:INPUT-VALUE).
   END.
   ELSE
      APPLY "CTRL-F3" TO tt-comm-rate.rate-comm IN BROWSE br-comm.
   APPLY "ENTRY" TO tt-comm-rate.rate-comm IN BROWSE br-comm.
   IF RETURN-VALUE EQ {&RET-ERROR}
   THEN RETURN NO-APPLY.
   IF vNewRate NE ? THEN
      tt-comm-rate.rate-comm = vNewRate.
   ELSE
      tt-comm-rate.rate-comm = 0.
   tt-comm-rate.min_value = 0.
   FIND FIRST commission WHERE commission.commission EQ   tt-comm-rate.commission
                           AND commission.currency   EQ   tt-loan.currency:SCREEN-VALUE NO-LOCK.
   DISP
      tt-comm-rate.commission
      tt-comm-rate.rate-fixed
      tt-comm-cond.floattype
      tt-comm-rate.rate-comm
      tt-comm-rate.min_value
      commission.name-comm[1] @ mNameCommi
      WITH BROWSE br-comm.
   IF tt-comm-rate.commission EQ "" THEN
      DISP
         "" @ mNameCommi
         WITH BROWSE br-comm.
   &IF DEFINED(MANUAL-REMOTE) &THEN
   RUN UpdateBrowser(br-comm:HANDLE).
   &ENDIF
END.

ON LEAVE OF tt-comm-rate.min_value IN BROWSE br-comm DO:
 tt-comm-rate.min_value = DEC (tt-comm-rate.min_value:screen-value IN BROWSE br-comm ) NO-ERROR .
END.

ON LEAVE OF tt-comm-rate.rate-comm IN BROWSE br-comm DO:
 tt-comm-rate.rate-comm = DEC (tt-comm-rate.rate-comm:screen-value IN BROWSE br-comm ) NO-ERROR .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define BROWSE-NAME br-comm
&Scoped-define SELF-NAME br-comm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON CTRL-F9 OF br-comm IN FRAME fMain
ANYWHERE
DO:
   IF iMode EQ {&MOD_ADD} THEN
   DO:

      DEF VAR vTempRateComm AS DEC NO-UNDO.
      DEFINE VARIABLE vDateClc AS DATE    NO-UNDO.
      DEFINE VARIABLE vOk AS LOGICAL    NO-UNDO.

      vTempRateComm = DEC(tt-comm-rate.rate-comm:SCREEN-VALUE IN BROWSE br-comm).

      RUN f-cratepl.p (INPUT BUFFER tt-comm-rate:HANDLE,INPUT BUFFER tt-comm-cond:HANDLE,br-comm:ROW,OUTPUT vOk).

      /* �� ����� ������� �⠢�� ⮫쪮 ���������, � ���짮��⥫� ����� 㪠���� ���� �� �⠢��
      ** �� �������. ���⮬� ����뢠�� �� �⠢�� ������� ��᫠ ��� */
      IF tt-comm-cond.source EQ "��騥 �⠢��" THEN
      DO:
         RUN CalcFloatRate (tt-loan.contract,
                            tt-loan.cont-code,
                            tt-comm-cond.source,
                            tt-comm-cond.BaseCode,
                            DATE(tt-loan.open-date:SCREEN-VALUE),
                            tt-comm-cond.action,
                            tt-comm-cond.BaseChange,
                            tt-comm-cond.firstdelay,
                            OUTPUT vRatePS).
         IF vRatePS NE 0 THEN
         DO:
            vDateClc = tt-loan.open-date - tt-comm-cond.firstdelay.
            RUN GET_COMM_BUF (tt-comm-cond.BaseCode, /* ��� �����ᨨ. */
                     ?,                              /* �����䨪��� ���. */
                     "",                             /* ��� ������. */
                     "",                             /* ��� ��� ("" - �� 㬮�砭��). */
                     0.00,                           /* �����. ���⮪ (0 - ��㬮�砭��). */
                     0,                              /* ��ਮ�/�ப (0 - ��㬮�砭��). */
                     vDateClc,                       /* ��� ���᪠. */
                     BUFFER t-comm-rate
                     ).
   
            IF AVAIL t-comm-rate 
               AND t-comm-rate.since NE vDateClc
            THEN DO:
               RUN Fill-SysMes IN h_tmess ("", "", "0", 
              "�� ���� ���भ� " + STRING(vDateClc) + " �� ������� ���祭�� �⠢�� �� ���� " +
              STRING(tt-comm-cond.BaseCode) + " !~n ��᫥���� ��������� �⠢�� " + STRING(t-comm-rate.since) + "." ).
            END.

            FIND FIRST tt-comm-rate WHERE tt-comm-rate.commission EQ tt-comm-cond.commission
                                      AND tt-comm-rate.since      EQ tt-comm-cond.since
            EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL tt-comm-rate THEN
               ASSIGN
                  tt-comm-rate.rate-comm = vRatePS.
      END.
      END.
      ELSE
         tt-comm-rate.rate-comm = vTempRateComm.

      IF vOk  THEN
      DO:
         br-comm:REFRESH().
         &IF DEFINED(MANUAL-REMOTE) &THEN
         RUN UpdateBrowser(br-comm:HANDLE).
         &ENDIF
      END.
   END.
END.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON CTRL-F3 OF br-comm IN FRAME fMain
ANYWHERE
DO:
   DEFINE VARIABLE vRwd AS ROWID     NO-UNDO.
   DEFINE VARIABLE vTmp AS ROWID     NO-UNDO.
   IF iMode NE {&MOD_ADD} THEN
      RETURN NO-APPLY.
   IF NUM-RESULTS("br-comm") EQ 1 THEN
   DO:
      vRwd = ROWID(tt-comm-rate).
      tt-comm-rate.commission = "".
      tt-comm-rate.rate-comm = 0.
      tt-comm-cond.commission = "".
      tt-comm-cond.FloatType = NO .
      tt-comm-rate.local__template = YES.
      tt-comm-rate.Local__Id = GetInstanceId("tt-comm-rate") + 1.
      DISP
         tt-comm-rate.commission
         /*
         tt-comm-rate.Local__Id
         */
         "" @ mNameCommi
         tt-comm-rate.rate-comm
         WITH BROWSE br-comm.
   END.
   ELSE
   DO:
      /* �᫨ �⠢�� �뫠 ������饩,
      ** � �⬥砥� �� ��� �� ������饩 */
      tt-comm-cond.FloatType = NO .
      DELETE tt-comm-rate.
      br-comm:DELETE-SELECTED-ROW(1).
      vRwd = ROWID(tt-comm-rate).
   END.
   {&OPEN-QUERY-br-comm}
   REPOSITION br-comm TO ROWID vRwd.
   &IF DEFINED(MANUAL-REMOTE) &THEN
   RUN UpdateBrowser(br-comm:HANDLE).
   &ENDIF
   APPLY "entry" TO FOCUS.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON CTRL-J OF br-comm IN FRAME fMain
ANYWHERE
DO:
   APPLY "LEAVE" TO FOCUS.
   IF RETURN-VALUE = {&RET-ERROR} THEN
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON ENTER OF br-comm IN FRAME fMain
ANYWHERE
DO:
   DEFINE VARIABLE vRow AS ROWID      NO-UNDO.
   DEFINE VARIABLE vH   AS HANDLE     NO-UNDO.

   vH = BROWSE br-comm:NEXT-TAB-ITEM.
   DO WHILE NOT(    vH:VISIBLE
                AND vH:SENSITIVE):
      vH = vH:NEXT-TAB-ITEM.
   END.

   APPLY "LEAVE" TO FOCUS.
   IF RETURN-VALUE = {&RET-ERROR} THEN
      RETURN NO-APPLY.
   IF FOCUS:NAME EQ "rate-comm" THEN
   DO:
      vRow = ROWID(tt-comm-rate).
      APPLY "CURSOR-DOWN" TO br-comm.
      IF vRow EQ ROWID(tt-comm-rate) THEN
         APPLY "ENTRY" TO vH.
   END.
   ELSE IF FOCUS:NAME EQ "min_value" THEN
   DO:
      vRow = ROWID(tt-comm-rate).
      APPLY "CURSOR-DOWN" TO br-comm.
      IF vRow EQ ROWID(tt-comm-rate)
         THEN APPLY "TAB"        TO SELF.
         ELSE APPLY "BACK-TAB"  TO SELF.
   END.
   ELSE
      APPLY "TAB" TO SELF.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON ENTRY OF br-comm IN FRAME fMain
DO:
   IF SELF:NAME EQ "br-comm" THEN
   DO:
      IF iMode EQ {&MOD_ADD} THEN
      FOR EACH tt-comm-rate:
         tt-comm-rate.since = tt-loan-cond.since.
         tt-comm-cond.since = tt-loan-cond.since.
      END.
      {&OPEN-QUERY-br-comm}
       br-comm:REFRESH() .
      RUN PutHelp(
         "F1" + (IF iMode EQ {&MOD_ADD} THEN "�Ctrl-F2 - ��������Ctrl-F3 - �������Ctrl-F9 - ������஢���" ELSE (IF mSwitchF9 AND iMode EQ {&MOD_VIEW} THEN "�F9" ELSE "")),
         FRAME {&MAIN-FRAME}:HANDLE).
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON F1 OF br-comm IN FRAME fMain
ANYWHERE
DO:
   IF SELF:NAME EQ "commission" AND iMode EQ {&MOD_ADD} THEN
   DO:
      DO TRANS:
         RUN browseld.p (
            "commission",
            "currency" + CHR(1) + "contract" + CHR(1) + "enable-editing",
            STRING(tt-loan.currency:SCREEN-VALUE) + CHR(1) + STRING(tt-loan.contract) + CHR(1) + "enable-editing",
            "currency" + CHR(1) + "contract",
            iLevel).
         IF LASTKEY = 10 AND pick-value <> ? THEN
            SELF:SCREEN-VALUE = pick-value.
      END.
   END.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON LEAVE OF br-comm IN FRAME fMain
ANYWHERE
DO:
   mModeBrowse = iMode  .
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged   = mChangedField
     &tt-loan         = tt-loan
     &tt-loan-cond    = tt-loan-cond
     &tt-comm-rate    = tt-comm-rate
     &tt-amount       = tt-amount
     &br-comm         = br-comm
  }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comm TERMINAL-SIMULATION
ON VALUE-CHANGED OF br-comm IN FRAME fMain
ANYWHERE DO:

   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &ValueChangedBrowseComm = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.branch-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.branch-id TERMINAL-SIMULATION
ON LEAVE OF tt-loan.branch-id IN FRAME fMain /* ���ࠧ������� */
DO:
  {&BEG_BT_LEAVE}
  IF iMode NE {&MOD_VIEW} AND
     GetBufferValue("branch",
                    "where branch-id = '" + SELF:SCREEN-VALUE + "'",
                    "branch-id") EQ ? THEN
  DO:
     MESSAGE "������ ��� ���ࠧ�������"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN NO-APPLY {&RET-ERROR}.
  END.
  mBranchName:SCREEN-VALUE = GetCliName("�",
                                        SELF:SCREEN-VALUE,
                                        OUTPUT vAddr,
                                        OUTPUT vINN,
                                        OUTPUT vKPP,
                                        INPUT-OUTPUT vType,
                                        OUTPUT vCode,
                                        OUTPUT vAcct).
  {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.cont-type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.cont-type TERMINAL-SIMULATION
ON LEAVE OF tt-loan.cont-type IN FRAME fMain /* ��� */
DO:
   {&BEG_BT_LEAVE}
   IF iMode NE {&MOD_VIEW} AND
      AVAIL tt-Instance AND
      SELF:SCREEN-VALUE EQ "��祭��" THEN
   DO:
      MESSAGE '������� - �祭�� �����ண� ������� �� ����� ����� ⨯ "��祭��"!'
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.cred-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-date TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.cred-date IN FRAME fMain /* cred-date */
DO:
  {&BEG_BT_LEAVE}
  {&BT_LEAVE}
  mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
  {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged  = mChangedField
     &tt-loan        = tt-loan
     &tt-loan-cond   = tt-loan-cond
     &tt-comm-rate   = tt-comm-rate
     &tt-amount      = tt-amount
     &br-comm        = br-comm
  }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-date TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.cred-date IN FRAME fMain /* cred-date */
DO:
   mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.cred-mode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-mode TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.cred-mode IN FRAME fMain /* cred-mode */
DO:
   /* �����塞 ������ ���� � ����ᨬ��� �� ���祭�� cred-mode (����. ��ਮ� - ��.����) */
   CASE tt-loan-cond.cred-mode:SCREEN-VALUE:
      WHEN "����焭��" THEN
         ASSIGN
            tt-loan-cond.DateDelay        :VISIBLE = NO
            tt-loan-cond.cred-curr-next   :VISIBLE = NO
            tt-loan-cond.delay1           :VISIBLE = YES
            tt-loan-cond.cred-work-calend :VISIBLE = YES
            tt-loan-cond.grperiod$        :VISIBLE = NO
         .
      WHEN "��⠎����" THEN
         ASSIGN
            tt-loan-cond.DateDelay        :VISIBLE = YES
            tt-loan-cond.cred-curr-next   :VISIBLE = YES
            tt-loan-cond.delay1           :VISIBLE = NO
            tt-loan-cond.cred-work-calend :VISIBLE = NO
            tt-loan-cond.grperiod$        :VISIBLE = NO
         .
      WHEN "��ਮ���" THEN
      DO:
         ASSIGN
            tt-loan-cond.DateDelay        :VISIBLE = NO
            tt-loan-cond.cred-curr-next   :VISIBLE = NO
            tt-loan-cond.delay1           :VISIBLE = YES
            tt-loan-cond.cred-work-calend :VISIBLE = NO
            tt-loan-cond.grperiod$        :VISIBLE = YES
         .
         DISPLAY tt-loan-cond.grperiod$ WITH FRAME {&MAIN-FRAME} .
      END.
   END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.cred-month
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-month TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.cred-month IN FRAME fMain /* cred-month */
DO:
  {&BEG_BT_LEAVE}
  IF  ( tt-loan-cond.cred-period:INPUT-VALUE EQ "�"
    AND tt-loan-cond.cred-month:INPUT-VALUE GT 3
    OR  tt-loan-cond.cred-period:INPUT-VALUE EQ "��"
    AND tt-loan-cond.cred-month:INPUT-VALUE GT 6
    OR  tt-loan-cond.cred-period:INPUT-VALUE EQ "�"
    AND tt-loan-cond.cred-month:INPUT-VALUE GT 12 )
    OR ((tt-loan-cond.cred-period:INPUT-VALUE EQ "�"
    OR   tt-loan-cond.cred-period:INPUT-VALUE EQ "��"
    OR   tt-loan-cond.cred-period:INPUT-VALUE EQ "�")
    AND  tt-loan-cond.cred-month:INPUT-VALUE  LE 0) THEN
  DO:
     RUN Fill-SysMes ("", "", "0", "� 㪠������ ��ਮ�� ��� ����� � 㪠����� ����஬.") NO-ERROR.
     {return_no_apply.i '{&RET-ERROR}'}
  END.
  {&BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-month TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.cred-month IN FRAME fMain /* cred-month */
DO:
  mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cred-offset_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cred-offset_ TERMINAL-SIMULATION
ON F1 OF cred-offset_ IN FRAME fMain
,int-offset_,delay-offset_,delay-offset-int_
DO:
   DEF VAR vi AS INT64    NO-UNDO.
   /* ��४��祭�� ���祭�� */
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      vi = LOOKUP(SELF:SCREEN-VALUE,mOffsetVld).
      vi = vi + 1.
      IF vi GT NUM-ENTRIES(mOffsetVld) THEN vi = 1.
      SELF:SCREEN-VALUE = ENTRY(vi,mOffsetVld).
      APPLY "VALUE-CHANGED" TO SELF.
      RETURN NO-APPLY.
   END.
   {&BT_F1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cred-offset_ TERMINAL-SIMULATION
ON LEAVE OF cred-offset_ IN FRAME fMain
DO:
   {&BEG_BT_LEAVE}
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      /* �������� ���祭�� */
      IF NOT CAN-DO(mOffsetVld,SELF:SCREEN-VALUE)  THEN
      DO:
         RUN GetXAttr (tt-loan.class-code, "cred-offset",BUFFER xattr).
         RUN Fill-SysMes IN h_tmess ("", "", "0",
            "���祭�� ४����� ~"" + xattr.name + "~" ����� ~"" + xattr.class-code +
            "~" �� ᮮ⢥����� ᯨ�� �����⨬�� ���祭�� ~"" + mOffsetVld + "~"").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
      ASSIGN
        /* �����뢠�� �ࠢ��쭮� ���祭�� � "�����饥" ���� ({&CB-NONE} ����� "--") */
        tt-loan-cond.cred-offset:SCREEN-VALUE = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                           THEN {&CB-NONE}
                                           ELSE SELF:SCREEN-VALUE
        tt-loan-cond.cred-offset              = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                           THEN ""
                                           ELSE SELF:SCREEN-VALUE.
      {&BT_LEAVE}
      mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
      {loan-trg.pro
         &RecalcAnnuitet = YES
         &LogVarChanged  = mChangedField
         &tt-loan        = tt-loan
         &tt-loan-cond   = tt-loan-cond
         &tt-comm-rate   = tt-comm-rate
         &tt-amount      = tt-amount
         &br-comm        = br-comm
      }
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cred-offset_ TERMINAL-SIMULATION
ON VALUE-CHANGED OF cred-offset_ IN FRAME fMain
DO:
   mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.cred-period
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-period TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.cred-period IN FRAME fMain /* ��.���� */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   ASSIGN
      mNameCredPeriod:SCREEN-VALUE =
         GetDomainCodeName(tt-loan-cond.class-code,
                           "cred-period",
                           tt-loan-cond.cred-period:SCREEN-VALUE)
   .
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged  = mChangedField
     &tt-loan        = tt-loan
     &tt-loan-cond   = tt-loan-cond
     &tt-comm-rate   = tt-comm-rate
     &tt-amount      = tt-amount
     &br-comm        = br-comm
  }
   
   DEFINE VARIABLE vH   AS HANDLE     NO-UNDO.
   vH = tt-loan-cond.cred-period:HANDLE:NEXT-SIBLING.
   DO WHILE VALID-HANDLE(vH):
      IF (    vH:VISIBLE
          AND vH:SENSITIVE) THEN
      DO :
         APPLY "ENTRY" TO vH.
         RETURN NO-APPLY. 
      END.
      vH = vH:NEXT-SIBLING.
   END.
   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.cred-period TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.cred-period IN FRAME fMain /* ��.���� */
DO:
   ASSIGN
     tt-loan-cond.cred-month:SCREEN-VALUE = "1"
     mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.currency
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.currency TERMINAL-SIMULATION
ON LEAVE OF tt-loan.currency IN FRAME fMain /* ��� */
DO:
   {&BEG_BT_LEAVE}
   DEFINE VARIABLE vName AS CHARACTER  NO-UNDO.
   APPLY "LEAVE" TO FRAME {&MAIN-FRAME}.
   IF RETURN-VALUE EQ {&RET-ERROR}
      THEN RETURN NO-APPLY.
   IF LASTKEY = KEYCODE("ESC") OR iMode EQ {&MOD_VIEW} THEN RETURN.
   vName = GetBufferValue("currency",
                          "WHERE currency.currency EQ '" +
                              INPUT FRAME {&MAIN-FRAME} tt-loan.currency + "'",
                          "i-currency").
  IF vName EQ ? THEN
  DO:
     SELF:SCREEN-VALUE = "".
     MESSAGE "����� ��������� � �ࠢ�筨��"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN NO-APPLY {&RET-ERROR}.
  END.
  {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-broker.cust-cat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-broker.cust-cat TERMINAL-SIMULATION
ON F1 OF tt-broker.cust-cat IN FRAME fMain /*     �ப�� */
, tt-broker.cust-id
DO:
   IF tt-loan.alt-contract EQ "mm" AND
      iMode NE {&MOD_VIEW} THEN
   DO:
      {f-fx.trg
         &F1-BROKER = YES
         &BASE-TABLE=tt-loan}
   END.
   ELSE
   DO:
      {&BT_F1}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-dealer.cust-cat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dealer.cust-cat TERMINAL-SIMULATION
ON F1 OF tt-dealer.cust-cat IN FRAME fMain /*     ����� */
, tt-dealer.cust-id
DO:
   IF tt-loan.alt-contract EQ "mm" AND
      iMode NE {&MOD_VIEW} THEN
   DO:
      {f-fx.trg
         &F1-DEALER = YES
         &BASE-TABLE=tt-loan}
   END.
   ELSE
   DO:
      {&BT_F1}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.cust-cat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.cust-cat TERMINAL-SIMULATION
ON F1 OF tt-loan.cust-cat IN FRAME fMain /*      ����ࠣ��� */
, tt-loan.cust-id
DO:
   IF tt-loan.alt-contract EQ "mm" AND
      iMode NE {&MOD_VIEW} THEN
   DO:
      {f-fx.trg
         &F1-CUST = YES
         &BASE-TABLE=tt-loan}
   END.
   ELSE
   DO:
      {&BT_F1}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-dealer.cust-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dealer.cust-id TERMINAL-SIMULATION
ON LEAVE OF tt-dealer.cust-id IN FRAME fMain /* ��� */
DO:
   {&BEG_BT_LEAVE}
   IF tt-loan.alt-contract = "mm" THEN
   DO:
      {f-fx.trg &LEAVE-DEALER-CUST-ID = YES}
   END.
   ELSE
   DO:
      {&BT_LEAVE}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.cust-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.cust-id TERMINAL-SIMULATION
ON LEAVE OF tt-loan.cust-id IN FRAME fMain /* ��� */
DO:
   {&BEG_BT_LEAVE}
   IF tt-loan.alt-contract = "mm" THEN
   DO:
      {f-fx.trg &LEAVE-CUST-ID = YES}
   END.
   ELSE
   DO:
      {&BT_LEAVE}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-broker.cust-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-broker.cust-id TERMINAL-SIMULATION
ON LEAVE OF tt-broker.cust-id IN FRAME fMain /* ��� */
DO:
   {&BEG_BT_LEAVE}
   IF tt-loan.alt-contract = "mm" THEN
   DO:
      {f-fx.trg &LEAVE-BROKER-CUST-ID = YES}
   END.
   ELSE
   DO:
      {&BT_LEAVE}
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.datasogl$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.datasogl$ TERMINAL-SIMULATION
ON LEAVE OF tt-loan.datasogl$ IN FRAME fMain /*     ���� */
DO:
  {&BEG_BT_LEAVE}
  IF BT_Modify(SELF) THEN
  DO:
     IF DATE(tt-loan.datasogl$:SCREEN-VALUE) > DATE(tt-loan.open-date:SCREEN-VALUE) THEN
     DO:
        IF iMode EQ {&MOD_ADD} THEN
           tt-loan.open-date:SCREEN-VALUE = STRING(tt-loan.datasogl$:SCREEN-VALUE).
        ELSE
        DO:
           MESSAGE "��� �����祭�� ������� �� ����� ���� ����� ���� ������"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY {&RET-ERROR}.
        END.
     END.
  END.

  {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.DateDelay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.DateDelay TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.DateDelay IN FRAME fMain /* DateDelay */
DO:
   {&BEG_BT_LEAVE}

   /* ����� ��� � ����� �� ����� ���� > 31 ��� <1 */
   IF INT64(SELF:SCREEN-VALUE) GT 31 THEN SELF:SCREEN-VALUE = "31".
   IF INT64(SELF:SCREEN-VALUE) LT 1  THEN SELF:SCREEN-VALUE = "1".

   /* ����� ��� (� ⥪�饬 �����) ����砭�� ����.��ਮ�� �� ����� ����
   ** ����� ����� ��� ��砫� ���⥦���� ��ਮ�� */
   IF     tt-loan-cond.cred-date:VISIBLE
      AND tt-loan-cond.cred-curr-next:SCREEN-VALUE EQ ENTRY(1,tt-loan-cond.cred-curr-next:FORMAT,"/")
      AND INT64(tt-loan-cond.cred-date:SCREEN-VALUE) GT INT64(tt-loan-cond.DateDelay:SCREEN-VALUE)
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "", "��� ����砭�� ���⥦���� ��ਮ�� (���� " +
                                  tt-loan-cond.DateDelay:SCREEN-VALUE + ") �� ����� ����~n " +
                                  "����� ���� ��� ��砫� (���� " + tt-loan-cond.cred-date:SCREEN-VALUE + ").").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.DateDelayInt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.DateDelayInt TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.DateDelayInt IN FRAME fMain /* DateDelayInt */
DO:
   {&BEG_BT_LEAVE}

   /* ����� ��� � ����� �� ����� ���� > 31 ��� <1 */
   IF INT64(SELF:SCREEN-VALUE) GT 31 THEN SELF:SCREEN-VALUE = "31".
   IF INT64(SELF:SCREEN-VALUE) LT 1  THEN SELF:SCREEN-VALUE = "1".

   /* ����� ��� (� ⥪�饬 �����) ����砭�� ����.��ਮ�� �� ����� ����
   ** ����� ����� ��� ��砫� ���⥦���� ��ਮ�� */
   IF     tt-loan-cond.int-date:VISIBLE
      AND tt-loan-cond.int-curr-next:SCREEN-VALUE EQ ENTRY(1,tt-loan-cond.int-curr-next:FORMAT,"/")
      AND INT64(tt-loan-cond.int-date:SCREEN-VALUE) GT INT64(tt-loan-cond.DateDelayInt:SCREEN-VALUE)
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "", "��� ����砭�� ���⥦���� ��ਮ�� (���� " +
                                  tt-loan-cond.DateDelayInt:SCREEN-VALUE + ") �� ����� ����~n " +
                                  "����� ���� ��� ��砫� (���� " + tt-loan-cond.int-date:SCREEN-VALUE + ").").
      RETURN NO-APPLY {&RET-ERROR}.
   END.

   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME delay-offset-int_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL delay-offset-int_ TERMINAL-SIMULATION
ON LEAVE OF delay-offset-int_ IN FRAME fMain
DO:
   {&BEG_BT_LEAVE}
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      /* �������� ���祭�� */
      IF NOT CAN-DO(mOffsetVld,SELF:SCREEN-VALUE)  THEN
      DO:
         RUN GetXAttr (tt-loan.class-code,"delay-offset-int",BUFFER xattr).
         RUN Fill-SysMes IN h_tmess ("", "", "0",
            "���祭�� ४����� ~"" + xattr.name + "~" ����� ~"" + xattr.class-code +
            "~" �� ᮮ⢥����� ᯨ�� �����⨬�� ���祭�� ~"" + mOffsetVld + "~"").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
      /* �����뢠�� �ࠢ��쭮� ���祭�� � "�����饥" ���� ({&CB-NONE} ����� "--") */
      ASSIGN
         tt-loan-cond.delay-offset-int:SCREEN-VALUE = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                                         THEN {&CB-NONE}
                                                         ELSE SELF:SCREEN-VALUE
         tt-loan-cond.delay-offset-int              = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                                         THEN ""
                                                         ELSE SELF:SCREEN-VALUE.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME delay-offset_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL delay-offset_ TERMINAL-SIMULATION
ON LEAVE OF delay-offset_ IN FRAME fMain
DO:
   {&BEG_BT_LEAVE}
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      /* �������� ���祭�� */
      IF NOT CAN-DO(mOffsetVld,SELF:SCREEN-VALUE)  THEN
      DO:
         RUN GetXAttr (tt-loan.class-code,"delay-offset",BUFFER xattr).
         RUN Fill-SysMes IN h_tmess ("", "", "0",
            "���祭�� ४����� ~"" + xattr.name + "~" ����� ~"" + xattr.class-code +
            "~" �� ᮮ⢥����� ᯨ�� �����⨬�� ���祭�� ~"" + mOffsetVld + "~"").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
      /* �����뢠�� �ࠢ��쭮� ���祭�� � "�����饥" ���� ({&CB-NONE} ����� "--") */
      ASSIGN
         tt-loan-cond.delay-offset:SCREEN-VALUE = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                                     THEN {&CB-NONE}
                                                     ELSE SELF:SCREEN-VALUE
         tt-loan-cond.delay-offset              = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                                     THEN ""
                                                     ELSE SELF:SCREEN-VALUE.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.disch-type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.disch-type TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.disch-type IN FRAME fMain /* ��ଠ ���� */
DO:
   {&BEG_BT_LEAVE}
   IF iMode NE {&MOD_VIEW} THEN
   DO:
      IF GetBufferValue("disch-type",
                        "where disch-type = " + SELF:SCREEN-VALUE,
                        "name") EQ ? THEN
      DO:
         MESSAGE "��ଠ ���� ��������� � �ࠢ�筨��"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY {&RET-ERROR}.
      END.
   END.
   IF iMode EQ {&MOD_ADD} AND SELF:INPUT-VALUE NE -1 THEN
      tt-percent.amt-rub:SCREEN-VALUE = "0".
   mNameDischType:SCREEN-VALUE =
      GetBufferValue("disch-type",
                     "where disch-type = " + SELF:SCREEN-VALUE,
                     "name").
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.doc-ref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.doc-ref TERMINAL-SIMULATION
ON LEAVE OF tt-loan.doc-ref IN FRAME fMain /* ����� ������� */
DO:
   {&BEG_BT_LEAVE}
   IF SELF:INPUT-VALUE EQ "" THEN
   DO:
      MESSAGE "����� ������� ������ ���� ������!"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   IF CAN-FIND(FIRST loan WHERE
               loan.filial-id EQ tt-loan.filial-id AND
               loan.contract EQ tt-loan.contract AND
               loan.doc-ref EQ SELF:INPUT-VALUE AND
               ROWID(loan) NE tt-loan.local__rowid) THEN
   DO:
      MESSAGE "������� � ⠪�� ����஬ 㦥 �������"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   IF   INDEX(SELF:INPUT-VALUE,",") NE 0
     OR INDEX(SELF:INPUT-VALUE,";") NE 0 THEN
   DO:
      RUN fill-sysmes IN h_tmess ("", "", "0", "����� ������� ᮤ�ন� ����饭�� ᨬ����.").
      RETURN NO-APPLY {&RET-ERROR}.
   END.

   IF ShMode THEN
   DO:
      tt-loan.cont-code = addFilToLoan(SELF:INPUT-VALUE,ShFilial).
   END.
   ELSE DO:
      tt-loan.cont-code = SELF:INPUT-VALUE.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.end-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.end-date TERMINAL-SIMULATION
ON LEAVE OF tt-loan.end-date IN FRAME fMain /* �� */
DO:
   DEF VAR vEnd_date AS DATE  NO-UNDO.
   DEF VAR vMove     AS INT64 NO-UNDO.
   DEF VAR vMess     AS CHAR  NO-UNDO.
   DEF VAR vFlag     AS INT64 NO-UNDO.

   IF     mNewEndDate  NE ?
      AND mNewEndDate  NE DATE(tt-loan.end-date:SCREEN-VALUE)
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "4", "�뫠 �������� ��⮬���᪨ ��⠭������� ��� ����砭�� � "
                                  + STRING(mNewEndDate,"99/99/9999") + " �� " + tt-loan.end-date:SCREEN-VALUE
                                  + ". ��⠢���?").
      IF pick-value NE "yes" 
      THEN
         tt-loan.end-date:SCREEN-VALUE = STRING(mNewEndDate,"99/99/9999").
   END.

   ASSIGN
      vMove     = 0
      vEnd_date = GetFstWrkDay(tt-loan.Class-Code, tt-loan.user-id, DATE(tt-loan.end-date:SCREEN-VALUE), 9, 1).
   {&BEG_BT_LEAVE}
   IF tt-loan.end-date:SCREEN-VALUE EQ "" THEN
      tt-percent.amt-rub:SCREEN-VALUE = "0".
   IF tt-loan.end-date:INPUT-VALUE LE tt-loan.open-date:INPUT-VALUE THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "��� ����砭�� �� ����� ���� ����� ���� ��砫�").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   IF AVAIL tt-instance AND
      tt-loan.end-date:INPUT-VALUE GT tt-instance.end-date THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "��� ������� �祭�� �� ����� ���� ����� ���� ������� �������").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
         /* ��������� ���� ����砭�� ������� � ������� ��஭� */
   IF     iMode EQ {&MOD_EDIT}
      AND tt-loan.end-date:INPUT-VALUE LT tt-loan.end-date
   THEN DO:
      /* �᫨ ���� �஫����樨 ��⮩ ����� ����� ���� ����砭�� ������� */
      IF CAN-FIND(FIRST pro-obl WHERE pro-obl.contract   EQ tt-loan.contract
                                  AND pro-obl.cont-code  EQ tt-loan.cont-code
                                  AND pro-obl.idnt       EQ 3
                                  AND pro-obl.n-end-date GT tt-loan.end-date:INPUT-VALUE)
      THEN DO:
         /* �� ������塞 ��������� ����, �.�. �� �⮬ ���⥦ �஫����஢���� �㤥� 㤠��� */
         RUN Fill-SysMes IN h_tmess ("", "", "0", "�������� �஫����樨 ��易⥫��� �� ���� ����� ����� ���� ����砭�� �������. ���砫� 㤠��� �஫����樨 ������.").
         tt-loan.end-date:SCREEN-VALUE = STRING(tt-loan.end-date).
         {return_no_apply.i '{&RET-ERROR}'}
      END.
      /* �᫨ ���� �᫮��� ��� ��砫� ������ �����  ����� ���� ����砭�� ������� */
      IF CAN-FIND(FIRST loan-cond WHERE loan-cond.contract     EQ tt-loan.contract
                                  AND   loan-cond.cont-code    EQ tt-loan.cont-code
                                  AND   loan-cond.since        GT tt-loan.end-date:INPUT-VALUE)
      THEN DO:
         /* �� ������塞 ��������� ����, �.�. ���� �� 㤠��� �᫮��� */
         RUN Fill-SysMes IN h_tmess ("", "", "0", "������� �᫮��� ������� �� ���� ����� ����� ���� ����砭�� �������. ���砫� 㤠��� �᫮��� ������.").
         tt-loan.end-date:SCREEN-VALUE = STRING(tt-loan.end-date).
         {return_no_apply.i '{&RET-ERROR}'}
      END.
   END.
   IF     iMode EQ {&MOD_ADD}
      AND AVAIL tt-instance THEN
   DO:
      Set_Loan(tt-loan.contract,ENTRY(1,tt-loan.cont-code," ")).
      RUN Chk_Stop_cond(DATE(tt-loan.open-date:SCREEN-VALUE),
                 OUTPUT vFlag).
      IF vFlag LT 0 THEN
      DO:
         IF vFlag EQ -1 THEN vmess = "��-�� ���� ᮣ��襭��".
         ELSE IF vFlag EQ -2 THEN vmess = "��-�� ����襭�� �ப� �뤠�".
         ELSE IF vFlag EQ -3 THEN vmess = "��-�� ������ ������襭���� �࠭�".
         ELSE IF vFlag EQ -4 THEN vmess = "��-�� ��������� � ��ਮ� ����⢨� ��. �࠭�".
         ELSE vmess = "".
         RUN Fill-SysMes IN h_tmess ("", "", "0", "�࠭� �� ��襫 �஢�ન " + vmess).
         RETURN NO-APPLY {&RET-ERROR}.
      END.
   END.
   IF tt-loan-cond.grperiod$ AND tt-loan-cond.grdatapo$ GT tt-loan.end-date:INPUT-VALUE THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "��� ����砭�� ������� �� ����� ���� ����� ���� ����砭�� ����஥��� ��䨪�� (�� ����⠏�)").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   /*mitr: ���������� % �⠢�� ���祭�ﬨ "�� 㬮�砭��"*/
   IF iMode EQ {&MOD_ADD}
      AND NOT mBrowseCommRateOFF THEN
   DO:

      DEFINE VARIABLE vNewRate  LIKE comm-rate.rate-comm  NO-UNDO.
      DEFINE VARIABLE vNewFixed LIKE comm-rate.rate-fixed NO-UNDO.
      FOR EACH tt-comm-rate WHERE tt-comm-rate.rate-comm EQ 0.0 :

         RUN getDefaultRate IN hDefaultRate (
            'init-rate' , /* ��� �ࠢ�筨��. */
            tt-loan.open-date:INPUT-VALUE,
            tt-loan.class-code,
            tt-loan.currency:INPUT-VALUE,
            tt-loan.cont-type:INPUT-VALUE,
            tt-comm-rate.commission,
            OUTPUT vNewRate).

         IF vNewRate NE ?
            AND vNewRate NE tt-comm-rate.rate-comm THEN
            ASSIGN
               tt-comm-rate.rate-comm = vNewRate
               mChangedField          = YES      /* ��� ������ ������ */
            .
         RUN getDefaultFixed IN hDefaultRate (
            'init-fixed' , /* ��� �ࠢ�筨��. */
            tt-loan.open-date:INPUT-VALUE,
            tt-loan.class-code,
            tt-loan.currency:INPUT-VALUE,
            tt-loan.cont-type:INPUT-VALUE,
            tt-comm-rate.commission,
            OUTPUT vNewFixed).
         IF vNewFixed NE ?
            AND vNewFixed NE tt-comm-rate.rate-fixed THEN
            ASSIGN
               tt-comm-rate.rate-fixed = vNewFixed
               mChangedField           = YES      /* ��� ������ ������ */
            .
      END.
      br-comm:REFRESH().
   END.

   pick-value = "".
   {&BT_LEAVE}
   /* �஢�ઠ �� ����室������ ᤢ��� ���� */
   IF     DATE(tt-loan.end-date:SCREEN-VALUE) NE mDateEnd
      AND DATE(tt-loan.end-date:SCREEN-VALUE) NE vEnd_date THEN DO:
      IF pick-value EQ "" THEN
         RUN Fill-SysMes IN h_tmess("","",3,"��� ~"��~" ������ �� ��室��� ����" + "~n" + "�������� �� ������訩 ࠡ�稩 ?|�������� ���।,�������� �����,�� ��������").
      vMove = IF pick-value = "2" THEN -1 ELSE IF pick-value = "1" THEN 1 ELSE 0.
      IF vMove NE 0 THEN
         tt-loan.end-date:SCREEN-VALUE = STRING(GetFstWrkDay(tt-loan.Class-Code, tt-loan.user-id, DATE(tt-loan.end-date:SCREEN-VALUE), 9, vMove)).
   END.
   mDateEnd = DATE(tt-loan.end-date:SCREEN-VALUE) NO-ERROR.

   IF    mSrokChange
     AND tt-loan.open-date:SCREEN-VALUE NE "?"
     AND tt-loan.end-date:SCREEN-VALUE  NE "?"
     AND tt-loan.end-date:SCREEN-VALUE  NE "" THEN
   DO:
      RUN DMY_In_Per(tt-loan.open-date:SCREEN-VALUE,
                     tt-loan.end-date:SCREEN-VALUE,
                     OUTPUT mNDays,
                     OUTPUT mNMonth,
                     OUTPUT mNYear).

      IF GetXattrInit(tt-loan.Class-Code,"���ᄭ") EQ "��" THEN
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(tt-loan.end-date:INPUT-VALUE - tt-loan.open-date:INPUT-VALUE)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(0)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(0)
         mChangedField                    = YES   /* ��� ������ ������ */
      .
      ELSE IF GetXattrInit(tt-loan.Class-Code,"���ጥ�") EQ "��" THEN
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(mNDays)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(mNMonth + mNYear * 12)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(0)
         mChangedField                    = YES   /* ��� ������ ������ */
      .
      ELSE
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(mNDays)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(mNMonth)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(mNYear)
         mChangedField                    = YES   /* ��� ������ ������ */
      .
   END.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged  = mChangedField
     &tt-loan        = tt-loan
     &tt-loan-cond   = tt-loan-cond
     &tt-comm-rate   = tt-comm-rate
     &tt-amount      = tt-amount
     &br-comm        = br-comm
  }
/*��� ��� �।�� �஢�ਬ ���2 */
   DEFINE VAR yy            AS INT64     NO-UNDO.
   DEFINE VAR dd            AS INT64     NO-UNDO.
   DEF VAR vTerm  AS CHAR INITIAL ""
                          NO-UNDO.
   DEF VAR vDTType AS CHAR NO-UNDO.
   DEF VAR vDTKind AS CHAR NO-UNDO.
   DEF VAR vDTTerm AS CHAR NO-UNDO.
   DEF VAR vDTCust AS CHAR NO-UNDO.

   IF     AVAIL tt-instance
      AND iMode EQ {&MOD_ADD} THEN
   DO:
      RUN DTCust(tt-instance.cust-cat,tt-instance.cust-id,?,OUTPUT vDTcust).
      ASSIGN
         vDTType = GetXAttrValueEx("loan",
                                   tt-instance.contract + "," + tt-instance.cont-code,
                                   "DTType",
                                   GetXAttrInit(tt-instance.class-code,"DTType"))
         vDTKind = GetXAttrValueEx("loan",
                                   tt-instance.contract + "," + tt-instance.cont-code,
                                   "DTKind",
                                   GetXAttrInit(tt-instance.class-code,"DTKind"))
         pick-value = ?
      .
      FOR EACH code WHERE code.class = "DTTerm" AND code.parent = "DTTerm"
          NO-LOCK:
         IF IS-Term(DATE(tt-loan.open-date:SCREEN-VALUE),
                    (IF DATE(tt-loan.end-date:SCREEN-VALUE) = ? THEN
                        12/31/9999
                     ELSE
                        DATE(tt-loan.end-date:SCREEN-VALUE)),
                    code.code,
                    NO,
                    0,
                    OUTPUT yy,
                    OUTPUT dd)
    THEN DO:
            Mask = tt-instance.contract + CHR(1)
                          + vDTType + CHR(1)
                          + vDTCust + CHR(1)
                          + vDTKind + CHR(1)
                          + code.code.
            RUN cbracct.p("DecisionTable","DecisionTable","DecisionTable",0).
            LEAVE.
         END.
      END. /*FOR*/
      IF pick-value EQ ? THEN
         RUN Fill-SysMes IN h_tmess ("", "", "0", "��� �࠭� �� ��।���� ���2 ").
      ELSE IF NOT tt-loan-acct-main.acct BEGINS pick-value THEN
      DO:
/* ���饬 �� �� �࠭�� */
         ASSIGN
            tt-loan-acct-main.acct = ?
            tt-loan-acct-main.acct:SCREEN-VALUE = ?
         .
         IF GetXAttrValueEx("loan",
                            tt-instance.contract + ',' + tt-instance.cont-code,
                            "�࠭菥����",
                            "��") EQ "���" THEN
         FOR EACH loan-acct WHERE loan-acct.contract  EQ tt-instance.contract
                              AND loan-acct.cont-code BEGINS tt-instance.cont-code
                              AND loan-acct.acct-type EQ tt-instance.contract
                              AND loan-acct.acct      BEGINS pick-value NO-LOCK,
            FIRST acct WHERE acct.acct EQ loan-acct.acct
                         AND acct.open-date LE DATE(tt-loan.open-date:SCREEN-VALUE)
                         AND (   acct.close-date EQ ?
                              OR acct.close-date GT DATE(tt-loan.end-date:SCREEN-VALUE))
                NO-LOCK :
            ASSIGN
               tt-loan-acct-main.acct = acct.number
               tt-loan-acct-main.acct:SCREEN-VALUE = acct.number
            .
         END.
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.end-date TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan.end-date IN FRAME fMain /* �� */
DO:
  mSrokChange   = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.int-mode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-mode TERMINAL-SIMULATION
ON F1 OF tt-loan-cond.int-mode IN FRAME fMain /* int-mode */
,tt-loan-cond.cred-mode
DO:
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      SELF:READ-ONLY = NO.
      mCall_F1_IN_Frame = YES.
      APPLY "F1" TO FRAME {&MAIN-FRAME}.
      mCall_F1_IN_Frame = NO.
      SELF:READ-ONLY = YES.
      RETURN NO-APPLY.
   END.
   {&BT_F1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-mode TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.int-mode IN FRAME fMain /* int-mode */
DO:
   {&BEG_BT_LEAVE}
   IF tt-loan-cond.int-mode:INPUT-VALUE EQ "��ਮ���" THEN
   DO:
      RUN Fill-SysMes ("", "", "0", "��� % ����� ����� ⨯ ��ਮ���.") NO-ERROR.
      {return_no_apply.i '{&RET-ERROR}'}
   END.
   {&BT_LEAVE}
   /* �����塞 ������ ���� � ����ᨬ��� �� ���祭�� int-mode (����. ��ਮ� - ��業��) */
   IF tt-loan-cond.int-mode:SCREEN-VALUE  EQ "����焭��"
   THEN ASSIGN tt-loan-cond.DateDelayint     :VISIBLE = NO
               tt-loan-cond.int-curr-next    :VISIBLE = NO
               tt-loan-cond.delay            :VISIBLE = YES
               tt-loan-cond.int-work-calend  :VISIBLE = YES.
   ELSE ASSIGN tt-loan-cond.delay            :VISIBLE = NO
               tt-loan-cond.int-work-calend  :VISIBLE = NO
               tt-loan-cond.DateDelayint     :VISIBLE = YES
               tt-loan-cond.int-curr-next    :VISIBLE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.int-month
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-month TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.int-month IN FRAME fMain /* int-month */
DO:
  {&BEG_BT_LEAVE}
  /* �஢�ઠ �� ���४⭮��� ����� */
  IF  ( tt-loan-cond.int-period:INPUT-VALUE EQ "�"
    AND tt-loan-cond.int-month:INPUT-VALUE GT 3
    OR  tt-loan-cond.int-period:INPUT-VALUE EQ "��"
    AND tt-loan-cond.int-month:INPUT-VALUE GT 6
    OR  tt-loan-cond.int-period:INPUT-VALUE EQ "�"
    AND tt-loan-cond.int-month:INPUT-VALUE GT 12 )
    OR ((tt-loan-cond.int-period:INPUT-VALUE EQ "�"
    OR   tt-loan-cond.int-period:INPUT-VALUE EQ "��"
    OR   tt-loan-cond.int-period:INPUT-VALUE EQ "�")
    AND  tt-loan-cond.int-month:INPUT-VALUE  LE 0) THEN
  DO:
     RUN Fill-SysMes ("", "", "0", "� 㪠������ ��ਮ�� ��� ����� � 㪠����� ����஬.") NO-ERROR.
     {return_no_apply.i '{&RET-ERROR}'}
  END.
  {&BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-month TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.int-month IN FRAME fMain /* int-month */
DO:
  mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-offset_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-offset_ TERMINAL-SIMULATION
ON LEAVE OF int-offset_ IN FRAME fMain
DO:
   {&BEG_BT_LEAVE}
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      /* �������� ���祭�� */
      IF NOT CAN-DO(mOffsetVld,SELF:SCREEN-VALUE)  THEN
      DO:
         RUN GetXAttr (tt-loan.class-code,"int-offset",BUFFER xattr).
         RUN Fill-SysMes IN h_tmess ("", "", "0",
            "���祭�� ४����� ~"" + xattr.name + "~" ����� ~"" + xattr.class-code +
            "~" �� ᮮ⢥����� ᯨ�� �����⨬�� ���祭�� ~"" + mOffsetVld + "~"").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
      ASSIGN
         /* �����뢠�� �ࠢ��쭮� ���祭�� � "�����饥" ���� ({&CB-NONE} ����� "--") */
         tt-loan-cond.int-offset:SCREEN-VALUE = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                           THEN {&CB-NONE}
                                           ELSE SELF:SCREEN-VALUE
         tt-loan-cond.int-offset              = IF SELF:SCREEN-VALUE EQ mOffsetNone
                                           THEN ""
                                           ELSE SELF:SCREEN-VALUE.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.int-period
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-period TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.int-period IN FRAME fMain /* ��業�� */
DO:
  {&BEG_BT_LEAVE}
  IF tt-loan-cond.int-period:INPUT-VALUE EQ "��" THEN
  DO:
     RUN Fill-SysMes ("", "", "0", "��� % ����� ����� ⨯ ��.") NO-ERROR.
     {return_no_apply.i '{&RET-ERROR}'}
  END.  
  {&BT_LEAVE}
  ASSIGN
     mNameIntPeriod:SCREEN-VALUE =
        GetDomainCodeName(tt-loan-cond.class-code,
                          "int-period",
                          tt-loan-cond.int-period:SCREEN-VALUE)
  .
  mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
  {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged  = mChangedField
     &tt-loan        = tt-loan
     &tt-loan-cond   = tt-loan-cond
     &tt-comm-rate   = tt-comm-rate
     &tt-amount      = tt-amount
     &br-comm        = br-comm
  }
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.int-period TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.int-period IN FRAME fMain /* ��業�� */
DO:
  ASSIGN
     tt-loan-cond.int-month:SCREEN-VALUE = "1"
     mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.isklmes$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.isklmes$ TERMINAL-SIMULATION
ON F1 OF tt-loan-cond.isklmes$ IN FRAME fMain /* �᪫. ���. */
DO:

  IF tt-loan.cont-code = "" THEN DO:
     MESSAGE "������ ����� �������."
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     APPLY "entry" TO tt-loan.doc-ref IN FRAME {&FRAME-NAME}.
     RETURN NO-APPLY.
  END.

  DO TRANSACTION:
     RUN term-exc.p (iMode,
                     tt-loan.contract,
                     tt-loan.cont-code,
                     IF iMode EQ {&MOD_ADD}
                        THEN tt-loan.open-date
                        ELSE tt-loan-cond.since,
                     INPUT-OUTPUT TABLE ttTermObl,
                     INPUT 4).
     IF CAN-FIND(FIRST ttTermObl) THEN
         SELF:SCREEN-VALUE = "yes".
     ELSE SELF:SCREEN-VALUE = "no".

     mChangedField = YES.
     mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
     {loan-trg.pro
         &RecalcAnnuitet = YES
         &LogVarChanged  = mChangedField
         &tt-loan        = tt-loan
         &tt-loan-cond   = tt-loan-cond
         &tt-comm-rate   = tt-comm-rate
         &tt-amount      = tt-amount
         &br-comm        = br-comm
      }
  END.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.isklmes$ TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.isklmes$ IN FRAME fMain /* �᪫. ���. */
DO:
  IF SELF:SCREEN-VALUE = "yes" THEN DO:
     APPLY "F1" TO SELF.
  END.
  ELSE DO:
      FOR EACH ttTermObl:
          DELETE ttTermObl.
      END.
      mChangedField = YES.
      mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
      {loan-trg.pro
         &RecalcAnnuitet = YES
         &LogVarChanged  = mChangedField
         &tt-loan        = tt-loan
         &tt-loan-cond   = tt-loan-cond
         &tt-comm-rate   = tt-comm-rate
         &tt-amount      = tt-amount
         &br-comm        = br-comm
      }
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.kollw#gtper$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.kollw#gtper$ TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.kollw#gtper$ IN FRAME fMain /* kollw#gtper$ */
DO:
   {&BEG_BT_LEAVE}
      /* �������� ���祭�� */
   IF INT64(SELF:SCREEN-VALUE) GE GetQntPer(DATE(tt-loan.open-date:SCREEN-VALUE),
                                          DATE(tt-loan.end-date:SCREEN-VALUE),
                                          IF tt-loan-cond.cred-date:VISIBLE EQ YES
                                             THEN INT64(tt-loan-cond.cred-date:SCREEN-VALUE)
                                             ELSE 0,
                                          tt-loan-cond.cred-period:SCREEN-VALUE + ":" + tt-loan-cond.cred-month:SCREEN-VALUE,
                                          tt-loan-cond.since)
      AND INT64(SELF:SCREEN-VALUE) NE 0 THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0",
         "��᫮ �죮��� ��ਮ��� ������ ���� ����� �᫠ ������ ��ਮ���").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.kollw#gtper$ TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.kollw#gtper$ IN FRAME fMain /* kollw#gtper$ */
DO:
  mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.kollw#gtperprc$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.kollw#gtperprc$ TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.kollw#gtperprc$ IN FRAME fMain /* kollw#gtperprc$ */
DO:
   {&BEG_BT_LEAVE}
      /* �������� ���祭�� */
   IF INT64(SELF:SCREEN-VALUE) GE GetQntPer(DATE(tt-loan.open-date:SCREEN-VALUE),
                                          DATE(tt-loan.end-date:SCREEN-VALUE),
                                          IF tt-loan-cond.int-date:VISIBLE EQ YES
                                             THEN INT64(tt-loan-cond.int-date:SCREEN-VALUE)
                                             ELSE 0,
                                          tt-loan-cond.int-period:SCREEN-VALUE + ":" + tt-loan-cond.int-month:SCREEN-VALUE,
                                          tt-loan-cond.since)
      AND INT64(SELF:SCREEN-VALUE) NE 0 THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0",
         "��᫮ �죮��� ��ਮ��� ������ ���� ����� �᫠ ������ ��ਮ���").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   {&BT_LEAVE}
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.kollw#gtperprc$ TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan-cond.kollw#gtperprc$ IN FRAME fMain /* kollw#gtperprc$ */
DO:
  mChangedField = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.kredplat$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.kredplat$ TERMINAL-SIMULATION
ON F5 OF tt-loan-cond.kredplat$ IN FRAME fMain /* kredplat$ */
DO:
   DEF VAR mPerCnt      AS INT64    NO-UNDO. /* ���稪 ��ਮ��� */
   DEF VAR vi_lgt       AS INT64    NO-UNDO. /* �᫮ �죮��� ��ਮ��� �� �� */
   DEF VAR vGrDateS     AS DATE     NO-UNDO. /* ��� ��砫� ��䨪� ����襭�� */
   DEF VAR vGrDatePo    AS DATE     NO-UNDO. /* ��� ����砭�� ��䨪� ����襭�� */

   vi_lgt = INT64(tt-loan-cond.kollw#gtper$:SCREEN-VALUE).   /* ��।������ �᫠ �죮��� ��ਮ��� �� �� */
   IF tt-loan-cond.grperiod$ AND tt-loan-cond.grdatas$ NE ? THEN
      vGrDateS = tt-loan-cond.grdatas$ - 1.
   ELSE
      vGrDateS = DATE(tt-loan.open-date:SCREEN-VALUE).
   IF tt-loan-cond.grperiod$ AND tt-loan-cond.grdatapo$ NE ? THEN
      vGrDatePo = tt-loan-cond.grdatapo$.
   ELSE
      vGrDatePo = DATE(tt-loan.end-date:SCREEN-VALUE).
   mPerCnt = GetQntPer (vGrDateS,
                        vGrDatePo,
                        IF tt-loan-cond.cred-date:VISIBLE EQ YES THEN INT64(tt-loan-cond.cred-date:SCREEN-VALUE)
                                                              ELSE 0,
                        tt-loan-cond.cred-period:SCREEN-VALUE + ":" + tt-loan-cond.cred-month:SCREEN-VALUE,
                        tt-loan-cond.since) - vi_lgt.
      /* �।���᫥��� �㬬� ���⥦� */
   SELF:SCREEN-VALUE = STRING(DEC(tt-amount.amt-rub:SCREEN-VALUE) / mPerCnt).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mBag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mBag TERMINAL-SIMULATION
ON F1 OF mBag IN FRAME fMain /* ����䥫� */
DO:
   IF       iMode             EQ {&MOD_VIEW}
      AND   SELF:SCREEN-VALUE NE ""
      AND   SELF:SCREEN-VALUE NE "?"
      THEN RUN bagform.p (?, ?, "UniformBag", "���," + SELF:SCREEN-VALUE, {&MOD_VIEW}, 4).

   IF       iMode             EQ {&MOD_ADD}
      THEN DO:
         DO TRANSACTION: /* ��� TRANSACTION  �����४�� pick-value */
            RUN browseld.p ('UniformBag', '', '', '', 4).
            IF LASTKEY NE 10
            THEN
               pick-value = "".
         END.
         RUN bagadd.p (
            INPUT tt-loan.contract,
            INPUT tt-loan.cont-code,
            INPUT pick-value,
            INPUT tt-loan.open-date,
            INPUT gEnd-date
            ) NO-ERROR .

         IF ERROR-STATUS :ERROR THEN DO:
            RUN Fill-SysMes IN h_tmess ("", "", "0", RETURN-VALUE ).
            RETURN NO-APPLY {&RET-ERROR}.
         END.
         ELSE DO:
            mBag = pick-value.
            DISPLAY mBag WITH FRAME {&FRAME-NAME} .

         END.
      END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mSvod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mSvod TERMINAL-SIMULATION
ON " ",F1 OF mSvod IN FRAME fMain /* ������ ��䨪 */
DO:
   RUN "f-mm-dop.p" (INPUT-OUTPUT tt-loan.svodgrafik$,   /* �� ������䨪 */
                     INPUT-OUTPUT tt-loan.svodskonca$,   /* �� ��������� */
                     INPUT-OUTPUT tt-loan.svodgravto$,   /* �� ��������� */
                     INPUT-OUTPUT tt-loan.svodspostr$,   /* �� ��������� */
                     10,
                     iLevel + 11,
                     mSvodROnly).
   mSvod:SCREEN-VALUE = STRING(tt-loan.svodgrafik$ OR tt-loan.svodskonca$ OR tt-loan.svodgravto$ OR tt-loan.svodspostr$).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mGrRiska
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mGrRiska TERMINAL-SIMULATION
ON F1 OF mGrRiska IN FRAME fMain /* �� */
DO:

   DO TRANSACTION:

      RUN codelay.p  ("�����",
                      "�����",
                      "��⥣�ਨ ����⢠",
                      iLevel + 1).

   END.

   IF LASTKEY = 10 AND pick-value <> ? THEN
   DO: 
       SELF:SCREEN-VALUE = ENTRY(1,pick-value,"��").
       mIsChanGRisk = YES.
   END.     

   RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mGrRiska TERMINAL-SIMULATION
ON LEAVE OF mGrRiska IN FRAME fMain /* �� */
DO:
   DEFINE VARIABLE vListGrRiska AS CHARACTER   NO-UNDO.
   {&BEG_BT_LEAVE}
   /*{&BT_LEAVE}*/
   IF (INPUT {&SELF-NAME} ) <>  {&SELF-NAME} THEN
   DO:
      ASSIGN {&SELF-NAME}.
      RUN LnGetRiskGrList IN h_i254 (DEC(mRisk:SCREEN-VALUE),
                                     DATE(tt-loan.open-date:SCREEN-VALUE),
                                     YES,
                                     OUTPUT vListGrRiska).

      IF NOT CAN-DO(vListGrRiska,mGrRiska:SCREEN-VALUE)
      THEN DO:

         RUN LnGetPersRsrvOnDate IN h_i254 (INPUT INPUT mGrRiska,
                                       INPUT INPUT tt-loan.open-date,
                                        OUTPUT mRisk).

         mRisk:SCREEN-VALUE = STRING(mRisk).
      END.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mLimit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mLimit TERMINAL-SIMULATION
ON LEAVE OF mLimit IN FRAME fMain /* ����� �. */
DO:
   IF iMode EQ {&MOD_ADD} THEN
      mLimitRest:SCREEN-VALUE = mLimit:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mRisk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mGrRiska TERMINAL-SIMULATION
ON VALUE-CHANGED OF mGrRiska IN FRAME fMAin
DO:
   {&BEG_BT_LEAVE}
   mIsChanGRisk = YES.
   {&END_BT_LEAVE}
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mRisk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mRisk TERMINAL-SIMULATION
ON LEAVE OF mRisk IN FRAME fMain /* ��� */
DO:
   DEFINE VARIABLE vListGrRiska AS CHARACTER   NO-UNDO.
   {&BEG_BT_LEAVE}
   IF mRisk:INPUT-VALUE < 0 OR
      mRisk:INPUT-VALUE > 100 THEN
   DO:
      MESSAGE '���ࠢ���� �����樥�� १�ࢨ஢����'
         VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY {&RET-ERROR}.
   END.

   IF (INPUT {&SELF-NAME} ) <>  {&SELF-NAME} THEN
   DO:

      ASSIGN {&SELF-NAME}.

      RUN LnGetRiskGrList IN h_i254 (DEC(mRisk:SCREEN-VALUE),
                                     DATE(tt-loan.open-date:SCREEN-VALUE),
                                     YES,
                                     OUTPUT vListGrRiska).
                                     
      IF NOT CAN-DO(vListGrRiska,mGrRiska:SCREEN-VALUE) OR NOT mIsChanGRisk
      THEN DO:
         RUN LnGetRiskGrOnDate IN h_i254 (DEC(mRisk:SCREEN-VALUE),
                                          DATE(tt-loan.open-date:SCREEN-VALUE),
                                          OUTPUT mGrRiska).
         IF mGrRiska = ? THEN
         DO:
            MESSAGE '�� 㤠���� ������ ��' SKIP
                    '�� 㪠������� �����樥��� १�ࢨ஢����'
               VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY {&RET-ERROR}.
         END.

         mGrRiska:SCREEN-VALUE = STRING(mGrRiska).
      END.
      ELSE mGrRiska:SCREEN-VALUE = ENTRY(1,vListGrRiska).
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan-cond.NYears
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.NYears TERMINAL-SIMULATION
ON ENTRY OF tt-loan-cond.NYears IN FRAME fMain /* ��� */
DO:
   vEndRasch = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.NYears TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.NYears IN FRAME fMain /* ��� */
DO:
   IF iMode = {&MOD_ADD} AND tt-loan.open-date:SCREEN-VALUE NE "?" AND NOT vEndRasch THEN DO:

      tt-loan.end-date:SCREEN-VALUE = STRING(
                        GoMonth(DATE(tt-loan.open-date:SCREEN-VALUE),
                                INT64(tt-loan-cond.NYears:SCREEN-VALUE) * 12 +
                                INT64(tt-loan-cond.NMonth:SCREEN-VALUE))
                      + INT64(tt-loan-cond.NDays:SCREEN-VALUE)
                   ).
      vEndRasch = YES.
   END.
   mSrokChange = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-loan.open-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.open-date TERMINAL-SIMULATION
ON LEAVE OF tt-loan.open-date IN FRAME fMain /* � */
DO:
   DEF VAR vDayTr AS INT64 NO-UNDO.
   DEF VAR vProdPog AS CHAR  NO-UNDO.

   {&BEG_BT_LEAVE}

  IF AVAIL tt-instance THEN
  DO:
     IF tt-loan.open-date:INPUT-VALUE LT tt-instance.open-date THEN
     DO:
        MESSAGE "��� ������ �祭�� �� ����� ���� ����� ���� ������ �������"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY {&RET-ERROR}.
     END.
     IF iMode EQ {&MOD_ADD} THEN
     DO:
        vDayTr = INT64(GetXAttrValueEx("loan",
                       tt-instance.contract + ',' + tt-instance.cont-code,
                       "�����",
                       "0")).
        IF vDayTr GT 0 AND tt-loan.end-date EQ ? THEN
           ASSIGN
              mSrokChange = TRUE
              tt-loan.end-date:SCREEN-VALUE = STRING(DATE(DATE(tt-loan.open-date:SCREEN-VALUE) + vDayTr))
              tt-loan.end-date = DATE(tt-loan.end-date:SCREEN-VALUE)
           NO-ERROR.
     END.
  END.

  IF DATE(tt-loan.open-date:SCREEN-VALUE) < DATE(tt-loan.datasogl$:SCREEN-VALUE) THEN
  DO:
     MESSAGE "��� ������ ������ ���� ����� ��� ࠢ�� ���� �����祭�� �������"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN NO-APPLY {&RET-ERROR}.
  END.

  {&BT_LEAVE}

   IF    mSrokChange
     AND tt-loan.open-date:SCREEN-VALUE NE "?"
     AND tt-loan.end-date:SCREEN-VALUE  NE "?"
     AND tt-loan.end-date:SCREEN-VALUE  NE "" THEN
   DO:
      RUN DMY_In_Per(tt-loan.open-date:SCREEN-VALUE,
                     tt-loan.end-date:SCREEN-VALUE,
                     OUTPUT mNDays,
                     OUTPUT mNMonth,
                     OUTPUT mNYear).

      IF GetXattrInit(tt-loan.Class-Code,"���ᄭ") EQ "��" THEN
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(tt-loan.end-date:INPUT-VALUE - tt-loan.open-date:INPUT-VALUE)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(0)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(0)
      .
      ELSE IF GetXattrInit(tt-loan.Class-Code,"���ጥ�") EQ "��" THEN
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(mNDays)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(mNMonth + mNYear * 12)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(0)
      .
      ELSE
      ASSIGN
         tt-loan-cond.NDays:SCREEN-VALUE  = STRING(mNDays)
         tt-loan-cond.NMonth:SCREEN-VALUE = STRING(mNMonth)
         tt-loan-cond.NYears:SCREEN-VALUE = STRING(mNYear)
      .
   END.
   mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.

   IF     mSrokChange    
      AND {assigned tt-loan.prodkod$} THEN
   DO:
      vProdPog = GetRefVal ("�த���", gend-date, tt-loan.prodkod$ + "," + "��").

      IF ENTRY(NUM-ENTRIES(vProdPog), vProdPog) EQ "��" THEN
      DO:
         pick-value = ?.
         RUN Fill-SysMes ("", "", "3",
                          "�������� ��� ����襭�� �᭮����� ����� � ��業⮢?|��,���").
         IF pick-value EQ "1" THEN
         DO:
            ASSIGN
               tt-loan-cond.cred-date:SCREEN-VALUE = STRING(DAY(DATE(tt-loan.open-date:SCREEN-VALUE)))
               tt-loan-cond.int-date:SCREEN-VALUE  = STRING(DAY(DATE(tt-loan.open-date:SCREEN-VALUE)))
            .
         END.
      END.
   END.

  {loan-trg.pro
     &RecalcAnnuitet = YES
     &LogVarChanged  = mChangedField
     &tt-loan        = tt-loan
     &tt-loan-cond   = tt-loan-cond
     &tt-comm-rate   = tt-comm-rate
     &tt-amount      = tt-amount
     &br-comm        = br-comm
  }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.open-date TERMINAL-SIMULATION
ON VALUE-CHANGED OF tt-loan.open-date IN FRAME fMain /* � */
DO:
  ASSIGN
     mSrokChange   = YES
     mChangedField = YES
  .

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.annuitkorr$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan-cond.annuitkorr$ TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.annuitkorr$ IN FRAME fMain /*          �㬬� */
DO:
   {&BEG_BT_LEAVE}
   {&BT_LEAVE}
   mChangedField = NOT mHandCalcAnnuitet.
   {loan-trg.pro
      &RecalcAnnuitet = YES
      &LogVarChanged  = mChangedField
      &tt-loan        = tt-loan
      &tt-loan-cond   = tt-loan-cond
      &tt-comm-rate   = tt-comm-rate
      &tt-amount      = tt-amount
      &br-comm        = br-comm
   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan.user-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-loan.user-id TERMINAL-SIMULATION
ON LEAVE OF tt-loan.user-id IN FRAME fMain /* ���� */
DO:
   {&BEG_BT_LEAVE}

   IF iMode NE {&MOD_VIEW} THEN 
   DO:
      IF NOT {assigned tt-loan.user-id:SCREEN-VALUE} THEN 
      DO:
         RUN Fill-SysMes IN h_tmess ("", "", "0",
                                     "��������  ~"����㤭��~" ��易⥫��.").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
   END.   
  
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-loan-cond.grperiod$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mStrah TERMINAL-SIMULATION
ON " ", F1 OF tt-loan-cond.grperiod$ IN FRAME fMain
DO:
   RUN per-graf.p(iMode,
                  tt-loan.open-date:INPUT-VALUE,
                  tt-loan.end-date:INPUT-VALUE,
                  INPUT-OUTPUT tt-loan-cond.grdatas$,
                  INPUT-OUTPUT tt-loan-cond.grdatapo$
                  ).
   tt-loan-cond.grperiod$ = tt-loan-cond.grdatas$ NE ? OR tt-loan-cond.grdatapo$ NE ?.
   DISPLAY tt-loan-cond.grperiod$ WITH FRAME fMain.
END.
   /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mStrah TERMINAL-SIMULATION
ON LEAVE OF tt-loan-cond.grperiod$ IN FRAME fMain
DO:
   {&BEG_BT_LEAVE}
   tt-loan-cond.grperiod$ = tt-loan-cond.grdatas$ NE ? OR tt-loan-cond.grdatapo$ NE ?.
   DISPLAY tt-loan-cond.grperiod$ WITH FRAME fMain.
   {&BT_LEAVE}
END.

   /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK TERMINAL-SIMULATION


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE
   RUN disable_UI.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.
ON ENDKEY, END-ERROR OF FRAME fMain ANYWHERE DO:
   DEFINE VARIABLE mChoice AS LOGICAL     NO-UNDO.
   IF iMode NE {&MOD_VIEW}
   THEN DO:
      MESSAGE
         "��� ��� ��࠭���� ���������?"
      VIEW-AS ALERT-BOX BUTTONS YES-NO UPDATE mChoice.
      IF NOT mChoice OR
         mChoice EQ ?
         THEN RETURN NO-APPLY.
   END.
   mRetVal = IF mOnlyForm THEN
      {&RET-ERROR}
      ELSE
         "".
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

ON ENTRY OF tt-comm-rate.rate-fixed IN BROWSE br-comm
DO:
   IF LASTKEY EQ KEYCODE ("TAB")
   THEN  DO:
      APPLY "ENTRY" TO tt-comm-rate.rate-comm IN BROWSE br-comm.
      RETURN NO-APPLY.
   END.
END.

ON ENTRY OF tt-comm-rate.commission IN BROWSE br-comm
DO:
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      IF LASTKEY EQ KEYCODE ("BACK-TAB")
      THEN /* BACK-TAB */
         APPLY "BACK-TAB" TO BROWSE br-comm.
      ELSE /* TAB  OR  ENTER */
         APPLY "ENTRY" TO tt-comm-rate.rate-comm IN BROWSE br-comm.
      RETURN NO-APPLY.
   END.
END.

&IF DEFINED(MANUAL-REMOTE) &THEN
ON F9 OF br-comm IN FRAME fMain ANYWHERE
DO:
   DEFINE VARIABLE vOk AS LOGICAL    NO-UNDO.

   IF iMode <> {&MOD_ADD} OR NOT AVAIL tt-comm-rate THEN
      RETURN NO-APPLY.

   RUN f-crate.p (INPUT BUFFER tt-comm-rate:HANDLE,br-comm:ROW,OUTPUT vOk).
   IF vOk  THEN
   DO:
      br-comm:REFRESH().
      &IF DEFINED(MANUAL-REMOTE) &THEN
      RUN UpdateBrowser(br-comm:HANDLE).
      &ENDIF
   END.
END.
ON INSERT OF br-comm IN FRAME fMain ANYWHERE
DO:
   APPLY "CTRL-F2" TO br-comm.
   RETURN NO-APPLY.
END.
ON DEL OF br-comm IN FRAME fMain ANYWHERE
DO:
   APPLY "CTRL-F3" TO br-comm.
   RETURN NO-APPLY.
END.
&ENDIF

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   /* Commented by KSV: ���樠������ ��⥬��� ᮮ�饭�� */
   RUN Init-SysMes("","","").

   /* Commented by KSV: ���४��㥬 ���⨪����� ������ �३�� */
   iLevel = GetCorrectedLevel(FRAME fMain:HANDLE,iLevel).
   FRAME fMain:ROW = iLevel.
   /* ������ TITLE COLOR bright-white */
   FRAME fMain:TITLE-DCOLOR = {&bright-white}.

   /*mitr: �����㬥�� ��� ����祭�� % �⠢�� �� 㬮�砭�� ���
   �����ᨩ, �ய�ᠭ��� � ���.४����� loan.rate-list */
   RUN ln-init-rate.p PERSISTENT SET hDefaultRate .

/* Commented by KSV: ��⠥� ����� */
   RUN GetObject.

   IF tt-loan-cond.isklmes$ = ? THEN tt-loan-cond.isklmes$ = NO.

   IF iMode = {&MOD_ADD} THEN
   DO:
      tt-loan.filial-id = dept.branch.
   END.

   ASSIGN
      mRateList = GetXattrEx(iClass,"rate-list","Initial")
      mBrowseCommRateOFF = NOT {assigned tt-loan.rate-list}
   .
   IF NOT mBrowseCommRateOFF THEN
   DO:
      IF iMode EQ {&MOD_ADD} THEN
      DO:
         DO mI = 1 TO NUM-ENTRIES(mRateList):
            FIND FIRST tt-comm-rate WHERE tt-comm-rate.commission = "" NO-ERROR.
            IF NOT AVAIL tt-comm-rate THEN
            DO:
               CREATE tt-comm-rate.
               tt-comm-rate.local__id = mI.
               CREATE tt-comm-cond.
               tt-comm-cond.local__id = mI.
            END.
            ASSIGN
               tt-comm-rate.commission = ENTRY(mI,mRateList)
               tt-comm-rate.acct       =  "0"
               tt-comm-cond.commission = ENTRY(mI,mRateList)
            .
            tt-comm-rate.rate-fixed = GET_HEAD_COMM_TYPE (tt-comm-rate.commission,
                                                          tt-loan.currency,
                                                          tt-loan.open-date).
         END.
         FOR EACH tt-comm-rate:
            tt-comm-rate.since = tt-loan-cond.since.
         END.
         FOR EACH tt-comm-cond:
            tt-comm-cond.since = tt-loan-cond.since.
         END.

            /* �������� �⠢�� �� ��䠬 */
         IF     tt-loan-cond.prodtrf$ NE ?
            AND tt-loan-cond.prodtrf$ NE ""
            AND tt-loan-cond.prodtrf$ NE "?" THEN
         DO:
               /* ���砫� �� "�த���" �饬 ��騩 ��� �த��� */
            IF     tt-loan.prodkod$ NE ""
               AND tt-loan.prodkod$ NE "?"
               AND tt-loan.prodkod$ NE ? THEN
            DO:
                  /* �饬 ������� ⥬���஢���� �����䨪���, �.�.
                  ** getTCodeFld �⪠�뢠���� ࠡ���� � ���ᨢ��� */
               mProdCode = tt-loan.prodkod$.
               FIND LAST tmp-code WHERE
                         tmp-code.class      EQ "�த���"
                  AND    tmp-code.code       EQ mProdCode
                  AND    tmp-code.beg-date   LE tt-loan.open-date
                  AND   (tmp-code.end-date   GE tt-loan.open-date
                     OR  tmp-code.end-date   EQ ?)
               NO-LOCK NO-ERROR.
                  /* �᫨ �� ����த�� �� ����� ������ ���, � �饬 �� த�⥫�� */
               REPEAT WHILE AVAIL tmp-code AND tmp-code.misc[7] EQ "":
                  FIND FIRST code WHERE
                             code.class EQ "�த���"
                         AND code.code  EQ mProdCode
                  NO-LOCK NO-ERROR.
                  IF AVAIL code AND code.parent NE "" THEN
                  DO:
                     mProdCode = code.parent.
                     FIND LAST tmp-code WHERE
                               tmp-code.class      EQ "�த���"
                        AND    tmp-code.code       EQ mProdCode
                        AND    tmp-code.beg-date LE tt-loan.open-date
                        AND   (tmp-code.end-date GE tt-loan.open-date
                            OR tmp-code.end-date EQ ?)
                     NO-LOCK NO-ERROR.
                  END.
                  ELSE
                     RELEASE tmp-code.
               END.

               IF AVAIL tmp-code AND tmp-code.misc[7] NE "" THEN
                  RUN SetTariffCommRate (tmp-code.misc[7]).
            END.

               /* �, �������, ���� ��� �த�� */
            RUN SetTariffCommRate (tt-loan-cond.prodtrf$).
               /* ���४��㥬 ���� ����䨪��ࠬ� */
            IF     tt-loan.prodkod$ NE ""
               AND tt-loan.prodkod$ NE "?"
               AND tt-loan.prodkod$ NE ? THEN
               RUN ModCommRate (tt-loan.prodkod$).
         END.
      END.
      ELSE
      DO:
         mI = 1.
         FOR EACH tt-commrate BREAK BY tt-commrate.commission:
            IF LAST-OF(tt-commrate.commission) THEN
            DO:
               FIND FIRST tt-comm-rate WHERE
                          tt-comm-rate.commission EQ tt-commrate.commission AND
                          tt-comm-rate.since EQ tt-loan-cond.since NO-LOCK NO-ERROR.

               IF AVAILABLE tt-comm-rate THEN DO:

                  ASSIGN
                     msurrcr2 = string(tt-comm-rate.commission) + "," +
                                string(tt-comm-rate.acct) + "," +
                                string(tt-loan.currency) + "," +
                                PushSurr(STRING(tt-loan.contract) + "," + STRING(tt-loan.cont-code))  + "," +
                                string(tt-comm-rate.min-value) + "," +
                                string(tt-comm-rate.period) + "," +
                                string(tt-comm-rate.since)
                     tt-comm-rate.min_value = dec(GetXAttrValueEx("comm-rate",msurrcr2,"�������","0"))
                  .
               END.
               ELSE DO:
                  /* �� �⠢�� ������� ⮫쪮 ��� �᫮��� ��������  */
                  IF NOT CAN-DO("������,��������", mFindLoanCond) THEN DO:
                  CREATE tt-comm-rate.
                  ASSIGN
                     tt-comm-rate.commission = tt-commrate.commission
                     tt-comm-rate.since = tt-loan-cond.since
                     tt-comm-rate.rate-comm = tt-commrate.rate-comm
                     tt-comm-rate.local__template = YES
                     tt-comm-rate.local__id = GetInstanceId("tt-comm-rate") + mI
                     mI = mI + 1
                  .
                     tt-comm-rate.rate-fixed = GET_HEAD_COMM_TYPE (tt-comm-rate.commission,
                                                                   tt-loan.currency,
                                                                   tt-loan.open-date).
               END.
              END.
            END.
         END.
      END.
      /* ������ ᮧ����� ���ଠ�� �� ������騬 �⠢��� */
      mI = 1.
      FOR EACH tt-comm-rate:
         FIND FIRST tt-comm-cond WHERE tt-comm-cond.commission EQ tt-comm-rate.commission
                                   AND tt-comm-cond.since      EQ tt-comm-rate.since
         EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAIL tt-comm-cond THEN
         DO:
            FOR EACH b-comm-cond BY b-comm-cond.Local__Id DESC:
               LEAVE.
            END.
            CREATE tt-comm-cond.
            ASSIGN
               tt-comm-cond.commission = tt-comm-rate.commission
               tt-comm-cond.since      = tt-comm-rate.since
               tt-comm-cond.contract   = tt-loan.contract
               tt-comm-cond.cont-code  = tt-loan.cont-code
               tt-comm-cond.class-code = "comm-cond"
               tt-comm-cond.local__template = YES
               tt-comm-cond.local__Id = MAX(GetInstanceId("tt-comm-cond"),
                                            b-comm-cond.Local__Id) + 1.
           .




               FIND LAST comm-cond WHERE comm-cond.contract   EQ tt-loan.contract
                                     AND comm-cond.cont-code  EQ tt-loan.cont-code
                                     AND comm-cond.commission EQ tt-comm-cond.commission
                                     AND comm-cond.since      LE tt-comm-cond.since
               NO-LOCK NO-ERROR.
                  /* �������� ⮫쪮 ⨯, �.�. � ��� �������� �⠢�� ��
                  ** ।���஢���� �� ������� */
               IF AVAIL comm-cond THEN
                  ASSIGN
                     tt-comm-cond.FloatType = comm-cond.FloatType.
            END.
         END.


      /* �।������塞 �⠢�� �� �᭮����� �����䨪��� �����⏠ࠬ */
      IF iMode EQ {&MOD_ADD} THEN
      DO:
         vCredPlav = GetXattrInit (tt-loan.class-code,"�।����").
         IF    vCredPlav NE ""
           AND vCredPlav NE ? THEN
         DO:
            DO vCounter = 1 TO NUM-ENTRIES(vCredPlav):

               FIND FIRST code WHERE code.class EQ "�����⏠ࠬ"
                                 AND code.code  EQ ENTRY(vCounter,vCredPlav)
               NO-LOCK NO-ERROR.
               IF AVAIL code THEN
               DO:
                  FIND FIRST tt-comm-cond WHERE tt-comm-cond.commission EQ ENTRY(2,code.misc[2])
                                            AND tt-comm-cond.since      EQ tt-loan-cond.since
                  EXCLUSIVE-LOCK NO-ERROR.
                  IF AVAIL tt-comm-cond THEN
                  DO:
                     ASSIGN
                        tt-comm-cond.action     = code.misc[3]
                        tt-comm-cond.BaseChange = DEC(code.misc[4])
                        tt-comm-cond.BaseCode   = ENTRY(1,code.misc[2])
                        tt-comm-cond.contract   = tt-loan.contract
                        tt-comm-cond.cont-code  = tt-loan.cont-code
                        tt-comm-cond.day        = INT64(ENTRY(1,code.misc[8]))
                        tt-comm-cond.delay      = INT64(ENTRY(2,code.misc[5]))
                        tt-comm-cond.FirstDelay = INT64(ENTRY(1,code.misc[5]))
                        tt-comm-cond.FloatType  = YES
                        tt-comm-cond.month      = INT64(ENTRY(2,code.misc[8]))
                        tt-comm-cond.period     = code.misc[6]
                        tt-comm-cond.quantity   = INT64(code.misc[7])
                        tt-comm-cond.reference  = ENTRY(vCounter,vCredPlav)
                        tt-comm-cond.source     = code.misc[1]
                     .

                     /* �᫨ �⠢�� ������ �� �������, � ��祣� ������ �� ����, �.�. �� ����
                     ** 㪠�뢠�� �� ����� ������� �⠢��. �᫨ �� ���� �⠢��, � ����塞
                     ** �� 㪠����� �ࠢ���� */
                     IF tt-comm-cond.source EQ "��騥 �⠢��" THEN
                     DO:
                        RUN CalcFloatRate (tt-loan.contract,
                                           tt-loan.cont-code,
                                           tt-comm-cond.source,
                                           tt-comm-cond.BaseCode,
                                           DATE(tt-loan.open-date:SCREEN-VALUE),
                                           tt-comm-cond.action,
                                           tt-comm-cond.BaseChange,
                                           tt-comm-cond.firstdelay,
                                           OUTPUT vRatePS).
                        IF vRatePS NE 0 THEN
                           FIND FIRST tt-comm-rate WHERE tt-comm-rate.commission EQ tt-comm-cond.commission
                                                     AND tt-comm-rate.since      EQ tt-comm-cond.since
                           EXCLUSIVE-LOCK NO-ERROR.
                           IF AVAIL tt-comm-rate THEN
                              ASSIGN
                                 tt-comm-rate.rate-comm = vRatePS.
                     END.
                  END.
               END.
            END.
         END.
      END.
   END.

   IF iMode EQ {&MOD_EDIT} OR
      iMode EQ {&MOD_VIEW} THEN
   DO:

      mRisk = LnRsrvRate(tt-loan.contract, tt-loan.cont-code, tt-loan.since).
      mGrRiska = re_history_risk(tt-loan.contract, tt-loan.cont-code, tt-loan.since, INT64(mRisk)).
      mBag = LnInBagOnDate (tt-loan.contract, tt-loan.cont-code, gend-date ).

      FOR FIRST tt-amount WHERE tt-amount.amt-rub NE 0 BY tt-amount.end-date:
         LEAVE.
      END.
      FIND LAST tt-percent NO-ERROR.
      FIND LAST tt-loan-acct-main NO-ERROR.
      FIND LAST tt-loan-acct-cust NO-ERROR.
   END.

   /* �᫨ � ��� ��᫥���� �᫮��� � ��� �� ���� ����砭�� �������,
   ** � ����室��� �⮡ࠦ��� �� 0, � ����窥 ���-�, � �㬬� ��᫥�����
   ** �� �㫥���� ��������� ���⥦� */
   IF tt-loan-cond.since EQ tt-loan.end-date THEN
      RUN RE_PLAN_SUMM_BY_LOAN IN h_loan (tt-loan.contract,
                                          tt-loan.cont-code,
                                          tt-loan-cond.since - 1,
                                          OUTPUT mSumma-sd).
   ELSE
      RUN RE_PLAN_SUMM_BY_LOAN IN h_loan (tt-loan.contract,
                                          tt-loan.cont-code,
                                          tt-loan-cond.since,
                                          OUTPUT mSumma-sd).
   ASSIGN
      mEndDate    = tt-loan.end-date
      mAmount     = mSumma-sd
      mCredPeriod = tt-loan-cond.Cred-Period  WHEN AVAIL tt-loan-cond
      mCredDate   = tt-loan-cond.Cred-Date    WHEN AVAIL tt-loan-cond
      mIntPeriod  = tt-loan-cond.int-period
      mIntDate    = tt-loan-cond.int-date
      mDelay1     = tt-loan-cond.Delay1       WHEN AVAIL tt-loan-cond
      mCredOffset = tt-loan-cond.cred-offset
      mCountPer   = tt-loan-cond.kollw#gtper$ WHEN AVAIL tt-loan-cond

      mBranchName = GetCliName(
         "�",
         tt-loan.branch-id,
         OUTPUT vAddr,
         OUTPUT vINN,
         OUTPUT vKPP,
         INPUT-OUTPUT vType,
         OUTPUT vCode,
         OUTPUT vAcct)
      mNameCredPeriod =
         GetDomainCodeName(tt-loan-cond.class-code,
                           "cred-period",
                           tt-loan-cond.cred-period)
      mNameIntPeriod =
         GetDomainCodeName(tt-loan-cond.class-code,
                           "int-period",
                           tt-loan-cond.int-period)
      mNameDischType =
         GetBufferValue("disch-type",
                        "where disch-type = " + STRING(tt-loan-cond.disch-type),
                        "name")
      mPartition = GetXattrEx(iClass,"Partition","Initial") /* ������ ���� */
      rid-t      = Rowid2Recid("loan-cond",tt-loan-cond.local__rowid)
                       WHEN (iMode = {&MOD_EDIT} OR
                             iMode = {&MOD_VIEW}) AND
                            tt-loan-cond.local__rowid <> ?
      rid-p      = Rowid2Recid("loan",tt-loan.local__rowid)
                       WHEN iMode = {&MOD_EDIT} OR
                            iMode = {&MOD_VIEW}
   .

   /* ��६ � ���孥�� ������� ��� ���� */
   IF     tt-loan.class-code EQ "loan-tran-lin-ann"
      AND AVAIL tt-instance THEN
   DO:
      FIND LAST loan-cond WHERE loan-cond.contract  EQ tt-instance.contract
                            AND loan-cond.cont-code EQ tt-instance.cont-code
      NO-LOCK NO-ERROR.
      IF AVAIL loan-cond THEN
         tt-loan-cond.disch-type = loan-cond.disch-type.
   END.

   /* ������塞 COMBO-BOX'� ����묨 �� ����奬� */
   RUN FillComboBox(FRAME {&MAIN-FRAME}:HANDLE).

   /* Commented by KSV: �����뢠�� �࠭��� ��� */
   STATUS DEFAULT "".
   RUN enable_UI.

   /* Commented by KSV: ���뢠�� � ����, ����� ࠧ�襭� ��������
   ** � ����ᨬ��� �� ०��� ������ */
   RUN EnableDisable.
   /* Commented by KSV: ���㥬 ࠧ����⥫�. �������⥫� �������� ��� FILL-IN
   ** � �����䨪��஬ SEPARATOR# � ��ਡ�⮬ VIES-AS TEXT */
   RUN Separator(FRAME fMain:HANDLE,"1").

   IF NOT THIS-PROCEDURE:PERSISTENT THEN
      WAIT-FOR CLOSE OF THIS-PROCEDURE FOCUS mFirstTabItem.
END.

/* Commented by KSV: ����뢠�� �㦡� ��⥬��� ᮮ�饭�� */
RUN End-SysMes.

RUN disable_ui.

/* Commented by KSV: ����塞 ������� ��ꥪ� */
IF VALID-HANDLE(mInstance) AND NOT mOnlyForm THEN
   RUN DelEmptyInstance(mInstance).

/* Commented by KSV: ���㦠�� ������⥪� */
{intrface.del}

/*mitr: ����媠 �����㬥�� ln-init-rate */
PUBLISH 'done'.

/* Commented by KSV: �����頥� ���祭�� ��뢠�饩 ��楤�� */
RETURN mRetVal.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CheckAutoTermDistrTT TERMINAL-SIMULATION
PROCEDURE CheckAutoTermDistrTT :
/*------------------------------------------------------------------------------
  Purpose: �஢�ઠ ���������� ��⮬���᪮� ࠧ��᪨ ���⥦�� �� �࠭蠬
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEF INPUT  PARAM iContract AS CHAR   NO-UNDO.   /* �����祭�� ������� */
   DEF INPUT  PARAM iContCode AS CHAR   NO-UNDO.   /* ����� ������� */
   DEF OUTPUT PARAM oCheckOk  AS LOG    NO-UNDO.   /* ������� */


   DEF BUFFER b-loan          FOR loan.            /* �����襭�� */
   DEF BUFFER b-loan-cond     FOR loan-cond.       /* �᫮��� ᮣ��襭�� */
   DEF BUFFER b-term-obl      FOR term-obl.        /* ��易⥫��⢠ ᮣ��襭�� */

   oCheckOk = TRUE.
      /* ����樮���㥬�� �� ᮣ��襭�� */
   FIND FIRST b-loan WHERE
              b-loan.contract  EQ iContract
      AND     b-loan.cont-code EQ ENTRY(1, iContCode, " ")
   NO-LOCK NO-ERROR.
   IF AVAIL b-loan THEN
   DO:
         /* �஢�ઠ �����⢫���� ⮫쪮 �� ��⮬���᪮� ࠧ��᪥ ��䨪� (�� "���������" = "��") */
      IF GetXAttrValue("loan", b-loan.contract + "," + b-loan.cont-code, "���������") EQ "��" THEN
      DO:
         bkl:
         DO:
               /* �饬 �������饥 �᫮��� ᮣ��襭�� */
            FIND LAST b-loan-cond WHERE
                      b-loan-cond.contract  EQ b-loan.contract
               AND    b-loan-cond.cont-code EQ b-loan.cont-code
               AND    b-loan-cond.since     LE b-loan.end-date
            NO-LOCK NO-ERROR.
            IF AVAIL b-loan-cond THEN
            DO:
                  /* �� ����� �ப� */
               IF tt-loan-cond.cred-period:SCREEN-VALUE IN FRAME {&frame-name} NE "��" THEN
               DO:
                     /* 1. �஢�ઠ ᮢ������� ��ࠬ��஢ ��ਮ��筮�� */
                  IF    b-loan-cond.cred-period NE     tt-loan-cond.cred-period:SCREEN-VALUE IN FRAME {&frame-name}
                     OR b-loan-cond.cred-date   NE INT64(tt-loan-cond.cred-date:SCREEN-VALUE   IN FRAME {&frame-name})
                     OR b-loan-cond.cred-month  NE INT64(tt-loan-cond.cred-month:SCREEN-VALUE  IN FRAME {&frame-name})
                  THEN DO:
                     pick-value = "2".        /* �।��⠭���� ����: "2" - ��� */
                     RUN Fill-SysMes IN h_tmess ("", "", "3",
                                                 "�� ᮢ������ ��ࠬ���� ���� ����襭�� �� �� ᮣ��襭�� � �࠭�.~n" +
                                                 "��⮬���᪠� ࠧ��᪠ ����������.~n" +
                                                 "�த������?:|��,���").
                     oCheckOk = IF pick-value EQ "1"
                                   THEN TRUE
                                   ELSE FALSE.
                     IF NOT oCheckOk THEN
                        LEAVE bkl.
                  END.
               END.
                  /* ����� �ப� */
               ELSE IF tt-loan-cond.cred-period:SCREEN-VALUE IN FRAME {&frame-name} EQ "��" THEN
               DO:
                     /* �饬 � ��䨪� ᮣ��襭�� �஢������ ����稥 ����� �� ���� ����砭�� �ப� �࠭� */
                  FIND FIRST b-term-obl WHERE
                             b-term-obl.contract     EQ b-loan.contract    /* ����� */
                     AND     b-term-obl.cont-code    EQ b-loan.cont-code   /* ᮣ��襭�� */
                     AND     b-term-obl.idnt         EQ 3
                     AND     b-term-obl.end-date     EQ DATE(tt-loan.end-date:SCREEN-VALUE IN FRAME {&frame-name})      /* ����砭�� �࠭� */
                  NO-LOCK NO-ERROR.
                     /* �� ������� - �㣠���� � ��室�� */
                  IF NOT AVAIL b-term-obl THEN
                  DO:
                     oCheckOk = FALSE.
                     RUN Fill-SysMes IN h_tmess ("", "", "1",
                                                 "� ��䨪� ᮣ��襭�� ��� ����� �� ���� ����砭�� �࠭� <" +
                                                 (tt-loan.end-date:SCREEN-VALUE IN FRAME {&frame-name}) + ">.").
                     LEAVE bkl.
                  END.
               END.
            END.
            ELSE
            DO:
               oCheckOk = FALSE.
               RUN Fill-SysMes IN h_tmess ("", "", "1",
                                           "�� ������� �������饥 �᫮���").
               LEAVE bkl.
            END.
         END.
      END.
   END.
END PROCEDURE. /* CheckAutoTermDistrTT */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreLoanStream TERMINAL-SIMULATION
PROCEDURE CreLoanStream :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER iCommRateId AS INT64    NO-UNDO.

   DEFINE BUFFER b-loan FOR tt-loan.
      FIND FIRST b-loan WHERE b-loan.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-loan THEN DELETE b-loan.
   DEFINE BUFFER b-loan-cond FOR tt-loan-cond.
      FIND FIRST b-loan-cond WHERE b-loan-cond.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-loan-cond THEN DELETE b-loan-cond.
   DEFINE BUFFER b-amount FOR tt-amount.
      FIND FIRST b-amount WHERE b-amount.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-amount THEN DELETE b-amount.
   DEFINE BUFFER b-percent FOR tt-percent.
      FIND FIRST b-percent WHERE b-percent.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-percent THEN DELETE b-percent.
   DEFINE BUFFER b-loan-acct-main FOR tt-loan-acct-main.
      FIND FIRST b-loan-acct-main WHERE b-loan-acct-main.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-loan-acct-main THEN DELETE b-loan-acct-main.
   DEFINE BUFFER b-loan-acct-cust FOR tt-loan-acct-cust.
      FIND FIRST b-loan-acct-cust WHERE b-loan-acct-cust.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-loan-acct-cust THEN DELETE b-loan-acct-cust.
   DEFINE BUFFER b-contragent FOR tt-contragent.
      FIND FIRST b-contragent WHERE b-contragent.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-contragent THEN DELETE b-contragent.
   DEFINE BUFFER b-dealer FOR tt-dealer.
      FIND FIRST b-dealer WHERE b-dealer.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-dealer THEN DELETE b-dealer.
   DEFINE BUFFER b-broker FOR tt-broker.
      FIND FIRST b-broker WHERE b-broker.local__ID EQ 1 NO-ERROR.
      IF AVAIL b-broker THEN DELETE b-broker.
   DEFINE BUFFER b-comm-rate FOR tt-comm-rate.
      FOR EACH b-comm-rate WHERE b-comm-rate.local__UpID EQ 1:
         DELETE b-comm-rate.
      END.

   FIND FIRST tt-loan WHERE tt-loan.local__UpId EQ 0 NO-ERROR.
   FIND FIRST tt-contragent WHERE tt-contragent.local__UpId EQ 0 NO-ERROR.
   FIND FIRST tt-dealer WHERE tt-dealer.local__UpId EQ 0 NO-ERROR.
   FIND FIRST tt-broker WHERE tt-broker.local__UpId EQ 0 NO-ERROR.
   FIND LAST tt-loan-cond WHERE tt-loan-cond.local__UpId EQ 0 NO-ERROR.
   FIND LAST tt-amount WHERE tt-amount.local__UpId EQ 0 NO-ERROR.
   FIND LAST tt-percent WHERE tt-percent.local__UpId EQ 0 NO-ERROR.
   FIND LAST tt-loan-acct-main WHERE tt-loan-acct-main.local__UpId EQ 0 NO-ERROR.
   FIND LAST tt-loan-acct-cust WHERE tt-loan-acct-cust.local__UpId EQ 0 NO-ERROR.

   IF NOT AVAIL tt-loan THEN
      RETURN ERROR "��������� LOAN".

   CREATE b-loan.
   CREATE tmp-loan. /*�⮡ �� ����஢��� ���.४� */
   BUFFER-COPY tt-loan  EXCEPT cont-code doc-ref alt-contract TO tmp-loan.
   BUFFER-COPY tmp-loan EXCEPT cont-code doc-ref alt-contract TO b-loan.
   DELETE tmp-loan.
   ASSIGN
      tt-loan.cont-type   = "��祭��"
      b-loan.cont-type    = tt-loan.cont-type:SCREEN-VALUE IN FRAME {&MAIN-FRAME}
      b-loan.cont-code    = tt-loan.cont-code + " 1"
      b-loan.Local__Id    = 1
      b-loan.alt-contract = IF tt-loan.alt-contract EQ "mm" THEN "mmap"
                                                            ELSE tt-loan.alt-contract
   .
      b-loan.class-code = GetXattrEx(iClass,"amt-part","Domain-Code").
      b-loan.doc-ref    = IF ShMode THEN DelFilFromLoan(b-loan.cont-code)
                                    ELSE b-loan.cont-code.

   CREATE b-loan-cond.
   BUFFER-COPY tt-loan-cond EXCEPT cont-code local__id local__upid
      TO b-loan-cond.
   ASSIGN
      b-loan-cond.cont-code = b-loan.cont-code
      b-loan-cond.Local__UpId = 1
      b-loan-cond.Local__Id = 1.

   IF tt-amount.amt-rub NE 0 THEN
   DO:
      CREATE b-amount.
      BUFFER-COPY tt-amount EXCEPT cont-code local__id local__upid
         TO b-amount.
      ASSIGN
         b-amount.cont-code = b-loan.cont-code
         b-amount.Local__UpId = 1
         b-amount.Local__Id = 1.
   END.
   FIND FIRST tt-term-obl.
   ASSIGN
      tt-term-obl.idnt = 3
      tt-term-obl.fop-date = tt-loan.open-date
      tt-term-obl.end-date = tt-loan.end-date
      tt-term-obl.amt-rub = b-amount.amt-rub
      tt-term-obl.Local__UpId = 1.

   IF {assigned tt-loan-acct-main.acct} THEN
   DO:
      IF shMode THEN
      DO: /* tt-loan-acct-main.acct ����� ���� ��� @ */
         FIND FIRST acct WHERE acct.filial-id EQ tt-loan.filial-id
                           AND acct.number    EQ ENTRY(1, tt-loan-acct-main.acct, "@")
                           AND acct.currency  EQ tt-loan-acct-main.currency
            NO-LOCK NO-ERROR.
         IF AVAIL acct THEN
         DO:
            IF tt-loan-acct-main.acct NE acct.acct THEN
               tt-loan-acct-main.acct = acct.acct.
         END.
      END.
      CREATE b-loan-acct-main.
      BUFFER-COPY tt-loan-acct-main EXCEPT cont-code local__id local__upid
         TO b-loan-acct-main.
      ASSIGN
         b-loan-acct-main.cont-code = b-loan.cont-code
         b-loan-acct-main.Local__UpId = 1
         b-loan-acct-main.Local__Id = 1.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI TERMINAL-SIMULATION  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  RUN DeleteOldDataProtocol IN h_base ("���㣫�������㡫��").
  /* Hide all frames. */
  HIDE FRAME fMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI TERMINAL-SIMULATION  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  separator-3:VISIBLE IN FRAME {&MAIN-FRAME} = NO. /*  */
  DISPLAY mBranchName CustName1 mNameCredPeriod cred-offset_ delay-offset_
          mNameIntPeriod int-offset_ delay-offset-int_ mBag mSvod mLimit
          mNameDischType mLimitRest mGrRiska mRisk CustName2 CustName3
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-amount THEN
    DISPLAY tt-amount.amt-rub
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-broker THEN
    DISPLAY tt-broker.cust-cat tt-broker.cust-id
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-dealer THEN
    DISPLAY tt-dealer.cust-cat tt-dealer.cust-id
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-loan THEN
    DISPLAY tt-loan.branch-id tt-loan.datasogl$ tt-loan.cust-cat tt-loan.cust-id
          tt-loan.doc-num tt-loan.doc-ref tt-loan.cont-type tt-loan.DTType
          tt-loan.DTKind tt-loan.currency tt-loan.open-date tt-loan.sum-depos tt-loan-cond.PartAmount tt-loan-cond.FirstPeriod tt-loan.end-date
          tt-loan.ovrstop$ tt-loan.ovrstopr$ tt-loan.ovrpr$ tt-loan.tranwspertip$ tt-loan.rewzim$ tt-loan.user-id
          tt-loan.loan-status tt-loan.close-date tt-loan.trade-sys
          tt-loan.comment tt-loan.prodkod$
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-loan-acct-cust THEN
    DISPLAY tt-loan-acct-cust.acct
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-loan-acct-main THEN
    DISPLAY tt-loan-acct-main.acct
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-loan-cond THEN
    DISPLAY tt-loan-cond.NDays tt-loan-cond.NMonthes tt-loan-cond.NYears
          tt-loan-cond.cred-period tt-loan-cond.cred-date
          tt-loan-cond.cred-month tt-loan-cond.cred-offset
          tt-loan-cond.kollw#gtper$ tt-loan-cond.cred-mode
          tt-loan-cond.cred-work-calend tt-loan-cond.cred-curr-next
          tt-loan-cond.delay1 tt-loan-cond.DateDelay tt-loan-cond.delay-offset
          tt-loan-cond.kredplat$ tt-loan-cond.annuitplat$
          tt-loan-cond.int-period tt-loan-cond.int-date tt-loan-cond.int-month
          tt-loan-cond.int-offset tt-loan-cond.kollw#gtperprc$
          tt-loan-cond.int-mode tt-loan-cond.int-work-calend
          tt-loan-cond.int-curr-next tt-loan-cond.delay
          tt-loan-cond.DateDelayInt tt-loan-cond.delay-offset-int
          tt-loan-cond.isklmes$ tt-loan-cond.disch-type tt-loan-cond.annuitkorr$
          tt-loan-cond.grperiod$
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-percent THEN
    DISPLAY tt-percent.amt-rub
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  ENABLE tt-loan-cond.NDays tt-loan-cond.NMonthes tt-loan-cond.NYears
         tt-loan-cond.cred-month tt-loan-cond.cred-offset cred-offset_
         tt-loan-cond.cred-mode tt-loan-cond.cred-work-calend
         tt-loan-cond.cred-curr-next tt-loan-cond.DateDelay
         tt-loan-cond.delay-offset delay-offset_ tt-loan-cond.kredplat$
         tt-loan-cond.int-month tt-loan-cond.int-offset int-offset_
         tt-loan-cond.kollw#gtperprc$ tt-loan-cond.int-work-calend
         tt-loan-cond.int-curr-next tt-loan-cond.DateDelayInt
         tt-loan-cond.delay-offset-int delay-offset-int_ tt-loan-cond.isklmes$
         mBag mSvod mLimit mLimitRest tt-loan-cond.grperiod$
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW TERMINAL-SIMULATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetTermObl TERMINAL-SIMULATION
PROCEDURE GetTermObl :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    FOR EACH ttTermObl:
        DELETE ttTermObl.
    END.

/* ������塞 �६����� ⠡���� - ������ ��� �᪫�祭�� � � �ᮡ� ०���� */
   FOR EACH term-obl WHERE
            term-obl.contract = tt-loan.contract
        AND term-obl.cont-code = tt-loan.cont-code
        AND term-obl.idnt >= 200
        AND term-obl.idnt <= 201
        AND term-obl.end-date = IF iMode = {&MOD_ADD}
                                   THEN tt-loan.open-date
                                   ELSE tt-loan-cond.since
       NO-LOCK:

       BUFFER-COPY term-obl TO ttTermObl.

       RELEASE ttTermObl.

   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LocalEnableDisable TERMINAL-SIMULATION
PROCEDURE LocalEnableDisable :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE BUFFER b-percent     FOR tt-percent.
DEFINE BUFFER xtt-comm-rate FOR tt-comm-rate.
DEFINE BUFFER bloan         FOR loan.
DEFINE BUFFER loan-cond     FOR loan-cond.

DEFINE VARIABLE vNextStream AS INT64    NO-UNDO.
DEFINE VARIABLE vPercent    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE vCount      AS INT64    NO-UNDO.
DEFINE VARIABLE vNum        AS CHARACTER  NO-UNDO. /* ���ᣥ���஢���� � ���. */
DEFINE VARIABLE vMeasure    AS CHARACTER  NO-UNDO. /* ����窠 ��� get-one-limit */
DEFINE VARIABLE vOperSumm   AS DECIMAL    NO-UNDO. /* ���祭�� ����� */
DEFINE VARIABLE hTrade-Sys  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hComment    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTSLabel    AS HANDLE     NO-UNDO.
DEFINE VARIABLE oAutoCodeNeed AS LOGICAL NO-UNDO . /* �㦭� �� ��� �ନ஢���� ����� ��-� ��������*/

   IF     mNewEndDate NE ?
      AND GetFstWrkDay(tt-loan.Class-Code, tt-loan.user-id, mNewEndDate, 9, 1) NE mNewEndDate 
   THEN
      mNewEndDate = ?.
   IF mNewEndDate NE ? 
   THEN DO:
      tt-loan.end-date:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = STRING (mNewEndDate,"99/99/9999").
      mSrokChange = YES.
   END.

   DISPLAY mTxtPercent WITH FRAME {&MAIN-FRAME} .

   IF tt-loan.contract = "�����" THEN
      ASSIGN
         mGrRiska    :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         mRisk       :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         mBag        :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
      .
   
   IF  tt-loan.class-code NE "loan_dbl_ann" AND
       (   FGetSetting("����㬎�","����⎡��","?") NE "��"
        OR tt-loan.class-code NE "loan_mortgage")  THEN
      tt-loan.sum-depos:VISIBLE IN FRAME {&MAIN-FRAME} = FALSE.

   IF  tt-loan.class-code NE "loan_dbl_ann" THEN
       ASSIGN
           tt-loan-cond.PartAmount:VISIBLE   IN FRAME {&MAIN-FRAME} = FALSE
           tt-loan-cond.FirstPeriod:VISIBLE IN FRAME {&MAIN-FRAME} = FALSE.
   
   IF tt-loan.contract = "�����" AND FGetSetting("������", "", ?) EQ "��" THEN
      ASSIGN
         mHiddenField                   :VISIBLE IN FRAME {&MAIN-FRAME} = TRUE
         tt-loan-cond.cred-period       :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         mNameCredPeriod                :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-date         :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-month        :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-offset       :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         cred-offset_                   :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.kollw#gtper$      :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-mode         :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-work-calend  :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.cred-curr-next    :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.delay1            :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.DateDelay         :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.delay-offset      :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         delay-offset_                  :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.kredplat$         :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.int-mode          :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.int-work-calend   :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.int-curr-next     :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.delay             :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.DateDelayInt      :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.delay-offset-int  :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         delay-offset-int_              :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan-cond.isklmes$          :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
         tt-loan.rewzim$                :VISIBLE IN FRAME {&MAIN-FRAME} = FALSE
      .
   ELSE
      mHiddenField:VISIBLE IN FRAME {&MAIN-FRAME} = FALSE.
      /* ��ନ஢���� ����� �祭�� */
   IF AVAIL tt-instance AND iMode EQ {&MOD_ADD} THEN
   DO:
      vNextStream = INT64(ENTRY(2,
         GetBuffersValue(
            "loan",
            "FOR EACH loan WHERE
                 loan.contract EQ '" + tt-instance.contract + "' AND
                 loan.cont-code BEGINS '" + tt-instance.cont-code + " ' AND
                 NUM-ENTRIES(loan.cont-code,' ') EQ 2 NO-LOCK BY INT64(ENTRY(2,loan.cont-code,' ')) DESC",
            "loan.cont-code"),
         " ")) NO-ERROR.

      vNextStream = IF vNextStream EQ ? THEN 1 ELSE vNextStream + 1.
      tt-loan.doc-ref   = ENTRY(1,tt-instance.doc-ref," ") + " " + STRING(vNextStream).
      IF ShMode THEN
         tt-loan.cont-code = addFilToLoan(tt-loan.doc-ref,ShFilial).
      ELSE
         tt-loan.cont-code = tt-loan.doc-ref.

      tt-loan.doc-ref:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = tt-loan.doc-ref.
      IF tt-loan.cust-cat:VISIBLE THEN ASSIGN
         tt-loan.cust-cat:SCREEN-VALUE = tt-instance.cust-cat.
      IF tt-loan.cust-id:VISIBLE THEN ASSIGN
         tt-loan.cust-id:SCREEN-VALUE = STRING(tt-instance.cust-id).
      APPLY "leave" TO tt-loan.cust-id.
      RUN BT_HiddOrDisableField(tt-loan.doc-ref:HANDLE,NO,YES).
      RUN BT_HiddOrDisableField(tt-loan.cust-cat:HANDLE,NO,YES).
      RUN BT_HiddOrDisableField(tt-loan.cust-id:HANDLE,NO,YES).
      tt-loan.cont-type:SCREEN-VALUE = GetxAttrValueEx("loan",
                                                       tt-instance.contract + "," + tt-instance.cont-code,
                                                       "����������",
                                                       "").
      IF tt-loan.cont-type:SCREEN-VALUE NE "" THEN
         RUN BT_HiddOrDisableField(tt-loan.cont-type:HANDLE,NO,YES).
      ASSIGN
         tt-loan.currency:SCREEN-VALUE = tt-instance.currency
         tt-loan.currency:SENSITIVE = NO
      .
   END.

      /* �᫨ ������� �� �࠭� ������� ⨯� "��祭��",
      ** � ����᪠�� ������ �ନ஢���� � ������� */

   IF     NOT AVAIL tt-instance
      AND iMode EQ {&MOD_ADD} THEN
   DO:
      /* �㦥� �� ⨯ ������� ��� �����樨 ��⮪��� ?*/
      RUN AutoCodeNeed IN h_loan (tt-loan.Class-Code,"t" , OUTPUT oAutoCodeNeed) .
      IF oAutoCodeNeed AND
         tt-loan.cont-type:SCREEN-VALUE = ""
      THEN
        APPLY "F1" TO tt-loan.cont-type. /* �᫨ �㦥� - ������� ��� */

      RUN GetNumLoan IN h_loan (tt-loan.Class-Code,
                                tt-loan.open-date,
                                SUBSTITUTE("&1|&2|&3|&4|&5" ,
                                             tt-loan.branch-id ,
                                             "","","" ,
                                             tt-loan.cont-type:SCREEN-VALUE ) , /* ��� 䨫����    � �� ����室��� ⥣�  */
                                NO,
                                OUTPUT vNum,
                                OUTPUT mCounterVal).
      tt-loan.doc-ref = vNum.
      ASSIGN
         tt-loan.cont-code = IF ShMode THEN addFilToLoan(vNum, ShFilial)
                                       ELSE vNum
         tt-loan.doc-ref:SCREEN-VALUE IN FRAME {&MAIN-FRAME} = vNum
      .
   END.


   IF mBrowseCommRateOFF THEN
   DO:
      RUN BT_HiddAndDisableField(tt-percent.amt-rub:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-period:HANDLE).
      RUN BT_HiddAndDisableField(mNameIntPeriod:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-date:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.delay:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-offset:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.disch-type:HANDLE).
      RUN BT_HiddAndDisableField(mNameDischType:HANDLE).
      RUN BT_HiddAndDisableField(int-offset_:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.kollw#gtperprc$:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-mode:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-work-calend:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.DateDelayInt:HANDLE).
      RUN BT_HiddAndDisableField(tt-loan-cond.int-curr-next:HANDLE).
      RUN BT_HiddAndDisableField(delay-offset-int_:HANDLE).
      RUN BT_HiddAndDisableField(tt-comm-cond.floattype:HANDLE IN BROWSE br-comm).
      IF br-comm:VISIBLE IN FRAME {&MAIN-FRAME} THEN
      DO:
         DISABLE br-comm WITH FRAME {&MAIN-FRAME}.
         br-comm:VISIBLE IN FRAME {&MAIN-FRAME} = NO.
         separator-2:VISIBLE IN FRAME {&MAIN-FRAME} = NO.
         RUN BT_UpForm(separator-3:HANDLE,3).
            /* TOGGLE-BOX� ��⮬ �� ������뢠����, ���⮬� ��㥬 ����� */
         IF tt-loan-cond.isklmes$:VISIBLE IN FRAME {&MAIN-FRAME} THEN
         DO:
            tt-loan-cond.isklmes$:VISIBLE IN FRAME {&MAIN-FRAME} = NO.
            tt-loan-cond.isklmes$:VISIBLE IN FRAME {&MAIN-FRAME} = YES.
         END.
         FRAME {&MAIN-FRAME}:HEIGHT = FRAME {&MAIN-FRAME}:HEIGHT - 3.
         RUN PutHelp("",FRAME {&MAIN-FRAME}:HANDLE).
      END.
   END.
   ELSE
   DO:
      ENABLE br-comm WITH FRAME {&MAIN-FRAME}.
      IF iMode EQ {&MOD_ADD} THEN
      DO:
         tt-comm-rate.commission:READ-ONLY IN BROWSE br-comm = NO.
         tt-comm-rate.rate-comm:READ-ONLY IN BROWSE br-comm = NO.
         tt-comm-cond.floattype:READ-ONLY IN BROWSE br-comm = YES.
      END.
      ELSE
         RUN ReadOnly(FRAME {&MAIN-FRAME}:HANDLE,"br-comm","br-comm",YES).
      /* �뭥�� � ������⥪� */
      FOR EACH term-obl OF tt-loan WHERE term-obl.idnt EQ 1 NO-LOCK:
         ACCUMULATE
            term-obl.amt-rub (TOTAL)
            term-obl.amt-rub (COUNT).
      END.
      vPercent = (ACCUM TOTAL term-obl.amt-rub).
      vCount = (ACCUM COUNT term-obl.amt-rub).
      IF vCount GT 1 AND tt-percent.amt-rub:VISIBLE THEN
      DO:
         DISP vPercent @ tt-percent.amt-rub
            WITH FRAME {&MAIN-FRAME}.
         DISABLE tt-percent.amt-rub WITH FRAME {&MAIN-FRAME}.
      END.
   END.
      /* ��� ����ᮢ loan-repo-bm,loan-repo-lm
   ** �㦭� ���� tt-loan.trade-sys, � ��� ������ ����� tt-loan.comment */
   IF CAN-DO("loan-repo-bm,loan-repo-lm", tt-loan.Class-code)
      AND tt-loan.trade-sys:VISIBLE
      AND tt-loan.comment:VISIBLE THEN
   DO:
      hTrade-Sys = tt-loan.trade-sys:HANDLE.
      hComment   = tt-loan.comment:HANDLE.
      hTSLabel   = hTrade-Sys:SIDE-LABEL-HANDLE.

      IF     hTrade-Sys:ROW EQ hComment:ROW
         AND hTrade-Sys:COL + hTrade-Sys:WIDTH GE hComment:COL THEN
      DO:
        /* ᤢ���� ���� tt-loan.comment ��ࠢ�, �� ᪮�쪮 �㦭�,
        ** �⮡� tt-loan.trade-sys �뫮 ����� */
         hComment:INNER-CHARS = hComment:INNER-CHARS - 
                               (hTrade-Sys:WIDTH + hTSLabel:WIDTH + 2).
         hComment:COL = (hTrade-Sys:COL + hTrade-Sys:WIDTH + 1). 
      END. 
   END.
   IF tt-loan-acct-main.acct:VISIBLE AND
      GetXattrEx(iClass,"loan-acct-main","xattr-label") NE "" THEN
      tt-loan-acct-main.acct:LABEL =
         GetXattrEx(iClass,"loan-acct-main","xattr-label").
   IF tt-loan-acct-cust.acct:VISIBLE AND
      GetXattrEx(iClass,"loan-acct-cust","xattr-label") NE "" THEN
      tt-loan-acct-cust.acct:LABEL =
         GetXattrEx(iClass,"loan-acct-cust","xattr-label").
   IF iMode = {&MOD_ADD}                      AND
      NOT IsEmpty  (tt-loan.parent-cont-code) THEN
   DO:
      DISABLE tt-loan.cust-cat tt-loan.cust-id WITH FRAME fMain.
   END.
   IF tt-loan.alt-contract EQ "mm" THEN
   DO:
      IF iMode NE {&MOD_ADD} THEN
         tt-loan.cont-type:SCREEN-VALUE = MM_GetContTypeStreem(tt-loan.contract,tt-loan.cont-code).
      tt-loan.doc-ref:VISIBLE = NO.
      IF tt-loan.doc-num:VISIBLE THEN ASSIGN
         tt-loan.doc-num:LABEL =
            tt-loan.doc-num:HANDLE:SIDE-LABEL-HANDLE:SCREEN-VALUE
         tt-loan.doc-num:SCREEN-VALUE = tt-loan.doc-num.
   END.
   ELSE
   DO:
      tt-loan.doc-num:VISIBLE = NO.
      IF tt-loan.doc-ref:VISIBLE THEN ASSIGN
         tt-loan.doc-ref:LABEL =
            tt-loan.doc-ref:HANDLE:SIDE-LABEL-HANDLE:SCREEN-VALUE
         tt-loan.doc-ref:SCREEN-VALUE = tt-loan.doc-ref.
   END.
   IF iMode = {&MOD_ADD} THEN
   DO:
      tt-loan-cond.annuitkorr$:SCREEN-VALUE =
         GetXAttrInit(tt-loan-cond.class-code,
                      "����⊮��").
      IF tt-loan-cond.annuitkorr$:SCREEN-VALUE = "" THEN
         tt-loan-cond.annuitkorr$:SCREEN-VALUE = ?.
   END.
   ELSE
      IF GetXAttrValueEx("loan-cond",
                         tt-loan-cond.contract + "," + tt-loan-cond.cont-code + "," + STRING(tt-loan-cond.since),
                         "����⊮��",
                         "") EQ "" THEN
         tt-loan-cond.annuitkorr$:SCREEN-VALUE = ?.
   IF tt-loan-cond.shemaplat$ THEN
   DO:
      IF iMode = {&MOD_ADD} THEN
      DO:
         /* ��⠭���� ���㣫����, �᫨ ��� ���� */
         IF GetXattrInit(tt-loan.class-code,"���㣄���") EQ "��" THEN
            RUN SetSysConf IN h_base ("���㣫�������㡫��","YES"). 

         FIND FIRST xtt-comm-rate WHERE
                    xtt-comm-rate.commission = "%�।"
         NO-ERROR.

         IF AVAIL xtt-comm-rate THEN
            RUN CalcAnnuitet(
                          tt-loan.contract,
                          tt-loan.cont-code,
                          DATE(tt-loan.open-date:SCREEN-VALUE),
                          DATE(tt-loan.end-date:SCREEN-VALUE),
                          tt-amount.amt-rub,
                          xtt-comm-rate.rate-comm,
                          INT64(tt-loan-cond.cred-date:SCREEN-VALUE),
                          tt-loan-cond.cred-period:SCREEN-VALUE,
                          tt-loan-cond.cred-month:SCREEN-VALUE,
                          INT64(tt-loan-cond.kollw#gtper$:SCREEN-VALUE),
                          LOOKUP(tt-loan-cond.cred-offset:SCREEN-VALUE,tt-loan-cond.cred-offset:LIST-ITEMS),
                          INT64(tt-loan-cond.annuitkorr$:SCREEN-VALUE),
                          DEC(tt-loan.sum-depos:SCREEN-VALUE),
                          INT64(tt-loan-cond.FirstPeriod:SCREEN-VALUE),
                          DEC(tt-loan-cond.PartAmount:SCREEN-VALUE),
                          OUTPUT tt-loan-cond.annuitplat$).
         IF    tt-loan.class-code EQ "loan-transh-ann"
            OR tt-loan.class-code EQ "loan-transh-lin-ann" THEN
            tt-loan-cond.annuitplat$ = ?.
         tt-loan-cond.annuitplat$:SCREEN-VALUE = STRING(tt-loan-cond.annuitplat$).
      END.
   END.
   ELSE
      tt-loan-cond.annuitkorr$:VISIBLE = NO.

   IF tt-loan-cond.isklmes$:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "yes"
      THEN DO:
      RUN GetTermObl.
   END.

   IF FGetSetting("�����⨥","","?") EQ "���" THEN
      tt-loan.close-date:SENSITIVE = NO.

   /* �����塞 ������ ���� � ����ᨬ��� �� ���祭�� cred-mode (����. ��ਮ� - ��.����) */
   CASE tt-loan-cond.cred-mode:SCREEN-VALUE:
      WHEN "����焭��" THEN
         ASSIGN
            tt-loan-cond.DateDelay        :VISIBLE = NO
            tt-loan-cond.cred-curr-next   :VISIBLE = NO
         .
      WHEN "��⠎����" THEN
         ASSIGN
            tt-loan-cond.delay1           :VISIBLE = NO
            tt-loan-cond.cred-work-calend :VISIBLE = NO
         .
      WHEN "��ਮ���" THEN
         ASSIGN
            tt-loan-cond.DateDelay        :VISIBLE = NO
            tt-loan-cond.cred-curr-next   :VISIBLE = NO
            tt-loan-cond.cred-work-calend :VISIBLE = NO
         .
   END CASE.
   /* �����塞 ������ ���� � ����ᨬ��� �� ���祭�� int-mode (����. ��ਮ� - ��業��) */
   IF tt-loan-cond.int-mode:SCREEN-VALUE  EQ "����焭��"
   THEN ASSIGN tt-loan-cond.DateDelayint     :VISIBLE = NO
               tt-loan-cond.int-curr-next    :VISIBLE = NO.
   ELSE ASSIGN tt-loan-cond.delay            :VISIBLE = NO
               tt-loan-cond.int-work-calend  :VISIBLE = NO.
   ASSIGN
      cred-offset_            :SCREEN-VALUE  =  IF NOT {assigned tt-loan-cond.cred-offset}
                                       THEN mOffsetNone
                                       ELSE tt-loan-cond.cred-offset:SCREEN-VALUE
      int-offset_             :SCREEN-VALUE  =  IF NOT {assigned  tt-loan-cond.int-offset}
                                       THEN mOffsetNone
                                       ELSE tt-loan-cond.int-offset:SCREEN-VALUE
      delay-offset_           :SCREEN-VALUE  =  IF NOT {assigned  tt-loan-cond.delay-offset}
                                       THEN mOffsetNone
                                       ELSE tt-loan-cond.delay-offset:SCREEN-VALUE
      delay-offset-int_       :SCREEN-VALUE  =  IF NOT {assigned  tt-loan-cond.delay-offset-int}
                                       THEN mOffsetNone
                                       ELSE tt-loan-cond.delay-offset-int:SCREEN-VALUE
      cred-offset_            :READ-ONLY     = YES
      int-offset_             :READ-ONLY     = YES
      delay-offset_           :READ-ONLY     = YES
      delay-offset-int_       :READ-ONLY     = YES
      tt-loan-cond.cred-offset     :VISIBLE       = NO
      tt-loan-cond.int-offset      :VISIBLE       = NO
      tt-loan-cond.delay-offset    :VISIBLE       = NO
      tt-loan-cond.delay-offset-int:VISIBLE       = NO.
   IF iMode NE {&MOD_ADD}
   THEN
      ASSIGN
         cred-offset_          :SENSITIVE = NO
         int-offset_           :SENSITIVE = NO
         delay-offset_         :SENSITIVE = NO
         delay-offset-int_     :SENSITIVE = NO
      .
/* � ᯥ梥���� Multi, Etb � �⮬ ���� �⮨� FGetSetting("�ᯏத","",?),
** �㦭� ��ࠢ��� �� FGetSetting("�த���","�ᯏத",?) */

   /* �᫨ ।���஢����, � ����뢠�� ���� */
   IF iMode = {&MOD_EDIT} THEN
      ASSIGN
         tt-loan-cond.NDays   :SENSITIVE = NO
         tt-loan-cond.NMonthes:SENSITIVE = NO
         tt-loan-cond.NYears  :SENSITIVE = NO
      .
   IF work-module EQ "loan-fiz"
   THEN
      ASSIGN
         tt-loan.cust-cat :LIST-ITEMS   = "�"
         tt-loan.cust-cat :SCREEN-VALUE = "�"
         tt-loan.cust-cat :SENSITIVE    = NO
         tt-loan.cust-cat
      .
   ELSE IF work-module EQ "loan-jur"
   THEN
      ASSIGN
         tt-loan.cust-cat :LIST-ITEMS   = "�,�"
         tt-loan.cust-cat :SCREEN-VALUE = "�"
         tt-loan.cust-cat
      .
&IF DEFINED(MANUAL-REMOTE) &THEN
   tt-loan.ovrstopr$ :LIST-ITEMS = "�,�" . 
   IF tt-loan.ovrstopr$ NE ? THEN tt-loan.ovrstopr$:SCREEN-VALUE = tt-loan.ovrstopr$ .
&ENDIF 

    /* ������ �뤠� */
   IF   ( iMode EQ {&MOD_EDIT}
      OR  iMode EQ {&MOD_VIEW} )
     AND ( tt-loan.rewzim$:SCREEN-VALUE EQ "����뤇��" OR
           tt-loan.rewzim$:SCREEN-VALUE EQ "����������" )THEN
   DO:
      /* ����稬 ��⠭������� ����� */
      RUN get-one-limit ("loan",
                         tt-loan.contract + "," + tt-loan.cont-code,
                         "limit-l-distr",
                         tt-loan.since ,
                         "",
                         OUTPUT vMeasure,
                         OUTPUT mLimit).
      mLimit:SCREEN-VALUE = STRING(mLimit).

      /* ������ ���㬬��㥬 �� ����樨 �뤠�, � �.�. �� �࠭蠬
      ** � ���⥬ �� �� ����� - ����稬 ��⠢訩�� ����� */
      FOR EACH loan-int WHERE loan-int.contract  EQ tt-loan.contract
                          AND loan-int.cont-code EQ tt-loan.cont-code
                          AND loan-int.id-d      EQ 0
                          AND loan-int.id-k      EQ 3
                          AND loan-int.mdate     LE tt-loan.since
      NO-LOCK:
         vOperSumm = vOperSumm + loan-int.amt-rub.
      END.
      IF tt-loan.cont-type EQ "��祭��" THEN
         FOR EACH loan-int WHERE loan-int.contract  EQ     tt-loan.contract
                             AND loan-int.cont-code BEGINS tt-loan.cont-code + " "
                             AND loan-int.id-d      EQ     0
                             AND loan-int.id-k      EQ     3
                             AND loan-int.mdate     LE     tt-loan.since
         NO-LOCK:
            vOperSumm = vOperSumm + loan-int.amt-rub.
         END.
      ASSIGN
         mLimitRest              = mLimit - vOperSumm
         mLimitRest:SCREEN-VALUE = STRING(mLimitRest).
   END.
   /* ����� ������������ */
   IF   ( iMode EQ {&MOD_EDIT}
      OR  iMode EQ {&MOD_VIEW})
     AND tt-loan.rewzim$:SCREEN-VALUE EQ "�����������" THEN
   DO:
      /* ����稬 ��⠭������� ����� �� ���� ���ﭨ�  */
      RUN get-one-limit-loan ("loan",
                              tt-loan.contract + "," + tt-loan.cont-code,
                              "limit-l-debts",
                              tt-loan.since ,
                              "",
                              OUTPUT vMeasure,
                              OUTPUT mLimit).

      /* ����㯭� ����� �� ��ࠬ��� 19 - ���ᯮ�짮����� ������ �।�⢠  */
      RUN STNDRT_PARAM (tt-loan.contract,
                        tt-loan.cont-code,
                        19,
                        tt-loan.since,
                        OUTPUT mLimitRest,
                        OUTPUT md1,
                        OUTPUT md2).

      ASSIGN
         mLimit:SCREEN-VALUE = STRING(mLimit)
         mLimitRest:SCREEN-VALUE = STRING(mLimitRest).
   END.



   IF NOT (   tt-loan.rewzim$:SCREEN-VALUE EQ "����뤇��"
           OR tt-loan.rewzim$:SCREEN-VALUE EQ "�����������"
           OR tt-loan.rewzim$:SCREEN-VALUE EQ "����������") THEN
      ASSIGN
         mLimit:VISIBLE IN FRAME fMain     = NO
         mLimitRest:VISIBLE IN FRAME fMain = NO
      .

   IF NOT tt-loan.svodform$ THEN
   DO:
      RUN BT_HiddAndDisableField(mSvod:HANDLE).
      separator-3:VISIBLE IN FRAME {&MAIN-FRAME} = YES.
   END.
   ELSE
      mSvodROnly =     iMode NE {&MOD_ADD}
                   AND CAN-FIND(FIRST bloan WHERE
                                      bloan.contract                    EQ     tt-loan.contract
                                  AND bloan.cont-code                   BEGINS tt-loan.cont-code + " "
                                  AND NUM-ENTRIES(bloan.cont-code, " ") GT 1
                                )
                   OR (   tt-loan.class-code EQ "loan-transh-ann"
                       OR tt-loan.class-code EQ "loan-tran-lin-ann")
      .

      /* �����뢠��, �᫨ ।���஢����, ��� ��ᬮ��
      ** � ��⠭����� ���⥦�� ��ਮ� = ��ਮ��� */
   IF iMode NE {&MOD_ADD} AND tt-loan-cond.cred-mode EQ "��ਮ���" AND tt-loan-cond.shemaplat$ NE YES THEN
   DO:
         /* TOGGLE-BOX� ��⮬ �� ������뢠����, ���⮬� ��㥬 ����� */
      tt-loan-cond.grperiod$:VISIBLE IN FRAME {&MAIN-FRAME} = NO.
      tt-loan-cond.grperiod$:VISIBLE IN FRAME {&MAIN-FRAME} = YES.
   END.
   ELSE
      tt-loan-cond.grperiod$:VISIBLE = NO.
/*====*/
   ii = ii + 1 .
   IF ii LE 1 THEN DO:
      SetHelpStrAdd(mHelpStrAdd + "�F6-��ਮ� ����㯭��� �।��").
      RUN PutHelp("",FRAME {&MAIN-FRAME}:HANDLE).
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LocalSetObject TERMINAL-SIMULATION
PROCEDURE LocalSetObject :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEFINE VARIABLE vRet   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vRwd   AS ROWID      NO-UNDO.
   DEFINE VARIABLE vId    AS INT64      NO-UNDO.
   DEFINE VARIABLE vHs    AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vSum   AS DEC        NO-UNDO.
   DEFINE VARIABLE vHT    AS HANDLE     NO-UNDO.

   DEFINE VARIABLE vHRisk    AS HANDLE   NO-UNDO.
   DEFINE VARIABLE vHGrRiska AS HANDLE   NO-UNDO.
   DEFINE VARIABLE vCheckMon AS LOG      NO-UNDO.
   DEFINE VARIABLE vOk       AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE vFL       AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE VoKs      AS LOGICAL  NO-UNDO.

   DEF BUFFER xloan      FOR loan.
   DEF BUFFER xcomm-rate FOR comm-rate.

   /* �㬬� �� �������� */
   mSummaDog = tt-amount.amt-rub.
   /* ��� ⮣�, �⮡� ��࠭��� �� �६����� ⠡���� ���祭�� ४����⮢,
   ** �� ��ꥪ⠬� ���ﬨ, �㦭� �������� �� � ᯨ᮪ ᫥�. ��ࠧ�� : */
   SetFormDefList(GetFormDefList() +
                  ",tt-loan-cond.cred-offset,tt-loan-cond.int-offset" +
                  ",tt-loan-cond.delay-offset,tt-loan-cond.delay-offset-int" +
                  ",tt-loan.AgrCounter,tt-loan.UniformBag,tt-loan.prodkod$,tt-loan-cond.prodtrf$" +
                  ",tt-loan.svodgrafik$,tt-loan.svodskonca$,tt-loan.svodgravto$,tt-loan.svodspostr$" +
                  ",tt-loan.LimitGrafDate,tt-loan-cond.grdatas$,tt-loan-cond.grdatapo$").
      /* �஢�ઠ ��⠏� ����⮢ */
      IF tt-loan.rewzim$ NE ? AND
         tt-loan.rewzim$ NE ""  AND
         tt-loan.LimitGrafDate EQ ?
      THEN DO:
         tt-loan.LimitGrafDate = tt-loan.end-date .
      END.
      IF tt-loan.rewzim$ EQ ? OR
         tt-loan.rewzim$ EQ ""
      THEN DO:
         tt-loan.LimitGrafDate = ? .
      END.
      IF tt-loan.rewzim$ NE ? AND
         tt-loan.rewzim$ NE ""  AND
         tt-loan.LimitGrafDate NE  tt-loan.end-date
      THEN DO:
             RUN LimitChangeDatePo IN h_limit( "",
            tt-loan.contract  ,
            tt-loan.cont-code ,
            tt-loan.End-date  ,
            INPUT-OUTPUT tt-loan.LimitGrafDate
            ) NO-ERROR .
         IF ERROR-STATUS :ERROR THEN
            RETURN ERROR RETURN-VALUE .
      END.  /* tt-loan.LimitGrafDate NE  tt-loan.end-date */

      /* �஢�ઠ �� ����������� ��⮬���᪮� ࠧ��᪨ ᢮����� ��䨪� */
   RUN CheckAutoTermDistrTT (tt-loan.contract,     /* �����祭�� ������� */
                             tt-loan.cont-code,    /* ����� ������� */
                             OUTPUT vCheckMon).    /* ������� */
   IF NOT vCheckMon THEN
   DO:
      ASSIGN
         mRetVal = {&RET-ERROR}
         vRet    = RETURN-VALUE
      .
      RETURN ERROR "�஢�ઠ �� ����������� ��⮬���᪮� ࠧ��᪨ ��䨪� �� �ன����".
   END.

   IF iMode = {&MOD_ADD} THEN
   DO:
      vHRisk = GetProperty(mInstance,"risk","").

      IF VALID-HANDLE(vHRisk) THEN
         vHRisk:PRIVATE-DATA = {&FORM-DEF} NO-ERROR.

      vHGrRiska = GetProperty(mInstance,"gr-riska","").

      IF VALID-HANDLE(vHGrRiska) THEN
         vHGrRiska:PRIVATE-DATA = {&FORM-DEF} NO-ERROR.

      ASSIGN
         tt-loan.risk = DECIMAL(mRisk:SCREEN-VALUE IN FRAME {&frame-name})
         tt-loan.gr-riska = INT64(mGrRiska:SCREEN-VALUE IN FRAME {&frame-name})
      .
   END.

   IF tt-loan-cond.shemaplat$ THEN
   DO WITH FRAME {&MAIN-FRAME}:
      vHs = GetProperty(mInstance,"loan-cond","").
      IF VALID-HANDLE(vHs) THEN
         ASSIGN
            vHs  = vHs:BUFFER-VALUE
            vHs  = vHs:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("shemaplat$")
            .
      IF VALID-HANDLE(vHs) THEN
         vHs:PRIVATE-DATA = {&FORM-DEF} NO-ERROR.
      ASSIGN
         tt-loan-cond.int-period  = tt-loan-cond.cred-period
         tt-loan-cond.int-month   = tt-loan-cond.cred-month
         tt-loan-cond.int-date    = tt-loan-cond.cred-date
         tt-loan-cond.delay       = tt-loan-cond.delay1
         tt-loan-cond.int-offset  = tt-loan-cond.cred-offset
         tt-loan-cond.end-date    = tt-loan.end-date
         .
      IF iMode = {&MOD_ADD} THEN
      DO:
         vHs = GetProperty(mInstance,"loan-cond","").

         IF VALID-HANDLE(vHs) THEN
            ASSIGN
               vHs = vHs:BUFFER-VALUE
               vHs = vHs:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("end-date")
               .
         IF VALID-HANDLE(vHs) THEN
            vHs:PRIVATE-DATA = {&FORM-DEF} NO-ERROR.
      END.

      FIND FIRST b-comm-rate WHERE
                 b-comm-rate.commission = "%�।"
      NO-ERROR.
      IF tt-loan.class-code EQ "loan-tran-lin-ann" THEN
      DO:
         FIND FIRST xloan WHERE xloan.contract  EQ tt-loan.contract
                            AND xloan.cont-code EQ ENTRY(1,tt-loan.cont-code," ")
         NO-LOCK NO-ERROR.
         IF AVAIL xloan THEN
            FIND LAST  xcomm-rate WHERE
                       xcomm-rate.commission EQ "%�।"
                   AND xcomm-rate.acct       EQ "0"
                   AND xcomm-rate.kau        EQ xloan.contract + "," + xloan.cont-code
                   AND xcomm-rate.since      LE tt-loan-cond.since
            NO-LOCK NO-ERROR.
       END.
      /* �᫨ �� ��������� �����, � �� ����� ������ �� ����� ���� ��⠭����� ����
      ** �������, ���� �஫����஢��� ���� ����砭�� �������.
      ** � �� ��砥, ���� ������ ������ �� ���� ��᫥����� �᫮��� �� ����
      ** ����砭�� �������. �᫨ �� ��२᪨���� xxloan-cond � tt-amount,
      ** � �� ��������� 祣� ���� � ����窥 �������, ���� �㤥� ������
      ** �� ���� ��砫� ������� �� ���� ᫥���饣� �᫮���, �� �� ��୮,
      ** ���⬮� ��२᪨���� �㦭� ���� */
      IF iMode EQ {&MOD_EDIT} THEN
      DO:
         FIND LAST xxloan-cond WHERE xxloan-cond.contract  EQ tt-loan.contract
                                 AND xxloan-cond.cont-code EQ tt-loan.cont-code
                                 AND xxloan-cond.since     LE DATE(tt-loan.end-date:SCREEN-VALUE)
         NO-LOCK NO-ERROR.
         FIND FIRST tt-amount WHERE tt-amount.contract  EQ tt-loan.contract
                                AND tt-amount.cont-code EQ tt-loan.cont-code
                                AND tt-amount.idnt      EQ 2
                                AND tt-amount.end-date  LE xxloan-cond.since
         NO-LOCK NO-ERROR.
      END.

      RUN CalcAnnuitet(
                       tt-loan.contract,
                       tt-loan.cont-code,
                       IF iMode EQ {&MOD_EDIT} THEN xxloan-cond.since
                                               ELSE DATE(tt-loan.open-date:SCREEN-VALUE),
                       DATE(tt-loan.end-date:SCREEN-VALUE),
                       tt-amount.amt-rub,
                       (IF AVAIL xcomm-rate THEN xcomm-rate.rate-comm ELSE IF AVAIL b-comm-rate THEN b-comm-rate.rate-comm ELSE 0),
                       INT64(tt-loan-cond.cred-date:SCREEN-VALUE),
                       tt-loan-cond.cred-period:SCREEN-VALUE,
                       tt-loan-cond.cred-month:SCREEN-VALUE,
                       INT64(tt-loan-cond.kollw#gtper$:SCREEN-VALUE),
                       LOOKUP(tt-loan-cond.cred-offset:SCREEN-VALUE,tt-loan-cond.cred-offset:LIST-ITEMS),
                       INT64(tt-loan-cond.annuitkorr$:SCREEN-VALUE),
                       DEC(tt-loan.sum-depos:SCREEN-VALUE),
                       INT64(tt-loan-cond.FirstPeriod:SCREEN-VALUE),
                       DEC(tt-loan-cond.PartAmount:SCREEN-VALUE),
                       OUTPUT vSum).
     IF RETURN-VALUE <> "" THEN
     DO:
        ASSIGN
           mRetVal = {&RET-ERROR}
           vRet    = RETURN-VALUE
           .
        RETURN ERROR vRet.
     END.

         /* �஢�ઠ ��࠭�祭�� �� �ப� ������, ����� ��� ⮫쪮 ���
         ** ����� "loan_mortgage", ��� ��㣨� ����ᮢ �ய�᪠���� */
      IF    AVAIL b-comm-rate
         OR AVAIL xcomm-rate THEN
      DO:
         RUN CheckTermLimit(tt-loan.Class-Code,
                            DATE(tt-loan.open-date:SCREEN-VALUE),
                            DATE(tt-loan.end-date:SCREEN-VALUE),
                            (IF AVAIL xcomm-rate THEN xcomm-rate.rate-comm ELSE b-comm-rate.rate-comm),
                            OUTPUT vCheckMon,
                            OUTPUT mRetVal
                            ).
         IF vCheckMon THEN
            RETURN ERROR mRetVal.
         ELSE IF mRetVal NE "" THEN
            RUN Fill-SysMes IN h_tmess ("", "", "", mRetVal).
      END.
   END.

   IF br-comm:VISIBLE AND NOT mBrowseCommRateOFF THEN
   DO:
      FOR EACH b-comm-rate WHERE b-comm-rate.since EQ tt-loan-cond.since BY Local__ID:
         IF iMode EQ {&MOD_ADD} THEN
         DO:
            mChangedField = IF mHandCalcAnnuitet THEN NO ELSE mChangedField.
            {loan-trg.pro
               &CheckCommRate  = YES
               &LogVarChanged  = mChangedField
               &tt-loan        = tt-loan
               &tt-loan-cond   = tt-loan-cond
               &tt-comm-rate   = tt-comm-rate
               &tt-amount      = tt-term-amt
               &br-comm        = br-comm
            }
            b-comm-rate.currency = tt-loan.currency.
            vId = b-comm-rate.local__id + 1.
         END.
      END.
   END.
   tt-loan-cond.user__mode =
      IF BT_CAN-TABLE("tt-loan-cond","visible",OUTPUT vHT) THEN
         {&MOD_EDIT}
         ELSE
            {&MOD_DELETE}.
   IF iMode EQ {&MOD_ADD} THEN
   DO:
      tt-loan.since = tt-loan.open-date.
      tt-loan-cond.since = tt-loan.open-date.
      tt-loan-cond.contract = tt-loan.contract.
      IF tt-loan.cont-code EQ "" THEN
         tt-loan.cont-code = ?.

      IF tt-loan.doc-ref EQ "" THEN
         tt-loan.doc-ref = ?.

      IF tt-amount.amt-rub NE 0 THEN ASSIGN
         tt-amount.fop-date = tt-loan.open-date
         tt-amount.end-date = tt-loan.open-date.
      IF tt-percent.amt-rub NE 0 THEN ASSIGN
         tt-percent.fop-date = tt-loan.open-date
         tt-percent.end-date = tt-loan.end-date.

      IF {assigned tt-loan-acct-main.acct} THEN
      DO:
         IF shMode THEN
         DO: /* tt-loan-acct-main.acct ����� ���� ��� @ */
            FIND FIRST acct WHERE acct.filial-id EQ tt-loan.filial-id
                              AND acct.number    EQ ENTRY(1, tt-loan-acct-main.acct, "@")
                              AND acct.currency  EQ tt-loan.currency
               NO-LOCK NO-ERROR.
            IF AVAIL acct THEN
            DO:
               IF tt-loan-acct-main.acct NE acct.acct THEN
                  tt-loan-acct-main.acct = acct.acct.
            END.
         END.
         ASSIGN
            tt-loan-acct-main.currency = tt-loan.currency
            tt-loan-acct-main.since = tt-loan.open-date
         .
      END.
      IF {assigned tt-loan-acct-cust.acct} THEN
      DO:
         IF shMode THEN
         DO: /* tt-loan-acct-cust.acct ����� ���� ��� @ */
            FIND FIRST acct WHERE acct.filial-id EQ tt-loan.filial-id
                              AND acct.number    EQ ENTRY(1, tt-loan-acct-cust.acct, "@")
                              AND acct.currency  EQ tt-loan.currency
               NO-LOCK NO-ERROR.
            IF AVAIL acct THEN
            DO:
               IF tt-loan-acct-cust.acct NE acct.acct THEN
                  tt-loan-acct-cust.acct = acct.acct.
            END.
         END.
         ASSIGN
            tt-loan-acct-cust.currency = tt-loan.currency
            tt-loan-acct-cust.since = tt-loan.open-date
         .
      END.
   END.

   IF tt-loan.alt-contract EQ "mm" THEN
   DO:
      {f-fx.trg
         &CHECK-AGREEMENT=YES
         &BASE-TABLE=tt-loan
      }
      IF iMode EQ {&MOD_ADD} THEN /* ᮧ����� �祭�� */
      DO:
         RUN CreLoanStream(vId) NO-ERROR.
         IF ERROR-STATUS:ERROR THEN
         DO:
            mRetVal = {&RET-ERROR}.
            RETURN ERROR RETURN-VALUE.
         END.
      END.
      ELSE
      DO:
         RUN MM_SetContTypeStreem IN h_mm(tt-loan.contract,tt-loan.cont-code,tt-loan.cont-type).
         tt-loan.cont-type = "��祭��".
      END.
   END.

   RUN SetTermObl.

    /* �᫨ � ������� �࠭� ���� ������⥫�� ४����� UnformBag,
        � �।������ ��� �������� � �祭�� */
   IF iMode EQ {&MOD_ADD} AND AVAIL tt-instance THEN
   DO:
      mUniformBag = GetXAttrValueEx("loan", tt-instance.contract + "," + tt-instance.cont-code, "UniformBag", "").
      IF tt-instance.cont-type EQ "��祭��" AND mUniformBag NE "" THEN
      DO:
         pick-value ="".
         RUN Fill-SysMes IN h_tmess ("","","4", "�� �墠�뢠�饬 ������� ��⠭����� �� UniformBag � ���祭�� " + mUniformBag + ". ��⠭����� ����� ४����� �� �祭��?").
         IF pick-value EQ "YES" THEN /* YES */
            tt-loan.UniformBag = mUniformBag.
      END.
   END.

      /* ���࠭塞 ���祭�� ���稪� � �� ������� "AgrCounter" */
   IF mCounterVal GT 0 THEN
   DO:
     IF NOT UpdateSigns("loan",
                         tt-loan.contract + "," + tt-loan.cont-code,
                         "AgrCounter",
                         STRING(mCounterVal),
                         NO) THEN
         RUN Fill-SysMes IN h_tmess ("","","", "�訡�� ��࠭���� �� AgrCounter").
      ELSE
         tt-loan.AgrCounter = STRING(mCounterVal).
   END.

   /* ��ࠡ�⪠ ����⮢ �� ����稨 �����ᨨ "%�����" */
   FIND FIRST tt-comm-rate WHERE
              tt-comm-rate.commission EQ "%�����"
   NO-ERROR.
   IF     AVAIL tt-comm-rate
   THEN DO:
      IF NOT {assigned tt-loan.rewzim$} THEN
         ASSIGN
            tt-loan.rewzim$:SCREEN-VALUE = "�����������"
            tt-loan.rewzim$
         .
      IF tt-loan.rewzim$ NE "�����������"
      THEN DO:
         IF  tt-loan.rewzim$ = ? OR tt-loan.rewzim$ = ""
         THEN
            ASSIGN
            tt-loan.rewzim$:SCREEN-VALUE = "�����������"
            tt-loan.rewzim$              = "�����������"
            .
         ELSE DO:
            RUN Fill-SysMes IN h_tmess ("", "", "", "�⠢�� �������쭮�� ����襭�� �� ��ࠡ��뢠���� � ०��� �����������").
            RETURN ERROR "�⠢�� �������쭮�� ����襭�� �� ��ࠡ��뢠���� � ०��� �����������".
         END.
      END.
      ELSE DO:
         /* ���࠭���� ����⮢ */
         IF (mLimit EQ ? OR mLimit EQ 0)
         THEN DO:
            mLimit = tt-amount.amt-rub.
            RUN SaveLoanLimit (tt-loan.contract,tt-loan.cont-code,tt-loan.open-date,tt-loan.currency,"limit-l-debts",mLimit,OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","�������� �訡�� �� ��࠭���� ����� ������������. ����� �� ��࠭��.").
         END.
      END.
   END.

   /* ���� */
   IF tt-loan.cont-type NE "��祭��" THEN
      ASSIGN
         tt-loan.svodgrafik$ = IF tt-loan.svodgrafik$ EQ NO THEN ? ELSE tt-loan.svodgrafik$
         tt-loan.svodskonca$ = IF tt-loan.svodskonca$ EQ NO THEN ? ELSE tt-loan.svodskonca$
         tt-loan.svodgravto$ = IF tt-loan.svodgravto$ EQ NO THEN ? ELSE tt-loan.svodgravto$
         tt-loan.svodspostr$ = IF tt-loan.svodspostr$ EQ NO THEN ? ELSE tt-loan.svodspostr$
      .
      /* ��� �⠢��, ����� �뫨 ᮧ���� ��� ���४⭮�� �⮡ࠦ���� � ��㧥�
      br-comm, ��⠭�������� �ਧ��� 㤠����� */
   IF iMode NE {&MOD_ADD} THEN
      FOR EACH tt-comm-rate WHERE tt-comm-rate.local__template EQ YES:
          tt-comm-rate.user__mode = {&MOD_DELETE}.
      END.
      /* ��� tt-comm-cond �஢�ઠ local__template �� �ॡ����, �.�.
      ** ������������ ॠ�쭮� ��������� �⠢�� */
   FOR EACH tt-comm-cond:
         /* ��� ࠡ��ᯮᮡ���� ��࠭���� �������� �⠢��
         ** ����室��� �������� tt-comm-cond.since
         ** ⠪ �� ��� � ᤥ���� ��� � tt-loan-cond.since */
         /* �饬 �।����� �⠢��, �⫨��� �� ⥪�饩 */
      FIND LAST comm-cond WHERE
                comm-cond.contract   EQ tt-comm-cond.contract
            AND comm-cond.cont-code  EQ tt-comm-cond.cont-code
            AND comm-cond.commission EQ tt-comm-cond.commission
            AND comm-cond.since      LE tt-comm-cond.since
      NO-LOCK NO-ERROR.
      IF AVAIL comm-cond THEN
      DO:
         IF comm-cond.since EQ tt-comm-cond.since
         THEN
            tt-comm-cond.local__rowid = ROWID(comm-cond).
         ELSE IF    comm-cond.FloatType EQ tt-comm-cond.FloatType
                 OR comm-cond.Action    EQ tt-comm-cond.Action
                   /* ����� ����室��� ����᫨�� �� ����
                   ** �������� � ��������� �� ���������
                   ** ������ �᫮��� */
         THEN
               /* �ਧ��� 㤠����� �� ��࠭���� */
            tt-comm-cond.user__mode = {&MOD_DELETE}.
      END.
      ELSE
         IF NOT tt-comm-cond.FloatType THEN
            tt-comm-cond.user__mode = {&MOD_DELETE}.
   END.
      /* ��। ������� ������塞 �裡 � ��ॣ����騬� ��ꥪ⠬� */

IF NOT AVAIL tt-loan-cond THEN
      FIND FIRST tt-loan-cond NO-ERROR.

   FOR EACH tt-comm-cond WHERE tt-comm-cond.user__mode NE {&MOD_DELETE}:

      IF AVAIL tt-loan-cond THEN
         tt-comm-cond.local__UpId = tt-loan-cond.local__Id.
      ELSE
            /* �᫨ �� ��諨 ���室�饣� �᫮���, � �� ��࠭塞 �⠢�� */
         tt-comm-cond.user__mode = {&MOD_DELETE}.
   END.

   IF iMode EQ {&MOD_ADD} THEN
      FOR FIRST tt-comm-rate WHERE 
                tt-comm-rate.rate-comm EQ ? 
      NO-LOCK:
         RUN Fill-SysMes IN h_tmess ("","","0",
                                     "�� ������ ���祭�� ��業⮩ �⠢�� " + 
                                     tt-comm-rate.commission).
         RETURN ERROR.
      END.  
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Local_F9 TERMINAL-SIMULATION
PROCEDURE Local_F9:
                  /* �஢�ઠ �ࠢ �� ।���஢���� ������� ���稭������ */
   IF     USERID("bisquit") NE tt-loan.user-id
      AND NOT GetSlavePermission(USERID("bisquit"),tt-loan.user-id,"w")
   THEN RETURN ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PostGetObject TERMINAL-SIMULATION
PROCEDURE PostGetObject :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEFINE VARIABLE vCustCat      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vCustID       AS INT64    NO-UNDO.
   DEFINE VARIABLE vH            AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vAcctTypeList AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vAcctType     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vAcct         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vProd         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vOk           AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE vInstCond     AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vBuffCond     AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vProdPogOD    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vProdPogPr    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vProdType     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vDR           AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vValDR        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vI            AS INT64      NO-UNDO.
   DEFINE VARIABLE vLstDR        AS CHAR       NO-UNDO. /*ᯨ᮪ ��᫥�㥬�� ��*/
   DEFINE VARIABLE vLoan         AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vBufField     AS HANDLE     NO-UNDO. 

   DEF BUFFER bPos       FOR loan.      /* ���������� ����. */
   DEF BUFFER bterm-obl  FOR term-obl.  /* ���������� ����. */

   IF     AVAIL tt-Instance
      AND iMode EQ {&MOD_ADD} THEN
      IF tt-Instance.cont-type EQ "��祭��" THEN 
      DO:
         vLstDR =  GetXAttrInit(tt-Instance.class-code, "���፠᫄�").
         vLoan = BUFFER tt-loan:HANDLE.
         DO vI = 1 TO NUM-ENTRIES(vLstDR):
            vDR  =  ENTRY(vI,vLstDR).
            vValDr  = GetXAttrValueEx("loan", tt-Instance.contract + "," + tt-Instance.cont-code, vDR,"").
            vBufField = vLoan:BUFFER-FIELD(GetMangLedName(vDR)) NO-ERROR.
            IF vBufField EQ ? THEN
               {additem.i mLstDR vDR}
            ELSE
               CASE vBufField:DATA-TYPE:
                  WHEN "int64"   THEN vBufField:BUFFER-VALUE = INT64(vValDr).
                  WHEN "date"    THEN vBufField:BUFFER-VALUE = DATE(vValDr).
                  WHEN "decimal" THEN vBufField:BUFFER-VALUE = DEC(vValDr).
                  OTHERWISE           vBufField:BUFFER-VALUE = vValDr.
               END CASE.
         END.
      END.

         /* �஢�ઠ �ࠢ ����㯠 � ���ଠ樨 ������-�������� ������� */
   IF    (iMode EQ {&MOD_EDIT}
      OR  iMode EQ {&MOD_VIEW})
      AND tt-loan.cust-cat EQ "�"
      AND NOT GetPersonPermission(tt-loan.cust-id)
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "ap16", "", "%s=" + STRING(tt-loan.cust-id)).
      RETURN ERROR.
   END.

   IF    iMode EQ {&MOD_EDIT}
      OR iMode EQ {&MOD_VIEW}
   THEN
   DO:
      mBag = LnInBagOnDate (tt-loan.contract, tt-loan.cont-code,gend-date).
      CASE tt-loan.contract:
         WHEN "�।��" THEN
            mFindLoanCond = FGetSetting("�।���", "", "").
         WHEN "�����" THEN
            mFindLoanCond = FGetSetting("������", "", "").
      END CASE.
      CASE mFindLoanCond:
         WHEN "������" THEN
            FIND FIRST tt-loan-cond WHERE
                       tt-loan-cond.cont-code EQ tt-loan.cont-code
                   AND tt-loan-cond.contract  EQ tt-loan.contract
            NO-LOCK NO-ERROR.
         WHEN "��������" THEN
            FIND LAST tt-loan-cond WHERE
                      tt-loan-cond.cont-code EQ tt-loan.cont-code
                  AND tt-loan-cond.contract  EQ tt-loan.contract
                  AND tt-loan-cond.since     LE tt-loan.since
            NO-LOCK NO-ERROR.
      END CASE.
      IF CAN-DO("��������,���������", mFindLoanCond) THEN
      DO:
            /* ������� �㬬� � ᮮ⢥��⢨� � �������� �᫮���� */
         FIND FIRST bterm-obl WHERE
                    bterm-obl.contract  EQ tt-loan.contract
                AND bterm-obl.cont-code EQ tt-loan.cont-code
                AND bterm-obl.end-date  EQ tt-loan-cond.since
                AND bterm-obl.idnt      EQ 2
         NO-LOCK NO-ERROR.
         IF AVAIL bterm-obl THEN DO:

            RUN PrepareInstance IN h_data ("").

            RUN GetInstance IN h_data ("term-obl",
                                       bterm-obl.contract + "," + bterm-obl.cont-code + "," + STRING(bterm-obl.idnt) + "," + STRING(bterm-obl.end-date) + "," + STRING(bterm-obl.nn),
                                       OUTPUT vInstCond,
                                       OUTPUT vOk).
            vBuffCond = vInstCond:DEFAULT-BUFFER-HANDLE.
            vBuffCond:FIND-FIRST().
            BUFFER tt-amount:BUFFER-COPY(vBuffCond) NO-ERROR.
            tt-amount.local__rowid = TO-ROWID (getInstanceProp2 (vBuffCond, "__rowid")).

         END.
      END.
   END.

   /* Commented by KSV: �᫨ ०�� ����� �����, ���栫����㥬 �� ����� */
   IF iMode = {&MOD_ADD} THEN
   DO:
      tt-loan.open-time = TIME.
      tt-loan.datasogl$ = TODAY.
      IF tt-loan.alt-contract = "mm"  THEN
      DO:
         {f-fx.trg &INIT-AGREEMENT = YES}
      END.
                        /* ��।������ �᪠. */
      mRisk =  tt-loan.risk.
      IF mBag NE ?
      THEN DO:
         FIND FIRST bPos WHERE
                  bPos.contract  EQ "���"
            AND   bPos.cont-code EQ mBag
         NO-LOCK NO-ERROR.
         IF AVAIL bPos THEN
            mRisk = DEC (fGetBagRate ((BUFFER bPos:HANDLE), "%���", tt-loan.since, "rate-comm")).
      END.
      RUN LnGetRiskGrOnDate IN h_i254 (DEC(mRisk),
                                       tt-loan.since,
                                       OUTPUT mGrRiska).
      IF mGrRiska = ? THEN
      DO:
         MESSAGE '�� 㤠���� ������ ��㯯� �᪠' SKIP
                 '�� 㪠������� �����樥��� १�ࢨ஢����'
            VIEW-AS ALERT-BOX ERROR.
      END.

      IF AVAIL tt-instance THEN
      DO:
         IF iMode EQ {&MOD_ADD} THEN ASSIGN
            mGrRiska = tt-instance.gr-riska
            mRisk    = tt-instance.risk
            tt-loan.currency = tt-instance.currency.
         vAcctTypeList = GetXattrEx(iClass,"acct-type-list","Initial").
         vH = GetProperty(iInstance,"loan-acct-main:acct-type","").
         vAcctType = vH:BUFFER-VALUE.
         vH = GetProperty(iInstance,"loan-acct-main:acct","").
         vAcct = vH:BUFFER-VALUE.
         IF {assigned vAcctType} AND
            NOT {assigned tt-loan-acct-main.acct} AND
            CAN-DO(vAcctTypeList,vAcctType) THEN
            tt-loan-acct-main.acct = vAcct.

         vH = GetProperty(iInstance,"loan-acct-cust:acct-type","").
         vAcctType = vH:BUFFER-VALUE.
         vH = GetProperty(iInstance,"loan-acct-cust:acct","").
         vAcct = vH:BUFFER-VALUE.
         IF {assigned vAcctType} AND
            NOT {assigned tt-loan-acct-cust.acct} AND
            CAN-DO(vAcctTypeList,vAcctType) THEN
            tt-loan-acct-cust.acct = vAcct.
      END.
      /* ᯨ᮪ �����⨬�� ���祭�� ��� ����� ����� */
      RUN GetXAttr (tt-loan.class-code,"cred-offset",BUFFER xattr).
      mOffsetVld = xattr.Validation.   /* ������� ᯨ᮪ �����⨬�� ���祭�� ����� "�����" */
      ENTRY(LOOKUP("",mOffsetVld),mOffsetVld) = mOffsetNone. /* ����� ���祭�� "" �ᯮ��㥬 "--" */

      IF NUM-ENTRIES(iInstanceList,CHR(3)) GT 1
      THEN
         vProd = ENTRY(2,iInstanceList,CHR(3)).
      IF {assigned vProd}
      THEN DO:
         /* ��ଠ ��⠭���� ��ࠬ��� �த�� */
         RUN cred-prod-cr.p (vProd,           /* �த�� */
                             gend-date,       /* �� ���� */
                             "",              /* �।��⠭���� */
                             OUTPUT vProd).   /* ��ப� ����஥� �த�� */
         IF NUM-ENTRIES(vProd, ";") GT 0 THEN
         DO:
            FIND LAST tmp-code WHERE
                         tmp-code.class      EQ "�த���"
                  AND    tmp-code.code       EQ ENTRY( 1, vProd, ";")
                  AND    tmp-code.beg-date   LE tt-loan.open-date
                  AND   (tmp-code.end-date   GE tt-loan.open-date
                     OR  tmp-code.end-date   EQ ?)
            NO-LOCK NO-ERROR.


            vProdPogOD = GetRefVal ("�த���", gend-date, ENTRY( 1, vProd, ";") + "," + "��").
            vProdPogPr = GetRefVal ("�த���", gend-date, ENTRY( 1, vProd, ";") + "," + "%").

            /*���砫�  ��६ ⨯ ��ਮ�� � �����⭮�� �த��, ��⥬ � ��*/
            vProdType = IF AVAIL tmp-code AND CAN-DO("�,�,�",tmp-code.misc[8])
                        THEN tmp-code.misc[8]
                        ELSE FGetSetting("�த���", "�����ਮ��", "�").

            ASSIGN
               tt-loan.prodkod$        = ENTRY( 1, vProd, ";")
               tt-loan.currency        = ENTRY( 3, vProd, ";")
               tt-amount.amt-rub       = DEC(ENTRY( 2, vProd, ";"))
               vProdType               = IF NOT CAN-DO("�,�,�",vProdType) THEN "�" ELSE vProdType
               tt-loan-cond.NDays      = IF vProdType EQ "�" THEN INT64(ENTRY( 4, vProd, ";")) ELSE tt-loan-cond.NDays
               tt-loan-cond.NMonthes   = IF vProdType EQ "�" THEN INT64(ENTRY( 4, vProd, ";")) ELSE tt-loan-cond.NMonthes
               tt-loan-cond.NYears     = IF vProdType EQ "�" THEN INT64(ENTRY( 4, vProd, ";")) ELSE tt-loan-cond.NYears
               tt-loan-cond.prodtrf$   = ENTRY( 7, vProd, ";")
               tt-loan.cont-type       = ENTRY( 8, vProd, ";")
              .
               /* �� */
            IF NUM-ENTRIES (vProdPogOD) GE 8 THEN
               ASSIGN
                  tt-loan-cond.cred-period  = ENTRY(1,vProdPogOD)
                  tt-loan-cond.cred-date    = INT64(ENTRY(2,vProdPogOD))
                  tt-loan-cond.cred-month   = INT64(ENTRY(3,vProdPogOD))
                  cred-offset_:SCREEN-VALUE IN FRAME fMain = ENTRY(4,vProdPogOD)
                  tt-loan-cond.cred-offset  = ENTRY(4,vProdPogOD)
                  tt-loan-cond.kollw#gtper$ = INT64(ENTRY(5,vProdPogOD))
                  tt-loan-cond.cred-mode    = ENTRY(6,vProdPogOD)
                  tt-loan-cond.delay1       = INT64(ENTRY(7,vProdPogOD))
                  delay-offset_             = ENTRY(8,vProdPogOD)
                  tt-loan-cond.delay-offset = ENTRY(8,vProdPogOD)
               .
               /* %% */
            IF NUM-ENTRIES (vProdPogPr) GE 8 THEN
               ASSIGN
                  tt-loan-cond.int-period       = ENTRY(1,vProdPogPr)
                  tt-loan-cond.int-date         = INT64(ENTRY(2,vProdPogPr))
                  tt-loan-cond.int-month        = INT64(ENTRY(3,vProdPogPr))
                  int-offset_:SCREEN-VALUE IN FRAME fMain = ENTRY(4,vProdPogPr)
                  tt-loan-cond.int-offset       = ENTRY(4,vProdPogPr)
                  tt-loan-cond.kollw#gtperprc$  = INT64(ENTRY(5,vProdPogPr))
                  tt-loan-cond.int-mode         = ENTRY(6,vProdPogPr)
                  tt-loan-cond.delay            = INT64(ENTRY(7,vProdPogPr))
                  delay-offset-int_             = ENTRY(8,vProdPogPr)
                  tt-loan-cond.delay-offset-int = ENTRY(8,vProdPogPr)
               .

            IF vProdType EQ "�" 
            THEN
               tt-loan.end-date        = tt-loan.open-date + tt-loan-cond.Ndays.
            ELSE IF vProdType EQ "�" 
            THEN
            tt-loan.end-date        = GoMonth(tt-loan.open-date,tt-loan-cond.NMonthes).
            ELSE IF vProdType EQ "�" 
            THEN DO:
               tt-loan.end-date = DATE(MONTH(tt-loan.open-date),
                                       DAY(tt-loan.open-date),
                                       YEAR(tt-loan.open-date) + tt-loan-cond.NYears) NO-ERROR.
               IF ERROR-STATUS:ERROR /* �᫨ ���㣨 � �⮬ ���� ��� 29 䥢ࠫ� */
               THEN DO:
                  ASSIGN
                     tt-loan.end-date   = DATE(MONTH(tt-loan.open-date),
                                               DAY(tt-loan.open-date) + 1,
                                               YEAR(tt-loan.open-date) + tt-loan-cond.NYears)
                     tt-loan-cond.NDays = 1
                  .
               END.
            END.
               
            

            mNameCredPeriod = GetDomainCodeName(tt-loan-cond.class-code,
                                                "cred-period",
                                                tt-loan-cond.cred-period).
            mNameIntPeriod  = GetDomainCodeName(tt-loan-cond.class-code,
                                                "int-period",
                                                tt-loan-cond.int-period).

            /* ���� �� �ଥ �� ������ �� "�த���" � "�த���" ��襬 � ����� ������ */
            RUN SetInstanceProp(mInstance, "�த���", ENTRY( 1, vProd, ";"), OUTPUT vOk).
            vH = WIDGET-HANDLE(GetInstanceProp2(mInstance, "loan-cond")).
            IF VALID-HANDLE(vH) THEN
               RUN SetInstanceProp(vH, "�த���", ENTRY( 7, vProd, ";"), OUTPUT vOk).

            /*���������*/
            IF tt-loan.class-code = "loan_dbl_ann" 
                AND NUM-ENTRIES(vProd, ";") GE 18 THEN
            DO:
                ASSIGN
                    tt-loan-cond.PartAmount  = DEC(ENTRY(18 , vProd, ";"))
                    tt-loan-cond.FirstPeriod = INT(ENTRY(17 , vProd, ";"))
                    .
                RUN SetInstanceProp(mInstance, "InitPay", ENTRY( 10, vProd, ";"), OUTPUT vOk).
                RUN SetInstanceProp(mInstance, "rko11_price", ENTRY( 16, vProd, ";"), OUTPUT vOk).
            END.
         END.
      END.
   END.
   ELSE IF iMode = {&MOD_EDIT} 
   THEN DO:
      mNewEndDate = DATE(ENTRY(2,iInstanceList,CHR(3))) NO-ERROR.
   END.

   DO WITH FRAME {&MAIN-FRAME}:
      IF    tt-loan.open-date NE ?
        AND tt-loan.end-date  NE ?
        AND ( tt-loan-cond.NDays  EQ 0
        AND  tt-loan-cond.NMonth EQ 0
        AND  tt-loan-cond.NYears EQ 0 )
         OR ( tt-loan-cond.NDays EQ ?
         OR tt-loan-cond.NMonth EQ ?
         OR tt-loan-cond.NYears EQ ? ) THEN
      DO:
        RUN DMY_In_Per(tt-loan.open-date,
                        tt-loan.end-date,
                        OUTPUT mNDays,
                        OUTPUT mNMonth,
                        OUTPUT mNYear).
        ASSIGN
            tt-loan-cond.NDays  = mNDays
            tt-loan-cond.NMonth = mNMonth
            tt-loan-cond.NYears = mNYear
        .
      END.
   END.
      /* ���� */
   ASSIGN
      tt-loan.svodgrafik$ = IF tt-loan.svodgrafik$ EQ ? THEN NO ELSE tt-loan.svodgrafik$
      tt-loan.svodskonca$ = IF tt-loan.svodskonca$ EQ ? THEN NO ELSE tt-loan.svodskonca$
      tt-loan.svodgravto$ = IF tt-loan.svodgravto$ EQ ? THEN NO ELSE tt-loan.svodgravto$
      tt-loan.svodspostr$ = IF tt-loan.svodspostr$ EQ ? THEN NO ELSE tt-loan.svodspostr$
      mSvod               = tt-loan.svodgrafik$ OR tt-loan.svodskonca$ OR tt-loan.svodgravto$ OR tt-loan.svodspostr$
   .
   mSummaDog = DEC(GetXAttrValueEx("loan",tt-loan.contract + "," + tt-loan.cont-code,"�㬬����","0")).
   IF     mSummaDog NE 0 
      AND mSummaDog NE ? THEN      
      tt-amount.amt-rub = mSummaDog.
   IF tt-loan-cond.grperiod$ EQ ? THEN
      tt-loan-cond.grperiod$ = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PostSetObject TERMINAL-SIMULATION
PROCEDURE PostSetObject :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

   DEFINE VARIABLE vH        AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vRow      AS ROWID      NO-UNDO.
   DEFINE VARIABLE vRecLoan  AS RECID      NO-UNDO.
   DEFINE VARIABLE vRecCond  AS RECID      NO-UNDO.
   DEFINE VARIABLE vAcctType AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vRet      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vRet1     AS CHARACTER  NO-UNDO.

   DEFINE VARIABLE vChangeSumm  AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vChangePr    AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vChangeDate  AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vChangePer   AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vGrRisk      AS INT64   NO-UNDO.
   DEFINE VARIABLE vListGrRiska AS CHARACTER NO-UNDO.

   DEFINE VARIABLE fl-error   AS INT64    NO-UNDO.
   DEFINE VARIABLE mObespTran AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vOk        AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE vCondCount AS INT64    NO-UNDO.
   DEFINE VARIABLE vCheckLimit  AS CHAR       NO-UNDO.

   DEFINE VARIABLE mGrRiskVn  AS INT64    NO-UNDO.
   DEFINE VARIABLE mMinRate   AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE vPayDateMove AS CHARACTER NO-UNDO. /* �� ���玪��瑤��� */

   DEFINE VARIABLE vAcctTypeList AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vCounter      AS INT64        NO-UNDO.
   DEFINE VARIABLE vPrefLimDate  AS DATE NO-UNDO .
   DEFINE VARIABLE vRetLim       AS CHARACTER NO-UNDO .
   DEFINE VARIABLE vLCRecNew     AS RECID NO-UNDO.
   DEFINE VARIABLE vLCSummNew    AS DEC   NO-UNDO.
   DEFINE VARIABLE vRaschInstr   AS CHARACTER NO-UNDO.

   DEFINE BUFFER loan       FOR loan.
   DEFINE BUFFER tloan      FOR loan.
   DEFINE BUFFER b-loan     FOR loan.
   DEFINE BUFFER loan-cond  FOR loan-cond. /* ���������� ����. */
   DEFINE BUFFER tloan-cond FOR loan-cond.
   DEFINE BUFFER bcomm-rate FOR comm-rate.
   DEFINE BUFFER loan-acct  FOR loan-acct. /* ���������� ����. */
   DEFINE BUFFER bloan-acct FOR loan-acct. /* ���������� ����. */
   DEFINE BUFFER blimits    FOR limits.
   DEFINE BUFFER term-obl   FOR term-obl.

   /* ���࠭塞 �㬬� �� �������� */
   IF    iMode EQ {&MOD_ADD}
      OR iMode EQ {&MOD_EDIT} THEN
   DO:          
      UpdateSigns(tt-loan.Class-Code,
                  tt-loan.contract + "," + tt-loan.cont-code,
                  "�㬬����",
                  STRING(mSummaDog),
                  ?).
   END.

   IF     AVAIL tt-Instance
      AND iMode EQ {&MOD_ADD} THEN /* ����஢���� �� � �墠�뢠�饣� ������� */
      IF     tt-Instance.Cont-code EQ ENTRY(1, tt-loan.Cont-code, " ")
         AND tt-Instance.cont-type EQ "��祭��" THEN 
      DO:
         mLstDR =  GetXAttrInit(tt-Instance.class-code, "���፠᫄�").
         RUN CopySignsEx(tt-Instance.class-code,
                         tt-loan.Contract + "," + tt-Instance.Cont-code,
                         tt-loan.class-code,
                         tt-loan.Contract + "," + tt-loan.Cont-code,
                         mLstDR,
                         "!*").
      END.

   IF iMode EQ {&MOD_ADD} THEN /* �஢�ઠ �� ᮮ⢥��⢨� ��⮢ ������� */
   DO:
      vH = GetProperty(mInstance,"loan-acct-main:acct-type","__upid = 0").
      vAcctType = vH:BUFFER-VALUE.
      IF {assigned tt-loan-acct-main.acct} AND
         NOT CheckCliAcct(vAcctType,
                          tt-loan-acct-main.acct,
                          tt-loan.currency,
                          tt-loan.cust-cat,
                          tt-loan.cust-id) THEN
      DO:
         APPLY "ENTRY" TO tt-loan-acct-main.acct IN FRAME {&MAIN-FRAME}.
         RETURN ERROR "��� �� ᮮ⢥����� ����ࠣ���� ��� �����".
      END.

      FIND loan WHERE loan.contract  EQ tt-loan.contract
                  AND loan.cont-code EQ tt-loan.cont-code
         NO-LOCK.
      IF {assigned tt-loan-acct-main.acct} THEN
      DO:
         FOR EACH acct WHERE
                  acct.acct     =  tt-loan-acct-main.acct
              AND acct.currency =  tt-loan.currency
         NO-LOCK:

            RUN SetKau IN h_loanx (RECID(acct),
                                   RECID(loan) ,
                                   tt-loan-acct-main.acct-type).
            LEAVE.
         END.
      END.

      vH = GetProperty(mInstance,"loan-acct-cust:acct-type","__upid = 0").
      vAcctType = vH:BUFFER-VALUE.
      IF {assigned tt-loan-acct-cust.acct} AND
         NOT CheckCliAcct(vAcctType,
                          tt-loan-acct-cust.acct,
                          tt-loan.currency,
                          tt-loan.cust-cat,
                          tt-loan.cust-id) THEN
      DO:
         APPLY "ENTRY" TO tt-loan-acct-cust.acct IN FRAME {&MAIN-FRAME}.
         RETURN ERROR "��� �� ᮮ⢥����� ����ࠣ���� ��� �����".
      END.

         /* �������� ����.१�ࢨ஢���� */
      IF INDEX(tt-loan.cont-code, " ") EQ 0 THEN
         RUN CrResRate IN h_Loan (tt-loan.contract,
                                  tt-loan.cont-code,
                                  mRisk,
                                  tt-loan.open-date).
         IF AVAILABLE tt-instance THEN DO:
            vAcctTypeList = GetXattrEx(tt-instance.class-code,"acct-type-list","Initial").
            REPEAT vCounter = 1 TO NUM-ENTRIES(vAcctTypeList):
               FIND LAST bloan-acct WHERE
                        bloan-acct.contract  EQ tt-instance.contract
                     AND bloan-acct.cont-code EQ tt-instance.cont-code
                     AND bloan-acct.acct-type EQ ENTRY(vCounter, vAcctTypeList)
                     AND bloan-acct.since     LE tt-loan.open-date
               NO-LOCK NO-ERROR.
               IF NOT AVAIL bloan-acct THEN
                  NEXT.
               FIND FIRST loan-acct WHERE
                        loan-acct.contract  EQ tt-loan.contract
                     AND loan-acct.cont-code EQ tt-loan.cont-code
                     AND loan-acct.acct-type EQ bloan-acct.acct-type
                     AND loan-acct.since     EQ tt-loan.open-date
               NO-LOCK NO-ERROR.
               IF AVAIL loan-acct THEN
                  NEXT.
               CREATE loan-acct.
               BUFFER-COPY bloan-acct EXCEPT cont-code since TO loan-acct.
               ASSIGN
                  loan-acct.cont-code = tt-loan.cont-code
                  loan-acct.since     = tt-loan.open-date
               .
            END.
         END.
         /* �������� � �ਢ離� ��⮢ */
      {sgn-acct.i &BufferLoan = "LOAN"
                  &OpenDate   = loan.open-date
                  &OUT-Error  = fl-error
      }
      IF fl-error EQ -1 THEN
         RETURN ERROR "��ࠡ�⪠ ��ࢠ��".
      mObespTran = GetXAttrInit(loan.class-code,"Op-Kind_Obesp").
      IF {assigned mObespTran} THEN
      DO:
         FIND FIRST Op-Kind WHERE
                    Op-Kind.Op-Kind = mObespTran
         NO-LOCK NO-ERROR.
         FIND FIRST loan-cond WHERE
                    loan-cond.contract  = loan.contract
                AND loan-cond.cont-code = loan.cont-code
         NO-LOCK NO-ERROR.

         IF AVAIL Op-Kind AND
            AVAIL loan-cond   THEN
         DO:
               /* C��砫� ����᪠�� ��㧥� ���ᯥ祭�� */
            RUN browseld.p ("term-obl-gar",
                            "contract"         + CHR(1) + "cont-code"         + CHR(1) + "since",
                            loan-cond.contract + CHR(1) + loan-cond.cont-code + CHR(1) + STRING(loan-cond.since),
                            "",
                            ilevel + 1).
               /* ... � �࠭����� ᮧ����� ��⮢ */
            RUN credacct.p (loan.open-date,
                            RECID(Op-Kind),
                            RECID(loan),
                            "�������������� ������ �� �������� � " +
                            loan.doc-ref,
                            OUTPUT fl-Error).
         END.
      END.
      IF fl-error EQ -1 THEN
         RETURN ERROR "��ࠡ�⪠ ��ࢠ��".
      UpdateSignsEx(tt-loan-cond.class-code,
                    tt-loan.contract + ","
                  + tt-loan.cont-code + ","
                  + STRING (tt-loan-cond.since),
                    "CondEndDate",
                    STRING(tt-loan.end-date)
                    ) .
      /* ��।��塞, ���� �� ���뢠�� ᤢ�� ���� ���⥦� 
      ** ��� ���� ���� ����砭�� �஡��� */
      IF tt-loan-cond.cred-mode = "��⠎����" AND 
         NOT tt-loan-cond.cred-curr-next 
      THEN DO:
         vPayDateMove = GetXattrInit(tt-loan-cond.class-code, "���玪��瑤���").
         IF vPayDateMove NE ? AND
            vPayDateMove NE "" 
         THEN DO:
            UpdateSignsEx(tt-loan-cond.class-code,
                          tt-loan.contract + ","
                        + tt-loan.cont-code + ","
                        + STRING (tt-loan-cond.since),
                          "���玪��瑤���",
                          vPayDateMove
                          ) .
         END.
      END.
   /* ���࠭���� ����⮢ */
      IF tt-loan.rewzim$:SCREEN-VALUE NE ? AND
         tt-loan.rewzim$:SCREEN-VALUE NE ""  AND
         tt-loan.LimitGrafDate EQ ?
      THEN DO:
         tt-loan.LimitGrafDate = tt-loan.end-date .
      END.
      CASE tt-loan.rewzim$:SCREEN-VALUE :

         WHEN "����뤇��" THEN DO:
            RUN SaveLoanLimit (tt-loan.contract,tt-loan.cont-code,tt-loan.open-date,tt-loan.currency,"limit-l-distr",mLimit,OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","�������� �訡�� �� ��࠭���� ����� �뤠�. ����� �� ��࠭��.").
         RUN SaveLoanLimitLastCond IN h_limit  (tt-loan.contract,tt-loan.cont-code,tt-loan.LimitGrafDate,tt-loan.currency,"limit-l-distr",OUTPUT vOk).
         IF NOT vOk THEN
            RUN Fill-SysMes IN h_tmess ("","","0","�������� �訡�� �� ��࠭���� ��᫥���� ����� ����� �뤠�. ����� �� ��࠭��.").

         END.
         WHEN "�����������" THEN DO:
            RUN SaveLoanLimit (tt-loan.contract,tt-loan.cont-code,tt-loan.open-date,tt-loan.currency,"limit-l-debts",mLimit,OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","�������� �訡�� �� ��࠭���� ����� ������������. ����� �� ��࠭��.").
            RUN SaveLoanLimitLastCond IN h_limit  (tt-loan.contract,tt-loan.cont-code,tt-loan.LimitGrafDate,tt-loan.currency,"limit-l-debts",OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","�������� �訡�� �� ��࠭���� ��᫥���� ����� ����� ������������. ����� �� ��࠭��.").

         END.
         WHEN "����������" THEN DO:
            RUN SaveLoanLimit (tt-loan.contract,tt-loan.cont-code,tt-loan.open-date,tt-loan.currency,"limit-l-distr",mLimit,OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","�������� �訡�� �� ��࠭���� ����� �뤠�. ����� �� ��࠭��.").
            RUN SaveLoanLimitLastCond IN h_limit  (tt-loan.contract,tt-loan.cont-code,tt-loan.LimitGrafDate,tt-loan.currency,"limit-l-distr",OUTPUT vOk).
            IF NOT vOk THEN
               RUN Fill-SysMes IN h_tmess ("","","0","�������� �訡�� �� ��࠭���� ��᫥���� ����� ����� �뤠�. ����� �� ��࠭��.").
         END.
      END CASE.
   END.

   IF iMode EQ {&MOD_EDIT} THEN
   DO:
         /* ��������� �ப� ����⢨� ����⮢ */
      IF tt-loan.rewzim$:SCREEN-VALUE NE ? AND
         tt-loan.rewzim$:SCREEN-VALUE NE ""  AND
         tt-loan.LimitGrafDate EQ ?
      THEN DO:
         tt-loan.LimitGrafDate = tt-loan.end-date .
      END.
      CASE tt-loan.rewzim$:SCREEN-VALUE :
         WHEN "����뤇��" OR
         WHEN "����������" THEN DO:
         RUN SaveLoanLimitLastCond IN h_limit  (tt-loan.contract,tt-loan.cont-code,tt-loan.LimitGrafDate,tt-loan.currency,"limit-l-distr",OUTPUT vOk).
         IF NOT vOk THEN
            RUN Fill-SysMes IN h_tmess ("","","0","�������� �訡�� �� ��࠭���� ��᫥���� ����� ����� �뤠�. ����� �� ��࠭��.").

      END.
      WHEN "�����������" THEN DO:
         RUN SaveLoanLimitLastCond IN h_limit  (tt-loan.contract,tt-loan.cont-code,tt-loan.LimitGrafDate,tt-loan.currency,"limit-l-debts",OUTPUT vOk).
         IF NOT vOk THEN
            RUN Fill-SysMes IN h_tmess ("","","0","�������� �訡�� �� ��࠭���� ��᫥���� ����� ����� ������������. ����� �� ��࠭��.").

         END.
      END CASE.

   END.

   IF iMode EQ {&MOD_ADD} OR iMode EQ {&MOD_EDIT} THEN
   DO:
      vH = GetProperty(mInstance,"__rowid"," __id = 0").
      vRow = vH:BUFFER-VALUE.
      vRecLoan = Rowid2Recid("Loan",vRow).
      vH = GetProperty(mInstance,"loan-cond:__rowid","__upid = 0 BY since DESC").
      vRow = vH:BUFFER-VALUE.
      IF vRow NE ? THEN
      DO:
         vRecCond = Rowid2Recid("Loan-Cond",vRow).
         RUN SetSysConf IN h_base(
            "������������� �� �������� �����",
            STRING(LOOKUP(tt-loan-cond.cred-offset,tt-loan-cond.cred-offset:LIST-ITEMS))).
         RUN SetSysConf IN h_base(
            "������� �� ��������� �����",
            STRING(LOOKUP(tt-loan-cond.int-offset,tt-loan-cond.int-offset:LIST-ITEMS))).
         RUN SetSysConf IN h_base("��������","��").

         IF iMode EQ {&MOD_EDIT} THEN
         DO:
            FIND LAST tt-loan-cond NO-ERROR.
            FOR FIRST tt-amount WHERE tt-amount.amt-rub NE 0 BY tt-amount.end-date:
               LEAVE.
            END.
         END.
         IF iMode EQ {&MOD_ADD} THEN ASSIGN
            vChangeSumm = YES
            vChangePr   = YES
            vChangeDate = YES
            vChangePer  = YES
         .
         ELSE ASSIGN
            vChangeSumm = mAmount NE mSumma-sd
            vChangePr   =
               mCredPeriod NE tt-loan-cond.Cred-Period OR
               mCredDate NE tt-loan-cond.Cred-Date OR
               mDelay1 NE tt-loan-cond.Delay1 OR
               mCredOffset NE tt-loan-cond.cred-offset OR
               mCountPer NE tt-loan-cond.kollw#gtper$
            vChangeDate = mEndDate NE tt-loan.end-date
            vChangePer =   mIntPeriod  NE tt-loan-cond.int-Period
                        OR mIntDate    NE tt-loan-cond.int-Date
         .
         
         IF tt-loan.class-code = "loan_dbl_ann" THEN
         DO:
            FIND FIRST loan WHERE RECID(loan) EQ vRecLoan NO-LOCK NO-ERROR .
            FIND FIRST loan-cond WHERE
                       loan-cond.contract  EQ loan.contract
                   AND loan-cond.cont-code EQ loan.cont-code 
            NO-LOCK NO-ERROR.
            IF     AVAIL loan 
               AND AVAIL loan-cond THEN 
            DO:  
                IF iMode EQ {&MOD_ADD} THEN 
                DO:
                   RUN set-pr.p(RECID(loan-cond),RECID(loan),1).
                   RUN pog-cr.p(RECID(loan-cond),RECID(loan),0,tt-loan.open-date,tt-loan.open-date + 1,
                                OUTPUT vFlag) NO-ERROR.
                   RUN Cr_Cond_DblAnn IN h_Loan (tt-loan.contract, 
                                                 tt-loan.cont-code, 
                                                 tt-loan.open-date, 
                                                 NO, 
                                                 YES,
                                                 ?,
                                                 OUTPUT vLCRecNew,  
                                                 OUTPUT vLCSummNew) NO-ERROR.
                END.
                RUN anps.p(tt-loan.since,0, BUFFER loan, BUFFER loan-cond).
            END.
         END.
         ELSE DO:
             FOR EACH loan-cond WHERE
                      loan-cond.contract  = tt-loan.contract
                  AND loan-cond.cont-code = tt-loan.cont-code
             NO-LOCK:
                vCondCount = vCondCount + 1.
             END.
    
             IF    tt-loan.class-code EQ "loan-transh-ann"
                OR tt-loan.class-code EQ "loan-tran-lin-ann" THEN
             DO:
                /* ��७�� ��䨪�� */
                RUN loansvodgr.p(tt-loan.contract,ENTRY(1,tt-loan.cont-code," "),tt-loan-cond.since,"get").
                /* ��� ������� �࠭� */
                FOR EACH tloan WHERE (tloan.contract  EQ tt-loan.contract
                                  AND tloan.cont-code BEGINS ENTRY(1,tt-loan.cont-code, " ") + " "
                                  AND NUM-ENTRIES(tloan.cont-code," ") GT 1)
                                 OR  (tloan.contract  EQ tt-loan.contract
                                  AND tloan.cont-code EQ ENTRY(1,tt-loan.cont-code," "))
                    NO-LOCK,
                    
                    LAST tloan-cond WHERE tloan-cond.contract  EQ tloan.contract
                                      AND tloan-cond.cont-code EQ tloan.cont-code
                    NO-LOCK BY NUM-ENTRIES(tloan.cont-code," ") DESC:
    
                   /* ��⠥� ���-�� �᫮��� �� �祭�� */
                   vCondCount = 0.
                   FOR EACH loan-cond WHERE
                            loan-cond.contract  = tloan.contract
                        AND loan-cond.cont-code = tloan.cont-code
                   NO-LOCK:
                      vCondCount = vCondCount + 1.
                   END.
                   /* ������ ��䨪�� */
                   IF NUM-ENTRIES(tloan.cont-code, " ") EQ 1 THEN
                      RUN SetSysConf IN h_Base("�� �������� ������� �� �����","��").
                   IF     NUM-ENTRIES(tloan.cont-code, " ") GT 1 
                      AND tloan.cont-code NE tt-loan.cont-code THEN
                      FIND FIRST term-obl OF tloan WHERE term-obl.idnt EQ 2 NO-ERROR.
                   RUN mm-to.p(RECID(tloan),
                               RECID(tloan-cond),
                               (IF tloan.cont-code EQ tt-loan.cont-code OR NOT AVAIL term-obl THEN tt-amount.amt-rub ELSE term-obl.amt-rub),
                               (IF tloan.cont-code EQ tt-loan.cont-code THEN iMode ELSE {&MOD_EDIT}),
                               vChangeSumm,
                               vChangePr  ,
                               vChangeDate,
                               vChangePer,
                               mRisk,
                               vCondCount) NO-ERROR.
                   IF NUM-ENTRIES(tloan.cont-code, " ") EQ 1 THEN
                      RUN DeleteOldDataProtocol IN h_Base("�� �������� ������� �� �����").
                   vRet = RETURN-VALUE.
                END.
                /* ᭮�� ���祬 ��� ��䨪� � ������ ᢮��� ��䨪� �� %% � ��, ࠧ���� �� �࠭蠬 */
                RUN loansvodgr.p(tt-loan.contract,ENTRY(1,tt-loan.cont-code," "),tt-loan-cond.since,"set").
                IF NUM-ENTRIES(tt-loan.cont-code, " ") GE 1 THEN
                DO:
                   /* �饬 ���� �࠭� �� �������� */
                   FIND FIRST loan WHERE
                        loan.contract  EQ tt-loan.contract
                    AND loan.cont-code BEGINS ENTRY(1,tt-loan.cont-code," ") + " "
                    AND NUM-ENTRIES (loan.cont-code," ") EQ 2
                   NO-LOCK NO-ERROR.
                   /* �᫨ ��諨, � �饬 ��᫥���騩 �࠭� */
                   IF AVAIL loan THEN
                   DO:
                      FIND NEXT loan WHERE
                           loan.contract  EQ tt-loan.contract
                       AND loan.cont-code BEGINS ENTRY(1,tt-loan.cont-code," ") + " "
                       AND NUM-ENTRIES (loan.cont-code," ") EQ 2
                      NO-LOCK NO-ERROR.

                      IF NOT AVAIL loan THEN 
                      tr:
                      DO TRANSACTION:
                         FIND FIRST loan-cond WHERE 
                                    loan-cond.contract  EQ tt-loan.contract
                                AND loan-cond.cont-code EQ ENTRY(1,tt-loan.cont-code," ") 
                         EXCLUSIVE-LOCK NO-ERROR.
                         IF AVAIL loan-cond THEN
                         DO:
                            ASSIGN
                              loan-cond.since = tt-loan-cond.since
                            NO-ERROR.
                            IF ERROR-STATUS:ERROR THEN 
                            DO:
                              RUN Fill-SysMes IN h_tmess ("","","1",ERROR-STATUS:GET-MESSAGE(1)).
                              UNDO,LEAVE tr.
                            END.
                         END.
                         ELSE 
                            RUN crCond IN h_loan(tt-loan.contract,ENTRY(1,tt-loan.cont-code," "),tt-loan-cond.since,"").
                      END.
                      ELSE 
                         RUN crCond IN h_loan(tt-loan.contract,ENTRY(1,tt-loan.cont-code," "),tt-loan-cond.since,""). 
                   END.
                END.
             END.
             ELSE
             DO:
                RUN mm-to.p(vRecLoan,
                            vRecCond,
                            tt-amount.amt-rub,
                            iMode,
                            vChangeSumm,
                            vChangePr  ,
                            vChangeDate,
                            vChangePer,
                            mRisk,
                            vCondCount) NO-ERROR.
                vRet = RETURN-VALUE.
             END.
         END.
         vRetLim = "".
         
         /* �� �஢�ન, ��襤訥 �� ��吝��� �⪫���, �㦭� ࠧ������� � 
         ** �ॡ�����ﬨ � ��९���� ��� ������, ��������� �� CheckAllLimit,
         ** ॠ�������� ������ �ॡ������ �⤥�쭮
         */
         IF GetXAttrValueEx("loan",
                            tt-loan.contract + "," + ENTRY(1,tt-loan.cont-code," "),
                            "�����",
                             ?) NE ? THEN
         DO:
   
            /* ��室�� �墠�뢠�騩 ������� */
            FIND FIRST loan WHERE loan.contract  EQ tt-loan.contract
                              AND loan.cont-code EQ ENTRY(1, tt-loan.cont-code, " " )
            NO-LOCK NO-ERROR.
               /* �� ���������� �࠭� �㦭� ��।����� �� �� �墠�뢠�饬 */
            IF tt-loan.LimitGrafDate EQ ? THEN DO:
               tt-loan.LimitGrafDate = date(GetTempXAttrValueEx("loan",
                        loan.contract + "," + loan.cont-code,
                        "LimitGrafDate",
                        date(tt-loan.end-date:screen-value),
                        ?)).
            END.
            vCheckLimit = GetXAttrValueEx("loan",
                                          loan.contract + "," + loan.cont-code,
                                          "CheckLimit",
                                          ?).
            IF NOT {assigned vCheckLimit} THEN
               vCheckLimit = GetXattrInit(loan.class-code, "CheckLimit").
            IF vCheckLimit EQ ? THEN
               vCheckLimit = "��".
               /* �᫨ �ॡ����, �ந������ �஢�ન ����� */
            IF vCheckLimit EQ "��" THEN
            DO:
               RUN LimitControl IN h_limit
                  (loan.contract,
                   loan.cont-code,
                   tt-loan.open-date,
                   tt-loan.end-date,
                   OUTPUT vOk,
                   OUTPUT vCheckLimit).
               IF NOT vOk THEN
               DO:
                  RUN Fill-SysMes IN h_tmess ("", "", "-1", vCheckLimit).
                  RETURN ERROR "�訡�� ��࠭���� �᫮���".
               END.
            END.
         END.
         IF iMode EQ {&MOD_ADD} AND tt-loan.alt-contract EQ "mm" THEN
         DO:
            vH = GetProperty(mInstance,"__rowid","__id = 1").
            vRow = vH:BUFFER-VALUE.
            IF vRow NE ? THEN
            DO:
               vRecLoan = Rowid2Recid("Loan",vRow).
               vH = GetProperty(mInstance,"loan-cond:__rowid","__upid = 1 BY since DESC").
               vRow = vH:BUFFER-VALUE.
               vRecCond = Rowid2Recid("Loan-Cond",vRow).
               RUN mm-to.p(vRecLoan,
                           vRecCond,
                           tt-amount.amt-rub,
                           iMode,
                           YES,
                           YES,
                           YES,
                           YES,
                           mRisk,
                           vCondCount) NO-ERROR.
               vRet1 = RETURN-VALUE.
            END.
         END.

         RUN DeleteOldDataProtocol IN h_base("������� �� ��������� �����").
         RUN DeleteOldDataProtocol IN h_base("������������� �� �������� �����").
         RUN DeleteOldDataProtocol IN h_base("��������").
         IF vRet EQ {&RET-ERROR} OR vRet1 EQ {&RET-ERROR} THEN
         DO:
            mRetVal = {&RET-ERROR}.
            RETURN ERROR "�訡�� ��࠭���� �᫮���".
         END.
      END.
      IF iMode EQ {&MOD_ADD} AND
         tt-loan.stream-show EQ YES AND
         tt-loan.cont-type EQ "��祭��" THEN
      DO TRANS:
         RUN "loan(ch.p"(tt-loan.contract,tt-loan.cont-code,0,0,iLevel).
         IF LASTKEY EQ 27 THEN
         DO:
            READKEY PAUSE 0.
            MESSAGE "��ࢠ�� ��ࠡ���?"
               VIEW-AS ALERT-BOX QUESTION
               BUTTONS YES-NO UPDATE vUndo AS LOG.
            IF vUndo EQ YES THEN
               RETURN ERROR "��ࠡ�⪠ ��ࢠ��".
         END.
      END.
      IF tt-loan.alt-contract EQ "mm" THEN
      DO:
         RUN mm-pay.p(?,?,
             GetInstanceProp(mInstance,"class-code"),
             GetInstanceProp(mInstance,"contract") + "," + GetInstanceProp(mInstance,"cont-code"),
             - iMode,0). /* - �⮡ �� ᡨ��� ���ண�� �� MOD_ADD */
      END.

      RUN GET_COMM_LOAN_BUF IN h_Loan (tt-loan.contract,
                                       tt-loan.cont-code,
                                       "%���",
                                       tt-loan.since,
                                       BUFFER comm-rate).

      IF NOT AVAILABLE comm-rate
         AND NUM-ENTRIES (tt-loan.cont-code, " ") = 2
         AND NOT CAN-FIND (loan WHERE loan.contract  = tt-loan.contract
                                  AND loan.cont-code = tt-loan.cont-code
                                  AND loan.cont-type = "��祭��"
                           NO-LOCK)
      THEN
          RUN GET_COMM_LOAN_BUF IN h_Loan (tt-loan.contract,
                                          ENTRY (1, tt-loan.cont-code, " "),
                                          "%���",
                                          tt-loan.since,
                                          BUFFER comm-rate).

      IF AVAILABLE comm-rate
      THEN
         UpdateSignsEx("comm-rate",
                       STRING(comm-rate.commission) + "," +
                       STRING(comm-rate.acct) + "," +
                       STRING(tt-loan.currency) + "," +
                       PushSurr(comm-rate.kau) + "," +
                       string(comm-rate.min-value) + "," +
                       STRING(comm-rate.period) + "," +
                       STRING(comm-rate.since),
                       "��⥣���",
                       STRING(mGrRiska)).

      FOR EACH tt-comm-rate NO-LOCK:

         msurrcr2 = STRING(tt-comm-rate.commission) + "," +
                    STRING(tt-comm-rate.acct) + "," +
                    STRING(tt-loan.currency) + "," +
                    PushSurr(STRING(tt-loan.contract) + "," + STRING(tt-loan.cont-code)) + "," +
                    string(tt-comm-rate.min-value) + "," +
                    STRING(tt-comm-rate.period) + "," +
                    STRING(tt-loan-cond.since)
               .

         UpdateSignsEx("comm-rate-loan",
                        msurrcr2,
                       "�������",
                       STRING(tt-comm-rate.min_value)
            ) .

         IF tt-comm-rate.commission EQ "%���"
         THEN DO:
            RUN LnGetRiskGrOnDate IN h_i254 (mRisk,
                                             tt-loan.open-date,
                                             OUTPUT vGrRisk).
            IF vGrRisk NE mGrRiska
            THEN DO:
               RUN LnGetRiskGrList IN h_i254 (mRisk,
                                              tt-loan.open-date,
                                              YES,
                                              OUTPUT vListGrRiska).
               IF CAN-DO(vListGrRiska,STRING(mGrRiska))
               THEN
                  UpdateSignsEx("comm-rate-loan",
                                msurrcr2,
                                "��⥣���",
                                STRING(mGrRiska)).

            END.
         END.
      END.

            /* ��⮬���᪠� ���⠭���� ��業� १�ࢨ஢���� �� ���������� */
      IF     iMode EQ {&MOD_ADD}
         AND LOGICAL(FGetSetting("��⮏�搥���","","���"),"��/���")
      THEN
      BLK:
      DO ON ERROR  UNDO BLK, LEAVE BLK
         ON ENDKEY UNDO BLK, LEAVE BLK:
         RUN LnGetRiskGrOnDate IN h_i254 (mRisk,
                                          tt-loan.open-date,
                                          OUTPUT vGrRisk).
         RUN LnGetRiskGrList IN h_i254 (mRisk,
                                        tt-loan.open-date,
                                        YES,
                                        OUTPUT vListGrRiska).
         FIND LAST loan-acct WHERE loan-acct.contract  EQ tt-loan.contract
                               AND loan-acct.cont-code EQ tt-loan.cont-code
                               AND loan-acct.acct-type EQ "�।���"
                               AND loan-acct.since     LE tt-loan.open-date
         NO-LOCK NO-ERROR.
         IF NOT AVAIL loan-acct THEN
            FIND LAST loan-acct WHERE loan-acct.contract  EQ tt-loan.contract
                                  AND loan-acct.cont-code EQ tt-loan.cont-code
                                  AND loan-acct.acct-type EQ "�।�"
                                  AND loan-acct.since     LE tt-loan.open-date
            NO-LOCK NO-ERROR.

         IF     NOT AVAIL loan-acct
            OR (NOT FGetSetting("����������","","���") BEGINS "��"
            AND IF IsTemporal("acct","��������")
                 THEN (GetTempXAttrValueEx("acct",loan-acct.acct + ',' + loan-acct.currency,"��������",tt-loan.open-date,"���") NE "��")
                 ELSE (GetXAttrValue("acct",loan-acct.acct + ',' + loan-acct.currency,"��������") NE "��"))
         THEN LEAVE BLK.

         FIND FIRST acct WHERE acct.acct     EQ loan-acct.acct
                           AND acct.currency EQ loan-acct.currency
         NO-LOCK NO-ERROR.
         IF NOT AVAIL acct THEN LEAVE BLK.

                  /* �᫨ ��㯯� ������ ������ � ����� ��㯯� �����⨬, � �ᯮ��㥬 ���.
                  ** ���� ��, ����� ��।���� LnGetRiskGrList */
         mGrRiskVn = IF CAN-DO(vListGrRiska,STRING(mGrRiska)) THEN mGrRiska ELSE vGrRisk.
                  /* ��।��塞 �������쭮� ��� ��⠭���������� ��⥣�ਨ ����⢠ ���祭�� �-� १�ࢨ஢���� */
         RUN LnGetPersRsrvOnDate IN h_i254 (mGrRiskVn,tt-loan.open-date,OUTPUT mMinRate).

                  /* �᫨ ���.�⠢�� ��� ���.���-�� � ��⠭�������� �� ���� ࠧ������� */
         IF mMinRate NE GET_COMM("%���",RECID(acct),acct.currency,"",0,0,tt-loan.open-date) THEN
         BLK2:
         DO ON ERROR  UNDO BLK2, LEAVE BLK2
            ON ENDKEY UNDO BLK2, LEAVE BLK2:
                     /* ����� ���⢥ত���� ����⠭��� �⠢�� ��� 㪠����� ����室���� */
            PAUSE 0.
            UPDATE mMinRate FORMAT ">>>>>>>>9.9999"
                            LABEL "      �⠢�� �����樥�� १�ࢨ஢���� �� ����������"
               WITH FRAME fRate COLOR messages
               TITLE "[ ����������� ������ ��� ������� ����������� ]"
               OVERLAY CENTERED ROW 10 SIDE-LABELS.
            IF LAST-EVENT:FUNCTION EQ "END-ERROR" THEN LEAVE BLK2.

            FIND FIRST bcomm-rate WHERE bcomm-rate.commission EQ "%���"
                                    AND bcomm-rate.filial-id  EQ shfilial
                                    AND bcomm-rate.branch-id  EQ ""
                                    AND bcomm-rate.acct       EQ acct.acct
                                    AND bcomm-rate.currency   EQ acct.currency
                                    AND bcomm-rate.kau        EQ ""
                                    AND bcomm-rate.MIN-VALUE  EQ 0
                                    AND bcomm-rate.period     EQ 0
                                    AND bcomm-rate.since      EQ tt-loan.open-date
            EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAIL bcomm-rate THEN
               CREATE bcomm-rate.
            ASSIGN
               bcomm-rate.commission = "%���"
               bcomm-rate.acct       = acct.acct
               bcomm-rate.currency   = acct.currency
               bcomm-rate.kau        = ""
               bcomm-rate.MIN-VALUE  = 0
               bcomm-rate.period     = 0
               bcomm-rate.since      = tt-loan.open-date
               bcomm-rate.rate-comm  = mMinRate
               .
            IF IsTemporal("comm-rate","��⥣���") THEN
               UpdateTempSignsEx("comm-rate",                                
                                bcomm-rate.commission        + "," +
                                bcomm-rate.acct              + "," +
                                bcomm-rate.currency          + "," +
                                PushSurr(bcomm-rate.kau)     + "," +
                                STRING(bcomm-rate.min-value) + "," +
                                STRING(bcomm-rate.period)    + "," +
                                STRING(bcomm-rate.since),
                                "��⥣���",
                                tt-loan.open-date,
                                STRING(mGrRiskVn),
                                ?).
            ELSE
               UpdateSignsEx("comm-rate",
                             bcomm-rate.commission        + "," +
                             bcomm-rate.acct              + "," +
                             bcomm-rate.currency          + "," +
                             PushSurr(bcomm-rate.kau)     + "," +
                             STRING(bcomm-rate.min-value) + "," +
                             STRING(bcomm-rate.period)    + "," +
                             STRING(bcomm-rate.since),
                             "��⥣���",
                             STRING(mGrRiskVn)).
         END.
         HIDE FRAME fRate.
      END.

   END.
      /* ��� ᢮���� ��䨪�� */
   IF     iMode EQ {&MOD_ADD}
      AND AVAIL tt-instance THEN
   DO:
      FIND FIRST b-loan WHERE
                 b-loan.contract  EQ tt-loan.contract
         AND     b-loan.cont-code EQ ENTRY(1, tt-loan.cont-code, " ")
      NO-LOCK NO-ERROR.
      IF     AVAIL b-loan 
         AND b-loan.class-code NE "loan-transh-ann" THEN
      DO:
         IF GetXAttrValue("loan", b-loan.contract + "," + b-loan.cont-code, "���������") EQ "��" THEN
         DO:
               /* �஢�ઠ ��䨪� � �ନ஢���� �६����� ⠡��� ��� ࠧ��᪨ �� �࠭蠬 */
            RUN CheckTermCorr (tt-loan.contract,
                               ENTRY(1, tt-loan.cont-code, " "),
                               OUTPUT vOK).
               /* �᫨ �� ��, ⮣�� ����᪠�� ����஢���� ࠧ��ᥭ���� �� �࠭蠬 ��䨪� �� �६�����
               ** ⠡��� � �����騥 ��䨪� �࠭襩. �।���⥫쭮 � �࠭襩 㤠������ ���� ��䨪� */
            IF vOK THEN
            DO:
               RUN DividTermSumm (tt-loan.contract,
                                  ENTRY(1, tt-loan.cont-code, " "))
               NO-ERROR.
                  /* ��ࠡ�⪠ �訡�� ᮧ����� ��䨪�� */
               IF    ERROR-STATUS:ERROR
                  OR RETURN-VALUE NE "" THEN
                  RUN Fill-SysMes IN h_tmess ("", "", "-1", RETURN-VALUE).
               ELSE
                  RUN Fill-SysMes IN h_tmess ("", "", "0",
                                              "�����᪠ ��䨪� �����襭�.").
            END.
         END.
      END.
   END.  /* ��� ᢮���� ��䨪�� */
   
  /* ��� ����� ��� � ����� ������� */
   IF     iMode EQ {&MOD_ADD}
          AND  mBag <> ""
   THEN DO:
      RUN bagadd.p (
         INPUT tt-loan.contract,
         INPUT tt-loan.cont-code,
         INPUT mBag,
         INPUT tt-loan.open-date,
         INPUT gEnd-date
         ) NO-ERROR .
         IF ERROR-STATUS :ERROR THEN DO:
            RUN Fill-SysMes IN h_tmess ("", "", "1", RETURN-VALUE).
         END.
   END.

   IF iMode EQ {&MOD_ADD} AND GetXAttrInit(tt-loan.class-code,"���睏�") EQ "��"
   THEN
   DO:          
      UpdateSigns(
         tt-loan.Class-Code,
         tt-loan.contract + "," + tt-loan.cont-code,
         "���_���",
         STRING(
            GetEpsLoan(
               tt-loan.contract, 
               tt-loan.cont-code,
               tt-loan.open-date) 
            * 100),
         ?).
   END.

   RUN DeleteOldDataProtocol IN h_base ("���㣫�������㡫��").

   vRaschInstr = GetXattrInit (tt-loan.Class-Code,"�������爭���").
   
   FIND FIRST loan WHERE 
              loan.contract  EQ tt-loan.contract
          AND loan.cont-code EQ ENTRY(1,tt-loan.cont-code," ")
          NO-LOCK NO-ERROR.
   
   IF     (AVAIL loan) 
      AND (vRaschInstr EQ "��") THEN
   DO:
      RUN Fill-SysMes IN h_tmess 
        ("","",4,"�������� ���� ᮪�饭��� ���⭮� ������樨. �㤥� �������?").
      IF pick-value EQ "yes" THEN
         RUN getsettl1.p(RECID(loan),loan.open-date).
   END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetTariffCommRate TERMINAL-SIMULATION
PROCEDURE SetTariffCommRate :
/*------------------------------------------------------------------------------
  Purpose:     ��⠭�������� �⠢�� �� ����
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEF INPUT PARAM iTariffCode AS CHAR NO-UNDO.
   DEF BUFFER comm-rate FOR comm-rate.

      /* �᫨ ��� ������, � ������� �⠢�� �� ���� �� ������� */
   IF     iTariffCode NE ?
      AND iTariffCode NE ""
      AND iTariffCode NE "?" THEN
   DO:
         /* �ﭥ� �� �⠢�� �� ���� ��� */
      cc:
      FOR EACH xbcomm-rate WHERE
               xbcomm-rate.kau       EQ "�த���," + iTariffCode
      BREAK BY commission:
         IF FIRST-OF(xbcomm-rate.commission) THEN
         DO:
            FIND LAST comm-rate WHERE               
                      comm-rate.kau        EQ xbcomm-rate.kau
                AND   comm-rate.commission EQ xbcomm-rate.commission
                AND   comm-rate.currency   EQ tt-loan.currency
                AND   comm-rate.since      LE tt-loan.open-date
            NO-LOCK NO-ERROR.
           IF   NOT AVAIL comm-rate 
             OR comm-rate.rate-comm LE 0 THEN
              NEXT cc.
 
            /* �᫨ �⠢�� 㦥 ����, � "��४�뢠��" �� ���祭�� �� ��� */
            FIND FIRST tt-comm-rate WHERE
                       tt-comm-rate.commission EQ comm-rate.commission
            NO-ERROR.
            IF NOT AVAIL tt-comm-rate THEN
               CREATE tt-comm-rate.    /* - ᮧ���� */
               /* � ���४�뢠��, �᫨ ��� */
            ASSIGN
               tt-comm-rate.commission      = comm-rate.commission
               tt-comm-rate.acct            = comm-rate.acct
               tt-comm-rate.currency        = comm-rate.currency
               tt-comm-rate.period          = comm-rate.period
               tt-comm-rate.rate-fixed      = comm-rate.rate-fixed
               tt-comm-rate.min-value       = comm-rate.min-value
               tt-comm-rate.since           = tt-loan-cond.since
               tt-comm-rate.rate-comm       = comm-rate.rate-comm
               tt-comm-rate.local__template = YES
               tt-comm-rate.local__id       = GetInstanceId("tt-comm-rate") + mI
               mI                           = mI + 1
            .
         END.
      END.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetTermObl TERMINAL-SIMULATION
PROCEDURE SetTermObl :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   /* �᫨ ⮫쪮 ᮧ���� �������, � ��� ����� ���� ����୮�,
   ** ���ਬ��, �᫨ ᭠砫� ����� ������ �᪫��.,
   ** � ��⮬ �����﫨 ���� ������ */
   IF iMode EQ {&MOD_ADD} THEN
       FOR EACH ttTermObl:
           ttTermObl.end-date = tt-loan-cond.since.
       END.

/* �᫨ ����楢 �᪫�祭�� ��� � �� �뫮, � �� �⮬ �஢�ન �����襭� */
   IF NOT CAN-FIND(FIRST ttTermObl WHERE ttTermObl.idnt = 200 NO-LOCK)
      AND tt-monthout.contract = "" THEN .


   /*�᫨ �뫨 ������ �᪫�祭��, � �㦭� �� ��������*/

   /* �᫨ ������ �᪫�祭�� �뫨. �� ⥯��� �� �� 㤠���� (��) */
   ELSE IF NOT CAN-FIND(FIRST ttTermObl WHERE ttTErmObl.idnt = 200 NO-LOCK)
       THEN DO:
       FOR EACH tt-monthout:
           tt-monthout.user__mode = {&MOD_DELETE}.
       END.
   END.

   ELSE DO:

      /* ��⨬ ⠡���� ���楢 �᪫�祭�� */
      FOR EACH tt-monthout:
         FIND FIRST ttTermObl WHERE
                    ttTermObl.contract = tt-monthout.contract
                AND ttTermObl.cont-code = tt-monthout.cont-code
                AND ttTermObl.end-date = tt-monthout.end-date
                AND ttTermObl.idnt = tt-monthout.idnt
                AND ttTermObl.nn = tt-monthout.nn
             NO-ERROR.

         IF NOT AVAIL ttTermObl THEN
            tt-monthout.user__mode = {&MOD_DELETE}.
      END.

       /* ������塞 ⠡���� ��� ����묨 �� ��ଥ���� ⠡���� */
       FOR EACH ttTermObl WHERE
                ttTermObl.contract = tt-loan.contract
            AND ttTermObl.cont-code = tt-loan.cont-code
            AND ttTermObl.idnt = 200:

          FIND FIRST tt-monthout WHERE
                     tt-monthout.contract = ttTermObl.contract
                 AND tt-monthout.cont-code = ttTermObl.cont-code
                 AND tt-monthout.end-date = ttTermObl.end-date
                 AND tt-monthout.idnt = ttTermObl.idnt
                 AND tt-monthout.nn = ttTermObl.nn
              NO-ERROR.


          IF NOT AVAIL tt-monthout THEN
          DO:

              CREATE tt-monthout.
              FOR EACH b-monthout BY b-monthout.Local__Id DESC:
                 LEAVE.
              END.
              ASSIGN
                 tt-monthout.Local__UpId = tt-loan.local__Id.
                 tt-monthout.Local__Id = IF AVAIL b-monthout THEN
                                        MAX(GetInstanceId("tt-monthout"),
                                            b-monthout.Local__Id) + 1
                                        ELSE GetInstanceId("tt-monthout") + 1.

          END.

          BUFFER-COPY ttTermObl TO tt-monthout.

          RELEASE tt-monthout.

       END.
   END.

   /* �᫨ �ᮡ�� ����楢 ��� � �� �뫮, � �� �⮬ �஢�ન �����襭� */
   IF NOT CAN-FIND(FIRST ttTermObl WHERE ttTermObl.idnt = 201 NO-LOCK)
      AND tt-monthspec.contract = "" THEN .


   /*�᫨ �뫨 �ᮡ� ������, � �㦭� �� ��������*/

   /* �᫨ �ᮡ� ������ �뫨, �� ⥯��� �� �� 㤠���� (��) */
   ELSE IF NOT CAN-FIND(FIRST ttTermObl WHERE ttTermObl.idnt = 201 NO-LOCK)
       THEN DO:
       FOR EACH tt-monthspec:
           tt-monthspec.user__mode = {&MOD_DELETE}.
       END.
   END.

   ELSE DO:

      /* ��⨬ ⠡���� ���楢 �᪫�祭�� */
      FOR EACH tt-monthspec:
         FIND FIRST ttTermObl WHERE
                    ttTermObl.contract = tt-monthspec.contract
                AND ttTermObl.cont-code = tt-monthspec.cont-code
                AND ttTermObl.idnt = tt-monthspec.idnt
                AND ttTermObl.nn = tt-monthspec.nn
             NO-ERROR.
         IF NOT AVAIL ttTermObl THEN
         tt-monthspec.user__mode = {&MOD_DELETE}.
      END.

       /* ������塞 ⠡���� ��� ����묨 �� ��ଥ���� ⠡���� */
       FOR EACH ttTermObl WHERE
                ttTermObl.contract = tt-loan.contract
            AND ttTermObl.cont-code = tt-loan.cont-code
            AND ttTermObl.idnt = 201:

          FIND FIRST tt-monthspec WHERE
                     tt-monthspec.contract = ttTermObl.contract
                 AND tt-monthspec.cont-code = ttTermObl.cont-code
                 AND tt-monthspec.end-date = ttTermObl.end-date
                 AND tt-monthspec.idnt = ttTermObl.idnt
                 AND tt-monthspec.nn = ttTermObl.nn
              NO-ERROR.

          IF NOT AVAIL tt-monthspec THEN
          DO:

              CREATE tt-monthspec.
              FOR EACH b-monthspec BY b-monthspec.Local__Id DESC:
                 LEAVE.
              END.
              ASSIGN
                 tt-monthspec.Local__UpId = tt-loan.local__Id.
                 tt-monthspec.Local__Id = IF AVAIL b-monthspec THEN
                                        MAX(GetInstanceId("tt-monthspec"),
                                            b-monthspec.Local__Id) + 1
                                        ELSE GetInstanceId("tt-montspec") + 1.

          END.

          BUFFER-COPY ttTermObl TO tt-monthspec.

          RELEASE tt-monthspec.

       END.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ModCommRate TERMINAL-SIMULATION
PROCEDURE ModCommRate:
/*------------------------------------------------------------------------------
  Purpose: ����䨪��� �⠢��
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   DEF INPUT PARAM iProd AS CHAR NO-UNDO.   /* �த�� */

   DEF VAR vZnak AS CHAR NO-UNDO.

   DEF BUFFER comm-rate FOR comm-rate.

   FOR EACH tt-comm-rate:
      FIND LAST comm-rate WHERE
                comm-rate.kau        EQ "����䨪���," + iProd
            AND comm-rate.commission EQ tt-comm-rate.commission
            AND comm-rate.since      LE tt-loan.open-date
      NO-LOCK NO-ERROR.
      IF AVAIL comm-rate THEN DO:
         vZnak = GetXAttrValueEx("comm-rate",
                                 GetSurrogateBuffer("comm-rate",
                                                    (BUFFER comm-rate:HANDLE)
                                                    ),
                                 "�������",
                                 "+").
         CASE vZnak:
            WHEN "+" THEN
               tt-comm-rate.rate-comm = tt-comm-rate.rate-comm + comm-rate.rate-comm.
            WHEN "-" THEN
               tt-comm-rate.rate-comm = tt-comm-rate.rate-comm - comm-rate.rate-comm.
         END CASE.
      END.
   END.
END PROCEDURE. /* ModCommRate */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CheckCliAcct TERMINAL-SIMULATION
FUNCTION CheckCliAcct RETURNS LOGICAL
  ( INPUT iAcctType AS CHAR,
    INPUT iAcct AS CHAR,
    INPUT iCurr AS CHAR,
    INPUT iCat AS CHAR,
    INPUT iId AS INT64 ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
   DEFINE VARIABLE vRet AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE vChk AS CHARACTER  NO-UNDO.
   vChk = GetBufferValue("code",
                         "where code.class = '����焮�' and code.parent = '����焮�'" +
                         "   and code.code = '" + iAcctType + "'",
                         "misc").
   vChk = ENTRY(1,vChk,CHR(1)).
   vRet = YES.
   IF CAN-DO("��,Yes",vChk) THEN
      vRet =  GetBufferValue("acct",
                             "where acct = '" + iAcct + "'" +
                             "  and currency = '" + iCurr + "'" +
                             "  and cust-cat = '" + iCat + "'" +
                             "  and cust-id = " + STRING(iId),
                             "acct") EQ iAcct.
   RETURN vRet.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetQntPer TERMINAL-SIMULATION
FUNCTION GetQntPer RETURNS INT64 (
   INPUT iBegDate  AS DATE, /* ��� ������ ������� */
   INPUT iEndDate  AS DATE, /* ��� ������� ������� */
   INPUT iPayDay   AS INT64,  /* �᫮, ���. �ந����. ������ (⮫쪮 � � �) */
   INPUT iGlInt    AS CHAR, /* ���ࢠ� �/� ������묨 �����ﬨ */
   INPUT iCondBegD AS DATE  /* ��� ��砫� �᫮���, �ᯮ������ �� ���� ���� �� � ��� ��
                             ** �᫨ ? � ��ࠡ��뢠�� ���.�஢�ઠ �� �㤥� */
):

   DEF VAR mCurDate     AS DATE   NO-UNDO. /* ��।��� ��� ���⥦� */
   DEF VAR mCurDateOld  AS DATE   NO-UNDO. /* ���� ��� ��।���� ���⥦� */
   DEF VAR mPerCnt      AS INT64    NO-UNDO. /* ���稪 ��ਮ��� */

   mCurDate = iBegDate.

      /* ��⠥� �᫮ ��ਮ��� */
   CNT:
   DO WHILE mCurDate < iEndDate:
      IF mCurDateOld EQ mCurDate
      THEN
         mCurDate = mCurDate + 1.
      mCurDateOld = mCurDate.
      mCurDate = FRST_DATE(mCurDate,
                           iEndDate,
                           iPayDay,
                           iGlInt,
                           iCondBegD).

      /* ��� �������� � ����� ��� ����襭�� */
      IF (CAN-FIND (FIRST ttTermObl WHERE ttTermObl.contract  EQ tt-loan.contract
                                     AND ttTermObl.cont-code EQ tt-loan.cont-code
                                     AND ttTermObl.idnt      EQ 200
                                     AND INT64(ttTermObl.amt)  EQ MONTH(mCurDate)
                                     AND ttTermObl.end-date  LE mCurDate
                   NO-LOCK)
         /* � ����� � ���� ���� ��� � ᯨ᪥ �������� */
         AND NOT CAN-FIND
                  (FIRST ttTermObl WHERE ttTermObl.contract   EQ tt-loan.contract
                                     AND ttTermObl.cont-code  EQ tt-loan.cont-code
                                     AND ttTermObl.idnt       EQ 201
                                     AND ttTermObl.sop-offbal EQ 1         /* �������� */
                                     AND INT64(ttTermObl.amt)   EQ MONTH(mCurDate)
                                     AND INT64(ttTermObl.sop)   EQ YEAR (mCurDate)
                   NO-LOCK))
         /* ��� ����� � ��� ���� ���� � ᯨ᪥ ��������� */
         OR CAN-FIND
                  (FIRST ttTermObl WHERE ttTermObl.contract   EQ tt-loan.contract
                                     AND ttTermObl.cont-code  EQ tt-loan.cont-code
                                     AND ttTermObl.idnt       EQ 201
                                     AND ttTermObl.sop-offbal NE 1         /* ��������� */
                                     AND INT64(ttTermObl.amt)   EQ MONTH(mCurDate)
                                     AND INT64(ttTermObl.sop)   EQ YEAR (mCurDate)
                   NO-LOCK)
      THEN NEXT CNT.    /* �� ��⠥� �᪫�祭�� ������ */
      mPerCnt = mPerCnt + 1.
   END.
   RETURN mPerCnt.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

