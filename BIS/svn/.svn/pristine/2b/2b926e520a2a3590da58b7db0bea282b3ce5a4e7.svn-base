{globals.i}
{tmprecid.def}
{intrface.get xclass}
{intrface.get tmess}
{intrface.get strng}



DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

def var mUIP as char no-undo.
def var mEIP as char no-undo.
def var mKPP as char no-undo.
def var mINN as char no-undo.


def var count as int init 0 no-undo.

{init-bar.i "Обработка Документов"}

for each tmprecid, first op where RECID(op) = tmprecid.id NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.



for each tmprecid,
         first op where RECID(op) = tmprecid.id NO-LOCK,
         first op-entry of op NO-LOCK.

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }
          mEIP = ?.
          mUIP = ?.

          find first acct where acct.acct = op-entry.acct-db NO-LOCK NO-ERROR.

          if acct.cust-cat = "Ю" then do:          /*на данный момент процедура работает только по юр.лицам*/
          count = count + 1.
          find first cust-corp where cust-corp.cust-id = acct.cust-id  NO-LOCK NO-ERROR.
          if available cust-corp then do:

            IF cust-corp.country-id EQ "RUS" OR NOT {assigned cust-corp.country-id} THEN 
            mEIP = "2".
            ELSE mEIP = "3".
             mINN = cust-corp.inn.
             mKPP = GetXattrValue("cust-corp",STRING(cust-corp.cust-id),"КПП").

            if mInn = "" or mInn = ? then 
                DO:
		count = count - 1.
		message "Для клиента " cust-corp.name-short "не задан ИНН" SKIP "Документы клиента не обрабатываются" VIEW-AS ALERT-BOX.
		END.

            if mEIP <> "3" and (mKPP = "" or mKPP = ?) then 
	        DO:
		count = count - 1.
		message "Для клиента " cust-corp.name-short "не задан КПП" SKIP "Документы клиента не обрабатываются" VIEW-AS ALERT-BOX.
		END.
             IF {assigned mEIP} AND {assigned mINN} AND {assigned mKPP} THEN
             mEIP = mEIP + mINN + mKPP.
             ELSE mEIP = "".


              mUIP = "1" + STRING(INT64(FGetSetting("БанкМФО","","")),"999999999") +
                      FStrPadC(GetXattrValue("_user",op.user-id,"Отделение"),6,NO,"0") + 
                      SUBSTRING(STRING(YEAR(op.op-date)),3) + STRING(MONTH(op.op-date),"99") + STRING(DAY(op.op-date),"99") +
                      STRING(op.op,"9999999999") NO-ERROR.
                      UpdateSigns ("op", STRING(op.op), "ЕИП",         mEIP,          NO).
                      UpdateSigns ("op", STRING(op.op), "УИП",         mUIP,          NO).
                      UpdateSigns ("op", STRING(op.op), "УИН",          "0", NO).
                      UpdateSigns ("op", STRING(op.op), "УИЗ",          "0", NO).


          end.
          else message "Не найдены данные юрлица для документа op.op = " op.op VIEW-AS ALERT-BOX. 
          end.
		
          vLnCountInt = vLnCountInt + 1.
   

end.

MESSAGE "Успешно обработано " count " документов!" VIEW-AS ALERT-BOX.

{intrface.del}

