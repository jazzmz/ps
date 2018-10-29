/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2002 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: DPS-B2P.P
      Comment: ����� "�������" ��楤��, �ᯮ��㥬��  � 
               �࠭������ ������ ����� �������
               �� �᭮�� ��楤�� g-cr2.p � g-cr2unk.p
   Parameters:
         Uses:
      Used by:
      Created:
                tt 0004779  ��⮬���᪮� ��।������ � ���. ��. 2-��� ���浪� �� �஫����樨 
                            persistent ��楤�� ��� ��।�� ��ࠬ��஢ ������ 
  
                27/3/02 ����.�㭪�� �������() - ��।������ � ���. ��. 2-��� ���浪� �� ����⨨ ������
                        �����.��楤�� SET-DEP-PERIOD : ��।�� ����୮� �㭪樨 �த����⥫쭮�� ���뢠����� ������ �
                        �ଠ� "�=99,�=99,�=99"
      
     Modified: 01.07.2002 14:09 mitr  tt 8271 - 
                                      ��� 702(loan-expens) � 457(loan-future) �� ����ன�� ������� ������ 
                                      ������� �� १����⭮��.
                                      �.�. � �࠭���樨 ������ ������ ���� ����������� 㪠���� �������᪨�
                                      ��� � ����ᨬ��� �� १����⭮�� ������.
                                      � ������ ��ࠡ�⪨ 蠡����� ��⮢ ����� ������ ��� �� �����⥭, ���⮬�
                                      �� �� ����� �ᯮ�짮���� �㭪�� ������ �� g-pfunc.def � ᮧ���� 
                                      ���� ��ਠ�� ������ �㭪樨 � ������ O_�������� (�����頥� 1, 
                                      �᫨ �����稪 ���� १����⮬ ������).
                                                
     Modified: 4/7/02 mitr@bis.ru     ��������� ����ୠ� �㭪��  �_������():   �����頥� ��� ������ , � ���ன ���뢠���� �����
     Modified: 
*/

DEFINE INPUT PARAMETER loan-rid     AS RECID. /* loan */
DEFINE INPUT PARAMETER in-op-kind   LIKE op-kind.op-kind.
{sh-defs.i}
{globals.i} 
{dpsproc.def}
{intrface.get xclass}

DEF VAR local-dep-period   AS CHARACTER INIT ?  NO-UNDO.
DEF VAR local-summa        AS DECIMAL   INIT ?  NO-UNDO.
DEF VAR local-branch-id    AS CHARACTER INIT ?  NO-UNDO. 
DEF VAR in-op-kind$        AS CHARACTER         NO-UNDO.

DEF TEMP-TABLE tt
   FIELD INTERVAL AS INT64
   FIELD bal-acct AS CHARACTER
   INDEX INTERVAL INTERVAL.

if not this-procedure:persistent then do:
  message "��楤�� " this-procedure:file-name " ������ ����᪠���� � ��樥� persistent" view-as alert-box.
  return error.
end.

this-procedure:private-data = "parssen library,�����⏥�,�������,������஫,�_������,�_������,�_���,�_����,�_����,�_����,�_������,�_१�����,�_�����,�_���������".


/* �-�� ��������� ��ࠬ���, ��।������ � ��楤��� */
/* ��᫥ ࠧ��� ��ப�  ��ࠬ��஢ ����஬             */
{getprm.lib}

function dat_ return char (input d as INT64,
              input p as char):
    def var yy as char extent 3 init ['���','����','���'] no-undo.
    def var mm as char extent 3 init ['�����','�����','����楢'] no-undo.
    def var dd as char extent 3 init ['����','���','����'] no-undo.
    d = if d gt 3 then 3 else d.
    if p eq '�' then return yy[d].
    else if p eq '�' then return mm[d].
    else if p eq '�' then return dd[d].
end function.

/* ���樠������ ���.��६����� ��� ��楤��� ������ ������ ������ 
����� ��६���� �ᯮ������� � ����୮� �㭪樨 �������() */
PROCEDURE SET-private-data:  
   DEF INPUT PARAMETER in-dep-period   AS CHARACTER   NO-UNDO.
   DEF INPUT PARAMETER in-summa        AS DECIMAL     NO-UNDO.

  ASSIGN   
     local-dep-period = in-dep-period
     local-summa      = in-summa
     .
END PROCEDURE.

procedure setBranch-id:
  def input parameter in-branch-id as char no-undo.
  local-branch-id = in-branch-id.
end procedure.

/*---------------------------------------------------------------------------------------------------------------------------------
  �㬬� �஫����஢������ ������ ������ ���뢠���� �� �����ᮢ�� ��� ��ண� ���浪�, ��⠭��������� �� �� ��� ��� �������, 
  ���ᥭ��� �� �ப, ����� �����뢠���� ��� ��騩 �ப �ਢ��祭�� (�ப 䠪��᪮�� ��宦����� �� ��� ���� �������⥫�� 
  �ப �ਢ��祭�� �� �஫����樨). 
  �.� ��� ������⮢ 䨧 ��� 
    42301 - �� ����ॡ������;
    42302 - �� �ப �� 30 ��.,
    42303 - �� 31�� 90 ��.,
    42304 - �� 91 �� 180 ��.,
    42305 - �� 181��. �� 1����;
    42306 - �� 1�. �� 3 ���;
    42307 - ��� 3���.
  ��।������ ����� �����ᮢ��� ��� ��ண� ���浪�, �� ���஬ ������ ���뢠���� �㬬� �஫����஢������ ������ � ᮮ⢥��⢨� 
  � �ॡ�����ﬨ �� ��, ������ �஢������ ��⮬���᪨, ��᫥ 祣� � ����室���� �����  ����� ��७����� �� �㦭� �����ᮢ� ��� 
  �� �ப�� �ਢ��祭��, ���� �� ���� ��砫� �������.
  �᭮����� �ࠢ��� 61 � ������ �� �� 27 ���� 1996 �. N 25-1-322 �. IV.
  ����祭� ���⢥ত���� �� ���� ����� �. �ਫ��. 䠩�.   
---------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE �����⏥�:
  DEF INPUT PARAM rid         AS RECID   NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE    NO-UNDO.
  DEF INPUT PARAM param-count AS INT64     NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR    NO-UNDO.
   
  DEF VAR vnew-date           AS DATE.
  DEF VAR vdelta              AS INT64.
  DEF VAR in-op-template      AS INT64 NO-UNDO.
  DEF VAR vperiod             AS CHAR    NO-UNDO.
  DEF VAR vOpenDate AS DATE NO-UNDO.
  
  /* ⠡��� TT - ��� ���஢�� */
  for each tt: delete tt. end.
  for each code where code.class = "dps-b2p" :
    create tt.
    assign tt.interval = INT64(code.code)
           tt.bal-acct = code.val
    .
  end.

  /*��� �������஢����� �������*/
  FIND FIRST loan WHERE RECID(loan) = loan-rid NO-LOCK NO-ERROR.
  IF NOT AVAILABLE loan THEN RETURN. 
  
  vOpenDate = DATE(GetXattrValueEx("loan",loan.contract + "," + loan.cont-code,"��⠎��",?)) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN vOpenDate = ?.
  IF vOpenDate = ?  THEN vOpenDate = loan.open-date.

  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    vperiod = GetXattrValueEx("loan",loan.contract + "," + loan.cont-code,"dep_period",?).
    IF vperiod NE ? THEN
    DO: /* �஢�ઠ ��⠭���� ��ࠬ��� dep_period (��� g-cr2.p) */       
      vnew-date =  Get-End-Date(loan.end-date, vperiod).
      IF vnew-date = loan.end-date THEN vdelta = 0.
      ELSE vdelta = vnew-date -  vOpenDate.
    END.
    ELSE
    DO: /* ��� g-cr.p */  
      RUN set-op-kind . /* �࠭����� �஫����樨 -> in-op-kind$ */
      IF return-value = "error" THEN UNDO, LEAVE.
      in-op-template = GET_OP-TEMPL(in-op-kind$, "loan", "").
      IF in-op-template NE ? THEN
      DO: /* ��諨 蠡��� �஫����樨  */ 
        FIND op-template WHERE op-template.op-kind     EQ in-op-kind$
                           AND op-template.op-template EQ in-op-template  NO-LOCK.

        vperiod = Get_Param('dep-period', RECID(op-template)).
        IF vperiod = ? THEN vdelta = 0. /* ��ࠬ��� dep-period � 蠡���� �� ����� */
        ELSE
        DO: 
          vnew-date = Get-End-Date(loan.end-date, vperiod).
          IF vnew-date = loan.end-date THEN vdelta = 0.
          ELSE vdelta = vnew-date - vOpenDate.
        END.
      END.
      ELSE vdelta = 0. /* �� ��諨 蠡��� �஫����樨, ⮣�� �� ����ॡ������ */ 
    END. 

    /* १����� ��� ���*/
    FIND person WHERE person.person-id = loan.cust-id NO-LOCK.
  
    FIND FIRST tt WHERE tt.interval GE vdelta NO-ERROR.
    IF AVAIL tt THEN pick-value = ENTRY( IF person.country-id = "rus" THEN 1 ELSE 2, tt.bal-acct) .
                                  
  END. /* DO */

/*message " �����⏥�: " skip
        "vdelta = " vdelta skip
        "loan.cont-code = " loan.cont-code skip
        "person.country-id = " person.country-id skip
        "in-op-kind = " in-op-kind skip 
        "loan.end-date = " loan.end-date skip
        "loan.open-date = " loan.open-date SKIP
        "vnew-date = " vnew-date skip
        "dep-period = " Get_Param('dep-period', RECID(op-template)) skip
        "in-op-kind$ = " in-op-kind$ skip
        "in-op-template = " in-op-template skip
     "dep_period = " GetXattrValueEx("loan",loan.contract + "," + loan.cont-code,"dep_period",?) skip(1)     
view-as alert-box.
*/

end procedure.


/* ������ �����⏥�, �� �稠�� ��ਮ� �� �� ���� ������, 
** � �� ���� �஫����樨 */
PROCEDURE ������஫:
   DEF INPUT PARAM rid         AS RECID   NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE    NO-UNDO.
   DEF INPUT PARAM param-count AS INT64     NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR    NO-UNDO.
       
   DEF VAR vRetVal        AS CHARACTER INIT ?  NO-UNDO. /* �����頥��� ���祭�� */
   DEF VAR vProlDate      AS DATE              NO-UNDO. /* ��� ��砫� ������ */
   DEF VAR vPeriod        AS CHARACTER         NO-UNDO. /* �த����⥫쭮��� ������ */
   DEF VAR vNewDate       AS DATE              NO-UNDO. /* ����� ��� ����砭�� */
   DEF VAR vDelta         AS INT64           NO-UNDO.   
   DEF VAR in-op-template AS INT64           NO-UNDO.
   
    /* ⠡��� TT - ��� ���஢�� */
   {empty tt}
   
   MAIN:
   DO ON ERROR  UNDO, LEAVE
      ON ENDKEY UNDO, LEAVE:
   
      /* ��� ���४⭮� ���஢�� */
      FOR EACH CODE WHERE CODE.CLASS EQ "dps-b2p"
         NO-LOCK:
         CREATE tt.
         ASSIGN 
            tt.interval = INT64(code.code)
            tt.bal-acct = code.val
         .
      END.
    
      /*��� �������஢����� �������*/
      FIND FIRST loan WHERE RECID(loan) EQ loan-rid 
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE loan THEN
         UNDO MAIN, LEAVE MAIN.
            
      ASSIGN
         vProlDate = IF in-op-date EQ ? THEN DATE(GetSysConf("CDate4dpsb2p"))
                                        ELSE in-op-date
      
         vPeriod   = GetXattrValueEx("loan",
                                     loan.contract + "," + loan.cont-code,
                                     "dep_period",
                                     ?).
   
      /* �஢�ઠ ��⠭���� ��ࠬ��� dep_period (��� g-cr2.p) */       
      IF vPeriod NE ? THEN      
         ASSIGN
            vNewDate = Get-End-Date(loan.end-date, vPeriod)
            vDelta   = IF vNewDate EQ loan.end-date THEN 0
                                                    ELSE (vNewDate - vProlDate).      
      ELSE
      /* ��� g-cr.p */  
      DO: 
         /* �࠭����� �஫����樨 -> in-op-kind$ */
         RUN set-op-kind. 
         IF RETURN-VALUE EQ "error" THEN 
            UNDO MAIN, LEAVE MAIN.
         ASSIGN 
            vDelta = 0
            in-op-template = Get_Op-Templ(in-op-kind$, "loan", "")
            .         
         IF in-op-template NE ? THEN
         DO:             
            /* ��諨 蠡��� �஫����樨  */ 
            FIND op-template WHERE op-template.op-kind     EQ in-op-kind$
                               AND op-template.op-template EQ in-op-template  
               NO-LOCK NO-ERROR.
    
            vPeriod = Get_Param('dep-period', RECID(op-template)).   
            IF vPeriod NE ? THEN                            
               ASSIGN
                  vNewDate = Get-End-Date(loan.end-date, vPeriod)
                  vDelta   = IF vNewDate EQ loan.end-date THEN 0
                                                          ELSE (vNewDate - vProlDate).               
         END.         
      END. 
    
      /* १����� ��� ���*/
      FIND FIRST person WHERE person.person-id EQ loan.cust-id 
         NO-LOCK NO-ERROR.      
      FIND FIRST tt WHERE tt.interval GE vDelta 
         NO-ERROR.
      IF AVAIL tt THEN 
         vRetVal = ENTRY(IF person.country-id EQ "rus" THEN 1 
                                                       ELSE 2, tt.bal-acct).
   END.

   pick-value = vRetVal.
END PROCEDURE.


/*------------------------------------------------------------------------ 
    ��।������ �࠭���樨 �஫����樨 ; १���� � in-op-kind 
    return-value() ="error" �᫨ �������� �訡�� � ���᪥
------------------------------------------------------------------------*/
procedure set-op-kind:

  def var t             as INT64 no-undo.
  def var loan-op-kind$ as char    no-undo.
  def var out-op-kind as char no-undo .
  DEF VAR fl-ok-prol AS LOGICAL NO-UNDO .

  FIND FIRST op-kind WHERE op-kind.op-kind EQ loan.op-kind NO-LOCK NO-ERROR.
  IF AVAIL op-kind THEN 
  DO:    
     t = get_op-templ(op-kind.op-kind, "loan", "").
     IF t EQ ? THEN 
     DO:        
        RETURN "".
     END.             
     FIND op-template OF op-kind WHERE op-template.op-template EQ t NO-LOCK NO-ERROR.
     IF AVAIL op-template THEN 
     DO:
        RUN Chk_Limit_Per in h_dpspc (loan.end-date,
                                              RECID(loan),
                                              loan.prolong + 1,
                                              OUTPUT fl-ok-prol).  
        /* ��।������ �� ����� �࠭���樨 �㤥� ���� ����� */
        IF NOT fl-ok-prol THEN 
        DO:
           ASSIGN in-op-kind$ = ?.
        END.
        ELSE
        DO:
           RUN get-param-const in h_dpspc (RECID(loan),
                                                   'prol-kind',
                                                   OUTPUT in-op-kind$).
           IF in-op-kind$ = ? THEN 
              ASSIGN in-op-kind$ = loan.op-kind.
        END.
     END.
     ELSE 
        RETURN "error".
  END.
  ELSE
     RETURN "error".

end procedure.
/* --------------- ����� ��।������ �࠭���樨 �஫����樨 ------------*/


/*----------------------------------------------------------------------------------------------  
  27/3/02 ����.�㭪�� �������() - ��।������ � ���. ��. 2-��� ���浪� 
          �� ����⨨ ������ 
-----------------------------------------------------------------------------------------------*/
PROCEDURE �������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.
   
   DEFINE VARIABLE vDelta     AS INT64     NO-UNDO.
   DEFINE VARIABLE vNext29Feb AS DATE        NO-UNDO.
   DEFINE VARIABLE vCorrInt   AS INT64     NO-UNDO.
   DEFINE VARIABLE vCorrMeth  AS INT64     NO-UNDO.
   DEFINE VARIABLE vI         AS INT64     NO-UNDO.
   DEFINE VARIABLE vNameproc  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vParams    AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vNumYears  AS INT64     NO-UNDO.
   DEFINE VARIABLE vEndDate   AS DATE      NO-UNDO.

   /* ⠡��� TT - ��� ���஢�� */  
   {empty tt}
   FOR EACH code WHERE code.class EQ "dps-b2p"
      NO-LOCK:
      CREATE tt.
      ASSIGN 
         tt.interval = INT64(code.code)
         tt.bal-acct = code.val
         .
   END.
    
   pick-value = ?.
   
   MAIN:
   DO ON ERROR  UNDO MAIN, LEAVE MAIN
      ON ENDKEY UNDO MAIN, LEAVE MAIN:  
   
     /* १����� ��� ���*/
     FIND FIRST loan WHERE RECID(loan) EQ loan-rid 
        NO-LOCK NO-ERROR.
     IF NOT AVAIL loan THEN
        UNDO MAIN, LEAVE MAIN.
   
     FIND FIRST person WHERE person.person-id EQ loan.cust-id 
        NO-LOCK NO-ERROR.
     IF NOT AVAIL person THEN
        UNDO MAIN, LEAVE MAIN.

     RUN deposit-dep-period IN h_dpspc (RECID(loan), 
                                        in-op-date, 
                                        local-dep-period, 
                                        OUTPUT vDelta).

     /* �᫨ ��ਮ� 㪠��� � �����, � ��稭����� ���⪨� ⠭�� � �㡭��, �.�.
     ** ���� ����� �, �� �� ��ॢ��� � ��� � ����ᨬ��� �� ��⮤�
     ** "get-end-date" �ப � ���� ����� 㢥��稢����� �� ����, � � ��砥
     ** �᫨ � �஬���⮪ �������� ��᮪��� ����, � �� �� �����஥ 
     ** ������⢮ ����, � �� �⮬ � �ࠢ�筨�� "dps-b2p" ��ਮ� 
     ** 㪠�뢠���� ⮫쪮 � ���� */
     IF     NUM-ENTRIES(local-dep-period) EQ 3
        AND local-dep-period BEGINS "�" THEN
        vNumYears = INT64(ENTRY(2, ENTRY(1, local-dep-period), "=")) NO-ERROR.
     IF ERROR-STATUS:ERROR THEN
        vNumYears = 0.
     IF vNumYears NE 0 THEN
     DO:
        /* �饬 ᪮�쪮 29-�� 䥢ࠫ� �������� � �ப ����� ������ */
        DO vI = YEAR(gend-date) TO YEAR(gend-date + vDelta):
           vNext29Feb = DATE(02, 29, vI) NO-ERROR.
           IF     NOT ERROR-STATUS:ERROR
              AND vNext29Feb LT (gend-date + vDelta)
              AND vNext29Feb GT gend-date THEN
              ASSIGN
                 vCorrInt     = vCorrInt + 1
                 vNext29Feb   = ?
                 .          
        END.
     
        /* ��।��塞, �ᯮ������ �� ��楤�� ��⮤� "get-end-date" */
        RUN GetClassMethod IN h_xclass (loan.class-code, 
                                        "get-end-date",
                                        "",
                                        "",
                                        OUTPUT vNameproc,
                                        OUTPUT vParams).
        /* �᫨ ��⮤ �����, � �饬 ࠧ���� ����� ���᫥���� �த����⥫쭮����
        ** ������ � �᫨ �� ��⮤ �� �� �� �����, �.�. ���� ��直� ��譨� ���� */
        IF {assigned vNameproc} THEN 
        DO:
           vEndDate = get-end-date(gend-date, local-dep-period).            
           vCorrMeth = vDelta - (vEndDate - gend-date).
           IF MONTH(vEndDate) EQ 2 AND DAY(vEndDate) EQ 29 THEN
              vCorrInt = vCorrInt - 1.
        END.
        /* ���४��㥬 �த����⥫쭮��� �� ࠧ���� � �ப�� �� �� ��⮤� */
        vDelta = vDelta - vCorrMeth.

        /* ���४��㥬 �த����⥫쭮��� �� ࠧ���� � �裡 � ��᮪��묨 ������ */
        IF ((vDelta - vCorrInt) MODULO 365) EQ 0 THEN
           vDelta = vDelta - vCorrInt.
     END.
   
     /* �饬 �����ᮢ� ��� � �ࠢ�筨�� "dps-b2p" */
     FIND FIRST tt WHERE tt.interval GE vDelta 
        NO-ERROR.
     IF AVAIL tt THEN 
        pick-value = ENTRY(IF person.country-id EQ "rus" THEN 1 
                                                         ELSE 2, tt.bal-acct).                                  
   END. /* DO */
END PROCEDURE.


/*--------------------------------------------------  
  ������� ��� ������������ �������� �����
  1) �_������  -  ��� ������
  2) �_������ - ����� ��������
  3) �_���    ��� ���������
  4) �_����   ���� �������� ������
  5) �_����   ����.������
  6) �_����   ���� � ���� "1 ��� 6 ������� 20 ����"
  7) �_������ ���� ��������� �������� (���� ������ ����� 1 ����)
---------------------------------------------------*/

/*----------------------------------------------------------------------------------------------  
  1) �_������  -  ��� ������
-----------------------------------------------------------------------------------------------*/
PROCEDURE �_������:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    FIND loan WHERE RECID(loan) = loan-rid
       NO-LOCK NO-ERROR.
    FIND FIRST CODE WHERE CODE.class = "cont-type" 
                      AND CODE.CODE  = loan.cont-type
       NO-LOCK NO-ERROR.
    IF AVAIL (CODE) THEN
       pick-value = CODE.NAME.                
  END. /* DO */
END PROCEDURE.
/*----------------------------------------------------------------------------------------------  
  2) �_������ - ����� ��������
-----------------------------------------------------------------------------------------------*/
PROCEDURE �_������:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    FIND FIRST loan WHERE RECID(loan) = loan-rid NO-LOCK.
    pick-value = loan.doc-ref.
                
  END. /* DO */
END PROCEDURE.
/*----------------------------------------------------------------------------------------------  
  3) �_���    ��� ���������
-----------------------------------------------------------------------------------------------*/
PROCEDURE �_���:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    FIND loan WHERE RECID(loan) = loan-rid NO-LOCK.
    find person where person.person-id = loan.cust-id no-lock.
    pick-value = person.name-last + " " + person.first-names .                
  END. /* DO */
END PROCEDURE.
/*----------------------------------------------------------------------------------------------  
  4) �_����   ���� �������� ������
-----------------------------------------------------------------------------------------------*/
PROCEDURE �_����:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    FIND loan WHERE RECID(loan) = loan-rid NO-LOCK.
    pick-value = STRING(loan.open-date, "99/99/9999").                
  END. /* DO */
END PROCEDURE.
/*----------------------------------------------------------------------------------------------  
  5) �_����   ����.������
-----------------------------------------------------------------------------------------------*/
PROCEDURE �_����:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  DEF VAR in-templ AS INT64 NO-UNDO.
  DEF VAR cmm AS CHAR NO-UNDO.
  DEF VAR delta AS INT64 INITIAL 0 NO-UNDO.
  DEF VAR mAcctBaseDps AS CHAR NO-UNDO.
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    FIND loan WHERE RECID(loan) = loan-rid NO-LOCK.
    RUN Get_Last_Commi in h_dpspc(RECID(loan),in-op-date,in-op-date,OUTPUT cmm).
    RUN deposit-dep-period in h_dpspc (RECID(loan), in-op-date, local-dep-period, OUTPUT delta).
    delta = IF delta < 0 THEN 0 ELSE delta.

    IF local-summa eq ? THEN DO:
       RUN GetBaseAcct IN h_dpspc(loan.contract,loan.cont-code,in-op-date,OUTPUT mAcctBaseDps).
       FIND FIRST acct WHERE acct.acct eq entry(1,mAcctBaseDps) and acct.currency eq entry(2,mAcctBaseDps) no-lock no-error.
       IF AVAIL(acct) THEN DO:           
          RUN acct-pos IN h_base (acct.acct,acct.currency,in-op-date,in-op-date,gop-status).
          local-summa = ABS(IF acct.currency EQ "" THEN sh-bal ELSE sh-val).
       END.
    END.
        

    FIND LAST comm-rate WHERE comm-rate.commi EQ  cmm
                           AND comm-rate.filial-id = shfilial
                           AND comm-rate.branch-id = ""
                           AND comm-rate.acct EQ  "0" 
                           AND comm-rate.currency EQ loan.currency 
                           AND comm-rate.min-val <= local-summa 
                           AND comm-rate.period LE delta
                           AND comm-rate.since LE in-op-date NO-LOCK NO-ERROR .
    IF AVAIL comm-rate THEN pick-value = STRING(comm-rate.rate-comm).
  END. /* DO */
END PROCEDURE.
/*----------------------------------------------------------------------------------------------  
  6) �_����   ���� � ���� "1 ��� 6 ������� 20 ����"
-----------------------------------------------------------------------------------------------*/
PROCEDURE �_����:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  DEF VAR c1 AS CHAR NO-UNDO.
  DEF VAR c2 AS CHAR NO-UNDO.
  DEF VAR yy AS INT64 NO-UNDO.
  DEF VAR mm AS INT64 NO-UNDO.
  DEF VAR dd AS INT64 NO-UNDO.
  DEF VAR i  AS INT64 NO-UNDO.

   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    FIND loan WHERE RECID(loan) = loan-rid NO-LOCK.
    IF loan.end-date EQ ? THEN DO:
      c2 = "�� ����ॡ������" .
    END. ELSE DO:  
      
      RUN period2dmy(local-dep-period, OUTPUT yy, OUTPUT mm, OUTPUT dd).
      c2 = "".
      IF yy > 0 THEN DO:
        i = yy.
        i = if (i ge 5 and i le 20) or i eq (INT64((i / 10)) * 10) then 3 else ((i - TRUNCATE(i / 10, 0) * 10) / 3) + 1.
        c2 = c2 + STRING(yy) + " " + dat_(i, "�") + " ".
      END.
      IF mm > 0 THEN DO:
        i = mm.
        i = if (i ge 5 and i le 20) or i eq (INT64((i / 10)) * 10) then 3 else ((i - TRUNCATE(i / 10, 0) * 10) / 3) + 1.
        c2 = c2 + STRING(mm) + " " + dat_(i, "�") + " ".
      END.
      IF dd > 0 THEN DO:
        i = dd.
        i = if (i ge 5 and i le 20) or i eq (INT64((i / 10)) * 10) then 3 else ((i - TRUNCATE(i / 10, 0) * 10) / 3) + 1.
        c2 = c2 + STRING(dd) + " " + dat_(i, "�").
      END.    
    END.  
    pick-value = trim(c2).                
  END. /* DO */
END PROCEDURE.
/*----------------------------------------------------------------------------------------------  
  7) �_������ ���� ��������� �������� (���� ������ ����� 1 ����)
-----------------------------------------------------------------------------------------------*/
PROCEDURE �_������:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

  DEF VAR d AS DATE NO-UNDO. 
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    RUN deposit-end-date in h_dpspc (loan-rid, in-op-date, local-dep-period, OUTPUT d).
    pick-value = STRING(d).
  END. /* DO */
END PROCEDURE.



         /*--------------------------------------

            ��楤���, ����室��� �� ��ࠡ�⪥
            蠡��஢ ��⮢

         ---------------------------------------*/





/*----------------------------------------------------------------------------------------------  
  8) �_��������    �����頥� 1, �᫨ �����稪 ���� १����⮬ ������
-----------------------------------------------------------------------------------------------*/
PROCEDURE �_१�����:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.
  DEF VAR vSett AS CHAR NO-UNDO.
   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    FIND FIRST loan WHERE RECID(loan) = loan-rid NO-LOCK NO-ERROR.
    find FIRST person where person.person-id = loan.cust-id no-lock NO-ERROR.   
    vSett = FGetSetting("������",?,"RUS"). /* ��-㬮�砭�� ����頥� rus */
    pick-value = if person.country-id eq vSett then "1" else "0".
  END. /* DO */
END PROCEDURE.


/*----------------------------------------------------------------------------------------------  
  9) �_������    �����頥� ��� ������ , � ���ன ���뢠���� �����
-----------------------------------------------------------------------------------------------*/
PROCEDURE �_�����:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    FIND loan WHERE RECID(loan) = loan-rid NO-LOCK.        
    pick-value = loan.currency.
    if pick-value eq "" then pick-value = FGetSettingEx("�����悠�",?,?,YES).

  END. /* DO */
END PROCEDURE.


/*----------------------------------------------------------------------------------------------  
  10) �_���������  �����頥� ��� �⤥����� , 
                   � ���⥪�� ���ண� �믮������ ����⨥ ������
                   ��� �ਢ離� ��⮢
                   �⤥����� ������ �� ���.४����� ���짮��⥫� "�⤥�����",
                   �����⨢襣� �� �믮������ ��楤���, ���
                   �� �����쭮� ��६����� local-branch-id , �᫨
                   �� ���祭�� �� ᮤ�ন� ����।�������� ���祭��
-----------------------------------------------------------------------------------------------*/
PROCEDURE �_���������:
  DEF INPUT PARAM rid         AS RECID NO-UNDO.
  DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
  DEF INPUT PARAM param-count AS INT64   NO-UNDO.
  DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   
  pick-value = ?.
  DO ON ERROR UNDO, LEAVE:
    pick-value = 
    if local-branch-id = ? then 
      getThisUserXAttrValue("�⤥�����")
    else
      local-branch-id .
  END. /* DO */
 /* message "�_��������� = " pick-value view-as alert-box. */
END PROCEDURE.

/* /*----------------------------------------------------------------------------------------------  */
/*   ������ ��楤���                                                                                */
/* -----------------------------------------------------------------------------------------------*/ */
/* PROCEDURE <Function-name>:                                                                        */
/*   DEF INPUT PARAM rid         AS RECID NO-UNDO.                                                   */
/*   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.                                                   */
/*   DEF INPUT PARAM param-count AS INT64   NO-UNDO.                                                   */
/*   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.                                                   */
/*                                                                                                   */
/*                                                                                                   */
/*   pick-value = ?.                                                                                 */
/*   DO ON ERROR UNDO, LEAVE:                                                                        */
/*                                                                                                   */
/*                                                                                                   */
/*                                                                                                   */
/*   END. /* DO */                                                                                   */
/* END PROCEDURE.                                                                                    */




/*------------------------------------------------------------------------------
  Purpose:   "����஢��" ��ਮ��  
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE period2dmy :
  DEFINE INPUT PARAM in-str AS CHAR.
  DEFINE OUTPUT PARAM out-yy AS INT64.
  DEFINE OUTPUT PARAM out-mm AS INT64.
  DEFINE OUTPUT PARAM out-dd AS INT64.

  DEF VAR j AS INT64.
  DEF VAR s2 AS CHAR.

  ASSIGN
    out-yy = 0
    out-mm = 0
    out-dd = 0
  .

  REPEAT j = 1 TO NUM-ENTRIES(in-str) :
    s2 = ENTRY(j, in-str).
    IF NUM-ENTRIES(s2, "=") = 2 THEN DO:
      CASE ENTRY(1, s2, "=") :
        WHEN "�" THEN out-yy = INT64(ENTRY(2, s2, "=")) NO-ERROR.          
        WHEN "�" THEN out-mm = INT64(ENTRY(2, s2, "=")) NO-ERROR.
        WHEN "�" THEN out-dd = INT64(ENTRY(2, s2, "=")) NO-ERROR.
      END CASE.
    END.
  END.
END PROCEDURE.


/*��⠢�� ������� ��� #778 */
{dps-b2p.i}
/*��⠢�� ������� ��� #778 */
