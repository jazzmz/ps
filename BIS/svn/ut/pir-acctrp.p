/*****************************************
 *
 * ���� �� �������⥫�� ४����⠬
 * ��楢�� ��⮢.
 *
 *****************************************
 *
 * ����         : ��᫮� �. �. Maslov D. A.
 * ��� ᮧ����� : 20.11.12
 * ���        : #1780
 *
 *****************************************/

 {globals.i}
 {tmprecid.def}
 {intrface.get xclass}
 {intrface.get db2l}

 /**
  * ��⮢ �㤥� ����� ���⮬�
  * ����� �ᯮ�짮���� TTable.
  **/
 {setdest.i}

  PUT UNFORMATTED "������������ ���" FORMAT "x(35)" "|" "������������ ���" FORMAT "x(20)" "|" "���祭�� ��" SKIP.
  PUT UNFORMATTED " " SKIP.                                          

 /**
  * �� ��� #1949
  *
  **/
 FOR EACH tmprecid NO-LOCK,
   FIRST acct WHERE RECID(acct) EQ tmprecid.id NO-LOCK 
   BY INT(SUBSTRING(acct.acct,1,5)) BY INT(SUBSTRING(acct.acct,12,9)):


   PUT UNFORMATTED acct.details FORMAT "x(35)" "|"
                   acct.acct FORMAT "x(20)" "|"
                   getXAttrValueEx("acct",getSurrogateBuffer("acct",BUFFER acct:HANDLE),"�ਬ1","-") SKIP.
 END.

 {preview.i}
 {intrface.del}