{pirsavelog.p}

{globals.i}             /* �������� ��६���� ��ᨨ. */
{tmprecid.def }
{svarloan.def NEW}
{intrface.get cdrep}
{intrface.get tmess}    /* �����㬥��� ��ࠡ�⪨ ᮮ�饭��. */
{intrface.get loan}     /* �����㬥��� ��� ࠡ��� � ⠡��窮� loan. */

def var iGrupParam AS Char INIT "0,7,4,8,10,33,29,21,46,350,351" NO-UNDO.       /*ᯨ᮪ ��ࠬ��஢ �� ����� �஢������ ����襭 �� �࠭� */
def var idate as date NO-UNDO.
def var count as int NO-UNDO.
def var counter as int INIT 0 NO-UNDO.
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
DEFINE INPUT PARAMETER iOpRID     AS RECID NO-UNDO.


DEFINE BUFFER bloan FOR loan. /* ���������� ����. */
DEFINE NEW SHARED STREAM err.
DEFINE NEW SHARED FRAME l.

{setdest.i &stream="stream err" &filename='_spool1.tmp'} 
OS-DELETE '_spool3.tmp'.

RUN SetSysConf IN h_base("AUTOTEST:autotest","yes"). 
RUN SetSysConf IN h_base("Append_spool3","yes").
RUN SetSysConf IN h_base("NoProtocol", "YES").


FUNCTION ParamsClose RETURNS  LOGICAL
   (iContract AS CHAR,
    iContCode AS CHAR,
    iDate     AS DATE,
    iParams   AS CHAR):

   DEFINE VARIABLE vI      AS INT64     NO-UNDO.
   DEFINE VARIABLE vReturn AS LOGICAL     NO-UNDO.

   block-param:
   DO vI = 1 TO NUM-ENTRIES(iParams):
      IF LN_GetParams(iContract,
                     iContCode,
                     REPLACE(ENTRY(vI,iParams),"+",","),
                     iDate) GT 0
      THEN DO:
         vReturn = TRUE.
         LEAVE block-param.
      END.
   END.
   RETURN vReturn.
END FUNCTION. 


idate = in-op-date.


for each loan where loan.contract = "�।��" and (loan.Class-Code = "loan_trans_ov" or loan.Class-Code = "loan_trans_diff") and loan.cont-code begins "��" and loan.close-date = ? NO-LOCK.

      IF ParamsClose(loan.contract,
                     loan.cont-code,
                     iDate,
                     iGrupParam)
      THEN
          count = count + 1.
/*         RUN PutStrem (
            "� ������� � ���ண�⮬ '" + loan.contract + "," + loan.cont-code +
            "������⥫쭠� �㬬� ��ࠬ��஢. ������� �� �㤥� ������.\n").      */
/*	display             "� ������� � ���ண�⮬ '" + loan.contract + "," + loan.cont-code +
            "������⥫쭠� �㬬� ��ࠬ��஢. ������� �� �㤥� ������.". */
      ELSE
do:
         RUN CloseLoan IN h_loan (loan.contract,
                                  loan.cont-code,
                                  iDate,
                                  1).
      counter = counter + 1.
/*message loan.cont-code.*/
end.

end.

  message "������ �࠭襩: " counter VIEW-AS ALERT-BOX.

RUN PutStrem ("\n").
RUN DeleteOldDataProtocol IN h_base("AUTOTEST:autotest"). 
RUN DeleteOldDataProtocol IN h_base("Append_spool3").
RUN DeleteOldDataProtocol IN h_base("NoProtocol").
{preview.i &stream="stream err" &filename='_spool1.tmp'}

define var d      as char    format "x(60)".
form

    a like d at 1 skip
    b like d at 1 skip
    c like d at 1
with frame l
    title "[ �����⨥ ������� ]"
    col 2 row 15 color messages
        top-only overlay no-labels 1 col width 65.

PROCEDURE PutStrem:
   DEFINE INPUT PARAMETER iMess AS CHARACTER   NO-UNDO.
   PUT STREAM err UNFORMATTED iMess.
END PROCEDURE.

PROCEDURE DispMess:
   DEFINE INPUT PARAMETER iMess AS CHARACTER   NO-UNDO.
   
   OUTPUT TO TERMINAL.

   CLEAR FRAME l NO-PAUSE.

   DISP iMess @ a
	loan.cont-code @ c
   WITH FRAME l.

   OUTPUT CLOSE.

   PUT STREAM err UNFORMATTED  " " SKIP iMess SKIP.

END PROCEDURE.


PROCEDURE DispMess2:
   DEFINE INPUT PARAMETER iMess1 AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER iMess2 AS CHARACTER   NO-UNDO.
   
   OUTPUT TO TERMINAL.
   CLEAR FRAME l NO-PAUSE.

   DISP iMess1  @ a
        iMess2  @ b
	loan.cont-code @ c
   WITH FRAME l.

   OUTPUT CLOSE.
   iMess1 = iMess1 + iMess2.
   PUT STREAM err UNFORMATTED " " SKIP  iMess1 SKIP.

END PROCEDURE.

