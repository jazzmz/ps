{pirsavelog.p}

/*
                ­ª®¢áª ï ¨­â¥£à¨à®¢ ­­ ï á¨áâ¥¬  ˆ‘ª¢¨â
    Copyright: (C) 1992-2004 ’ " ­ª®¢áª¨¥ ¨­ä®à¬ æ¨®­­ë¥ á¨áâ¥¬ë"
     Filename: ap-wear.p
      Comment: ‚¥¤®¬®áâì ¨§­®á  ®á­®¢­ëå áà¥¤áâ¢
   Parameters:
         Uses:
      Used by:
      Created: 30.03.1998 mkv
     Modified:
*/

&GLOBAL-DEFINE wear YES
&GLOBAL-DEFINE cols 199

{ap-sort.i}

PROCEDURE show:

   FORM WITH FRAME list WIDTH {&cols} DOWN NO-BOX NO-LABEL.

   PUT UNFORMATTED
      GetReportName("   ‚…„Œ‘’œ ˆ‡‘€") SKIP(1)
   " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" SKIP
   "    ˆ‚…’€›‰ Œ…   ³          €ˆŒ…‚€ˆ…          ³{&Col_Lbl_1}³               €Œ’ˆ‡€–ˆŸ             ³  „€’€  ³  …‚€—€‹œ€Ÿ   ³      ‹€Ÿ       ³  ‘“ŒŒ€ ˆ‡‘€ ‡€  ³     ‘’€’—€Ÿ     " SKIP
   "                        ³                                ³{&Col_Lbl_2}ÃÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´ ‘’“-³    ‘’ˆŒ‘’œ      ³   ‘“ŒŒ€ ˆ‡‘€    ³ ‘‹…„ˆ‰ Œ…‘Ÿ–   ³     ‘’ˆŒ‘’œ      " SKIP
   "                        ³                                ³            ³ Š„     ³      Œ€      ³‘Š ˆ‘‹.³ ‹…ˆŸ  ³                   ³                   ³                   ³                    " SKIP
   "                        ³                                ³            ³ Œ›   ³                 ³   (Œ…‘.)  ³        ³                   ³                   ³                   ³                    " SKIP
   " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" SKIP.

   FOR EACH af
      NO-LOCK
      USE-INDEX sort-value
      BREAK BY af.sort-value
      WITH FRAME list:

      ACCUMULATE
         af.disc   (TOTAL BY af.sort-value)
         af.rest   (TOTAL BY af.sort-value)
         af.rest-m (TOTAL BY af.sort-value)
         af.amor   (TOTAL BY af.sort-value).

      IF FIRST-OF(af.sort-value) THEN
         PUT UNFORMATTED SKIP(1) " "
            af.sort-value
         SKIP(1).

      DISPLAY
         " "
         af.inv-num
         af.name[1]
         GetSortVal() FORMAT "x({&SortColumnWidth})"
         af.misc[2]   FORMAT "x(9)"
         af.comm-rate
         af.rate-fixed
         af.GoodUse
         af.date-make
         af.disc
         af.amor
         af.rest-m
         af.rest
      WITH FRAME list.

      DOWN WITH FRAME list.
      
    DO mExt = 2 TO EXTENT(af.name):
         IF af.name[mExt] NE "" THEN DO:
            DISPLAY
               af.name[mExt] @ af.name[1]
            WITH FRAME list.
            DOWN WITH FRAME list.
         END.
      END.
      
      IF LAST-OF(af.sort-value) THEN
      DO:
         PUT UNFORMATTED " " FILL("_", {&cols}) SKIP.

         DISPLAY
            GetSubTitle()                           @ af.name[1]
            ACCUM TOTAL BY af.sort-value  af.rest-m @ af.rest-m
            ACCUM TOTAL BY af.sort-value  af.disc   @ af.disc
            ACCUM TOTAL BY af.sort-value  af.amor   @ af.amor
            ACCUM TOTAL BY af.sort-value  af.rest   @ af.rest
         WITH FRAME list.

         DOWN 2 WITH FRAME list.

         IF LAST(af.sort-value) THEN
         DO:
            PUT UNFORMATTED " " FILL("_", {&cols}) SKIP.

            DISPLAY
               "ˆâ®£® ¯® ¢¥¤®¬®áâ¨"  @ af.name[1]
               ACCUM TOTAL af.rest-m @ af.rest-m
               ACCUM TOTAL af.disc   @ af.disc
               ACCUM TOTAL af.amor   @ af.amor
               ACCUM TOTAL af.rest   @ af.rest
            WITH FRAME list.

            DOWN WITH FRAME list.
         END. /* LAST */
      END. /* LAST-OF */
   END. /* FOR EACH */

END PROCEDURE.