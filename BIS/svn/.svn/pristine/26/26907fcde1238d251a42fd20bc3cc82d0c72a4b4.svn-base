/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2011 ЗАО "Банковские информационные системы"
     Filename: prt-mess365p.p
      Comment: Перечень отправленных сообщений за период
   Parameters:
         Uses:
      Used by:
      Created: 14.02.2012 kraa 0163310 
     Modified: 12.12.2012 Bashmakov D.V
*/

DEFINE INPUT PARAMETER iParam AS CHARACTER NO-UNDO.

DEFINE VARIABLE vStat         AS CHARACTER NO-UNDO.
DEFINE VARIABLE vFile         AS CHARACTER NO-UNDO.
DEFINE VARIABLE vPackFileName AS CHARACTER NO-UNDO.
DEFINE VARIABLE vNum          AS INT64     NO-UNDO.

{globals.i}
{parsin.def}
{intrface.get prnvd}

{getdates.i}

ASSIGN
   vStat   = GetParamByNameAsChar(iParam,"Статус","")
   vFile   = GetParamByNameAsChar(iParam,"Файл","")
.

RUN Insert_TTName("dateIn",STRING(beg-date,"99.99.99")).                             
RUN Insert_TTName("dateOut",STRING(end-date,"99.99.99")).                             

RUN BeginCircle_TTName ("mess").   
FOR EACH Packet WHERE Packet.Class-Code BEGINS 'PTAX' AND
                      Packet.PackDate GE beg-date AND
                      Packet.PackDate LE end-date /*NO-LOCK,

   FIRST Seance WHERE Seance.SeanceID    EQ Packet.SeanceID AND
                      Seance.direct      EQ "Экспорт" 
*/
NO-LOCK BY Packet.PackDate:
   vPackFileName = GetXAttrValueEx("Packet", STRING(Packet.PacketID), "FileName", "").
   IF NOT CAN-DO(vFile,vPackFileName) OR 
      NOT CAN-DO(vStat,Packet.State) THEN
      NEXT.
   vNum = vNum + 1.                

   RUN Insert_TTName("num[mess]",STRING(vNum)).                             
   RUN Insert_TTName("date[mess]",STRING(Packet.PackDate,"99.99.99")).                             
   RUN Insert_TTName("stat[mess]",Packet.State).                             
   RUN Insert_TTName("file[mess]",vPackFileName).                             

   RUN NextCircle_TTName ("mess").                
END.
RUN EndCircle_TTName ("mess").   

RUN printvd.p ("MESS365", INPUT TABLE ttNames).

{intrface.del}          /* Выгрузка инструментария. */ 
