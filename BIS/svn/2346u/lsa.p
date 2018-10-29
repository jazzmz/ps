{pirsavelog.p}


                   /*******************************************
                    *                                         *
                    *  ГОСПОДА ПРОГРАММИСТЫ И СОЧУВСТВУЮЩИЕ!  *
                    *                                         *
                    *  РЕДАКТИРОВАТЬ ДАННЫЙ ФАЙЛ БЕСПОЛЕЗНО,  *
                    *  Т.К. ОН СОЗДАЕТСЯ ГЕНЕРАТОРОМ ОТЧЕТОВ  *
                    *             АВТОМАТИЧЕСКИ!              *
                    *                                         *
                    *******************************************/

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2005 ТОО "Банковские информационные системы"
     Filename: lsa.p
      Comment: Отчет, созданный генератором отчетов
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 06/09/05 13:13:00
     Modified:
*/
Form "~n@(#) lsa.p 1.0 RGen 06/09/05 RGen 06/09/05 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- Входные параметры --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- Объявление переменных --------------------*/

Define Buffer buf_0_op               For op.

/*--------------- Буфера для полей БД: ---------------*/

/*--------------- Переменные для специальных полей: ---------------*/
Define Variable Bank-name        As Character            No-Undo.
Define Variable dob              As Date                 No-Undo.
Define Variable drag-b           As Decimal              No-Undo.
Define Variable drag-o           As Decimal              No-Undo.
Define Variable Ispol            As Character            No-Undo.
Define Variable k-b              As Decimal              No-Undo.
Define Variable k-drag-b         As Decimal              No-Undo.
Define Variable k-drag-o         As Decimal              No-Undo.
Define Variable k-o              As Decimal              No-Undo.
Define Variable kinv-b           As Decimal              No-Undo.
Define Variable kinv-o           As Decimal              No-Undo.
Define Variable tot-b            As Decimal              No-Undo.
Define Variable tot-o            As Decimal              No-Undo.
Define Variable val-b            As Decimal              No-Undo.
Define Variable val-o            As Decimal              No-Undo.

/*--------------- Определение форм для циклов ---------------*/

/* Начальные действия */
{getdate.i}

def var bDocRub as logical no-undo.

def var bDocDrg as logical no-undo.

def var bDocKas as logical no-undo.

def var nDigit  as integer no-undo.

def var nDocAmt like op-entry.amt-rub no-undo.

DEFINE BUFFER xop-entry FOR op-entry.

DEFINE VARIABLE mReRate    AS CHARACTER NO-UNDO.
DEFINE VARIABLE adb        AS CHARACTER NO-UNDO.
DEFINE VARIABLE acr        AS CHARACTER NO-UNDO.
DEFINE VARIABLE isCash     AS LOGICAL   NO-UNDO.

{op-cash.def}
mReRate    = FGetSetting("БухЖур(b)", "ПерСчет",   "*empty*").


for each op where op-date = end-date and op.op-status >= gop-status no-lock:
    bDocRub = YES.

    for each op-entry of op no-lock:
        IF op-entry.currency NE "" THEN bDocRub =NO.
    end.

    for each op-entry of op:
       ASSIGN
          adb = ?
          acr = ?
       .

       IF op-entry.acct-cr EQ ? THEN 
       DO:
          FIND FIRST xop-entry WHERE xop-entry.op = op.op 
                                 AND xop-entry.acct-db EQ ? 
             USE-INDEX op-entry NO-LOCK NO-ERROR.
          ASSIGN
            adb = op-entry.acct-db
            acr = IF AVAILABLE xop-entry THEN xop-entry.acct-cr ELSE "**empty**"
          .
       END.
       ELSE IF op-entry.acct-db EQ ? THEN 
       DO:
          FIND FIRST xop-entry WHERE xop-entry.op = op.op 
                                 AND xop-entry.acct-cr EQ ? 
             USE-INDEX op-entry NO-LOCK  NO-ERROR.
          ASSIGN       
             adb = IF AVAILABLE xop-entry THEN xop-entry.acct-db ELSE "**empty**"
             acr = op-entry.acct-cr
          .
       END.
       ELSE 
       DO:
          ASSIGN
             adb = op-entry.acct-db
             acr = op-entry.acct-cr
          .
       END.
       {op-cash.i}

        assign
  
            bDocKas     = isCash.
            bDocDrg     = false

        .

        IF bDocRub THEN
           bDocRub = NOT (CAN-FIND( FIRST acct WHERE acct.acct = op-entry.acct-cr
                                                 AND CAN-DO(mReRate, acct.acct))
                          OR 
                          CAN-FIND( FIRST acct WHERE acct.acct = op-entry.acct-db
                                                 AND CAN-DO(mReRate, acct.acct))
           ).


        IF bDocRub AND op-entry.acct-db = ? THEN
            bDocRub = NOT CAN-FIND(FIRST op-entry OF op WHERE op-entry.currency <> "" 
                                                          AND op-entry.acct-cr = ?
                                  ).
        ELSE IF bDocRub AND op-entry.acct-cr = ? THEN
            bDocRub = NOT CAN-FIND(FIRST op-entry OF op WHERE op-entry.currency <> "" 
                                                          AND op-entry.acct-db = ?
                                  ).

        if( (not bDocRub) and (not bDocDrg) ) then do:

            nDigit = -1.

            assign

                nDigit = integer( substr( op-entry.currency, 1, 1 ) )

            no-error.

            bDocDrg = (nDigit < 0).

        end.

        assign

            nDocAmt = 0
            nDocAmt = op-entry.amt-rub

            when op-entry.acct-db <> ?

        .

        assign

            tot-b  = tot-b  + nDocAmt       /* Баланс все документы */

                when (op.acct-cat = "b")

            k-b = k-b + nDocAmt             /* Баланс все кассовые */

                when (op.acct-cat = "b")

                 /*and (bDocRub)*/ and (bDocKas)

            val-b = val-b + nDocAmt         /* Баланс валюта мемориальные */
    
                when (op.acct-cat = "b")
    
                 and (not bDocRub) and (not bDocDrg) and (not bDocKas)
    
            kinv-b = kinv-b + nDocAmt       /* Баланс валюта кассовые */
    
                when (op.acct-cat = "b")

             and (not bDocRub) and (not bDocDrg) and (bDocKas)

            drag-b = drag-b + nDocAmt       /* Баланс драг.мет. мемориальные */
    
                when (op.acct-cat = "b")
    
                 and (not bDocRub) and (bDocDrg) and (not bDocKas)
    
            k-drag-b = k-drag-b + nDocAmt   /* Баланс драг.мет. кассовые */
    
                when (op.acct-cat = "b")

             and (not bDocRub) and (bDocDrg) and (bDocKas)

            tot-o  = tot-o  + nDocAmt       /* Внебаланс все документы */
    
                when (op.acct-cat = "o")
    
            k-o = k-o + nDocAmt             /* Внебаланс все кассовые */
    
                when (op.acct-cat = "o")
    
                 /*and (bDocRub)*/ and (bDocKas)

            val-o = val-o + nDocAmt         /* Внебаланс валюта мемориальные */
    
                when (op.acct-cat = "o")
    
                 and (not bDocRub) and (not bDocDrg) and (not bDocKas)
    
            kinv-o = kinv-o + nDocAmt       /* Внебаланс валюта кассовые */
    
                when (op.acct-cat = "o")

                 and (not bDocRub) and (not bDocDrg) and (bDocKas)
    
            drag-o = drag-o + nDocAmt       /* Внебаланс драг.мет. мемориальные */
    
                when (op.acct-cat = "o")
    
                 and (not bDocRub) and (bDocDrg) and (not bDocKas)
    
            k-drag-o = k-drag-o + nDocAmt   /* Внебаланс драг.мет. кассовые */

                when (op.acct-cat = "o")
    
                 and (not bDocRub) and (bDocDrg) and (bDocKas)
    
        .
    
    end.
    
end.

/*-----------------------------------------
   Проверка наличия записи главной таблицы,
   на которую указывает Input Param RID
-------------------------------------------*/
Find op Where RecID(op) = RID no-lock no-error.
If Not Avail(op) then do:
  message "Нет записи <op>".
  Return.
end.

/*------------------------------------------------
   Выставить buffers на записи, найденные
   в соответствии с заданными в отчете правилами
------------------------------------------------*/
/* Т.к. не задано правило для выборки записей из главной таблицы,
   просто выставим его buffer на input RecID                    */
find buf_0_op where RecID(buf_0_op) = RecID(op) no-lock.

/*------------------------------------------------
   Вычислить значения специальных полей
   в соответствии с заданными в отчете правилами
------------------------------------------------*/
/* Вычисление значения специального поля Bank-name */
{get-bankname.i}
{get_set.i "Банк"}

    assign

/*       bank-name = setting.val*/
       bank-name = cBankName

    .

/* Вычисление значения специального поля dob */
assign

 dob = end-date

.

/* Вычисление значения специального поля drag-b */
/* Смотри начальные действия */

/* Вычисление значения специального поля drag-o */
/* Смотри начальные действия */

/* Вычисление значения специального поля Ispol */
find first _user where _user._userid = user('bisquit').

       assign

             ispol = _user._user-name

       .

/* Вычисление значения специального поля k-b */
/* Смотри начальные действия */

/* Вычисление значения специального поля k-drag-b */
/* Смотри начальные действия */

/* Вычисление значения специального поля k-drag-o */
/* Смотри начальные действия */

/* Вычисление значения специального поля k-o */
/* Смотри начальные действия */

/* Вычисление значения специального поля kinv-b */
/* Смотри начальные действия */

/* Вычисление значения специального поля kinv-o */
/* Смотри начальные действия */

/* Вычисление значения специального поля tot-b */
/* Смотри начальные действия */

/* Вычисление значения специального поля tot-o */
/* Смотри начальные действия */

/* Вычисление значения специального поля val-b */
/* Смотри начальные действия */

/* Вычисление значения специального поля val-o */
/* Смотри начальные действия */

/*-------------------- Формирование отчета --------------------*/
{strtout3.i &cols=83 &option=Paged}

put unformatted "Срок хранения   __________________________________________________" skip.
put unformatted " " skip.
put unformatted "Архивный индекс __________________________________________________" skip.
put unformatted " " skip.
put skip(1).
put unformatted "                 " Bank-name Format "x(50)"
                "" skip.
put skip(3).
put unformatted "Бухгалтерские документы за " dob Format "99/99/9999"
                "." skip.
put skip(3).
put unformatted "                                по балансовым счетам       по внебалансовым счетам" skip.
put skip(1).
put unformatted "Бухгалтерские документы" skip.
put unformatted " " skip.
put unformatted "на сумму                    " tot-b Format "->>>,>>>,>>>,>>9.99"
                "  руб.     " tot-o Format "->>>,>>>,>>>,>>9.99"
                "  руб." skip.
put skip(2).
put unformatted "Из них находится в отдельных папках:" skip.
put skip(1).
put unformatted "кассовые документы          " k-b Format "->>>,>>>,>>>,>>9.99"
                "  руб.     " k-o Format "->>>,>>>,>>>,>>9.99"
                "  руб." skip.
put skip(2).
put unformatted "    по операциям с иностранной валютой:" skip.
put skip(1).
put unformatted "бухгалтерские документы     " val-b Format "->>>,>>>,>>>,>>9.99"
                "  руб.     " val-o Format "->>>,>>>,>>>,>>9.99"
                "  руб." skip.
put skip(1).
put unformatted "     срок хранения  ____________" skip.
put unformatted " " skip.
put unformatted "кассовые документы          " kinv-b Format "->>>,>>>,>>>,>>9.99"
                "  руб.     " kinv-o Format "->>>,>>>,>>>,>>9.99"
                "  руб." skip.
put skip(1).
put unformatted "     срок хранения  ____________" skip.
put unformatted " " skip.
put skip(1).
put unformatted "    по операциям с драгоценными металлами:" skip.
put unformatted " " skip.
put unformatted "бухгалтерские документы     " drag-b Format "->>>,>>>,>>>,>>9.99"
                "  руб.     " drag-o Format "->>>,>>>,>>>,>>9.99"
                "  руб." skip.
put skip(1).
put unformatted "     срок хранения  ____________" skip.
put skip(1).
put unformatted "кассовые документы          " k-drag-b Format "->>>,>>>,>>>,>>9.99"
                "  руб.     " k-drag-o Format "->>>,>>>,>>>,>>9.99"
                "  руб." skip.
put skip(1).
put unformatted "     срок хранения  ____________" skip.
put unformatted " " skip.
put unformatted " " skip.
put skip(4).
put unformatted "Документы сброшюрованы и подшиты __________________" skip.
put unformatted "                                   (подпись)" skip.
put skip(2).
put unformatted "Исполнитель:  " Ispol Format "x(50)"
                "" skip.

{endout3.i &nofooter=yes}

