Unit
          frm_edtcfg;

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
          iu_LWCETConf
          ,
          iu_BGRColor
          ;

Type

          { tHTypeHelperColor }

          tHTypeHelperLong                  = Type Helper For tColor

             Function                       switchLowerBytes(): longInt;
             Function                       guessContrastColor(): longInt;

          End;


          { tfrm_edtcfg_ }

          tfrm_edtcfg_                      = Class( tForm)

             bbt_apply                      : tBitBtn;


             cbx_Fonts                      : tComboBox;
             cbx_CloseBtns                  : tComboBox;
             lbl_FntHght                    : tLabel;
             lbl_PdgX                       : tLabel;
             lbl_FntWdth                    : tLabel;
             lbl_CloseBtns                  : tLabel;
             lbl_PdgY                       : tLabel;

             lbl_SelTab                     : tLabel;
             lbl_OthTabs                    : tLabel;
             lbl_FntNme                     : tLabel;
             lbl_SelTxt                     : tLabel;
             lbl_Lights                     : tLabel;
             lbl_Shadows                    : tLabel;
             lbl_OthTxt                     : tLabel;
             pn_Pad2ClsBtns                 : tPanel;
             pn_EmporeOth                   : tPanel;
             pn_Lights                      : tPanel;
             pn_Btns                        : tPanel;

             bbt_ok                         : tBitBtn;
             bbt_Cancel                     : tBitBtn;

             coldlg_Edit                    : tColorDialog;

             pn_Colors                      : tPanel;
             pn_CltMid                      : tPanel;
             pn_CltOuter                    : tPanel;
             pn_EmporeSel                   : tPanel;
             pn_Shadows                     : tPanel;
             pn_Padding                     : tPanel;
             pn_Font                        : tPanel;
             pn_TextSel                     : tPanel;
             pn_TextOth                     : tPanel;
             sped_FontHeight                : tSpinEdit;
             sped_FontWidth                 : tSpinEdit;

             sped_PdgX                      : tSpinEdit;
             sped_PdgY                      : tSpinEdit;


             Procedure                      bbt_okClick( aSender: tObject);
             Procedure                      bbt_applyClick( aSender: tObject);
             Procedure                      bbt_CancelClick( aSender: tObject);

             Procedure                      cbx_FontsChange( aSender: tObject);

             Procedure                      colEditSink( aSender: tObject);
             Procedure                      formCloseQuery( aSender: tObject; Var aVarCanClose: Boolean);
             Procedure                      formShow( aSender: tObject);
             Procedure                      col4TxtEditSink( aSender: tObject);
             Procedure                      sped_FontHeightChange( aSender: tObject);


          Private

             theConfig                      : tLWCETConfig;


          Protected

             Procedure                      doColorEdit( aCtrl: tWinControl; aUseFontProp: boolEan= False);

             Procedure                      assignToCfg();
             Procedure                      assignToFrm();

             Function                       apiReloadFonts41PAF( Out aVarSL: tStringList): intEger;

             Procedure                      correctTextPnCol();

             Type

             tEnumFontData                  = Class

                Fonts                       : tStringList;
                Parent                      : tfrm_edtcfg_;

             End;

             Function                       initializeEFD(): tEnumFontData;
             Procedure                      finalizeEFD( Var aEFD: tEnumFontData);

          Public

             Class Function                 exeCute( aMnFrm: tForm; Var aVarCfg: tLWCETConfig): tModalResult;

          End;



Implementation

Uses
          lclType
          //,
          //typInfo
          ,
          su_LWCETConf
          ,
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


          { tfrm_edtcfg_ }

Procedure
          tfrm_edtcfg_.bbt_okClick( aSender: tObject);
Begin
          _nOp( [ aSender]);

          assignToCfg();

          ModalResult:= mrOk;
          close();
End;

Procedure
          tfrm_edtcfg_.bbt_applyClick( aSender: tObject);
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
          tfrm_edtcfg_.bbt_CancelClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          ModalResult:= mrCancel;
          close();
End;

Procedure
          tfrm_edtcfg_.cbx_FontsChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          //
          Try
             pn_TextSel.Font.Name:= cbx_Fonts.Text;
             pn_TextOth.Font.Name:= cbx_Fonts.Text;
          Except End;
End;


Procedure
          tfrm_edtcfg_.doColorEdit( aCtrl: tWinControl; aUseFontProp: boolEan= False);
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
          tfrm_edtcfg_.correctTextPnCol();
Begin
          pn_TextSel.Color:= pn_EmporeSel.Color;
          pn_TextOth.Color:= pn_EmporeOth.Color;
End;

Procedure
          tfrm_edtcfg_.colEditSink( aSender: tObject);
Begin
          _nOp( [ aSender]);
          doColorEdit( tWinControl( aSender));
          correctTextPnCol();
End;


Procedure
          tfrm_edtcfg_.formCloseQuery( aSender: tObject; Var aVarCanClose: Boolean);
Begin
          _nOp( [ aSender]);
          aVarCanClose:= ( mrCancel= ModalResult);
End;

Procedure
          tfrm_edtcfg_.formShow( aSender: tObject);
Var
          vtSl1                             : tStringList;
Begin
          _nOp( [ aSender]);

          cbx_Fonts.Items.clear();
          vtSl1:= Nil;
          If apiReloadFonts41PAF( vtSl1)> 0
             Then
             Begin
                  cbx_Fonts.Items.addStrings( vtSl1);
                  cbx_Fonts.ItemIndex:= 0;
                  cbx_Fonts.ItemIndex:= cbx_Fonts.Items.indexOf( trim( theConfig.str_TabFontName));

                  freeAndNil( vtSl1);
          End;

          fillCloseButtonStyles( cbx_CloseBtns.Items);

          assignToFrm();
End;

Procedure
          tfrm_edtcfg_.col4TxtEditSink( aSender: tObject);
Begin
          _nOp( [ aSender]);
          doColorEdit( tWinControl( aSender), True);
End;

Procedure
          tfrm_edtcfg_.sped_FontHeightChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          //
          Try
             pn_TextSel.Font.Height:= sped_FontHeight.Value;
             pn_TextOth.Font.Height:= sped_FontHeight.Value;
          Except End;
End;


Procedure
          tfrm_edtcfg_.assignToCfg();
Begin
          // colors
          theConfig.col_TabLight      := pn_Lights .Color     .switchLowerBytes() ;
          theConfig.col_TabShadow     := pn_Shadows.Color     .switchLowerBytes() ;

          theConfig.col_TabEmporeUnSel:= pn_EmporeOth.Color   .switchLowerBytes() ;

          theConfig.col_TabEmporeSlctd:= pn_EmporeSel.Color   .switchLowerBytes() ;

          theConfig.col_TabFontUnSel  := pn_TextOth.Font.Color.switchLowerBytes() ;
          theConfig.col_TabFontSlctd  := pn_TextSel.Font.Color.switchLowerBytes() ;

          // font specific

          theConfig.str_TabFontName   := cbx_Fonts.Text+ #0                       ;
          theConfig.int_TabFontHeight := sped_FontHeight.Value                    ;
          theConfig.int_TabFontWidth  := sped_FontWidth.Value                     ;

          // padding
          theConfig.bte_TabPaddingX   := sped_PdgX.Value                          ;
          theConfig.bte_TabPaddingY   := sped_PdgY.Value                          ;

          // close buttons
          theConfig.cbs_CloseBtnStyle := tLWCETConfig.tCloseButtonStyle(
                                           cbx_CloseBtns.ItemIndex
                                         )                                        ;


End;


Procedure
          tfrm_edtcfg_.assignToFrm();
Begin
          // colors
          pn_Lights .Color            := theConfig.col_TabLight .switchLowerBytes()                ;
          pn_Lights .Font.Color       := pn_Lights.Color.guessContrastColor()                      ;

          pn_Shadows.Color            := theConfig.col_TabShadow.switchLowerBytes()                ;
          pn_Shadows.Font.Color       := pn_Shadows.Color.guessContrastColor()                     ;

          pn_EmporeOth.Color          := theConfig.col_TabEmporeUnSel.switchLowerBytes()           ;
          pn_EmporeOth.Font.Color     := pn_EmporeOth.Color.guessContrastColor()                   ;

          pn_EmporeSel.Color          := theConfig.col_TabEmporeSlctd.switchLowerBytes()           ;
          pn_EmporeSel.Font.Color     := pn_EmporeSel.Color.guessContrastColor()                   ;

          correctTextPnCol();

          pn_TextOth.Font.Color       := theConfig.col_TabFontUnSel.switchLowerBytes()             ;
          pn_TextSel.Font.Color       := theConfig.col_TabFontSlctd.switchLowerBytes()             ;


          // font specific

          pn_TextOth.Font.Name        := theConfig.str_TabFontName                                 ;
          pn_TextSel.Font.Name        := theConfig.str_TabFontName                                 ;
          cbx_Fonts.ItemIndex         := cbx_Fonts.Items.indexOf( trim( theConfig.str_TabFontName));

          sped_FontHeight.Value       := theConfig.int_TabFontHeight                               ;
          pn_TextSel.Font.Height      := theConfig.int_TabFontHeight                               ;
          sped_FontWidth.Value        := theConfig.int_TabFontWidth                                ;

          // padding
          sped_PdgX.Value             := theConfig.bte_TabPaddingX                                 ;
          sped_PdgY.Value             := theConfig.bte_TabPaddingY                                 ;

          // close buttons
          cbx_CloseBtns.ItemIndex     := intEger( theConfig.cbs_CloseBtnStyle)                     ;

          // Apply CB
          bbt_apply.Enabled           := assigned( theConfig.ApplyCB)                              ;


End;

Class Function
          tfrm_edtcfg_.exeCute( aMnFrm: tForm; Var aVarCfg: tLWCETConfig): tModalResult;
Var
          vtFrmEC                           : tfrm_edtcfg_;
Begin

          vtFrmEC:= tfrm_edtcfg_.create( aMnFrm);
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

Function
          enumDistinctFontNames( Var aLogFont: tEnumLogFontEx; Var aMetric: tNewTextMetricEx; aFontType: Longint; aData: lParam): longInt; Stdcall;
Var
          vtEFD1                            : tfrm_edtcfg_.tEnumFontData;
          vStFntNme                         : String;
Begin
          _nOp( [ @aMetric, aFontType]);

          If ( 0= aData)
             Then
             Exit;

          Try
             vtEFD1:= tfrm_edtcfg_.tEnumFontData( ptrInt( aData));
             vStFntNme  := aLogFont.elfLogFont.lfFaceName;
             vtEFD1.Fonts.add( vStFntNme);

             Result:= 1;
          Except
             Result:= 0;
          End;
End;

Function
          tfrm_edtcfg_.initializeEFD(): tEnumFontData;
Begin
          Result       := tEnumFontData.create();
          Result.Fonts := tStringList.create();
          Result.Parent:= Self;
End;

Procedure
          tfrm_edtcfg_.finalizeEFD( Var aEFD: tEnumFontData);
Begin
          aEFD.Parent:= Nil;
          aEFD.Fonts.clear();
          freeAndNil( aEFD.Fonts);
          freeAndNil( aEFD);
End;


Function
          tfrm_edtcfg_.apiReloadFonts41PAF( Out aVarSL: tStringList): intEger;
Var
          vhDC1                             : hDC;
          vtLf1                             : tLogFont;
          vtEFD1                            : tEnumFontData;
          vStOneFnt                         : String;
Begin
          Result:= -1;
          aVarSL:= Nil;

          Try

             vtLf1.lfCharSet          := DEFAULT_CHARSET;
             vtLf1.lfFaceName         := '';
             vtLf1.lfPitchAndFamily   := 0;

             vhDC1                    := getDC( 0);

             vtEFD1                   := initializeEFD();

             enumFontFamiliesEX( vhDC1, @vtLf1, @enumDistinctFontNames, lParam( vtEFD1), 0);
             If ( Nil<> vtEFD1.Fonts)
                Then
                Begin
                     aVarSL           := tStringList.create();
                     aVarSL.Sorted    := True;
                     For vStOneFnt In vtEFD1.Fonts
                         Do
                         Begin
                              If ( aVarSL.indexOf( vStOneFnt)< 0)
                                 Then
                                 aVarSL.Add( vStOneFnt);
                     End;
                     Result:= aVarSL.Count;
             End;

          Finally

             releaseDC( 0, vhDC1);
             finalizeEFD( vtEFD1);

          End;
End;


End.
