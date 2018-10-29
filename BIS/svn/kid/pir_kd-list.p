/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2007 ЗАО "Банковские информационные системы"
     Filename: pir_kd-list.p
      Comment: Список КД по фильтру
   Parameters:
         Uses:
      Used by:
      Created: 29/05/2012 SSV
     Modified:
*/

{globals.i}

{tmprecid.def}
{intrface.get tmess}
{intrface.get strng}
{intrface.get card}
{intrface.get cust}
{intrface.get xclass}
{intrface.get instrum}
{intrface.get loan}
{intrface.get date}

/* DEF INPUT PARAM i_user-proc_procedure AS CHAR. / * используемый шаблон передается параметром */

{setdest.i}

FOR EACH tmprecid
, FIRST loan
    WHERE RecID(loan) = tmprecid.id
  NO-LOCK
  WITH WIDTH 120 :
     DEF VAR         vClName AS CHAR NO-UNDO EXTENT 3.
     RUN GetCustName IN h_base (             loan.cust-cat,
                                           loan.cust-id,
                                           "",
                              OUTPUT       vClName[1],
                              OUTPUT       vClName[2],
                              INPUT-OUTPUT vClName[3]
     ).

	vClName[1] = vClName[1] + " " + vClName[2].

    DISP
	loan.cont-code	 FORMAT 'x(12)'
	loan.loan-status FORMAT 'x(4)'
	loan.open-date 	 FORMAT '99.99.9999'
	loan.end-date  	 FORMAT '99.99.9999'
	loan.currency
	vClName[1]	 FORMAT 'x(40)' COLUMN-LABEL "ФИО или НАИМЕНОВАНИЕ"

		SKIP.
END.

FIND FIRST _user
  WHERE _user._userid = userid
  NO-LOCK NO-ERROR.


PUT UNFORMATTED
	SKIP(2) "\t" "\t" "\t"
	STRING(TODAY, "99/99/99") " "
	STRING(TIME, "hh:mm:ss")

	" ___________________ "
	(IF AVAIL _user
	  THEN _user._user-name
	  ELSE "-"
	) SKIP.


{preview.i}
