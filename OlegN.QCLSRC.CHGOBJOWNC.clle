/*----------------------------------------------------------------------------*/
/* CHGOBJOWNC              Change Object Owner-Process multiple objects table */
/* Written by Oleg Naymark (NAYMARK_O)  21/07/24                              */
/* Parameter:                                                                 */
/*   &OldUser - User name of an old owner to get privileges revoked           */
/*   &NewUser - User name of a new owner to get the privileges                */
/*   &Value   - Number of units to keep                                       */
/*   &Unit    - Units of measure (Days/Weeks/Months/Years)                    */
/*   &Act     - Type of action to take: List objects only/process the change  */
/*   &ObjTyp  - Select specific object type Or display all types              */
/*   &Revk    - Revoke or keep current user privileges                        */
/*----------------------------------------------------------------------------*/
             Pgm        Parm(&OldUser &NewUser &Value &Unit &Act &ObjTyp &Revk)

             Dcl        Var(&OldUser) Type(*Char) Len(10)
             Dcl        Var(&NewUser) Type(*Char) Len(10)
             Dcl        Var(&Value) Type(*Char) Len(3)
             Dcl        Var(&Unit) Type(*Char) Len(10)
             Dcl        Var(&Act) Type(*Char) Len(10)
             Dcl        Var(&ObjTyp) Type(*Char) Len(7)
             Dcl        Var(&Revk) Type(*Char) Len(7)
             Dcl        Var(&SqlIns) Type(*Char) Len(1024)
             Dcl        Var(&SqlLog) Type(*Char) Len(1024)
             Dcl        Var(&Command) Type(*Char) Len(256)
             Dcl        Var(&Job) Type(*Char) Len(10)
             Dcl        Var(&JobN) Type(*Char) Len(6)
             Dcl        Var(&User) Type(*Char) Len(10)
             Dcl        Var(&Subject) Type(*Char) Len(30)
             Dcl        Var(&Mail) Type(*Char) Len(50)
             Dcl        Var(&MsgId) Type(*Char) Len(7)
             Dcl        Var(&MsgData) Type(*Char) Len(50)
             Dcl        Var(&OutTbl) Type(*Char) Len(10) Value('DSPOBJOWN')
             Dcl        Var(&LogTbl) Type(*Char) Len(10) Value('OBJOWNLOGP')
             Dcl        Var(&WrkLib) Type(*Char) Len(10) Value('TIFUL')
             DclF       File(DSPOBJOWN)

             If         Cond((&OldUser *Eq ' ') *Or (&NewUser *Eq ' ')) +
                          Then(Goto CmdLbl(End))
             CallSubr   Subr(CreateTbl)
             OvrDbf     File(&OutTbl) ToFile(QTEMP/&OutTbl)
             RtvJobA    Job(&Job) User(&User) Nbr(&JobN)
             If         Cond((&Act *Eq '*CHANGE')) Then(Do)
             CallSubr   Subr(Process)
             EndDo
             CallSubr   Subr(SndReport)
             DltOvr     File(*All)

/*----------------------------------------------------------------------------*/
/* Create Table and insert population */
             Subr       Subr(CreateTbl)
             DltF       File(QTEMP/&OutTbl)
             MonMsg     MsgId(CPF0000)
             DltF       File(&WrkLib/&OutTbl)
             MonMsg     MsgId(CPF0000)
             RunSqlStm  SrcFile(&WrkLib/QSQLSRC) SrcMbr(&OutTbl) +
                          Commit(*None) ErrLvl(30)
             ChgVar     Var(&SqlIns) Value('Insert Into ' *Bcat &WrkLib +
                          *Tcat '.' *Tcat &OutTbl +
                          *Tcat ' (OBJ_LIB, OBJ_NAME, OBJ_TYPE, USER_NAME, +
                          LAST_USED, DAYS_USED, ADOPT_AUT) +
                          Select Coalesce(A.OBJECT_LIBRARY, '' ''), +
                          Coalesce(A.OBJECT_NAME, '' ''), +
                          A.OBJECT_TYPE, A.USER_NAME, +
                          Coalesce(B.LAST_00001, DATE(' *Tcat '''+
                          0001-01-01''' *Tcat ')), +
                          Coalesce(B.DAYS_00001, 0), +
                          Coalesce(C.USEADPAUT, ''*NO'') +
                          From QSYS2.OBJECT_OWNERSHIP A +
                          Left Join Table(QSYS2.OBJECT_STATISTICS(+
                          A.OBJECT_LIBRARY, A.OBJECT_TYPE)) B On +
                          A.OBJECT_LIBRARY=B.OBJLO00002 And +
                          A.OBJECT_NAME=B.OBJNAME And +
                          A.OBJECT_TYPE=B.OBJTYPE +
                          Left Join QSYS2.PROGRAM_INFO C On +
                          A.OBJECT_NAME=C.PGM_NAME And +
                          A.OBJECT_LIBRARY=C.PGM_LIB +
                          Where A.AUTHORIZATION_NAME=''')
             ChgVar     Var(&SqlIns) Value(&SqlIns *Tcat &OldUser *Tcat '''')
             If         Cond(&ObjTyp *Ne '*ALL') Then(Do)
             ChgVar     Var(&SqlIns) Value(&SqlIns *Tcat ' And A.OBJECT_TYPE=''')
             ChgVar     Var(&SqlIns) Value(&SqlIns *Tcat &ObjTyp *Tcat '''')
             EndDo
             If         Cond(&Value *Ne '999') Then(Do)
             ChgVar     Var(&SqlIns) Value(&SqlIns *Tcat ' And B.LAST_00001>=+
                        Current_Date-' *Tcat &Value *Tcat ' ' *Bcat &Unit)
             EndDo
             RunSql     Sql(&SqlIns) Commit(*None)
             Cpyf       FromFile(&WrkLib/&OutTbl) +
                          ToFile(QTEMP/&OutTbl) MbrOpt(*Add) +
                          CrtFile(*Yes)
             EndSubr
/*----------------------------------------------------------------------------*/
/* Process all records in the table and run change owner command */
             Subr       Subr(Process)
Loop:        RcvF
             MonMsg     MsgId(CPF0864) Exec(GoTo CmdLbl(EndLoop))
             ChgVar     Var(&Command) Value('ChgObjOwn Obj(' +
                          *Tcat &Obj_Lib *Tcat '/' *Tcat &Obj_Name *Tcat +
                          ') ObjType(' *Tcat &Obj_Type *Tcat ') NewOwn(' +
                          *Tcat &NewUser *Tcat ') CurOwnAut(' +
                          *Tcat &Revk *Tcat ')')
             Call       Pgm(QCmdExc) Parm(&Command 256)
/*           ChgObjOwn  Obj(&Obj_Lib/&Obj_Name) ObjType(&Obj_Type) +
                           NewOwn(&NewUser) CurOwnAut(&Revk)                  */
             MonMsg     MsgId(CPF0000) Exec(Do)
             RcvMsg     MsgDta(&MsgData) MsgId(&MsgId)
             If         Cond(&MsgId *Ne ' ') Then(CallSubr Subr(WriteLog))
             EndDo
             Goto       CmdLbl(Loop)
EndLoop:     EndSubr
/*----------------------------------------------------------------------------*/
/* Send report to user's mail */
             Subr       Subr(SndReport)
             ChgVar     Var(&Subject) Value('                      ')
             AddLiblE   LIB(MAILFILE) Position(*Last)
             AddLiblE   LIB(MAILPGM) Position(*Last)
             AddLiblE   Lib(&WrkLib) Position(*Last)
             MonMsg     MsgId(CPF0000)
             RtvAdMail  UsrPrf(&User) Email(&Mail)
             SndJmail   Subject(&Subject) FromEmail(MAC@MAC.ORG.IL) +
                          ToEmail(&Mail) DelAttach(*Yes) +
                          AttachDb((QTEMP/&OutTbl +
                          *First *Start *End *Excl_ansi *No))
             EndSubr
/*----------------------------------------------------------------------------*/
/* Write to Error Log */
             Subr       Subr(WriteLog)
             RunSqlStm  SrcFile(&WrkLib/QSQLSRC) SrcMbr(&LogTbl) +
                          Commit(*None) ErrLvl(30)
             MonMsg     MsgId(CPF0000)
             ChgVar     Var(&SqlLog) Value('Insert Into ' *Bcat &WrkLib +
                          *Tcat '.' *Tcat &LogTbl *Tcat +
                          ' (OBJ_LIB, OBJ_NAME, OBJ_TYPE, USER_NAME, +
                          COMMAND, MSG_ID, MSG_DATA, JOB_NAME, JOB_USER, +
                          JOB_NUMBER, TIMESTAMP) Values (''' *Tcat &OBJ_LIB +
                          *Tcat ''',''' *Tcat &OBJ_NAME *Tcat ''',''' +
                          *Tcat &OBJ_TYPE *Tcat ''',''' *Tcat &USER_NAME +
                          *Tcat ''',''' *Tcat &Command *Tcat ''',''' +
                          *Tcat &MSGID *Tcat ''',''' *Tcat &MSGDATA *Tcat ''',''' +
                          *Tcat &JOB *Tcat ''',''' *Tcat &USER *Tcat ''',''' +
                          *Tcat &JOBN *Tcat ''',' *Tcat CURRENT_TIMESTAMP +
                          *Tcat ')')
             RunSql     Sql(&SqlLog) Commit(*None)
             EndSubr
/*----------------------------------------------------------------------------*/

End:         EndPgm
