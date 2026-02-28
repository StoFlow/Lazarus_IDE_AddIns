          { Copyright (C) 2026  StOver }
          {$CODEPAGE UTF8}
Unit
          LazMsgWndPalImpl;

          {$mode objfpc}{$H+}
          {$ModeSwitch typehelpers}


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
          IDECommands
          ,
          ToolBarIntf
          ,
          IDEWindowIntf
          ,
          lcltype
          ,
          conTrols
          ,
          extCtrls
          ,
          IDEMsgIntf
          ,
          IDEExternToolIntf
          ,
          graPhics
          ,
          iu_LMWPConf
          ,
          su_LMWPConf
          ,
          frm_LMWPEdtCfg
          ;



          {$R LazMsgWndPal_Images.res}

Const
          // command
          SMWH_CAPTION                      = 'lazmsgwndpal';

Resourcestring

          SMWH_CAPTION_IDEMenuCaption       = 'Messages window font- and line- height';

Type

          tMsgWndFileNameStyle = (
              mwfsShort,    // = ExtractFilename
              mwfsRelative, // = CreateRelativePath
              mwfsFull
              );

          // never ever do this at home !!!
          tMessagesCtrlFake                 = Class( tCustomControl)

          Private
             {%H-}fActiveFilter             : tObject;
             {%H-}fBackgroundColor          : tColor;
             {%H-}FFilenameStyle            : tMsgWndFileNameStyle;
             {%H-}fHeaderBackground         : Array[ 0.. 2] of tColor;
             {%H-}fIdleConnected            : boolean;
             {%H-}fImageChangeLink          : tObject;
             {%H-}fImages                   : tObject;
             {%H-}fItemHeight               : integer;
          End;

          { tHelpObj }

          tHelpObj                          = Class( tObject)

          Private

             tmrStart                       : extCtrls.tTimer;

             theConfig                      : tLMWPConfig;

          Public

             Procedure                      lmwpEdtCfg( aSender: tObject);

             Procedure                      cfgApplyCB( aSender: tLMWPConfig);

             Constructor                    create();
             Procedure                      changeMsgWndFontHeightAndItemSize( aFontHeight: intEger; aItemHeight: intEger);

             Procedure                      startTimer( aSender: tObject);

             Procedure                      init( aWaitTime: dWord= 250);
             Procedure                      deInit();

             Procedure                      reInit( aWaitTime: dWord= 500);


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
                  messageDlg( 'LazMsgWndPal', 'ho_Obj is Nil', tMsgDlgType.mtWarning, [ tMsgDlgBtn.mbCancel], 0);
                  exit;
          End;

          ho_Obj.init();

End;



          { tHelpObj }

Procedure
          tHelpObj.changeMsgWndFontHeightAndItemSize( aFontHeight: intEger; aItemHeight: intEger);
Var
          vInOne                            : intEger;
          vInCnt                            : intEger;
          vtFrMFrame                        : tFrame;
          vtCcMsgsCtrl                      : tCustomControl;
          vStMsg                            : String;
Begin
          If not assigned( IDEMessagesWindow)
             Then
             Exit;

          Try
             IDEMessagesWindow.bringToFront();
             vStMsg:= 'Lazarus Messages Window Pal';
             IDEMessagesWindow.addCustomMessage( tMessageLineUrgency.mluHint, vStMsg, 'LazMsgWndPalImpl.pas', 0, 0, 'LazMsgWndPalImpl');

             If ( 0< IDEMessagesWindow.ControlCount)
                Then
                If ( IDEMessagesWindow.Controls[ 0] Is tWinControl)
                   And
                   ( 'TMessagesFrame'= IDEMessagesWindow.Controls[ 0].className())
                   Then
                   Begin
                        vtFrMFrame:= ( IDEMessagesWindow.Controls[ 0] As tFrame);
                        vInCnt:= vtFrMFrame.ControlCount;
                        vtFrMFrame.Font.Height:= aFontHeight;

                        For vInOne:= 0 To vInCnt- 1
                            Do
                            Begin
                                 If ( vtFrMFrame.Controls[ vInOne] Is tCustomControl)
                                    And
                                    ( 'TMessagesCtrl'= vtFrMFrame.Controls[ vInOne].className())
                                    Then
                                    Begin
                                         vtCcMsgsCtrl     := vtFrMFrame.Controls[ vInOne] As tCustomControl;
                                         Try
                                            // attention => very ugly hack with rebuilt rump of "tMessagesCtrl" - class
                                            // on any change in the class before fItemHeight it will put data of the instance to unknown state
                                            // so tMessagesCtrlFake has to be restructured too then!
                                            tMessagesCtrlFake( vtCcMsgsCtrl).fItemHeight:= aItemHeight;
                                            vtCcMsgsCtrl.repaint();
                                            vStMsg:= 'Settings are : aFontHeight => '+ aFontHeight.toString()+ ', aItemHeight => '+ aItemHeight.toString()+ '.';
                                            IDEMessagesWindow.addCustomMessage( tMessageLineUrgency.mluHint, vStMsg, 'LazMsgWndPalImpl.pas', 0, 0, 'LazMsgWndPalImpl');

                                         Except End;

                                         vtCcMsgsCtrl:= Nil;
                                    End;

                        End;
                        vtFrMFrame:= Nil;
                End;
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
          tmrStart.Enabled    := False;

          theConfig           := getConfig();   // Result  := tLWCETConfig.create();
          theConfig.ApplyCB   := @Self.cfgApplyCB;

          changeMsgWndFontHeightAndItemSize( theConfig.int_FontHeight, theConfig.int_ItemHeight);

          //{$IFDEF LINUX}
          //changeMsgWndFontHeightAndItemSize( 26, 32);
          //{$ELSE}
          //changeMsgWndFontHeightAndItemSize( 26, 25);
          //{$ENDIF}
End;


Procedure
          tHelpObj.init( aWaitTime: dWord= 250);
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
          // maybe later

End;

Procedure
          tHelpObj.reInit( aWaitTime: dWord= 500);
Begin
          deInit();
          init( aWaitTime);
End;


Procedure
          tHelpObj.lmwpEdtCfg( aSender: tObject);
Var
          vtCfg1                            : tLMWPConfig;

Begin
          _nOp( [ aSender]);

          Try
             imcCmd_MWPSettings.Enabled:= False;

             vtCfg1:= theConfig.clone();

             If ( mrOk= tfrm_LMWPEdtCfg_.exeCute( Nil, vtCfg1))
                Then
                Begin
                     theConfig.assign( vtCfg1);
                     reInit( 300);
                     setConfig( vtCfg1);
             End;
             freeAndNil( vtCfg1);

          Except End;
          imcCmd_MWPSettings.Enabled:= True;

End;

Procedure
          tHelpObj.CfgApplyCB( aSender: tLMWPConfig);
Begin
          If ( Nil= aSender)
             Then
             Exit;

          theConfig.assign( aSender);
          reInit( 300);
          setConfig( aSender);
End;



Constructor
          tHelpObj.create();
Begin
          tmrStart            := Nil;
          theConfig           := getConfig();       // at this point the cfg might be come from another folder (user-appdata-lazarus)
          theConfig.ApplyCB   := @Self.cfgApplyCB;
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

