/* ����: �����騩 �ਯ� ����室�� ��� �ᯥ譮�� �⪠� �࠭���樨
   ������ ������� ��� (����� ��, � �� ���). ��� ���᭨���� � ������஢ ���
   ⮦�.
   ����᪠�� ��। 㤠������ (�⪠⮬) ᠬ�� ����樨.
   ��। ����᪮� ����室��� ������ ���祭�� ��������� ����⠭�.
   ����: ������� ᨬ��� CHR(5), ��室�騩�� ����� "�����" � ����஬
   �������, �� ᨬ��� ",", ��⮬� �� ⠪ �� ��࠭���� � history.
   
   ��᪮�������� ���� ����䨪��� SQL!
*/

/** ��� ������� - ���: �।�� ; ���: ����� */ 
&GLOBAL-DEFINE CONT_TYPE �����
/** ����� ������� */
&GLOBAL-DEFINE CONT_CODE 3-0880/0001/�
/** ��� �����ᨨ ���: %�। � %���; ���: SafeRent */
&GLOBAL-DEFINE COMM_CODE SafeRent
/** ��� ��砫� �᫮��� (��� ������ �������) � �ଠ� ��/��/�� */
&GLOBAL-DEFINE SINCE 25/09/07
/** ����� �������. ���⮥ ���祭��, �᫨ ����� - �㡫� */
&GLOBAL-DEFINE CURR 

select surrogate format "x(50)" from signs where 
file-name = "comm-rate" and code = "class-code" and surrogate like 
"{&COMM_CODE}%{&CONT_TYPE}%{&CONT_CODE}%{&SINCE}".

/** ��᪮�������� ����� ��� ࠡ��� */


do:
disable triggers for load of signs.
update signs set surrogate = "{&COMM_CODE},0,{&CURR},{&CONT_TYPE},{&CONT_CODE},0,0,{&SINCE}" where
file-name = "comm-rate" and code = "class-code" and surrogate like
"{&COMM_CODE}%{&CONT_TYPE}%{&CONT_CODE}%{&SINCE}".                                           
end.


