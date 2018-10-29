/*
       Created:     28/03/2006 vteb
   Description: Групповое закрытие карточек
     Copyright: (C) 1992-2006 ТОО "Банковские информационные системы"
      Filename: a-clsln.p
       Comment: <comment>
    Parameters:
          Uses: a-br(ln).p
       Used by:

	 Last change:
*/

{globals.i}
{intrface.get umc}

DEFINE VARIABLE v-err    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE tmp-chr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE mClsDate AS DATE      NO-UNDO.

def var rest as dec no-undo.
def var qty  as dec no-undo.

{tmprecid.def}



DEF STREAM o-err.

MAIN:
DO ON ERROR UNDO MAIN, LEAVE MAIN:
   {getdate.i
      &DateLabel = "Дата закрытия"
      &DateHelp  = "Введите дату закрытия карточек"
      &return    = " LEAVE MAIN "
   }

   mClsDate = end-date.

   IF NOT CAN-FIND(FIRST tmprecid)
   THEN DO:
      MESSAGE "Не отмечена для закрытия ни одна карточка УМЦ!"
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      LEAVE MAIN.
   END.                            

   IF NOT CAN-DO("ОС,НМА,МБП,СКЛАД", work-module)
   THEN DO:
      MESSAGE "Групповое закрытие карточек может выполняться только в модуле УМЦ"
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      LEAVE MAIN.
   END.
   {setdest.i
      &cols   = 150
      &stream = "STREAM o-err"
   }
   v-err = NO.
   FOR EACH tmprecid,
      FIRST loan WHERE RECID(loan) = tmprecid.id:
     /* Проверка возможности закрытия карточки */
    rest = 1. 
    qty = 1.
  run GetAmtUMC(loan.contract,
                      loan.cont-code,
                      mClsDate,OUTPUT rest, OUTPUT qty).


      IF loan.close-date <> ? THEN
      DO:
         PUT STREAM o-err
            "Карточка " loan.contract "Инв.№ [" loan.doc-ref "] уже закрыта "
            STRING(loan.close-date) SKIP.
         v-err = YES.
         DELETE tmprecid.
      END.

      ELSE

      IF rest = 0 and qty = 0 THEN
      DO:
         ASSIGN loan.close-date = mClsDate.
         DELETE tmprecid.
      END.

      ELSE
      DO:
         PUT STREAM o-err
            "Карточка " loan.contract "Инв.№ [" loan.doc-ref "] не может быть закрыта"
            SKIP.
         v-err = YES.
      END.
   END.
   IF NOT v-err THEN
      PUT STREAM o-err "Все карточки успешно закрыты" SKIP.
   {preview.i
      &stream = "STREAM o-err"
   }
END.

{intrface.del}

