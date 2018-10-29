{pirsavelog.p}

/* 
               Банковская интегрированная система БИСквит 
    Copyright: (C) 1992-1996 ТОО "Банковские информационные системы" 
     Filename: n_vredps.p
      Comment: Программа просмотра Сводных данных 
               по классификатору ree_dpspr ( Промежуточный реестр обязательств перед вкладчиками ), 
               созданная Генератором программ gen-sv1.p. 
         Uses: n_vredps.lf,n_vredps.uf,n_vredps.nav,n_vredps.nau,n_vredps.cal
      Created: 20/08/04 SAP
*/  
DEFINE VARIABLE mCat AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mId  AS INTEGER    NO-UNDO.

{form.def}
{sv-form#.i 
    &prg        = "pirn_vredps"
    &total      = "pirn_vredps.cal "
}

form
   DataLine.Sym1 format "999999999" column-label "УНКг"
         help "Системный номер физ.лица"
   DataLine.Sym2 format "x(1)" column-label "С"
         help "Служебный симвлол"
   DataLine.Sym3 format "x(22)" column-label "Номер договора"
         help "Номер договора"
   DataLine.Sym4 format "x(9)" column-label "Рег.номер"
         help "Регистрационный номер банка (филиала)"
   Txt[1]  format "x(30)" column-label "ФИО"
         help "Фамилия Имя Отчество"
   Txt[2]  format "x(30)" column-label "Адрес"
         help "Реквизиты адреса"
   Txt[3]  format "x(3)" column-label "Код"
         help "Код вида документа"
   Txt[4]  format "x(15)" column-label "Номер док."
         help "Серия и номер документа"
   Txt[5]  format "x(40)" column-label "Выдан"
         help "Кем выдан"
/*   Txt[9]  format "x(10)" column-label "Дата!Выдачи"
         help "Дата выдачи документа"
*/
   Txt[6]  format "x(10)" column-label "Дата дог."
         help "Дата договора вклада"
   Txt[7]  format "x(20)" column-label "Счет"
         help "Номер лицевого счета"
   Txt[8]  format "x(10)" column-label "Телефон"
         help "Телефон"
   Txt[9]  format "x(10)" column-label "Договор"
         help "Договор"
   Txt[10]  format "x(10)" column-label "E-mail"
         help "Электронная почта"
   Txt[11]  format "x(20)" column-label "Адрес"
         help "Почтовый адрес"
	 
   DataLine.Val[1]  format ">>>,>>>,>>>,>>9.99" column-label "Сумма в валюте"
         help "Сумма в валюте счета"
   DataLine.Val[2]  format "->>>,>>>,>>>,>>9.99" column-label "Сумма в рублях"
         help "Сумма в рублях РФ по курсу"
with frame browse title color bright-white "[ " + (if avail branch then caps(branch.short-name) else "?") + " - " + caps(DataClass.Name) +       " ЗА " + caps(per) + " ]" width 320  .

