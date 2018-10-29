/* #977
�401 ������ 5. ��⮤ ��᫥ ����. �������� ��⮢ 91604 ��� १����⮢. 
��� ��⮤ pir_f401r5ca.p �� ���� �����᪮�� f401r5ca.p, ���� ��� � ������� 㤠����� ��⮢ 91604 ��� १����⮢.
��� ����������� ����� ��������� ���� ����� ���� ���� ��������� ����������.
� �������� �� �������� �� ��� ����� �� ���������� ������ ���.
*/

{sv-calc.i}
{intrface.get strng}
{f401.i}

DEFINE VARIABLE mValOthers AS INT64 EXTENT 4    NO-UNDO
   INIT [3,0,0,7].
DEFINE VARIABLE val AS DECIMAL     NO-UNDO.
DEFINE VARIABLE vCalcVal AS DECIMAL     NO-UNDO.

/* ����뢠�� ��⠭����, ����� ����� ������� ��᫥ ���� */
RUN SetSysConf IN h_base ({&REPORT-LABEL},?).

sh-branch-id = DataBlock.Branch-Id.

RUN PutScreen(1,PADR("���४�஢��",80)).

{for_form.i
   &and = "AND b-formula.var-id BEGINS '5.1_����'"
}
   RUN PutScreen(15,PADR("���㫠 " + formula.var-id,65)).

   RUN normpars.p (REPLACE(formula.formula,"~n"," "),
                   DataBlock.Beg-Date,
                   DataBlock.End-Date,
                   OUTPUT Val).

   DO TRANSACTION:
      CREATE DataLine.
      ASSIGN
         DataLine.Data-Id = DataBlock.Data-Id
         DataLine.Sym1    = "5.1�"
         DataLine.Sym2    = "00000000000000000000"
         DataLine.Sym3    = "840"
         DataLine.Sym4    = SUBSTRING(formula.var-id,9)
         DataLine.Val[INTEGER(DataLine.Sym4)] = Val
      .
      /* ��� ���४⭮�� ����஫� � �����ᮬ */
      DataLine.Val[mValOthers[INTEGER(DataLine.Sym4)]] = 0 - DataLine.Val[INTEGER(DataLine.Sym4)].
   END.

END.
{for_form.i
   &and = "AND b-formula.var-id BEGINS '5.8_����'"
   &nodef = "/*"
}
  RUN normpars.p (REPLACE(formula.formula,"~n"," "),
                   DataBlock.Beg-Date,
                   DataBlock.End-Date,
                   OUTPUT val).

  IF val GE 0 THEN NEXT.
  RUN PutScreen(15,PADR("���㫠 " + formula.var-id,65)).

  DO TRANSACTION:
     RUN olap.p ( OUTPUT vCalcVal ,DataBlock.Beg-Date,DataBlock.End-Date,"f401r5c|val" + DataLine.Sym4 ).
     IF  vCalcVal + Val GE 0 THEN
     DO:
         CREATE DataLine.
         ASSIGN
             DataLine.Data-Id = DataBlock.Data-Id
             DataLine.Sym1    = "5.8�"
             DataLine.Sym2    = "00000000000000000000"
             DataLine.Sym3    = "978"
             DataLine.Sym4    = SUBSTRING(formula.var-id,9)
             DataLine.Val[INTEGER(DataLine.Sym4)] = Val.
     
     CREATE DataLine.
     ASSIGN
         DataLine.Data-Id = DataBlock.Data-Id
         DataLine.Sym1    = "5.1��"
         DataLine.Sym2    = "00000000000000000000"
         DataLine.Sym3    = "840"
         DataLine.Sym4    = SUBSTRING(formula.var-id,9)
         DataLine.Val[INTEGER(DataLine.Sym4)] = - Val.
     END.
     ELSE RUN Fill-SysMes IN h_Olap ("","","1","���४�஢�� �� ��ப� 5.8 �� ��������. ���� ���祭�� ���� �㤥� ����⥫��!" ).
  END.
END.

RUN PutScreen(1, PADR("���४�஢�� �����襭�",80)).
PAUSE(10).
RUN PutScreen(1, PADR("",80)).

/* >>> ��砫� ������� ��� */

/* 㤠�塞 ��� 91604 ��� �����⮢ १����⮢ �� 5�� ࠧ���� 401 ���
������� � ��⮤ AfterCalc (��뢠���� ��᫥ ����/᢮) f401r5ca
*/

RUN PutScreen(1,PADR("<���> 㤠�塞 ��� 91604 ��� �����⮢ १����⮢ �� 5�� ࠧ���� 401 ���",80)).

DEF VAR i AS INT NO-UNDO INIT 1.

FOR EACH DataLine
  WHERE DataLine.Data-Id = DataBlock.Data-Id
    AND DataLine.Sym2   BEGINS '91604'
    AND DataLine.Txt    BEGINS '�'
:
    RUN PutScreen(1,PADR(STRING(i, ">>>9") + "\t" + DataLine.Sym2 + "\t" + DataLine.Txt, 80)).

    i = i + 1.
    DELETE DataLine.
END.

/* >>> ��砫� ������� ��� */

{intrface.del}
RETURN "".
