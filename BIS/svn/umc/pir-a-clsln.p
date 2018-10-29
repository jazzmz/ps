/*
       Created:     28/03/2006 vteb
   Description: ��㯯���� �����⨥ ����祪
     Copyright: (C) 1992-2006 ��� "������᪨� ���ଠ樮��� ��⥬�"
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
      &DateLabel = "��� �������"
      &DateHelp  = "������ ���� ������� ����祪"
      &return    = " LEAVE MAIN "
   }

   mClsDate = end-date.

   IF NOT CAN-FIND(FIRST tmprecid)
   THEN DO:
      MESSAGE "�� �⬥祭� ��� ������� �� ���� ����窠 ���!"
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      LEAVE MAIN.
   END.                            

   IF NOT CAN-DO("��,���,���,�����", work-module)
   THEN DO:
      MESSAGE "��㯯���� �����⨥ ����祪 ����� �믮������� ⮫쪮 � ���㫥 ���"
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
     /* �஢�ઠ ���������� ������� ����窨 */
    rest = 1. 
    qty = 1.
  run GetAmtUMC(loan.contract,
                      loan.cont-code,
                      mClsDate,OUTPUT rest, OUTPUT qty).


      IF loan.close-date <> ? THEN
      DO:
         PUT STREAM o-err
            "����窠 " loan.contract "���.� [" loan.doc-ref "] 㦥 ������ "
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
            "����窠 " loan.contract "���.� [" loan.doc-ref "] �� ����� ���� ������"
            SKIP.
         v-err = YES.
      END.
   END.
   IF NOT v-err THEN
      PUT STREAM o-err "�� ����窨 �ᯥ譮 �������" SKIP.
   {preview.i
      &stream = "STREAM o-err"
   }
END.

{intrface.del}

