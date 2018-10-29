USING Progress.Lang.*.

CLASS Tkurs INHERITS TSysClass:

/***********************************************************
*                                                          *
* ����� ��� �࠭���� ��⮤�� �� ����� ����-���ᮢ ����� *
* ����� ��᫥������ ����� Tsysclass                   *
*                                                          *
***********************************************************/

METHOD PUBLIC DECIMAL getKrossKurs(INPUT cType AS CHARACTER, INPUT iCode1 AS INTEGER, INPUT iCode2 AS INTEGER ,INPUT dDate AS DATE):

                            /*********************** *******************************************
                             *                                                                 *
                             *  ��⮤�� ���� ����/���� ��� ������  cType(Buy ��� Sell)    *
                             * ��� ���� iCode1/iCode2 �� ���� dDate                            *
                             *                                                                 *
                             *******************************************************************/

                        DEF VAR kursB2 AS DECIMAL.
                        DEF VAR kursS2 AS DECIMAL.
                        DEF VAR KursB1 AS DECIMAL. 
                        DEF VAR KursS1 AS DECIMAL.
                        kursB1 = ROUND((getKursByType("�ূ�脁",iCode1,dDate) * 0.995),4).
  	 	        kursS1 = ROUND((getKursByType("�ূ���",iCode1,dDate) * 1.005),4).
                        kursB2 = ROUND((getKursByType("�ূ�脁",iCode2,dDate) * 0.995),4).
  	 	        kursS2 = ROUND((getKursByType("�ূ���",iCode2,dDate) * 1.005),4).

			if KursB1 > getCBRKurs(iCode1,dDate) then KursB1 = getCBRKurs(iCode1,dDate).
			if KursS1 < getCBRKurs(iCode1,dDate) then KursS1 = getCBRKurs(iCode1,dDate).
			if KursB2 > getCBRKurs(iCode2,dDate) then KursB2 = getCBRKurs(iCode2,dDate).
			if KursS2 < getCBRKurs(iCode2,dDate) then KursS2 = getCBRKurs(iCode2,dDate).

/*  	 	        Message KursB1.
			Message kursS1.
			Message kursB2.
  			Message kursS2.*/
			
			IF (kursB2<>0) AND (kursS2<>0) THEN
	 		  do.
			     if cType = "Buy" then RETURN (KursB1 / KursS2).
			     if cType = "Sell" then RETURN (KursS1 / KursB2).			 
			  END.

END METHOD.

METHOD PUBLIC DECIMAL getPlastikKrossKurs(INPUT cType AS CHARACTER, INPUT iCode1 AS INTEGER, INPUT iCode2 AS INTEGER ,INPUT dDate AS DATE):

                            /*********************** *******************************************
                             *                                                                 *
                             *  ��⮤�� ���� ����/���� ��� ������  cType(Buy ��� Sell)    *
                             * ��� ���� iCode1/iCode2 �� ���� dDate ��� ����⨪�               *
                             *                                                                 *
                             *******************************************************************/

                        DEF VAR kurs1 AS INTEGER.
                        DEF VAR kurs2 AS INTEGER.
                        kurs1 = getCBRKurs(iCode1,dDate + 1).
			kurs2 = getCBRKurs(iCode2,dDate + 1).
			IF (kurs1<>0) AND (kurs2<>0) THEN
			  do.
			   if cType = "Buy" then RETURN ((kurs1 * 0.995) / (Kurs2 * 1.005)).
			   if cType = "Sell" then RETURN ((kurs1 * 1.005) / (Kurs2 * 0.995)).			 
			  END.
END METHOD.

END CLASS