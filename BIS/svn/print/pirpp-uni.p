{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1997 ТОО "Банковские информационные системы"
     Filename: pirpp-uni.p
      Comment: Универсальная процедура печати платежных поручений
               адаптированная для ПИРБАНК.
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I StrtOut3.I EndOut3.I
      Used by:
      Created: 02.03.2000 Kostik
     Modified: 30.07.2003 kraw (0019129) Вариант со шрифтом elit в получателе
     Modified: 23.03.2006 anisimov добавление штампов в документы и т.п.
*/
Form "~n@(#) pirpp-uni.p 1.0 Kostik 02.03.2000 Kostik 02.03.2000 Универсальные п/п" with frame sccs-id width 250.

{globals.i}                                 /* глобальные переменные         */
{chkacces.i}
{intrface.get xclass}
&GLOB tt-op-entry yes
&IF defined(NEW_1256) NE 0 &THEN
   &SCOP NEW_1256 YES
   &SCOP NFORM    601
&ELSE
   &SCOP NFORM    60
&ENDIF

&IF defined(ELIT_POL) EQ 0 &THEN
   &SCOP ELIT_POL NO
&ELSE
   &SCOP ELIT_POL YES
&ENDIF

DEF VAR i        AS INTEGER          NO-UNDO.
DEF VAR PlatName AS CHAR    EXTENT 5 NO-UNDO.
DEF VAR PolName  AS CHAR    EXTENT 5 NO-UNDO.

DEF VAR beg-row AS INT NO-UNDO.
DEF VAR end-row AS INT NO-UNDO.

&SCOP TEST YES
&IF "{&TEST}" EQ "YES" &THEN
   DEF STREAM test.
   OUTPUT STREAM test TO "test.pp".
&ENDIF
{pirpp-uni.var {&*}}                                /* определение переменных        */

{pp-uni.not &ACTIVE      = YES
            &MAX-NUM-STR = 4
            &LENGTH      = 30}

&IF DEFINED(FRM_PRN) EQ 0 &THEN
   {pp-uni.frm {&*}}                                /* определение фрейма            */
&ELSE
   {{&FRM_PRN} {&*}}
&ENDIF

{pp-uni.err}                                /* сообщения об ошибках          */
{pirpp-uni.prg {&*}}                     /* описание стандартных процедур */

{pp-uni.chk}                                /* проверка входных данных       */

{pp-uni.run}                                /* непосредственно расчет        */

{pp-uni.not &BANK-CLIENT = YES}

&IF "{&TEST}" EQ "YES" &THEN
   OUTPUT STREAM test CLOSE.
&ENDIF


  /* #2895 */
IF  op.user-id = "MCI" AND op.doc-type = "09" THEN
DO:
  flReplDocType = yes .
  vReplDocType = "01" .
END.
ELSE 
  vReplDocType = op.doc-type .


{strtout3.i &cols=80 &option=Paged}  /* подготовка к выводу           */

{pirpp-uni.prn {&*}}                                /* непосредственно вывод         */

&IF DEFINED(LaserOff) EQ 0 &THEN
IF iDoc EQ 1 THEN DO:

   end-row = 72.
   beg-row =  1.
   theUserID = OP.user-inspector.
   FIND FIRST _user WHERE _user._userid EQ theUserID NO-LOCK NO-ERROR. 
   IF AVAILABLE (_user) THEN DO:
     IF _user._user-name NE "" THEN
          theUser = _user._user-name. 
   END.
   theKontr ="".

{pirlazerprn.lib &DATARETURN = 04010600.gen
                 &ELIT_POL   = "{&ELIT_POL}"
                 &FORM-DOC   = "{&NFORM}" 
                 &USER_SIGN_XY  = "VALUE('/X:3200 /Y:' + STRING((end-row - beg-row) * 75 - 550))"
/*                 &KONTR_SIGN_XY  = "VALUE('/X:3200 /Y:' + STRING((end-row - beg-row) * 75 - 550))"
                 &KONTR_SIGN_DOWN_XY  = "VALUE('/X:3200 /Y:' + STRING((end-row - beg-row) * 75 - 550))" */
                 {&*}}
END.
&ENDIF
{endout3.i  &nofooter=yes}                   /* завершение вывода             */

