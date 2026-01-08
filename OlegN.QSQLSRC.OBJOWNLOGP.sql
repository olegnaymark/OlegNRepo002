--/*--------------------------------------------------------------------------*/
--/* OBJOWNLOGP                                 SQL - Create ObjOwnLog Table  */
--/* Written by Oleg Naymark (NAYMARK_O)  07/08/24                            */
--/*--------------------------------------------------------------------------*/
 Create Table TIFUL.OBJOWNLOGP (
     OBJ_LIB CHAR(10) Not Null Default ' ',
     OBJ_NAME CHAR(10) Not Null Default ' ',
     OBJ_TYPE CHAR(10) Not Null Default ' ',
     USER_NAME CHAR(10) Not Null Default ' ',
     COMMAND CHAR(150) Not Null Default ' ',
     MSG_ID CHAR(10) Not Null Default ' ',
     MSG_DATA CHAR(50) Not Null Default ' ',
     JOB_NAME CHAR(10) Not Null Default ' ',
     JOB_USER CHAR(10) Not Null Default ' ',
     JOB_NUMBER Char(6) Not Null Default ' ',
     TIMESTAMP Timestamp Not Null Default '0001-01-01-00.00.00.000000'
 );
