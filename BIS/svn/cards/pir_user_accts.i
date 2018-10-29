/* pir_show_user_accts.p 
(����� ��������) �����뢠�� �ࠢ� �� ���.��� ���짮��⥫� 
�� dop-acct,�/�,������℁,������⊐
������ ���.��� � 㤠��� ��ॢ��� ��ப
*/

DEF VAR STR_LENGTH AS INT NO-UNDO INIT 78.

DEF VAR drCode  AS CHAR NO-UNDO INIT "dop-acct,�/�,������℁,������⊐".
DEF VAR drNames AS CHAR NO-UNDO INIT "���᮪ ���.��⮢ ��� ��ᬮ��,���᮪ �/�, ����㯭�� ��� ���. ����.,��� �����㥬�,��� �।��㥬�".

{pirsavelog.p}
{globals.i}
{intrface.get xclass}

DEFINE TEMP-TABLE TmpSortAcct NO-UNDO
   FIELD acct       AS CHAR
   INDEX acct	acct 
.

/* �������� � ᯨ�� ����, �᫨ ��� �� ��室�� �� CAN-DO � ������ ᯨ᮪ ��᮪ */
FUNCTION Add2SortCanDo RETURNS CHARACTER
   (  INPUT pAcctsCanDo AS CHARACTER	/* ᯨ᮪ ��᮪ ��⮢ 		 */
    , INPUT pAcct2Add 	AS CHARACTER	/* ᯨ᮪ ��᮪ ������塞�� ��� */
) :
  /* ��⨬ ⠡���� */
  FOR EACH TmpSortAcct:
    DELETE TmpSortAcct.
  END.
  pAcctsCanDo = REPLACE(pAcctsCanDo, "#tab", "").
  pAcctsCanDo = REPLACE(pAcctsCanDo, "#cr" , "").
  pAcctsCanDo = REPLACE(pAcctsCanDo, " "   , "").

  /* ��室�� �� �ᥬ� ᯨ�� ��᮪ � ᪨�뢠�� �� �६����� ⠡���� ��� ���஢�� */
  DEF VAR k       AS INTEGER NO-UNDO.
  DO k = 1 TO NUM-ENTRIES(pAcctsCanDo) :
    DEF VAR  cAcctCanDo AS CHAR NO-UNDO.
    cAcctCanDo = ENTRY(k, pAcctsCanDo).
    /* ��� ⠪��� ��� �� ��᪥ */
/*  IF NOT CAN-DO(cAcctCanDo, ...) THEN DO: */
      CREATE TmpSortAcct.
      TmpSortAcct.acct = cAcctCanDo.
/*  END. */
  END.  

  DO k = 1 TO NUM-ENTRIES(pAcct2Add) :
    /* ������塞 ����� ����, �᫨ �� ��� */
    IF NOT CAN-DO(cAcctCanDo, ENTRY(k, pAcct2Add)) THEN DO:
      CREATE TmpSortAcct.
      TmpSortAcct.acct = ENTRY(k, pAcct2Add).
    END.
  END.  

  /* ��室�� �� �����஢����� ⠡��� � ����砥� �����஢���� ᯨ᮪ */
  DEF VAR cAcctsList AS CHAR NO-UNDO.
  cAcctsList = "".
  FOR EACH TmpSortAcct:
    cAcctsList = cAcctsList + ',' + TmpSortAcct.acct.
  END.

  IF LENGTH (cAcctsList) > 1	/* 㤠�塞 ����� ������� */
    THEN cAcctsList = SUBSTR(cAcctsList, 2).
  RETURN cAcctsList.
END. /* FUNCTION Add2SortCanDo */

/* �������� � ᯨ�� ����, �᫨ ��� �� ��室�� �� CAN-DO � ������ ᯨ᮪ ��᮪ */
FUNCTION CountColAccts RETURNS INTEGER
   (  INPUT pAcctsCanDo AS CHARACTER	/* ᯨ᮪ ��᮪ ��⮢ 	*/
) :
  DEF VAR vColAccts AS INT NO-UNDO.
  SELECT COUNT(*) INTO vColAccts
    FROM acct
    WHERE CAN-DO(pAcctsCanDo, acct.acct).
  RETURN vColAccts.
END. /* FUNCTION CountColAccts */

/* ࠧ������ �� ��ப�� ������ �� STR_LENGTH ᨬ����� */
PROCEDURE ShowAcctsByLength.
  DEF INPUT PARAM pdrOldValue AS CHARACTER.
  DEF INPUT PARAM pSTR_LENGTH AS INT.
  DO WHILE     LENGTH(pdrOldValue) > pSTR_LENGTH /* ��ப� ������� 祬 ������ �� �࠭ */
         AND R-INDEX(pdrOldValue, ',') > 0	 /* � ���� ����������� ࠧ������ */
  :
    DEF VAR dr AS CHAR NO-UNDO.
    dr = SUBSTR(pdrOldValue, 1, pSTR_LENGTH).
    dr = SUBSTR(dr, 1, R-INDEX(dr, ',')).

    pdrOldValue = REPLACE (pdrOldValue, dr, "").

    PUT UNFORMATTED dr SKIP.
  END.
  
  PUT UNFORMATTED pdrOldValue SKIP.
END. /* PROCEDURE CountColAccts. */
