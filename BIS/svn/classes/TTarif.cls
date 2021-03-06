using Progress.Lang.*.                        /* ������砥� ��⥬�� ������ �ண��� */

CLASS TTarif:

DEF PROTECTED BUFFER bCode FOR Code. /*���� �� �ࠢ�筨� ����� ������*/
DEF PROTECTED BUFFER bCode-struct FOR Code. /*���� �� ��������*/
DEF PROTECTED BUFFER bCode-date FOR Code. /*���� �� ���� �⢥ত����*/
DEF PROTECTED BUFFER bcomm-rate FOR comm-rate.

    {set-prop.i &aa="since"   &cc="DATE"}
    {set-prop.i &aa="name"   &cc="CHAR"}
    {set-prop.i &aa="TpNum"   &cc="CHAR"}


DEF VAR BaseTp AS CHAR INIT "1" NO-UNDO.

DEF TEMP-TABLE TempComm-Rate 
    field commission like comm-rate.commission
    field currency like comm-rate.currency
    field min-value like comm-rate.min-value
    field since like comm-rate.since
    field acct like comm-rate.acct
    field rate-comm like comm-rate.rate-comm.


CONSTRUCTOR TTarif(INPUT TpNum as CHAR):
 
    InitClassByNum(TpNum).

END CONSTRUCTOR.


CONSTRUCTOR TTarif(INPUT cAcct as CHAR,INPUT dDate as DATE): /*�� ������ ��� � ���*/

  DEF VAR oAcct AS TAcct NO-UNDO.
  def var tempTpNum as CHAR NO-UNDO.

  oAcct = new TAcct(cAcct).
  tempTpNum = oAcct:GetXAttr("PirTarif",dDate).
  if tempTpNum <> ? then InitClassByNum(TpNum).
  else InitClassByClient(oAcct:cust-id,oAcct:cust-cat,dDate).

END CONSTRUCTOR.



CONSTRUCTOR TTarif(INPUT CustID as INT,INPUT CustCat as CHAR,INPUT dDate AS DATE): /*���� ��� �� ������� � ���*/
  InitClassByClient(CustID,CustCat,dDate).
END CONSTRUCTOR.


CONSTRUCTOR TTarif(INPUT CustID as INT64,INPUT CustCat as CHAR,INPUT dDate AS DATE): /*���� ��� �� ������� � ���*/
  InitClassByClient(CustID,CustCat,dDate).
END CONSTRUCTOR.



METHOD PROTECTED VOID InitClassByClient(INPUT CustID as INT,INPUT CustCat as CHAR,INPUT dDate AS DATE):

   DEF VAR oClient AS TClient NO-UNDO.
   def var tempTpNum as CHAR NO-UNDO.
   oClient = new TClient(CustCat,CustId).
   tempTpNum = oClient:getXAttr("PirTarif",dDate).
   if tempTpNum <> ? then InitClassByNum(TpNum).
   else InitClassByNum(BaseTp).

   DELETE OBJECT oClient. 

END METHOD.


METHOD PROTECTED VOID InitClassByClient(INPUT CustID as INT64,INPUT CustCat as CHAR,INPUT dDate AS DATE):

   DEF VAR oClient AS TClient NO-UNDO.
   def var tempTpNum as CHAR NO-UNDO.
   oClient = new TClient(CustCat,CustId).
   tempTpNum = oClient:getXAttr("PirTarif",dDate).
/*   message  tempTpNum VIEW-AS ALERT-BOX.*/
   if tempTpNum <> ? then InitClassByNum(tempTpNum).
   else InitClassByNum(BaseTp).
   DELETE OBJECT oClient. 

END METHOD.


METHOD PROTECTED VOID InitClassByNum(INPUT TpNum as CHAR):
    FIND FIRST bCode where bcode.class = "PirTarifMain" and bcode.code = TpNum NO-LOCK NO-ERROR.
     if available bCode then 
	do:
	  FillProp(BUFFER bcode:HANDLE).
	end.
END METHOD.

METHOD PROTECTED VOID fillProp (INPUT bCodeHandle AS HANDLE):
/*��⮤ �������� ᢮��⢠ ��ꥪ�*/

    ASSIGN
	  name = bCodeHandle::name
	  TpNum = bCodeHandle::code.

    	  since = GetTarifSince().


END METHOD.



                    		
METHOD PUBLIC DATE GetTarifSince():

     RETURN GetTarifSince(TODAY).

END METHOD.




METHOD PUBLIC DATE GetTarifSince(INPUT dDate AS DATE):
     def var max_date as date NO-UNDO.
   
     max_date = 01/01/1099.  /*������� �� �ࠢ�� ��? �� �ࠢ������ � ����� ���祭�� �� ��������*/

     for each bCode-date where bcode-date.class = "PirTarifDate"
			     and bcode-date.name = TpNum
			      NO-LOCK.
	if date(bcode-date.val) >= max_date and date(bcode-date.val) <= dDate then max_date = date(bcode-date.val).
     end.

      if max_date =  01/01/1099 then RETURN ?. else
    
      RETURN max_date.
		
END METHOD.




METHOD PUBLIC LOGICAL IsNewDate(INPUT dDate AS DATE):

  def var bNewDate as logical INIT true NO-UNDO.
    

      FOR EACH bcode-struct where bcode-struct.class = "PirStrTarif" NO-LOCK,
          first comm-rate where comm-rate.commission = bcode-struct.val + "_" + TpNum 
			    and comm-rate.since = dDate NO-LOCK.
	  bNewDate = false.
      END.
  RETURN bNewDate.

END METHOD.




METHOD PUBLIC DATE PrevDate(INPUT dDate AS DATE): /*��� � ���ன �����㥬 */

  def var bNewDate as logical INIT true NO-UNDO.
  def var tempDate as date NO-UNDO.
	
      FOR EACH bcode-struct where bcode-struct.class = "PirStrTarif" NO-LOCK,
          first comm-rate where comm-rate.commission = bcode-struct.val + "_" + TpNum 
			    and comm-rate.since <= dDate NO-LOCK.


	  if tempDate = ? or tempDate < comm-rate.since then tempDate = comm-rate.since.
      END.
  RETURN tempDate.

END METHOD.


METHOD PUBLIC CHAR GetStructKod(INPUT str as CHAR):

find first code where code.class = "PirStrTarif" and code.description[3] MATCHES "*" + str + "*" NO-LOCK NO-ERROR.

if available(code) then RETURN code.val.
else 
DO:
  find first code where code.class = "PirStrTarif" and code.description[3] MATCHES "*" + ENTRY(1,str) + "*" NO-LOCK NO-ERROR. /* �᫨ �� ��諨, ����� ��� ����� ���� �� �ਢ易� � ���� 蠡���� */

  if available(code) then RETURN code.val.
  else 
  DO:
     MESSAGE "��� �࠭���樨 " str "�� ����� �㭪� ��䭮�� �����!" VIEW-AS ALERT-BOX.
     RETURN ?.
  END.
END.

END METHOD.



METHOD PUBLIC DEC GetCommission(INPUT str AS CHAR, INPUT dSumm As DEC, INPUT currency as char, 	INPUT dDate AS DATE): /*������� ࠧ��� �����ᨨ*/

  def var surr as char no-undo.
  def var dRes as dec no-undo.

  surr = getStructKod(str). 
  find last comm-rate where comm-rate.commission = surr  +  "_" + TpNum
			and comm-rate.since <= dDate 
			and comm-rate.min-value <=dSumm
			NO-LOCK NO-ERROR.
/*   message  TpNum surr  +  "_" + TpNum VIEW-AS ALERT-BOX.*/
  if NOT available (comm-rate) then 
       /*�᫨ �� ��諨 ������� �� ��, � �饬 �� ��������.*/
	DO:
           find last comm-rate where comm-rate.commission = surr  +  "_" + BaseTp
	  	 	         and comm-rate.since <= dDate 
  	  	  	         and comm-rate.min-value <= dSumm
				 and comm-rate.currency = currency
			NO-LOCK NO-ERROR.
	END.

  IF NOT AVAILABLE (Comm-rate) then dRes = 0. /*�᫨ �� ��諨 ������� �� �� � �� ��������, � �����頥� 0*/
  else
  do:    /*����� ���� �� ���������� comm-rate + �㬬� ���㬥�� � �����*/
        dRes = IF comm-rate.rate-fixed THEN  comm-rate.rate-comm ELSE (comm-rate.rate-comm / 100) * dSumm.
  END.
  RETURN dRes.
END METHOD.



METHOD PUBLIC VOID CopyToNewDate(INPUT newDate AS DATE).
   def var dPrevDate as date no-undo.
    dPrevDate = prevdate(newDate).
          if dprevdate <> ? then do:
	      CopyToNewDate(newDate,dprevDate).
          end.	
          else
          do:
	      MESSAGE "�� ������� ���祭�� �����ᨩ ��� ����஢����" VIEW-AS ALERT-BOX.
          end.

END METHOD.

METHOD PUBLIC LOGICAL CanDelete().
def var CanDel as logical INIT TRUE NO-UNDO. 
             FOR EACH bcode-struct where bcode-struct.class = "PirStrTarif" NO-LOCK,
                  each comm-rate where comm-rate.commission = bcode-struct.val + "_" + TpNum
				    NO-LOCK.
		CanDel = false.
             END.
	RETURN CanDel.
END METHOD.

METHOD PUBLIC VOID CopyFromOtherTarif(INPUT fromTarif AS CHAR, INPUT fromDate AS DATE).

             FOR EACH bcode-struct where bcode-struct.class = "PirStrTarif" NO-LOCK,
                  each comm-rate where comm-rate.commission = bcode-struct.val + "_" + fromTarif
				    and comm-rate.since = fromDate NO-LOCK.
 
                    find first bcomm-rate where bcomm-rate.commission = bcode-struct.val + "_" + TpNum
 	  	 	         and bcomm-rate.since = fromDate 
				 and bcomm-rate.min-value = comm-rate.min-value NO-ERROR.
		    IF AVAILABLE (bcomm-rate) then delete bcomm-rate.
		    CREATE bcomm-rate.
                    ASSIGN 
                         bcomm-rate.commission = bcode-struct.val + "_" + TpNum
	                 bcomm-rate.currency   = comm-rate.currency
   	                 bcomm-rate.min-value  = comm-rate.min-value
 	                 bcomm-rate.since      = fromdate
 	                 bcomm-rate.rate-fixed = comm-rate.rate-fixed
	                 bcomm-rate.acct       = comm-rate.acct
 	                 bcomm-rate.rate-comm  = comm-rate.rate-comm.
	    END.
                      CreateNewDate(fromDate).


	    MESSAGE "����஢���� �����襭�!" VIEW-AS ALERT-BOX.

END METHOD.



METHOD PUBLIC VOID CreateNewDate(INPUT NewDate as DATE).

def var tempID as INT NO-UNDO.

           find last bcode-date where bcode-date.class = "PirTarifDate"  NO-ERROR.
              if available bcode-date then tempID = INT(bcode-date.code) + 1.
              else tempID = 1.
              CREATE bcode-date.
              ASSIGN 
   	            bcode-date.code = STRING(tempID)     
                    bcode-date.class = "PirTarifDate"
                    bcode-date.parent = "PirTarifDate"
 	            bcode-date.name = tpNum
 	            bcode-date.val = STRING(NewDate,"99/99/9999")
	            bcode-date.misc[1] = STRING(dec(NewDate)).


END METHOD.

METHOD PUBLIC VOID CopyToNewDate(INPUT newDate AS DATE,INPUT PrevDate AS DATE). /*����஢��� ���祭�� �����ᨩ �� �� �� ���� PrevDate � NewDate*/
   def var confirm_copy as logical init no no-undo.
   def var confirm_overwrite as logical init no no-undo.
   def var deleted as logical init yes no-undo.

		MESSAGE "����஢��� �� ���祭�� �����ᨩ ��� ��䭮�� �����" SKIP
                        "�� " STRING(prevdate,"99/99/9999") " � " STRING(newDate,"99/99/9999")
        	VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE confirm_copy.	
        if confirm_copy then do:	
          FOR EACH bcode-struct where bcode-struct.class = "PirStrTarif" NO-LOCK,
                  each comm-rate where comm-rate.commission = bcode-struct.val + "_" + TpNum
				    and comm-rate.since = PrevDate NO-LOCK.

  	         find first bcomm-rate where bcomm-rate.commission = bcode-struct.val + "_" + TpNum
	  	  	 	         and bcomm-rate.since = NewDate 
					 and bcomm-rate.min-value = comm-rate.min-value NO-ERROR.
	  	 deleted = yes.

	  	 IF AVAILABLE (bcomm-rate) then 
                 do:
                   confirm_overwrite = no.
                   deleted = no.
		   MESSAGE "��� �㭪� " bcode-struct.name SKIP
                        "㦥 ������ ������� � " STRING(newDate,"99/99/9999") SKIP
			"��९����?"
              	         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE confirm_overwrite.	
               	   if confirm_overwrite then 
		     DO: 
			DELETE bcomm-rate.
			deleted =  yes.
		     END.
		 end.

		if deleted then
		do:

		   CREATE bcomm-rate.
                   ASSIGN 
                         bcomm-rate.commission = comm-rate.commission
	                 bcomm-rate.currency   = comm-rate.currency
   	                 bcomm-rate.min-value  = comm-rate.min-value
 	                 bcomm-rate.since      = newDate
 	                 bcomm-rate.rate-fixed = comm-rate.rate-fixed
	                 bcomm-rate.acct       = comm-rate.acct
 	                 bcomm-rate.rate-comm  = comm-rate.rate-comm.

		end.


	
	  END.
        end.

END METHOD.

METHOD PUBLIC VOID ExportTarif(INPUT dDate AS DATE):

    EMPTY TEMP-TABLE TempComm-Rate.

    for each comm-rate where comm-rate.commission MATCHES "*_" + TpNum and comm-rate.since = dDate NO-LOCK.

        CREATE TempComm-Rate.

        assign
	      TempComm-Rate.commission = Comm-Rate.commission
              TempComm-Rate.currency = Comm-Rate.currency
	      TempComm-Rate.min-value = Comm-Rate.min-value
  	      TempComm-Rate.since = Comm-Rate.since
	      TempComm-Rate.acct = Comm-Rate.acct
	      TempComm-Rate.rate-comm = Comm-Rate.rate-comm.
    end.


    TEMP-TABLE TempComm-Rate:WRITE-XML("file","./" + TpNum + "_" + REPLACE(STRING(dDate),"/","_") + ".xml",YES,?,?,NO,NO).

END METHOD.

METHOD PUBLIC VOID ImportTarif(INPUT dDate AS DATE):
def var count as int init 0 no-undo.
    EMPTY TEMP-TABLE TempComm-Rate.

    TEMP-TABLE TempComm-Rate:READ-XML("file","./" + TpNum + "_" + REPLACE(STRING(dDate),"/","_") + ".xml","empty",?,?,?,?).
     
    FOR EACH tempComm-Rate No-LOCK:
       find first comm-rate where comm-rate.commission = tempComm-Rate.commission 
			      and comm-rate.since = tempComm-Rate.since
	   	   	      and comm-rate.min-value = tempComm-Rate.min-value NO-ERROR.
       if available comm-rate then delete comm-rate.
       count = count + 1.
       CREATE comm-rate.
       ASSIGN
              Comm-Rate.commission = TempComm-Rate.commission
              Comm-Rate.currency = TempComm-Rate.currency
	      Comm-Rate.min-value = TempComm-Rate.min-value
  	      Comm-Rate.since = TempComm-Rate.since
	      Comm-Rate.acct = TempComm-Rate.acct
	      Comm-Rate.rate-comm = TempComm-Rate.rate-comm.
    END.
    message "������஢���� " count " ����ᥩ!" VIEW-AS ALERT-BOX.

END METHOD.



END CLASS.