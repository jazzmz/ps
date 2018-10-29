&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*------------------------------------------------------------------------
    Library     : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{intrface.get data}
{intrface.get db2l}
{intrface.get xclass}   /* Библиотека инструментов метасхемы. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-CliExist) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CliExist Method-Library 
FUNCTION CliExist RETURNS LOGICAL
  (in-cat AS CHAR,in-id AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetCliName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetCliName Method-Library 
FUNCTION GetCliName RETURNS CHARACTER
  (in-cat AS CHAR,in-id AS CHAR,
   OUTPUT pAddr AS CHAR,
   OUTPUT pINN AS CHAR,
   OUTPUT pKPP AS CHAR,
   INPUT-OUTPUT pType AS CHAR,
   OUTPUT pCode AS CHAR,
   OUTPUT pAcct AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-fill-tt-cust-role) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-tt-cust-role Method-Library 
PROCEDURE fill-tt-cust-role :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER iH AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER iAcctType AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER iPrior AS CHARACTER  NO-UNDO.

DEFINE VARIABLE vCat AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vId AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vUpTable AS HANDLE     NO-UNDO.
DEFINE VARIABLE vInstance AS HANDLE     NO-UNDO.
DEFINE VARIABLE vOk AS LOGICAL    NO-UNDO.
DEFINE VARIABLE vIsGetLocal AS LOGICAL    NO-UNDO.
DEFINE VARIABLE vHB AS HANDLE     NO-UNDO.
DEFINE VARIABLE vHF AS HANDLE     NO-UNDO.

DEFINE VARIABLE vCustName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vINN AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vKPP AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vAddress AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vType AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vCode AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vAcct AS CHARACTER  NO-UNDO.

vInstance = iH.
vUpTable = WIDGET-HANDLE(GetInstanceProp(iH,"__UpTable")).
DO WHILE VALID-HANDLE(vUpTable):
   vInstance = vUpTable:BUFFER-HANDLE.
   IF GetInstanceProp(vInstance,"__Table") EQ 
      GetInstanceProp(iH,"file-name") THEN
      LEAVE.
   vInstance:FIND-FIRST().
   vUpTable = WIDGET-HANDLE(GetInstanceProp(vInstance,"__UpTable")).
END.

IF GetInstanceProp(vInstance,"__Table") NE GetInstanceProp(iH,"file-name") THEN
DO:
   vIsGetLocal = YES.
   RUN GetInstance(GetClassObject(GetInstanceProp(iH,"file-name"),
                                  GetInstanceProp(iH,"Surrogate")),
                   GetInstanceProp(iH,"Surrogate"),
                   OUTPUT vInstance,OUTPUT vOk).
END.

vHF = GetProperty(vInstance,
                  "loan-acct:acct",
                  "acct-type = '" + iAcctType + "'").
IF VALID-HANDLE(vHF) THEN
   vHF = GetProperty(vInstance,
                     "loan-acct:lacct:cust-cat",
                     "acct = '" + vHF:STRING-VALUE + "'").
IF VALID-HANDLE(vHF) THEN
DO:
   ASSIGN
      vHB = vHF:BUFFER-HANDLE
      vCat = vHF:BUFFER-VALUE
      vID = vHB:BUFFER-FIELD("cust-id"):BUFFER-VALUE
      vCustName = GetCliName(
         vCat,vID,
         OUTPUT vAddress,
         OUTPUT vINN,
         OUTPUT vKPP,
         INPUT-OUTPUT vType,
         OUTPUT vCode,
         OUTPUT vAcct)
         iH:BUFFER-FIELD("cust-cat"):BUFFER-VALUE = vCat
         iH:BUFFER-FIELD("cust-id"):BUFFER-VALUE = vID
         iH:BUFFER-FIELD("cust-name"):BUFFER-VALUE = vCustName
         iH:BUFFER-FIELD("Address"):BUFFER-VALUE = vAddress
         iH:BUFFER-FIELD("INN"):BUFFER-VALUE = vINN
         iH:BUFFER-FIELD("KPP"):BUFFER-VALUE = vKPP
         iH:BUFFER-FIELD("cust-code-type"):BUFFER-VALUE =vType 
         iH:BUFFER-FIELD("cust-code"):BUFFER-VALUE = vCode
         iH:BUFFER-FIELD("corr-acct"):BUFFER-VALUE = vAcct
      .
END.

IF VALID-HANDLE(vInstance) AND vIsGetLocal THEN
   RUN DelEmptyInstance(vInstance).
{intrface.del}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-CliExist) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CliExist Method-Library 
FUNCTION CliExist RETURNS LOGICAL
  (in-cat AS CHAR,in-id AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE vExist AS LOGICAL    NO-UNDO.

IF NOT {assigned in-cat} OR NOT {assigned in-id} THEN
   RETURN ?.

CASE in-cat:
   WHEN "Ю" THEN
      vExist = GetBufferValue("cust-corp",
                             "WHERE cust-id eq " + in-id,
                             "cust-id") NE ?.
   WHEN "Б" THEN
      vExist = GetBufferValue("banks",
                             "WHERE bank-id eq " + in-id,
                             "bank-id") NE ?.
   WHEN "Ч" THEN
      vExist = GetBufferValue("person",
                             "WHERE person-id eq " + in-id,
                             "person-id") NE ?.
   WHEN "В" THEN
      vExist = GetBufferValue("branch",
                             "WHERE branch-id eq '" + in-id + "'",
                             "branch-id") NE ?.
   WHEN "Э" THEN DO:
      vExist = GetCodeVal("issue_cod",in-cat + ',' + in-id) NE ?.
   END.
END CASE.

RETURN vExist.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetCliName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetCliName Method-Library 
FUNCTION GetCliName RETURNS CHARACTER
  (in-cat AS CHAR,in-id AS CHAR,
   OUTPUT pAddr AS CHAR,
   OUTPUT pINN AS CHAR,
   OUTPUT pKPP AS CHAR,
   INPUT-OUTPUT pType AS CHAR,
   OUTPUT pCode AS CHAR,
   OUTPUT pAcct AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE vFileName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vName AS CHARACTER EXTENT 3 NO-UNDO.
DEFINE VARIABLE vI AS INT64    NO-UNDO.
   vI = INDEX("ЮЧБВ",in-cat).
   IF vI EQ 0 OR NOT {assigned in-id} THEN RETURN "".
   vFileName = ENTRY(vI,"cust-corp,person,banks,branch").
   pKPP = GetXattrValue(vFileName,in-id,"КПП").
   pINN = GetXattrValue(vFileName,in-id,"ИНН").
   IF in-cat = "Б" THEN
   DO:
      pType = GetBufferValue("Banks-code",
                             "WHERE bank-id eq " + in-id + " AND 
                                    bank-code-type BEGINS '" + pType + "'",
                             "bank-code-type").
      IF pType EQ ? THEN
         pType = GetBufferValue("Banks-code",
                           "WHERE bank-id eq " + in-id,
                           "bank-code-type").
   END.
   ELSE IF in-cat = "Ч" THEN
      pType = GetBufferValue("person",
                             "WHERE person-id eq " + in-id,
                             "document-id").
   pCode =
      IF in-cat = "Б" THEN
         GetBufferValue("Banks-code",
                        "WHERE bank-id eq " + in-id + " AND 
                               bank-code-type eq '" + pType + "'",
                        "bank-code")
         ELSE 
            (IF in-cat = "Ч" THEN
               GetBufferValue("person",
                              "WHERE person-id eq " + in-id,
                              "document")
               ELSE "").
   pAddr = 
      IF in-cat = "Ю" THEN
         ENTRY(1,
               GetBufferValue("cust-corp",
                              "WHERE cust-id EQ " + in-id,
                              "addr-of-low"),
               CHR(1)) + 
         ENTRY(2,
               GetBufferValue("cust-corp",
                              "WHERE cust-id EQ " + in-id,
                              "addr-of-low"),
               CHR(1))
         ELSE (IF in-cat = "Ч" THEN
            REPLACE(
               REPLACE(GetBufferValue("person",
                                      "WHERE person-id EQ " + in-id,
                                      "address"),
                       ","," "),
               CHR(1)," ")
            ELSE (IF in-cat = "Б" THEN
               GetBufferValue("banks",
                              "WHERE bank-id EQ " + in-id,
                              "mail-address")
               ELSE
                  GetBufferValue("branch",
                                "WHERE branch.branch-id EQ '" + in-id + "'",
                                "address"))).
   IF in-cat = "Б" AND pType = "МФО-9" THEN
      pAcct = GetBufferValue("banks-corr",
                             "WHERE bank-corr EQ '" + in-id + "'",
                             "corr-acct").
   ELSE IF in-cat EQ "Ю" THEN
      pAcct = getBufferValue ("cust-corp",
                              "WHERE cust-id EQ " + in-id,
                              "BenAcct").
   ELSE IF in-cat EQ "Ч" THEN
      pAcct = getBufferValue ("person",
                              "WHERE person-id EQ " + in-id,
                              "BenAcct").
                              
   CASE in-cat:
      WHEN "В" THEN 
      DO: 
         pCode = GetXattrValue(vFileName,in-id,"БанкМФО").
         pAcct = GetXattrValue(vFileName,in-id,"КорСч").
         pAddr = GetBufferValue("branch",
                                "WHERE branch.branch-id EQ '" + in-id + "'",
                                "address").
         RETURN GetBufferValue("branch",
                                "WHERE branch.branch-id EQ '" + in-id + "'",
                                "short-name").
      END.
      OTHERWISE DO:
         IF in-id NE "" THEN
            RUN GetCustName IN h_base(in-cat,in-id,?,
                                   OUTPUT vName[1],
                                   OUTPUT vName[2],
                                   INPUT-OUTPUT vName[3]).
         ELSE
            vName = "".
         pINN = vName[3].

/* Оригинал от биса был: RETURN TRIM(vName[1]) + " " + TRIM(vName[2]). */

/*стало:     */
	RETURN trim(TRIM(vName[1]) + " " + TRIM(vName[2])).

/* правка связана с ошибкой выгрузки сообщений по 365п, в конце возвращаемой строки появляется знак " " */
      END.
   END CASE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

