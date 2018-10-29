{pirsavelog.p}

/*                          
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2001 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: dps_chk.p
      Comment: �஢��筠� ��������� �� �������.
               �ࠢ������ ���⪨ �� �������᪨� ��⠬, � ������ ����
               �㡠������᪨� ���, �ਢ易��� �� �������, �
               �� �㡠������᪨� ���⪨.
   Parameters:
      Created: Om 16/11/01
     Modified: Om 21/11/01 ��ࠡ�⪠: �஢�ઠ �� ����⢮�����
                                �㡠������᪨� 蠡�����.
*/

Form "~n@(#) dps_chk.p 1.0 Om 16/11/01"
with frame sccs-id stream-io width 250.

{globals.i}
{tmprecid.def}   /* �६����� ⠡��� � ᯨ᪮� ��࠭��� ������� */
{dps_chk2.us}     /* ��।������ �६����� ⠫�� ��� ���� � ��� ����. */

{sh-defs.i}      /* ��६���� ��� ����祭�� �������᪮�� ���⪠ �� ����. */
{ksh-defs.i new} /* ��६���� ��� ����祭�� �㡠�����-�� ���⪠ �� ����. */

define var vCountInt as int     no-undo. /* ���稪 ��ࠡ�⠭��� ������� */
define var vTotalInt as int     no-undo. /* ��饥 ���-�� ������� */
define var vKauChar  as char    no-undo. /* �㡠������᪨� ���ண�� */
define var vTmpDec   as decimal no-undo. /* �६����� ���祭�� ���⪠ */
define var vAllLog   as logical
                     format "ࠧ����/��       "
                     init Yes
                                no-undo. /* ��४���⥫� �⮡ࠦ���� ����ᥩ */

/* ����室��� ��� ���ࠨ����� � getdate.i
** ᥫ���� �롮ન */
form
    end-date
    vAllLog
        label "�뢮����"
        help "������ - �������� ⨯ �⮡ࠦ����"
with frame dateframe2.

on ' ' of vAllLog in frame dateframe2
do:
    frame-value = if trim(frame-value) eq "��" then Yes else No.
end.

/* ���� ����, ���᪠��� �� ���������
** �롮� ���� */
{getdate.i
    &UpdAfterDate = "vAllLog"
}

/* ��室 �᫨ ��� �� ������ �⮡࠭���� ������� */
if not can-find(first tmprecid)
then return.

{init-bar.i "���㭤���..."}

/*  ������ ��饣� �᫠ ����ᥩ */
for each tmprecid:
    vTotalInt = vTotalInt + 1.
end.

/* ��ନ஢���� ���� */
GET_LOAN:
for each tmprecid,
    first loan where
        recid(loan) eq tmprecid.id
    no-lock,
    each loan-acct of loan where
        loan-acct.since le end-date and
        can-find (first code where
                    code.class eq "�������" and
                    code.code  eq loan-acct.acct-type
                  no-lock)
    no-lock,
    first acct of loan-acct
    no-lock
break
    by loan.cont-code:

    /* ������ ⠡���� ���� */
    create ttDpsChkRep.

    ASSIGN
        ttDpsChkRep.cont-code = loan.cont-code
        ttDpsChkRep.acct-type = loan-acct.acct-type
        ttDpsChkRep.acct      = acct.acct
        ttDpsChkRep.currency  = acct.currency
    .

    /* ��ନ஢���� �������᪮�� ���⪠ */
    run acct-pos in h_base (acct.acct,
                            acct.currency,
                            end-date,
                            end-date,
                            gop-status).


    /* ����祭�� �������������� ���⪠ ��� � ����� ��� */
    ttDpsChkRep.acct-pos = if acct.currency eq ""
                           then sh-bal
                           else sh-val.

    /* ����祭�� ����������������� ���⪠ ��� � ����� ��� */
    for each code where
        code.class  eq "loan-acct" and
        code.parent eq loan-acct.acct-type
    no-lock:

        /* ��ନ஢���� �㡠����⨪� */
        vKauChar = loan.contract + ',' + loan.cont-code + ',' + code.code.

        /* ����祭�� ���⪠ �� ��. ���� */
        run kau-pos.p(acct.acct,     /* ��� */
                      acct.currency, /* ����� ��� */
                      end-date,      /* ���⮪ ��  */
                      end-date,      /* ���� end-date */
                      gop-status,    /* ����� �஢���, � ������ �����뢠�� */
                      vKauChar).     /* �㡠������᪨� ���⮪ */

        /* ��. ���⮪ � ����� ��� */
        vTmpDec = if acct.currency eq ""
                  then ksh-bal
                  else ksh-val.

/* message "" code.name acct.acct loan.cont-code vTmpDec. pause. */

        if code.name matches ("*��業�*")
	and acct.acct EQ loan.cont-code
        then ttDpsChkRep.kau-proc = vTmpDec.
        else ttDpsChkRep.kau-pos  = vTmpDec.
    end.

    /* ��ନ஢���� ࠧ���� ���⪮� */
    ttDpsChkRep.RemDiff = ttDpsChkRep.acct-pos -
                          (ttDpsChkRep.kau-pos /* + ttDpsChkRep.kau-proc*/ ).

    /* ���稪 ��ࠡ�⠭��� ����ᥩ */
    if last-of (loan.cont-code)
    then do:
        vCountInt = vCountInt + 1.
        {move-bar.i vCountInt vTotalInt}
    end.
end.

/* �������� progress bar */
{del-bar.i}

/* �᫨ ⠡��� ���� ����,
** � ᮮ�頥� � ��室�� */
if not can-find (first ttDpsChkRep)
then do:
    message color darkgray/gray "���� ����!"
    view-as alert-box message buttons Ok.

    return.
end.

/* ����� �������� */
{setdest.i}

for each ttDpsChkRep where
    vAllLog     and ttDpsChkRep.RemDiff ne 0 or
    not vAllLog and true
with frame DpsChkRepFrm
break
    by ttDpsChkRep.cont-code:

    display
        ttDpsChkRep.cont-code   when first-of (ttDpsChkRep.cont-code)
        ttDpsChkRep.acct-type
        ttDpsChkRep.acct     
        ttDpsChkRep.currency 
        ttDpsChkRep.acct-pos
            format "zzz,zzz,zzz,zz9.99 �"
            when ttDpsChkRep.acct-pos ge 0
            @ ttDpsChkRep.acct-pos
        - ttDpsChkRep.acct-pos
            format "zzz,zzz,zzz,zz9.99 �"
            when ttDpsChkRep.acct-pos lt 0
            @ ttDpsChkRep.acct-pos
        ttDpsChkRep.kau-pos
            format "zzz,zzz,zzz,zz9.99 �"
            when ttDpsChkRep.kau-pos ge 0
            @ ttDpsChkRep.kau-pos
        - ttDpsChkRep.kau-pos
            format "zzz,zzz,zzz,zz9.99 �"
            when ttDpsChkRep.kau-pos lt 0
            @ ttDpsChkRep.kau-pos
        ttDpsChkRep.kau-proc
            format "zzz,zzz,zzz,zz9.99 �"
            when ttDpsChkRep.kau-proc ge 0
            @ ttDpsChkRep.kau-proc
        - ttDpsChkRep.kau-proc
            format "zzz,zzz,zzz,zz9.99 �"
            when ttDpsChkRep.kau-proc lt 0
            @ ttDpsChkRep.kau-proc
        ttDpsChkRep.RemDiff
            format "zzz,zzz,zzz,zz9.99 �"
            when ttDpsChkRep.RemDiff ge 0
            @ ttDpsChkRep.RemDiff
        - ttDpsChkRep.RemDiff
            format "zzz,zzz,zzz,zz9.99 �"
            when ttDpsChkRep.RemDiff lt 0
            @ ttDpsChkRep.RemDiff
    .
    down.

    if last-of (ttDpsChkRep.cont-code)
    then down 1.

end.

/* ����� �ᯮ�쭨⥫� */
{signatur.i &user=/*}

{preview.i}
