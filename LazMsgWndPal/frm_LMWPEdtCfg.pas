          { Copyright (C) 2026  StOver }
Unit
          frm_LMWPEdtCfg;

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
          iu_LMWPConf
          ;

Type

          { tHTypeHelperColor }

          tHTypeHelperLong                  = Type Helper For tColor

             Function                       switchLowerBytes(): longInt;
             Function                       guessContrastColor(): longInt;

          End;


          { tfrm_LMWPEdtCfg_ }

          tfrm_LMWPEdtCfg_                  = Class( tForm)

             bbt_apply                      : tBitBtn;
             lbl_FntHght: TLabel;
             lbl_ItmHgt: TLabel;



             pn_Btns                        : tPanel;

             bbt_ok                         : tBitBtn;
             bbt_Cancel                     : tBitBtn;


             pn_CltOuter                    : tPanel;
             sped_FontHeight                : tSpinEdit;
             sped_ItmHgt                    : tSpinEdit;



             Procedure                      bbt_okClick( aSender: tObject);
             Procedure                      bbt_applyClick( aSender: tObject);
             Procedure                      bbt_CancelClick( aSender: tObject);


             Procedure                      formCloseQuery( aSender: tObject; Var aVarCanClose: Boolean);
             Procedure                      formShow( aSender: tObject);

             Procedure                      centerOnMonitor();
             Procedure                      reflect_Changes();

             Procedure                      sped_FontHeightChange( aSender: tObject);
             Procedure                      sped_ItmHgtChange( aSender: tObject);


          Private

             theConfig                      : tLMWPConfig;


          Protected

             Procedure                      assignToCfg();
             Procedure                      assignToFrm();

             Type

             tEnumFontData                  = Class

                Parent                      : tfrm_LMWPEdtCfg_;

             End;

          Public

             Class Function                 exeCute( aMnFrm: tForm; Var aVarCfg: tLMWPConfig): tModalResult;

          End;



Implementation

Uses
          lclType
          ,
          //su_LMWPConf
          //,
          winDOwS
          ;

          {$R *.lfm}

          {$hints off}
Procedure // helper proc that makes compiler shut up for not (yet) used arguments
          _nOp( Const aAOC: Array Of Const);
Begin
          //
End;
          {$hints on}


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


          { tfrm_LMWPEdtCfg_ }

Procedure
          tfrm_LMWPEdtCfg_.bbt_okClick( aSender: tObject);
Begin
          _nOp( [ aSender]);

          assignToCfg();

          ModalResult:= mrOk;
          close();
End;

Procedure
          tfrm_LMWPEdtCfg_.bbt_applyClick( aSender: tObject);
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
          tfrm_LMWPEdtCfg_.bbt_CancelClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          ModalResult:= mrCancel;
          close();
End;


Procedure
          tfrm_LMWPEdtCfg_.formCloseQuery( aSender: tObject; Var aVarCanClose: Boolean);
Begin
          _nOp( [ aSender]);
          aVarCanClose:= ( mrCancel= ModalResult);
End;

Procedure
          tfrm_LMWPEdtCfg_.formShow( aSender: tObject);
Begin
          _nOp( [ aSender]);

          assignToFrm();
End;

Procedure
          tfrm_LMWPEdtCfg_.centerOnMonitor();
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
          tfrm_LMWPEdtCfg_.reflect_Changes();
Begin
          //
          Try
             lbl_FntHght     .Font.Height := sped_FontHeight.Value;
             lbl_FntHght     .AutoSize    := True;
             lbl_FntHght     .AutoSize    := False;

             sped_FontHeight .Left        := lbl_FntHght    .Left+ lbl_FntHght    .Width + 5;
             sped_FontHeight .Font.Height := sped_FontHeight.Value;
             //sped_FontHeight .AutoSize    := True;   // seems to stop working properly at a certain point
             //sped_FontHeight .AutoSize    := False;
             sped_FontHeight .Height      := sped_ItmHgt.Value;
             sped_FontHeight .Width       := lbl_FntHght    .Width Div 2 ; //Trunc( ( lbl_FntHght    .Width) / String( lbl_FntHght.Caption).Length)* 8;

             lbl_ItmHgt      .Left        := sped_FontHeight.Left+ sped_FontHeight.Width + 5;
             lbl_ItmHgt      .Font.Height := sped_FontHeight.Value;
             lbl_ItmHgt      .AutoSize    := True;
             lbl_ItmHgt      .AutoSize    := False;

             sped_ItmHgt     .Left        := lbl_ItmHgt     .Left+ lbl_ItmHgt     .Width + 5;
             sped_ItmHgt     .Font.Height := sped_FontHeight.Value;
             //sped_ItmHgt     .AutoSize    := True;   // seems to stop working properly at a certain point
             //sped_ItmHgt     .AutoSize    := False;
             sped_ItmHgt     .Height      := sped_FontHeight.Height;
             sped_ItmHgt     .Width       := sped_FontHeight.Width ;

             Self            .ClientWidth := sped_ItmHgt    .Left+ sped_ItmHgt    .Width + lbl_FntHght .Left;
             Self            .ClientHeight:= sped_ItmHgt    .Top + sped_ItmHgt    .Height+ lbl_FntHght .Top  + pn_Btns.Height;

             centerOnMonitor();

             bbt_apply       .Left        := ( Self           .ClientWidth- bbt_apply.Width) Div 2;

          Except End;
End;

Procedure
          tfrm_LMWPEdtCfg_.sped_FontHeightChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          reflect_Changes();
End;

Procedure
          tfrm_LMWPEdtCfg_.sped_ItmHgtChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          //
          reflect_Changes();
End;


Procedure
          tfrm_LMWPEdtCfg_.assignToCfg();
Begin

          // font specific

          theConfig.int_FontHeight    := sped_FontHeight.Value                    ;

          // padding
          theConfig.int_ItemHeight    := sped_ItmHgt.Value                        ;

End;


Procedure
          tfrm_LMWPEdtCfg_.assignToFrm();
Begin
          // font specific

          sped_FontHeight.Value       := theConfig.int_FontHeight                                  ;
          sped_FontHeightChange( Nil);

          // padding
          sped_ItmHgt.Value           := theConfig.int_ItemHeight                                  ;
          sped_ItmHgtChange    ( Nil);

          // Apply CB
          bbt_apply.Enabled           := assigned( theConfig.ApplyCB)                              ;


End;

Class Function
          tfrm_LMWPEdtCfg_.exeCute( aMnFrm: tForm; Var aVarCfg: tLMWPConfig): tModalResult;
Var
          vtFrmEC                           : tfrm_LMWPEdtCfg_;
Begin

          vtFrmEC:= tfrm_LMWPEdtCfg_.create( aMnFrm);
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
