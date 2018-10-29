/* ------------------------------------------------------
File		: $RCSfile: op-enbum.i,v $ $Revision: 1.2 $ $Date: 2007/06/14 14:01:12 $
Copyright	: ООО КБ "Пpоминвестрасчет"
Базируется	: op-enbum.i
Назначение	: Изменен отбор проводок в группу 1
Причина		: ???
Место запуска	: включается в процедуры формирования бухгалтерских журналов
		: op-enbum.p, pirop-enbumr.p, pirop-enbumv.p
Автор		: ???
Изменения	: $Log: op-enbum.i,v $
Изменения	: Revision 1.2  2007/06/14 14:01:12  lavrinenko
Изменения	: Изменен отбор документов по к/с
Изменения	:
------------------------------------------------------ */
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2002 ТОО "Банковские информационные системы"
     Filename: OP-ENBUM.I
      Comment: Бух. журнал по отделениям для ВТБ
   Parameters:
         Uses:
      Used by: op-enbum.p
      Created: 17/09/02 GORM      
     Modified: 06/07/2004 kraw (0028452) Изменение алгоритма определения кассовых проводок (взято из lsa.p)
     Modified: 16/03/2005 kraw (0044111) Проверка расположения отдела автоматизации в иерархии
*/

{op-cash.def}

n_asu = FGetSetting ("БухЖурн", 
                     "N_АСУ",
                     "").

IF n_asu = "" THEN DO:
   MESSAGE "Не задан параметр" SKIP "N_АСУ !" 
      VIEW-AS ALERT-BOX.
   RETURN.
END.

FIND FIRST branch WHERE branch.branch-id EQ n_asu NO-LOCK NO-ERROR.

IF NOT AVAILABLE branch THEN
DO:
   MESSAGE "Не найдено подразделение с кодом" n_asu "(отдел автоматизации)" SKIP
      "в справочнике <<Оргструктура банка>>"
      VIEW-AS ALERT-BOX. 
   RETURN.
END.

sp_tr = FGetSetting ("БухЖурн", 
                     "SP_TR",
                     "").

IF sp_tr = "" THEN DO:
   MESSAGE "Не задан параметр" SKIP "SP_TR !" 
      VIEW-AS ALERT-BOX.
   RETURN.
END.

sp_trod = FGetSetting ("БухЖурн", 
                       "SP_TROD",
                       "").

IF sp_trod = "" THEN DO:
   MESSAGE "Не задан параметр" SKIP "SP_TROD !" 
      VIEW-AS ALERT-BOX.
   RETURN.
END.

FUNCTION get_str_branch RETURN CHAR 
   (INPUT ip-str AS CHAR,
    INPUT ip-out-branch AS CHAR,
    INPUT ip-list-branch AS CHAR):

   DEF VAR k1 AS INT NO-UNDO.

   IF ip-out-branch > "" AND 
      CAN-DO(ip-str,ip-out-branch)       
      THEN RETURN ip-out-branch.

   ELSE 
      DO k1 = 1 TO NUM-ENTRIES(ip-str):
         IF CAN-DO(ip-list-branch, ENTRY(k1, ip-str)) THEN 
            RETURN ENTRY(k1, ip-str).          
      END.

   RETURN "".
END FUNCTION.

FOR EACH op WHERE op.op-date = end-date
              AND op.op-status >= gop-status NO-LOCK,
    EACH op-entry OF op WHERE op-entry.prev-year EQ fl NO-LOCK
    BREAK BY op.op 
          BY op-entry.op-entry 
          BY op.user-id
    WITH FRAME fopp:            

   ASSIGN
     adb = ?
     acr = ?
     acrcur = ?
     adbcur = ?
     cur_user-id = ''
     cur_refer = ''
     cur_user_name = ''
     tt-st = ?
   .

   IF op-entry.acct-cr EQ ? THEN DO:
     FIND FIRST xop-entry WHERE xop-entry.op = op.op 
        AND xop-entry.acct-db EQ ? 
        USE-INDEX op-entry NO-LOCK NO-ERROR.
     ASSIGN
       adb = op-entry.acct-db
       acr = xop-entry.acct-cr
       adbcur = op-entry.currency
       acrcur = xop-entry.currency
     .
   END.
   ELSE IF op-entry.acct-db EQ ? THEN DO:
     FIND FIRST xop-entry WHERE xop-entry.op = op.op 
        AND xop-entry.acct-cr EQ ? 
        USE-INDEX op-entry NO-LOCK  NO-ERROR.
     ASSIGN       
       adb = xop-entry.acct-db
       acr = op-entry.acct-cr
       adbcur = xop-entry.currency
       acrcur = op-entry.currency
     .
   END.
   ELSE DO:
     ASSIGN
       adb = op-entry.acct-db
       acr = op-entry.acct-cr
       adbcur = op-entry.currency 
       acrcur = op-entry.currency
       .
   END.
      /* является ли кассовым документом */
   {op-cash.i}

   IF op.acct-cat EQ "b"  AND 
   			(CAN-DO(sp_tr, op.op-kind) OR 
          acr BEGINS "30102" OR 
          adb BEGINS "30102" ) THEN DO:

      pr_num = 1.

      FIND FIRST acct WHERE acct.acct = acr 
            AND acrcur BEGINS acct.currency 
            NO-LOCK NO-ERROR. 
	    
      IF AVAILABLE acct THEN cur_user-id = acct.user-id.
	    
      IF adb BEGINS "47416" THEN DO:	    
         cur_user-id = op.user-id.
      END.	   
      
      
      IF acr BEGINS "30102" THEN DO:	    
         FIND FIRST acct WHERE acct.bal-acct EQ 30102 
                           AND acct.close-date EQ ? NO-LOCK NO-ERROR.
         IF AVAILABLE acct THEN cur_user-id = acct.user-id.
      END. 	   
	 
      IF adb BEGINS "30102" THEN DO:	    
         cur_user-id = "MCI".
      END. 	   
            
      IF CAN-DO(list-pochta, op-entry.type) THEN is_pochta = YES.
      ELSE IF CAN-DO(list-teleg, op-entry.type) THEN is_pochta = NO.
      ELSE is_pochta = ?.    
      
   END.
   ELSE IF CAN-DO(sp_trod, op.op-kind) THEN DO:
      ASSIGN
         cur_user-id = op.user-id
         cur_refer = n_asu
         pr_num = 3.
   END.
   ELSE DO:
      ASSIGN
         cur_user-id = op.user-id
         pr_num = 2.            
   END.

   /* если выбор был по сотрудникам */
   IF list-id > '' THEN DO: 
      IF CAN-DO(list-id, cur_user-id) THEN .
      ELSE NEXT.
   END. 
     
   IF adb NE ? AND acr NE ? THEN DO:
      /*
      IF pr_num = 3 THEN DO:
         str2 = ''.
         {op-enbum.cr &bra=str2} 
      END.
      ELSE
   */ DO:  
         FIND _user WHERE _user._userid = cur_user-id 
            NO-LOCK NO-ERROR.

         IF AVAILABLE _user THEN DO:
            cur_user_name = _user._user-name.
            tt-st = GetXattrValueEx("_user", _user._userid, "ОтделОтч",?).
         END.
                        
         IF tt-st = ?  THEN
            tt-st = GetUserBranchId(cur_user-id).            
         
         FIND branch WHERE branch.branch-id = tt-st 
            NO-LOCK NO-ERROR.   
         IF AVAILABLE branch THEN DO:

            ASSIGN
               str2 = ''
               str_p = ''.

            IF branch.branch-type = us_type2 
               THEN str2 = branch.branch-id.            

            ELSE IF only-branch <> YES AND branch.branch-type = us_type1 
               THEN ASSIGN
                  str2 = branch.branch-id
                  str_p = str2.

            ELSE DO:

               RUN GetBranchParent_Type (tt-st, us_type2, INPUT-OUTPUT str2).                   
                  
               IF NUM-ENTRIES(str2) > 1 THEN DO:                                    
                  IF only-branch = YES THEN 
                     str2 = get_str_branch(str2, out-branch-id, list-branch-id).

                  ELSE DO:
                     DO i1 = 1 TO NUM-ENTRIES(str2):
                        RUN GetBranchParent_Type (ENTRY(i1, str2), us_type1, INPUT-OUTPUT str_p).
                        
                        IF NUM-ENTRIES(str_p) > 1 THEN
                           str_p = get_str_branch(str_p, out-branch-id, list-branch-id).

                        IF str_p > "" THEN 
                           str2 = ENTRY(i1, str2).

                        LEAVE.
                     END.
                  END.
               END.

            END.

            IF only-branch <> YES AND 
               str_p = "" AND
               str2 > "" THEN DO:                  
                  RUN GetBranchParent_Type (str2, us_type1, INPUT-OUTPUT str_p).
                  IF NUM-ENTRIES (str_p) > 1 THEN
                     str_p = get_str_branch(str_p, out-branch-id, list-branch-id).
            END.               
            
            IF only-branch = YES THEN DO:
               IF str2 > '' AND 
                  (str2 = out-branch-id OR 
                   CAN-DO(list-branch-id,str2)) THEN DO:             
                  {op-enbum.cr &bra=str2}          
               END.            
            END.
            ELSE IF str_p > "" AND 
                  (str_p = out-branch-id OR 
                   CAN-DO(list-branch-id,str_p)) THEN DO:                            
                  {op-enbum.cr &bra=str2}                                           
            END.
            ELSE IF chk_all THEN DO:
               str_p = dept.branch.
               IF CAN-DO(list-branch-id,str_p) THEN
               DO:
               {op-enbum.cr &bra=dept.branch}          
               END.
            END.    

         END.         
      END.
   END.
END. /* конец сбора информации */

/* удаление одной из полупроводок */
FOR EACH xentry WHERE xentry.polupr <> ""
         BREAK BY xentry.op 
               BY xentry.amt 
               BY xentry.currency 
   DESCENDING:
   IF LAST-OF(xentry.op) THEN
      DELETE xentry.
END.

/* для подчета кол-ва документов */
FOR EACH xentry 
   BREAK BY xentry.op
         BY xentry.user-id:

   ASSIGN
      xentry.num     = IF FIRST-OF(xentry.op) 
                          THEN 1 
                          ELSE 0
      xentry.num-usr = IF FIRST-OF(xentry.user-id) 
                          THEN 1 
                          ELSE 0
      .

END.
