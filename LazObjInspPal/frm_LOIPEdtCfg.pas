{ Copyright (C) 2026  StOver }
Unit
          frm_LOIPEdtCfg;

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
          iu_LOIPConf
          ;

Type


          { tfrm_LOIPEdtCfg_ }

          tfrm_LOIPEdtCfg_                  = Class( tForm)

             bbt_apply                      : tBitBtn;
             lbl_FntHght                    : tLabel;



             pn_Btns                        : tPanel;

             bbt_ok                         : tBitBtn;
             bbt_Cancel                     : tBitBtn;


             pn_CltOuter                    : tPanel;
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


          Private

             theConfig                      : tLOIPConfig;


          Protected

             Procedure                      assignToCfg();
             Procedure                      assignToFrm();

             Type

             tEnumFontData                  = Class

                Parent                      : tfrm_LOIPEdtCfg_;

             End;

          Public

             Class Function                 exeCute( aMnFrm: tForm; Var aVarCfg: tLOIPConfig): tModalResult;

          End;



Implementation

Uses
          lclType
          ,
          maTh
          ;

          {$R *.lfm}

          {$hints off}
Procedure // helper proc that makes compiler shut up for not (yet) used arguments
          _nOp( Const aAOC: Array Of Const);
Begin
          //
End;
          {$hints on}


          { tfrm_LOIPEdtCfg_ }

Procedure
          tfrm_LOIPEdtCfg_.bbt_okClick( aSender: tObject);
Begin
          _nOp( [ aSender]);

          assignToCfg();

          ModalResult:= mrOk;
          close();
End;

Procedure
          tfrm_LOIPEdtCfg_.bbt_applyClick( aSender: tObject);
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
          tfrm_LOIPEdtCfg_.bbt_CancelClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          ModalResult:= mrCancel;
          close();
End;


Procedure
          tfrm_LOIPEdtCfg_.formCloseQuery( aSender: tObject; Var aVarCanClose: Boolean);
Begin
          _nOp( [ aSender]);
          aVarCanClose:= ( mrCancel= ModalResult);
End;

Procedure
          tfrm_LOIPEdtCfg_.formShow( aSender: tObject);
Begin
          _nOp( [ aSender]);

          assignToFrm();
End;



Procedure
          tfrm_LOIPEdtCfg_.centerOnMonitor();
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
          tfrm_LOIPEdtCfg_.reflect_Changes();

Begin
          //
          Try

             lbl_FntHght    .Font.Height:= sped_FontHeight.Value;

             sped_FontHeight.Font.Height:= sped_FontHeight.Value;

             sped_FontHeight.Height     := trunc( sped_FontHeight.Value* 1.4);
             sped_FontHeight.Width      := trunc( sped_FontHeight.Value* 2.8);

             ClientHeight:= sped_FontHeight.Top+  // leave space below
                            sped_FontHeight.Top+ sped_FontHeight.Height+
                            pn_Btns.Height
                            ;

             ClientWidth := Math.max(
                                     lbl_FntHght.Left+  // leave space left
                                     sped_FontHeight.Left+ sped_FontHeight.Width+
                                     lbl_FntHght.Left   // leave space right
                                     ,
                                     240
                                    )
                            ;

             centerOnMonitor();

             bbt_apply       .Left        := ( pn_Btns.ClientWidth- bbt_apply.Width) Div 2;

          Except End;
End;

Procedure
          tfrm_LOIPEdtCfg_.sped_FontHeightChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          reflect_Changes();
End;

Procedure
          tfrm_LOIPEdtCfg_.sped_ItmHgtChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          //
          reflect_Changes();
End;


Procedure
          tfrm_LOIPEdtCfg_.assignToCfg();
Begin
          // font specific

          theConfig.int_FontHeight    := sped_FontHeight.Value                       ;

End;


Procedure
          tfrm_LOIPEdtCfg_.assignToFrm();
Begin
          // font specific

          sped_FontHeight.Value       := theConfig.int_FontHeight                    ;
          sped_FontHeightChange( Nil);


          // Apply CB
          bbt_apply.Enabled           := assigned( theConfig.ApplyCB)                              ;


End;

Class Function
          tfrm_LOIPEdtCfg_.exeCute( aMnFrm: tForm; Var aVarCfg: tLOIPConfig): tModalResult;
Var
          vtFrmEC                           : tfrm_LOIPEdtCfg_;
Begin

          vtFrmEC:= tfrm_LOIPEdtCfg_.create( aMnFrm);
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
