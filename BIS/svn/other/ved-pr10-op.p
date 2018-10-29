{pirsavelog.p}

 {globals.i}

DEF INPUT PARAMETER in-cont-code LIKE loan.cont-code NO-UNDO.

def var date-beg_  as date    no-undo.
def var rest_      as decimal no-undo.
def var date-end_  as date    no-undo.
def var quantity_  as decimal no-undo.
def var rate_      as decimal no-undo.
def var account_   as decimal no-undo.
def var total_     as decimal no-undo.
def var kod-st_    as char .
def var date_  as date    no-undo.
def var in-date  as date    no-undo.


def stream err.

DEFINE TEMP-TABLE tloan FIELD tloan-cond AS CHAR  
                        field tdate-beg_ as date    
                        field trest_     as decimal 
                        field tdate-end_ as date     
                        FIELD tquantity_ as decimal  
                        field trate_     as decimal 
                        field taccount_  as decimal 
                        field ttotal_    as decimal 
                        field tkod-st_   as char 
                        field tdate_     as date    
                        Index x tdate_ tloan-cond  tdate-beg_  tdate-end_.

{setdest2.i &stream="stream err" &filename="spool.tmp " &cols=160}

DEF VAR mContract-date AS DATE NO-UNDO. /*Плановая дата документа*/
DEF VAR mBranch        AS CHAR  NO-UNDO. /*подразделение*/
DEF VAR mDataClass-ID AS CHAR NO-UNDO INIT "dps-nach1". /*класс документа*/
DEF VAR txt AS CHAR EXTENT 2.
DEF VAR sym AS CHAR EXTENT 2.

FIND FIRST loan WHERE loan.contract = "dps"
    AND loan.cont-code = in-cont-code
    NO-LOCK NO-ERROR.


ASSIGN
    mBranch = GetUserBranchId(loan.user-id)
    in-date = loan.open-date.
   .



FOR EACH Datablock NO-LOCK WHERE DataBlock.DataClass-Id = mDataClass-ID  
                             AND Datablock.Branch-Id = mBranch 
                             AND Datablock.beg-date >= in-date, 
                             EACH Dataline OF Datablock NO-LOCK WHERE DataLine.Sym2 = STRING(loan.contract) + "," + string(loan.cont-code) .
   
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

   find first tloan where tloan.tloan-cond  = in-cont-code
                 and tloan.tdate-beg_  = date-beg_
                 and tloan.tdate-end_  = date-end_
                 and tloan.tkod-st_    = kod-st_
                 and tloan.trest_      = rest_    
                 no-error.
   if not avail tloan 
   then do:
      Create tloan.
      Assign
         tloan.tloan-cond  = in-cont-code 
         tloan.tdate-beg_  = date-beg_
         tloan.tdate-end_  = date-end_
         tloan.tkod-st_    = kod-st_
         tloan.trest_      = rest_
         tloan.tquantity_   = quantity_
         tloan.trate_       = rate_    
         tloan.taccount_    = account_ 
         tloan.tdate_ = Datablock.beg-date
      .       
   end.   
end.

total_ = 0.
for each tloan.
    total_ = total_ + round(tloan.taccount_,2).
    tloan.ttotal_    =  total_  .
end.


for each tloan.  

Assign
   date_        =  tloan.tdate_
   in-cont-code   =  tloan.tloan-cond 
   date-beg_      =  tloan.tdate-beg_ 
   date-end_      =  tloan.tdate-end_ 
   kod-st_        =  tloan.tkod-st_   
   rest_          =  tloan.trest_     
   kod-st_        =  tloan.tkod-st_
   quantity_      =  tloan.tquantity_ 
   rate_          =  tloan.trate_     
   account_       =  tloan.taccount_  
   total_         =  tloan.ttotal_    
.
form
    date_         form "99/99/9999" column-label "Дата"
    in-cont-code  form "x(20)" column-label "Номер вклада"
    date-beg_        form "99/99/9999" column-label "С"
    date-end_    form "99/99/9999" column-label "ПО"
    quantity_           column-label "Колич.дней"
    rest_        form ">>>>>>>>>9.99"   column-label "Остаток"
    rate_           column-label "Ставка"
    kod-st_      form "x(15)"   column-label "Код   Вид вклада "
    account_     form ">>>>>>>>>9.9999"   column-label "Начислено %"
    total_       form ">>>>>>>>>9.9999"   column-label "Итого %"
    header  skip
    dept.name-bank "СТР.:" at 138
    page-number (err) format ">>9" at 144 skip (2)
with frame prn down width 160 title "ВЕДОМОСТЬ ПО ВКЛАДУ"  .


/* loan_:
*/
      display stream err
            date_
            in-cont-code
            date-beg_
            date-end_
            quantity_
            rest_    
            rate_    
            kod-st_
            account_ 
            total_   
            with frame prn.
      down stream err.
end.

{dpsproc.def END-USE-PROC}


find _user where _user._userid eq userid('bisquit') no-lock no-error.

display stream err skip (2) "Исполнитель:"
    "_________________________" at 20
    _user._user-name format "x(30)"  no-label at 48.

{preview2.i &stream="stream err" &filename="spool.tmp"}


