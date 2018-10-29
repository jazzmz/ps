/* 
               Банковская интегрированная система БИСквит 
    Copyright: (C) 1992-2007 ЗАО "Банковские информационные системы" 
     Filename: f212v.p
      Comment: Программа просмотра отчетных данных 
               по классу f212 ( Форма 212. Проверки правил работы с наличными деньгами ), 
      Created: 28/02/07 SALN
*/  

{norm.i new}

{intrface.get tmess}        /* Служба системных сообщений */
{intrface.get strng}


{sv-cqr#.i 
    &prg        = "pir_f227_2v"
    &oth3 = "blank "
}

{intrface.del}
RETURN "".