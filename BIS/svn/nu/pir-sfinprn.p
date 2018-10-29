/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2005 ЗАО "Банковские информационные системы"
     Filename: pir-SFINPRN.P
      Comment: Печать журнала полученных счетов-фактур
		в версии PIR подправлены sf-in-[hdr,body,end] на предмет удаления "Дата оплаты счета-фактуры"
   Parameters:
         Uses: 
      Used by:
      Created: 27.01.2005 Gorm  (0045974)
     Modified: 16.06.2005 11:11 gorm     
     Modified:   
*/

{globals.i}
{intrface.get xclass}
{intrface.get axd}
{intrface.get strng}

DEF VAR mContract AS CHAR NO-UNDO.
DEF VAR mTitle AS CHAR NO-UNDO.    /*заголовок отчета*/

ASSIGN
   mContract = "sf-in"
   mTitle = "Журнал учета полученных счетов-фактур"
    .

{pir-sfprn.i}

{intrface.del}
