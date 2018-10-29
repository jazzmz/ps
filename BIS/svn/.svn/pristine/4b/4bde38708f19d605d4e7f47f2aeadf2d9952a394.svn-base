{pirsavelog.p}


                   /*******************************************
                    *                                         *
                    *  ƒ‘„€ ƒ€ŒŒˆ‘’› ˆ ‘—“‚‘’‚“™ˆ…!  *
                    *                                         *
                    *  …„€Š’ˆ‚€’œ „€›‰ ”€‰‹ …‘‹…‡,  *
                    *  ’.Š.  ‘‡„€…’‘Ÿ ƒ……€’Œ ’—…’‚  *
                    *             €‚’Œ€’ˆ—…‘Šˆ!              *
                    *                                         *
                    *******************************************/

/*
                ­ª®¢áª ï ¨­â¥£à¨à®¢ ­­ ï á¨áâ¥¬  ˆ‘ª¢¨â
    Copyright: (C) 1992-2005 ’ " ­ª®¢áª¨¥ ¨­ä®à¬ æ¨®­­ë¥ á¨áâ¥¬ë"
     Filename: mor-g24.p
      Comment: âç¥â, á®§¤ ­­ë© £¥­¥à â®à®¬ ®âç¥â®¢
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 24/08/05 14:27:12
     Modified:
*/
Form "~n@(#) mor-g24.p 1.0 RGen 24/08/05 RGen 24/08/05 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- ‚å®¤­ë¥ ¯ à ¬¥âàë --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- ¡êï¢«¥­¨¥ ¯¥à¥¬¥­­ëå --------------------*/

Define Buffer buf_0_op               For op.

/*--------------- ãä¥à  ¤«ï ¯®«¥© „: ---------------*/

/*--------------- ¥à¥¬¥­­ë¥ ¤«ï á¯¥æ¨ «ì­ëå ¯®«¥©: ---------------*/
Define Variable amt-cur-s        As Character            No-Undo.
Define Variable amt-rub-         As Decimal              No-Undo.
Define Variable Amtp             As Character            No-Undo.
Define Variable Amtp1            As Character            No-Undo.
Define Variable bank             As Character            No-Undo.
Define Variable Cen              As Character Extent   4 No-Undo.
Define Variable cr               As Character            No-Undo.
Define Variable datap            As Character            No-Undo.
Define Variable db               As Character            No-Undo.
Define Variable DNum             As Character            No-Undo.
Define Variable endtext          As Character            No-Undo.
Define Variable NameCl           As Character Extent   2 No-Undo.
Define Variable Osn              As Character Extent   2 No-Undo.
Define Variable Q-t              As Character            No-Undo.
Define Variable textc            As Character Extent  10 No-Undo.
Define Variable user-op          As Character            No-Undo.

/*--------------- ¯à¥¤¥«¥­¨¥ ä®à¬ ¤«ï æ¨ª«®¢ ---------------*/

/*  ç «ì­ë¥ ¤¥©áâ¢¨ï */
{wordwrap.def}
{get_set.i " ­ª"}
bank = setting.val.
{get_set.i " ­ªƒ®à®¤"}
bank = bank + " " + setting.val.
def var amt-     as DEC no-undo.
def var amt-cur- as dec no-undo.
def var passport_ as char no-undo.


find first op where recid(op) = RID no-lock.
find first op-entry of op where op-entry.acct-cat = "o" no-lock no-error.
if not available op-entry then do: 
   message "“ ¤®ªã¬¥­â  ®âáãâáâ¢ã¥â ¯à®¢®¤ª ".
   return. 
end.
/*{strval.i op-entry.amt-rub Amtp} 
if length(Amtp) > 66 then do: 
      Amtp1 = substring(Amtp,67,86).
end.*/

if op-entry.currency <> ? and op-entry.currency <> "" 
then do:
   amt-   = op-entry.amt-cur.
   amt-rub- = op-entry.amt-rub.
   amt-cur- = op-entry.amt-cur.
end.
else do:
   amt- = op-entry.amt-rub.
   amt-rub- = op-entry.amt-rub.
   amt-cur- = 0.
end.

find first _user where _user._userid = op.user-id no-error.
if avail _user then user-op = _user._user-name.
Run x-amtstr.p (amt-,op-entry.currency,true,true,output Amtp,output Amtp1).      
/* if trunc(amt-,0) = amt-                             
  then Amtp1 = ''. */
Amtp  = caps(substring(Amtp,1,1)) + substring(Amtp,2) .
Amtp= Amtp + ' ' + Amtp1.                         
if Length(Amtp) > 66 then do:                                         
 Assign  
  Amtp1 = Amtp
  Amtp  = SubStr(Amtp,1,R-Index(SubStr(Amtp,1,66),' ') - 1)
  Amtp1 = SubStr(Amtp1,Length(Amtp) + 1).
 end.                      
 else Amtp1 = ''. 
amt-cur-s = string(amt-cur-, if amt-cur- = 0 then ">>,>>>,>>>" else ">>,>>>,>>>.99").

assign
   Q-t   = string(op-entry.qty,  ">>>>>" )
   datap = {term2str op.op-date op.op-date} 
   db    = op-entry.acct-db
   cr    = op-entry.acct-cr
.        
  FIND last signs WHERE signs.file EQ "op"
                  AND signs.code   EQ " ¨¬–¥­"
                  and signs.surr   EQ  string(op.op)
                  NO-ERROR.


  if avail signs then do:
      Cen[1] =  trim(signs.xattr-value).
      {wordwrap.i &s=Cen &n=4 &l=45}         
  end.    


  FIND last signs WHERE signs.file EQ "op"
                  AND signs.code   EQ "á­„®ª"
                  and signs.surr   EQ  string(op.op)
                  NO-ERROR.

  if avail signs then do:
      Osn[1] =  signs.xattr-value.
      {wordwrap.i &s=Osn &n=2 &l=75}         
  end.    

  FIND last signs WHERE signs.file EQ "op"
                  AND signs.code   EQ "Passport"
                  and signs.surr   EQ  string(op.op)
                  NO-ERROR.

  if avail signs then do:
      passport_ =  signs.xattr-value.       
  end.    
          


if Op.Name-Ben = "" then do:
 
   find first acct where acct.acct = op-entry.acct-cr no-lock no-error.
      {getcust.i &name = NameCl &OFFInn = yes}
      {wordwrap.i &s=NameCl &n=2 &l=52}         
end.
else do: 
     if Op.inn <> "" and op.inn <> ? then NameCl[1] = "ˆ " + Op.inn + " ".
        NameCl[1] =  NameCl[1]  +  Op.Name-Ben + " " + passport_.
       {wordwrap.i &s=NameCl &n=2 &l=52}         
end.


textc[1] = Op.Details.
{wordwrap.i &s=textc &n=4 &l=45}

/*-----------------------------------------
   à®¢¥àª  ­ «¨ç¨ï § ¯¨á¨ £« ¢­®© â ¡«¨æë,
   ­  ª®â®àãî ãª §ë¢ ¥â Input Param RID
-------------------------------------------*/
Find op Where RecID(op) = RID no-lock no-error.
If Not Avail(op) then do:
  message "¥â § ¯¨á¨ <op>".
  Return.
end.

/*------------------------------------------------
   ‚ëáâ ¢¨âì buffers ­  § ¯¨á¨, ­ ©¤¥­­ë¥
   ¢ á®®â¢¥âáâ¢¨¨ á § ¤ ­­ë¬¨ ¢ ®âç¥â¥ ¯à ¢¨« ¬¨
------------------------------------------------*/
/* ’.ª. ­¥ § ¤ ­® ¯à ¢¨«® ¤«ï ¢ë¡®àª¨ § ¯¨á¥© ¨§ £« ¢­®© â ¡«¨æë,
   ¯à®áâ® ¢ëáâ ¢¨¬ ¥£® buffer ­  input RecID                    */
find buf_0_op where RecID(buf_0_op) = RecID(op) no-lock.

/*------------------------------------------------
   ‚ëç¨á«¨âì §­ ç¥­¨ï á¯¥æ¨ «ì­ëå ¯®«¥©
   ¢ á®®â¢¥âáâ¢¨¨ á § ¤ ­­ë¬¨ ¢ ®âç¥â¥ ¯à ¢¨« ¬¨
------------------------------------------------*/
/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï amt-cur-s */
/**/

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï amt-rub- */
/**/

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï Amtp */
/* {strval.i op-entry.amt-rub Amtp } */

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï Amtp1 */
/**/

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï bank */
/*
{get_set.i " ­ª"}
bank = setting.val.
{get_set.i " ­ªƒ®à®¤"}
bank = bank + " " + setting.val.

find first op-entry of op where op-entry.acct-cat = "b" no-lock no-error.
if not available op-entry then do: 
   message "“ ¤®ªã¬¥­â  ®âáãâáâ¢ã¥â ¯à®¢®¤ª ".
   return. 
end.
*/
/* {strval.i op-entry.amt-rub Amtp} */

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï Cen */
/**/

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï cr */
/* cr = op-entry.acct-db. */

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï datap */
/**/

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï db */
/* db = op-entry.acct-cr. */

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï DNum */
DNum = op.doc-num.

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï endtext */
/* */

page.

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï NameCl */
/*
*/

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï Osn */
/**/

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï Q-t */
/**/

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï textc */
/**/

/* ‚ëç¨á«¥­¨¥ §­ ç¥­¨ï á¯¥æ¨ «ì­®£® ¯®«ï user-op */
/**/

/*-------------------- ”®à¬¨à®¢ ­¨¥ ®âç¥â  --------------------*/
{strtout3.i &cols=90 &option=Paged}

put unformatted "                                                                     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip.
put unformatted "                                                                     ³       0402102     ³" skip.
put unformatted "    " Bank Format "x(52)"
                "             ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.
put unformatted "    ÄÄ ­ ¨¬¥­®¢ ­¨¥ ãçà¥¦¤¥­¨ï ¡ ­ª  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ              " datap Format "x(20)"
                "" skip.
put unformatted "                                               ÚÄÄÄÄÄÄ¿                ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    Œ…Œˆ€‹œ›‰ „…  ˆ…Œ“ –…‘’…‰   N ³" DNum Format "x(6)"
                "³                    ¤ â  ¢ë¤ ç¨" skip.
put unformatted "                                               ÀÄÄÄÄÄÄÙ              „……’" skip.
put unformatted "    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip.
put unformatted "    ³" datap Format "x(20)"
                "³                                ³‘ç.N " db Format "x(25)"
                "³" skip.
put unformatted "    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.
put unformatted "                                                                     Š…„ˆ’" skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ                                 ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip.
put unformatted "       ¤ â  § ç¨á«¥­¨ï                                    ³‘ç.N " cr Format "x(25)"
                "³" skip.
put unformatted "                                                          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.
put unformatted "    " NameCl[1] Format "X(52)"
                "" skip.
put unformatted "    " NameCl[2] Format "x(52)"
                "" skip.
put unformatted "    ÄÄÄÄ ª®¬ã ¯à¨­ ¤«¥¦ â æ¥­­®áâ¨ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    ¯¨á ­¨¥ ®¯¥à æ¨¨: " textc[1] Format "x(45)"
                "" skip.
put unformatted "                       " textc[2] Format "x(45)"
                "" skip.
put unformatted "                       " textc[3] Format "x(45)"
                "" skip.
put unformatted "                       " textc[4] Format "x(45)"
                "" skip.
put unformatted "    á­®¢ ­¨¥: " Osn[1] Format "  x(75)"
                "" skip.
put unformatted "               " Osn[2] Format "x(75)"
                "" skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "        ¨¬¥­®¢ ­¨¥ æ¥­­®áâ¥©                    ³Š®«¨ç.³ ‘ã¬¬  ¢ ¨­.¢ «.³  ‘ã¬¬  ¢ àã¡." skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "  " cen[1] Format "  x(45)"
                "³" Q-t Format "x(6)"
                "³ " amt-cur-s Format "x(12)"
                "   ³ " amt-rub- Format ">>,>>>,>>>.99"
                "" skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    " cen[2] Format "x(45)"
                "³      ³                ³" skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    " cen[3] Format "x(45)"
                "³      ³                ³" skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    " cen[4] Format "x(45)"
                "³      ³                ³" skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "                                    ˆ’ƒ...     ³" Q-t Format "x(6)"
                "³ " amt-cur-s Format "x(12)"
                "   ³ " amt-rub- Format ">>,>>>,>>>.99"
                "" skip.
put unformatted "                                                 ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    ‘ã¬¬  ¯à®¯¨áìî " Amtp Format "x(66)"
                "" skip.
put unformatted "    " Amtp1 Format "x(86)"
                "" skip.
put skip(1).
put unformatted "    “ª § ­­ãî áã¬¬ã ¯®«ãç¨« ____________  ®¤¯¨áì ¨á¯®«­¨â¥«ï:___________/" user-op Format "x(15)"
                "/" skip.
put unformatted "                             (¯®¤¯¨áì)" skip.
put unformatted "                                          ®¤¯¨áì ª®­âà®«¥à :_____________________" skip.
put unformatted " " skip.
put unformatted "                                          ®¤¯¨áì ª áá¨à :________________________" skip.
put unformatted " " skip.
put unformatted " " skip.
put skip(35).
put unformatted "    " endtext Format "x(5)"
                "" skip.
put unformatted "                                                                     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip.
put unformatted "                                                                     ³       0402102     ³" skip.
put unformatted "    " Bank Format "x(52)"
                "             ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.
put unformatted "    ÄÄ ­ ¨¬¥­®¢ ­¨¥ ãçà¥¦¤¥­¨ï ¡ ­ª  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ              " datap Format "x(20)"
                "" skip.
put unformatted "                                               ÚÄÄÄÄÄÄ¿                ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    Ÿ‹›Š ‘‚†„€™ˆ‰ –…‘’œ            N ³" DNum Format "x(6)"
                "³                    ¤ â  ¢ë¤ ç¨" skip.
put unformatted "                                               ÀÄÄÄÄÄÄÙ" skip.
put unformatted "    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip.
put unformatted "    ³" datap Format "x(20)"
                "³                        ‘—…’    ³‘ç.N " db Format "x(25)"
                "³" skip.
put unformatted "    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip.
put skip(1).
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "       ¤ â  § ç¨á«¥­¨ï" skip.
put skip(1).
put unformatted "    " NameCl[1] Format "X(52)"
                "" skip.
put unformatted "    " NameCl[2] Format "x(52)"
                "" skip.
put unformatted "    ÄÄÄÄ ª®¬ã ¯à¨­ ¤«¥¦ â æ¥­­®áâ¨ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    ¯¨á ­¨¥ ®¯¥à æ¨¨: " textc[1] Format "x(45)"
                "" skip.
put unformatted "                       " textc[2] Format "x(45)"
                "" skip.
put unformatted "                       " textc[3] Format "x(45)"
                "" skip.
put unformatted "                       " textc[4] Format "x(45)"
                "" skip.
put unformatted "    á­®¢ ­¨¥: " Osn[1] Format "  x(75)"
                "" skip.
put unformatted "               " Osn[2] Format "x(75)"
                "" skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "        ¨¬¥­®¢ ­¨¥ æ¥­­®áâ¥©                    ³Š®«¨ç.³ ‘ã¬¬  ¢ ¨­.¢ «.³  ‘ã¬¬  ¢ àã¡." skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "  " cen[1] Format "  x(45)"
                "³" Q-t Format "x(6)"
                "³ " amt-cur-s Format "x(12)"
                "   ³ " amt-rub- Format ">>,>>>,>>>.99"
                "" skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    " cen[2] Format "x(45)"
                "³      ³                ³" skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    " cen[3] Format "x(45)"
                "³      ³                ³" skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    " cen[4] Format "x(45)"
                "³      ³                ³" skip.
put unformatted "    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "                                    ˆ’ƒ...     ³" Q-t Format "x(6)"
                "³ " amt-cur-s Format "x(12)"
                "   ³ " amt-rub- Format ">>,>>>,>>>.99"
                "" skip.
put unformatted "                                                 ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" skip.
put unformatted "    ‘ã¬¬  ¯à®¯¨áìî " Amtp Format "x(66)"
                "" skip.
put unformatted "    " Amtp1 Format "x(86)"
                "" skip.
put skip(1).
put unformatted "    “ª § ­­ãî áã¬¬ã ¯®«ãç¨« ____________  ®¤¯¨áì ¨á¯®«­¨â¥«ï:___________/" user-op Format "x(15)"
                "/" skip.
put unformatted "                             (¯®¤¯¨áì)" skip.
put unformatted "                                          ®¤¯¨áì ª®­âà®«¥à :_____________________" skip.
put unformatted " " skip.
put unformatted "                                          ®¤¯¨áì ª áá¨à :________________________" skip.
put unformatted " " skip.

/* Š®­¥ç­ë¥ ¤¥©áâ¢¨ï */
page.


{endout3.i &nofooter=yes}

