/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2006 ТОО "Банковские информационные системы"
     Filename: pctra-brw.p
      Comment: Суммы транзакций
   Parameters:
         Uses:
      Used by:
      Created: 06.10.2006 18:49 MIOA     (0068298)
     Modified: 18.11.2006 18:43 OZMI     (0068806)
     Modified: 10.09.2007 18:43 JADV     (0080885)
     Modified by PIR: 11.05.2010 17:16 Buryagin
                      Добавлен макрос &delete в определении запроса.
*/

{globals.i}
{flt-file.i}
{intrface.get rights}

&GLOBAL-DEFINE BIS-TTY-EF YES

/* Переменные форм */
DEFINE VAR vContTime AS CHAR NO-UNDO.
DEFINE VAR vFIO      AS CHAR NO-UNDO.
DEFINE VAR vFirm     AS CHAR NO-UNDO.
DEFINE VAR vCardLoan AS CHAR NO-UNDO.
DEFINE VAR vEqLoan   AS CHAR NO-UNDO.
DEFINE VAR vClName   AS CHAR NO-UNDO EXTENT 3.
DEFINE VAR mBTESurr  AS CHAR NO-UNDO.
DEFINE VAR mParamLst AS CHAR NO-UNDO.
DEFINE VAR mHField   AS HANDLE NO-UNDO.
/* Для nav-файла */
DEFINE VAR vSurr     AS CHAR NO-UNDO.
DEFINE VAR vCh       AS CHAR NO-UNDO.

/* Форма 1 */
FORM
   pc-trans-amt.amt-code  FORMAT "x(12)"               COLUMN-LABEL "РОЛЬ"        HELP "Роль суммы в транзакции"
   pc-trans-amt.currency  FORMAT "x(3)"                COLUMN-LABEL "ВАЛ"         HELP "Валюта транзакции"
   pc-trans-amt.amt-cur   FORMAT "->>>,>>>,>>>,>>9.99" COLUMN-LABEL "СУММА"       HELP "Сумма"
   pc-trans-amt.cont-date FORMAT "99/99/9999"          COLUMN-LABEL "СПИСАНО"     HELP "Дата выполнения транзакции"
   pc-trans-amt.proc-date FORMAT "99/99/9999"          COLUMN-LABEL "ОБРАБОТАНО"  HELP "Дата обработки транзакции"
   WITH FRAME browse1 TITLE COLOR bright-white "[ СУММЫ ТРАНЗАКЦИИ ]". 

mParamLst = GetFltVal("pctr-id").

{qrdef.i
  &buff-list        = "pc-trans-amt"
  &need-buff-list   = "pc-trans-amt" 
  &Join-list        = "EACH"
  &SortBy           = "'BY pc-trans-amt.amt-code '"
}
    
{navigate.cqr
  &file             = "pc-trans-amt"
  &avfile           = "pc-trans-amt" 
  &files            = "pc-trans-amt" 
  
  &filt             = "YES"
  &tmprecid         = "YES"
  
  &maxfrm           = 1
  &bf1              = "pc-trans-amt.amt-code pc-trans-amt.currency pc-trans-amt.amt-cur pc-trans-amt.cont-date pc-trans-amt.proc-date"  
  
  &oh2              = "│F2 операции"
  &oth2             = "pctra.mnu "

  &oh6              = "│F6 фильтр"
  &oth6             = "flt-file.f6 "

  &altlook          = "pctra-brw.nav "
  &look             = "bis-tty.nav "
  &edit             = "bis-tty.ef "
  &delete           = "pir-pctra-brw.del "
}    

{intrface.del}
