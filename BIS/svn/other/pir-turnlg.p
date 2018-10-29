{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-turnlg.p,v $ $Revision: 1.4 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ��� �� "�p������������"
��稭�       : �� �� 10.09.2007, �⤥� ��⨢�����⢨� ��������樨 ��室��, �⨭� �.�
�����祭��    : ����⭠� ��������� �� ��ਮ� �� �����⠬, ������ ������ �ॢ�ᨫ� ��ண���� �㬬�.
���� ����᪠ : ��/�����/����� �� ��楢� ��⠬/����⭮-ᠫ줮�� ��������/����.ᠫ�. ���������, �� ��⠬ �ॢ��. ������. ������
����         : $Author: anisimov $ 
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.3  2007/10/05 08:17:18  kuntash
���������     : изменение условий
���������     :
���������     : Revision 1.2  2007/09/14 07:14:21  lavrinenko
���������     : �������� ��⮪����� ����᪮�
���������     :
���������     : Revision 1.1  2007/09/13 07:24:11  lavrinenko
���������     : ����⪠ � ��ண�� ��� �⤥�� ��⨢�����⢨� ���������樨
���������     :
------------------------------------------------------ */
{globals.i}
{chkacces.i}
{sh-defs.i}
{wordwrap.def}


{ifndef {&format}}
   &GLOB format ->>>,>>>,>>>,>>9.99
{endif} */

DEFINE VAR long-acct AS   CHAR FORMAT "x(25)" COLUMN-LABEL "������� ����" NO-UNDO.
DEFINE VAR name      AS   CHAR FORMAT "x(35)" EXTENT 10 COLUMN-LABEL "������������" NO-UNDO.

DEFINE TEMP-TABLE tt-Acct  NO-UNDO
   FIELD fAcct       LIKE acct.acct
   FIELD fIn-bal     LIKE acct-pos.balance
   FIELD Fdb         LIKE acct-pos.debit  
   FIELD fcr         LIKE acct-pos.credit
   FIELD fbal        LIKE acct-pos.balance
   INDEX iAcct       IS UNIQUE PRIMARY  fAcct
   INDEX iturn Fdb Fcr DESCENDING
.


{getdates.i}
{getturns.i}

{get-fmt.i &obj=b-Acct-Fmt}

{empty tt-Acct}
 
{justamin}
FOR EACH acct WHERE CAN-DO('�,�',acct.cust-cat)   AND 
                    acct.acct-cat    EQ 'b'       AND
                    (acct.close-date EQ ?         OR
                     acct.close-date GE beg-date  AND
                     acct.open-date  LE end-date) NO-LOCK :
    {on-esc RETURN}                          
    RUN acct-pos IN h_base (acct.acct, acct.currency, beg-date, end-date, ?).
    
    IF (sh-db GE min-turn OR sh-cr GE min-turn) AND
       (sh-db LE max-turn OR sh-cr LE max-turn) THEN DO:
        CREATE tt-Acct.
        ASSIGN
           tt-acct.fAcct     = acct.acct
           tt-acct.fIn-bal   = ABS(sh-in-bal)
           tt-acct.Fdb       = ABS(sh-db)
           tt-acct.fcr       = ABS(sh-cr)
           tt-acct.fbal      = ABS(sh-bal)
        .
    END.
END. /* FOR EACH acct WHERE CAN-DO('�,�',acct.cust-cat) */

{setdest.i &cols="200"}

FOR EACH tt-Acct NO-LOCK,
    FIRST acct WHERE acct.acct EQ tt-acct.facct NO-LOCK 
    BY tt-acct.Fdb DESCENDING ON ENDKEY UNDO, LEAVE:
  
FORM  long-acct
      acct.Curr
      tt-Acct.fIn-bal     COLUMN-LABEL "��. �������!�����"  FORMAT "{&format}" 
      tt-Acct.Fdb         COLUMN-LABEL "������ ��!������"   FORMAT "{&format}" 
      tt-Acct.fcr         COLUMN-LABEL "������ ��!�������"  FORMAT "{&format}" 
      tt-Acct.fbal        COLUMN-LABEL "���. �������!�����" FORMAT "{&format}" 
      NAME[1]
 HEADER  CAPS(name-bank) FORMAT "x(70)" SKIP
        "��������-��������� ��������� �� " + CAPS({term2str Beg-Date End-Date})  FORMAT "x(69)"

  SKIP(2)
  WITH NO-BOX WIDTH 400
.

  {getcust.i &name="name" &offinn="/*"}
  name[1] = TRIM(name[1] + " " + name[2]).
  {wordwrap.i &s=name &l=35 &n=10}  
  
  DISPLAY {out-fmt.i tt-Acct.facct fmt} @ long-acct
          acct.Curr
          tt-acct.fIn-bal  
          tt-acct.Fdb      
          tt-acct.fcr      
          tt-acct.fbal
          NAME[1]
  .
END.
{preview.i}

{pir-log.i &module="$RCSfile: pir-turnlg.p,v $" &comment="����⭠� ��������� �� ��ਮ� �� �����⠬, ������ ������ �ॢ�ᨫ� ��ண���� �㬬�."}