&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 Character
&ANALYZE-RESUME
/* Connected Databases 
          bisquit          PROGRESS
*/
&Scoped-define WINDOW-NAME TERMINAL-SIMULATION


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-banks NO-UNDO LIKE banks
       FIELD okato$ AS CHARACTER /* ����� */
       FIELD abwawtik$ AS CHARACTER /* ���騪 */
       FIELD arhiv$ AS LOGICAL /* ��娢 */
       FIELD bankwemitent$ AS CHARACTER /* �������⥭� */
       FIELD bik$ AS CHARACTER /* ��� */
       FIELD blok$ AS LOGICAL /* ���� */
       FIELD vidbanklic$ AS CHARACTER /* ���������� */
       FIELD viddewat$ AS CHARACTER /* ������� */
       FIELD vidkli$ AS CHARACTER /* ������ */
       FIELD gvk$ AS CHARACTER /* ��� */
       FIELD grawzd$ AS CHARACTER /* �ࠦ� */
       FIELD dataizm$ AS DATE /* ��⠈�� */
       FIELD datakontrolwa$ AS DATE /* ��⠊���஫� */
       FIELD dko$ AS DECIMAL /* ��� */
       FIELD dkowe$ AS DECIMAL /* ���� */
       FIELD dogovor_s_mci$ AS CHARACTER /* �������_�_��� */
       FIELD iin$ AS CHARACTER /* ��� */
       FIELD istoriwakl$ AS CHARACTER /* ���� */
       FIELD klient$ AS CHARACTER /* ������ */
       FIELD klientuf$ AS LOGICAL /* �����ⓔ */
       FIELD kodklienta$ AS CHARACTER /* ��������� */
       FIELD kop$ AS INT64 /* ��� */
       FIELD kopf$ AS INT64 /* ���� */
       FIELD kpp$ AS CHARACTER /* ��� */
       FIELD materinkomp$ AS CHARACTER /* ����������� */
       FIELD mbr$ AS LOGICAL /* ��� */
       FIELD neupolbank$ AS LOGICAL /* ���������� */
       FIELD obosobpodr$ AS CHARACTER /* ���ᮡ���� */
       FIELD ogrn$ AS CHARACTER /* ���� */
       FIELD okato-nalog$ AS CHARACTER /* �����-����� */
       FIELD okvwed$ AS CHARACTER /* ����� */
       FIELD okopf$ AS CHARACTER /* ����� */
       FIELD ofwsor$ AS CHARACTER /* ���� */
       FIELD ocenkariska$ AS CHARACTER /* �業����᪠ */
       FIELD pokrytie$ AS LOGICAL /* �����⨥ */
       FIELD postkorresp$ AS CHARACTER /* ���⊮��� */
       FIELD preemnik$ AS CHARACTER /* �॥���� */
       FIELD prim1$ AS CHARACTER /* �ਬ1 */
       FIELD prim2$ AS CHARACTER /* �ਬ2 */
       FIELD prim3$ AS CHARACTER /* �ਬ3 */
       FIELD prim4$ AS CHARACTER /* �ਬ4 */
       FIELD prim5$ AS CHARACTER /* �ਬ5 */
       FIELD prim6$ AS CHARACTER /* �ਬ6 */
       FIELD prisutorguprav$ AS CHARACTER /* �����࣓�ࠢ */
       FIELD riskotmyv$ AS CHARACTER /* ��᪎�� */
       FIELD svedvygdrlica$ AS CHARACTER /* �����룄���� */
       FIELD struktorg$ AS CHARACTER /* ������ */
       FIELD subw%ekt$ AS CHARACTER /* ��ꥪ� */
       FIELD unk$ AS DECIMAL /* ��� */
       FIELD unkg$ AS INT64 /* ���� */
       FIELD ustavkap$ AS CHARACTER /* ��⠢��� */
       FIELD uwcastniknop$ AS CHARACTER /* ���⭨���� */
       FIELD uwcdokgr$ AS CHARACTER /* �焮��� */
       FIELD uwcredorg$ AS CHARACTER /* ��।�� */
       FIELD fiobuhg$ AS CHARACTER /* ������ */
       FIELD fioruk$ AS CHARACTER /* ����� */
       FIELD formsobs$ AS CHARACTER /* ��଑��� */
       FIELD formsobs_118$ AS CHARACTER /* ��଑���_118 */
       FIELD bank-stat AS CHARACTER /* bank-stat */
       FIELD branch-id AS CHARACTER /* branch-id */
       FIELD branch-list AS CHARACTER /* branch-list */
       FIELD brand-name AS CHARACTER /* brand-name */
       FIELD contr_group AS CHARACTER /* contr_group */
       FIELD contr_type AS CHARACTER /* contr_type */
       FIELD country-id2 AS CHARACTER /* country-id2 */
       FIELD country-id3 AS CHARACTER /* country-id3 */
       FIELD CountryCode AS CHARACTER /* CountryCode */
       FIELD DataLic AS DATE /* DataLic */
       FIELD date-export AS CHARACTER /* date-export */
       FIELD e-mail AS CHARACTER /* e-mail */
       FIELD engl-name AS CHARACTER /* engl-name */
       FIELD fax AS CHARACTER /* fax */
       FIELD HistoryFields AS CHARACTER /* HistoryFields */
       FIELD holding-id AS CHARACTER /* holding-id */
       FIELD IndCode AS CHARACTER /* IndCode */
       FIELD inter-region AS CHARACTER /* inter-region */
       FIELD LegTerr AS CHARACTER /* LegTerr */
       FIELD lic-sec AS CHARACTER /* lic-sec */
       FIELD LocCustType AS CHARACTER /* LocCustType */
       FIELD mess AS CHARACTER /* mess */
       FIELD NACE AS CHARACTER /* NACE */
       FIELD Netting AS LOGICAL /* Netting */
       FIELD new1 AS CHARACTER /* new1 */
       FIELD NoExport AS LOGICAL /* NoExport */
       FIELD num_contr AS INT64 /* num_contr */
       FIELD okonx AS CHARACTER /* okonx */
       FIELD okpo AS CHARACTER /* okpo */
       FIELD Prim-ID AS CHARACTER /* Prim-ID */
       FIELD real AS CHARACTER /* real */
       FIELD RegDate AS CHARACTER /* RegDate */
       FIELD region AS CHARACTER /* region */
       FIELD RegNum AS CHARACTER /* RegNum */
       FIELD RegPlace AS CHARACTER /* RegPlace */
       FIELD Soato AS CHARACTER /* Soato */
       FIELD swift-address AS CHARACTER /* swift-address */
       FIELD swift-name AS CHARACTER /* swift-name */
       FIELD tel AS CHARACTER /* tel */
       FIELD test1 AS CHARACTER /* test1 */
       FIELD uer AS CHARACTER /* uer */
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
       /* Additional fields you should place here                      */
       
       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-banks" "" }
       .
DEFINE TEMP-TABLE tt-InnBank NO-UNDO LIKE cust-ident
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
       /* Additional fields you should place here                      */
       
       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-InnBank" "InnBank" }
       .
DEFINE TEMP-TABLE tt-MFO-9 NO-UNDO LIKE banks-code
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
       /* Additional fields you should place here                      */
       
       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-MFO-9" "MFO-9" }
       .
DEFINE TEMP-TABLE tt-Regn NO-UNDO LIKE banks-code
       FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
       FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
       FIELD local__id       AS INT64   /* �����䨪��� �����     */
       FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
       FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
       /* Additional fields you should place here                      */
       
       /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
       {ln-tthdl.i "tt-Regn" "Regn" }
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS TERMINAL-SIMULATION 
/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: F-BANKS.P
      Comment: <comment>
   Parameters:
         Uses:
      Used by:
      Created: 30.11.2005 16:02 ILVI    
     Modified: 15/11/2012 ccc  (0133400) ��ࠡ�⠭� ��ࠡ�⪠ ���
*/
/*          This file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Commented by KSV: ����� 蠡��� �।�����祭 ��� ᮧ����� ��࠭��� ���
** �����⢫��饩 ����������, ��������� � ��ᬮ�� ���ଠ樨 �� ��ꥪ�
** ����奬� �������� ��� �����।�⢥����� ���饭�� � ���� ������.
**
** ���� �� ᮧ����� ��࠭��� ���:
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
**    9. ��� ��।�� ᯥ���᪨� ��ࠬ��஢ ��楤�� ��࠭��� ���
**       ��ᯮ����� �㭪�ﬨ ������⥪� PP-TPARA.P
**   10. ���ᠭ�� ��६����� ��� �ࠢ����� ��࠭��� �ମ� ��室���� � ᥪ樨
**       Definitions ������⥪� bis-tty.pro 
**   11. ���ᠭ�� TEMP-TABL'��
*/
{globals.i}
{intrface.get cust}     /* ������⥪� ��� ࠡ��� � �����⠬�. */
{intrface.get tmess}    /* ������⥪� ��⥬��� ᮮ�饭��     */

&IF DEFINED(SESSION-REMOTE) EQ 0 &THEN
CREATE WIDGET-POOL.
&ENDIF
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

/* ��� ��ᬮ�� ����祭��� mInstance � GetObject */
/* &GLOBAL-DEFINE DEBUG-INSTANCE-GET */

/* ��� ��ᬮ�� mInstance ��। ������� � ���� � SetObject */
/* &GLOBAL-DEFINE DEBUG-INSTANCE-SET */

/* ����᫮���� ����祭��\�⪫�祭�� �맮�� xattr-ed 
(���� �� ��뢠���� �� ����稥 ������������� ��易⥫��� ४����⮢ */
/*
&GLOBAL-DEFINE XATTR-ED-OFF
&GLOBAL-DEFINE XATTR-ED-ON 
*/

DEFINE VARIABLE mType     AS CHARACTER  NO-UNDO.  /* ⨯ ����⨨䪠�� ����� */
DEFINE VARIABLE mClass    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mClient   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mTempVal  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mTempFlg  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mFlagUnk  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mTmpUnk   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mResCntry AS CHARACTER   NO-UNDO.

DEFINE BUFFER bCust-Ident FOR cust-ident.

&GLOBAL-DEFINE FlowFields  tt-banks.unk$
/* �஢����� �ࠢ� �� ��㯯� ४����⮢ */
&GLOBAL-DEFINE CHECK-XATTR-GROUP-PERMISSION

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-banks tt-regn tt-MFO-9 tt-InnBank

/* Definitions for FRAME fMain                                          */
&Scoped-define FIELDS-IN-QUERY-fMain tt-banks.date-in tt-banks.last-date ~
tt-banks.date-out tt-banks.unk$ tt-banks.client tt-banks.flag-rkc ~
tt-banks.vidbanklic$ tt-banks.bank-type tt-banks.bank-stat ~
tt-banks.short-name tt-banks.name tt-banks.country tt-banks.region ~
tt-banks.country-id tt-banks.town-type tt-banks.town tt-banks.tax-insp ~
tt-banks.law-address tt-banks.mail-address tt-MFO-9.bank-code ~
tt-Regn.bank-code tt-InnBank.cust-code tt-banks.uer tt-banks.okvwed$ ~
tt-banks.kpp$ tt-banks.okonx tt-banks.okpo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-fMain tt-banks.date-in ~
tt-banks.last-date tt-banks.date-out tt-banks.unk$ tt-banks.client ~
tt-banks.flag-rkc tt-banks.vidbanklic$ tt-banks.bank-type ~
tt-banks.bank-stat tt-banks.short-name tt-banks.name tt-banks.country ~
tt-banks.region tt-banks.country-id tt-banks.town-type tt-banks.town ~
tt-banks.tax-insp tt-banks.law-address tt-banks.mail-address ~
tt-MFO-9.bank-code tt-Regn.bank-code tt-InnBank.cust-code tt-banks.uer ~
tt-banks.okvwed$ tt-banks.kpp$ tt-banks.okonx tt-banks.okpo 
&Scoped-define ENABLED-TABLES-IN-QUERY-fMain tt-banks tt-MFO-9 tt-Regn ~
tt-InnBank
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-fMain tt-banks
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-fMain tt-MFO-9
&Scoped-define THIRD-ENABLED-TABLE-IN-QUERY-fMain tt-Regn
&Scoped-define FOURTH-ENABLED-TABLE-IN-QUERY-fMain tt-InnBank
&Scoped-define QUERY-STRING-fMain FOR EACH tt-banks SHARE-LOCK, ~
      EACH tt-regn WHERE TRUE /* Join to tt-banks incomplete */ SHARE-LOCK, ~
      EACH tt-MFO-9 WHERE TRUE /* Join to tt-banks incomplete */ SHARE-LOCK, ~
      EACH tt-InnBank WHERE TRUE /* Join to tt-banks incomplete */ SHARE-LOCK
&Scoped-define OPEN-QUERY-fMain OPEN QUERY fMain FOR EACH tt-banks SHARE-LOCK, ~
      EACH tt-regn WHERE TRUE /* Join to tt-banks incomplete */ SHARE-LOCK, ~
      EACH tt-MFO-9 WHERE TRUE /* Join to tt-banks incomplete */ SHARE-LOCK, ~
      EACH tt-InnBank WHERE TRUE /* Join to tt-banks incomplete */ SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-fMain tt-banks tt-regn tt-MFO-9 tt-InnBank
&Scoped-define FIRST-TABLE-IN-QUERY-fMain tt-banks
&Scoped-define SECOND-TABLE-IN-QUERY-fMain tt-regn
&Scoped-define THIRD-TABLE-IN-QUERY-fMain tt-MFO-9
&Scoped-define FOURTH-TABLE-IN-QUERY-fMain tt-InnBank


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-banks.date-in tt-banks.last-date ~
tt-banks.date-out tt-banks.unk$ tt-banks.client tt-banks.flag-rkc ~
tt-banks.vidbanklic$ tt-banks.bank-type tt-banks.bank-stat ~
tt-banks.short-name tt-banks.name tt-banks.country tt-banks.region ~
tt-banks.country-id tt-banks.town-type tt-banks.town tt-banks.tax-insp ~
tt-banks.law-address tt-banks.mail-address tt-MFO-9.bank-code ~
tt-Regn.bank-code tt-InnBank.cust-code tt-banks.uer tt-banks.okvwed$ ~
tt-banks.kpp$ tt-banks.okonx tt-banks.okpo 
&Scoped-define ENABLED-TABLES tt-banks tt-MFO-9 tt-Regn tt-InnBank
&Scoped-define FIRST-ENABLED-TABLE tt-banks
&Scoped-define SECOND-ENABLED-TABLE tt-MFO-9
&Scoped-define THIRD-ENABLED-TABLE tt-Regn
&Scoped-define FOURTH-ENABLED-TABLE tt-InnBank
&Scoped-Define DISPLAYED-FIELDS tt-banks.date-in tt-banks.last-date ~
tt-banks.date-out tt-banks.unk$ tt-banks.client tt-banks.flag-rkc ~
tt-banks.vidbanklic$ tt-banks.bank-type tt-banks.bank-stat ~
tt-banks.short-name tt-banks.name tt-banks.country tt-banks.region ~
tt-banks.country-id tt-banks.town-type tt-banks.town tt-banks.tax-insp ~
tt-banks.law-address tt-banks.mail-address tt-MFO-9.bank-code ~
tt-Regn.bank-code tt-InnBank.cust-code tt-banks.uer tt-banks.okvwed$ ~
tt-banks.kpp$ tt-banks.okonx tt-banks.okpo 
&Scoped-define DISPLAYED-TABLES tt-banks tt-MFO-9 tt-Regn tt-InnBank
&Scoped-define FIRST-DISPLAYED-TABLE tt-banks
&Scoped-define SECOND-DISPLAYED-TABLE tt-MFO-9
&Scoped-define THIRD-DISPLAYED-TABLE tt-Regn
&Scoped-define FOURTH-DISPLAYED-TABLE tt-InnBank


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 tt-banks.date-in tt-banks.unk$ tt-banks.client ~
tt-banks.flag-rkc tt-banks.vidbanklic$ tt-banks.bank-type ~
tt-banks.bank-stat tt-banks.short-name tt-banks.name tt-banks.region ~
tt-banks.country-id tt-banks.town-type tt-banks.town tt-banks.tax-insp ~
tt-banks.law-address tt-banks.mail-address tt-MFO-9.bank-code ~
tt-Regn.bank-code tt-InnBank.cust-code tt-banks.uer tt-banks.okvwed$ ~
tt-banks.kpp$ tt-banks.okonx tt-banks.okpo 
&Scoped-define List-2 tt-banks.date-in tt-banks.date-out tt-banks.unk$ ~
tt-banks.client tt-banks.flag-rkc tt-banks.vidbanklic$ tt-banks.bank-type ~
tt-banks.bank-stat tt-banks.short-name tt-banks.name tt-banks.region ~
tt-banks.country-id tt-banks.town-type tt-banks.town tt-banks.tax-insp ~
tt-banks.law-address tt-banks.mail-address tt-MFO-9.bank-code ~
tt-Regn.bank-code tt-InnBank.cust-code tt-banks.uer tt-banks.okvwed$ ~
tt-banks.kpp$ tt-banks.okonx tt-banks.okpo 
&Scoped-define List-3 tt-banks.date-in tt-banks.last-date tt-banks.date-out ~
tt-banks.unk$ tt-banks.client tt-banks.flag-rkc tt-banks.vidbanklic$ ~
tt-banks.bank-type tt-banks.bank-stat tt-banks.short-name tt-banks.name ~
tt-banks.country tt-banks.region tt-banks.country-id tt-banks.town-type ~
tt-banks.town tt-banks.tax-insp tt-banks.law-address tt-banks.mail-address ~
tt-MFO-9.bank-code tt-Regn.bank-code tt-InnBank.cust-code tt-banks.uer ~
tt-banks.okvwed$ tt-banks.kpp$ tt-banks.okonx tt-banks.okpo 
&Scoped-define List-4 tt-banks.date-in tt-banks.bank-type ~
tt-banks.bank-stat tt-MFO-9.bank-code tt-Regn.bank-code ~
tt-InnBank.cust-code tt-banks.uer 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY fMain FOR 
      tt-banks, 
      tt-regn, 
      tt-MFO-9, 
      tt-InnBank SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     tt-banks.date-in
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 17 COLON-ALIGNED
          &ELSE AT ROW 1 COL 17 COLON-ALIGNED &ENDIF
          LABEL "��� ���������"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-banks.last-date
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 63 COLON-ALIGNED
          &ELSE AT ROW 1 COL 63 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
          &ELSE SIZE 13 BY 1 &ENDIF
     tt-banks.date-out
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 2 COL 17 COLON-ALIGNED
          &ELSE AT ROW 2 COL 17 COLON-ALIGNED &ENDIF HELP
          "��� �室� ������-�����"
          LABEL "��� �室�" FORMAT "99/99/99"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-banks.unk$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 17 COLON-ALIGNED
          &ELSE AT ROW 2.99 COL 17 COLON-ALIGNED &ENDIF HELP
          ""
          LABEL "���" FORMAT "999999999999999"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 15 BY 1
          &ELSE SIZE 15 BY 1 &ENDIF
     tt-banks.client
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 3 COL 63 COLON-ALIGNED
          &ELSE AT ROW 3 COL 63 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
          &ELSE SIZE 9 BY 1 &ENDIF
     tt-banks.flag-rkc
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 17 COLON-ALIGNED
          &ELSE AT ROW 4 COL 17 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
          &ELSE SIZE 9 BY 1 &ENDIF
     tt-banks.vidbanklic$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 63 COLON-ALIGNED
          &ELSE AT ROW 4 COL 63 COLON-ALIGNED &ENDIF
          LABEL "��� ��業���"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-banks.bank-type
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 17 COLON-ALIGNED
          &ELSE AT ROW 5 COL 17 COLON-ALIGNED &ENDIF HELP
          "����� ����� (�, ��, ���, ���, ...)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 11 BY 1
          &ELSE SIZE 11 BY 1 &ENDIF
     tt-banks.bank-stat
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 63 COLON-ALIGNED
          &ELSE AT ROW 5 COL 63 COLON-ALIGNED &ENDIF
          LABEL "�����(��-�ࠢ �ଠ)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-banks.short-name
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 6 COL 17 COLON-ALIGNED
          &ELSE AT ROW 5.99 COL 17 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 27 BY 1
          &ELSE SIZE 27 BY 1 &ENDIF
     tt-banks.name
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 7 COL 17 COLON-ALIGNED
          &ELSE AT ROW 7 COL 17 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 59 BY 1
          &ELSE SIZE 59 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-banks.country
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 8 COL 17 COLON-ALIGNED
          &ELSE AT ROW 8 COL 17 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 27 BY 1
          &ELSE SIZE 27 BY 1 &ENDIF
     tt-banks.region
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 8 COL 63 COLON-ALIGNED
          &ELSE AT ROW 8 COL 63 COLON-ALIGNED &ENDIF
          LABEL "��� ॣ����"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-banks.country-id
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 17 COLON-ALIGNED
          &ELSE AT ROW 9 COL 17 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
          &ELSE SIZE 9 BY 1 &ENDIF
     tt-banks.town-type
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 10 COL 17 COLON-ALIGNED
          &ELSE AT ROW 10 COL 17 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 14 BY 1
          &ELSE SIZE 14 BY 1 &ENDIF
     tt-banks.town
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 11 COL 17 COLON-ALIGNED
          &ELSE AT ROW 11 COL 17 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 27 BY 1
          &ELSE SIZE 27 BY 1 &ENDIF
     tt-banks.tax-insp
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 17 COLON-ALIGNED
          &ELSE AT ROW 12 COL 17 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 18 BY 1
          &ELSE SIZE 18 BY 1 &ENDIF
     tt-banks.law-address
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 17 COLON-ALIGNED
          &ELSE AT ROW 13 COL 17 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 59 BY 1
          &ELSE SIZE 59 BY 1 &ENDIF
     tt-banks.mail-address
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 17 COLON-ALIGNED
          &ELSE AT ROW 14 COL 17 COLON-ALIGNED &ENDIF
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 59 BY 1
          &ELSE SIZE 59 BY 1 &ENDIF
     tt-MFO-9.bank-code
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 17 COLON-ALIGNED
          &ELSE AT ROW 15 COL 17 COLON-ALIGNED &ENDIF HELP
          "������ 9-����� ��� ����� (�᫨ ����)"
          LABEL "����� ���" FORMAT "x(9)"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     tt-Regn.bank-code
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 17 COLON-ALIGNED
          &ELSE AT ROW 16 COL 17 COLON-ALIGNED &ENDIF HELP
          "������ ॣ����樮��� ����� ����� (�᫨ ����)"
          LABEL "���.�����"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 21.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMain
     tt-InnBank.cust-code
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 17 COLON-ALIGNED
          &ELSE AT ROW 17 COL 17 COLON-ALIGNED &ENDIF HELP
          "������ ��� ����� (�᫨ ����)"
          LABEL "���"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
          &ELSE SIZE 22 BY 1 &ENDIF
     tt-banks.uer
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 17 COL 63 COLON-ALIGNED
          &ELSE AT ROW 17 COL 63 COLON-ALIGNED &ENDIF
          LABEL "��.��.���⮢"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-banks.okvwed$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 17 COLON-ALIGNED
          &ELSE AT ROW 18 COL 17 COLON-ALIGNED &ENDIF
          LABEL "��� �����"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-banks.kpp$
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 18 COL 63 COLON-ALIGNED
          &ELSE AT ROW 18 COL 63 COLON-ALIGNED &ENDIF
          LABEL "���"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-banks.okonx
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 17 COLON-ALIGNED
          &ELSE AT ROW 19 COL 17 COLON-ALIGNED &ENDIF
          LABEL "��� �����"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
     tt-banks.okpo
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 19 COL 63 COLON-ALIGNED
          &ELSE AT ROW 19 COL 63 COLON-ALIGNED &ENDIF
          LABEL "��� ����"
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
          &ELSE SIZE 10 BY 1 &ENDIF
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
      TABLE: tt-banks T "?" NO-UNDO bisquit banks
      ADDITIONAL-FIELDS:
          FIELD okato$ AS CHARACTER /* ����� */
          FIELD abwawtik$ AS CHARACTER /* ���騪 */
          FIELD arhiv$ AS LOGICAL /* ��娢 */
          FIELD bankwemitent$ AS CHARACTER /* �������⥭� */
          FIELD bik$ AS CHARACTER /* ��� */
          FIELD blok$ AS LOGICAL /* ���� */
          FIELD vidbanklic$ AS CHARACTER /* ���������� */
          FIELD viddewat$ AS CHARACTER /* ������� */
          FIELD vidkli$ AS CHARACTER /* ������ */
          FIELD gvk$ AS CHARACTER /* ��� */
          FIELD grawzd$ AS CHARACTER /* �ࠦ� */
          FIELD dataizm$ AS DATE /* ��⠈�� */
          FIELD datakontrolwa$ AS DATE /* ��⠊���஫� */
          FIELD dko$ AS DECIMAL /* ��� */
          FIELD dkowe$ AS DECIMAL /* ���� */
          FIELD dogovor_s_mci$ AS CHARACTER /* �������_�_��� */
          FIELD iin$ AS CHARACTER /* ��� */
          FIELD istoriwakl$ AS CHARACTER /* ���� */
          FIELD klient$ AS CHARACTER /* ������ */
          FIELD klientuf$ AS LOGICAL /* �����ⓔ */
          FIELD kodklienta$ AS CHARACTER /* ��������� */
          FIELD kop$ AS INT64 /* ��� */
          FIELD kopf$ AS INT64 /* ���� */
          FIELD kpp$ AS CHARACTER /* ��� */
          FIELD materinkomp$ AS CHARACTER /* ����������� */
          FIELD mbr$ AS LOGICAL /* ��� */
          FIELD neupolbank$ AS LOGICAL /* ���������� */
          FIELD obosobpodr$ AS CHARACTER /* ���ᮡ���� */
          FIELD ogrn$ AS CHARACTER /* ���� */
          FIELD okato-nalog$ AS CHARACTER /* �����-����� */
          FIELD okvwed$ AS CHARACTER /* ����� */
          FIELD okopf$ AS CHARACTER /* ����� */
          FIELD ofwsor$ AS CHARACTER /* ���� */
          FIELD ocenkariska$ AS CHARACTER /* �業����᪠ */
          FIELD pokrytie$ AS LOGICAL /* �����⨥ */
          FIELD postkorresp$ AS CHARACTER /* ���⊮��� */
          FIELD preemnik$ AS CHARACTER /* �॥���� */
          FIELD prim1$ AS CHARACTER /* �ਬ1 */
          FIELD prim2$ AS CHARACTER /* �ਬ2 */
          FIELD prim3$ AS CHARACTER /* �ਬ3 */
          FIELD prim4$ AS CHARACTER /* �ਬ4 */
          FIELD prim5$ AS CHARACTER /* �ਬ5 */
          FIELD prim6$ AS CHARACTER /* �ਬ6 */
          FIELD prisutorguprav$ AS CHARACTER /* �����࣓�ࠢ */
          FIELD riskotmyv$ AS CHARACTER /* ��᪎�� */
          FIELD svedvygdrlica$ AS CHARACTER /* �����룄���� */
          FIELD struktorg$ AS CHARACTER /* ������ */
          FIELD subw%ekt$ AS CHARACTER /* ��ꥪ� */
          FIELD unk$ AS DECIMAL /* ��� */
          FIELD unkg$ AS INT64 /* ���� */
          FIELD ustavkap$ AS CHARACTER /* ��⠢��� */
          FIELD uwcastniknop$ AS CHARACTER /* ���⭨���� */
          FIELD uwcdokgr$ AS CHARACTER /* �焮��� */
          FIELD uwcredorg$ AS CHARACTER /* ��।�� */
          FIELD fiobuhg$ AS CHARACTER /* ������ */
          FIELD fioruk$ AS CHARACTER /* ����� */
          FIELD formsobs$ AS CHARACTER /* ��଑��� */
          FIELD formsobs_118$ AS CHARACTER /* ��଑���_118 */
          FIELD bank-stat AS CHARACTER /* bank-stat */
          FIELD branch-id AS CHARACTER /* branch-id */
          FIELD branch-list AS CHARACTER /* branch-list */
          FIELD brand-name AS CHARACTER /* brand-name */
          FIELD contr_group AS CHARACTER /* contr_group */
          FIELD contr_type AS CHARACTER /* contr_type */
          FIELD country-id2 AS CHARACTER /* country-id2 */
          FIELD country-id3 AS CHARACTER /* country-id3 */
          FIELD CountryCode AS CHARACTER /* CountryCode */
          FIELD DataLic AS DATE /* DataLic */
          FIELD date-export AS CHARACTER /* date-export */
          FIELD e-mail AS CHARACTER /* e-mail */
          FIELD engl-name AS CHARACTER /* engl-name */
          FIELD fax AS CHARACTER /* fax */
          FIELD HistoryFields AS CHARACTER /* HistoryFields */
          FIELD holding-id AS CHARACTER /* holding-id */
          FIELD IndCode AS CHARACTER /* IndCode */
          FIELD inter-region AS CHARACTER /* inter-region */
          FIELD LegTerr AS CHARACTER /* LegTerr */
          FIELD lic-sec AS CHARACTER /* lic-sec */
          FIELD LocCustType AS CHARACTER /* LocCustType */
          FIELD mess AS CHARACTER /* mess */
          FIELD NACE AS CHARACTER /* NACE */
          FIELD Netting AS LOGICAL /* Netting */
          FIELD new1 AS CHARACTER /* new1 */
          FIELD NoExport AS LOGICAL /* NoExport */
          FIELD num_contr AS INT64 /* num_contr */
          FIELD okonx AS CHARACTER /* okonx */
          FIELD okpo AS CHARACTER /* okpo */
          FIELD Prim-ID AS CHARACTER /* Prim-ID */
          FIELD real AS CHARACTER /* real */
          FIELD RegDate AS CHARACTER /* RegDate */
          FIELD region AS CHARACTER /* region */
          FIELD RegNum AS CHARACTER /* RegNum */
          FIELD RegPlace AS CHARACTER /* RegPlace */
          FIELD Soato AS CHARACTER /* Soato */
          FIELD swift-address AS CHARACTER /* swift-address */
          FIELD swift-name AS CHARACTER /* swift-name */
          FIELD tel AS CHARACTER /* tel */
          FIELD test1 AS CHARACTER /* test1 */
          FIELD uer AS CHARACTER /* uer */
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
          /* Additional fields you should place here                      */
          
          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-banks" "" }
          
      END-FIELDS.
      TABLE: tt-InnBank T "?" NO-UNDO bisquit cust-ident
      ADDITIONAL-FIELDS:
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
          /* Additional fields you should place here                      */
          
          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-InnBank" "InnBank" }
          
      END-FIELDS.
      TABLE: tt-MFO-9 T "?" NO-UNDO bisquit banks-code
      ADDITIONAL-FIELDS:
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
          /* Additional fields you should place here                      */
          
          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-MFO-9" "MFO-9" }
          
      END-FIELDS.
      TABLE: tt-Regn T "?" NO-UNDO bisquit banks-code
      ADDITIONAL-FIELDS:
          FIELD local__template AS LOGICAL   /* �ਧ��� 蠡���/�� 蠡��� */
          FIELD local__rowid    AS ROWID     /* ROWID ����� � ��        */
          FIELD local__id       AS INT64   /* �����䨪��� �����     */
          FIELD local__upid     AS INT64   /* ��뫪� �� ������ � ���ॣ����饩 ⠡��� */
          FIELD user__mode      AS INT64   /* ���� �ࠢ����� ������� � �� */
          /* Additional fields you should place here                      */
          
          /* �����뢠�� ��뫪� �� �६����� ⠡���� � ᯥ樠���� ⠡���� */
          {ln-tthdl.i "tt-Regn" "Regn" }
          
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW TERMINAL-SIMULATION ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 21
         WIDTH              = 80.43
         MAX-HEIGHT         = 21
         MAX-WIDTH          = 80.43
         VIRTUAL-HEIGHT     = 21
         VIRTUAL-WIDTH      = 80.43
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = yes
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB TERMINAL-SIMULATION 
/* ************************* Included-Libraries *********************** */

{bis-tty.pro}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-MFO-9.bank-code IN FRAME fMain
   1 2 3 4 EXP-LABEL EXP-FORMAT EXP-HELP                                */
/* SETTINGS FOR FILL-IN tt-Regn.bank-code IN FRAME fMain
   1 2 3 4 EXP-LABEL EXP-HELP                                           */
/* SETTINGS FOR FILL-IN tt-banks.bank-stat IN FRAME fMain
   1 2 3 4 EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN tt-banks.bank-type IN FRAME fMain
   1 2 3 4 EXP-HELP                                                     */
/* SETTINGS FOR FILL-IN tt-banks.client IN FRAME fMain
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN tt-banks.country IN FRAME fMain
   3                                                                    */
/* SETTINGS FOR FILL-IN tt-banks.country-id IN FRAME fMain
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN tt-InnBank.cust-code IN FRAME fMain
   1 2 3 4 EXP-LABEL EXP-HELP                                           */
/* SETTINGS FOR FILL-IN tt-banks.date-in IN FRAME fMain
   1 2 3 4 EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN tt-banks.date-out IN FRAME fMain
   2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                    */
/* SETTINGS FOR FILL-IN tt-banks.flag-rkc IN FRAME fMain
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN tt-banks.kpp$ IN FRAME fMain
   1 2 3 EXP-LABEL                                                      */
/* SETTINGS FOR FILL-IN tt-banks.last-date IN FRAME fMain
   3                                                                    */
/* SETTINGS FOR FILL-IN tt-banks.law-address IN FRAME fMain
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN tt-banks.mail-address IN FRAME fMain
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN tt-banks.name IN FRAME fMain
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN tt-banks.okonx IN FRAME fMain
   1 2 3 EXP-LABEL                                                      */
/* SETTINGS FOR FILL-IN tt-banks.okpo IN FRAME fMain
   1 2 3 EXP-LABEL                                                      */
/* SETTINGS FOR FILL-IN tt-banks.okvwed$ IN FRAME fMain
   1 2 3 EXP-LABEL                                                      */
/* SETTINGS FOR FILL-IN tt-banks.region IN FRAME fMain
   1 2 3 EXP-LABEL                                                      */
/* SETTINGS FOR FILL-IN tt-banks.short-name IN FRAME fMain
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN tt-banks.tax-insp IN FRAME fMain
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN tt-banks.town IN FRAME fMain
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN tt-banks.town-type IN FRAME fMain
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN tt-banks.uer IN FRAME fMain
   1 2 3 4 EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN tt-banks.unk$ IN FRAME fMain
   1 2 3 EXP-LABEL EXP-FORMAT EXP-HELP                                  */
/* SETTINGS FOR FILL-IN tt-banks.vidbanklic$ IN FRAME fMain
   1 2 3 EXP-LABEL                                                      */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(TERMINAL-SIMULATION)
THEN TERMINAL-SIMULATION:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _TblList          = "Temp-Tables.tt-banks,Temp-Tables.tt-regn WHERE Temp-Tables.tt-banks ...,Temp-Tables.tt-MFO-9 WHERE Temp-Tables.tt-banks ...,Temp-Tables.tt-InnBank WHERE Temp-Tables.tt-banks ..."
     _Query            is NOT OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME tt-MFO-9.bank-code
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-MFO-9.bank-code TERMINAL-SIMULATION
ON F1 OF tt-MFO-9.bank-code IN FRAME fMain /* ����� ��� */
DO:
   mType = "���-9".
   DO TRANSACTION:
      RUN bankscod.p (INPUT-OUTPUT mType, iLevel + 1).
   END.
   IF     LASTKEY EQ 10 
      AND pick-value NE ? THEN 
       DISPLAY 
          ENTRY(2,pick-value) @ tt-mfo-9.bank-code 
       WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-MFO-9.bank-code TERMINAL-SIMULATION
ON LEAVE OF tt-MFO-9.bank-code IN FRAME fMain /* ����� ��� */
DO:
   {&BEG_BT_LEAVE}
   IF SELF:SCREEN-VALUE NE "" THEN
   DO:
      mTempFlg = YES.
      DECIMAL(SELF:SCREEN-VALUE) NO-ERROR.
      IF ERROR-STATUS:ERROR
      OR SELF:SCREEN-VALUE = "?"
      THEN mTempFlg = NO.
      ELSE RUN rekvchk.p("���-9", SELF:SCREEN-VALUE, OUTPUT mTempFlg).
      IF NOT mTempFlg THEN DO:
         RUN Fill-SysMes IN h_tmess ("", "", "0", "�����४⭮� ���祭�� ����� ���!").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
      mTempVal = GetValueByQuery("banks-code",
                                 "bank-id",
                                 "     banks-code.bank-code-type EQ '���-9'" + 
                                 (IF tt-banks.bank-id NE 0 
                                  THEN " AND banks-code.bank-id NE " + STRING(tt-banks.bank-id)
                                  ELSE "") +
                                 " AND banks-code.bank-code      EQ '" + STRING(INT64(SELF:SCREEN-VALUE), '999999999') + "'"
                                 ).
      IF mTempVal NE ? THEN DO:
         RUN Fill-SysMes IN h_tmess ("", "", "0", "���� " + 
                                                   GetValueAttrEx("banks", mTempVal, "short-name", GetValueAttrEx("banks", mTempVal, "name", "� ����� " + mTempVal)) + 
                                                   " ����� ⠪�� �� ���-9!").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-Regn.bank-code
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-Regn.bank-code TERMINAL-SIMULATION
ON F1 OF tt-Regn.bank-code IN FRAME fMain /* ���.����� */
DO:
   mType = "REGN".
   DO TRANSACTION:
      RUN bankscod.p (INPUT-OUTPUT mType, iLevel + 1).
   END.
   IF     LASTKEY EQ 10 
      AND pick-value NE ? THEN 
      DISPLAY 
         ENTRY(2,pick-value) @ tt-regn.bank-code 
      WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-Regn.bank-code TERMINAL-SIMULATION
ON LEAVE OF tt-Regn.bank-code IN FRAME fMain /* ���.����� */
DO:
   {&BEG_BT_LEAVE}
   IF SELF:SCREEN-VALUE NE "" THEN
   DO:
      mTempVal = GetValueByQuery("banks-code",
                                 "bank-id",
                                 "     banks-code.bank-code-type EQ 'REGN'" +
                                 (IF tt-banks.bank-id NE 0 
                                  THEN " AND banks-code.bank-id NE " + STRING(tt-banks.bank-id)
                                  ELSE "") +
                                 " AND banks-code.bank-code      EQ '" + SELF:SCREEN-VALUE + "'"
                                 ).
      IF mTempVal NE ? THEN DO:
         RUN Fill-SysMes ("", "", "0", "���� " +
                                       GetValueAttrEx("banks", mTempVal, "short-name", ?) +
                                       " ����� ⠪�� �� ॣ. �����!").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-banks.client
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-banks.client TERMINAL-SIMULATION
ON F1 OF tt-banks.client IN FRAME fMain /* ������ */
DO:
   IF iMode NE {&MOD_VIEW} THEN
      DISPLAY 
         NOT INPUT tt-banks.client @ tt-banks.client
      WITH FRAME {&FRAME-NAME}. 
END.

ON ' ' OF tt-banks.client
DO:
   APPLY "F1" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-banks.country-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-banks.country-id TERMINAL-SIMULATION
ON F1 OF tt-banks.country-id IN FRAME fMain /* �������� ��� */
DO:
   IF {assigned SELF:SCREEN-VALUE} THEN
      RUN country#.p (SELF:SCREEN-VALUE,
                      iLevel + 1).
   ELSE DO:
      DO TRANSACTION:
         RUN count.p (iLevel + 1).
      END.
      IF     LASTKEY EQ 10 
         AND pick-value NE ? THEN 
      DO:
         SELF:SCREEN-VALUE = pick-value.
         DISP GetValueAttrEx("country",
                             pick-value,
                             "country-name",
                             "") @ tt-banks.country
         WITH FRAME {&FRAME-NAME}. 
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-banks.country-id TERMINAL-SIMULATION
ON LEAVE OF tt-banks.country-id IN FRAME fMain /* �������� ��� */
DO:
   {&BEG_BT_LEAVE}
   mTempVal = GetValueAttrEx("country",
                             SELF:SCREEN-VALUE,
                             "country-name",
                             ?).
      
   IF mTempVal EQ ? 
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "����୮ ������ ��� ��࠭�!").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   ELSE
   DO:
      tt-banks.country = mTempVal.
      tt-banks.country:SCREEN-VALUE IN FRAME {&FRAME-NAME}= mTempVal.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-InnBank.cust-code
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-InnBank.cust-code TERMINAL-SIMULATION
ON F1 OF tt-InnBank.cust-code IN FRAME fMain /* ��� */
DO:
   DEFINE VARIABLE vRes AS CHARACTER   NO-UNDO.

   DO TRANSACTION:
      RUN browseld.p ("cust-ident",
                      "class-code" + CHR(1) + "cust-cat" + CHR(1) + "cust-code-type",
                      "cust-bank"  + CHR(1) + "�"        + CHR(1) + "���",
                      "",
                      iLevel + 1).
   END.
   IF KEYFUNCTION (LASTKEY) NE "END-ERROR" THEN
      SELF:SCREEN-VALUE = ENTRY (2, pick-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-InnBank.cust-code TERMINAL-SIMULATION
ON LEAVE OF tt-InnBank.cust-code IN FRAME fMain /* ��� */
DO:
      
   DEFINE VAR i       AS INTEGER NO-UNDO.
   DEFINE VAR vLen    AS INTEGER NO-UNDO.
   DEFINE VAR isAlpha AS LOGICAL NO-UNDO.
   DEFINE VARIABLE vFl AS LOGICAL NO-UNDO.
   vFl = YES.
   {&BEG_BT_LEAVE}
   IF SELF:SCREEN-VALUE NE "" THEN
   DO:
     vLen = LENGTH(SELF:SCREEN-VALUE).
     DO i = 1 TO vLen:
      IF ASC(SUBSTRING(SELF:SCREEN-VALUE,i,1)) LT 48 OR 
         ASC(SUBSTRING(SELF:SCREEN-VALUE,i,1)) GT 57 THEN isAlpha = YES.
      ELSE isAlpha = NO.
      IF isAlpha THEN LEAVE.
     END.
     IF isAlpha THEN
     DO:
       MESSAGE '� ��� ������ ���� ⮫쪮 ����.' VIEW-AS ALERT-BOX.
       RETURN NO-APPLY {&RET-ERROR}.
     END.
     IF ((vLen NE 10) AND (vLen NE 12) AND (tt-banks.country-id:SCREEN-VALUE EQ 'RUS')) THEN
     DO:
       MESSAGE '� ��� ������ ���� 10 ��� 12 ���, ������� ' + TRIM(STRING(vLen)) + '.' 
         VIEW-AS ALERT-BOX TITLE " �������� ".
       RETURN NO-APPLY {&RET-ERROR}.
     END.
      IF ((vLen NE 5) AND (vLen NE 10) AND (vLen NE 12) AND (tt-banks.country-id:SCREEN-VALUE NE 'RUS')) THEN
     DO:
       MESSAGE '� ��� ������ ���� 5, 10 ��� 12 ���, ������� ' + TRIM(STRING(vLen)) + '.'
         VIEW-AS ALERT-BOX TITLE " �������� ".
       RETURN NO-APPLY {&RET-ERROR}.
     END.
     IF vLen NE 5 AND
       NOT fValidInnSignature(SELF:SCREEN-VALUE, mTempVal) THEN DO:
       IF vLen = 10 THEN 
           MESSAGE ("��᫥���� ��� ��� (����) ������ ����: ~"" + mTempVal + "~"")
             SKIP "OK - ��ࠢ���, Cancel - �ய�����"
           VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL TITLE " �������� " UPDATE vfl.
       IF vLen = 12 THEN 
           MESSAGE ("��᫥���� 2 ���� ��� (����) ������ ����: ~"" + mTempVal + "~"")
             SKIP "OK - ��ࠢ���, Cancel - �ய�����"
           VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL TITLE " �������� " UPDATE vfl.
       IF vfl OR vfl EQ ? THEN 
              RETURN NO-APPLY {&RET-ERROR}.
     END.
   END.
   ELSE DO:
      IF (tt-banks.country-id:SCREEN-VALUE EQ mResCntry)
         AND INPUT tt-banks.client THEN DO:
         RUN Fill-SysMes IN h_tmess ("", "", "0" , "��� �����-������, ��饣��� १����⮬, ����室��� 㪠���� ���!").
         RETURN NO-APPLY {&RET-ERROR}.
      END.
   END.
   {&END_BT_LEAVE}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-banks.date-in
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-banks.date-in TERMINAL-SIMULATION
ON LEAVE OF tt-banks.date-in IN FRAME fMain /* ��� ��������� */
,tt-banks.date-out
DO:
   {&BEG_BT_LEAVE}
   /* �஢�ઠ �������� ����, �⮡� �� ��������� �ண�ᮢ�� �訡�� */
   DEFINE VARIABLE vdtTmpDt AS DATE NO-UNDO.
   vdtTmpDt = DATE(SELF:SCREEN-VALUE) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", ERROR-STATUS:GET-MESSAGE(1)).
      RETURN NO-APPLY {&RET-ERROR}.
   END.

   /* �஢�ઠ ᮮ⢥��⢨� ��� ������/������� */
   IF INPUT tt-banks.date-out LT INPUT tt-banks.date-in THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("", 
                                  "", 
                                  "0", 
                                  "��� ��������� ������ ������ ���� ����� ���� �������!").
      RETURN NO-APPLY {&RET-ERROR}.
   END.
   {&END_BT_LEAVE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-banks.flag-rkc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-banks.flag-rkc TERMINAL-SIMULATION
ON F1 OF tt-banks.flag-rkc IN FRAME fMain /* ��� */
DO:
   IF iMode NE {&MOD_VIEW} THEN
      DISPLAY 
         NOT INPUT tt-banks.flag-rkc @ tt-banks.flag-rkc
      WITH FRAME {&FRAME-NAME}. 
END.

ON ' ' OF tt-banks.flag-rkc
DO:
   APPLY "F1" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-banks.short-name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-banks.short-name TERMINAL-SIMULATION
ON F1 OF tt-banks.short-name IN FRAME fMain /* ��⪮� ����-��� */
DO:
   IF iMode EQ {&MOD_VIEW}  THEN
      RUN xview.p("banks",tt-banks.bank-id).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-banks.unk$
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-banks.unk$ TERMINAL-SIMULATION
ON ENTRY OF tt-banks.unk$ IN FRAME fMain /* ��� */
DO:
   IF  iMode         EQ {&MOD_EDIT}
   AND tt-banks.unk$ EQ ? 
   AND mFlagUnk
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "4", "��᢮��� ����� ���祭�� ���?").
      IF pick-value EQ "YES" THEN
         tt-banks.unk$:SCREEN-VALUE = STRING(NewUnk("banks")).
   END.
END.
ON F1 OF tt-banks.unk$ IN FRAME fMain 
DO:
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK TERMINAL-SIMULATION 


/* ***************************  Main Block  *************************** */
&IF DEFINED(SESSION-REMOTE) EQ 0 &THEN
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
   mRetVal = IF mOnlyForm THEN
      {&RET-ERROR}
      ELSE 
         "".
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.
&ENDIF
/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

RUN StartBisTTY.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:


	/* #2905 */
   IF LOGICAL(FGetSetting("PirChkOp","Pir2905","YES")) THEN 
   DO:
     DEF VAR oRes AS LOGICAL NO-UNDO.
     RUN pir-updatedanket.p("banks",iSurrogate,OUTPUT oRes).
     IF  oRes   THEN 
       MESSAGE  "��������!" SKIP "���� ���������� ������ �������!" SKIP "��� ��������� �������� ����� ������������� �6 � �11" VIEW-AS ALERT-BOX.
   END.

   mResCntry = fGetSetting("������",?,"RUS").
   {getflagunk.i &class-code="'banks'" &flag-unk="mFlagUnk"}

   IF mFlagUnk THEN DO:
      mTempVal = GetXAttrEx("banks","���","data-format").
      IF mTempVal NE FILL("9", LENGTH(mTempVal)) THEN DO:
         RUN Fill-SysMes IN h_tmess ("", "", "0", "��ଠ� ���, ������� � ����奬� �.�. ~"999...~"!").
         UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK.
      END.
   END.

   /* Commented by KSV: ���樠������ ��⥬��� ᮮ�饭�� */
   RUN Init-SysMes("","","").
   
   /* Commented by KSV: ���४��㥬 ���⨪����� ������ �३�� */
   iLevel = GetCorrectedLevel(FRAME fMain:HANDLE,iLevel).
   FRAME fMain:ROW = iLevel.

   /* Commented by KSV: ��⠥� ����� */
   RUN GetObject.

   IF NUM-ENTRIES(iInstanceList,CHR(3)) GT 1 
   THEN mClient = ENTRY(2, iInstanceList,CHR(3)) EQ 'yes'.
   ELSE tt-banks.client.
   
   mClass = IF mClient 
            THEN mFlagUnk 
            ELSE mClient.

   IF iMode EQ {&MOD_ADD}  THEN DO:
      ASSIGN 
         tt-banks.client  = mClass
         tt-banks.date-in = TODAY
      .
   END.
   
   IF iMode NE {&MOD_VIEW} THEN DO:
      ASSIGN
         tt-banks.modified  = YES
         tt-banks.last-date = TODAY
      .
      IF mFlagUnk THEN DO:
         IF  tt-banks.unk$       EQ ? 
         AND mClass
         THEN DO:
            pick-value = "YES".
            IF iMode EQ {&MOD_EDIT} THEN
               RUN Fill-SysMes IN h_tmess ("", "", "4", "��᢮��� ����� ���祭�� ���?").
            IF pick-value EQ "YES" THEN
            DO:
               tt-banks.unk$ = NewUnk("banks").
               IF  iMode EQ {&MOD_EDIT} THEN
                  RUN Fill-SysMes IN h_tmess ("", "", "1", "������� ��᢮��� ����� ���祭�� ��� - " + STRING(tt-banks.unk$,mTempVal)).
            END.
         END.
      END.
   END.

   /* ������塞 COMBO-BOX'� ����묨 �� ����奬� */
   RUN FillComboBox(FRAME {&MAIN-FRAME}:HANDLE).

   /* ���ᢥ⪠ ����� �� LIST-5 (����ந�� ��� ᥡ� )*/
   RUN SetColorList(FRAME {&MAIN-FRAME}:HANDLE,
                    REPLACE("{&LIST-5}"," ",","),
                    "bright-green").
   
   
   /* Commented by KSV: �����뢠�� ��࠭��� ��� */
   STATUS DEFAULT "".
&IF DEFINED(SESSION-REMOTE) EQ 0 &THEN
   RUN enable_UI.
&ENDIF
   /* Commented by KSV: ���뢠�� � ����, ����� ࠧ�襭� ��������
   ** � ����ᨬ��� �� ०��� ������ */
   RUN EnableDisable.
&IF DEFINED(SESSION-REMOTE) &THEN
   LEAVE MAIN-BLOCK.
&ENDIF

   /* Commented by KSV: ���㥬 ࠧ����⥫�. �������⥫� �������� ��� FILL-IN
   ** � �����䨪��஬ SEPARATOR# � ��ਡ�⮬ VIES-AS TEXT */
   RUN Separator(FRAME fMain:HANDLE,"1").
  
   IF NOT THIS-PROCEDURE:PERSISTENT THEN
      WAIT-FOR CLOSE OF THIS-PROCEDURE FOCUS mFirstTabItem. 
END.

/* Commented by KSV: ����뢠�� �㦡� ��⥬��� ᮮ�饭�� */
RUN End-SysMes.

&IF DEFINED(SESSION-REMOTE) = 0 &THEN
RUN disable_ui.
&ENDIF


RUN EndBisTTY.

/* Commented by KSV: ���㦠�� ������⥪� */
{intrface.del}

/* Commented by KSV: �����頥� ���祭�� ��뢠�饩 ��楤�� */
RETURN mRetVal.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  IF AVAILABLE tt-banks THEN 
    DISPLAY tt-banks.date-in tt-banks.last-date tt-banks.date-out tt-banks.unk$ 
          tt-banks.client tt-banks.flag-rkc tt-banks.vidbanklic$ 
          tt-banks.bank-type tt-banks.bank-stat tt-banks.short-name 
          tt-banks.name tt-banks.country tt-banks.region tt-banks.country-id 
          tt-banks.town-type tt-banks.town tt-banks.tax-insp 
          tt-banks.law-address tt-banks.mail-address tt-banks.uer 
          tt-banks.okvwed$ tt-banks.kpp$ tt-banks.okonx tt-banks.okpo 
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-InnBank THEN 
    DISPLAY tt-InnBank.cust-code 
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-MFO-9 THEN 
    DISPLAY tt-MFO-9.bank-code 
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  IF AVAILABLE tt-Regn THEN 
    DISPLAY tt-Regn.bank-code 
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  ENABLE tt-banks.date-in tt-banks.last-date tt-banks.date-out tt-banks.unk$ 
         tt-banks.client tt-banks.flag-rkc tt-banks.vidbanklic$ 
         tt-banks.bank-type tt-banks.bank-stat tt-banks.short-name 
         tt-banks.name tt-banks.country tt-banks.region tt-banks.country-id 
         tt-banks.town-type tt-banks.town tt-banks.tax-insp 
         tt-banks.law-address tt-banks.mail-address tt-MFO-9.bank-code 
         tt-Regn.bank-code tt-InnBank.cust-code tt-banks.uer tt-banks.okvwed$ 
         tt-banks.kpp$ tt-banks.okonx tt-banks.okpo 
      WITH FRAME fMain IN WINDOW TERMINAL-SIMULATION.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW TERMINAL-SIMULATION.
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

   DEFINE VARIABLE vIsNotAcct AS LOGICAL NO-UNDO.
   
   IF mFlagUnk THEN 
      tt-banks.unk$:FORMAT IN FRAME {&FRAME-NAME} = mTempVal.
   tt-banks.unk$:HIDDEN IN FRAME {&FRAME-NAME} = NOT mClass.

   vIsNotAcct = YES.

   IF iMode EQ {&MOD_EDIT} AND tt-banks.client THEN

      FOR EACH acct WHERE acct.cust-cat   EQ "�"
                      AND acct.cust-id    EQ tt-banks.bank-id
                      AND acct.close-date EQ ? NO-LOCK:
         vIsNotAcct = NO.
         LEAVE.
      END.
   tt-banks.client:SENSITIVE IN FRAME {&FRAME-NAME} = IF     iMode NE {&MOD_View}
                                                         AND (NOT tt-banks.client OR vIsNotAcct)
                                                      THEN YES
                                                      ELSE NO.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE localSetObject TERMINAL-SIMULATION 
PROCEDURE localSetObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hBankCode  AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hCustIdent AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vOk        AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE hT         AS HANDLE     NO-UNDO.

   DEFINE VARIABLE vNonUniqInn AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE vCont       AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE vNum        AS INT64     NO-UNDO.
     
   IF GetValueAttrEx("banks-code",
                     STRING(tt-banks.bank-id) + ',' + '���-9',
                     "bank-code",
                     ?) NE ? THEN DO:
      IF tt-mfo-9.bank-code EQ "" THEN DO:
         RUN prepareInstance IN h_Data ("").
         RUN getInstance IN h_Data (       "banks-code", 
                                           STRING(tt-banks.bank-id) + ',' + '���-9',
                                    OUTPUT hBankCode, 
                                    OUTPUT vOk).
         /* �᫨ ������ ���⮩ ����⨨䪠��, � ������ 㤠�塞 */
         IF VALID-HANDLE (hBankCode) THEN
            tt-mfo-9.user__mode      = {&MOD_DELETE}.
      END.
   END.
   
   IF GetValueAttrEx("banks-code",
                     STRING(tt-banks.bank-id) + ',' + 'REGN',
                     "bank-code",
                     ?) NE ? THEN DO:
      IF tt-regn.bank-code EQ "" THEN DO:
         RUN prepareInstance IN h_Data ("").
         RUN getInstance IN h_Data (       "banks-code", 
                                           STRING(tt-banks.bank-id) + ',' + 'REGN',
                                    OUTPUT hBankCode, 
                                    OUTPUT vOk).
         /* �᫨ ������ ���⮩ ����⨨䪠��, � ������ 㤠�塞 */
         IF VALID-HANDLE (hBankCode) THEN
            tt-regn.user__mode      = {&MOD_DELETE}.
      END.
      ELSE
         tt-regn.user__mode = {&MOD_EDIT}.
   END.
   IF GetValueAttrEx("cust-ident",
                     "���" + "," + tt-InnBank.cust-code + "," + STRING (tt-InnBank.cust-type-num), 
                     "cust-code",
                     ?) NE ? THEN DO:
      IF tt-InnBank.cust-code EQ "" THEN DO:
         RUN prepareInstance IN h_Data ("").
         RUN getInstance IN h_Data (       "cust-ident", 
                                           "���" + "," + tt-InnBank.cust-code + "," + STRING (tt-InnBank.cust-type-num), 
                                    OUTPUT hCustIdent, 
                                    OUTPUT vOk).
         /* �᫨ ������ ���⮩ ����⨨䪠��, � ������ 㤠�塞 */
         IF VALID-HANDLE (hCustIdent) THEN
            tt-InnBank.user__mode      = {&MOD_DELETE}.
      END.
   END.


   IF iMode EQ {&MOD_ADD} THEN DO:
      IF tt-banks.name EQ "" THEN
         tt-banks.name = tt-banks.short-name.
      IF     tt-mfo-9.bank-code NE ""
         AND SUBSTRING(tt-mfo-9.bank-code, 
                       MAX(LENGTH(tt-mfo-9.bank-code) - 2,1), 
                       3) EQ "000" THEN
         tt-banks.flag-rkc = YES.
   END.
   
   IF tt-mfo-9.bank-code <> "" THEN
      tt-mfo-9.bank-code = STRING(INT64(tt-mfo-9.bank-code), "999999999").
   
   /* �஢�ઠ ��� �� 㭨���쭮��� */
   IF (iMode EQ {&MOD_EDIT}) OR (iMode EQ {&MOD_ADD}) THEN
   DO:
      FIND FIRST bCust-ident WHERE bCust-ident.cust-cat       EQ "�"
                             AND   bCust-ident.cust-code-type EQ "���"
                             AND   bCust-ident.cust-code      EQ tt-InnBank.cust-code
                             AND   ROWID (bCust-Ident)        NE tt-InnBank.local__rowid
         NO-LOCK NO-ERROR.
      IF AVAIL bCust-Ident THEN
      DO:
         RUN Fill-SysMes IN h_tmess ("", "", "4", "��� ���� ���� � ��� " + 
                                                  tt-InnBank.cust-code + 
                                                  "!~n�த������?").
         IF NOT LOGICAL (pick-value) THEN
            RETURN ERROR.
      END.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Local_GO TERMINAL-SIMULATION 
PROCEDURE Local_GO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VAR vCheckBankRek       AS LOGICAL NO-UNDO.
   DEFINE VAR vBadMandatoryFields AS CHAR    NO-UNDO.
   DEFINE VAR vBadWarningFields   AS CHAR    NO-UNDO.

   DO WITH FRAME {&MAIN-FRAME}:
      vCheckBankRek = (FGetSetting("�஢�������",?,"���") = "��").

      IF NOT {assigned tt-banks.short-name:SCREEN-VALUE}
      OR tt-banks.short-name:SCREEN-VALUE = "?"
      THEN IF GetXattrEx(tt-banks.class-code,GetOriginalName(tt-banks.short-name:NAME),"Mandatory") = "YES"
           OR (    vCheckBankRek
               AND tt-banks.client)
           THEN vBadMandatoryFields = vBadMandatoryFields + tt-banks.short-name:LABEL + "~n".
           ELSE IF vCheckBankRek
                THEN vBadWarningFields = vBadWarningFields + tt-banks.short-name:LABEL + "~n".

      IF NOT {assigned tt-banks.vidbanklic$:SCREEN-VALUE}
      OR tt-banks.vidbanklic$:SCREEN-VALUE = "?"
      THEN IF GetXattrEx(tt-banks.class-code,GetOriginalName(tt-banks.vidbanklic$:NAME),"Mandatory") = "YES"
           OR (    vCheckBankRek
               AND tt-banks.client)
           THEN vBadMandatoryFields = vBadMandatoryFields + tt-banks.vidbanklic$:LABEL + "~n".
           ELSE IF vCheckBankRek
                THEN vBadWarningFields = vBadWarningFields + tt-banks.vidbanklic$:LABEL + "~n".

      IF NOT {assigned tt-banks.bank-stat:SCREEN-VALUE}
      OR tt-banks.bank-stat:SCREEN-VALUE = "?"
      THEN IF GetXattrEx(tt-banks.class-code,GetOriginalName(tt-banks.bank-stat:NAME),"Mandatory") = "YES"
           OR (    vCheckBankRek
               AND tt-banks.client)
           THEN vBadMandatoryFields = vBadMandatoryFields + tt-banks.bank-stat:LABEL + "~n".
           ELSE IF vCheckBankRek
                THEN vBadWarningFields = vBadWarningFields + tt-banks.bank-stat:LABEL + "~n".

   END.

   IF {assigned vBadMandatoryFields} THEN DO:
      vBadMandatoryFields = "����������� ����, ��易⥫�� ��� ����������:~n~n"
                          + vBadMandatoryFields.
      RUN Fill-SysMes IN h_tmess ("", "", "-1", vBadMandatoryFields).
      RETURN ERROR {&RET-ERROR}.
   END.
   IF {assigned vBadWarningFields} THEN DO:
      vBadWarningFields = "������������ ��������� ����� ����:~n~n"
                        + vBadWarningFields + "~n�������� � ��� ?".
      pick-value = "yes".
      RUN Fill-SysMes IN h_tmess ("", "", "4", vBadWarningFields).
      IF pick-value = "yes"
      THEN RETURN ERROR {&RET-ERROR}.
   END.

   RETURN.
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
   DEFINE VAR vCustId LIKE banks.bank-id NO-UNDO.

   vCustId = INT64(GetSurrogate("banks", TO-ROWID(GetInstanceProp2(mInstance,"__rowid")))).

   /* (������ �� ����) ���⠭���� ��砫쭮�� ����� */
   UpdateSigns("banks",
               STRING(vCustId),
               "status",
               FGetSetting("���₢����", "�������", ?),
               ?).

   RUN RunClassMethod IN h_xclass("banks",
                                  "chkupd",
                                  "",
                                  "",
                                  "cust-req",
                                  Rowid2Recid("banks",TO-ROWID(GetInstanceProp(mInstance,"__rowid")))
                                 ).
   IF RETURN-VALUE NE "" THEN 
      RETURN ERROR.

      {chk_frm_mand_adr.i
         &cust-type = "'�'"
         &cust-id   = "vCustId"
      }

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
