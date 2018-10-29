{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-ac.p,v $ $Revision: 1.2 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Базируется    : ac-uni.p
Причина       : Невозможность печати стандартными средствами длинных назначения платежа и списка документов.
              : При установке обновлений - компилировать
Назначение    : Печать аккредитива
Описание      : Используются стандартные процедуры извлечения данных ПП, вывод осуществляется через систему 
							: графической печати базирующуюся на bisPC
Параметры     : RECID документа
Место запуска : Печать документов
Автор         : $Author: anisimov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.1  2007/06/27 06:48:01  lavrinenko
Изменения     : процедура печати аккредитива
Изменения     :
------------------------------------------------------ */
Form "~n@(#) pt-uni.p 1.0 Kostik 02.03.2000 Kostik 02.03.2000 Универсальные п/т" with frame sccs-id width 250.

{globals.i}                                 /* глобальные переменные         */
{chkacces.i}
{prn-doc.def &with_proc}
{intrface.get xclass}

&SCOP TEST YES
&SCOP NEW_1256 YES

&GLOBAL-DEFINE OFFSIGNS YES
&IF "{&TEST}" EQ "YES" &THEN
   DEF STREAM test.
   OUTPUT STREAM test TO "test.pp".
&ENDIF

{pp-uni.var}                                /* определение переменных        */
{ac-uni.var}

{ac-uni.frm}                                /* определение фрейма            */

{pp-uni.err}                                /* сообщения об ошибках          */

{pp-uni.prg}                     /* описание стандартных процедур */



{pp-uni.chk}                                /* проверка входных данных       */

/* непосредственно расчет        */
RUN Collection-Info.
RUN GetDopParam.                /* Считывание дополнительных параметров      */
                                /* по инструкции 1256-У                      */
RUN RunAvailProc("Amt").        /* обработка суммы                           */
RUN RunAvailProc("Detail").     /* назначения платежа                        */
RUN RunAvailProc("Payer").      /* реквизиты плательщика                     */
RUN RunAvailProc("Recipient").  /* реквизиты получателя                      */
RUN RunAvailProc("Header").     /* заголовок, номер формы, дата, вид платежа */
RUN RunAvailProc("XattrVar").   /* д/р для акккредитивов                     */

&IF "{&TEST}" EQ "YES" &THEN
   OUTPUT STREAM test CLOSE.
&ENDIF


RUN Clear_TTName.
RUN Insert_TTName ("doc-num", op.doc-num).
RUN Insert_TTName ("theDate", theDate).
RUN Insert_TTName ("PayType", PayType).
RUN Insert_TTName ("AmtStr", AmtStr[1]).
RUN Insert_TTName ("Rub", Rub).
RUN Insert_TTName ("PlINN", PlINN).
RUN Insert_TTName ("PlLAcct", PlLAcct).
RUN Insert_TTName ("PlName", PlName[1]).
RUN Insert_TTName ("PlRKC", PlRKC[1]).
RUN Insert_TTName ("PlMFO", PlMFO).
RUN Insert_TTName ("PlCAcct", PlCAcct).

RUN Insert_TTName ("PoRKC", PoRKC[1]).
RUN Insert_TTName ("PoMFO", PoMFO).
RUN Insert_TTName ("PoCAcct", PoCAcct).
RUN Insert_TTName ("PoINN", PoINN).
RUN Insert_TTName ("PoName", PoName[1]).
RUN Insert_TTName ("PoAcct", PoAcct).

RUN Insert_TTName ("doc-type", IF AVAIL doc-type THEN doc-type.digital ELSE op.doc-type).
RUN Insert_TTName ("Due-Accredit", Due-Accredit).
RUN Insert_TTName ("accredit", accredit).
RUN Insert_TTName ("Cond-Pay", Cond-Pay).
RUN Insert_TTName ("Detail", Detail[1]).
RUN Insert_TTName ("mKindOfDoc", mKindOfDoc[1]).
RUN Insert_TTName ("mExtraCond", mExtraCond[1]).
RUN Insert_TTName ("mAcctOfRec", mAcctOfRec[1]).
RUN Insert_TTName ("mExtOp", mExtOp).

RUN printvd.p("pir0401063", INPUT TABLE ttnames).


PROCEDURE GetHeader:
   RUN DefHeader.
   ASSIGN
      NameOrder  = "АККРЕДИТИВ N"
      NumberForm = "0401063"
   .

END PROCEDURE.

PROCEDURE GetXattrVar:
   ASSIGN 
      mKindOfDoc[1] = GetXAttrValueEx("op", STRING(op.op), "ПоПредст", "")
      mExtraCond[1] = GetXAttrValueEx("op", STRING(op.op), "ДопУсл", "")
      mAcctOfRec    = GetXAttrValueEx("op", STRING(op.op), "СчетПолучателя", "")
      Cond-Pay      = GetXAttrValueEx("op", STRING(op.op), "УслОпл", "")
      accredit      = GetCodeName("ВидАккр", GetXAttrValueEx("op", STRING(op.op), "ВидАккр", ""))
      Due-Accredit  = GetXAttrValueEx("op", STRING(op.op), "СркАкц", "")
      accredit      = IF accredit EQ ? THEN "" ELSE accredit
   .
END PROCEDURE.