--/*--------------------------------------------------------------------------*/
--/* DSPOBJOWN1                                 SQL - Create DspObjOwn Table  */
--/* Written by Oleg Naymark (NAYMARK_O)  22/07/24                            */
--/*--------------------------------------------------------------------------*/
 Create Table Tiful.DspObjOwn (
     OBJ_LIB CHAR(10) Not Null Default ' ',
     OBJ_NAME CHAR(10) Not Null Default ' ',
     OBJ_TYPE CHAR(10) Not Null Default ' ',
     USER_NAME CHAR(10) Not Null Default ' ',
     LAST_USED Date Not Null Default '0001-01-01',
     DAYS_USED INT Not Null Default 0,
     ADOPT_AUT CHAR(4) Not Null Default '*NO'
 );
