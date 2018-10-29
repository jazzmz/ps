{pirsavelog.p}


/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1997 ТОО "Банковские информационные системы"
     Filename: pirpp-uni.p
      Comment: Универсальная процедура печати мемориальных ордеров
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
/*-------------------- Входные параметры --------------------*/
Define Input Param RID as RecID no-undo.

&IF defined(ELIT_POL) EQ 0 &THEN
   &SCOP ELIT_POL NO
&ELSE
   &SCOP ELIT_POL YES
&ENDIF

DEF VAR i        AS INTEGER          NO-UNDO.
DEF VAR PlatName AS CHAR    EXTENT 5 NO-UNDO.
DEF VAR PolName  AS CHAR    EXTENT 5 NO-UNDO.


{pirmem-uni.var {&*}}                                /* определение переменных        */

{pirmem-uni-cvt.prg {&*}}                                /* описание стандартных процедур */

    &SCOP NFORM    110

{pirmem-uni-cvt.frm {&*}}                                /* определение фрейма            */

{strtout3.i &cols=80 &option=Paged}                  /* подготовка к выводу           */

{pirmem-uni-cvt.prn {&*}}                                /* непосредственно вывод         */

&IF DEFINED(LaserOff) EQ 0 &THEN
IF iDoc EQ 1 THEN DO:

{pirlazerprn.lib &DATARETURN = 04010108.gen
                 &ELIT_POL   = "{&ELIT_POL}"
                 &FORM-DOC   = "{&NFORM}" 
                 {&*}}
END.
&ENDIF
{endout3.i  &nofooter=yes}                           /* завершение вывода             */






