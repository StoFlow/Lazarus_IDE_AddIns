          { Copyright (C) 2026  StOver }
          {$CODEPAGE UTF8}
Unit
          LazObjInspPalImpl;

          {$mode objfpc}{$H+}
          {$ModeSwitch typehelpers}



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
          ObjectInspector
          ,
          FormEditingIntf
          ,
          lcltype
          ,
          conTrols
          ,
          extCtrls
          ,
          comCtrls
          ,
          stdCtrls
          ,
          IDEExternToolIntf
          ,
          graPhics
          ,
          butTons
          ,
          iu_LOIPConf
          ,
          su_LOIPConf
          ,
          frm_LOIPEdtCfg
          ;



          {$R LazObjInspPal_Images.res}

Const
          // command
          SSWH_CAPTION                      = 'LazObjInspPal';

Resourcestring

          SSWH_CAPTION_IDEMenuCaption       = 'Object Inspector font height';

Type


          { tHelpObj }

          tHelpObj                          = Class( tObject)

          Private

             tmrStOIPal                     : extCtrls.tTimer;

             theConfig                      : tLOIPConfig;

          Public

             Procedure                      LOIPEdtCfg( aSender: tObject);

             Procedure                      cfgApplyCB( aSender: tLOIPConfig);

             Constructor                    create();

             Function                       getSubCtrlByClass( aParentCtrl: tWinControl; aClass: tControlClass; Out aOutCtrl: tControl; aOptRecursive: boolEan= False): boolEan;
             //Function                       getObjInspWin( Out aOutForm: tForm): boolEan;

             Procedure                      setCfgToOneGrid( aGrid: tOICustomPropertyGrid; aFontHeight: intEger);
             Procedure                      changeObjInspSettings( aFontHeight: intEger);

             Procedure                      startTimer( aSender: tObject);

             {$IFDEF LINUX}
             Procedure                      init( aWaitTime: dWord= 500);
             {$ELSE}
             Procedure                      init( aWaitTime: dWord= 250);
             {$ENDIF}

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
          imcCmd_SWPSettings        := registerOneCmd( SSWH_CAPTION, SSWH_CAPTION_IDEMenuCaption, @ho_Obj.LOIPEdtCfg);
          imcCmd_SWPSettings.Enabled:= True;

          If ( Nil= ho_Obj)
             Then
             Begin
                  messageDlg( 'LazObjInspPal', 'ho_Obj is Nil', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  exit;
          End;

          ho_Obj.init();

End;



          { tHelpObj }

//Function
//          tHelpObj.getObjInspWin( Out aOutForm: tForm): boolEan;
//Const
//          cstr_SRW_CLSNAME                  = 'TOBJECTINSPECTORDLG';
//          cstr_SRW_CAPTION                  = 'OBJECT INSPECTOR';                     // might be other caption with other langs #todo check it :)
//Var
//          vInOne                            : intEger;
//          vInCnt                            : intEger;
//          vStCNm                            : String;
//          vStCpn                            : String;
//          vtFrm                             : tForm;
//          //vStAllF                           : String;
//
//Begin
//          Result  := False;
//          aOutForm:= Nil;
//          //vStAllF := '';
//          vInCnt:= Screen.FormCount;
//
//          For vInOne:= 0 To vInCnt- 1
//              Do
//              Begin
//                   vtFrm:= Screen.Forms[ vInOne];
//                   If ( Nil= vtFrm)
//                      Then
//                      conTinue;
//
//                   vStCNm:= String( vtFrm.className()).toUpper();
//                   vStCpn:= String( vtFrm.Caption).toUpper();
//                   //If ( ''<> vStAllF)
//                   //   Then
//                   //   vStAllF+= #13#10;
//                   //vStAllF+= vStCNm+ #9+ vStCpn;
//
//                   If ( cstr_SRW_CLSNAME= vStCNm)
//                      And
//                      ( cstr_SRW_CAPTION= vStCpn)
//                      And
//                      ( vtFrm.Showing)
//                      Then
//                      Begin
//                           aOutForm:= vtFrm;
//
//                           break;
//                   End;
//          End;
//          //showMessage( vStAllF);
//          Result:= ( Nil<> aOutForm);
//
//End;

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


Procedure
          tHelpObj.setCfgToOneGrid( aGrid: tOICustomPropertyGrid; aFontHeight: intEger);
Var
          vtCtl1                            : tControl;
          vtCbBx                            : tComboBox;
Begin
          If ( Nil= aGrid)
             Then
             Exit;

          aGrid.NameFont        .Height    := aFontHeight;
          aGrid.ValueFont       .Height    := aFontHeight;
          aGrid.DefaultValueFont.Height    := aFontHeight;
          aGrid.HighlightFont   .Height    := aFontHeight;

          {$IFDEF LINUX}
          aGrid.DefaultItemHeight          := aFontHeight+ 12;
          {$ENDIF}

          If getSubCtrlByClass( aGrid, tComboBox, vtCtl1, True)
             Then
             Begin
                  vtCbBx            := vtCtl1 As tComboBox;
                  vtCbBx.Font.Height:= aFontHeight;
                  vtCbBx.ItemHeight := aFontHeight;
          End;

End;

Procedure
          tHelpObj.changeObjInspSettings( aFontHeight: intEger);
Var
          vtCtl1                            : tControl;
          vtOiD                             : tObjectInspectorDlg;
          vtNtBk                            : tPageControl;
          vtStBr                            : tStatusBar;
Begin

          If not assigned( LazIDEIntf.LazarusIDE)
             Then
             Exit;

          Try
             If ( Nil= FormEditingIntf.FormEditingHook)
                Then
                Exit;

             vtOiD:= FormEditingIntf.FormEditingHook.getCurrentObjectInspector();
             If ( Nil= vtOiD)
                Then
                Begin
                     // nothing to inspect ?
                     // wait for better times
                     init( 5000);
                     Exit;
                End
             Else
                Begin
                     // maybe later
             End;
             //If Not getObjInspWin( vtFrm)
             //   Then
             //   Begin
             //        showMessage( 'Couln''t get search results window!');
             //        exit;
             //End;

             vtOiD.Visible               := True;
             vtOiD.bringToFront();

             vtOiD.Font.Height           := aFontHeight;

             {$IFDEF LINUX}
             vtOiD.DefaultItemHeight     := aFontHeight+ 12;
             {$ELSE}
             vtOiD.DefaultItemHeight     := aFontHeight+ 2;
             {$ENDIF}

             vtOiD.InfoPanel.Font.Height := aFontHeight;

             If getSubCtrlByClass( vtOiD, tPageControl, vtCtl1, True)
                Then
                Begin
                     vtNtBk              := vtCtl1 As tPageControl;
                     vtNtBk.Height       := aFontHeight+ 2;
                     vtNtBk.ShowTabs     := False;
                     vtNtBk.ShowTabs     := True;
             End;

             If getSubCtrlByClass( vtOiD, tStatusBar, vtCtl1, True)
                Then
                Begin
                     vtStBr              := vtCtl1 As tStatusBar;
                     vtStBr.AutoSize     := False;
                     vtStBr.Height       := aFontHeight+ 4;
                     vtStBr.SimpleText   := 'Font height= '+ aFontHeight.toString();
             End;

             setCfgToOneGrid( vtOiD.PropertyGrid   , aFontHeight);
             setCfgToOneGrid( vtOiD.FavoriteGrid   , aFontHeight);
             setCfgToOneGrid( vtOiD.EventGrid      , aFontHeight);
             setCfgToOneGrid( vtOiD.RestrictedGrid , aFontHeight);

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
          tmrStOIPal.Enabled:= False;

          theConfig           := getConfig();
          theConfig.ApplyCB   := @Self.cfgApplyCB;

          changeObjInspSettings(
                                theConfig.int_FontHeight
                              );
End;


Procedure
          {$IFDEF LINUX}
          tHelpObj.init( aWaitTime: dWord= 500);
          {$ELSE}
          tHelpObj.init( aWaitTime: dWord= 250);
          {$ENDIF}
Begin

          IF ( Nil= tmrStOIPal)
             Then
             tmrStOIPal        := tTimer.create( Nil);

          tmrStOIPal.Enabled   := False;

          If ( 0< aWaitTime)
             Then
             Begin
                  tmrStOIPal.Interval  := aWaitTime;
                  tmrStOIPal.OnTimer   := @startTimer;
                  tmrStOIPal.Enabled   := True;
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
          tHelpObj.reInit( aWaitTime: dWord= 300);
Begin
          deInit();
          init( aWaitTime);
End;

Procedure
          tHelpObj.CfgApplyCB( aSender: tLOIPConfig);
Begin
          If ( Nil= aSender)
             Then
             Exit;

          theConfig.assign( aSender);
          reInit( 300);
          setConfig( aSender);
End;


Procedure
          tHelpObj.LOIPEdtCfg( aSender: tObject);
Var
          vtCfg1                            : tLOIPConfig;

Begin
          _nOp( [ aSender]);

          Try
             imcCmd_SWPSettings.Enabled:= False;

             vtCfg1:= theConfig.clone();

             If ( mrOk= tfrm_LOIPEdtCfg_.exeCute( Nil, vtCfg1))
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
          tmrStOIPal            := Nil;
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


