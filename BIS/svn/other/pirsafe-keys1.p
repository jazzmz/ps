{pirsavelog.p}

/*
* ����� ��� ��।�� 業���⥩ �� ���砬 �� ���
* ���� �.�., 13.06.2006 16:44
*/

{globals.i}

/** ������ */
DEF INPUT PARAM iParam AS CHAR.

/* ���ᨬ��쭮� ���-�� ���祩 � ���筨� */
DEF VAR max_keys_count AS INTEGER.
DEF VAR tmpStr AS CHAR.
max_keys_count = INT(FGetSetting("Safe", "SafeKeysCount", "")).

/** ��� ���㬥�� */
DEF VAR repDate AS DATE.
{getdate.i}
repDate = end-date.

/** ���ᨢ�, �࠭�騥 ���ଠ�� �� ���砬, ��� ������ ��⥣�ਨ */
DEF VAR keys_c1 AS CHAR EXTENT 1025.
DEF VAR keys_c2 AS CHAR EXTENT 1025.
DEF VAR keys_c3 AS CHAR EXTENT 1025.

/** ���-�� ����������� ���ଠ樨 �� �祩��� ������ ��⥣�ਨ */
DEF VAR index_c1 AS INTEGER INITIAL 0.
DEF VAR index_c2 AS INTEGER INITIAL 0.
DEF VAR index_c3 AS INTEGER INITIAL 0.
DEF VAR count AS INTEGER.
DEF VAR countStr AS CHAR EXTENT 2.
DEF VAR outFIO AS CHAR.
DEF VAR inFIO AS CHAR.

FIND FIRST _user WHERE _user._userid = userid no-lock no-error.
IF AVAIL _user then
	outFIO = _user._user-name.
else
	outFIO = "-".


DEF VAR i AS INTEGER.

/** ��ॡ�ࠥ� �� �祩�� � ����ᮬ "����" */
FOR EACH code WHERE 
		SUBSTRING(code,2,1) = "-"
		AND
		val = ""
		NO-LOCK
		:
		CASE ENTRY(1,code,"-") :
			WHEN "1" THEN	DO:
					index_c1 = index_c1 + 1.
					keys_c1[index_c1] = ENTRY(2,code,"-").
				END.
			WHEN "2" THEN DO:
					index_c2 = index_c2 + 1.
					keys_c2[index_c2] = ENTRY(2,code,"-").
				END.
			WHEN "3" THEN DO:
					index_c3 = index_c3 + 1.
					keys_c3[index_c3] = ENTRY(2,code,"-").
				END.
		END /* CASE */ .
END /* EACH code */ .


/** �뢮��� ᮡ࠭��� ���ଠ�� �� ����� */
{setdest.i}

PUT UNFORMATTED "                                  � � �" SKIP
                "                             �������� ���������" SKIP(1)
                "                                 " STRING(repDate,"99/99/9999") SKIP(2)
                "   ��, ���������ᠢ訥��, ������ ����樮���� ����� ��⠢��� �����騩 ��� �" SKIP
                "⮬, ��:" SKIP(1)
                "����� " outFIO " ��।��(�), �" SKIP(1)
                "����� " iParam " �ਭ�(�) ᫥���騥 業����:" SKIP(1)
                "���� �� �������㠫��� ������᪨� ᥩ䮢 �� ��⥣���:" SKIP
								"�����������������������������������������������������������������Ŀ" SKIP
                "� �祩�� 72�10�450    � �祩�� 100�10�450   � �祩�� 250�10�450   �" SKIP
                "�����������������������������������������������������������������Ĵ" SKIP
                "���/� �� ����        ���/� �� ����        ���/� �� ����        �" SKIP
                "�����������������������������������������������������������������Ĵ" SKIP.
                
DO i = 1 TO max_keys_count :
		PUT UNFORMATTED 
			"�" IF keys_c1[i] = "" THEN "     " ELSE STRING(i,">>>>>") 
			"�" keys_c1[i] FORMAT "X(15)"
			"�" IF keys_c2[i] = "" THEN "     " ELSE STRING(i + index_c1,">>>>>") 
			"�" keys_c2[i] FORMAT "X(15)"
			"�" IF keys_c3[i] = "" THEN "     " ELSE STRING(i + index_c1 + index_c2, ">>>>>") 
			"�" keys_c3[i] FORMAT "X(15)" 
			"�" SKIP.
END.

PUT UNFORMATTED "�����������������������������������������������������������������Ĵ" SKIP
                "��⮣��" index_c1 FORMAT ">>>>>>>>>>>>>>9" 
                "��⮣��" index_c2 FORMAT ">>>>>>>>>>>>>>9" 
                "��⮣��" index_c3 FORMAT ">>>>>>>>>>>>>>9" 
                "�" SKIP
                "�������������������������������������������������������������������" SKIP.


count = index_c3 + index_c2 + index_c1.
Run x-amtstr.p(count, "", false, true, output countStr[1], output countStr[2]).
PUT UNFORMATTED " �ᥣ�: " count " (" TRIM(countStr[1]) ") ����(�,��)" SKIP(2)
                "������� �ਭ� ________________               ������� ᤠ� _________________" SKIP
                "                   (�������)                                     (�������)    " SKIP(2)
                "��� ��।��                                  ��� �ਥ��" SKIP.


{preview.i}