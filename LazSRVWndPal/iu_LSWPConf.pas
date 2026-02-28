          { Copyright (C) 2026  StOver }
Unit
          iu_LSWPConf;

          {$mode ObjFPC}{$H+}

Interface

          {$IFDEF FUN}
Uses
          iu_LSWPBGRColor;

          {$ENDIF}


Type

          { tLSWPConfig }

          tLSWPConfig                      = Class( tObject)

          Public

             Type
                tApplyCallBack              = Procedure ( aSender: tLSWPConfig) Of Object;

          Protected

             acb                            : tApplyCallBack;

          Private


          Public

             {$IFDEF FUN}
             // colors

             col_Font                       : tBGRColor;
             col_Back                       : tBGRColor;

             {$ENDIF}

             // font specific

             int_FontHeight                 : intEger  ;

             Constructor                    create();
             Constructor                    create( aApplyCB: tApplyCallBack);

             Procedure                      assign( aTemplate: tLSWPConfig);

             Function                       clone(): tLSWPConfig;

             Property                       ApplyCB: tApplyCallBack Read acb Write acb;

          End;

Const
          cstr_CfgConfigVersion             = '1';

          cstr_CfgFileName                  = 'LazSrvWndPalImpl.xml';

          {$IFDEF FUN}
          cstr_CfgXMLPathUIColors           = 'UI/Colors/'         ;
          {$ENDIF}
          cstr_CfgXMLPathUIFont             = 'UI/Font/'           ;


          //---------------- Config names

          {$IFDEF FUN}
             // colors

          cstr_CfgValNmeFont                = 'Font';
          cstr_CfgValNmeBack                = 'Back';
          {$ENDIF}

             // font specific

          cstr_CfgValNmeFontHeight          = 'FontHeight';


          //---------------- Default values

          {$IFDEF FUN}
             // colors

          ccol_Font                         : tBGRColor= ccolBlack;
          ccol_Back                         : tBGRColor= ccolLime;
          {$ENDIF}


             // font specific

          cint_FontHeight                   : intEger  = 26;





Implementation

          { tLSWPConfig }

Constructor
          tLSWPConfig.create();
Begin
          {$IFDEF FUN}
          // colors

          col_Font          := ccol_Font;
          col_Back          := ccol_Back;
          {$ENDIF}

          // font specific

          int_FontHeight    := cint_FontHeight                 ;

          // buttons
          // apply

          ApplyCB           := Nil;

End;

Constructor
          tLSWPConfig.create( aApplyCB: tApplyCallBack);
Begin
          create();
          ApplyCB           := aApplyCB;
End;

Procedure
          tLSWPConfig.assign( aTemplate: tLSWPConfig);
Begin
          If Not ( assigned( aTemplate))
             Then
             Exit;

          {$IFDEF FUN}
          // colors

          col_Font          := aTemplate.col_Font;
          col_Back          := aTemplate.col_Back;
          {$ENDIF}

          // font specific

          int_FontHeight    := aTemplate.int_FontHeight     ;

          // apply
          ApplyCB           := aTemplate.ApplyCB;

End;


Function
          tLSWPConfig.clone(): tLSWPConfig;
Begin
          Result:= tLSWPConfig.create();
          Result.assign( Self);
End;




End.

