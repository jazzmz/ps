/* #977
Ф401 Раздел 5. Метод после расчета. Удаления счетов 91604 для резидентов. 
Наш метод pir_f401r5ca.p на базе БИСовского f401r5ca.p, суть его в добавке удаления счетов 91604 для резидентов.
ПРИ ОБНОВЛЕНИЯХ НУЖНО ДОБАВЛЯТЬ ЭТОТ КУСОК КОДА ЕСЛИ ПРОЦЕДУРА ПОМЕНЯЕТСЯ.
И СМОТРЕТЬ НЕ ПЕРЕТРЕТ ЛИ НАШ МЕТОД ДО ИСПОЛНЕНИЯ ЗАЯВКИ БИС.
*/

{sv-calc.i}
{intrface.get strng}
{f401.i}

DEFINE VARIABLE mValOthers AS INT64 EXTENT 4    NO-UNDO
   INIT [3,0,0,7].
DEFINE VARIABLE val AS DECIMAL     NO-UNDO.
DEFINE VARIABLE vCalcVal AS DECIMAL     NO-UNDO.

/* Сбрасываем установки, которые могли остаться после печати */
RUN SetSysConf IN h_base ({&REPORT-LABEL},?).

sh-branch-id = DataBlock.Branch-Id.

RUN PutScreen(1,PADR("Корректировка",80)).

{for_form.i
   &and = "AND b-formula.var-id BEGINS '5.1_Корр'"
}
   RUN PutScreen(15,PADR("Формула " + formula.var-id,65)).

   RUN normpars.p (REPLACE(formula.formula,"~n"," "),
                   DataBlock.Beg-Date,
                   DataBlock.End-Date,
                   OUTPUT Val).

   DO TRANSACTION:
      CREATE DataLine.
      ASSIGN
         DataLine.Data-Id = DataBlock.Data-Id
         DataLine.Sym1    = "5.1к"
         DataLine.Sym2    = "00000000000000000000"
         DataLine.Sym3    = "840"
         DataLine.Sym4    = SUBSTRING(formula.var-id,9)
         DataLine.Val[INTEGER(DataLine.Sym4)] = Val
      .
      /* Для корректного контроля с балансом */
      DataLine.Val[mValOthers[INTEGER(DataLine.Sym4)]] = 0 - DataLine.Val[INTEGER(DataLine.Sym4)].
   END.

END.
{for_form.i
   &and = "AND b-formula.var-id BEGINS '5.8_Корр'"
   &nodef = "/*"
}
  RUN normpars.p (REPLACE(formula.formula,"~n"," "),
                   DataBlock.Beg-Date,
                   DataBlock.End-Date,
                   OUTPUT val).

  IF val GE 0 THEN NEXT.
  RUN PutScreen(15,PADR("Формула " + formula.var-id,65)).

  DO TRANSACTION:
     RUN olap.p ( OUTPUT vCalcVal ,DataBlock.Beg-Date,DataBlock.End-Date,"f401r5c|val" + DataLine.Sym4 ).
     IF  vCalcVal + Val GE 0 THEN
     DO:
         CREATE DataLine.
         ASSIGN
             DataLine.Data-Id = DataBlock.Data-Id
             DataLine.Sym1    = "5.8к"
             DataLine.Sym2    = "00000000000000000000"
             DataLine.Sym3    = "978"
             DataLine.Sym4    = SUBSTRING(formula.var-id,9)
             DataLine.Val[INTEGER(DataLine.Sym4)] = Val.
     
     CREATE DataLine.
     ASSIGN
         DataLine.Data-Id = DataBlock.Data-Id
         DataLine.Sym1    = "5.1кк"
         DataLine.Sym2    = "00000000000000000000"
         DataLine.Sym3    = "840"
         DataLine.Sym4    = SUBSTRING(formula.var-id,9)
         DataLine.Val[INTEGER(DataLine.Sym4)] = - Val.
     END.
     ELSE RUN Fill-SysMes IN h_Olap ("","","1","Корректировка по строке 5.8 не возможна. Иначе значение графы будет отрицательным!" ).
  END.
END.

RUN PutScreen(1, PADR("Корректировка завершена",80)).
PAUSE(10).
RUN PutScreen(1, PADR("",80)).

/* >>> начало добавки ПИР */

/* удаляем счета 91604 для клиентов резидентов из 5го раздела 401 формы
добавка в метод AfterCalc (Вызывается после расчета/сво) f401r5ca
*/

RUN PutScreen(1,PADR("<ПИР> удаляем счета 91604 для клиентов резидентов из 5го раздела 401 формы",80)).

DEF VAR i AS INT NO-UNDO INIT 1.

FOR EACH DataLine
  WHERE DataLine.Data-Id = DataBlock.Data-Id
    AND DataLine.Sym2   BEGINS '91604'
    AND DataLine.Txt    BEGINS 'Р'
:
    RUN PutScreen(1,PADR(STRING(i, ">>>9") + "\t" + DataLine.Sym2 + "\t" + DataLine.Txt, 80)).

    i = i + 1.
    DELETE DataLine.
END.

/* >>> начало добавки ПИР */

{intrface.del}
RETURN "".
