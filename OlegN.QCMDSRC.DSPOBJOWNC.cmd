/*----------------------------------------------------------------------------*/
/* CRTCMD CMD(NAYMARK_O/CHGOBJOWNC) PGM(CHGOBJOWNC)                           */
/*----------------------------------------------------------------------------*/
/*   ChgObjOwnC: Change Objects Owner-Automatic Process                       */
/*   Function  : Creates Output Table by selected User and Object Type.       */
/*   CPP       : CHGOBJOWNC                                                   */
/*----------------------------------------------------------------------------*/
             Cmd        Prompt('Change Object Owner')

 OLDUSER:    Parm       Kwd(OldUser) Type(*Char) Len(10) Rstd(*No) +
                          Rel(*NE ' ') AlwUnprt(*No) AlwVar(*No) +
                          Prompt('Old Owner User Name')
 NEWUSER:    Parm       Kwd(NewUser) Type(*Char) Len(10) Rstd(*No) +
                          Rel(*NE ' ') AlwUnprt(*No) AlwVar(*No) +
                          Prompt('New Owner User Name')
 VALUE:      Parm       Kwd(Value) Type(*Char) Len(3) Rstd(*No) +
                          Dft(182) Range('000' '999') Min(0) +
                          AlwUnprt(*No) AlwVar(*No) Prompt('Units +
                          to keep')
 UNIT:       Parm       Kwd(Unit) Type(*Char) Len(10) Rstd(*Yes) +
                          Dft(DAYS) Values(Days Weeks Months Years) +
                          Min(0) AlwUnprt(*No) +
                          AlwVar(*No) Prompt('Units of Values')
 ACTION:     Parm       Kwd(Action) Type(*Char) Len(10) Rstd(*Yes) +
                          Dft(*LIST) Spcval((*LIST *LIST) (*CHANGE +
                          *CHANGE)) Min(0) +
                          AlwVar(*No) Prompt('Action Type')
 ObjType:    Parm       Kwd(ObjType) Type(*Char) Len(10) Rstd(*Yes) +
                          Dft(*ALL) Values(*ALRTBL *BNDDIR *CFGL +
                           *CHTFMT *CLD *CLS *CMD *CRQD *CSI *CSPMAP +
                           *CSPTBL *DTAARA *DTAQ *EDTD *EXITRG *FCT +
                           *FILE *FNTRSC *FORMDF *FTR *GSS *JOBD +
                           *JOBQ *JOBSCD *JRN *JRNRCV *MENU *MODULE +
                           *MSGF *MSGQ *NoDL *OUTQ *OVL *PAGDFN +
                           *PAGSEG *PDG *PGM *PNLGRP *PRDAVL *PRDDFN +
                           *PRDLOD *QMFORM *QMQRY *QRYDFN *RCT *SBSD +
                           *SCHIDX *SPADCT *SQLPKG *SRVPGM *SSND +
                           *SVRSTG *S36 *TBL *USRIDX *USRQ *USRSPC +
                           *WSCST) SpcVal((*ALL)) Prompt('Object Type')
 Revike:     Parm       Kwd(Revoke) Type(*Char) Len(7) Rstd(*Yes) +
                          Dft(*REVOKE) Spcval((*REVOKE *REVOKE) +
                          (*SAME *SAME)) Min(0) +
                          AlwVar(*No) Prompt('Current owner authority')
