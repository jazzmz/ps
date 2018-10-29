CLASS TDTInput:
/*
 Версия 1.0 
 Чую реализация отстойная, но лучше ничего пока придумать не могу :-(
*/

DEF PRIVATE VAR cViewType       AS CHARACTER NO-UNDO.
DEF PRIVATE VAR iMainFormHeight AS INTEGER   NO-UNDO.
DEF PRIVATE VAR ifrmButtonRow   AS INTEGER   NO-UNDO.

DEFINE PRIVATE BUTTON btnOk     LABEL "ОК".
DEFINE PRIVATE BUTTON btnCancel LABEL "Отмена".

DEF PRIVATE VAR cTitle AS CHARACTER INITIAL "От:" FORMAT "x(15)"  NO-UNDO.
DEF PRIVATE VAR cTitle2 AS CHARACTER INITIAL "/" FORMAT "x(15)"   NO-UNDO.
DEF PRIVATE VAR cTitle3 AS CHARACTER INITIAL "До:" FORMAT "x(15)" NO-UNDO.
DEF PRIVATE VAR cTitle4 AS CHARACTER INITIAL "/" FORMAT "x(15)"   NO-UNDO.
DEF PRIVATE VAR iMinWidth AS INTEGER INITIAL 15.

DEF PRIVATE VAR cDayBeg AS CHARACTER FORMAT "x(2)"   NO-UNDO.
DEF PRIVATE VAR cMonthBeg AS CHARACTER FORMAT "x(2)" NO-UNDO.
DEF PRIVATE VAR cYearBeg AS CHARACTER FORMAT "x(4)"  NO-UNDO.

DEF PRIVATE VAR cDayEnd AS CHARACTER FORMAT "x(2)"   NO-UNDO.
DEF PRIVATE VAR cMonthEnd AS CHARACTER FORMAT "x(2)" NO-UNDO.
DEF PRIVATE VAR cYearEnd AS CHARACTER FORMAT "x(4)"  NO-UNDO.

DEF PRIVATE VAR cHoursBeg AS CHARACTER FORMAT "x(2)"   NO-UNDO.
DEF PRIVATE VAR cMinutesBeg AS CHARACTER FORMAT "x(2)" NO-UNDO.

DEF PRIVATE VAR cHoursEnd AS CHARACTER FORMAT "x(2)"   NO-UNDO.
DEF PRIVATE VAR cMinutesEnd AS CHARACTER FORMAT "x(2)" NO-UNDO.

DEFINE VAR iX AS INTEGER INITIAL "230" NO-UNDO.
DEFINE VAR iY AS INTEGER INITIAL "55"  NO-UNDO.

DEF PRIVATE VAR dtBegDateTime AS DATETIME INITIAL ? NO-UNDO.
DEF PRIVATE VAR dBegDate      AS DATE               NO-UNDO.

DEF PRIVATE VAR dtEndDateTime AS DATETIME INITIAL ? NO-UNDO.
DEF PRIVATE VAR dEndDate      AS DATE               NO-UNDO.

DEFINE VARIABLE lisSet AS LOGICAL INITIAL FALSE NO-UNDO.


{TDTInput.def}                        /* Вставляем опреление форм */

DEFINE PUBLIC PROPERTY head AS CHARACTER
   GET:
     RETURN FRAME main:TITLE.
   END GET.
   SET (INPUT cProp AS CHARACTER):
      FRAME main:TITLE = cProp.
   END SET.

DEFINE PUBLIC PROPERTY label1 AS CHARACTER
   GET:
     RETURN cTitle.
    END GET.
   SET (INPUT cProp AS CHARACTER):
      cTitle = cProp.
   END SET.

DEFINE PUBLIC PROPERTY label2 AS CHARACTER
      GET:
        RETURN cTitle2.
      END GET.
      SET (INPUT cProp AS CHARACTER):
       cTitle2 = cProp.
      END SET.

DEFINE PUBLIC PROPERTY label3 AS CHARACTER
   GET:
      RETURN cTitle3.
   END GET.
   SET (INPUT cProp AS CHARACTER):
       cTitle3 = cProp.
   END SET.

DEFINE PUBLIC PROPERTY label4 AS CHARACTER
   GET:
     RETURN cTitle4.
   END GET.
   SET (INPUT cProp AS CHARACTER):
     cTitle4 = cProp.
   END SET.

DEFINE PUBLIC PROPERTY X AS INTEGER
   GET:
      RETURN iX.
   END GET.
   SET (INPUT cProp AS INTEGER):
      iX = cProp.
      FRAME main:X = iX.
   END SET.

DEFINE PUBLIC PROPERTY Y AS INTEGER
   GET:
       RETURN iY.
   END GET.
   SET (INPUT cProp AS INTEGER):
      iY = cProp.
      FRAME main:Y = iY.
   END SET.

  DEFINE PUBLIC PROPERTY beg-datetime AS DATETIME
   GET:
      RETURN dtBegDateTime.
   END GET.
   SET (INPUT cProp AS DATETIME):
      dtBegDateTime = cProp.
   END SET.

DEFINE PUBLIC PROPERTY beg-date AS DATE
   GET:
      RETURN dBegDate.
   END.
   SET(INPUT cProp AS DATE):
       dBegDate = cProp.
   END SET.
   
DEFINE PUBLIC PROPERTY end-datetime AS DATETIME
  GET:
    RETURN dtEndDateTime.
  END GET.
  SET (INPUT cProp AS DATETIME):
     dtEndDateTime = cProp.
  END SET.

DEFINE PUBLIC PROPERTY end-date AS DATE
  GET:
    RETURN dEndDate.
  END.
  SET(INPUT cProp AS DATE):
    dEndDate = cProp.
  END SET.

DEFINE PUBLIC PROPERTY isSet AS LOGICAL
     GET:
       RETURN lisSet.
     END GET.
     SET(INPUT cProp AS LOGICAL):
       lisSet = cProp.
     END SET.
      
   
CONSTRUCTOR TDTInput(INPUT viewType AS CHARACTER):
   cViewType = viewType.
   setHeightMainFrm().
   setfrmButtonRow().
   initDefaultDates().
END CONSTRUCTOR.

CONSTRUCTOR TDTInput(INPUT viewType AS INTEGER):
   cViewType = STRING(viewType).
   setHeightMainFrm().
   setfrmButtonRow().
   initDefaultDates().
END CONSTRUCTOR.

METHOD PRIVATE INTEGER setPositions(INPUT hFrame AS HANDLE):
                      /*************************************
                       *                                  *
                       * Функция определения расположения *
                       * объектов в фрэймов               *
                       *                                  *
                       **************************************/
                       
 DEF VAR hObject AS HANDLE  NO-UNDO.
 DEF VAR iBegPos AS INTEGER NO-UNDO.

  hObject=hFrame:FIRST-CHILD.    /* Нашли FieldGroup */
  hObject = hObject:FIRST-CHILD. /* Нашли первый объект */
   
  DO WHILE VALID-HANDLE(hObject):
   IF hObject:NAME = "cTitle" THEN 
    DO:
     iBegPos = LENGTH(hObject:SCREEN-VALUE) + 2.
    END.
    ELSE
      DO:
        hObject:COL = iBegPos.
        iBegPos = iBegPos + hObject:WIDTH-CHARS.
      END.
         hObject = hObject:NEXT-SIBLING.
   END.
 RETURN iBegPos.
END METHOD.


METHOD PRIVATE INTEGER disposeFrmDateBeg():
        DEFINE VARIABLE iformWidth AS INTEGER NO-UNDO.
        
          /* Размещаем ДАТУНАЧ */
          cTitle:SCREEN-VALUE IN FRAME frDateBeg = cTitle.
          iformWidth = setPositions(FRAME frDateBeg:HANDLE).
          FRAME frDateBeg:WIDTH-CHARS = iformWidth.
          FRAME frDateBeg:FRAME = FRAME main:HANDLE.         
/*          ENABLE cDayBeg cMonthBeg cYearBeg WITH FRAME frDateBeg.*/
   RETURN iformWidth.
END METHOD.

METHOD PRIVATE INTEGER disposeFrmTimeBeg(INPUT iPosition AS INTEGER):
           DEFINE VARIABLE iformWidth AS INTEGER NO-UNDO.
          cTitle:SCREEN-VALUE IN FRAME frTimeBeg = cTitle2.
          iformWidth = setPositions(FRAME frTimeBeg:HANDLE).
          FRAME frTimeBeg:COL = iPosition.
          FRAME frTimeBeg:WIDTH-CHARS = iformWidth.
          FRAME frTimeBeg:FRAME = FRAME main:HANDLE.
/*          ENABLE cHoursBeg cMinutesBeg WITH FRAME frTimeBeg.*/
     RETURN iformWidth.
END METHOD.

METHOD PRIVATE INTEGER disposeFrmDateEnd():
        DEFINE VARIABLE iformWidth AS INTEGER NO-UNDO.
        cTitle:SCREEN-VALUE IN FRAME frDateEnd = cTitle3.
        iformWidth = setPositions(FRAME frDateEnd:HANDLE).
        FRAME frDateEnd:WIDTH-CHARS = iformWidth.
        FRAME frDateEnd:FRAME = FRAME main:HANDLE.
/*        ENABLE cDayEnd cMonthEnd cYearEnd WITH FRAME frDateEnd.*/
        RETURN iformWidth.
END METHOD.

METHOD PRIVATE INTEGER disposeFrmTimeEnd(INPUT iPosition AS INTEGER):
                DEFINE VARIABLE iformWidth AS INTEGER NO-UNDO.
                cTitle:SCREEN-VALUE IN FRAME frTimeEnd = cTitle4.
                iformWidth = setPositions(FRAME frTimeEnd:HANDLE).
                FRAME frTimeEnd:WIDTH-CHARS = iformWidth.
                FRAME frTimeEnd:COL = iPosition.
                FRAME frTimeEnd:FRAME = FRAME main:HANDLE.
/*                ENABLE cHoursEnd cMinutesEnd WITH FRAME frTimeEnd.*/
        RETURN iformWidth.
END METHOD.

METHOD PRIVATE VOID disposeFrames():
  DEFINE VARIABLE iMainFrameWidth AS INTEGER INITIAL 0 NO-UNDO.
  DEFINE VARIABLE iSplitPos AS INTEGER INITIAL 0 NO-UNDO.
  CASE cViewType:
      WHEN "2" THEN
                            DO:
                                 /* Размещаем ВРЕМЯНАЧ */
                                iMainFrameWidth = disposeFrmDateBeg().
                                iSplitPos = iMainFrameWidth.
                                iMainFrameWidth = iMainFrameWidth + disposeFrmTimeBeg(iSplitPos + 1).

                                /* Размещаем ВРЕМЯКОН */
                                iSplitPos = disposeFrmDateEnd().
                                disposeFrmTimeEnd(iSplitPos + 1).
                                
                          END.
        WHEN "4" THEN
                            DO:
                                 /* Размещаем ДАТУНАЧ */
                                iMainFrameWidth = disposeFrmDateBeg().

                                /* Размещаем ДАТУКОН */
                                disposeFrmDateEnd().
                            END.
        WHEN "6" THEN
                                DO:
                                         /* Размещаем ВРЕМЯНАЧ */
                                        iMainFrameWidth = disposeFrmTimeBeg(1).
                                        /* Размещаем ВРЕМЯКОН */
                                        disposeFrmTimeEnd(1).
                                END.
        WHEN "3" THEN
                                DO:
                                        iMainFrameWidth = disposeFrmDateBeg().
                                END.
        WHEN "5" THEN
                                DO:
                                        iMainFrameWidth = disposeFrmTimeBeg(1).
                                END.
        WHEN "7" THEN
                                DO:
                                        iMainFrameWidth = disposeFrmDateBeg().
                                        iSplitPos = iMainFrameWidth + 1.
                                        iMainFrameWidth = iMainFrameWidth + disposeFrmTimeBeg(iSplitPos + 1).
                                END.
        END CASE.
        
        FRAME main:WIDTH-CHARS = MAXIMUM(iMainFrameWidth + 3,iMinWidth).
        FRAME frmButton:COL = ROUND((FRAME main:WIDTH-CHARS - FRAME frmButton:WIDTH-CHARS) / 2,0).
        FRAME frmButton:ROW = ifrmButtonRow.
        FRAME frmButton:FRAME = FRAME main:HANDLE.
        FRAME frmButton:SCROLLABLE = no.
        FRAME main:SCROLLABLE = no.
        FRAME main:HEIGHT-CHARS = iMainFormHeight.
        
        CASE cViewType:
          WHEN "2" THEN 
            DO:
              ENABLE cDayBeg cMonthBeg cYearBeg WITH FRAME frDateBeg.
              ENABLE cHoursBeg cMinutesBeg WITH FRAME frTimeBeg.
              ENABLE cDayEnd cMonthEnd cYearEnd WITH FRAME frDateEnd.
              ENABLE cHoursEnd cMinutesEnd WITH FRAME frTimeEnd.
            END.
          WHEN "4" THEN
            DO:
              ENABLE cDayBeg cMonthBeg cYearBeg WITH FRAME frDateBeg.
              ENABLE cDayEnd cMonthEnd cYearEnd WITH FRAME frDateEnd.
            END.
          WHEN "6" THEN
            DO:
              ENABLE cHoursBeg cMinutesBeg WITH FRAME frTimeBeg.
              ENABLE cHoursEnd cMinutesEnd WITH FRAME frTimeEnd.
            END.
           WHEN "3" THEN
             DO:
               ENABLE cDayBeg cMonthBeg cYearBeg WITH FRAME frDateBeg.
             END.
           WHEN "5" THEN
             DO:
               ENABLE cHoursBeg cMinutesBeg WITH FRAME frTimeBeg.
             END.
           WHEN "7" THEN
             DO:
               ENABLE cDayBeg cMonthBeg cYearBeg WITH FRAME frDateBeg.
               ENABLE cHoursBeg cMinutesBeg WITH FRAME frTimeBeg.
             END.
        END CASE.
        ENABLE ALL WITH FRAME frmButton.
        DISPLAY WITH FRAME main.
END METHOD.

METHOD PUBLIC VOID show():

DEFINE VARIABLE oSysClass AS TSysClass NO-UNDO.
oSysClass = new TSysClass().

cDayBeg:SCREEN-VALUE IN FRAME frDateBeg=oSysClass:DATETIME2STR(beg-datetime,"%d").
cMonthBeg:SCREEN-VALUE IN FRAME frDateBeg=oSysClass:DATETIME2STR(beg-datetime,"%m").
cYearBeg:SCREEN-VALUE IN FRAME frDateBeg=oSysClass:DATETIME2STR(beg-datetime,"%Y").
cHoursBeg:SCREEN-VALUE IN FRAME frTimeBeg=oSysClass:DATETIME2STR(beg-datetime,"%h").
cMinutesBeg:SCREEN-VALUE IN FRAME frTimeBeg=oSysClass:DATETIME2STR(beg-datetime,"%j").

cDayEnd:SCREEN-VALUE IN FRAME frDateEnd=oSysClass:DATETIME2STR(end-datetime,"%d").
cMonthEnd:SCREEN-VALUE IN FRAME frDateEnd=oSysClass:DATETIME2STR(end-datetime,"%m").
cYearEnd:SCREEN-VALUE IN FRAME frDateEnd=oSysClass:DATETIME2STR(end-datetime,"%Y").
cHoursEnd:SCREEN-VALU IN FRAME frTimeEnd=oSysClass:DATETIME2STR(end-datetime,"%h").
cMinutesEnd:SCREEN-VALUE IN FRAME frTimeEnd =oSysClass:DATETIME2STR(end-datetime,"%j").

disposeFrames().

ON CHOOSE OF btnOk IN FRAME frmButton
  DO:
    setInput2Prop().
  END.
WAIT-FOR CHOOSE OF btnOk OR CHOOSE OF btnCancel.
END METHOD.

METHOD PUBLIC VOID show(INPUT hFrameHandle AS HANDLE):
/********************************************
 *                                          *
 * Метод размещает форму в указанном фрэйме *
 *                                          *
 *********************************************/
  FRAME main:FRAME = hFrameHandle.
  show().
END METHOD.

METHOD PRIVATE VOID setHeightMainFrm():
  IF cViewType = "2" OR cViewType = "4" OR cViewType = "6" THEN iMainFormHeight = 8. ELSE iMainFormHeight = 7.   
END METHOD.

METHOD PRIVATE VOID setfrmButtonRow():
  IF cViewType = "3" OR cViewType = "5" OR cViewType = "7" THEN ifrmButtonRow = 4. ELSE ifrmButtonRow = 6.
END METHOD.

METHOD PROTECTED VOID setInput2Prop():
   
     beg-datetime=DATETIME(INTEGER(cMonthBeg:SCREEN-VALUE IN FRAME frDateBeg),INTEGER(cDayBeg:SCREEN-VALUE IN FRAME frDateBeg),INTEGER(cYearBeg:SCREEN-VALUE IN FRAME frDateBeg),INTEGER(cHoursBeg:SCREEN-VALUE IN FRAME frTimeBeg),INTEGER(cMinutesBeg:SCREEN-VALUE IN FRAME frTimeBeg)).
     end-datetime=DATETIME(INTEGER(cMonthEnd:SCREEN-VALUE IN FRAME frDateEnd),INTEGER(cDayEnd:SCREEN-VALUE IN FRAME frDateEnd),INTEGER(cYearEnd:SCREEN-VALUE IN FRAME frDateEnd),INTEGER(cHoursEnd:SCREEN-VALUE IN FRAME frTimeEnd),INTEGER(cMinutesEnd:SCREEN-VALUE IN FRAME frTimeEnd)).

     beg-date = DATE(INTEGER(cMonthBeg:SCREEN-VALUE IN FRAME frDateBeg),INTEGER(cDayBeg:SCREEN-VALUE IN FRAME frDateBeg),INTEGER(cYearBeg:SCREEN-VALUE IN FRAME frDateBeg)).
     end-date = DATE(INTEGER(cMonthEnd:SCREEN-VALUE IN FRAME frDateEnd),INTEGER(cDayEnd:SCREEN-VALUE IN FRAME frDateEnd),INTEGER(cYearEnd:SCREEN-VALUE IN FRAME frDateEnd)).

    isSet = TRUE.
END METHOD.

METHOD PROTECTED VOID initDefaultDates():
      /******************************
       * Инициализируем значение дат*
       * по-умолчанию               *
       *******************************/

 beg-datetime = TODAY - 1.
 beg-date = DATE(beg-datetime).

 end-datetime = TODAY.
 end-date = DATE(beg-datetime).

END METHOD.     


END CLASS.

