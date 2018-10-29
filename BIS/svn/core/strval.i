/*
Converts decimal {1} (0.00 to 999,999,999,999.99) to char string {2}
*/

{globals.def}

def var hundreds as char extent 10 no-undo initial
['','сто ','двести ','триста ','четыреста ','пятьсот ','шестьсот ','семьсот ','восемьсот ','девятьсот '].
def var tens as char extent 10 no-undo initial
['','десять ','двадцать ','тридцать ','сорок ','пятьдесят ','шестьдесят ','семьдесят ','восемьдесят ','девяносто '].
def var ones as char extent 20 no-undo initial
['','один ','два ','три ','четыре ','пять ','шесть ','семь ','восемь ','девять ','десять ','одиннадцать ','двенадцать ','тринадцать ','четырнадцать ','пятнадцать ','шестнадцать ','семнадцать ','восемнадцать ','девятнадцать '].
def var suffix-m as char extent 5 no-undo initial ['ов ',' ','а ','а ','а '].
def var suffix-f as char extent 5 no-undo initial [' ','а ','и ','и ','и '].
def var suffix-r as char extent 5 no-undo initial ['ей ','ь ','я ','я ','я '].

def var stinstr  as char                                           no-undo.
def var digit    as INT64 extent 12                              no-undo.
def var sti      as INT64                                            no-undo.
def var cdec      as char                                            no-undo.

stinstr = string(if {1} ge 0 then {1} else (- {1}), "999999999999.99").

do sti = 1 to 12:
  digit[sti] = INT64(substr(stinstr, 13 - sti, 1)).
end.

{2} = if substr(stinstr,1,12) eq "000000000000" then "ноль " else "".
assign ones[2] = "один " ones[3] = "два ".
{2} = {2} + {triad.i 9 миллиаpд m}.
{2} = {2} + {triad.i 6 миллион  m}.
assign ones[2] = "одна " ones[3] = "две ".
{2} = {2} + {triad.i 3 тысяч    f}.
assign ones[2] = "один " ones[3] = "два ".
{2} = {2} + {triad.i 0 pубл     r}.

if INT64(substr(stinstr,14,2)) >= 0 then do:
/* добавленно равно для вывод 00 копеек  Кунташев */
   find first currency where currency.currency = "" no-lock no-error.

   if avail(currency) then do:
      cdec = {triad3.i}.
   end.
   else
      cdec = "{&in-La-DecNCN}".
   {2} = {2} + substr(stinstr,14,2) + " " + cdec.

end.
