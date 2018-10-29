{pirsavelog.p}

/*
                ­ª®¢áª ï ¨­â¥£à¨à®¢ ­­ ï á¨áâ¥¬  ˆ‘ª¢¨â
    Copyright: (C) 1992-2001 ’ " ­ª®¢áª¨¥ ¨­ä®à¬ æ¨®­­ë¥ á¨áâ¥¬ë"
     Filename: p21r05.p
      Comment: “‹…‚›… Š€‘‘‚›… „Š“Œ…’›  ¤«ï ª« áá  i56_1
   Parameters:
         Uses:
      Used by:
      Created: 18.10.2001 Olenka
     Modified: 01/04/2002 Olenka - ¨á¯®«ì§®¢ ­ GetXattrValue ¢¬¥áâ® GetSigns
     Modified:

*/
Form "~n@(#) p21r05.p Olenka 18/10/2001 “‹…‚›… Š€‘‘‚›… „Š“Œ…’›  ¤«ï ª« áá  i56_1"
with frame sccs-id stream-io width 250.

def input param in-data-id like DataBlock.Data-Id no-undo.
def input param vNumPril as char no-undo.

{globals.i}
{norm.i}
{tmprecid.def}        /** ˆá¯®«ì§ã¥¬ ¨­ä®à¬ æ¨î ¨§ ¡à®ã§¥à  */

find DataBlock where DataBlock.Data-Id eq in-Data-Id no-lock no-error.
find first DataClass where DataClass.DataClass-id = entry(1,DataBlock.DataClass-id,'@') no-lock.

def var xresult as dec no-undo.
def var i as int no-undo.
def var cnt75 as dec extent 4 format ">>>>>>9" no-undo.
def var cnt05 as dec extent 4 format ">>>>>>9" no-undo.
def var sum75 as dec extent 4 format "->>>>,>>>,>>>,>>9.99" no-undo.
def var sum05 as dec extent 4 format "->>>>,>>>,>>>,>>9.99" no-undo.
def var indeks as char no-undo.

if datablock.branch-id = "00002" then
DO:
run br-user.p (4).
FOR EACH tmprecid:
FIND FIRST _user WHERE RECID(_user) = tmprecid.id NO-LOCK NO-ERROR.
for each DataLine of DataBlock where
         DataLine.Sym3 = ""  and
	 ENTRY(1, DataLine.Sym1, "_") = _user._userid no-lock:

    if DataLine.Sym2 = "b" and DataLine.Sym4 = "db" then i = 1.
    if DataLine.Sym2 = "b" and DataLine.Sym4 = "cr" then i = 2.
    if DataLine.Sym2 = "o" and DataLine.Sym4 = "db" then i = 3.
    if DataLine.Sym2 = "o" and DataLine.Sym4 = "cr" then i = 4.

    assign 
       sum05[i] = sum05[i] + DataLine.Val[2]
       cnt05[i] = cnt05[i] + DataLine.Val[6]
       sum75[i] = sum75[i] + DataLine.Val[4]
       cnt75[i] = cnt75[i] + DataLine.Val[8]
    .
end.
END.
END.
 ELSE
DO:
for each DataLine of DataBlock where
         DataLine.Sym3 = ""  no-lock:

    if DataLine.Sym2 = "b" and DataLine.Sym4 = "db" then i = 1.
    if DataLine.Sym2 = "b" and DataLine.Sym4 = "cr" then i = 2.
    if DataLine.Sym2 = "o" and DataLine.Sym4 = "db" then i = 3.
    if DataLine.Sym2 = "o" and DataLine.Sym4 = "cr" then i = 4.

    assign 
       sum05[i] = sum05[i] + DataLine.Val[2]
       cnt05[i] = cnt05[i] + DataLine.Val[6]
       sum75[i] = sum75[i] + DataLine.Val[4]
       cnt75[i] = cnt75[i] + DataLine.Val[8]
    .
end.
END.

&GLOB width 86
{setdest.i &cols = {&width}}

if datablock.branch-id = "00002" then 
 do:
 put skip
"                                                                 ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip
"                                                                 ³   ‘‹“†ˆ‚€ˆ…    ³" skip
"                                                                 ³‚ ‘‹……€–ˆ…³" skip
"                                                                 ³       ‚…ŒŸ       ³" skip
"                                                                 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.
 end.
run stdhdr_p.p (output xResult, DataBlock.beg-date,DataBlock.end-date,
               "{&width}," + vNumPril + ",¢ àã¡.,|ã¡«¥¢ë¥_ª áá®¢ë¥_¤®ªã¬¥­âë|áà®ª_åà ­¥­¨ï_5_«¥â||‡€_&1|ˆ­¤¥ªá ü " + indeks + " ,no").

put skip
"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip
"³Š áá®¢ë¥ ¤®ªã¬¥­âë³   Š®«¨ç¥áâ¢® (èâãª)   ³            ‘ã¬¬  (àã¡.)                 ³" skip
"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
"³                  ³   ‚á¥£®   ³‚ ®â¤¥«ì­ëå³       ‚á¥£®        ³    ‚ ®â¤¥«ì­ëå     ³" skip
"³                  ³           ³   ¯ ¯ª å  ³                    ³       ¯ ¯ª å       ³" skip
"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
"³1. à¨å®¤­ë¥      ³           ³           ³                    ³                    ³" skip
"³   ¤®ªã¬¥­âë      ³" cnt05[1] at 23 "³" at 32 "³" at 44 sum05[1] at 45 "³" at 65 "³" at 86 skip
"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
"³2.  áå®¤­ë¥      ³           ³           ³                    ³                    ³" skip
"³   ¤®ªã¬¥­âë      ³" cnt05[2] at 23 "³" at 32 "³" at 44 sum05[2] at 45 "³" at 65 "³" at 86 skip
"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
"³3. Œ¥¬®à¨ «ì­ë¥   ³           ³           ³                    ³                    ³" skip
"³¤®ª-âë ¯® ¯à¨å®¤ã ³" cnt05[3] at 23 "³" at 32 "³" at 44 sum05[3] at 45 "³" at 65 "³" at 86 skip
"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
"³4. Œ¥¬®à¨ «ì­ë¥   ³           ³           ³                    ³                    ³" skip
"³¤®ª-âë ¯® à áå®¤ã ³" cnt05[4] at 23 "³" at 32 "³" at 44 sum05[4] at 45 "³" at 65 "³" at 86 skip
"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip
.


{sign_kas.i}
/* {signatur.i &user-only = yes } */
{preview.i }


