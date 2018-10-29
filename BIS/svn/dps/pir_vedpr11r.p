{pirsavelog.p}

/** ������஢��: ���� 28.09.2006 15:22
                   ������� � �롮�� �᫮���, ���஥ ��ᥪ��� ����� ����� ������ ����� dps-nach1 
                   � ����� �⠢�� ���᫥��� %�����, �⮡� �� �������� ���᫥���� ��業⮢ ���� 
                   ��������� �㬬.
*/

/* ������஢��: �ନ��� 20.01.2009 
������� ��� ����� ������� �஢��� �������� �����ᨨ (࠭�� �� �����ᨨ �� ���� ������� ��稭����� �� "fixed", ⥯��� �� "fixed" ��� "pir-")  
*/



{globals.i}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

/** ������⥪� �㭪権 ࠡ��� � ������ࠬ� */
{ulib.i}
{get-bankname.i}

DEF INPUT PARAMETER work-date  as date NO-UNDO.
DEF INPUT PARAMETER in-beg-date  as date NO-UNDO.
DEF INPUT PARAMETER in-end-date  as date NO-UNDO.
DEF INPUT PARAMETER mVal as char no-undo.
DEF INPUT PARAMETER mTip as char no-undo.


DEF var cont-code_  LIKE loan.cont-code NO-UNDO.

def var date-beg_  as date    no-undo.
def var rest_      as decimal no-undo.
def var date-end_  as date    no-undo.
def var quantity_  as decimal no-undo.
def var rate_      as decimal no-undo.
def var account_   as decimal no-undo.
def var total_     as decimal no-undo.
def var kod-st_    as char no-undo.
def var Client_    as char no-undo.
def var DBacct_    as char no-undo.
def var CRacct_    as char no-undo.

def var mTip2	as char no-undo.

def stream err.
def var in-cont-code as char no-undo.
def var in-date  as date    no-undo.
def var date_  as date    no-undo.

/* Buryagin 30.11.2005 15:41 ������� ����� �㬬� ���᫥���� ��業⮢ � ���� ���� */
def var total_account_ as decimal initial 0 no-undo.
def var old_loan as char no-undo.

do on error undo, return on endkey undo, return:
    run bran#ot.p ("*", 3).
    if return-value = "error" or keyfunc(lastkey) = "END-ERROR" then
       undo, return.
    if not can-find(first tmprecid) then do:
       message "�� ��࠭� �⤥�����!" view-as alert-box.
       undo, retry.
    end.
end.


DEFINE TEMP-TABLE tloan NO-UNDO
                        Field tbranch    as char
                        FIELD tloan-cond AS CHAR
                        field tdate-beg_ as date
                        field trest_     as decimal
                        field tdate-end_ as date
                        FIELD tquantity_ as decimal
                        field trate_     as decimal
                        field taccount_  as decimal
                        field ttotal_    as decimal
                        field tkod-st_   as char
                        field tdate_     as date
                        field tClient_   as char
                        field tDBacct_  as char
                        field tCRacct_  as char
                        Index x tdate_ tloan-cond  tdate-beg_  tdate-end_.

{setdest2.i &stream="stream err" &filename="spool.tmp " &cols=192}

DEF VAR mContract-date AS DATE NO-UNDO. /*�������� ��� ���㬥��*/
DEF VAR mBranch        AS CHAR  NO-UNDO. /*���ࠧ�������*/
DEF VAR mDataClass-ID AS CHAR NO-UNDO INIT "dps-nach1". /*����� ���㬥��*/
DEF VAR txt AS CHAR EXTENT 2 NO-UNDO.
DEF VAR sym AS CHAR EXTENT 2 NO-UNDO.

/*
ASSIGN
    mBranch = GetUserBranchId(loan.user-id).

ASSIGN
    mBranch = "0012".
*/

 


	put stream err unformatted  "� �����⠬��� 3 " at 128 skip.

  
    put stream err unformatted "��� �� �p������������" at 120 skip(1).
    put stream err unformatted  work-date at 130  "�." at 140 skip(1).
    put stream err unformatted  "������������" at 80 skip(1).
    
    put stream err unformatted  "� ᮮ⢥��⢨� � ���������� ����� ���ᨨ �39-� �� 26.06.98�. ���᫨�� ��業�� �� ������ࠬ ������᪨� ������� ᮣ��᭮ ��������:" at 1 skip(2).
    
    put stream err unformatted  "��������� �� ����������� ��������� �� " at 50 MONTH_NAMES[MONTH(end-date)] at 89 STRING(YEAR(end-date)) FORMAT 'X(4)' at 98     "�." at 103 
    " "  skip(1) .
	    




do in-date = in-beg-date to in-end-date:

for each tmprecid, FIRST branch WHERE recid(branch) = tmprecid.id NO-LOCK.

FOR EACH Datablock NO-LOCK WHERE DataBlock.DataClass-Id = mDataClass-ID  
                             AND Datablock.Branch-Id = branch.Branch-Id
                             
                             
                             AND Datablock.beg-date = in-date ,
                               each Dataline OF Datablock 
                               /** ���� ������� �᫮��� 28.09.2006 15:21 */
                               WHERE not Dataline.txt begins "%�����"
                               /** ���� end */
                               NO-LOCK .




/*message  Dataline.sym1 Dataline.sym2 Dataline.sym3 Dataline.sym4 replace(Dataline.txt, "\n"," "). pause.*/

   
   date-beg_ = date(int(substr(Dataline.sym3,3,2)), 
          int(substr(Dataline.sym3,1,2)),
          int(substr(Dataline.sym3,5,4))).
   rest_      = Dataline.val[1].
   date-end_ = date(int(substr(Dataline.sym4,3,2)),
          int(substr(Dataline.sym4,1,2)),
          int(substr(Dataline.sym4,5,4))).
   quantity_  = Dataline.val[2].
   rate_      = Dataline.val[3].
   account_   = Dataline.val[4].
   total_     = Dataline.val[4].
   kod-st_   = trim(replace(Dataline.txt, "\n"," ")) .
   in-cont-code = substr(Dataline.sym2,5,20).

/* ���� ����� ������ */
   client_ = "".
   find first loan where loan.cont-code  = in-cont-code and CAN-DO("�,���",loan.loan-status)  NO-LOCK NO-ERROR  .
   if avail loan 
   then 
     do:
      
	/*	 message  loan.cont-code  loan.end-date loan.loan-status loan.close-date . pause. */ 
      
      find first person where person.person-id = loan.cust-id.
      if avail person 
      then 
         do:
         	client_ =  trim(person.name-last) + " " + trim(person.first-names). 
         end.

/*  ���� ����ᯮ����樨 ��⮢ */      
     if  date-end_ = in-end-date   then
      do:
      /** ���� ������⭮�� ��� ��� ����᫥��� %% */
	  CRacct_ = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-int", in-end-date , false).
	  /** ���� ��室���� ��� �� ����� %% */
	  DBacct_ = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-expens", in-end-date , false).
	  end.
	 else
	  do:
      /** ���� ������⭮�� ��� ��� ����᫥��� %% */
	  CRacct_ = ""  /* GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-int", date-beg_, false)*/.
	  /** ���� ��室���� ��� �� ����� %% */
	  DBacct_ = ""  /*GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-expens", date-beg_, false)*/.
	  end.
	 . 
	 
     	/*message CRacct_ DBacct_ .  pause.*/

   
     end. /* find first loan */

   find first tloan where tloan.tloan-cond  = in-cont-code
                 and tloan.tdate-beg_  = date-beg_
                 and tloan.tdate-end_  = date-end_
                 and tloan.tkod-st_    = kod-st_
                 and tloan.trest_      = rest_    
                 no-error.
   if not avail tloan and client_ NE "" /*and total_ > 0*/ and date-beg_ GE in-beg-date and date-end_ LE in-end-date
   then 
    do:

    /*  message in-date. pause.  */

      Create tloan.
      Assign
         tloan.tloan-cond  	=	in-cont-code 
         tloan.tClient     	=	Client_ 
         tloan.tdate-beg_  	=	date-beg_
         tloan.tdate-end_  	=	date-end_
         tloan.tkod-st_    	=	kod-st_
         tloan.trest_     	=	rest_
         tloan.tquantity_   =	quantity_
         tloan.trate_       =	rate_    
         tloan.taccount_    =	account_
         tloan.tDBacct_    	=	DBacct_
         tloan.tCRacct_    	=	CRacct_  
         tloan.tkod-st_     =	tkod-st_
         tloan.tdate_  		=	Datablock.beg-date       
       .
    end.   
end.

end.
end.

in-cont-code = "999999999999".
total_ = 0.
for each tloan.
    if tloan.tloan-cond <> in-cont-code 
    then do: 
       total_ = 0.
       in-cont-code = tloan.tloan-cond.
    end.
    total_ = total_ + round(tloan.taccount_,2).
    tloan.ttotal_    =  total_  .
end.


for each tloan.
Assign
   date_        =  tloan.tdate_
   in-cont-code   =  tloan.tloan-cond 
   Client_        =  tloan.tClient_
   date-beg_      =  tloan.tdate-beg_ 
   date-end_      =  tloan.tdate-end_ 
   kod-st_        =  tloan.tkod-st_   
   rest_          =  tloan.trest_     
   quantity_      =  tloan.tquantity_ 
   rate_          =  tloan.trate_     
   account_       =  tloan.taccount_  
   total_         =  tloan.ttotal_
   DBacct_         =  tloan.tDBacct_
   CRacct_         =  tloan.tCRacct_    
.


if mTip EQ "fixed" Then 
	mTip2 = "pir-".
else 
	mTip2 = "abcd"
.

if (substr(in-cont-code,6,3) = mVal and kod-st_ begins mTip) OR 
   (substr(in-cont-code,6,3) = mVal and kod-st_ begins mTip2) then do:
form
/*  date_         form "99/99/9999" column-label "���"         */
    in-cont-code  form "x(20)" column-label "����� ������"
    Client_       form "x(30)" column-label "������"
    date-beg_        form "99/99/9999" column-label "�"
    date-end_    form "99/99/9999" column-label "��"
    quantity_           column-label "�����.����"
    rest_        form ">>>>>>>>>9.99"   column-label "���⮪"
    rate_           column-label "�⠢��"
    account_       form ">>>>>>>>>9.99" column-label "���᫥�� %"
    total_         form ">>>>>>>>>9.99" column-label "�⮣� %"
    DBacct_         form "X(20)" column-label "��� �� ������"
    CRacct_         form "X(20)" column-label "��� �� �।���"
    header  	    skip

/*	"� �����⠬��� 3 " at 128 skip
    cBankName at 120 skip(2)
    in-end-date at 130  "�." at 140 skip(1)
    "������������" at 80 skip(2)
    
    "� ᮮ⢥��⢨� � ���������� ����� ���ᨨ �39-� �� 26.06.98�. ���᫨�� ��業�� �� ������ࠬ ������᪨� ������� ᮣ��᭮ ��������:" at 1 skip(2)
    
    "��������� �� ����������� ��������� �� " at 50 MONTH_NAMES[MONTH(end-date)] at 89 STRING(YEAR(end-date)) FORMAT 'X(4)' at 98     "�." at 103 
    " "  skip(1)*/ 
	    
       
    
    /*dept.name-bank*/ "���.:" at 158    page-number (err) format ">>9" at 164 skip (2)

with frame prn down width 192 title "" .

   if old_loan <> tloan.tloan-cond then
		do:
		put stream err unformatted "" skip(1).
		old_loan = tloan.tloan-cond.
		end.

   display stream err
            /*date_*/
            in-cont-code
            Client_
            date-beg_
            date-end_
            quantity_
            rest_    
            rate_    

/*         kod-st_*/
           account_ 
           total_          
           DBacct_
           CRacct_
              
            with frame prn.
      down stream err.
		total_account_ = total_account_ + round(tloan.taccount_,2).
end.
end.

{dpsproc.def END-USE-PROC}

put stream err unformatted "" skip "�⮣� ���᫥�� %%: " total_account_ format ">>>>>>>>9.99" skip.

find _user where _user._userid eq userid('bisquit') no-lock no-error.

display stream err skip (2) "�ᯮ���⥫�:"
    "_________________________" at 20
    _user._user-name format "x(30)"  no-label at 48.

display stream err skip (2) "����஫��:"
    "_________________________" at 20
    "_______________" at 48.

{preview2.i &stream="stream err" &filename="spool.tmp"}
