/***************************************************
 *                                                                                               *
 *  ��楤�� ����஫� �����⨬��� �믮������      *
 * ��室��� ����樨 �� ������⭮�� ��������.          *
 *                                                                                               *
 *                                                                                               *
 ***************************************************
 * ����: ��᫮� �. �.                                                         *
 * ��� ᮧ�����: 15:46 01.09.2010                                      *
 * ���: #397                                                                       *
 **************************************************/
{globals.i}
{ulib.i}
{intrface.get debug}

/* Maslov D. A. Added By Event #505 */
&GLOBAL-DEFINE maskDepozAcctList397 !423*,!426*,42*

FUNCTION getPermitClose RETURNS INTEGER(INPUT cXAttrValue AS CHARACTER,INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE):

            /****************************************
             * �㭪�� ��।��塞 �ப ������� �       *
             * ��⥬ �����頥� ������⢮ ����            *
             *  �� ������� ������� � �祭��                *
             *  ������ ����饭�� ������� ���������. *
            *****************************************/
        DEF VAR iDayDiff AS INTEGER.
        DEF VAR oSysClass AS TSysClass.
        
oSysClass = new TSysClass().

        IF cXAttrValue <> "" THEN
        DO:
                /* ��⠭����� ���. ४����� */
                 iDayDiff = INTEGER(cXAttrValue).
                /* 
                     � ������� �������� ��࠭�祭�� 
                     �� ���������� ������.
                */
          END. /* ����� ��� ४����� ��⠭�����  */
           ELSE
                DO:

                            iDayDiff = dDateEnd - dDateBeg.

                            /* ��।����� ������ �६������ ���ࢠ�� �ਭ������� ������� */
                            iDayDiff = oSysClass:getLineSegment(iDayDiff,"90,90,90,9999").

                           FIND FIRST code WHERE code.class EQ "PirPermitIn" AND code.val EQ STRING(iDayDiff) NO-LOCK NO-ERROR.

                            iDayDiff = INTEGER(code.code).
                END.  /* ����� �� ��⠭����� ���. ४����� */

DELETE OBJECT oSysClass.

                RETURN iDayDiff.
END FUNCTION.

FUNCTION getDepozEndDate RETURNS DATE(INPUT cDogContract AS CHARACTER,INPUT cClassCode AS CHARACTER,INPUT cDogNum AS CHARACTER):
                            /**************************************
                             * �����頥� ���� ������� �������    *
                             **************************************/
DEF BUFFER bLoan-Cond FOR loan-cond.
DEF BUFFER bLoan FOR loan.

DEF VAR dDateEnd AS DATE INITIAL ?.                                    /* ��� ����砭�� ������� */

/* 
    �� 䨣� �� ����, ��� ��� ����砭�� ������� �࠭����.
    �������, �� ���� ��ᬮ���� ���. ४�����, � ⮫쪮 ��⮬
   ��ᬮ���� �᭮���� ४����� �������.
*/

  /* ��諨 ��᫥���� �᫮��� �� �������� */
     FIND LAST bLoan-Cond WHERE bLoan-Cond.cont-code EQ cDogNum  AND bLoan-Cond.contract EQ cDogContract NO-LOCK NO-ERROR.
                IF NOT ERROR-STATUS:ERROR THEN
                     DO:                                
                            dDateEnd = DATE(getXAttrValue("loan-cond",bLoan-Cond.contract + "," + bLoan-Cond.cont-code + "," + STRING(bLoan-Cond.since),"CondEndDate")). 
                      END.

            IF dDateEnd EQ ? THEN
                    DO:
                            FIND FIRST bLoan WHERE bLoan.cont-code EQ cDogNum AND bLoan.contract EQ cDogContract AND bLoan.close-date EQ ?.
                            
                                        IF AVAILABLE(bLoan) THEN 
                                                DO:
                                                    dDateEnd = bLoan.end-date.                                
                                                END.
                    END.

             RETURN dDateEnd.
END FUNCTION.

FUNCTION getPermitDateByNum RETURNS DATE(INPUT cDogContract AS CHARACTER,INPUT cClassCode AS CHARACTER,INPUT cDogNum AS CHARACTER):

                                            /***********************************************
                                             *  �㭪�� �����頥� ���� ��稭�� � ���ன      *
                                             * ����頥��� ��������� ����� .                                 *
                                             ***********************************************/
/* ��।��塞 ������� ��६���� */
DEF VAR dKIDBegPeriod AS DATE.                         /* ��� ��砫쭮�� �襭�� ��� */

DEF VAR dDateBeg AS DATE.                                   /* ��� ��砫� ������� */
DEF VAR dDateMiddle AS DATE.                              /* ��� ��砫� ��࠭�祭�� */
DEF VAR dDateEnd AS DATE.                                    /* ��� ����砭�� ������� */
DEF VAR iDayDiff AS INTEGER.                               /* ������⢮ ���� �� ������� � �祭�� ������ ����� ����� ��������� */

 
DEF VAR lResult AS LOGICAL INITIAL TRUE.     /* ������� ࠡ��� �㭪樨 ��-㬮�砭�� "ࠧ�襭� ���������" */
DEF VAR iDebugLevel AS INTEGER.                       /* �஢��� �⫠��� */
DEF VAR cExReq AS CHARACTER.                        /* �६����� ��� �࠭���� ���祭�� ���. ४����� */

dKIDBegPeriod = DATE(FGetSetting("��⠍��।",?,?)).
RUN GetLevel IN h_debug (OUTPUT iDebugLevel).

dDateMiddle = dKIDBegPeriod.


                        /* ��� �ਭ������� ������ */
                       cExReq = GetXAttrValue("loan",cDogContract + "," + cDogNum,"PirPermitIn").
                       dDateBeg = DATE(getMainLoanAttr(cDogContract,cDogNum,"%��⠍��")).

                       dDateEnd = getDepozEndDate(cDogContract,cClassCode,cDogNum).

                                          IF dDateEnd <> ? THEN  
                                                                    DO:
                                                                        iDayDiff = getPermitClose(cExReq,dDateBeg,dDateEnd).
                                                                        dDateMiddle = dDateEnd - iDayDiff.
                                                                    END.
                              RETURN dDateMiddle.
END FUNCTION.

FUNCTION getPermitDate RETURNS DATE(INPUT cAcct AS CHARACTER):

                                            /***********************************************
                                             *  �㭪�� �����頥� ���� ��稭�� � ���ன      *
                                             * ����頥��� ��������� �����                                   *
                                             ***********************************************/

 /* �������㥬 ������ */
DEF BUFFER bLoan-Acct FOR loan-acct.

cAcct = REPLACE(cAcct,"-","").                                /* ���ࠥ� "-", �⮡ �� Copy/Paste 㤮��� ������ �뫮 */

FIND FIRST bLoan-Acct WHERE bLoan-Acct.acct = cAcct NO-LOCK NO-ERROR .

IF NOT ERROR-STATUS:ERROR THEN
  DO:
          /* ��諨 ��� ��� � �������.  */
            RETURN getPermitDateByNum(bLoan-Acct.contract,"loan_attract",bLoan-Acct.cont-code).
   END. /* ����� �ਢ離� ������� */

   RETURN ?.
END FUNCTION.

FUNCTION isDepozInPermit RETURNS LOGICAL (INPUT cAcct AS CHARACTER,INPUT dOpDate AS DATE):

/*****************************************************
 *                                                                                                      *
 * �㭪�� �஢���� ࠧ�襭�,                                           *
 * �� ᯨᠭ�� �� ��������                                                        *
 * � ������� �६����� ��ਮ�?                                            *
 *                                                                                                      *
 * ������:                                                                                   *
 *    1.  ��室�� ��� ��� <--> �������;                                *
 *    2. �饬 �� ������� ���. ४����� PirPermitIn                *
 *  �᫨ ��� ���. ४����� <> "����" � <> 0,                        *
 *  � �� �ப� ����砭�� ���⠥� ���祭�� PirPermitIn.  *
 *   3. �᫨ ���. ४����� = "����" ��� 0, � ��⠥�,         *
 * �� ��������� ����� ����� � �� �६�;                      *
 *                                                                                                       *
********************************************************/
                            DEF VAR dDateMiddle AS DATE.

                              dDateMiddle = getPermitDate(cAcct).

                            IF dDateMiddle <> ? THEN
                                DO:

                                        IF dDateMiddle<=dOpDate THEN
                                           DO:
                                                 /*  ���㬥�� ����� � ����饭���
                                                       ���ࢠ�� � ᮮ⢥��⢥��� �� ����� ���� 
                                                       �믮����.
                                                */  
                                                 RETURN FALSE.
                                          END.
                                END.
                   RETURN TRUE.

END FUNCTION.