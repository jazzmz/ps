{globals.i}
{sh-defs.i}
{getdate.i}
/*{getdates.i}  �������� ��� */

DEFINE TEMP-TABLE ttResults
   FIELD ttf_card AS CHAR
   FIELD ttf_fio AS date
   FIELD ttf_ucs AS dec FORMAT "->>>>,>>>,>>>,>>9.99"
   FIELD ttf_bis AS dec FORMAT "->>>>,>>>,>>>,>>9.99"
INDEX idx_card IS PRIMARY ttf_card.

DEFINE VAR ACC AS CHAR   NO-UNDO.
DEFINE VAR VAL AS CHAR   NO-UNDO.
DEFINE VAR bisost AS dec NO-UNDO.


for each op-int  
 	 where
       substr(surrogate,1,4) ne "card"
 	and  create-date eq end-date
 	no-lock: 
 	 	
if AVAIL op-int then 
 Do: 	 	
 	
 	ACC=SUBSTR(surrogate,1,20).
 	val=SUBSTR(surrogate,6,3).

 	if val = "810" then val = "".
	
 	/*���⮪ � ���*/
 	RUN acct-pos IN h_base (acc,
                          val,
                          end-date,
                          end-date,
                          gop-status).
 	/*++++++++++++++++++++++++++++++++++++++++*/
 	
 			bisost= (if val = "" then abs(sh-bal) else abs(sh-val)).
  if bisost ne op-int.par-dec[3]  then
    DO:
 			CREATE ttResults. 

          ASSIGN 
          	 ttResults.ttf_fio  = op-int.create-date
             ttResults.ttf_card = acc
	           ttResults.ttf_ucs  = op-int.par-dec[3]
	           ttResults.ttf_bis  = bisost.
	   END.    			
 		end. /* ��� 横�� */
 end.  /* ��� �롮ન */
 

{setdest.i &cols=200}
PUT UNFORMATTED "                  ������ ��������".

FOR EACH ttResults where   ttResults.ttf_ucs <> ttResults.ttf_bis:
DISPLAY 
   ttResults.ttf_fio label ""
   ttResults.ttf_card LABEL "� ���" FORMAT "x(20)"
   ttResults.ttf_ucs LABEL "UCS ���⮪" 
   ttResults.ttf_bis LABEL "BIS ���⮪".
end.  
   
 {preview.i}
