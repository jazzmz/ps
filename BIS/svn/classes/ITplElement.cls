INTERFACE ITplElement:
 /*
   ����䥩� ��� ��� ᫮����� �������
   蠡�������� TTpl
 */
METHOD PUBLIC VOID show().			                                                /* �뢮��� ������� �� ��࠭ */
METHOD PUBLIC VOID setPropertyByStr(INPUT cPropertyName AS CHAR,INPUT cPropertyValue AS CHAR).	/* ��⠭�������� ���祭�� ᢮��⢠ */
METHOD PUBLIC CHAR getProperty(INPUT cPropertyName AS CHAR).		                        /* ��⠭�������� ���祭�� ᢮��⢠ */
METHOD PUBLIC VOID setIsInTpl(INPUT cProp AS LOGICAL).	                                        /* ��⠭�������� ����, �ᯮ������ �� � 蠡���� */

END INTERFACE.