/********
 * Вспомогательные функции для WU
 ********/

 {globals.i}
 {intrface.get xclass}

FUNCTION PirCalcZone3Rub RETURNS DEC(INPUT sumTransfer AS DEC,
                                     INPUT countryRec  AS CHAR,
                                     INPUT valTransfer AS CHAR,
                                     INPUT isFast      AS LOG
                                  ):

 DEF VAR vCountIntervals AS INT           NO-UNDO.
 DEF VAR vSum            AS DEC INIT 3028 NO-UNDO.


 if ((sumTransfer - 75000) / 15000) - TRUNCATE((sumTransfer - 75000) / 15000,0) = 0 
    THEN vCountIntervals = (sumTransfer - 75000) / 15000.
    ELSE  vCountIntervals = TRUNCATE((sumTransfer - 75000) / 15000,0) + 1.

 vSum = vSum + vCountIntervals * 500.

 RETURN vSum. 

END FUNCTION.

FUNCTION PirCalcZone3Val RETURNS DEC(INPUT sumTransfer AS DEC,
                                     INPUT countryRec  AS CHAR,
                                     INPUT valTransfer AS CHAR,
                                     INPUT isFast      AS LOG
                                  ):

  DEF VAR vCountIntervals AS INT           NO-UNDO.
  DEF VAR vSum            AS DEC INIT 121 NO-UNDO.
  if ((sumTransfer - 3000) / 600) - TRUNCATE((sumTransfer - 3000) / 600,0) = 0
  THEN vCountIntervals = TRUNCATE((sumTransfer - 3000) / 600,0).
  ELSE vCountIntervals = TRUNCATE((sumTransfer - 3000) / 600,0) + 1.
  vSum = vSum + vCountIntervals * 20.

 RETURN vSum.
END FUNCTION.
