          { Copyright (C) 2025  StOver }
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


Procedure
          Register;

Implementation

Uses
          winDOwS
          ,
          Classes
          ,
          SysUtils
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
          ToolBarIntf
          ,
          SrcEditorIntf
          ,
          IDEWindowIntf
          ,
          graPhics
          ,
          iu_WinMessages
          ,
          iu_DateTime
          ;

          {$R LazWinColEdTabs_Images.res}

Const
          // command
          SABOUT_ADDINN                     = 'about_lazwincoledtabs';

Resourcestring

          SABOUT_ADDINN_IDEMenuCaption      = 'LazWinColEdTabs V 0.0.1';

Type

          { tHTypeHelperString }

          tHTypeHelperString                = Type Helper( tStringHelper) For String

             Function                       saveToFile( aFileName: String; aDoAppend: boolEan= False): boolEan;

          End;

          { tHTypeHelperLong }

          tHTypeHelperLong                  = Type Helper( tLongIntHelper) For longInt

             Function                       toColorRef(): longInt;

          End;



          { tHelpObj }


          tHelpObj                          = Class( tObject)

          Private

             tcHwnd                         : hWnd;
             oldWDP                         : LONG_PTR;
             vtLgFnt                        : tLogFont;
             dwProcessId                    : dWord;

             tmrStart                       : extCtrls.tTimer;

          Protected

             Procedure                      paintTabs( aHWnd: hWND); StdCall;

             Procedure                      startTimer( aSender: tObject);

             Procedure                      init();

          Public

             Procedure                      aboutAddInn( aSender: tObject);

             Constructor                    create();
          End;


Var
          //imcCmd_ABTADI                     : tIDEMenuCommand= Nil;

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
          imcCmd_ABTABT                     : tIDEMenuCommand;
Begin
          imcCmd_ABTABT    := registerOneCmd( SABOUT_ADDINN, SABOUT_ADDINN_IDEMenuCaption, @ho_Obj.aboutAddInn);

          imcCmd_ABTABT.Enabled:= False;  // later for multi window and reinit etc.

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

Begin
          Result:= False;

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
          End;

End;

          { tHTypeHelperLong }

Function
          tHTypeHelperLong.toColorRef(): longInt;

Begin
          Result:= ( ( Self And $0000FF) Shl 16)
                   Or
                   ( ( Self And $00FF00)       )
                   Or
                   ( ( Self And $FF0000) Shr 16)
                   ;
End;




          { tHelpObj }  // and associates :)

Procedure
          tHelpObj.paintTabs( aHWnd: hWND); StdCall;
Var

          vtPs1                             : winDOwS.tPaintStruct;

          vtRe1                             : tRect;
          vhDc1                             : hDc;
          vhBrush                           : hBrush;

          vLoIdx                            : longInt;
          vLoOne                            : longInt;
          vLRsTabCnt                        : lResult;

          vTCitm                            : TC_ITEM;

          vStTxt                            : String;

          vthFont                           : hFont;


Begin
          vTCitm.pszText          := getMem( 256);
          vTCitm.cchTextMax       := 255;
          vTCitm.mask             := TCIF_TEXT;
          vTCitm.lParam           := 0;

          vLRsTabCnt              := TabCtrl_GetItemCount( aHWnd);
          vLoIdx                  := TabCtrl_GetCurSel( aHwnd);

          // prevent "does not seem to be initialized"
          vtPs1.hdc               := 0;
          vtRe1.Top               := 0;

          vhDc1                   := winDOwS.beginPaint( aHWnd, vtPs1);

          getClientRect( aHwnd, vtRe1);

          vhBrush                 := createSolidBrush( colorToRGB( clBtnFace));
          fillRect( vhDc1, vtRe1, vhBrush);
          deleteObject( vhBrush);

          vtLgFnt.lfHeight        := 14;
          vtLgFnt.lfWidth         := 6;
          vtLgFnt.lfEscapement    := 0;
          vtLgFnt.lfOrientation   := 0;
          vtLgFnt.lfWeight        := FW_NORMAL;
          vtLgFnt.lfItalic        := 0;
          vtLgFnt.lfUnderLine     := 0;
          vtLgFnt.lfStrikeOut     := 0;
          vtLgFnt.lfCharSet       := DEFAULT_CHARSET;
          vtLgFnt.lfOutPrecision  := OUT_DEFAULT_PRECIS;
          vtLgFnt.lfClipPrecision := CLIP_DEFAULT_PRECIS;
          vtLgFnt.lfQuality       := CLEARTYPE_QUALITY;
          vtLgFnt.lfPitchAndFamily:= VARIABLE_PITCH;
          vtLgFnt.lfFaceName      := 'Tahoma'#0;

          vthFont                 := createFontIndirect( vtLgFnt);
          selectObject( vhDc1, vthFont);

          For vLoOne:= 0 to vLRsTabCnt- 1
              Do
              Begin
                   TabCtrl_GetItem( aHwnd, vLoOne, vTCitm);
                   TabCtrl_GetItemRect( aHwnd, vLoOne, vtRe1);

                   vhBrush:= createSolidBrush( $00FFFFFF.toColorRef());
                   fillRect( vhDc1, vtRe1, vhBrush);
                   deleteObject( vhBrush);

                   vtRe1.Top += 1;
                   vtRe1.Left+= 1;
                   vhBrush:= createSolidBrush( $00999975.toColorRef());
                   fillRect( vhDc1, vtRe1, vhBrush);
                   deleteObject( vhBrush);

                   vtRe1.Width := vtRe1.Width - 1;
                   vtRe1.Height:= vtRe1.Height- 1;

                   If ( vLoIdx<> vLoOne)
                      Then
                      Begin
                           vhBrush:= createSolidBrush( $00E7E8A8.toColorRef());
                           fillRect( vhDc1, vtRe1, vhBrush);
                           deleteObject( vhBrush);
                           setBkColor( vhDc1, $00E7E8A8.toColorRef());
                           SetTextColor( vhDc1, $00FF0000);
                      End
                   Else
                      Begin
                           vhBrush:= createSolidBrush( $00FF0000);
                           fillRect( vhDc1, vtRe1, vhBrush);
                           deleteObject( vhBrush);

                           vtRe1.Left:= vtRe1.Left+ 2;
                           vtRe1.Top:= vtRe1.Top+ 1;
                           vtRe1.Width:= vtRe1.Width- 2;
                           vtRe1.Height:= vtRe1.Height- 1;

                           setBkColor( vhDc1, $00FF0000);
                           SetTextColor( vhDc1, $00E7E8A8.toColorRef());
                   End;

                   vStTxt:= vTCitm.pszText;
                   selectObject( vhDc1, vthFont);
                   vtRe1.Top+= 1;

                   DrawText( vhDc1, pChar( vStTxt), length( pChar( vStTxt)), vtRe1, DT_CENTER Or DT_VCENTER Or DT_SINGLELINE Or DT_NOCLIP);

                   vtRe1.Top  -= 1;

                   If ( vLoIdx= vLoOne)
                      Then
                      drawFocusRect( vhDc1, vtRe1);

          End;
          deleteObject( vthFont);
          endPaint( aHWnd, vtPs1);
          freeMem( vTCitm.pszText);
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


Function
          _wndProc ( aHWnd: hWND; aMsg: uINT; aWParam: wPARAM; aLParam: lPARAM): lResult; StdCall;
Begin

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

          If ( 0<> ho_Obj.oldWDP)
             Then
             {$warnings off} {$hints off}
             Result:= CallWindowProcW( WndProc( ho_Obj.oldWDP), aHWnd, aMsg, aWParam, aLParam);
             {$warnings on}  {$hints on}
End;

Function
          enumChildWindowsProc( aHwnd: hWnd; aLParam: lParam): WinBool; Stdcall;
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

Begin
          _nOp( [ aHwnd, aLParam]);

          If ( Nil= ho_Obj)
             Then
             Begin
                  messageDlg( 'LazWinColEdTabs', 'ho_Obj is Nil', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  exit;
          End;

          vTCitm.pszText   := getMem( 256);
          vTCitm.cchTextMax:= 255;
          vTCitm.mask      := TCIF_TEXT;
          vTCitm.lParam    := 0;

          Result:= True;
          vLoCNLen:= getClassName( aHwnd, @aocClsNme, cLoBuf);
          If ( 0< vLoCNLen)
             Then
             Begin
                  vStClsNme:= pChar( @aocClsNme);
                  If ( 'SysTabControl32'= vStClsNme)
                     Then
                     Begin
                          ho_Obj.tcHwnd:= aHwnd;
                          TabCtrl_SetPadding( aHwnd, 20, 4); // this makes the tabs more comfortable

                          ho_Obj.oldWDP:= getWindowLongPtr( aHwnd, GWLP_WNDPROC);

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

                          // the trick (part 2) below makes the tabcontrol redraw even in multiline mode
                          vtSrcEdCur              := SrcEditorIntf.SourceEditorManagerIntf.ActiveEditor;
                          vLoCnt                  := SrcEditorIntf.SourceEditorManagerIntf.SourceEditorCount;

                          SrcEditorIntf.SourceEditorManagerIntf.ActiveEditor:= SrcEditorIntf.SourceEditorManagerIntf.SourceEditors[ vLoCnt- 1];
                          SrcEditorIntf.SourceEditorManagerIntf.ActiveEditor:= SrcEditorIntf.SourceEditorManagerIntf.SourceEditors[ 0];

                          SrcEditorIntf.SourceEditorManagerIntf.ActiveEditor:= vtSrcEdCur;

                  End;
          End;
End;

Procedure
          tHelpObj.startTimer( aSender: tObject);
Var
          vtHWndOne                         : hWnd;
          vIn1                              : intEger;

Begin
          _nOp( [ aSender]);
          tmrStart.Enabled:= False;

          If Not assigned( SrcEditorIntf.SourceEditorManagerIntf)
             Then
             Begin
                  messageDlg( 'LazWinColEdTabs', 'SrcEditorIntf.SourceEditorManagerIntf is still not assigned', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  tmrStart.Enabled:= True;
                  Exit;
          End;

          For vIn1:= 0 To SrcEditorIntf.SourceEditorManagerIntf.SourceWindowCount- 1
              Do
              Begin
                   vtHWndOne:= SrcEditorIntf.SourceEditorManagerIntf.SourceWindows[ vIn1].Handle;
                   If Not IsWindowVisible( vtHWndOne)
                      Then
                      continue;

                   enumChildWindows( vtHWndOne, @enumChildWindowsProc, 0);

                   break;

          End;

End;


Procedure
          tHelpObj.aboutAddInn( aSender: tObject);
Var
          vStMsg                            : String;
Begin
          _nOp( [ aSender]);

          {$IFDEF WINDOWS}
          vStMsg:= '(Re-)Aktivieren für aktive Editorfenster ?';
          If ( mrYes= messageDlg( 'LazWinColEdTabs', vStMsg, tMsgDlgType.mtInformation, [ tMsgDlgBtn.mbYes, tMsgDlgBtn.mbClose] , 0))
             Then
             init();
          {$ELSE}
          vStMsg:= 'This add-in is only intended for use with Windows!;
          messageDlg( 'LazWinColEdTabs', vStMsg, tMsgDlgType.mtWarning    , [ tMsgDlgBtn.mbCancel], 0);
          Exit;
          {$ENDIF}


End;

Procedure
          tHelpObj.init();
Begin
          oldWDP             := 0;

          IF ( Nil= tmrStart)
             Then
             tmrStart        := tTimer.create( Nil);

          tmrStart.Interval  := 500;
          tmrStart.OnTimer   := @startTimer;
          tmrStart.Enabled   := True;


End;

Constructor
          tHelpObj.create();
Begin
          tmrStart   := Nil;
          tcHwnd     := 0;

          dwProcessId:= getCurrentProcessId();
          If ( 0= dwProcessId)
             Then
             Begin
                  messageDlg( 'LazWinColEdTabs', 'getCurrentProcessId() returned 0', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  exit;
          End;

          init();
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

