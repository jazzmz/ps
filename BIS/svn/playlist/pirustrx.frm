FORM
   CODE.CODE
      FORMAT "X(20)"
      VIEW-AS FILL-IN SIZE 60 BY 1
   CODE.NAME
      VIEW-AS FILL-IN SIZE 60 BY 1
   CODE.val             
      FORMAT "x(600)"  
      VIEW-AS FILL-IN  SIZE 60 BY 1
   CODE.DESCRIPTION[2]
      LABEL "Параметры"
      VIEW-AS EDITOR SIZE 60 BY 2
   CODE.MISC[1]  
      LABEL "Исполнитель" 
      VIEW-AS EDITOR SIZE 60 BY 1
   CODE.MISC[2]
      VIEW-AS EDITOR SIZE 60 BY 1
      LABEL "Старт"
   CODE.MISC[3]
      VIEW-AS EDITOR SIZE 60 BY 1
      LABEL "Финиш"
   CODE.MISC[4]
      VIEW-AS EDITOR SIZE 60 BY 1
      LABEL "Откатил"
   CODE.MISC[5]
      VIEW-AS EDITOR SIZE 60 BY 1
      LABEL "Старт"
   CODE.MISC[6]
      VIEW-AS EDITOR SIZE 60 BY 1
      LABEL "Финиш"
   CODE.MISC[7]
      VIEW-AS EDITOR SIZE 60 BY 1
      LABEL "Транз.ID(для УТ)"
WITH FRAME edit TITLE COLOR bright-white "".

/**
ON ' ':U OF CODE.misc[5] IN FRAME edit 
DO:
   IF CODE.misc[5] = "" 
   THEN CODE.misc[5] = "ДА".
   ELSE CODE.misc[5] = "".
   DISPLAY 
      CODE.misc[5] 
   WITH FRAME edit. 
   RETURN NO-APPLY.
END.

ON ANY-PRINTABLE OF CODE.misc[5] IN FRAME edit 
DO:
   RETURN NO-APPLY.
END.
*/