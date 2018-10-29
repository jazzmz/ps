/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1997 ТОО "Банковские информационные системы"
     Filename: pt-uni.p
      Comment: Универсальная процедура печати платежного требования
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I StrtOut3.I EndOut3.I
      Used by:
      Created: 02.03.2000 Kostik
     Modified: 11.09.2002 Gunk signs.fun -> intrface.get xclass
     Modified: 12/01/2005 kraw 0040840 Модификация имени плательщика (ДР "п106н_СтатПлат")
     Modified: 20/07/2007 kraw (0026826) многопроводочное конверсионное ПТ
*/
Form "~n@(#) pt-uni.p 1.0 Kostik 02.03.2000 Kostik 02.03.2000 Универсальные п/т" with frame sccs-id width 250.

{globals.i}                                 /* глобальные переменные         */
{chkacces.i}
&GLOB tt-op-entry yes
&GLOBAL-DEFINE OFFSIGNS YES
&IF defined(NEW_1256) NE 0 &THEN
   &SCOP NFORM    611
&ELSE
   &SCOP NFORM    61
&ENDIF
{intrface.get xclass}
&SCOP TEST YES
&IF "{&TEST}" EQ "YES" &THEN
   DEF STREAM test.
   OUTPUT STREAM test TO "test.pp".
&ENDIF

{pirpp-uni.var}                                /* определение переменных        */
{pt-uni.var}

DEF VAR beg-row AS INT NO-UNDO.
DEF VAR end-row AS INT NO-UNDO.

&IF DEFINED(FRM_PRN) EQ 0 &THEN
   {pt-uni.frm}                                /* определение фрейма            */
&ELSE
   {{&FRM_PRN}}
&ENDIF

{pp-uni.err}                                /* сообщения об ошибках          */

{pirpp-uni.prg}                     /* описание стандартных процедур */
{pt-uni.prg}

{pp-uni.chk &allcur=YES &multy-op-ontry=YES}                                /* проверка входных данных       */

{pp-uni.run}                                /* непосредственно расчет        */
{pt-uni.run}

&IF "{&TEST}" EQ "YES" &THEN
   OUTPUT STREAM test CLOSE.
&ENDIF
PROCEDURE GetHeader:
   RUN DefHeader.
   ASSIGN
      NameOrder  = "ПЛАТЕЖНОЕ ТРЕБОВАНИЕ N"
      NumberForm = "0401061"
   .

END PROCEDURE.

{nal_name.i}

{strtout3.i &cols=80 &option=Paged}  /* подготовка к выводу           */
{pt-uni.prn}                                /* непосредственно вывод         */
IF iDoc EQ 1 THEN DO:

   end-row = 72.
   beg-row =  1.
   theUserID = OP.user-id.
   FIND FIRST _user WHERE _user._userid EQ theUserID NO-LOCK NO-ERROR. 
   IF AVAILABLE (_user) THEN DO:
     IF _user._user-name NE ? THEN
          theUser = _user._user-name. 
   END.
   theKontr ="".

   {pirlazerprn.lib &DATARETURN = 0401061_stamp.prg
                 &FORM-DOC   = "611"
             	 &INKSTAMP = YES
                 &USER_SIGN_XY  = "VALUE('/X:3350 /Y:' + STRING((end-row - beg-row) * 75 - 550))"
                 {&*}
	}
END.
{endout3.i  &nofooter=yes}                   /* завершение вывода             */
