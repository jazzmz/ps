CLASS TDTDiag:
      /****************************
       *                          *
       * Класс отображает диалог  *
       * для ввода даты-времени   *
       *                          *
       ****************************/
     
/*
CONSTRUCTOR TDTDiag():
DEF VAR dDate AS DATETIME NO-UNDO.
dDate = DATETIME("13-12-2009 16:15:00").

END.
*/

CONSTRUCTOR TDTDiag():
    DEFINE VARIABLE fibegDay AS CHARACTER FORMAT "x(2)".
    DEFINE VARIABLE fibegMonth AS CHARACTER FORMAT "x(2)".
    DEFINE VARIABLE fibegYear AS CHARACTER FORMAT "x(4)".                
  

    DEFINE FRAME fDiag
                 fibegDay NO-LABEL VIEW-AS FILL-IN "." fibegMonth NO-LABEL "." fibegYear NO-LABEL
                .
                fibegDay:SENSITIVE=TRUE.
    ENABLE ALL WITH FRAME fDiag.
    DISPLAY WITH FRAME fDiag.
END.
           

END CLASS.