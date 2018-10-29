{capsif.i}
{get-bankname.i}
name-bank = cBankname.
   def var h-str as char no-undo.
   def var doubl-chr as char no-undo.

   if doubl-v1 then doubl-chr = trim(ts.name-vip) + " - „“‹ˆŠ€’".
               else doubl-chr = string(" ","x(3)") + "‚›ˆ‘Š€  ‹ˆ–…‚Œ“ ‘—…’“".
   if prev-db<>"" then
      h-str = fill(" ",21) + prev-db.
   else
      h-str = fill(" ",38) + prev-cr.
   form
        "³" space(0) stmt.op-date form "99.99.99"      space(0)
        "³" space(0) stmt.doc-num form "x(6)"          space(0)
        "³" space(0) stmt.doc-type form "x(3)"         space(0)
        "³" space(0) stmt.bank-code form "x(9)"        space(0)
        "³" space(0) sacctcur form "x(20)"           space(0)
        "³" space(0) sh-db format "->>>>,>>>,>>9.99" space(0)
        "³" space(0) sh-cr format "->>>>,>>>,>>9.99" space(0)
        "³" space(0) detarr[1] form "x({&detwidth})" space(0) "³"
      header
    skip(4)
    "ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸" skip
    "³"      name-bank  form "x(95)" today form "99.99.99" string(time,"HH:MM:SS") "³" skip
    "³"                                                                                            "³" at 117 skip
    "³" doubl-chr format "x(37)" long-acct format "x(25)" "§ " {term2str beg dob} format "x(25)" cur-page-str to 115 "³" at 117 skip
    "³"                                                                                            "³" at 117 skip
    "³  ¨¬¥­®¢ ­¨¥ ¢« ¤¥«ìæ  áç¥â  : " capsif(name[1] + " " + name[2]) format "x(82)"               "³" at 117 skip
    "³" capsif(name[3] + " " + name[4]) format "x(90)"                                               "³" at 117 skip
    "³ ‘ «ì¤® ­  ­ ç «® ¤­ï :" h-str form "x(62)" "à¥¤. ¢ë¯¨áª  §  :" prevop form "99.99.99" "³" skip
    "ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
    "³  „ â   ³ ®¬¥à³Š®¤³   Š®¤   ³  Š®àà¥á¯®­¤¨àãîé¨© ³       ¡®à®âë ¢ ­ æ. ¢ «îâ¥     ³     ‘®¤¥à¦ ­¨¥ ®¯¥à æ¨¨      ³" skip
    "³®¯¥à.¤­ï³¤®ªã¬.³¤®ª³  ¡ ­ª   ³        áç¥â        ³      „¥¡¥â            Šà¥¤¨â    ³                              ³" skip
    "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip
    with no-label no-underline.                   
