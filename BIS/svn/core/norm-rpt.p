{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: norm-rpt.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : normcalc.p
Причина       : Приказ №64 от 25.10.2005
Место запуска : ??????
Автор         : ??????
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.2  2007/08/17 07:35:42  Lavrinenko
Изменения     : 1. Добавлен стандартный заголовок 2. произведены работы для корректного выноса norm-end.i norm-rpt.i
Изменения     :
------------------------------------------------------ */

/*
                Банковская интегрированная система БИСквит
    Copyright:  (C) 1992-1996 ТОО "Банковские информационные системы"
     Filename:  NORMCALC.P
      Comment:

         Uses:
      Used by:
      Created:  09/04/1996 15:09:06 Serge
     Modified:  09/04/1996 15:09:06 Serge
     Modified:  31/03/1997 Serge Предварительный расчет ширины отчета, var PrinterWidth
     Modified:  29/05/1997 Serge оператор "ОКРУГЛЕНИЕ 1000" - все исходные данные
                               по остаткам/оборотам округляются до тысяч/миллионов.
     Modified:  02/10/1998 Serge формат (после ":") воспринимается только, есди в нем нет ")"
     Modified:  27/08/2001 NIK. Описания переменных вынесены в файл norm-rpt.def,
                           основной исполняемый код вынесен в файл norm-rpt.i
*/

Form "~n@(#) NORMCALC.P 1.0 Serge 09/04/96 Serge 09/04/96"
with frame sccs-id stream-io width 250.

{globals.i}
{pick-val.i}

{norm-rpt.def}                                   /* определение параметров и переменных          */
{norm.i}
{norm.def 
&normshtmp = "yes"
&TDataBlock = "yes"
&TmpText = "yes"
&tab-prn = "yes"
&norm-dates = "yes"}
{calcdate.i}

{n-lines.i &norm=InputFName &file=norm}

{pirraproc.def}
&GLOB filename arch_file_name
{pirraproc.i}																		/*ПИРБАНК: автоматическое сохранение печатных форм */

{norm-rpt.i}                                     /* основная обработка отчета по нормативам      */

{norm-end.i}

/*************************************************************************************************/
