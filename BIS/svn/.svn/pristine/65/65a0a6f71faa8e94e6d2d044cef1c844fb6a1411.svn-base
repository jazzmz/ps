{pirsavelog.p}

{globals.i}                                 /* глобальные переменные         */
{chkacces.i}
{intrface.get xclass}
&SCOP TEST YES

&IF DEFINED(NEW_1256) &THEN
   &SCOP NEW_1256 YES
&ENDIF
&IF "{&TEST}" EQ "YES" &THEN
   DEF STREAM test.
   OUTPUT STREAM test TO "test.pp".
&ENDIF

&IF defined(ELIT_POL) EQ 0 &THEN
   &SCOP ELIT_POL NO
&ELSE
   &SCOP ELIT_POL YES
&ENDIF

{pirpp-uni.var}                                /* определение переменных        */
{pirpo-uni_2.var}

DEF VAR beg-row AS INT NO-UNDO.
DEF VAR end-row AS INT NO-UNDO.

&IF DEFINED(FRM_PRN) EQ 0 &THEN
   {po-uni.frm}                                /* определение фрейма            */
&ELSE
   {{&FRM_PRN}}
&ENDIF

{pp-uni.err}                                /* сообщения об ошибках          */
{pirpp-uni.prg}                     /* описание стандартных процедур */
{po-uni.prg}

{pp-uni.chk}
                                       /* проверка входных данных       */
{po-uni.run}
{pp-uni.run}                                /* непосредственно расчет        */
&IF DEFINED(in-el) NE 0 &THEN   /* для электронного */
{{&in-el} &in-run=YES}
&ENDIF

&IF "{&TEST}" EQ "YES" &THEN
   OUTPUT STREAM test CLOSE.
&ENDIF
PROCEDURE GetHeader:
   RUN DefHeader.
   ASSIGN
      NameOrder  = "ПЛАТЕЖНЫЙ ОРДЕР N"
      NumberForm = "0401066"
   .
END PROCEDURE.

{nal_name.i}

{strtout3.i &cols=80 &option=Paged}  /* подготовка к выводу           */
{pirpo-uni.prn}
IF iDoc EQ 1 THEN DO:

   end-row = 72.
   beg-row =  1.
   theUserID = OP.user-id.
   FIND FIRST _user WHERE _user._userid EQ theUserID NO-LOCK NO-ERROR. 
   IF AVAILABLE (_user) THEN DO:
     IF _user._user-name NE ? THEN
          theUser = _user._user-name. 
   END.
   theKontr ="".

{pirlazerprn.lib &DATARETURN = 0401066_stamp.prg
              &FORM-DOC   = "661"
              &ELIT_POL   = "{&ELIT_POL}"
              &POSTAMP_NI = YES
              &USER_SIGN_XY  = "VALUE('/X:3350 /Y:' + STRING((end-row - beg-row - 29) * 75 - 550))"
              {&*}} 


END.
{endout3.i  &nofooter=yes}                   /* завершение вывода             */
