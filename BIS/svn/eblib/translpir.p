/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2005 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: Translmaster.p
      Comment: #0043406 ��楤�� �࠭᫨��樨.
   Parameters: inParType - �����ࠬ���
               inString  - ��ப���ࠬ���  
               inTList   - ��ࠢ�筨��࠭᫨��樨
               outString - ��室��� ��ப�
               
         Uses: translit.p
      Used by: pers.nau
      Created: 04.07.2006 Botu 0064141
     Modified: 
*/
DEFINE INPUT  PARAMETER inParType AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER inString  AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER inTList   AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER outString AS CHAR    NO-UNDO.


{globals.i}
{intrface.get xclass}
{translit.fun}

DEFINE VAR vi AS INTEGER NO-UNDO.

/******************************************************************************/
IF inTList = "" THEN inTList = FGetSettingEx("�࠭᫨����", "�࠭᫨⏮�����", "", YES).
  
CASE inParType:
   WHEN 3 THEN DO:
      outString = translit(inTList, ENTRY(1, ENTRY(2, inString), " ")) + 
                  " " + translit(inTList, ENTRY(1, inString)). 
   END.
   WHEN 2 THEN 
      outString = (IF inString = "yes" THEN "MR." ELSE "MRS.").
   OTHERWISE 
      outString = translit(inTList, inString).
END CASE.
