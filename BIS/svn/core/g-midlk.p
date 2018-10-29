/*
                Банковская интегрированная система БИСквит
    Copyright:  (C) 1992-1996 ТОО "Банковские информационные системы"
     Filename:  g-midlk.p
      Comment:  Ввод документов перевода с картотеки1 на картотеку2 (по крайней мере изначально так)
         Uses:  -
      Created: 30/04/2002 kraw
     Modified: 28/02/2003 kolal Копирование реквизита "ВидОп". Заявка 10552.
*/

&glob DoBeforeAfterSet RUN g-midlk_DoBeforeAfterSet. if is-undo-cycle then undo cycle, leave cycle.
&glob g-midlk-file yes.

{intrface.get blkob}

def new shared var hist-rec-acct as recid initial ? no-undo.
   
def variable vAcct as character  no-undo.
def var pers-handle as handle.
def var parssen-library-proc as handle no-undo.
def var is-undo-cycle as log init no no-undo.
   
/**********************************
 * Кооректировка содержания
 * внебалансового документа.
 **********************************
 * Автор: Маслов Д.А. (Maslov D.A.)
 * Дата создания: 30.12.2010
 * Заявка: #538
 *
 *********************************/

  DEF VAR NEW-VN-DOC  AS INT NO-UNDO.
  DEF VAR NEW-BAL-DOC AS INT NO-UNDO.

/********* КОНЕЦ #538 ************/
   
/* вызываем новую библиотеку для парсера */
run kaufun.p persistent set parssen-library-proc NO-ERROR.

if error-status:error then do:
   return error.
end.

{g-midl1.p
    &no-frame-disp = "/*"
    &post-kau="run g-midlk_post-kau. "
}

if valid-handle(parssen-library-proc)
    then delete procedure parssen-library-proc.

{kautools.lib &Noacctread=yes &user-rights=yes}

procedure g-midlk_DoBeforeAfterSet:
   def var rid as recid no-undo.
   DEFINE VARIABLE bAcct     AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE oAcct     AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE oCurrency AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vAcctStat AS CHARACTER   NO-UNDO.
   DEFINE VAR      vOpBal    AS CHAR        NO-UNDO.
   DEFINE BUFFER xop FOR op.
   run SelectKau(buffer op-kind, output rid).

   IF rid EQ ? OR rid EQ 0 THEN rid = INT64(GetSysConf("kau_rec")) NO-ERROR.

   if rid <> ? then do:
      find first kau where recid(kau) = rid no-lock no-error.

      if avail(kau) then do:

         IF kau.kau-id EQ "Карт-ка1" THEN DO:

            run fnd_acct_op(INPUT kau.kau, 
                            OUTPUT bAcct, 
                            OUTPUT oAcct, 
                            OUTPUT oCurrency).
            IF {assigned bAcct} THEN
            vAcctStat = BlockAcct(bAcct + "," + oCurrency,
                                  IF in-op-date EQ TODAY THEN DATETIME(TODAY,MTIME) 
                                  ELSE DATETIME(in-op-date + 1) - 1).
            IF vAcctStat MATCHES "Блок*" THEN DO:
               RUN Fill-SysMes("","","-1","Счет " + DelFilFromAcct(bAcct) + " заблокирован. Перенос с картотеки 1 на картотеку 2 невозможен.").
          
               is-undo-cycle = yes.
            END.
         END.

         vOpBal = GetXAttrValue("op", entry(1, kau.kau), "op-bal").
         IF {assigned vOpBal} THEN
            FIND xop WHERE xop.op EQ INT64(vOpBal) NO-LOCK NO-ERROR.
         ELSE IF AVAIL(op) THEN
            FIND FIRST xop WHERE xop.op-transaction EQ op.op-transaction
                             AND xop.acct-cat       EQ "b" NO-LOCK NO-ERROR.
         IF AVAIL(xop) THEN DO:
            RUN SetSysConf IN h_base ("БАЛ-ДОК:DOC-NUM",xop.doc-num).
            RUN SetSysConf in h_base ("БАЛ-ДОК:DETAILS", xop.details).
            RUN SetSysConf in h_base ("БАЛ-ДОК:DOC-DATE" , STRING(xop.doc-date)).
            FIND FIRST doc-type WHERE doc-type.doc-type EQ xop.doc-type NO-LOCK NO-ERROR.
            RUN SetSysConf in h_base ("БАЛ-ДОК:НАИМ-ТИП-ДОК", IF AVAIL(doc-type) THEN doc-type.name-doc ELSE ""). 
         END.
         IF AVAIL(op) THEN DO:
            RUN SetSysConf in h_base ("БАЛ-ДОК:AMT-RUB", GetXattrValue("op",STRING(xop.op),"amt-rub")).
            RUN SetSysConf in h_base ("БАЛ-ДОК:AMT-CUR", GetXattrValue("op",STRING(xop.op),"amt-cur")).
         END.

         run setKauDocSysConf(op.op-kind, recid(op-entry), recid(kau)).
         run sRidOE in parssen-library-proc (recid(kau)).
      end.
   end.
   else is-undo-cycle = yes.
end.

RUN DeleteOldDataProtocol IN h_base("БАЛ-ДОК:DOC-NUM").
RUN DeleteOldDataProtocol IN h_base("БАЛ-ДОК:DETAILS").
RUN DeleteOldDataProtocol IN h_base("БАЛ-ДОК:DOC-DATE").
RUN DeleteOldDataProtocol IN h_base("БАЛ-ДОК:НАИМ-ТИП-ДОК"). 
RUN DeleteOldDataProtocol IN h_base("БАЛ-ДОК:AMT-RUB").
RUN DeleteOldDataProtocol IN h_base("БАЛ-ДОК:AMT-CUR").

{intrface.del}          /* Выгрузка инструментария. */ 

procedure g-midlk_post-kau:
   run getKauDocSysConf(op.op-kind, buffer op-entry, buffer kau).

   if avail(kau) then do:
      UpdateSigns("op", string(op.op), "op-bal", GetXAttrValue("op", entry(1, kau.kau), "op-bal"), ?).
      UpdateSigns("op", string(op.op), "ВидОп", GetXAttrValue("op", entry(1, kau.kau), "ВидОп"), ?).

/**********************************
 * Кооректировка содержания
 * внебалансового документа.
 **********************************
 * Автор: Маслов Д.А. (Maslov D.A.)
 * Дата создания: 30.12.2010
 * Заявка: #538
 *
 *********************************/

      NEW-VN-DOC = op.op.
      NEW-BAL-DOC = INTEGER(GetXAttrValue("op", entry(1, kau.kau), "op-bal")).

/********* КОНЕЦ #538 ************/
   end.
end.

/**********************************
 * Кооректировка содержания
 * внебалансового документа.
 **********************************
 * Автор: Маслов Д.А. (Maslov D.A.)
 * Дата создания: 30.12.2010
 * Заявка: #538
 *
 *********************************/

FUNCTION lastPrep RETURNS LOGICAL():
    DEF BUFFER newBalOp FOR op.
    DEF BUFFER newVnOp  FOR op.
    DEF VAR oClient AS TClient NO-UNDO.

    FIND FIRST newVnOp WHERE newVnOp.op = NEW-VN-DOC.

    FIND FIRST newBalOp WHERE newBalOp.op = NEW-BAL-DOC.

     oClient = new TClient(GetXAttrValue("op", STRING(newBalOp.op), "acctbal")).

     ASSIGN 
	newVnOp.details = newVnOp.detail + " #DOCTYPE# N " + newBalOp.doc-num + " от " + STRING(newBalOp.doc-date) + " " + oClient:name-short + " по счету " + GetXAttrValue("op", STRING(newBalOp.op), "acctbal") + "."
     .

     /*** Добавляем тип исходного документа ***/


                     CASE newVnOp.doc-type:
                          WHEN "01" THEN DO:
                            newVnOp.details = REPLACE(newVnOp.details,"#DOCTYPE#","п/п").
                            newVnOp.details = REPLACE(newVnOp.details,"#ACTION#","Списано").
                          END.
                          WHEN "02" THEN DO:
                            newVnOp.details = REPLACE(newVnOp.details,"#DOCTYPE#","п/т").
                            newVnOp.details = REPLACE(newVnOp.details,"#ACTION#","Списано").
                          END.
                          WHEN "015" THEN DO:
                            newVnOp.details = REPLACE(newVnOp.details,"#DOCTYPE#","и/п").
                            newVnOp.details = REPLACE(newVnOp.details,"#ACTION#","Списано").
                          END.
                          WHEN "016" THEN DO:
                            newVnOp.details = REPLACE(newVnOp.details,"#DOCTYPE#","п/о").
                            newVnOp.details = REPLACE(newVnOp.details,"#ACTION#","Списано").
                          END.

                          WHEN "17" THEN DO:
                            newVnOp.details = REPLACE(newVnOp.details,"#DOCTYPE#","б/о").
                            newVnOp.details = REPLACE(newVnOp.details,"#ACTION#","Списано").
                          END.

                          OTHERWISE DO:
                            newVnOp.details = REPLACE(newVnOp.details,"#DOCTYPE#","и/п").
                            newVnOp.details = REPLACE(newVnOp.details,"#ACTION#","Частично списано").
                          END.
                     END.
     

    DELETE OBJECT oClient.
    return true.
END.
lastPrep().

/********* КОНЕЦ #538 ************/
