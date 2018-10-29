{capsif.i}
{get-bankname.i}
name-bank = cBankname.
   def var db-rub    as char no-undo.
   def var cr-rub    as char no-undo.
   def var doubl-chr as char no-undo.


   if doubl-v1
   then doubl-chr = trim(ts.name-vip) + " - „“‹ˆŠ€’".
   else doubl-chr = string(" ","x(3)") + trim(ts.name-vip).

   prrate = trim(prrate) + " " + icur.

   form

    "³" space(0) stmt.doc-num  form "x(6)"         space(0)
    "³" space(0) stmt.doc-type form "x(3)"         space(0)
    "³" space(0) sacctcur      form "x(20)"        space(0)
    "³" space(0) db-rub        form "x(23)"        space(0) 
    "³" space(0) cr-rub        form "x(23)"        space(0) 
    "³" space(0) detarr[1] form "x({&detwidth})"   space(0) "³"

   header
   skip(4)
    "ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸" skip
    "³                                                                                               ¥£¨áâà N 36  ª “  ³" skip
    "³"      name-bank  form "x(95)"                                                                                    "³" at 117 skip
    "³"                                                                                                                 "³" at 117 skip
    "³                                         ¥£¨áâà  ­ «¨â¨ç¥áª®£® ãç¥â                                               ³" skip
    "³                                                   § " dob form "99.99.99"                                        "³" at 117 skip
    "³"                                                                                                                 "³" at 117 skip
    "³        « ­á®¢ë© áç¥â : " long-acct format "x(25)"                                                               "³" at 117 skip
    "³"                                                                                                                 "³" at 117 skip
    "³ Šãàá :" prrate                                                                                                   "³" at 117 skip
    "³ ‘ «ì¤® ­  ­ ç «® ¤­ï :" incd at 34 inck at 58                                                                    "³" at 117 skip
    "ÃÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
    "³ ®¬¥à³Š®¤³  Š®àà¥á¯®­¤¨àãîé¨© ³                    ¡®à®âë                    ³        ‘®¤¥à¦ ­¨¥ ®¯¥à æ¨¨        ³" skip
    "³¤®ªã¬.³¤®ª³        áç¥â        ³          „¥¡¥â                  Šà¥¤¨â        ³                                   ³" skip
    "ÃÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
   with no-label no-underline.