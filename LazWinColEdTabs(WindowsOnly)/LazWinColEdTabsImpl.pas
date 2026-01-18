          { Copyright (C) 2025, 2026  StOver }
          {$CODEPAGE UTF8}
Unit
          LazWinColEdTabsImpl;

          {$mode objfpc}{$H+}
          {$ModeSwitch typehelpers}

          {$If ( FPC_VERSION> 2) And ( FPC_RELEASE> 2) And ( FPC_PATCH> 0)}
               {$Define FPC331aa}
          {$Else}
          {$EndIf}

          // not in lnx-laz because I have no idea how to interact with ta controls there :(

Interface

Uses
          ComCtrls
          ;

Procedure
          Register;

Implementation

Uses
          winDOwS
          ,
          Classes
          ,
          commCtrl
          ,
          SysUtils
          ,
          syncObjs
          ,
          conTrols
          ,
          extCtrls
          ,
          Dialogs
          ,
          menuintf
          ,
          System.uiTypes
          ,
          IDECommands
          ,
          lclType
          ,
          typInfo
          ,
          ToolBarIntf
          ,
          SrcEditorIntf
          ,
          IDEWindowIntf
          ,
          ideOptionDefs
          ,
          idecmdline
          ,
          IDEOptEditorIntf
          ,
          graPhics
          ,
          fOrms
          ,
          proJect
          ,
          //SynEdit
          //,
          iu_WinMessages
          ,
          iu_DateTime
          ,
          iu_LWCETConf
          ,
          su_LWCETConf
          ,
          iu_BGRColor
          ,
          frm_edtcfg
          ,
          LitteBmpMgr
          ,
          ExtendedNotebook
          ;

          {$R LazWinColEdTabs_Images.res}

Const
          // command
          SREINIT_ADDINN                    = 'reinit_lazwincoledtabs';
          SEDTCFG_ADDINN                    = 'edtcfg_lazwincoledtabs';

          cstr_TABCTRL_WINCLS_NAME          = 'SysTabControl32';



Resourcestring

          SREINIT_ADDINN_IDEMenuCaption     = 'LazWinColEdTabs V 0.1.0 - ReInit';
          SEDTCFG_ADDINN_IDEMenuCaption     = 'LazWinColEdTabs V 0.1.0 - Edit Config';

Type

          { tHTypeHelperString }

          tHTypeHelperString                = Type Helper( tStringHelper) For String

          Const
             str_LogFilePath                : String= 'c:\temp\';
             str_LogFileNmeFmtStr           : String= 'yyyy-mm-dd';

             Function                       saveToFile( aFileName: String; aDoAppend: boolEan= False): boolEan;
             Function                       logString ( aDoAppend: boolEan= True; aTimePfx: boolEan= True; aEOLSfx: boolEan= True): boolEan;

          End;

          { tHTypeHelperTcItem }

          tHTypeHelperTcItem                = Type Helper For TcItem

             Class Function                 initIalize  ( aTextMem: Word; aMask: Word): TcItem; Static;
             Class Procedure                deInitIalize( Var aVarItem: TcItem); Static;

          End;


          { tSrcWindowData }

          tSrcWindowData                    = Class ( tCollectionItem )

          Protected

             intClsblTabIdx                 : intEger;
             Procedure                      wndCloseSink( aSender: tObject; Var aVarCloseAction: tCloseAction);

          Public

             SrcForm                        : tSourceEditorWindowInterface;
             orgClEv                        : tCloseEvent;
             ptHWnd                         : hWnd;
             tcHwnd                         : hWnd;
             orgWDP                         : LONG_PTR;


             Procedure                      deInit();

             Procedure                      init( aSrcWin: tSourceEditorWindowInterface);
             Procedure                      invalidateTC( aIdx: intEger);

             Procedure                      setClosableTab( aIdx: intEger);

          End;

          { tSrcWindowDataColl }

          tSrcWindowDataColl                = Class ( tCollection )

          Protected

             Function                       _fnd_by_hwnd( aHwnd: hWnd): tSrcWindowData;

          Public

             Constructor                    create ();

             Property                       SrcWindowData[ aHwnd: hWnd]: tSrcWindowData Read _fnd_by_hwnd; Default;

             Procedure                      deInit();

          End;

          { tHelpObj }

          tHelpObj                          = Class( tObject)

          Public
             Type
                tCloseButtonType            = ( STD, SEL, CBL);  // aka standard, selected, closable

          Private

             theConfig                      : tLWCETConfig;

             dwProcessId                    : dWord;

             dwSrcWinCnt                    : -1.. $FFFFFF;

             tmrStart                       : extCtrls.tTimer;

             tpPosition                     : tTabPosition;

          Protected

             lbmImgs                        : tLitteBmpMgr;

             swdcSrcWndDatas                : tSrcWindowDataColl;
             swcSrcNbk                      : tIDEWindowCreator;

             orgWDP                         : LONG_PTR;

             str_cbsStyle                   : String;

             Procedure                      paintFilledRect( aHDc: hDc; aTabRect: tRect; aRGBColor: tBGRColor); StdCall;
             Function                       getBmpName( aIsSel: boolEan; aIsCsbl: boolEan): String;
             Function                       getBmpFromResToShow( aSrcWndDta: tSrcWindowData; aIdx: longInt; aIsSel: boolEan): Graphics.tBitMap;
             Function                       cbStyleToDim(): intEger;
             Procedure                      showBmpFromRes( aSrcWndDta: tSrcWindowData; aHDc: hDc; aTabRect: tRect; aIdx: longInt; aIsSel: boolEan); StdCall;
             Procedure                      paintTabRect( aHDc: hDc; aTabRect: tRect; aIsSel: boolEan); StdCall;
             Procedure                      prepareLogFont( aTabPos: tTabPosition; Out aOutLF: tLogFont); StdCall;
             Procedure                      drawTabText( aHDc: hDc; aTabPos: tTabPosition; aTabText: String; aTabRect: tRect; aIsSel: boolEan); StdCall;
             Procedure                      condDrawFocusRct( aHDc: hDc; aTabRect: tRect; aIsSel: boolEan); StdCall;
             Procedure                      paintTabs( aHWnd: hWND); StdCall;

             Procedure                      replaceOneWinProc( aSrcWin: tSourceEditorWindowInterface);
             Procedure                      replaceWinProcs();
             Procedure                      startTimer( aSender: tObject);

             Procedure                      checkOptionsChanged();
             Procedure                      afterIDEOptionsWritten( aSender: tObject; aDoRestore: Boolean);

             Function                       getTabPositionByHandle( aHwndSTC: hWnd): tTabPosition;

             Procedure                      init( aWaitTime: dWord= 500);
             Procedure                      deInit();

          Public

             Procedure                      lwcetReInit( aSender: tObject);
             Procedure                      lwcetEdtCfg( aSender: tObject);

             Procedure                      cfgApplyCB( aSender: tLWCETConfig);

             Function                       getSrcWndDta( aHWnd: hWnd; Out aOutSrcWndDta: tSrcWindowData): boolEan;

             Procedure                      signalClosableTab( aHwnd: hWnd; aTabIdx: intEger);
             Procedure                      resetClosableTab ();

             Procedure                      signalCloseTabNow( aHwnd: hWnd; aTabIdx: intEger);

             Procedure                      loadBitmaps();
             Constructor                    create();

          End;




Var
          //imcCmd_ABTADI                     : tIDEMenuCommand= Nil;
          imcCmd_EDTCFG                     : tIDEMenuCommand;

          {%H-}ho_Obj                       : tHelpObj= Nil;
          {%H+}

          {$hints off}
Procedure // helper proc that makes compiler shut up for not (yet) used arguments
          _nOp( Const aAOC: Array Of Const);
Begin
          //
End;
          {$hints on}


Function
          registerOneCmd( aCmdId: String; aCmdCaption: String; aObjMthd: tNotifyEvent): tIDEMenuCommand;
Var
          Key                               : tIDEShortCut;
          Cat                               : tIdeCommandCategory;
          Cmd                               : tIdeCommand;

Begin
          Result:= Nil;

          Try
             Key:= IDEShortCut( vk_unknown, []);
             Cat:= IDECommandList.FindCategoryByName( CommandCategoryToolMenuName);

             Cmd:= RegisterIDECommand( Cat, aCmdId, aCmdCaption, Key, aObjMthd, Nil);
             RegisterIDEButtonCommand( Cmd);
             Result:= RegisterIDEMenuCommand( itmSecondaryTools, aCmdId, aCmdCaption, aObjMthd, Nil, Cmd, AnsiLowerCase( aCmdId));

          Except End;

End;

Procedure
          Register;
Var
          imcCmd_ONE                        : tIDEMenuCommand;
Begin

          imcCmd_ONE    := registerOneCmd( SREINIT_ADDINN, SREINIT_ADDINN_IDEMenuCaption, @ho_Obj.lwcetReInit);

          imcCmd_ONE.Enabled:= True;

          imcCmd_EDTCFG := registerOneCmd( SEDTCFG_ADDINN, SEDTCFG_ADDINN_IDEMenuCaption, @ho_Obj.lwcetEdtCfg);

          imcCmd_EDTCFG.Enabled:= True;


          If ( Nil= ho_Obj)
             Then
             Begin
                  messageDlg( 'LazWinColEdTabs', 'ho_Obj is Nil', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  exit;
          End;

          ho_Obj.init();

End;

Function  // loggas little helper
          _formatMsg4Log( aHWnd: hWND; aMsg: uINT; aWParam: wPARAM; aLParam: lPARAM): String; StdCall;
Var
          vStHwnd                           : String;
          vStWMsg                           : String;
          vStwPrm                           : String;
          vStlPrm                           : String;
          vStDtT                            : String;

Begin
          vStHwnd:= aHWnd.toString();
          vStWMsg:= iu_WinMessages.getWinMsgName( tWinMessages( aMsg));
          vStwPrm:= aWParam.toString();
          vStlPrm:= aLParam.toString();

          vStDtT := now().toString( 1, 2, 3, 0, 4, 5, 6, 7);

          Result := vStDtT+ #9+ 'hWnd => '+ vStHwnd+ ' - Msg => '+ vStWMsg+ ' - wPrm => '+ vStwPrm+ ' - lPrm => '+ vStlPrm;

End;

Function  // loggas little helper
          _formatRect4Log( aRect: tRect): String; StdCall;
Var
          vStDtT                            : String;

Begin
          vStDtT := now().toString( 1, 2, 3, 0, 4, 5, 6, 7);

          Result := vStDtT+ #9+ 'aRect : '+
                    'Left  = '+ aRect.Left  .toString()+ ', '+
                    ' Top  = '+ aRect.Top   .toString()+ ', '+
                    'Right = '+ aRect.Right .toString()+ ', '+
                    'Bottom= '+ aRect.Bottom.toString()+ ', '+
                    'Width = '+ aRect.Width .toString()+ ', '+
                    'Height= '+ aRect.Height.toString();

End;

Function
          getClientXYFromLParam( aHWnd: hWND; aLParamFromMsg: lParam; Out aOutX: longInt; Out aOutY: longInt): boolEan; StdCall;
Var
          vLoX                              : longInt;
          vLoY                              : longInt;
          vtPo1                             : tPoInt;
Begin
          Result:= False;
          aOutX := 0;
          aOutY := 0;

          // where the mouse is pointing at ?
          vLoX:= GET_X_LPARAM( aLParamFromMsg);
          vLoY:= GET_Y_LPARAM( aLParamFromMsg);

          vtPo1:= tPoint.create( vLoX, vLoY);

          If screenToClient( aHwnd, vtPo1)
             Then
             Begin
                  aOutX:= vtPo1.X;
                  aOutY:= vtPo1.Y;
                  Result:= True;
          End;
End;

Function
          tabRectHitTest( aHWnd: hWND; aLParamFromMsg: lParam; Out aOutTabIdx: intEger): intEger; StdCall;
Var

          vLoX                              : longInt;
          vLoY                              : longInt;

          vtRe1                             : tRect;

          vLoIdx                            : longInt;
          vLoOne                            : longInt;
          vLRsTabCnt                        : lResult;
          vInDim                            : intEger;

Begin
          Result                  := HTNOWHERE;
          aOutTabIdx              := -1;

          If ( Nil= ho_Obj)
             Then
             Begin
                  messageDlg( 'LazWinColEdTabs', 'ho_Obj is Nil', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  exit;
          End;

          If ( Not getClientXYFromLParam( aHWnd, aLParamFromMsg, vLoX, vLoY))
             Then
             Exit;

          // prevent "does not seem to be initialized"
          vtRe1.Top               := 0;

          vLRsTabCnt              := TabCtrl_GetItemCount( aHWnd);
          vLoIdx                  := TabCtrl_GetCurSel( aHwnd);
          _nOp( [ vLoIdx]);

          vInDim                  := ho_Obj.cbStyleToDim();

          For vLoOne:= 0 to vLRsTabCnt- 1
              Do
              Begin
                   TabCtrl_GetItemRect( aHwnd, vLoOne, vtRe1);

                   If ( vLoX> vtRe1.Right- vInDim- 3- 1) And ( vLoX< vtRe1.Right- 2)
                      And
                      ( vLoY> vtRe1.Top          + 3   ) And ( vLoY< vtRe1.Top  + vInDim+ 3+ 1)
                      Then
                      Begin
                           aOutTabIdx:= vLoOne;
                           Result    := HTCLOSE;

                           Exit;
                   End;
          End;
End;


Function
          _wndProc ( aHWnd: hWND; aMsg: uINT; aWParam: wPARAM; aLParam: lPARAM): lResult; StdCall;
Var
          vtSrcWndDta                       : tSrcWindowData;
          vLoTabIdxClsbl                    : intEger;
Begin

          //_formatMsg4Log( aHWnd, aMsg, aWParam, aLParam).logString();
          If ( Nil= ho_Obj)
             Then
             Begin
                  messageDlg( 'LazWinColEdTabs', 'ho_Obj is Nil', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  exit;
          End;

          If ( winDOwS.WM_Paint= aMsg)
             Then
             Begin
                  ho_Obj.paintTabs( aHWnd);

                  Result:= 0;
                  Exit;
          End;

          If ( winDOwS.WM_NCHITTEST= aMsg) And ( tLWCETConfig.tCloseButtonStyle.cbs_None<> ho_Obj.theConfig.cbs_CloseBtnStyle)
             Then
             Begin
                  vLoTabIdxClsbl:= -1;

                  Result:= tabRectHitTest( aHwnd, aLParam, vLoTabIdxClsbl);

                  If ( HTCLOSE= Result)
                     Then
                     Begin
                          ho_Obj.signalClosableTab( aHWnd, vLoTabIdxClsbl);
                          Exit;
                     End
                  Else
                     Begin
                          ho_Obj.resetClosableTab();
                  End;
          End;

          If ( winDOwS.WM_NCLBUTTONDOWN= aMsg)
             Then
             Begin
                  vLoTabIdxClsbl:= -1;

                  Result:= tabRectHitTest( aHwnd, aLParam, vLoTabIdxClsbl);

                  If ( HTCLOSE= Result)
                     Then
                     Begin
                          ho_Obj.signalCloseTabNow( aHWnd, vLoTabIdxClsbl);
                          Result:= 0;
                          Exit;
                  //   End
                  //Else
                  //   Begin
                  //        ho_Obj.resetClosableTab();
                  End;
          End;

          vtSrcWndDta:= ho_Obj.swdcSrcWndDatas.SrcWindowData[ aHWnd];

          If ( Nil<> vtSrcWndDta) And ( 0<> vtSrcWndDta.orgWDP)
             Then
             {$warnings off} {$hints off}
             Result:= callWindowProcW( WndProc( vtSrcWndDta.orgWDP), aHWnd, aMsg, aWParam, aLParam);
             {$warnings on}  {$hints on}
End;

Function
          findSysTabCtrlProc( aHwnd: hWnd; aLParam: lParam): WinBool; Stdcall;
Const
          cLoBuf                            = 1024;
Var
          aocClsNme                         : Array[ 0.. cLoBuf] Of Char;
          vLoCNLen                          : longInt;
          vStClsNme                         : String;
          vPoOldWP                          : LONG_PTR;
          vtReWin                           : tRect;
          vTCitm                            : TC_ITEM;
          vLoIdx                            : longInt;
          vtSrcEdCur                        : tSourceEditorInterface;
          vLoCnt                            : longInt;

          vtSrcWndDta                       : tSrcWindowData;

Begin
          _nOp( [ aHwnd, aLParam]);

          If ( Nil= ho_Obj)
             Then
             Begin
                  messageDlg( 'LazWinColEdTabs', 'ho_Obj is Nil', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  exit;
          End;

          If ( 0= aLParam)
             Then
             Begin
                  messageDlg( 'LazWinColEdTabs', 'aLParam is 0', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  exit;
          End;

          vtSrcWndDta:= tSrcWindowData( aLParam);

          vTCitm:= TCITEM.initIalize( 256, TCIF_TEXT);

          Result:= True;
          vLoCNLen:= getClassName( aHwnd, @aocClsNme, cLoBuf);
          If ( 0< vLoCNLen)
             Then
             Begin
                  vStClsNme:= pChar( @aocClsNme);
                  If ( cstr_TABCTRL_WINCLS_NAME= vStClsNme)
                     Then
                     Begin
                          Result:= False;

                          vtSrcWndDta.tcHwnd:= aHwnd;

                          TabCtrl_SetPadding( aHwnd, ho_Obj.theConfig.bte_TabPaddingX, ho_Obj.theConfig.bte_TabPaddingY); // this makes the tabs more comfortable

                          vtSrcWndDta.orgWDP:= getWindowLongPtr( aHwnd, GWLP_WNDPROC);

                          {$warnings off} {$hints off}
                          vPoOldWP                := LONG_PTR( @_wndProc);
                          {$warnings on}  {$hints on}
                          setWindowLongPtr( aHwnd, GWLP_WNDPROC, vPoOldWP);

                          // prevent "does not seem to be initialized"
                          vtReWin.Top:= 0;

                          // the trick (part 1) below makes the tabcontrol redraw
                          getClientRect( aHwnd, vtReWin);
                          invalidateRect( aHwnd, vtReWin, True);

                          vLoCnt                  := TabCtrl_GetItemCount( aHwnd);
                          If ( 0< vLoCnt)
                             Then
                             Begin
                                  vLoIdx          := TabCtrl_GetCurSel( aHwnd);
                                  TabCtrl_GetItem( aHwnd, vLoCnt- 1, vTCitm);
                                  TabCtrl_SetItem( aHwnd, vLoCnt- 1, vTCitm);
                                  TabCtrl_SetCurSel( aHwnd, vLoIdx);
                                  TabCtrl_setCurFocus( aHwnd, vLoIdx);
                          End;

                          getClientRect( aHwnd, vtReWin);
                          invalidateRect( aHwnd, vtReWin, True);

                          vtSrcEdCur              := vtSrcWndDta.SrcForm.ActiveEditor;
                          vLoCnt                  := vtSrcWndDta.SrcForm.Count;

                          vtSrcWndDta.SrcForm.ActiveEditor:= vtSrcWndDta.SrcForm[ vLoCnt- 1];
                          vtSrcWndDta.SrcForm.ActiveEditor:= vtSrcWndDta.SrcForm[ 0];

                          vtSrcWndDta.SrcForm.ActiveEditor:= vtSrcEdCur;

                  End;
          End;
          vTCitm.deInitIalize( vTCitm);

End;


          { tHTypeHelperString }

Function
          tHTypeHelperString.saveToFile( aFileName: String; aDoAppend: boolEan= False): boolEan;
Var
          vtMemStm                          : tMemoryStream;
          vtEnc                             : tEncoding;
          aobCont                           : tBytes;
          vI64Sze                           : int64;
          {$IfNDef FPC331aa}
          vI64One                           : int64;
          {$EndIf}
          vtCriSctn                         : tRtlCriticalSection;

Begin
          Result:= False;

          vtCriSctn.DebugInfo:= Nil;
          initializeCriticalSection( vtCriSctn);
          enterCriticalSection( vtCriSctn);
          Try
             vtMemStm:= tMemoryStream.create();

             If aDoAppend And fileExists( aFileName, False)
                Then
                Begin
                     vtMemStm.loadFromFile( aFileName);
                     vtMemStm.Seek( 0, soEnd);
             End;

             vtEnc   := tEncoding.ANSI;
             aobCont := vtEnc.GetAnsiBytes( Self);
             vI64Sze := sysTem.length( aobCont);

             {$IfDef FPC331aa}
             vtMemStm.write( aobCont, vI64Sze);
             {$Else}
             For vI64One:= 0 To vI64Sze- 1
                 Do
                 vtMemStm.writeByte( aobCont[ vI64One]);
             {$EndIf}

             vtMemStm.saveToFile( aFileName);
             Result:= fileExists( aFileName);

          Finally
             Try
                freeAndNil( vtMemStm);
             Except End;
             Try
                leaveCriticalSection( vtCriSctn);
             Except End;

          End;

End;

Function
          tHTypeHelperString.logString ( aDoAppend: boolEan= True; aTimePfx: boolEan= True; aEOLSfx: boolEan= True): boolEan;
Var
          vStDtFmttd                        : String;
          vStFleNme                         : String;

          vStDtPfx                          : String;
          vStEolSfx                         : String;

Begin
          exit;  // remove to do some logging into a file - if heavily used, it might lead to a crash of the Lazarus !!!
          vStDtFmttd  := '';
          dateTimeToString( vStDtFmttd, str_LogFileNmeFmtStr, now());
          vStFleNme   := str_LogFilePath+ vStDtFmttd+ '.txt';

          vStDtPfx    := '';
          If ( aTimePfx)
             Then
             vStDtPfx := now().toString( 1, 2, 3, 0, 4, 5, 6, 7)+ #9;

          vStEolSfx   := '';
          If ( aEOLSfx)
             Then
             vStEolSfx:= LineEnding;

          Result      := ( vStDtPfx+ Self+ vStEolSfx).saveToFile( vStFleNme, aDoAppend);

End;


          { tHTypeHelperTcItem }

Class Function
          tHTypeHelperTcItem.initIalize( aTextMem: Word; aMask: Word): TcItem;
Begin
          // prevent "does not seem to be initialized"
          Result.mask:= 0;

          fillChar( Result, sizeOf( TcItem), 0);

          Result.pszText          := getMem( 256);
          Result.cchTextMax       := ( aTextMem- 1);
          Result.mask             := aMask;  // TCIF_TEXT
          Result.lParam           := 0;

End;

Class Procedure
          tHTypeHelperTcItem.deInitIalize( Var aVarItem: TcItem);
Begin
          If ( Nil<> aVarItem.pszText)
             Then
             Begin
                  Try
                     freeMem( aVarItem.pszText);
                  Except End;
          End;
          fillChar( aVarItem, sizeOf( TcItem), 0);
End;


          { tSrcWindowData }

Procedure
          tSrcWindowData.deInit();
Begin
          If (  assigned( SrcForm))
             Then
             Try
                SrcForm.OnClose:= orgClEv;
             Except End;

          If ( 0<> orgWDP) And ( 0<> tcHwnd)
             Then
             Try
                setWindowLongPtr( tcHwnd, GWLP_WNDPROC, orgWDP);
                intClsblTabIdx := -1;
                orgWDP         := 0;
                tcHwnd         := 0;
                orgClEv        := Nil;
                SrcForm        := Nil;
             Except End;
          Try
             free();
          Except End;
End;

Procedure
          tSrcWindowData.wndCloseSink( aSender: tObject; Var aVarCloseAction: tCloseAction);
Begin

          If ( assigned( orgClEv))
             Then
             Try
                orgClEv( aSender, aVarCloseAction);
             Except End;

          If ( caFree= aVarCloseAction)
             Then
             Begin
                  deInit();
          End;

          If ( Nil<> ho_Obj)
             Then
             ho_Obj.init();  // this "trick" might help to reInit after loading another project
End;

Procedure
          tSrcWindowData.invalidateTC( aIdx: intEger);
Var
          vtReWin                           : tRect;

Begin
          vtReWin.Left:= 0;
          TabCtrl_GetItemRect( Self.tcHwnd, aIdx, vtReWin);

          invalidateRect( Self.tcHwnd, vtReWin, True);
End;

Procedure
          tSrcWindowData.setClosableTab( aIdx: intEger);
Var
          vIntOld                           : intEger;
Begin
          vIntOld       := intClsblTabIdx;
          intClsblTabIdx:= aIdx;

          If ( vIntOld<> intClsblTabIdx)
             Then
             Begin
                  invalidateTC( vIntOld);
                  invalidateTC( aIdx);
          End;
End;

Procedure
          tSrcWindowData.init( aSrcWin: tSourceEditorWindowInterface);
Begin
          If ( Nil= aSrcWin)
             Or
             ( 0  = aSrcWin.Handle)
             Then
             Begin
                  Try
                     free();
                  Except End;
                  Exit;
          End;

          intClsblTabIdx   := -1;
          SrcForm          := aSrcWin;
          ptHWnd           := SrcForm.Handle;
          orgWDP           := 0;
          tcHwnd           := 0;
          orgClEv          := SrcForm.OnClose;

          aSrcWin.OnClose  := @wndCloseSink;

          enumChildWindows( ptHWnd, @findSysTabCtrlProc, lParam( Self));
End;


          { tSrcWindowDataColl }

Constructor
          tSrcWindowDataColl.create ();
Begin
          inHerited create( tSrcWindowData);

End;

Function
          tSrcWindowDataColl._fnd_by_hwnd( aHwnd: hWnd): tSrcWindowData;
Var
          one_itm                           : tCollectionItem;
          one_dta                           : tSrcWindowData;

Begin

          Result:= Nil;
          For one_itm In Self
              Do
              Begin
                   one_dta:= one_itm As tSrcWindowData;
                   If ( aHwnd= one_dta.tcHwnd)
                      Then
                      Begin
                           Result:= one_dta;
                           break;
                   End;
                   one_dta:= Nil;
          End;
End;

Procedure
          tSrcWindowDataColl.deInit();
Var
          one_itm                           : tCollectionItem;
          one_dta                           : tSrcWindowData;

Begin

          For one_itm In Self
              Do
              Begin
                   one_dta:= one_itm As tSrcWindowData;
                   one_dta.deInit();
                   one_dta:= Nil;
          End;

End;

          { tHelpObj }  // and associates :)

Procedure
          tHelpObj.paintFilledRect( aHDc: hDc; aTabRect: tRect; aRGBColor: tBGRColor); StdCall;
Var
          vhBrush                           : hBrush;
          vtRe1                             : tRect;

Begin
          vtRe1:= aTabRect;

          vhBrush:= createSolidBrush( aRGBColor.switchLowerBytes());
          fillRect( ahDc, vtRe1, vhBrush);
          deleteObject( vhBrush);

End;

Function
          tHelpObj.getBmpName( aIsSel: boolEan; aIsCsbl: boolEan): String;
Var
          vStType                           : String;
Begin
          Result     := '';

          If ( Nil= theConfig)
             Or
             ( tLWCETConfig.tCloseButtonStyle.cbs_None= theConfig.cbs_CloseBtnStyle)
             Then
             Exit;

          vStType    := 'STD';
          If aIsSel
             Then
             vStType := 'SEL';

          If aIsCsbl
             Then
             vStType := 'CBL';

          Result     := str_cbsStyle+ '_'+ vStType;
End;

Function
          tHelpObj.getBmpFromResToShow( aSrcWndDta: tSrcWindowData; aIdx: longInt; aIsSel: boolEan): Graphics.tBitMap;
Var
          vStBmNme                          : String;
Begin

          Result:= Nil;
          If ( Nil= aSrcWndDta)
             Then
             Exit;

          vStBmNme:= getBmpName( aIsSel, ( aIdx = aSrcWndDta.intClsblTabIdx));
          If ( ''= vStBmNme)
             Then
             Exit;

          Result:= lbmImgs[ vStBmNme];
End;

Function  // must always be square - don't mess around with the names !!!
          tHelpObj.cbStyleToDim(): intEger;
Var
          vStDim                            : String;
          vInDim                            : intEger;
Begin
          Result:= 12;                      // default
          vStDim:= '12';

          Try
             vStDim:= str_cbsStyle.split( [ 'cbs_'])[ 1];
             vStDim:=       vStDim.split( [   'px'])[ 0];

             If ( intEger.tryParse( vStDim, vInDim))
                Then
                Result:= vInDim;
          Except End;

End;


Procedure
          tHelpObj.showBmpFromRes( aSrcWndDta: tSrcWindowData; aHDc: hDc; aTabRect: tRect; aIdx: longInt; aIsSel: boolEan); StdCall;
Var
          vtBm1                             : Graphics.tBitmap;
          vtRe1                             : tRect;
          vtCvs                             : tCanvas;
          vInDim                            : intEger;
Begin
          If ( tLWCETConfig.tCloseButtonStyle.cbs_None= theConfig.cbs_CloseBtnStyle)
             Then
             Exit;

          vtBm1:= getBmpFromResToShow( aSrcWndDta, aIdx, aIsSel);
          If ( Nil= vtBm1)
             Then
             exit;

          vInDim      := cbStyleToDim();

          vtRe1.Left  := aTabRect.Right- vInDim- 3;
          vtRe1.Top   := aTabRect.Top          + 3;
          vtRe1.Width := vInDim;
          vtRe1.Height:= vInDim;


          vtCvs       := tCanvas.create();
          vtCvs.Handle:= aHDc;

          If ( aIsSel)
             Then
             vtCvs.Brush .Color:= theConfig.col_TabEmporeSlctd.switchLowerBytes()
          Else
             vtCvs.Brush .Color:= theConfig.col_TabEmporeUnSel.switchLowerBytes();

          vtCvs.brushCopy(
                       vtRe1,
                       vtBm1,
                       bounds( 0, 0, vtBm1.Width, vtBm1.Height),
                       clBlue
                  );

          vtBm1:= Nil;
          vtCvs.Handle:= 0;
          freeAndNil( vtCvs);
End;


Procedure
          tHelpObj.paintTabRect( aHDc: hDc; aTabRect: tRect; aIsSel: boolEan); StdCall;
Var
          vtRe1                             : tRect;

Begin
          vtRe1:= aTabRect;

          // lights, top+left
          paintFilledRect( aHDc, vtRe1, theConfig.col_TabLight);

          // shadows, bottom+ right
          vtRe1.Top += 1;                              // leave a light slot
          vtRe1.Left+= 1;

          paintFilledRect( aHDc, vtRe1, theConfig.col_TabShadow);

          // empore, centered
          vtRe1.Width := vtRe1.Width - 1;              // also leave a shadow slot
          vtRe1.Height:= vtRe1.Height- 1;

          If ( Not aIsSel)
             Then
             Begin
                  paintFilledRect( aHDc, vtRe1, theConfig.col_TabEmporeUnSel);
             End
          Else
             Begin
                  paintFilledRect( aHDc, vtRe1, theConfig.col_TabEmporeSlctd);
          End;

End;

Procedure
          tHelpObj.prepareLogFont( aTabPos: tTabPosition; Out aOutLF: tLogFont); StdCall;
Var
          vtLgFnt                           : tLogFont;
Begin
          vtLgFnt.lfHeight        := theConfig.int_TabFontHeight;
          vtLgFnt.lfWidth         := theConfig.int_TabFontWidth;

          vtLgFnt.lfEscapement    := 0;
          vtLgFnt.lfOrientation   := 0;

          If ( tpLeft= aTabPos)
             Then
             Begin
                  vtLgFnt.lfEscapement    := 900;
                  vtLgFnt.lfOrientation   := 900;
          End;
          If ( tpRight= aTabPos)
             Then
             Begin
                  vtLgFnt.lfEscapement    := 2700;
                  vtLgFnt.lfOrientation   := 2700;
          End;

          vtLgFnt.lfWeight        := FW_NORMAL;
          vtLgFnt.lfItalic        := 0;
          vtLgFnt.lfUnderLine     := 0;
          vtLgFnt.lfStrikeOut     := 0;
          vtLgFnt.lfCharSet       := DEFAULT_CHARSET;
          vtLgFnt.lfOutPrecision  := OUT_DEFAULT_PRECIS;
          vtLgFnt.lfClipPrecision := CLIP_DEFAULT_PRECIS;
          vtLgFnt.lfQuality       := CLEARTYPE_QUALITY;
          vtLgFnt.lfPitchAndFamily:= VARIABLE_PITCH;

          vtLgFnt.lfFaceName      := theConfig.str_TabFontName;

          aOutLF                  :=  vtLgFnt;

End;

Procedure
          tHelpObj.drawTabText( aHDc: hDc; aTabPos: tTabPosition; aTabText: String; aTabRect: tRect; aIsSel: boolEan); StdCall;
Var

          vtRe1                             : tRect;
          vStTxt                            : String;

Begin
          vtRe1 := aTabRect;
          vStTxt:= aTabText;

          If ( Not aIsSel)
             Then
             Begin
                  setBkColor( aHDc, theConfig.col_TabEmporeUnSel.switchLowerBytes());
                  SetTextColor( aHDc, theConfig.col_TabFontUnSel.switchLowerBytes());
             End
          Else
             Begin
                  vtRe1.Left:= vtRe1.Left+ 2;
                  vtRe1.Top:= vtRe1.Top+ 1;
                  vtRe1.Width:= vtRe1.Width- 2;
                  vtRe1.Height:= vtRe1.Height- 1;

                  setBkColor( aHDc, theConfig.col_TabEmporeSlctd.switchLowerBytes());
                  SetTextColor( aHDc, theConfig.col_TabFontSlctd.switchLowerBytes());
          End;

          // the calc's with font height / width are subject to test+change
          If ( tpLeft= aTabPos)
             Then
             Begin
                  SetTextAlign( aHDc, VTA_CENTER);
                  vtRe1.Left  := vtRe1.Left  + ( theConfig.int_TabFontHeight Div 3);
                  vtRe1.Bottom:= vtRe1.Bottom+ ( theConfig.int_TabFontWidth  *   2);
                  drawText    ( aHDc, pChar( vStTxt), length( pChar( vStTxt)), vtRe1, DT_SINGLELINE Or DT_VCENTER Or DT_NOCLIP);
             End
          Else
             If ( tpRight= aTabPos)
                Then
                Begin
                     SetTextAlign  ( aHDc, VTA_CENTER);
                     vtRe1.Left  := vtRe1.Left  + ( theConfig.int_TabFontHeight *   1)+ ( theConfig.int_TabFontHeight Div 3);
                     vtRe1.Bottom:= vtRe1.Bottom+ ( theConfig.int_TabFontWidth  *   2);
                     drawText      ( aHDc, pChar( vStTxt), length( pChar( vStTxt)), vtRe1, DT_SINGLELINE Or DT_VCENTER Or DT_NOCLIP);
                End
             Else    // top or bottom
                Begin
                     vtRe1.Top += 1;
                     drawText( aHDc, pChar( vStTxt), length( pChar( vStTxt)), vtRe1, DT_CENTER Or DT_VCENTER Or DT_SINGLELINE Or DT_NOCLIP);

          End;
End;

Procedure
          tHelpObj.condDrawFocusRct( aHDc: hDc; aTabRect: tRect; aIsSel: boolEan); StdCall;
Var

          vtRe1                             : tRect;
Begin
          vtRe1 := aTabRect;

          If aIsSel
             Then
             Begin
                  vtRe1.Top   += 2;
                  vtRe1.Left  += 2;
                  vtRe1.Width := vtRe1.Width -2;
                  vtRe1.Height:= vtRe1.Height-2;
                  drawFocusRect( aHDc, vtRe1);
          End;

End;


Procedure
          tHelpObj.paintTabs( aHWnd: hWND); StdCall;
Var

          vtPs1                             : winDOwS.tPaintStruct;

          vtRe1                             : tRect;

          vhDc1                             : hDc;

          vLoIdx                            : longInt;
          vLoOne                            : longInt;
          vLRsTabCnt                        : lResult;

          vTCitm                            : TC_ITEM;
          vStTxt                            : String;

          vtLgFnt                           : tLogFont;
          vthFont                           : hFont;

          vBoIsSel                          : boolEan;

          vtSrcWndDta                       : tSrcWindowData;
Begin
          getSrcWndDta( aHwnd, vtSrcWndDta);

          // prevent "does not seem to be initialized"
          vtPs1.hdc               := 0;
          vtRe1.Top               := 0;
          vhDc1                   := winDOwS.beginPaint( aHWnd, vtPs1);

          vTCitm                  := TcItem.initIalize( 256, TCIF_TEXT);

          vLRsTabCnt              := TabCtrl_GetItemCount( aHWnd);
          vLoIdx                  := TabCtrl_GetCurSel( aHwnd);

          getClientRect( aHwnd, vtRe1);

          paintFilledRect( vhDc1, vtRe1, colorToRgb( clBtnFace));

          prepareLogFont( tpPosition, vtLgFnt);
          vthFont                 := createFontIndirect( vtLgFnt);
          selectObject( vhDc1, vthFont);

          For vLoOne:= 0 to vLRsTabCnt- 1
              Do
              Begin
                   TabCtrl_GetItem( aHwnd, vLoOne, vTCitm);
                   TabCtrl_GetItemRect( aHwnd, vLoOne, vtRe1);

                   vBoIsSel       := ( vLoIdx= vLoOne);

                   vStTxt         := vTCitm.pszText;

                   paintTabRect( vhDc1, vtRe1, vBoIsSel);
                   drawTabText ( vhDc1, tpPosition, vStTxt, vtRe1, vBoIsSel);

                   showBmpFromRes( vtSrcWndDta, vhDc1, vtRe1, vLoOne, vBoIsSel);
                   condDrawFocusRct( vhDc1, vtRe1, vBoIsSel);
          End;

          deleteObject( vthFont);
          endPaint( aHWnd, vtPs1);
          vTCitm.deInitIalize( vTCitm);
End;



Function
          tHelpObj.getTabPositionByHandle( aHwndSTC: hWnd): tTabPosition;
Var
          vLoRes                            : longInt;
Begin
          Result:= tpTop;

          If ( ( 0= aHwndSTC) Or ( hWnd( -1)= aHwndSTC))
             Then
             Exit;

          vLoRes:= winDOwS.getWindowLong( aHwndSTC, GWL_STYLE);
          If ( ( TCS_VERTICAL And vLoRes)<> 0)
             Then
             Begin
                  If ( ( TCS_RIGHT And vLoRes)<> 0)
                     Then
                     Begin
                          Result:= tpRight;
                     End
                  Else
                     Begin
                          Result:= tpLeft;
                  End;
             End
          Else
             Begin
                  If ( ( TCS_BOTTOM And vLoRes)<> 0)
                     Then
                     Begin
                          Result:= tpBottom;
                  End;

          End;

End;

Procedure
          tHelpObj.replaceOneWinProc( aSrcWin: tSourceEditorWindowInterface);
Var
          vtSrvWndDta                       : tSrcWindowData;
Begin
          If ( Nil= aSrcWin)
             Then
             Exit;

          vtSrvWndDta:= swdcSrcWndDatas.add() As tSrcWindowData;
          vtSrvWndDta.init( aSrcWin);

End;

Procedure
          tHelpObj.replaceWinProcs();
Var
          vIn1                              : intEger;
Begin

          If Not assigned( SrcEditorIntf.SourceEditorManagerIntf)
             Then
             Begin
                  messageDlg( 'LazWinColEdTabs', 'SrcEditorIntf.SourceEditorManagerIntf is still not assigned', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  tmrStart.Enabled:= True;
                  Exit;
          End;

          If Not assigned( IDEOptEditorIntf.IDEEditorOptions)
             Then
             showMessage( 'Nil= IDEEditorOptions') // timer ivl too short ?
          Else
             Begin
                  IDEOptEditorIntf.IDEEditorOptions.addHandlerAfterWrite( @afterIDEOptionsWritten, False);
          End;

          For vIn1:= 0 To SrcEditorIntf.SourceEditorManagerIntf.SourceWindowCount- 1
              Do
              replaceOneWinProc( SrcEditorIntf.SourceEditorManagerIntf.SourceWindows[ vIn1]);


End;


Procedure
          tHelpObj.startTimer( aSender: tObject);

Begin
          _nOp( [ aSender]);
          tmrStart.Enabled:= False;

          // if no project is assigned - then the project dialog might be loaded after "close project" - so we'll wait
          If ( Not assigned( Project1))
             Then
             Begin
                  init( 2500);  // wait somewhat longer, cause the dlg might be open a long time
             End
          Else
             Begin
                  theConfig           := getConfig();
                  theConfig.ApplyCB   := @Self.cfgApplyCB;
                  str_cbsStyle:= getEnumName( typeInfo( tLWCETConfig.tCloseButtonStyle), intEger( theConfig.cbs_CloseBtnStyle));

                  tpPosition:= IDEOptEditorIntf.IDEEditorOptions.TabPosition;
                  replaceWinProcs();
          End;

End;


Procedure
          tHelpObj.lwcetReInit( aSender: tObject);
Var
          vStMsg                            : String;
Begin
          _nOp( [ aSender]);

          vStMsg:= '(Re-)Aktivieren für aktive Editorfenster ?';
          If ( mrYes= messageDlg( 'LazWinColEdTabs', vStMsg, tMsgDlgType.mtInformation, [ tMsgDlgBtn.mbYes, tMsgDlgBtn.mbClose] , 0))
             Then
             Begin
                  deInit();
                  init( 0);
          End;

End;

Procedure
          tHelpObj.CfgApplyCB( aSender: tLWCETConfig);
Begin
          If ( Nil= aSender)
             Then
             Exit;

          theConfig.assign( aSender);
          str_cbsStyle:= getEnumName( typeInfo( tLWCETConfig.tCloseButtonStyle), intEger( theConfig.cbs_CloseBtnStyle));
          init( 300);
          setConfig( aSender);
End;

Function
          tHelpObj.getSrcWndDta( aHWnd: hWnd; Out aOutSrcWndDta: tSrcWindowData): boolEan;
Begin
          Result         := False;
          aOutSrcWndDta  := Nil;

          If ( Nil= swdcSrcWndDatas)
             Then
             Exit;

          aOutSrcWndDta  := swdcSrcWndDatas[ aHwnd];
          Result         := ( Nil<> aOutSrcWndDta);

End;



Procedure
          tHelpObj.signalClosableTab( aHwnd: hWnd; aTabIdx: intEger);
Var
          vtSrcWndDta                       : tSrcWindowData;
Begin
          If ( Not getSrcWndDta( aHwnd, vtSrcWndDta))
             Then
             Exit;

          vtSrcWndDta.setClosableTab( aTabIdx);
End;

Procedure
          tHelpObj.resetClosableTab ();
Var
          vtSrcWndDta                       : tCollectionItem;
Begin
          If ( Nil= swdcSrcWndDatas)
             Then
             Exit;

          For vtSrcWndDta In swdcSrcWndDatas
              Do
              //tSrcWindowData( vtSrcWndDta).intClsblTabIdx:= -1;
              tSrcWindowData( vtSrcWndDta).setClosableTab( -1);
End;

Procedure
          tHelpObj.signalCloseTabNow( aHwnd: hWnd; aTabIdx: intEger);
Var
          vtSrcWndDta                       : tSrcWindowData;
          vtCtl1                            : tControl;
          vIn1                              : intEger;
Begin
          If ( Not getSrcWndDta( aHwnd, vtSrcWndDta))
             Then
             Exit;

          If ( vtSrcWndDta.intClsblTabIdx= aTabIdx)  // #todo : unnecessary if ?
             Then
             If ( Nil<> vtSrcWndDta.SrcForm)
                Then
                Begin
                     For vIn1:= 0 To vtSrcWndDta.SrcForm.ControlCount- 1
                         Do
                         Begin
                              vtCtl1:= vtSrcWndDta.SrcForm.Controls[ vIn1];
                              If vtCtl1 Is tExtendedNotebook // is not a tTabControl but a custom one
                                 Then
                                 Begin
                                      tExtendedNotebook( vtCtl1).DoCloseTabClicked( tExtendedNotebook( vtCtl1).Pages[ aTabIdx]);
                                      Exit;
                              End;
                     End;
             End;

End;


Procedure
          tHelpObj.lwcetEdtCfg( aSender: tObject);
Var
          vtCfg1                            : tLWCETConfig;
Begin
          _nOp( [ aSender]);

          Try
             imcCmd_EDTCFG.Enabled:= False;

             vtCfg1:= theConfig.clone();

             If ( mrOk= tfrm_edtcfg_.exeCute( Nil, vtCfg1))
                Then
                Begin
                     theConfig.assign( vtCfg1);
                     str_cbsStyle:= getEnumName( typeInfo( tLWCETConfig.tCloseButtonStyle), intEger( theConfig.cbs_CloseBtnStyle));
                     init( 300);
                     setConfig( vtCfg1);
             End;
             freeAndNil( vtCfg1);

          Except End;
          imcCmd_EDTCFG.Enabled:= True;

End;



Procedure
          tHelpObj.init( aWaitTime: dWord= 500);
Begin

          IF ( Nil= tmrStart)
             Then
             tmrStart        := tTimer.create( Nil);

          tmrStart.Enabled   := False;

          If ( 0< aWaitTime)
             Then
             Begin
                  tmrStart.Interval  := aWaitTime;
                  tmrStart.OnTimer   := @startTimer;
                  tmrStart.Enabled   := True;
             End
          Else
             startTimer( Nil);

End;

Procedure
          tHelpObj.deInit();
Begin
          swdcSrcWndDatas.deInit();

End;

Procedure
          tHelpObj.checkOptionsChanged();
Var
          vtTbPos                           : tTabPosition;
Begin

          If Not assigned( IDEOptEditorIntf.IDEEditorOptions)
             Then
             Exit;

          Try
             vtTbPos:= IDEOptEditorIntf.IDEEditorOptions.TabPosition;
             If ( tpPosition<> vtTbPos)
                Then
                Begin
                     tpPosition:= vtTbPos;
                     deInit();
                     init( 500);
             End;
          Except End;
End;

Procedure
          tHelpObj.afterIDEOptionsWritten( aSender: tObject; aDoRestore: Boolean);
Begin
          _nOp( [ aSender, aDoRestore]);

          checkOptionsChanged();
End;

Procedure
          tHelpObj.loadBitmaps();
Var
          vtSlStyles                        : tStringList;
          vtSlTypes                         : tStringList;

          vtSlBmps                          : tStringList;
          aosBmpNms                         : tStringArray;

          vInOneS                           : intEger;
          vInCntS                           : intEger;

          vInOneT                           : intEger;
          vInCntT                           : intEger;

          vStOnBmNme                        : String;

Begin
          vtSlStyles := tStringList.create();
          vtSlTypes  := tStringList.create();

          vtSlBmps   := tStringList.create();

          vInCntS    := fillCloseButtonStyles( vtSlStyles, 0);
          vInCntT    := fillEnumNames        ( typeInfo( tCloseButtonType), vtSlTypes, 0);

          For vInOneS:= 1 To vInCntS- 1     // for "none" we don't have any btmp ;-)
              Do
              Begin
                   For vInOneT:= 0 To vInCntT- 1
                       Do
                       Begin
                            vStOnBmNme:= ( vtSlStyles[ vInOneS]+ '_'+ vtSlTypes[ vInOneT]).toLower();
                            vtSlBmps.add( vStOnBmNme);
                   End;
          End;
          aosBmpNms := vtSlBmps.toStringArray();

          lbmImgs   := tLitteBmpMgr.create( aosBmpNms);

          aosBmpNms := [];
          freeAndNil( vtSlBmps);
          freeAndNil( vtSlStyles);
          freeAndNil( vtSlTypes);


End;

Constructor
          tHelpObj.create();

Begin
          imcCmd_EDTCFG       := Nil;

          theConfig           := getConfig();       // at this point the cfg might be come from another folder (user-appdata-lazarus)
          theConfig.ApplyCB   := @Self.cfgApplyCB;
          //setConfig( theConfig);

          loadBitmaps();
          str_cbsStyle        := getEnumName( typeInfo( tLWCETConfig.tCloseButtonStyle), intEger( ccbs_CloseBtnStyle));


          //lbmImgs             := tLitteBmpMgr.create( [
          //                                            cstr_RESNME_CLSBTN_CL_STD_12    , cstr_RESNME_CLSBTN_CL_SEL_12    , cstr_RESNME_CLSBTN_CL_CBL_12,
          //                                            cstr_RESNME_CLSBTN_RA_STD_12    , cstr_RESNME_CLSBTN_RA_SEL_12    , cstr_RESNME_CLSBTN_RA_CBL_12
          //                                            ]);

          swcSrcNbk           := Nil;
          dwSrcWinCnt         := -1;

          swdcSrcWndDatas     := tSrcWindowDataColl.create();
          tmrStart            := Nil;

          intEger( tpPosition):= -1;

          dwProcessId:= getCurrentProcessId();
          If ( 0= dwProcessId)
             Then
             Begin
                  messageDlg( 'LazWinColEdTabs', 'getCurrentProcessId() returned 0', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  exit;
          End;


End;


Initialization
Begin
          ho_Obj:= tHelpObj.Create();

End;

Finalization
Begin
          // maybe later
End;

End.

