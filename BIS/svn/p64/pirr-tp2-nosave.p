{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pirr-tp2.p,v $ $Revision: 1.4 $ $Date: 2010-03-25 10:01:02 $
Copyright     : ��� �� "�p������������"
���������    : r-tp2.p
��稭�       : �ਪ�� �64 �� 25.10.2005
�����祭��    : �ਫ������ �8
���� ����᪠ : ��/�����/��室�� ���/���� ��⮢(�ਫ������ 6..9), ��ଠ 101/���� ��⮢:�ਫ 8,9
����         : ???
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.3  2007/10/18 07:42:24  anisimov
���������     : no message
���������     :
���������     : Revision 1.2  2007/08/17 07:22:26  Lavrinenko
���������     : 1. �������� �⠭����� ��������� 2. �ந������� ࠡ��� ��� ���४⭮�� �뭮� norm-end.i norm-rpt.i
���������     :
------------------------------------------------------ */

def var in-data-id  like DataBlock.Data-Id no-undo.
def var vZoTmpChar   as char no-undo.
def var vTmpPerChar  as char no-undo.
def var vTmpBegDate  as date no-undo.
def var vTmpEndDate  as date no-undo.
def var vOldShSuff   as char no-undo.

{norm.i new}

{intrface.get acct}
{r-tpa.i {&*} }

assign
   in-beg-date = gbeg-date
   in-end-date = gend-date
   in-branch-id = dept.branch.

{norm-beg.i &title = "'��������� ������'" &nofil = yes &is-branch = yes}

/* assign
   in-beg-date
   in-end-date. */
   
&glob beg-date in-beg-date
{num-pril.i 7 "���������_���������||��_������_���������_�����������_����������_���������||��_&1"}
{r-tp.pro &stream = "stream fil " {&*} } /* ����७��� ��楤��� - ��� ������ r - ���� */


if in-beg-date = date(1,1,year(in-beg-date))       /* 01 ﭢ��� */
then do:
   assign
      vTmpBegDate = in-beg-date
      vTmpEndDate = in-end-date
      vTmpPerChar = {per2str in-beg-date in-end-date}.  /* ��ਮ� */

   case vTmpPerChar:
      when "�����" then assign
         vTmpBegDate = date(month(in-Beg-Date - 1),1,year(in-Beg-Date - 1))
         vTmpEndDate = in-Beg-Date - 1.
      when "����⠫" then assign
         vTmpBegDate = date(month(in-Beg-Date - 1) - 2,1,year(in-Beg-Date - 1))
         vTmpEndDate = in-Beg-Date - 1.
      when "���㣮���" then assign
         vTmpBegDate = date(month(in-Beg-Date - 1) - 5,1,year(in-Beg-Date - 1))
         vTmpEndDate = in-Beg-Date - 1.
      when "���" then assign
         vTmpBegDate = date( 1, 1,year(in-Beg-Date) - 1)
         vTmpEndDate = date(12,31,year(in-Beg-Date) - 1).
   END CASE.

   &IF DEFINED(spod) = 0 &THEN

   if year(vTmpEndDate) <> year(in-Beg-Date)         /* ��� ��ਮ� */
      and vTmpPerChar <> "���"  /* �� ��� */
   then
   do iClass = 2 to nCntClass :
      in-dataClass-Id = entry(iClass,s).


      if can-do("*cur,*pos,*post",in-DataClass-id)   /* ��� ����� */
      then do:
         IF NOT gRemote THEN   /* not AppServer */
         do on error  undo, LEAVE
            on endkey undo, LEAVE
            with frame bbb:
            update vTmpSuffChar with frame bbb .     /* ��।������ suff */
         end.
         hide frame bbb.
         IF not (keyfunc(lastkey) eq "GO" or
                 keyfunc(lastkey) eq "RETURN")
         THEN return.
         ASSIGN
            vPr0101Logic = true
            iClass       = nCntClass .
      end.
   end.
   &ENDIF
end.

{justamin}

/*
{pirraproc.def}
&GLOB filename arch_file_name
{pirraproc.i &arch_file_name="pril_7g.txt"}
*/
{setdest.i &stream = "stream fil " &cols = {&WIDTH}}
sh-branch-id = in-branch-id.


&IF DEFINED(spod) = 0 &THEN
if in-end-date = date(12,31,year(in-beg-date)) then do:
   if sh-suff = ""      then vZoTmpChar = " ( � ��⮬ �� )".
   if sh-suff = "@zo"   then vZoTmpChar = " ( ⮫쪮 �� )".
   if sh-suff = "@nzo"  then vZoTmpChar = " ( ��� ��� �� )".
end.
&ENDIF

do iClass = 2 to nCntClass :
   in-dataClass-Id = entry(iClass,s).

   run sv-get.p (in-dataClass-Id, in-branch-id, in-beg-date, in-end-date, output in-data-id).

   if in-data-id <> ? then do:

      find last DataBlock where DataBlock.Data-Id eq in-Data-Id no-lock no-error.
      find DataClass where DataClass.DataClass-id = entry(1,DataBlock.DataClass-id,'@') no-lock no-error.
      find branch of DataBlock no-lock no-error.

      assign
         per = {term2str DataBlock.Beg-Date DataBlock.End-Date}
         type = substr(in-dataClass-Id,1,1)
      .

      if vPr0101Logic and can-do("*cur,*pos,*post",in-dataClass-Id)
      then do:
         assign
            vOldShSuff = sh-suff
         &IF DEFINED(spod) = 0 &THEN
            sh-suff    = vTmpSuffChar
         &ENDIF
         .
         run sv-get.p  (input DataClass.DataClass-id, DataBlock.Branch-Id, vTmpBegDate, vTmpEndDate, output out-data-id).
         sh-suff    = vOldShSuff.
      end.
      else run sv-prev.p (input DataClass.DataClass-id, DataBlock.Branch-Id, DataBlock.beg-date , DataBlock.End-date , output out-data-id).
      find last b-DataBlock where b-DataBlock.data-Id eq out-data-id no-lock no-error.

      &IF DEFINED(spod) > 0 &THEN
      IF DataBlock.Beg-Date = DATE(01,01,YEAR(DataBlock.Beg-Date)) AND 
         DataBlock.End-Date = DATE(12,31,YEAR(DataBlock.End-Date)) THEN
      DO:
         sh-suff = "@zo".
         RUN sv-get.p (input  DataClass.DataClass-id, 
                              DataBlock.Branch-Id, 
                              DATE(12,31,YEAR(DataBlock.End-date) - 1), 
                              DATE(12,31,YEAR(DataBlock.End-date) - 1), 
                       output out-data-id).
         sh-suff = "".
         find last s-DataBlock where s-DataBlock.data-Id eq out-data-id no-lock no-error.
         mIsYear = YES.
      END.
      &ENDIF

      if iClass = 2 then do:
         run stdhdr_p.p (output xResult, DataBlock.beg-date,DataBlock.end-date,
                     "{&width}," + vNumPril + ",{&in-LA-NCN1}," + vHdrPril + "_" + vZoTmpChar + ",yes,YES").
      end.
      else PAGE.

	&IF DEFINED(ap) &THEN
      {r-tp-ap.i {&*} }
    &ENDIF
      {r-tpb.i &stream = "stream fil " {&*} }
   end.
   else do:
      run normdbg in h_debug (0,"�訡��","���������� ������� ����� �� ������ ~"" + in-DataClass-id + "~"!").
   end.
end.

{intrface.del acct}
if entry(1,s) = "1" then do:
 /*  {signp8p9.i &stream = "stream fil " &department = branch } */
   {signatur.i &stream = "stream fil " &department = branch  &f101=yes}
end.
{preview.i &stream = "stream fil "}

{norm-end.i &nopreview = yes &nofil = yes}

