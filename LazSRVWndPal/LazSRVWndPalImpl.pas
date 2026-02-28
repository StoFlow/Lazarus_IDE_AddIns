          { Copyright (C) 2026  StOver }
          {$CODEPAGE UTF8}
Unit
          LazSRVWndPalImpl;

          {$mode objfpc}{$H+}
          {$ModeSwitch typehelpers}


          //{$Define FUN}


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
          iu_LSWPBGRColor
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
          ,
          iu_LSWPConf
          ,
          su_LSWPConf
          ,
          frm_LSWPEdtCfg
          ;



          {$R LazSRVWndPal_Images.res}

Const
          // command
          SSWH_CAPTION                      = 'lazsrvwndpal';
          {$IFDEF FUN}
          FUN_TSH_CAPTION                   = 'Lazarus Search Window Pal';
          {$ENDIF}

Resourcestring

          SSWH_CAPTION_IDEMenuCaption       = 'Search results font height';

Type


          { tHelpObj }

          tHelpObj                          = Class( tObject)

          Private

             tmrStSRVPal                    : extCtrls.tTimer;

             theConfig                      : tLSWPConfig;

             {$IFDEF FUN}
             ts_MyTabSheet                  : tTabSheet;
             {$ENDIF}

          Public

             Procedure                      lswpEdtCfg( aSender: tObject);

             Procedure                      cfgApplyCB( aSender: tLSWPConfig);

             Constructor                    create();

             Function                       getSubCtrlByClass( aParentCtrl: tWinControl; aClass: tControlClass; Out aOutCtrl: tControl; aOptRecursive: boolEan= False): boolEan;
             Function                       getSearchResWin( Out aOutForm: tForm): boolEan;

             {$IFDEF FUN}
             Procedure                      closeMyTabSheet( aSender: tObject);
             {$ENDIF}

             Procedure                      changeSRVWndSettings(
                                                                  aFontHeight: intEger
                                                                  {$IFDEF FUN}
                                                                  ;
                                                                  aBackColor : tBGRColor
                                                                  ;
                                                                  aTextColor : tBGRColor
                                                                  {$ENDIF}
                                                                );

             Procedure                      startTimer( aSender: tObject);

             Procedure                      init( aWaitTime: dWord= 250);
             Procedure                      deInit();
             Procedure                      reInit( aWaitTime: dWord= 300);

          End;


Var
          imcCmd_SWPSettings                : tIDEMenuCommand= Nil;

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
          imcCmd_SWPSettings        := registerOneCmd( SSWH_CAPTION, SSWH_CAPTION_IDEMenuCaption, @ho_Obj.lswpEdtCfg);
          imcCmd_SWPSettings.Enabled:= True;

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
          tHelpObj.changeSRVWndSettings(
                                           aFontHeight: intEger
                                           {$IFDEF FUN}
                                           ;
                                           aBackColor : tBGRColor
                                           ;
                                           aTextColor : tBGRColor
                                           {$ENDIF}
                                         );
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
             vtLbl1.Color              := aBackColor.switchLowerBytes();  // clLime;
             vtLbl1.Font.Color         := aTextColor.switchLowerBytes();  // clBlack;
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

          theConfig           := getConfig();
          theConfig.ApplyCB   := @Self.cfgApplyCB;

          changeSRVWndSettings(
                                theConfig.int_FontHeight
                                {$IFDEF FUN}
                                ,
                                theConfig.col_Back
                                ,
                                theConfig.col_Font
                                {$ENDIF}
                              );
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
          {$IFDEF FUN}
          closeMyTabSheet( Nil);
          {$ENDIF}

End;

Procedure
          tHelpObj.reInit( aWaitTime: dWord= 300);
Begin
          deInit();
          init( aWaitTime);
End;

Procedure
          tHelpObj.CfgApplyCB( aSender: tLSWPConfig);
Begin
          If ( Nil= aSender)
             Then
             Exit;

          theConfig.assign( aSender);
          reInit( 300);
          setConfig( aSender);
End;


Procedure
          tHelpObj.lswpEdtCfg( aSender: tObject);
Var
          vtCfg1                            : tLSWPConfig;

Begin
          _nOp( [ aSender]);

          Try
             imcCmd_SWPSettings.Enabled:= False;

             vtCfg1:= theConfig.clone();

             If ( mrOk= tfrm_LSWPEdtCfg_.exeCute( Nil, vtCfg1))
                Then
                Begin
                     theConfig.assign( vtCfg1);
                     reInit( 300);
                     setConfig( vtCfg1);
             End;
             freeAndNil( vtCfg1);

          Except End;
          imcCmd_SWPSettings.Enabled:= True;
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

