using Progress.Lang.*.

CLASS TDocCollectBase:

/*************************

  �����-�������� ���㬥�⮢, 㤮���⢮����� 㪠����� �᫮���.
  ����: ��᫮� �. �.
  ��� ᮧ�����: 25.04.2009
  ��� ����䨪�樨: 22.07.2009.

**************************/

/*** PRIVATE ���� ������ ***/

DEFINE PROTECTED BUFFER bOp FOR op.                                                                                   /* ������ ���㬥�⮢ */
DEFINE PROTECTED BUFFER bOpEntry FOR op-entry.                                                               /* ������ �஢���� */

/********************** ��������� ��������� *******************/
{set-prop.i &aa="date-beg" &bb="ddate-beg" &cc="DATE" &init="01/01/1900"}                       /* ��砫� �⡮� */
{set-prop.i &aa="date-end" &bb="ddate-end" &cc="DATE" &init="01/01/2100"}                      /* ����� �⡮�    */

{set-prop.i &aa="beg-op" &bb="ibeg-op" &cc="INTEGER" &init="?"}                                       /* ��砫� �⡮� */
{set-prop.i &aa="end-op" &bb="iend-op" &cc="INTEGER" &init="?"}                                       /* ����� �⡮�    */

{set-prop.i &aa="beg-status" &bb="cbeg-status" &cc="CHARACTER" &init="?"}                      /* ��砫� �⡮� */
{set-prop.i &aa="end-status" &bb="cend-status" &cc="CHARACTER" &init="?"}                      /* ����� �⡮�    */

{set-prop.i  &aa="sum-min" &bb="dsum-min"   &cc="DECIMAL" &init="-100"}
{set-prop.i  &aa="sum-max" &bb="dsum-max"   &cc="DECIMAL" &init="999999999999999"}

/********************** �����  ���������� *******************/

/********************** �������� ***********************/

{set-prop.i  &aa="acct-db" &bb="cacct-db" &cc="CHARACTER" &init="\"*\""}
{set-prop.i  &aa="acct-cr" &bb="cacct-cr" &cc="CHARACTER" &init="\"*\""}

/***************** ����� �������� ********************/

{set-prop.i &aa="user-id" &bb="cuser-id" &cc="CHARACTER" &init="\"*\""} 
{set-prop.i &aa="doc-num" &bb="ddoc-num" &cc="CHARACTER" &init="\"*\""}

{set-prop.i  &aa="isAcctAND" &bb="lisAcctAND" &cc="LOGICAL" &init="TRUE"}

{set-prop.i  &aa="acct-rcpt"  &bb="cacct-rcpt"  &cc="CHARACTER" &init="\"*\""}
{set-prop.i  &aa="kassSymbol" &bb="ikassSymbol" &cc="INTEGER"   &init="?"}

{set-prop.i  &aa="sortOrder" &bb="csortOrder" &cc="CHARACTER" &init="\"doc-num\""}

{set-prop.i  &aa="doc-type" &bb="cdoc-type" &cc="CHARACTER" &init="\"*\""}

/************** READONLY �������� ***************/

{set-prop.i  &aa="DocCount"   &bb="idocCount"   &cc="INTEGER"  &init="?" &perms="PROTECTED"}
{set-prop.i  &aa="docSum"     &bb="ddocSumRub"  &cc="DECIMAL"  &init="0" &perms="PROTECTED"}
{set-prop.i  &aa="docSumVal"  &bb="ddocSumVal"  &cc="DECIMAL"  &init="0" &perms="PROTECTED"}

DEFINE PRIVATE TEMP-TABLE ClassDocCollect NO-UNDO                                              /* �६����� ⠡��� ��� �࠭���� ��ꥪ� ⨯� "���㬥��", ��������� � १���� ��������� 䨫��� */
                                      FIELD iDocNum AS INTEGER
				      FIELD  rDocRecid AS RECID
                                      FIELD ClassDoc AS CLASS Object
                                      INDEX idx_iDocNum IS PRIMARY iDocNum
                                     .
                                         
CONSTRUCTOR PUBLIC TDocCollectBase():
   /*
      ��������� ���⮩.
   */
END CONSTRUCTOR.

METHOD PROTECTED LOGICAL additionalFilterByTDoc(INPUT oDoc AS TDocument):
              /*************************************
               * �㭪�� ����� ��८�।�����      *
               * � ����� ��᫥����� � 楫��       *
               * �������� ���. �᫮��� 䨫���樨. *
               * �᫨ �����頥� TRUE, �          *
               * ���㬥�� �������� � ��������,    *
               * �᫨ FALSE, � ���                *
               *************************************/
     RETURN TRUE.
END METHOD.

METHOD PROTECTED CHARACTER getQuery():
             /***************************************
              * ��ନ��� ����� �� �᭮��          		  *
              * ��⠭�������� �����                 		  *
 	      * �।�������, �� � ����� ��᫥�����  *
              * �㤥� ��८�।����.				  *
              ***************************************/             
DEFINE VARIABLE cQuery AS CHARACTER. 
			
RETURN cQuery.
END METHOD.
METHOD PROTECTED VOID setBuffers(INPUT hQuery AS HANDLE):
		/******************************************
		 * �।��������, �� �㤥� ��८�।������� *
		 * � ����� ��᫥�����					    *
		  *										    *
		 ******************************************/
END METHOD.
METHOD PUBLIC VOID applyFilter():
   /*
       ��⮤� �ந������ ���� ���㬥�⮢, 
       �� ������� ᢮��⢠. ��⥬ ࠧ��頥� �� ���㬥���
       �� �६����� ⠡��� ClassDocCollect
  */

   DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
   DEFINE VARIABLE cQuery AS CHARACTER NO-UNDO.

   DEFINE VARIABLE i AS INTEGER NO-UNDO INITIAL 0.
   DEFINE VARIABLE tmpDocSum AS DECIMAL INITIAL 0.
   DEFINE VARIABLE tmpOpObject AS CLASS TDocument.
   
   /* ������ ����� ��⥫����㠫�� ����ந⥫� ����ᮢ */
   cQuery = getQuery().
   
    CREATE QUERY hQuery.

	setBuffers(hQuery).
         hQuery:QUERY-PREPARE(cQuery).                               

         hQuery:QUERY-OPEN().          
         hQuery:GET-FIRST(NO-LOCK).
             
                 REPEAT WHILE NOT hQuery:QUERY-OFF-END:
		   tmpOpObject = new TDocument(RECID(bOp)).

                   IF additionalFilterByTDoc(tmpOpObject) THEN
                    DO:      
                     i = i + 1.
                     	CREATE ClassDocCollect.
                        ASSIGN
	                          iDocNum = i
        	                  rDocRecid = RECID(bOp).
                          .
                     END.
		    DELETE OBJECT tmpOpObject.
                   hQuery:GET-NEXT(NO-LOCK).
                  END. /* REPEAT */
          hQuery:QUERY-CLOSE().             
   DELETE OBJECT hQuery.
   docCount = i.
END METHOD.

METHOD PUBLIC CLASS TDocument getDocument(INPUT iNumDoc AS INTEGER):
 /*
    �����頥� ���㬥�� � ����஬ iNumDoc.
    �᫨ ������ ����� ��ॡ�� �� ������樨, � �� ������ ��. ����讥 �६�.
    ����� ��ॡ�� �௨�� �믮����� �� �������� ��������, ���ਬ�� �� ����� ���.
 */
   FIND FIRST ClassDocCollect WHERE iDocNum=iNumDoc NO-LOCK NO-ERROR.
   IF AVAILABLE(ClassDocCollect) THEN
       DO:
	  ClassDocCollect.ClassDoc = new TDocument(ClassDocCollect.rDocRecid).
         RETURN CAST(ClassDocCollect.ClassDoc,TDocument).          
       END.           
  RETURN ?.
END METHOD.

METHOD PUBLIC LOGICAL isFind():
   /*
       ����뢠�� ������ �� ��� ���� ���㬥�� �� ������� �᫮��� 
   */
   IF docCount > 0 THEN 
        DO:
               RETURN TRUE.
        END.
              ELSE
                   DO:
                         RETURN FALSE.
                   END.
END METHOD.

DESTRUCTOR PUBLIC TDocCollectBase():
     /************************************
      * � ⥡� ��த��, � ⥡� � ���!!! *
      *************************************/
     FOR EACH ClassDocCollect:
         DELETE OBJECT ClassDocCollect.ClassDoc NO-ERROR.
     END.
     EMPTY TEMP-TABLE ClassDocCollect.
END DESTRUCTOR.

END CLASS.