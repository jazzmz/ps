/*
   wordwrap.i

   �ॡ�� wordwrap.def

   ��������� ������� ��ப� {&s}[1] �� {&n} ��ப {&s}[i] ������ �� ����� {&l}
   �� �࠭�栬 ᫮�.
   �᫨ ��⠭����� ��ࠬ��� {&centered}, � 業����� ����祭�� ��ப�.
   ���樠��� ᨬ��� &d (�� 㬮�砭�� "|") � ��ப� {&s}[1] ��뢠��
   ����᫮��� ��ॢ�� ��ப�.
   (���) 㤠��� ��७�� ��ப� �� ��宦����� ����⮩.

   Modified: 04/01/98 serge - "~n" processing: replaced by "|"
*/
&IF DEFINED(d) eq 0 &THEN
   &SCOPED-DEFINE d "|"
&ENDIF

wws = REPLACE({&s}[1] + " ","~n",{&d}).

DO wwi = 1 TO {&n}:

   IF INDEX(SUBSTRING(wws, 1, {&l} + 1), {&d}) NE 0 THEN
      ASSIGN
         {&s}[wwi] = SUBSTRING(wws, 1, INDEX(wws, {&d}) - 1)
         wws       = SUBSTRING(wws, INDEX(wws, {&d}) + 1).
   ELSE
      ASSIGN
         wwj       = R-INDEX(SUBSTRING(wws, 1, {&l} + 1), " ") 
                     /*           wordwrap comma-separated lists properly */
         wwj       = (IF wwj > 0 THEN wwj ELSE {&l})
         {&s}[wwi] = IF wwi EQ {&n} THEN wws ELSE SUBSTRING(wws, 1, wwj)
                     /* ^^^^^^^^^^^              don't truncate last line */
         wws       = SUBSTRING(wws, wwj + 1)
      .
&IF DEFINED(tail) NE 0 &THEN
         IF wwi EQ 1 THEN
            {&tail} = wws.
&ENDIF

   {ifndef {&notrim}}
      {&s}[wwi] = TRIM({&s}[wwi]).
   {endif} */

   {ifdef {&centered}}
      {&s}[wwi] = FILL(" ",INT64( ({&l} - LENGTH({&s}[wwi])) / 2)) + {&s}[wwi].
   {endif} */

   &IF DEFINED(LEFT_AND_RIGHT) NE 0 &THEN

   IF LENGTH(TRIM(wws)) NE 0 THEN
   DO:  /* ��ࠢ������ �ࠢ�� �࠭��� */
      mWordWrapIndex = {&l}.

      DO WHILE LENGTH({&s}[wwi]) LT {&l} AND INDEX({&s}[wwi], " ") GT 0:
         mWordWrapI = R-INDEX({&s}[wwi], " ", mWordWrapIndex).

         IF mWordWrapI EQ 0 THEN
            ASSIGN
               mWordWrapIndex = {&l}
               mWordWrapI     = R-INDEX({&s}[wwi], " ", mWordWrapIndex)
            .
            
         mWordWrapIndex = LENGTH(TRIM(SUBSTRING({&s}[wwi], 1, mWordWrapI))) - 1.
         {&s}[wwi] = SUBSTRING({&s}[wwi], 1, mWordWrapI) + SUBSTRING({&s}[wwi], mWordWrapI).
         
      END.
   END.
   &ENDIF
END.
