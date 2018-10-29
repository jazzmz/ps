{pirsavelog.p}

def var i as int no-undo.
&GLOB FMT format "->>>>>>>>>>9.99"

{branches.i}

{setdest.i &cols = 110}

put unformatted "€‹€‘ „‹ ” € " + STRING(DataBlock.beg-date + 1,"99.99.9999") skip(1) .

{br-put.i}

for each DataLine of DataBlock no-lock 
    break by DataLine.Sym1 with frame bs stream-io:

    form 
        DataLine.Sym1  format "99999" column-label "/‘"
        DataLine.Val[7]  {&fmt} column-label "€’‚ "
        DataLine.Val[8]  {&fmt} column-label "€’‚ "
        DataLine.Val[9]  {&fmt} column-label "€’‚"
        DataLine.Val[10] {&fmt} column-label "€‘‘‚ "
        DataLine.Val[11] {&fmt} column-label "€‘‘‚ "
        DataLine.Val[12] {&fmt} column-label "€‘‘‚"
    with no-box width 110.

    accum
         DataLine.Val[9] - DataLine.Val[8]   (total)
         DataLine.Val[8] (total)
         DataLine.Val[9] (total)
         DataLine.Val[12] - DataLine.Val[11]   (total)
         DataLine.Val[11] (total)
         DataLine.Val[12] (total).

    if (DataLine.Val[8] + DataLine.Val[9] + DataLine.Val[11] + DataLine.Val[12]) <> 0 then do:
    disp DataLine.Sym1
         DataLine.Val[9] - DataLine.Val[8] @ DataLine.Val[7]  
         DataLine.Val[8]
         DataLine.Val[9] 
         DataLine.Val[12] - DataLine.Val[11] @ DataLine.Val[10]
         DataLine.Val[11] 
         DataLine.Val[12]. 
    end.

    if last(DataLine.Sym1) then do:
    underline DataLine.Sym1 Val[7] Val[8] Val[9] Val[10] Val[11] Val[12].
    disp 
         accum total DataLine.Val[9] - DataLine.Val[8] @ DataLine.Val[7]  
         accum total DataLine.Val[8] @ DataLine.Val[8]
         accum total DataLine.Val[9] @ DataLine.Val[9]
         accum total DataLine.Val[12] - DataLine.Val[11] @ DataLine.Val[10]
         accum total DataLine.Val[11] @ DataLine.Val[11]
         accum total DataLine.Val[12] @ DataLine.Val[12].
    end.

end.

put unformatted skip(2) "‡ ¬. ΰ¥¤α¥¤ β¥«ο ΰ Ά«¥­¨ο				/ «®£¨­  ….ƒ. /" skip(3).
put unformatted "ƒ« Ά­λ© ΅γε£ «β¥ΰ					/ ®«®α®Ά  .‚. /".

{signatur.i &department = dept &user-only=yes}
{preview.i}
