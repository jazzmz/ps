/**
 * �஢�ઠ+�ࠢ�� � ����室����� 㢥������� ����� ��। ���������� ���㬥�� � �����⮬ ����.���
 * ᨫ��� �2-3.
 *
 * �ᯮ���� ������ 1-6.
 */
 
{globals.i}

{tmprecid.def}

{pir-chkop-6.def &closeday=yes}

DEF VAR iParam AS CHAR NO-UNDO INIT "".

DEF BUFFER lbfrOpEntryCr FOR op-entry.
DEF BUFFER lbfrAcctDb FOR acct.
DEF BUFFER lbfrAcctCr FOR acct.

{ulib.i}

{setdest.i}

/** �� �ᥬ ��࠭�� � ��㧥� ���㬥�⠬ */
FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
    FIRST op-entry OF op WHERE op-entry.acct-db <> ? NO-LOCK,
    FIRST lbfrOpEntryCr OF op WHERE lbfrOpEntryCr.acct-cr <> ? NO-LOCK,
    FIRST lbfrAcctDb WHERE lbfrAcctDb.acct = op-entry.acct-db NO-LOCK,
    FIRST lbfrAcctCr WHERE lbfrAcctCr.acct = lbfrOpEntryCr.acct-cr NO-LOCK
    :
    
    podft_need = false.
    
    /** ����� ������� �ந�室�� ��᢮���� podft_need */
    {pir-chkop-6.i &closeday=yes}

    PUT UNFORMATTED 
    	"�������� N" op.doc-num " �� " op.doc-date FORMAT "99/99/9999" SKIP(1)
    	"����.����       : " op.op-date FORMAT "99/99/9999" SKIP
    	"�����           : " lbfrAcctDb.acct FORMAT "x(20)" SKIP
    	"                :   " SUBSTRING(REPLACE(lbfrAcctDb.details, CHR(10), " "), 1, 50) FORMAT "x(50)" SKIP
    	"                :   " SUBSTRING(REPLACE(lbfrAcctDb.details, CHR(10), " "), 51, 50) FORMAT "x(50)" SKIP
    	"�।��          : " lbfrAcctCr.acct FORMAT "x(20)" SKIP
    	"                :   " SUBSTRING(REPLACE(lbfrAcctCr.details, CHR(10), " "), 1, 50) FORMAT "x(50)" SKIP
    	"                :   " SUBSTRING(REPLACE(lbfrAcctCr.details, CHR(10), " "), 51, 50) FORMAT "x(50)" SKIP
    	"�����          : " (IF op-entry.currency = "" THEN "810" ELSE op-entry.currency) FORMAT "x(3)" SKIP
    	"�㬬�           : " op-entry.amt-cur FORMAT ">,>>>,>>>,>>>,>>9.99" SKIP
    	"�㬬� ��.���.: " op-entry.amt-rub FORMAT ">,>>>,>>>,>>>,>>9.99" SKIP
    	"�����祭�� �-�� : " SUBSTRING(REPLACE(op.details, CHR(10), " "), 1, 50) FORMAT "x(50)" SKIP
    	"                : " SUBSTRING(REPLACE(op.details, CHR(10), " "), 51, 50) FORMAT "x(50)" SKIP
    	"                : " SUBSTRING(REPLACE(op.details, CHR(10), " "), 101, 50) FORMAT "x(50)" SKIP
    	"                : " SUBSTRING(REPLACE(op.details, CHR(10), " "), 151, 50) FORMAT "x(50)" SKIP
    	"��� ���㬥��   : " op.doc-type FORMAT "x(3)" SKIP
    	"���ᮢ� ᨬ��� : " STRING(op-entry.symbol) SKIP 
    	"ᮧ��⥫� ���-�: " GetUserInfo_ULL(op.user-id, "fio", false) FORMAT "x(30)" SKIP
    	"�६� �ࠢ��   : " TODAY FORMAT "99/99/9999" " " STRING(TIME, "HH:MM:SS") SKIP(1)
    	"1. �������⥫�� ४����� op.PIRcheckPODFT : " 
    		GetXAttrValueEx("op", STRING(op.op), "PIRcheckPODFT", "(����)") SKIP
    	"   (���㬥�� �஢�७ �����)" SKIP(1)
    	 
    	"2. �������⥫�� ४����� op.��������    : "
    		GetXAttrValueEx("op", STRING(op.op), "��������", "(����)") SKIP
    	"   (���������� ��室��. ��� ����樨)" SKIP(1) 
    		
    	"3. �������⥫�� ४����� op.��������㬥�� : "
    		GetXAttrValueEx("op", STRING(op.op), "��������㬥��", "(����)") SKIP
    	"   (���������� ��室��. �����.���㬥��)" SKIP(1)
    		
    	"����������: " (IF podft_need THEN 
    		"�. ����䨪��� ���㬥�� ������� ᮣ��ᮢ���� �⤥�� ���/��" ELSE
    		"�. ����䨪��� ���㬥�� �� �ॡ�� ᮣ��ᮢ���� �⤥�� ���/��") SKIP(2)
    	"���ࠧ�������-���樠��: " GetXAttrValueEx("_user", USERID, "group-id", "") SKIP(1)
    	"����㤭�� ���ࠧ�������: ____________________ /" GetUserInfo_ULL(USERID, "fio", false) "/" SKIP(1)
    	"�ᯮ���� ����㤭�� �2-3: ____________________ /_________________________/" SKIP(1).
    IF podft_need THEN DO:
    	PUT UNFORMATTED
    	"����㤭�� �⤥�� ����� : ____________________ /_________________________/" SKIP(1)
    	"���������: ______________________________________________________________" SKIP(1)
    	"_________________________________________________________________________" SKIP.
    END. 
	PUT UNFORMATTED
    	"-------------------------------------------------------------------------------------------------------" SKIP(1).
END.

{preview.i} 