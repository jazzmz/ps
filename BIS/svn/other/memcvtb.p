{pirsavelog.p}


                   /*******************************************
                    *                                         *
                    *  ������� ������������ � �������������!  *
                    *                                         *
                    *  ������������� ������ ���� ����������,  *
                    *  �.�. �� ��������� ����������� �������  *
                    *             �������������!              *
                    *                                         *
                    *******************************************/

/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2006 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: memcvtb.p
      Comment: ����, ᮧ����� ������஬ ���⮢
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 23/03/06 11:20:31
     Modified:
*/
Form "~n@(#) memcvtb.p 1.0 RGen 23/03/06 RGen 23/03/06 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- �室�� ��ࠬ���� --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- ������� ��६����� --------------------*/

/*--------------- ���� ��� ����� ��: ---------------*/
Define Buffer buf_0_op               For op. /* ���� ��� op, ஫� '������� ⠡���' */

/*--------------- ��६���� ��� ᯥ樠���� �����: ---------------*/
Define Variable acct-cr          As Character            No-Undo.
Define Variable acct-cur         As Character            No-Undo.
Define Variable acct-db          As Character            No-Undo.
Define Variable banner           As Character            No-Undo.
Define Variable CrName           As Character Extent   2 No-Undo.
Define Variable Det              As Character Extent   6 No-Undo.
Define Variable endtext          As Character            No-Undo.
Define Variable PlBank           As Character Extent   2 No-Undo.
Define Variable PlName           As Character Extent   2 No-Undo.
Define Variable PoBank           As Character Extent   2 No-Undo.
Define Variable PoName           As Character Extent   2 No-Undo.
Define Variable Summa1           As Character            No-Undo.
Define Variable Summa2           As Character            No-Undo.
Define Variable Summa3           As Character            No-Undo.
Define Variable Summa4           As Character            No-Undo.
Define Variable Summa5           As Character            No-Undo.
Define Variable SummaStr         As Character Extent   3 No-Undo.
Define Variable theDate          As Character            No-Undo.
Define Variable val1             As Character            No-Undo.
Define Variable val2             As Character            No-Undo.
Define Variable val3             As Character            No-Undo.
Define Variable val4             As Character            No-Undo.
Define Variable Val5             As Character            No-Undo.

/*--------------- ��।������ �� ��� 横��� ---------------*/

/* ��砫�� ����⢨� */
{wordwrap.def}

&SCOP OFFSigns
&SCOPED-DEFINE OFFinn

/*-----------------------------------------
   �஢�ઠ ������ ����� ������� ⠡����,
   �� ������ 㪠�뢠�� Input Param RID
-------------------------------------------*/
Find op Where RecID(op) = RID no-lock no-error.
If Not Avail(op) then do:
  message "��� ����� <op>".
  Return.
end.

/*------------------------------------------------
   ���⠢��� buffers �� �����, ��������
   � ᮮ⢥��⢨� � ������묨 � ���� �ࠢ�����
------------------------------------------------*/
/* �ࠢ��� ��� ������� ⠡���� op */
def buffer wop-entry for op-entry.
def buffer xop-entry for op-entry.

def var amt1 like op-entry.amt-rub NO-UNDO.
def var amt2 like op-entry.amt-rub NO-UNDO.
def var amt3 like op-entry.amt-rub NO-UNDO.
def var amt4 like op-entry.amt-rub NO-UNDO.
def var amt5 like op-entry.amt-rub NO-UNDO.

find first op-entry of op no-lock no-error.
   if avail op-entry and
            op-entry.acct-db ne ? and
            op-entry.acct-cr ne ? then do:
                        
      ASSIGN
        acct-db = op-entry.acct-db
        acct-cr = op-entry.acct-cr
      .
                  
      if can-find(first acct where acct.acct = op-entry.acct-db and
                                   acct.currency = "") then do:               

         find first currency where 
                    currency.currency = op-entry.currency no-lock no-error.                        
         ASSIGN   
           amt1 = op-entry.amt-rub
           amt3 = op-entry.amt-cur
           amt4 = op-entry.amt-rub
           val1 = "RUR"
           val3 = currency.i-currency
           val4 = "RUR"
         .
      end.
      else do:
         find first currency where
                    currency.currency = op-entry.currency no-lock no-error.
      
         ASSIGN
           amt1 = op-entry.amt-cur
           amt2 = op-entry.amt-rub
           amt4 = op-entry.amt-rub
           val1 = currency.i-currency
           val2 = "RUR"
           val4 = "RUR"
        .   
      end.   

      find first wop-entry of op
                 where wop-entry.acct-db begins "61406" or
                       wop-entry.acct-db begins "70205" or
                       wop-entry.acct-db begins "93801" or
                       wop-entry.acct-cr begins "61306" or
                       wop-entry.acct-cr begins "96801" or
                       wop-entry.acct-cr begins "70103" no-lock no-error.  
         if avail wop-entry then do:
            if wop-entry.acct-db begins "61406" or
               wop-entry.acct-cr begins "70205" or
               wop-entry.acct-db begins "93801"
               then do:
               acct-cur = wop-entry.acct-db.
               if val1 ne "RUR" then do:
                  amt2 = amt2 - wop-entry.amt-rub.
               end.   
               else do:
                  amt4 = amt4 + wop-entry.amt-rub.
               end.         
            end.
            else do:
               acct-cur = wop-entry.acct-cr.
               if val1 ne "RUR" then do:
                  amt2 = amt2 + wop-entry.amt-rub.
               end.
               else do:
                  amt4 = amt4 - wop-entry.amt-rub.
               end.
            end.            
            amt5 = wop-entry.amt-rub.
            val5 = "RUR".         
         end.           
   end.
   else do:
      find first op-entry of op where 
                 op-entry.acct-cr eq ? and
                 (substr(op-entry.acct-db,1,5) ne "61406" or
                  substr(op-entry.acct-db,1,5) ne "70205" or
                  substr(op-entry.acct-db,1,5) ne "93801") no-lock no-error.
      if avail op-entry then do:     
               
         if can-find(first acct where acct.acct = op-entry.acct-db and
                                   acct.currency = "") then do:               
            ASSIGN
              acct-db = op-entry.acct-db
              amt1 = op-entry.amt-rub
              val1 = "RUR"
            .
         end.
         else do:
            find first currency where 
                       currency.currency = op-entry.currency no-lock no-error.                        
            ASSIGN
              acct-db = op-entry.acct-db
              amt1 = op-entry.amt-cur
              amt2 = op-entry.amt-rub
              val1 = currency.i-currency
              val2 = "RUR"
            .
        end.
        find first wop-entry of op where 
                   wop-entry.acct-db eq ? and 
                   (substr(wop-entry.acct-cr,1,5) ne "61306" or
                    substr(wop-entry.acct-cr,1,5) ne "70103" or
                    substr(wop-entry.acct-cr,1,5) ne "96801") 
                    no-lock no-error.
        if avail wop-entry then do:
           if can-find(first acct where acct.acct = wop-entry.acct-cr and
                                acct.currency = "") then do:               
              ASSIGN
                acct-cr = wop-entry.acct-cr
                amt3 = wop-entry.amt-rub
                val3 = "RUR"
           .
           end.      
           else do:
              find first currency where 
                   currency.currency = wop-entry.currency no-lock no-error.                        
              ASSIGN
                acct-cr = wop-entry.acct-cr
                amt3 = wop-entry.amt-cur
                amt4 = wop-entry.amt-rub
                val3 = currency.i-currency
                val4 = "RUR"
              .
          end.            
        end.
        find first xop-entry of op
             where xop-entry.acct-db begins "61406" or
                   xop-entry.acct-db begins "70205" or
                   xop-entry.acct-db begins "93801" or
                   xop-entry.acct-cr begins "61306" or
                   xop-entry.acct-cr begins "96801" or
                   xop-entry.acct-cr begins "70103" no-lock no-error.  
           if avail xop-entry then do:
              if xop-entry.acct-db begins "61406" or
                 xop-entry.acct-cr begins "70205" or
                 xop-entry.acct-db begins "93801"
                 then do:
                 acct-cur = xop-entry.acct-db.
              end.
              else do:
                 acct-cur = xop-entry.acct-cr.
              end.
                 amt5 = xop-entry.amt-rub.
                 val5 = "RUR".
          end.
        end.                    
   end.

/* ���⠢�� buf_0_op �� op ஫� '������� ⠡���' */
Find buf_0_op Where RecID(buf_0_op) = RecID(op) no-lock.

/*------------------------------------------------
   ���᫨�� ���祭�� ᯥ樠���� �����
   � ᮮ⢥��⢨� � ������묨 � ���� �ࠢ�����
------------------------------------------------*/
/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� acct-cr */
/* ��. ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� acct-cur */
/* ��. ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� acct-db */
/* ��. ��砫�� ����⢨� */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� banner */
{get_set.i "����"}

banner = setting.val.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� CrName */
{getcust2.i acct-cur CrName}.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Det */
Det[1] = op.details.
{wordwrap.i &s=Det &n=6 &l=55}

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� endtext */
{get_set2.i "�ਭ��" "PCL" "w/o chek"}

if ((not avail(setting) or (avail(setting) and trim(setting.val) = "")) and
   usr-printer begins "+") or
   (avail(setting) and can-do(setting.val, usr-printer)) then do:
  
   endtext = chr(12).
end.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PlBank */
PlBank[1] = dept.name-bank.
{wordwrap.i &s=PlBank &l=42 &n=2}

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PlName */
{getcust2.i acct-db PlName}.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PoBank */
find first setting where setting.code = "����" no-lock.
PoBank[1] = setting.val.
{wordwrap.i &s=PoBank &n=2 &l=42}

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� PoName */
{getcust2.i acct-cr PoName}.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Summa1 */
IF amt1 ne 0 then do:
   IF TRUNC(amt1, 0) = amt1 THEN
      ASSIGN
        Summa1 = STRING(STRING(amt1 * 100, "-zzzzzzzzzz999"), "x(12)=")
     .
   ELSE
      ASSIGN       
        Summa1 = STRING(STRING(amt1 * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      .
END.
ELSE DO:
   ASSIGN
     Summa1 = ""    
   .
END.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Summa2 */
IF amt2 ne 0 then do:
   IF TRUNC(amt2, 0) = amt2 THEN
      ASSIGN
        Summa2 = STRING(STRING(amt2 * 100, "-zzzzzzzzzz999"), "x(12)=")
     .
   ELSE
      ASSIGN       
        Summa2 = STRING(STRING(amt2 * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      .
END.
ELSE DO:
   ASSIGN
     Summa2 = ""    
   .
END.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Summa3 */
IF amt3 ne 0 then do:
   IF TRUNC(amt3, 0) = amt3 THEN
      ASSIGN
        Summa3 = STRING(STRING(amt3 * 100, "-zzzzzzzzzz999"), "x(12)=")
     .
   ELSE
      ASSIGN       
        Summa3 = STRING(STRING(amt3 * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      .
END.
ELSE DO:
   ASSIGN
     Summa3 = ""    
   .
END.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Summa4 */
IF amt4 ne 0 then do:
   IF TRUNC(amt4, 0) = amt4 THEN
      ASSIGN
        Summa4 = STRING(STRING(amt4 * 100, "-zzzzzzzzzz999"), "x(12)=")
     .
   ELSE
      ASSIGN       
        Summa4 = STRING(STRING(amt4 * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      .
END.
ELSE DO:
   ASSIGN
     Summa4 = ""    
   .
END.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Summa5 */
IF amt5 ne 0 then do:
   IF TRUNC(amt5, 0) = amt5 THEN
      ASSIGN
        Summa5 = STRING(STRING(amt5 * 100, "-zzzzzzzzzz999"), "x(12)=")
     .
   ELSE
      ASSIGN       
        Summa5 = STRING(STRING(amt5 * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      .
END.
ELSE DO:
   ASSIGN
     Summa5 = ""    
   .
END.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� SummaStr */
IF Val1 = "RUR" THEN DO:
  RUN x-amtstr.p(amt1,"", TRUE, TRUE, OUTPUT SummaStr[1], OUTPUT SummaStr[2]).
  IF TRUNC(amt1, 0) = amt1 THEN
    ASSIGN
      SummaStr[2] = ''
    .
  ELSE
    ASSIGN
      SummaStr[1] = SummaStr[1] + ' ' + SummaStr[2]
    .
  {wordwrap.i &s=SummaStr &n=3 &l=58}
  SUBSTR(SummaStr[1], 1, 1) = CAPS(SUBSTR(SummaStr[1], 1, 1)).
END.
ELSE DO:  
  RUN x-amtstr.p(amt2,"", TRUE, TRUE, OUTPUT SummaStr[1], OUTPUT SummaStr[2]).
  IF TRUNC(amt2, 0) = amt2 THEN
    ASSIGN
      SummaStr[2] = ''
    .
  ELSE
    ASSIGN
      SummaStr[1] = SummaStr[1] + ' ' + SummaStr[2]
    .
  {wordwrap.i &s=SummaStr &n=3 &l=58}
  SUBSTR(SummaStr[1], 1, 1) = CAPS(SUBSTR(SummaStr[1], 1, 1)).
END.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� theDate */
if op.doc-date <> ? then
  theDate = {strdate.i op.doc-date}.
else
  theDate = {strdate.i op.op-date}.

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� val1 */
/* */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� val2 */
/* */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� val3 */
/* */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� val4 */
/* */

/* ���᫥��� ���祭�� ᯥ樠�쭮�� ���� Val5 */
/* */

/*-------------------- ��ନ஢���� ���� --------------------*/
{strtout3.i &cols=84 &option=Paged}

put unformatted "" banner Format "x(60)"
                "" skip.
put skip(1).
put unformatted "                                       ��������ͻ" skip.
put unformatted "                  ������������ ����� N � " buf_0_op.doc-num Format "x(6)"
                " �" skip.
put unformatted "                                       ��������ͼ" skip.
put unformatted "                        " theDate Format "x(20)"
                "" skip.
put unformatted "���⥫�騪                                        �����              �㬬�" skip.
put unformatted "" PlName[1] Format "x(42)"
                " ���������������������������������������ͻ" skip.
put unformatted "" PlName[2] Format "x(42)"
                " �" acct-db Format "x(20)"
                "�" val1 Format "x(3)"
                "" Summa1 Format "x(15)"
                "�" skip.
put unformatted " ���� ���⥫�騪�                          �                    �                  �" skip.
put unformatted "" PlBank[1] Format "x(42)"
                " �                    �" val2 Format "x(3)"
                "" Summa2 Format "x(15)"
                "�" skip.
put unformatted "" PlBank[2] Format "x(42)"
                " �                    �                  �" skip.
put unformatted "����������������������������������������������.N���������������͹                  �" skip.
put unformatted "�����⥫�                                      ������          �                  �" skip.
put unformatted "" PoName[1] Format "x(42)"
                " ���������������������������������������͹" skip.
put unformatted "" PoName[2] Format "x(42)"
                " �" acct-cr Format "x(20)"
                "�" val3 Format "x(3)"
                "" Summa3 Format "x(15)"
                "�" skip.
put unformatted "���� �����⥫�                            �                    �                  �" skip.
put unformatted "" PoBank[1] Format "x(42)"
                " �                    �" val4 Format "x(3)"
                "" Summa4 Format "x(15)"
                "�" skip.
put unformatted "" PoBank[2] Format "x(42)"
                " �                    �                  �" skip.
put unformatted "����������������������������������������������.N����������������������������������͹" skip.
put unformatted "                                                                �                  �" skip.
put unformatted "                                           ��������������������͹                  �" skip.
put unformatted "" CrName[1] Format "x(42)"
                " �" acct-cur Format "x(20)"
                "�" Val5 Format "x(3)"
                "" Summa5 Format "x(15)"
                "�" skip.
put unformatted "" CrName[2] Format "x(42)"
                " �                    �                  �" skip.
put unformatted "� �㬬� �ய���� �����������������������������.N����������������������������������͹" skip.
put unformatted "" SummaStr[1] Format "x(58)"
                "      ����  �            �" skip.
put unformatted "" SummaStr[2] Format "x(58)"
                "      �����.�            �" skip.
put unformatted "" SummaStr[3] Format "x(58)"
                "      ������������������͹" skip.
put unformatted "                                                                ����� �            �" skip.
put unformatted "                                                                �����.�            �" skip.
put unformatted "�͍����祭�� ���⥦� �������������������������������������������������������������͹" skip.
put unformatted "" Det[1] Format "x(55)"
                "         ��ப �            �" skip.
put unformatted "" Det[2] Format "x(55)"
                "         �����.�            �" skip.
put unformatted "" Det[3] Format "x(55)"
                "         ������������������͹" skip.
put unformatted "" Det[4] Format "x(55)"
                "         ����.�            �" skip.
put unformatted "" Det[5] Format "x(55)"
                "         �����.�            �" skip.
put unformatted "" Det[6] Format "x(55)"
                "         ������������������͹" skip.
put unformatted "                                                                �N ��.�            �" skip.
put unformatted "                                                                �������            �" skip.
put unformatted "                                                                ������������������ͼ" skip.
put unformatted "��壠���                       ����஫��" skip.
put skip(3).
put unformatted "" endtext Format "x(5)"
                "" skip.

{endout3.i &nofooter=yes}

