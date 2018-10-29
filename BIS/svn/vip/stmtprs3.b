   /******
    * Степанов С.В. stmtprs Стандартная (ПИРБАНК)- Регистр аналит.учета СВОДНАЯ ПЕРЕОЦЕН
    * сделана из stmtprr3.b - вариант вызова [ ]По дням и счет выписки рублевый
    * убрал код документа, код банка и номер счета корреспондента
    *  Инициатор Кувикова Ж. Ю.
    * Дата создания 27.07.2011
    ******/

      display
&if defined(nodate) eq 0 &then
         stmt.op-date 
&endif
         stmt.doc-num
/*         GetCBDocType1(stmt.doc-type) @ stmt.doc-type
         stmt.bank-code 
         sacctcur
*/
         stmt.amt-rub @ sh-{&this}
         detarr[1].
      down. 
      
      if hdetail > 1 then
         do idet = 2 to hdetail:
            if trim (detarr[idet]) eq "" then next.
             display

&if defined(nodate) eq 0 &then
             "" @ stmt.op-date 
&endif
             "" @ stmt.doc-num
/*             "" @ stmt.doc-type
             "" @ stmt.bank-code
             "" @ sacctcur
*/
             "" @ sh-db
             "" @ sh-cr 
             detarr[idet] @ detarr[1].
           down.           
         end.
         
 