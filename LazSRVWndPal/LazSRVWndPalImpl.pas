          { Copyright (C) 2026  StOver }
          {$CODEPAGE UTF8}
Unit
          LazSRVWndPalImpl;

          {$mode objfpc}{$H+}
          {$ModeSwitch typehelpers}


          {$Define FUN}

          //

Interface


Procedure
          Register;

implementation

Uses
          Classes
          ,
          SysUtils
          ,
          Forms
          ,
          Dialogs
          ,
          menuintf
          ,
          menus
          ,
          IDECommands
          ,
          ToolBarIntf
          ,
          IDEWindowIntf
          ,
          LazIDEIntf
          ,
          ExtendedNotebook
          ,
          TreeFilterEdit
          ,
          lcltype
          ,
          conTrols
          ,
          {$IFDEF FUN}
          stdCtrls
          ,
          {$ENDIF}
          extCtrls
          ,
          comCtrls
          ,
          IDEExternToolIntf
          ,
          graPhics
          ,
          butTons
          ;



          {$R LazSRVWndPal_Images.res}

Const
          // command
          SMWH_CAPTION                      = 'lazsrvwndpal';
          {$IFDEF FUN}
          FUN_TSH_CAPTION                   = 'Lazarus Search Window Pal';
          {$ENDIF}

Resourcestring

          SMWH_CAPTION_IDEMenuCaption       = 'Search results font height';

Type


          { tHelpObj }

          tHelpObj                          = Class( tObject)

          Private

             tmrStSRVPal                    : extCtrls.tTimer;

             {$IFDEF FUN}
             ts_MyTabSheet                  : tTabSheet;
             {$ENDIF}

          Public

             Procedure                      lmwpEdtCfg( aSender: tObject);

             Constructor                    create();

             Function                       getSubCtrlByClass( aParentCtrl: tWinControl; aClass: tControlClass; Out aOutCtrl: tControl; aOptRecursive: boolEan= False): boolEan;
             Function                       getSearchResWin( Out aOutForm: tForm): boolEan;

             {$IFDEF FUN}
             Procedure                      closeMyTabSheet( aSender: tObject);
             {$ENDIF}

             Procedure                      changeSRVWndFontHeight( aFontHeight: intEger);

             Procedure                      startTimer( aSender: tObject);

             Procedure                      init( aWaitTime: dWord= 250);
             Procedure                      deInit();

          End;


Var
          imcCmd_MWPSettings                : tIDEMenuCommand= Nil;

          {%H-}ho_Obj                       : tHelpObj= Nil;
          {%H+}

          {$hints off}
Procedure
          nOp( aSender : tObject);
Begin

End;
          {$hints off}
Procedure // helper proc that makes compiler shut up for not (yet) used arguments
          _nOp( Const aAOC: Array Of Const);
Begin
          //
End;
          {$hints on}

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
Begin
          imcCmd_MWPSettings        := registerOneCmd( SMWH_CAPTION, SMWH_CAPTION_IDEMenuCaption, @ho_Obj.lmwpEdtCfg);
          imcCmd_MWPSettings.Enabled:= True;

          If ( Nil= ho_Obj)
             Then
             Begin
                  messageDlg( 'LazSRVWndPal', 'ho_Obj is Nil', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  exit;
          End;

          ho_Obj.init();

End;



          { tHelpObj }

Function
          tHelpObj.getSearchResWin( Out aOutForm: tForm): boolEan;
Const
          cstr_SRW_CLSNAME                  = 'TSEARCHRESULTSVIEW';
          cstr_SRW_CAPTION                  = 'SEARCH RESULTS';                     // might be other caption with other langs #todo check it :)
Var
          vInOne                            : intEger;
          vInCnt                            : intEger;
          vStCNm                            : String;
          vStCpn                            : String;
          vtFrm                             : tForm;

Begin
          Result  := False;
          aOutForm:= Nil;

          vInCnt:= Screen.FormCount;

          For vInOne:= 0 To vInCnt- 1
              Do
              Begin
                   vtFrm:= Screen.Forms[ vInOne];
                   If ( Nil= vtFrm)
                      Then
                      conTinue;

                   vStCNm:= String( vtFrm.className()).toUpper();
                   vStCpn:= String( vtFrm.Caption).toUpper();
                   If ( cstr_SRW_CLSNAME= vStCNm)
                      And
                      ( cstr_SRW_CAPTION= vStCpn)
                      And
                      ( vtFrm.Showing)
                      Then
                      Begin
                           aOutForm:= vtFrm;

                           break;
                   End;
          End;
          Result:= ( Nil<> aOutForm);

End;

Function  // returns fst occurence
          tHelpObj.getSubCtrlByClass( aParentCtrl: tWinControl; aClass: tControlClass; Out aOutCtrl: tControl; aOptRecursive: boolEan= False): boolEan;
Var
          vInCnt                            : intEger;
          vInOne                            : intEger;
          vtCtl1                            : tControl;

Begin
          Result    := False;
          aOutCtrl  := Nil;

          If Not assigned( aParentCtrl)
             Then
             Exit;

          vInCnt    := aParentCtrl.ControlCount;
          For vInOne:= 0 To vInCnt- 1
              Do
              Begin
                   vtCtl1:= aParentCtrl.Controls[ vInOne];
                   If vtCtl1 Is aClass
                      Then
                      Begin
                           aOutCtrl:= vtCtl1 As aClass;
                           Result  := ( Nil<> aOutCtrl);
                           Exit;
                   End;
                   If ( vtCtl1 Is tWinControl) And aOptRecursive
                      Then
                      Begin
                           If getSubCtrlByClass( ( vtCtl1 As tWinControl), aClass, vtCtl1, aOptRecursive)
                              Then
                              Begin
                                   aOutCtrl:= vtCtl1 As aClass;
                                   Result  := ( Nil<> aOutCtrl);
                                   Exit;
                           End;
                   End;
          End;
End;

          {$IFDEF FUN}

Procedure
          tHelpObj.closeMyTabSheet( aSender: tObject);
Begin
          _nOp( [ aSender]);

          If ( Nil<> ts_MyTabSheet)
             Then
             Try
                ts_MyTabSheet.PageControl.doCloseTabClicked( ts_MyTabSheet);
             Except End;
End;
          {$ENDIF}

Procedure
          tHelpObj.changeSRVWndFontHeight( aFontHeight: intEger);
Var
          vtFrm                             : tForm;
          vtCtl1                            : tControl;
          vtXNb                             : tExtendedNotebook;
          vtTFe                             : tTreeFilterEdit;
          {$IFDEF FUN}
          vtTbSht                           : tTabSheet;
          vtLbl1                            : tLabel;
          vtBitBtn                          : tBitBtn;
          {$ENDIF}
Begin

          If not assigned( LazIDEIntf.LazarusIDE)
             Then
             Exit;

          Try
             LazIDEIntf.LazarusIDE.doShowSearchResultsView( iwgfShow);

             If Not getSearchResWin( vtFrm)
                Then
                Begin
                     showMessage( 'Couln''t get search results window!');
                     exit;
             End;

             vtFrm.Visible             := True;
             vtFrm.bringToFront();
             vtFrm.Font.Height         := aFontHeight;

             If Not getSubCtrlByClass( vtFrm, tExtendedNotebook, vtCtl1)
                Then
                Begin
                     showMessage( 'Couln''t get search results page control!');
                     exit;
             End;

             vtXNb                     := vtCtl1 As tExtendedNotebook;
             vtXNb.ParentFont          := False;

             If getSubCtrlByClass( vtFrm, TTreeFilterEdit, vtCtl1, True)
                Then
                Begin
                     vtTFe                := vtCtl1 As tTreeFilterEdit;
                     vtTFe.Font.Height    := aFontHeight;
                     vtTFe.AutoSize       := True;
                     vtTFe.Parent.AutoSize:= True;
             End;

             vtXNb.Font.Height         := aFontHeight;

             {$IFDEF FUN}
             // this part is just for FUN
             // ->
             vtTbSht                   := vtXNb.addTabSheet();
             vtTbSht.Caption           := FUN_TSH_CAPTION;

             vtLbl1                    := tLabel.create( vtTbSht);
             vtLbl1   .Align           := alClient;
             vtLbl1.Alignment          := taCenter;
             vtLbl1.Color              := clLime;
             vtLbl1.Font.Color         := clBlack;
             vtLbl1.Font.Height        := aFontHeight;
             vtLbl1.Caption            := 'Font height is '+ vtLbl1.Font.Height.toString();

             vtLbl1.Parent             := vtTbSht;
             vtLbl1.ParentColor        := False;
             vtLbl1.Transparent        := False;

             vtBitBtn                  := tBitBtn.create( vtTbSht);
             vtBitBtn.Height           := aFontHeight* 2;
             vtBitBtn.Align            := alBottom;
             vtBitBtn.Caption          := 'Close';
             vtBitBtn.Kind             := bkClose;
             vtBitBtn.Kind             := bkCustom;
             vtBitBtn.GlyphShowMode    := gsmAlways;
             vtBitBtn.ModalResult      := mrNone;
             vtBitBtn.Layout           := blGlyphTop;

             vtBitBtn.OnClick          := @closeMyTabSheet;
             ts_MyTabSheet             := vtTbSht;

             vtBitBtn.Parent           := vtTbSht;


             // <-
             {$ENDIF}

             Except
               On E: Exception
                  Do
                  showMessage( E.Message);
             End;
End;

Procedure
          tHelpObj.startTimer( aSender: tObject);

Begin
          _nOp( [ aSender]);
          tmrStSRVPal.Enabled:= False;

          {$IFDEF LINUX}
          changeSRVWndFontHeight( 26);
          {$ELSE}
          changeSRVWndFontHeight( 25);
          {$ENDIF}
End;


Procedure
          tHelpObj.init( aWaitTime: dWord= 250);
Begin

          IF ( Nil= tmrStSRVPal)
             Then
             tmrStSRVPal        := tTimer.create( Nil);

          tmrStSRVPal.Enabled   := False;

          If ( 0< aWaitTime)
             Then
             Begin
                  tmrStSRVPal.Interval  := aWaitTime;
                  tmrStSRVPal.OnTimer   := @startTimer;
                  tmrStSRVPal.Enabled   := True;
             End
          Else
             startTimer( Nil);

End;

Procedure
          tHelpObj.deInit();
Begin
          // maybe later

End;


Procedure
          tHelpObj.lmwpEdtCfg( aSender: tObject);

Begin
          nOp( aSender);
          showMessage(
                      'Sorry guys, settings window to adjust the font height is not implemented yet :/'+
                      LineEnding+
                      'Just change the call to changeSRVWndFontHeight()!'
                     );
End;


Constructor
          tHelpObj.create();
Begin
          tmrStSRVPal            := Nil;
          {$IFDEF FUN}
          ts_MyTabSheet          := Nil;
          {$ENDIF}
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

