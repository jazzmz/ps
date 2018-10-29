{pirsavelog.p}

{globals.i}                                 /* глобальные переменные         */
{chkacces.i}
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

{pp-uni.var}                                /* определение переменных        */
{pirpo-uni.var}

&IF DEFINED(FRM_PRN) EQ 0 &THEN
   {po-uni.frm}                                /* определение фрейма            */
&ELSE
   {{&FRM_PRN}}
&ENDIF

{pp-uni.err}                                /* сообщения об ошибках          */
{pp-uni.prg}                     /* описание стандартных процедур */
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
&IF DEFINED(in-el) EQ 0 &THEN
&IF defined(NEW_1256) NE 0 &THEN
{lazerprn.lib &DATARETURN = 0401066.prg
              &FORM-DOC   = "661"
              &ELIT_POL   = "{&ELIT_POL}"
}
&ELSE
 {lazerprn.lib &DATARETURN = 0401066.prg
              &FORM-DOC   = "66"
              &FORM-DOC1  = "662"
              &ELIT_POL   = "{&ELIT_POL}"
}
&ENDIF
&ENDIF
END.
{endout3.i  &nofooter=yes}                   /* завершение вывода             */
