{pirsavelog.p}

/*-----------------------------------------------------------------------------
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2001 ТОО "Банковские информационные системы"
     Filename: sword-pw.p
      Comment: Печать сводного мемориального ордера (используется фильтр).
               Сокращаем расход бумаги. Подключается в CTRL-G в док-тах дня.
   Parameters:
         Uses: nowhere
      Used by:
      Created: 28/02/2000 Vlad
     Modified: 06/03/2000 Vlad - Вариант для браузера проводок
     Modified: 16/05/2001 yakv - вывод имени фильтра во второй строке
     Modified: 28/02/2003 kraw (13230) вариант с широкой печатью
-----------------------------------------------------------------------------*/
form "~n@(#) SWORD-P.P vlad yakv "
with frame sccs-id stream-io width 250.

&if defined( FILE_sword_p_p ) = 0 &then &global-define FILE_sword_p_p true
&endif
&if defined( FILE_sword_i_wide ) = 0 &then &global-define FILE_sword_i_wide true
&endif
/*---------------------------------------------------------------------------*/
{swordf2.i}
