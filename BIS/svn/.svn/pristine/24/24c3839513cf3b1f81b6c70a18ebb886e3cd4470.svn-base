{capsif.i}
{get-bankname.i}
name-bank = cBankname.
   def var db-rub    as char form "x" no-undo.
   def var cr-rub    as char form "x" no-undo.
   def var doubl-chr as char no-undo.
   def var str       as char form "x(60)" no-undo.

   if doubl-v1
   then doubl-chr = trim(ts.name-vip) + " - „“‹ˆŠ€’".
   else doubl-chr = string(" ","x(3)") + "‚›ˆ‘Š€  ‹ˆ–…‚Œ“ ‘—…’“".

   str    = trim(prrate) + " " + icur.

   form
    "³" space(0) stmt.op-date  form "99.99.99"     space(0)
    "³" space(0) stmt.doc-num  form "x(6)"         space(0)
    "³" space(0) stmt.doc-type form "x(3)"         space(0)
    "³" space(0) sacctcur      form "x(20)"        space(0)
    "³" space(0) db-rub        form "x(23)"        space(0)
    "³" space(0) cr-rub        form "x(23)"        space(0)
    "³" space(0) detarr[1] form "x({&detwidth})"   space(0) "³"

   header
   skip(4)
    "ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸" skip
    "³                                                                                              à¨«®¦¥­¨¥ N 3 ª “  ³" skip
    "³"      name-bank  form "x(95)"                                                                                    "³" at 117 skip
    "³"                                                                                                                 "³" at 117 skip
    "³                                         ¥£¨áâà  ­ «¨â¨ç¥áª®£® ãç¥â                                               ³" skip
    "³                                              § " {term2str beg dob} format "x(25)"                               "³" at 117 skip
    "³"                                                                                                                 "³" at 117 skip
    "³        « ­á®¢ë© áç¥â : " long-acct format "x(25)"                                                               "³" at 117 skip
    "³"                                                                                                                 "³" at 117 skip
    "³ ‚å®¤ïé¨© ªãàá :" str                                                                                             "³" at 117 skip
    "³ ‘ «ì¤® ­  ­ ç «® ¯¥à¨®¤  :" incd at 43 inck at 67                                                                "³" at 117 skip
    "ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
    "³  „ â   ³ ®¬¥à³Š®¤³  Š®àà¥á¯®­¤¨àãîé¨© ³                    ¡®à®âë                    ³   ‘®¤¥à¦ ­¨¥ ®¯¥à æ¨¨    ³" skip
    "³®¯¥à.¤­ï³¤®ªã¬.³¤®ª³        áç¥â        ³          „¥¡¥â                  Šà¥¤¨â        ³                          ³" skip
    "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
   with no-label no-underline.