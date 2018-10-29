/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2003 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: vtb-lim.p
      Comment: ����ﭨ� �����, ��㤭�� ������������� �� ���ﭨ� �� .... 
   Parameters: 
         Uses:                     
      Used by:                     
      Created:
     Modified: 08.08.2003 15:17 KSV      (0010770) ��ࠢ���� ��䮣���᪠�
                                         �訡�� � ��������� ����. ��ࠢ����
                                         �訡�� ��������� �⮣� �� ������
                                         �।�⮢����.
     Modified: 
     Sinhro  : d66
*/

{globals.i}
{sh-defs.i}
{getdate.i}
end-date = end-date - 1.
{intrface.get comm}
{intrface.get xclass}
{intrface.get loan}
{intrface.get instrum}

def var c     as INT64 initial 0  no-undo.
def var name  as char               no-undo.
def var name1 as char    extent  3  no-undo.
def var cmm   as decimal  no-undo.
def var ds    as date     no-undo.
def var r-bad as decimal  no-undo.
def var r$    as decimal  no-undo.
def var db-tmp as decimal     no-undo.
def var cr-tmp as decimal     no-undo.
def var s-limit$ as decimal no-undo.
def var s-limit  as decimal no-undo.

{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

/** PIR **********************************/
   DEFINE VARIABLE ResAcct    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE ResAcctBal AS CHARACTER NO-UNDO.

{strtout3.i &col=176}
put unformatted "����ﭨ� �����, ��㤭�� ������������� �� ���ﭨ� �� " 
   (end-date + 1) skip(2).


for each tmprecid,
    each loan where recid(loan) = tmprecid.id
                and loan.close-date eq ?
                no-lock
    break by loan.cont-code :
  c = c + 1. display c format ">>>9" column-label "�/�" .

  /* ����騪 */
  run GetCustName IN h_base(loan.cust-cat,loan.cust-id,?,
                            output name1[1],
                            output name1[2],
                            input-output name1[3]).
  name = trim(name1[1] + " " + name1[2]).
  display name format "x(20)" column-label "����騪" with scrollable .

  /* ����� �।.ᮣ��襭��  */
  display loan.cont-code column-label "� ��".

  /* ��� �����祭�� ��. */
  display loan.open-date column-label "���!�����祭�� ��".

  /*%�⠢��� */
  r-bad = 0.
  r-bad = decimal(GetXattrValueEx("loan",
                                  loan.contract + "," + loan.cont-code,
                                  "���_���",
                                  ?)) no-error.

  display
    /*%�⠢�� �� ��.������. */
    GET_COMM ("%�।",
              ?,
              loan.currency,
              loan.contract + "," + loan.cont-code,
              0.0,
              0,
              end-date)
    format ">>>9.9999" column-label "% �⠢��!�� ��.!������."

    /* ��.�⠢�� ���.�� ���믮������ �᫮��� */
    r-bad
    format ">>>9.9999" column-label "% �⠢��!�� ��.!���.��!����.!��."
    when r-bad ge 0

    /* %�⠢�� �� ����.������. */
    GET_COMM ("%����",
              ?,
              loan.currency,
              loan.contract + "," + loan.cont-code,
              0.0,
              0,
              end-date)
    format ">>>9.9999" column-label "% �⠢��!�� ����.!������."
  .

  /* �ப ����襭�� */
  display loan.end-date column-label "�ப!����襭��".

  /* ��� 㯫��� ��業⮢ */
  find last loan-cond where loan-cond.contract = loan.contract
                        and loan-cond.cont-code = loan.cont-code
                        and loan-cond.since le end-date no-lock no-error.
  
  if avail loan-cond then do:
    display  
      (if loan-cond.int-period ne "�"
      then string((loan-cond.int-date + loan-cond.delay) modulo 31 , ">9")
      else "  ")
      format "x(2)" column-label "���!㯫��� %"
    .
  end.

  /*----------------------------------------------------------------  
      ����� �।�⮢���� � $
   ---------------------------------------------------------------*/
  if avail loan-cond then do:
    /* Commented by KSV: ���ଠ�� � ����� �।�⮢���� ��� �祭�� �뢮�����
    ** � �墠�뢠�饬 �������, �.�. �������� �஡��� � ���������� �⮣�� */
    IF NOT loan.cont-code MATCHES "* *" THEN
       run RE_PLAN_SUMM_BY_LOAN in h_loan (loan-cond.contract,
                                           loan-cond.cont-code,
                                           loan-cond.since,
                                           output s-limit).
    ELSE
       s-limit = 0.
      
    if  GetXattrValueEx("loan", loan.contract + "," + loan.cont-code, "���_���",?) = "1"
    then do:
      /* ��� ᮣ��襭�� */
      assign ds = date (GetXattrValueEx("loan", loan.contract + "," + loan.cont-code, "��⠑���",?)) no-error. 
      if ds eq ? then do:
        put unformatted skip(2) "�訡��!!! �� ������� ���祭�� ���.४����� ��⠑���!" skip(2) .
      end. else do:
        /* ������ � $ ����� */
        s-limit$ = CurToCur("����", loan.currency, "840", ds, s-limit). 
        r$ = findRate("����", "840", ds).

        display s-limit$  format "->>>>>>>>>>>9.99"  column-label "�����!�।�⮢����,$"
                r$        format "->>>>>9.9999"      column-label "���� $!�� ����!��-�".
        accumulate s-limit$ (total).
      end.
    end.

      /*----------------------------------------------------------------
         ��㤭.������������ � ����� �।�⮢���� � �㡫��.
      ----------------------------------------------------------------*/
      def var params as decimal extent 3 no-undo.  /* ��� ���᫥��� 0 7 13 ��ࠬ��஢ ������� */
      params = 0.
      run param_0      in h_loan (loan.contract, loan.cont-code,  0, end-date, output params[1], output db-tmp, output cr-tmp).
      run stndrt_param in h_loan (loan.contract, loan.cont-code,  7, end-date, output params[2], output db-tmp, output cr-tmp).
      run param_13     in h_loan (loan.contract, loan.cont-code, 13, end-date, output params[3], output db-tmp, output cr-tmp).
            
      params[1] = params[1] + params[2] + params[3].

      /* �㬬� ������������ � ����� �।�⮢���� � �㡫�� �� ����� ��
         �� ���� ����祭�� �������� */

      if loan.currency ne "" then do:
        r$ = findRate("����", loan.currency, end-date). 
        params[1] = round(params[1] * r$, 2).
        s-limit   = round(s-limit * r$, 2).
      end.

      display params[1] format "->>>>>>>>>>>9.99"  column-label "�㬬�!������������"
              s-limit   format "->>>>>>>>>>>9.99"  column-label "�����!�।�⮢����"  .

/*****************************   �뢮� ���⪠ �� ���� १�ࢠ ************************/

      FOR EACH loan-acct OF loan
         WHERE (loan-acct.acct-type = "�।���")
         :

         RUN acct-pos in h_base (loan-acct.acct, loan-acct.currency,end-date,end-date, chr(251)).
         ASSIGN
            ResAcct = loan-acct.acct
            ResAcctBal = STRING( ROUND(ABSOLUTE(sh-bal),2) )
         .
      END.

      DISPLAY ResAcct    FORMAT "X(20)" COLUMN-LABEL "���!����ࢠ".
      DISPLAY ResAcctBal FORMAT "X(15)" COLUMN-LABEL "�����".

      ResAcct    = "".
      ResAcctBal = "".

     accumulate params[1] (total)
                 s-limit (total) .

     if last(loan.cont-code) then do:
       underline name
                 s-limit$
                 params[1]
                 s-limit .

       down.
       display "�⮣�:" @ name
                accum total s-limit$ @ s-limit$
                accum total params[1] @ params[1]
                accum total s-limit @ s-limit .

     end.
  end. /* avail loan-cond */
end.
{signatur.i}
{endout3.i &nofooter=yes}
