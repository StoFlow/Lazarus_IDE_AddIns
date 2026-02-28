{ Copyright (C) 2026  StOver }
Unit
          frm_LSWPEdtCfg;

          {$mode ObjFPC}{$H+}
          {$ModeSwitch typehelpers}

Interface

Uses
          Classes
          ,
          SysUtils
          ,
          Forms
          ,
          Controls
          ,
          Graphics
          ,
          Dialogs
          ,
          StdCtrls
          ,
          ExtCtrls
          ,
          Buttons
          ,
          Spin
          ,
          iu_LSWPConf
          ;

Type

          {$IFDEF FUN}
          { tHTypeHelperColor }

          tHTypeHelperLong                  = Type Helper For tColor

             Function                       switchLowerBytes(): longInt;
             Function                       guessContrastColor(): longInt;

          End;
          {$ENDIF}

          { tfrm_LSWPEdtCfg_ }

          tfrm_LSWPEdtCfg_                  = Class( tForm)

             bbt_apply                      : tBitBtn;
             coldlg_Edit                    : tColorDialog;
             lbl_FntHght                    : tLabel;
             lbl_BackColor                  : tLabel;
             lbl_TextColor                  : tLabel;



             pn_Btns                        : tPanel;

             bbt_ok                         : tBitBtn;
             bbt_Cancel                     : tBitBtn;


             pn_CltOuter                    : tPanel;
             pn_BackColor                   : tPanel;
             pn_FontColor                   : tPanel;
             sped_FontHeight                : tSpinEdit;



             Procedure                      bbt_okClick( aSender: tObject);
             Procedure                      bbt_applyClick( aSender: tObject);
             Procedure                      bbt_CancelClick( aSender: tObject);


             Procedure                      formCloseQuery( aSender: tObject; Var aVarCanClose: Boolean);
             Procedure                      formShow( aSender: tObject);

             Procedure                      centerOnMonitor();
             Procedure                      reflect_Changes();

             Procedure                      sped_FontHeightChange( aSender: tObject);
             Procedure                      sped_ItmHgtChange( aSender: tObject);

             {$IFDEF FUN}
             Procedure                      doColorEdit( aCtrl: tWinControl; aUseFontProp: boolEan= False);
             Procedure                      correctTextPnCol();
             {$ENDIF}
             Procedure                      colEditSink( aSender: tObject);
             Procedure                      col4TxtEditSink( aSender: tObject);

          Private

             theConfig                      : tLSWPConfig;


          Protected

             Procedure                      assignToCfg();
             Procedure                      assignToFrm();

             Type

             tEnumFontData                  = Class

                Parent                      : tfrm_LSWPEdtCfg_;

             End;

          Public

             Class Function                 exeCute( aMnFrm: tForm; Var aVarCfg: tLSWPConfig): tModalResult;

          End;



Implementation

Uses
          lclType
          {$IFDEF FUN}
          ,
          iu_LSWPBGRColor
          {$ENDIF}
          ;

          {$R *.lfm}

          {$hints off}
Procedure // helper proc that makes compiler shut up for not (yet) used arguments
          _nOp( Const aAOC: Array Of Const);
Begin
          //
End;
          {$hints on}

          {$IFDEF FUN}
Function
          tHTypeHelperLong.switchLowerBytes(): longInt;

Begin
          Result:= ( ( Self And $0000FF) Shl 16)
                   Or
                   ( ( Self And $00FF00)       )
                   Or
                   ( ( Self And $FF0000) Shr 16)
                   ;
End;

Function
          tHTypeHelperLong.guessContrastColor(): longInt;
Begin
          Result:= rgbToColor(
                               255- red  ( Self),
                               Not  green( Self),
                               255- blue ( Self)
                             );
End;
          {$ENDIF}

          { tfrm_LSWPEdtCfg_ }

Procedure
          tfrm_LSWPEdtCfg_.bbt_okClick( aSender: tObject);
Begin
          _nOp( [ aSender]);

          assignToCfg();

          ModalResult:= mrOk;
          close();
End;

Procedure
          tfrm_LSWPEdtCfg_.bbt_applyClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          //
          If assigned( theConfig)
             And
             assigned( theConfig.ApplyCB)
             Then
             Try
                assignToCfg();
                theConfig.ApplyCB( theConfig);
             Except End;
End;

Procedure
          tfrm_LSWPEdtCfg_.bbt_CancelClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          ModalResult:= mrCancel;
          close();
End;


Procedure
          tfrm_LSWPEdtCfg_.formCloseQuery( aSender: tObject; Var aVarCanClose: Boolean);
Begin
          _nOp( [ aSender]);
          aVarCanClose:= ( mrCancel= ModalResult);
End;

Procedure
          tfrm_LSWPEdtCfg_.formShow( aSender: tObject);
Begin
          _nOp( [ aSender]);

          assignToFrm();
End;

          {$IFDEF FUN}
Procedure
          tfrm_LSWPEdtCfg_.doColorEdit( aCtrl: tWinControl; aUseFontProp: boolEan= False);
Var
          vtFnt                             : tFont;
Begin
          If ( Nil= aCtrl)
             Then
             Exit;

          vtFnt:= aCtrl.Font;
          If ( aUseFontProp )
             Then
             If ( Nil= vtFnt)
                Then
                Exit
             Else
                coldlg_Edit.Color:= aCtrl.Font.Color
          Else
             coldlg_Edit.Color:= aCtrl.Color;

          If ( Not coldlg_Edit.execute())
             Then
             Exit;

          If ( aUseFontProp )
             Then
             aCtrl.Font.Color:= coldlg_Edit.Color
          Else
             Begin
                  aCtrl.Color      := coldlg_Edit.Color;
                  aCtrl.Font.Color := coldlg_Edit.Color.guessContrastColor();
          End;
End;

Procedure
          tfrm_LSWPEdtCfg_.correctTextPnCol();
Begin
          pn_FontColor.Color:= pn_BackColor.Color;
End;

          {$ENDIF}

Procedure
          tfrm_LSWPEdtCfg_.colEditSink( aSender: tObject);
Begin
          _nOp( [ aSender]);
          {$IFDEF FUN}
          doColorEdit( tWinControl( aSender));
          correctTextPnCol();
          {$ENDIF}
End;

Procedure
          tfrm_LSWPEdtCfg_.col4TxtEditSink( aSender: tObject);
Begin
          _nOp( [ aSender]);
          {$IFDEF FUN}
          doColorEdit( tWinControl( aSender), True);
          {$ENDIF}
End;


Procedure
          tfrm_LSWPEdtCfg_.centerOnMonitor();
Var
          vtMonM                            : tMonitor;
          vtReNF                            : tRect;
Begin
          If ( Nil= Application)
             Then
             Exit;

          If ( Nil= Application.MainForm)
             Then
             Exit;

          vtMonM:= Screen.monitorFromRect( Application.MainForm.BoundsRect);

          If ( Nil= vtMonM)
             Then
             Exit;

          vtReNF:= vtMonM.BoundsRect;

          Self.Left:= vtReNF.Left+ ( vtReNF.Width - Self.Width ) Div 2;
          Self.Top := vtReNF.Top + ( vtReNF.Height- Self.Height) Div 2;

End;

Procedure
          tfrm_LSWPEdtCfg_.reflect_Changes();
Var
          vInOne                            : intEger;
          vInCnt                            : intEger;

Begin
          //
          Try
             // #todo maybe later more sizing and aligning...

             vInCnt:= pn_CltOuter.ControlCount;
             For vInOne:= 0 To vInCnt- 1
                 Do
                 Begin
                      If pn_CltOuter.Controls[ vInOne].Tag= 1
                         Then
                         pn_CltOuter.Controls[ vInOne].Visible:=
                                                                 {$IFDEF FUN}
                                                                 True
                                                                 {$ELSE}
                                                                 False
                                                                 {$ENDIF}
                                                                ;

             End;

             ClientHeight:= sped_FontHeight.Top+  // leave space below
                            {$IFDEF FUN}
                            pn_BackColor.Top   + pn_BackColor.Height
                            {$ELSE}
                            sped_FontHeight.Top+ sped_FontHeight.Height
                            {$ENDIF}
                            +
                            pn_Btns.Height
                            ;

             centerOnMonitor();

             bbt_apply       .Left        := ( pn_Btns.ClientWidth- bbt_apply.Width) Div 2;

          Except End;
End;

Procedure
          tfrm_LSWPEdtCfg_.sped_FontHeightChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          reflect_Changes();
End;

Procedure
          tfrm_LSWPEdtCfg_.sped_ItmHgtChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          //
          reflect_Changes();
End;


Procedure
          tfrm_LSWPEdtCfg_.assignToCfg();
Begin
          {$IFDEF FUN}
          // colors

          theConfig.col_Back          := pn_BackColor.Color.switchLowerBytes()       ;
          theConfig.col_Font          := pn_FontColor.Font.Color.switchLowerBytes()  ;
          {$ENDIF}

          // font specific

          theConfig.int_FontHeight    := sped_FontHeight.Value                       ;


End;


Procedure
          tfrm_LSWPEdtCfg_.assignToFrm();
Begin
          {$IFDEF FUN}
          // colors

          pn_BackColor.Color          := theConfig.col_Back.switchLowerBytes()       ;
          pn_FontColor.Font.Color     := theConfig.col_Font.switchLowerBytes()       ;
          correctTextPnCol();
          {$ENDIF}

          // font specific

          sped_FontHeight.Value       := theConfig.int_FontHeight                    ;
          sped_FontHeightChange( Nil);


          // Apply CB
          bbt_apply.Enabled           := assigned( theConfig.ApplyCB)                              ;


End;

Class Function
          tfrm_LSWPEdtCfg_.exeCute( aMnFrm: tForm; Var aVarCfg: tLSWPConfig): tModalResult;
Var
          vtFrmEC                           : tfrm_LSWPEdtCfg_;
Begin

          vtFrmEC:= tfrm_LSWPEdtCfg_.create( aMnFrm);
          vtFrmEC.theConfig:= aVarCfg;

          If ( Nil<> aMnFrm)
             Then
             Begin
                  vtFrmEC.Left:= aMnFrm.Left+ ( ( aMnFrm.Width - vtFrmEC.Width ) Div 2);
                  vtFrmEC.Top := aMnFrm.Top + ( ( aMnFrm.Height- vtFrmEC.Height) Div 2);
          End;

          vtFrmEC.show();

          While ( vtFrmEC.ModalResult= mrNone)
                Do
                Begin
                     Application.processMessages();
                     Sleep( 2);
          End;

          Result:= vtFrmEC.ModalResult;
          If ( mrOk= Result)
             Then
             aVarCfg.assign( vtFrmEC.theConfig);

          freeAndNil( vtFrmEC);

End;





End.
