{pirsavelog.p}

/*-----------------------------------------------------------------------------
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: sw-unico.p
      Comment: Сбор данных при запуске из документов
   Parameters:
         Uses: 
      Used by:
      Created: 27/05/2003 Peter
     Modified: 
-----------------------------------------------------------------------------*/
form "~n@(#) sw-unico.p Peter Peter" with frame sccs-id stream-io width 250.

&if defined( FILE_sword_p ) = 0 &then &global-define FILE_sword_p true
&endif

{globals.i}
{pp-uni.var}
{pp-uni.prg &NEW_1256=Yes}
{sw-uni.def &NOINPUT=YES}
{sw-uni.pro}

MESSAGE "Сбор данных по документам...".
{sw-uni.i}
