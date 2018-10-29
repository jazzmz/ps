{pirsavelog.p}

/** 
		��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007

		��ନ��� ���� �� �㬬�� ���⪮� �� ���� ������஢ �� �� ����. ����� ��㯯������� � ��ॣ�������.
		
		<����> : ���� �.�., <�६�_ᮧ����� [F7]> : 22.06.2007 14:07
		
		<���_����᪠����> �� �� - �����
		<��ࠬ���� ����᪠>
		<���_ࠡ�⠥�>
		<�ᮡ������_ॠ����樨>
		
		��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
		          <���ᠭ�� ���������>

		��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
		          <���ᠭ�� ���������>

*/

{globals.i}

{setdest.i}

def var name as char extent 5 init ["x <=100","100< x <=400","400< x <=500","500< x <=700", "700 < x"]  NO-UNDO.
def var summa as decimal extent 5 init [0, 0, 0, 0, 0]  NO-UNDO.
def var cnt as integer extent 5 init [0, 0, 0, 0, 0] NO-UNDO.

def var i as integer  NO-UNDO.

def var bal as decimal NO-UNDO.

{getdate.i}

for each acct where can-do("!42301*,!42601*,!42309*,!42609*,4230*,4260*", acct.acct) 
                    and (acct.close-date = ? or acct.close-date > end-date)
                    and acct.open-date <= end-date no-lock,
    last acct-pos where acct-pos.acct = acct.acct 
         and
         acct-pos.since le end-date no-lock
        
    :
        bal = abs(acct-pos.balance).
        
        if bal <= 100000 then 
            i = 1.
        if (bal > 100000) and (bal <= 400000) then
            i = 2.
        if (bal > 400000) and (bal <= 500000) then
            i = 3.
        if (bal > 500000) and (bal <= 700000) then
            i = 4.
        if bal > 700000 then 
            i = 5. 
                   
        summa[i] = summa[i] + bal.
        cnt[i] = cnt[i] + 1.
end.

do i = 1 to 5 :
    put unformatted name[i] format "x(20)" 
            summa[i] format ">>>,>>>,>>>,>>>,>>9.99" 
            cnt[i] format ">>>>>>>>>>>" skip.
end.

{preview.i}