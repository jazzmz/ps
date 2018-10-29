/*************************************
 *                                     *
 * ��७��� �������᪨� ����樨  *
 * �� ������ ��� � ��㣮� ����.             *
 *                                   *
 *************************************
 * ���� : ��᫮� �. �. Maslov D. A. *
 * ���: #943                      *
 * ���  : 03.04.12                  *
 *************************************/


 DEF TEMP-TABLE ttLoanInt LIKE loan-int.

 DEF VAR oldDate  AS DATE INIT 04/28/2012 NO-UNDO.
 DEF VAR newDate  AS DATE INIT 04/30/2012 NO-UNDO.

 /**
  * �����頥� ���ᨬ���� ����� ����樨,
  * �� �������� � ���.
  * @cLoan BUFFER ����� �� �������
  **/
 FUNCTION getLastNum RETURN INT(INPUT cLoan AS HANDLE,INPUT dDate AS DATE):
    DEF BUFFER loan-int FOR loan-int.
    DEF VAR iMax AS INT INIT 0 NO-UNDO.

    FOR EACH loan-int WHERE loan-int.contract  EQ "�।��"
                        AND loan-int.cont-code EQ cLoan::cont-code
                        AND loan-int.mdate     EQ dDate:
           IF iMax < loan-int.nn THEN iMax = loan-int.nn.
    END.
   RETURN iMax.
 END FUNCTION.

FOR EACH loan-int WHERE (loan-int.id-d EQ 33 OR loan-int.id-k EQ 33)
                     AND loan-int.contract EQ "�।��"
                     AND loan-int.cont-code BEGINS "��"
                     AND loan-int.mdate    EQ oldDate,
  FIRST loan WHERE loan.contract EQ "�।��" 
               AND loan.cont-code EQ loan-int.cont-code NO-LOCK:

   CREATE ttLoanInt.
   BUFFER-COPY loan-int TO ttLoanInt.
   ASSIGN
     ttLoanInt.nn    = getLastNum(BUFFER loan:HANDLE,newDate) + 1
     ttLoanInt.mdate = newDate
   .
    DELETE loan-int.
END.
FOR EACH ttLoanInt:
 CREATE loan-int.
 BUFFER-COPY ttLoanInt TO loan-int.
/* DISPLAY ttLoanInt.*/
END.
TEMP-TABLE ttLoanInt:WRITE-XML("file","./res.xml",TRUE,"UTF-8",?,?,?,?).