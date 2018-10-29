{capsif.i}
{get-bankname.i}
name-bank = cBankname.
   def var db-rub as char no-undo.
   def var cr-rub as char no-undo.
   def var doubl-chr as char no-undo.

   if doubl-v1 then doubl-chr = trim(ts.name-vip) + " - „“‹ˆŠ€’".
               else doubl-chr = string(" ","x(3)") + trim(ts.name-vip).
   prrate = trim(prrate) + " " + icur.
   form
    "³" space(0) stmt.doc-num  form "x(6)"         space(0)
    "³" space(0) stmt.doc-type form "x(3)"         space(0)
    "³" space(0) sacctcur    form "x(20)"        space(0)
    "³" space(0) db-rub      form "x(23)"        space(0) 
    "³" space(0) cr-rub      form "x(23)"        space(0) 
    "³" space(0) detarr[1] form "x({&detwidth})" space(0) "³"
   header
   skip(4)
    "ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸" skip
    "³"      name-bank  form "x(95)" today form "99.99.99" string(time,"HH:MM:SS") "³" skip
    "³"                                                                                            "³" at 117 skip
    "³" doubl-chr format "x(37)" long-acct format "x(25)" "§ " dob form "99/99/99" cur-page-str to 115 "³" at 117 skip
    "³"                                                                                            "³" at 117 skip
    "³  ¨¬¥­®¢ ­¨¥ ¢« ¤¥«ìæ  áç¥â  : " capsif(name[1] + " " + name[2]) format "x(82)"               "³" at 117 skip
    "³" capsif(name[3] + " " + name[4]) format "x(90)"                                               "³" at 117 skip
    "³ „ â  ¯à¥¤ë¤ãé¥© ®¯¥à æ¨¨:" prevop form "99.99.99" " Š®¤ ¢ «îâë:" new-cur2 icur "‚å®¤ïé¨© ªãàá :" prrate  "³" at 117 skip
    "³ ‘ «ì¤® ­  ­ ç «® ¤­ï :" incd at 34 inck at 58 space(8) "³" at 117 skip
    "³  (¢ ­ æ.íª¢¨¢ «¥­â¥) :" inrd at 34 inrk at 58                                                      "³" at 117 skip
    "³" strcurdif "³" at 117 skip
    "ÃÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
    "³ ®¬¥à³Š®¤³  Š®àà¥á¯®­¤¨àãîé¨© ³                    ¡®à®âë                    ³        ‘®¤¥à¦ ­¨¥ ®¯¥à æ¨¨        ³" skip
    "³¤®ªã¬.³¤®ª³        áç¥â        ³          „¥¡¥â                  Šà¥¤¨â        ³                                   ³" skip
    "ÃÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
   with no-label no-underline.