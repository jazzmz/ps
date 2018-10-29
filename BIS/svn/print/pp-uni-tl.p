{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1997 ТОО "Банковские информационные системы"
     Filename: pp-uni.p
      Comment: Универсальная процедура печати платежных поручений
               адаптированная для доверительного управления.
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I StrtOut3.I EndOut3.I
      Used by:
      Created: 02.03.2000 Kostik
     Modified: 30.07.2003 kraw (0019129) Вариант со шрифтом elit в получателе
     Modified: 12/01/2005 kraw 0040840 Модификация имени плательщика (ДР "п106н_СтатПлат")
     Modified:
*/
Form "~n@(#) pp-uni.p 1.0 Kostik 02.03.2000 Kostik 02.03.2000 Универсальные п/п" with frame sccs-id width 250.

{globals.i}                                 /* глобальные переменные         */
{chkacces.i}
{intrface.get xclass}

&GLOB tt-op-entry yes
&IF defined(NEW_1256) NE 0 &THEN
   &SCOP NFORM    601
   &SCOP NEW_1256 YES
&ELSE
   &SCOP NFORM    60
&ENDIF

&IF defined(ELIT_POL) EQ 0 &THEN
   &SCOP ELIT_POL NO
&ELSE
   &SCOP ELIT_POL YES
&ENDIF

DEF VAR i        AS INTEGER          NO-UNDO.
DEF VAR PlatName AS CHAR    EXTENT 6 NO-UNDO.
DEF VAR PolName  AS CHAR    EXTENT 6 NO-UNDO.

&SCOP TEST YES
&IF "{&TEST}" EQ "YES" &THEN
   DEF STREAM test.
   OUTPUT STREAM test TO "test.pp".
&ENDIF
{pp-uni.var {&*}}                                /* определение переменных        */
{pp-uni.not &ACTIVE      = YES
            &MAX-NUM-STR = 4
            &LENGTH      = 30}
&IF DEFINED(FRM_PRN) EQ 0 &THEN
   {pp-uni.frm {&*}}                                /* определение фрейма            */
&ELSE
   {{&FRM_PRN} {&*}}
&ENDIF

{pp-uni.err}                                /* сообщения об ошибках          */
{pp-uni-tl.prg {&*}}                     /* описание стандартных процедур */

{pp-uni.chk}                                /* проверка входных данных       */

{pp-uni.run}                                /* непосредственно расчет        */

{pp-uni.not &BANK-CLIENT = YES}

&IF "{&TEST}" EQ "YES" &THEN
   OUTPUT STREAM test CLOSE.
&ENDIF

{nal_name.i}

{strtout3.i &cols=80 &option=Paged}  /* подготовка к выводу           */

{pp-uni.prn {&*}}                                /* непосредственно вывод         */

&IF DEFINED(LaserOff) EQ 0 &THEN
IF iDoc EQ 1 THEN DO:
{lazerprn.lib &DATARETURN = 0401060.gen
              &ELIT_POL   = "{&ELIT_POL}"
              &FORM-DOC   = "{&NFORM}"}
END.
&ENDIF
{endout3.i  &nofooter=yes}                   /* завершение вывода             */

