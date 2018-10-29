{pirsavelog.p}

/*
                ­ª®¢áª ï ¨­â¥£à¨à®¢ ­­ ï á¨áâ¥¬  ˆ‘ª¢¨â
    Copyright: (C) 1992-2004 ’ " ­ª®¢áª¨¥ ¨­ä®à¬ æ¨®­­ë¥ á¨áâ¥¬ë"
     Filename: ap-amort.p
      Comment: ‚…„Œ‘’œ €—ˆ‘‹…ˆŸ €Œ’ˆ‡€–ˆˆ
   Parameters:
         Uses:
      Used by:
      Created: 30.03.1998 mkv
     Modified: 17.03.2004 fedm
*/

&GLOBAL-DEFINE amort YES
&GLOBAL-DEFINE cols  130

{ap-sort.i}

PROCEDURE show:

   FORM WITH FRAME list WIDTH {&cols} DOWN NO-BOX NO-LABEL.

   PUT UNFORMATTED
      GetReportName("   ‚…„Œ‘’œ €—ˆ‘‹…ˆŸ €Œ’ˆ‡€–ˆˆ") SKIP(1)
   " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" SKIP
   "    ˆ‚…’€›‰ Œ…   ³          €ˆŒ…‚€ˆ…          ³{&Col_Lbl_1}³   …‚€—€‹œ€Ÿ  ³    ‘“ŒŒ€ ˆ‡‘€   ³    ‘’€’—€Ÿ      " SKIP
   "                        ³                                ³{&Col_Lbl_2}³      ‘’ˆŒ‘’œ    ³                   ³    ‘’ˆŒ‘’œ       " SKIP
   " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" SKIP.

   FOR EACH af
      NO-LOCK
      USE-INDEX sort-value
      BREAK BY af.sort-value
      WITH FRAME list:

      ACCUMULATE
         af.disc (TOTAL BY af.sort-value)
         af.rest (TOTAL BY af.sort-value)
         af.amor (TOTAL BY af.sort-value).

      IF FIRST-OF(af.sort-value) THEN
         PUT UNFORMATTED SKIP(1) " "
            af.sort-value
         SKIP(1).

      DISPLAY
         " "
         af.inv-num
         af.name[1]
         GetSortVal() FORMAT "x({&SortColumnWidth})"
         af.disc
         af.amor
         af.rest
      WITH FRAME list.

      DOWN WITH FRAME list.

      IF LAST-OF(af.sort-value) THEN
      DO:
         PUT UNFORMATTED " " FILL("_", {&cols}) SKIP.

         DISPLAY
            GetSubTitle()                           @ af.name[1]
            ACCUM TOTAL BY af.sort-value  af.disc   @ af.disc
            ACCUM TOTAL BY af.sort-value  af.rest   @ af.rest
            ACCUM TOTAL BY af.sort-value  af.amor   @ af.amor
         WITH FRAME list.

         DOWN 2 WITH FRAME list.

         IF LAST(af.sort-value) THEN
         DO:
            PUT UNFORMATTED " " FILL("_", {&cols}) SKIP.

            DISPLAY
               "ˆâ®£® ¯® ¢¥¤®¬®áâ¨"  @ af.name[1]
               ACCUM TOTAL af.disc   @ af.disc
               ACCUM TOTAL af.rest   @ af.rest
               ACCUM TOTAL af.amor   @ af.amor
            WITH FRAME list.

            DOWN WITH FRAME list.
         END. /* LAST   */
      END. /* LAST-OF */
   END. /* FOR EACH */
END PROCEDURE.