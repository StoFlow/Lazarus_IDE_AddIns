Unit
          iu_LWCETConf;

          {$mode ObjFPC}{$H+}

Interface

Uses
          iu_BGRColor;



Type

          { tLWCETConfig }

          tLWCETConfig                      = Class( tObject)

          Public

             Type
                tApplyCallBack              = Procedure ( aSender: tLWCETConfig) Of Object;

                tCloseButtonStyle           = ( cbs_None, cbs_12pxCircle, cbs_11pxRect, cbs_19pxBin);

          Protected

             acb                            : tApplyCallBack;

          Private


          Public


             // colors

             col_TabLight                   : tBGRColor;
             col_TabShadow                  : tBGRColor;

             col_TabEmporeUnSel             : tBGRColor;

             col_TabEmporeSlctd             : tBGRColor;

             col_TabFontUnSel               : tBGRColor;
             col_TabFontSlctd               : tBGRColor;


             // font specific

             str_TabFontName                : String   ;
             int_TabFontHeight              : intEger  ;
             int_TabFontWidth               : intEger  ;

             // padding
             bte_TabPaddingX                : Byte     ;
             bte_TabPaddingY                : Byte     ;

             // close buttons
             cbs_CloseBtnStyle              : tCloseButtonStyle;

             Constructor                    create();
             Constructor                    create( aApplyCB: tApplyCallBack);

             Procedure                      assign( aTemplate: tLWCETConfig);

             Function                       clone(): tLWCETConfig;

             Property                       ApplyCB: tApplyCallBack Read acb Write acb;

          End;

Const
          cstr_CfgConfigVersion             = '1';

          cstr_CfgFileName                  = 'LazWinColEdTabs.xml';

          cstr_CfgXMLPathUIColors           = 'UI/Colors/'         ;
          cstr_CfgXMLPathUIFont             = 'UI/Font/'           ;
          cstr_CfgXMLPathUIPadding          = 'UI/Padding/'        ;


          //---------------- Config names

             // colors

          cstr_CfgValNmeTabLight            = 'TabLight';
          cstr_CfgValNmeTabShadow           = 'TabShadow';

          cstr_CfgValNmeTabEmporeUnSel      = 'TabEmporeUnSel';

          cstr_CfgValNmeTabEmporeSlctd      = 'TabEmporeSlctd';

          cstr_CfgValNmeTabFontUnSel        = 'TabFontUnSel';
          cstr_CfgValNmeTabFontSlctd        = 'TabFontSlctd';

             // font specific

          cstr_CfgValNmeTabFontName         = 'TabFontName';
          cstr_CfgValNmeTabFontHeight       = 'TabFontHeight';
          cstr_CfgValNmeTabFontWidth        = 'TabFontWidth';

             // padding

          cstr_CfgValNmeTabPaddingX         = 'TabPaddingX';
          cstr_CfgValNmeTabPaddingY         = 'TabPaddingY';

             // close buttons

          cstr_CfgValNmeCloseBtnStyle       = 'CloseBtnStyle';

          //---------------- Default values

             // colors

          ccol_TabLight                     : tBGRColor= ccolWhite;
          ccol_TabShadow                    : tBGRColor= ccolDarkOchre;

          ccol_TabEmporeUnSel               : tBGRColor= ccolLghtOchre;

          ccol_TabEmporeSlctd               : tBGRColor= ccolBlue;

          ccol_TabFontUnSel                 : tBGRColor= ccolBlue;
          ccol_TabFontSlctd                 : tBGRColor= ccolLghtOchre;

             // font specific

          cstr_TabFontName                  : String   = 'Tahoma'#0;
          cint_TabFontHeight                : intEger  = 14;
          cint_TabFontWidth                 : intEger  = 6;


             // padding

          cbte_TabPaddingX                  = 20;
          cbte_TabPaddingY                  =  4;

             // close buttons

          ccbs_CloseBtnStyle                = tLWCETConfig.tCloseButtonStyle.cbs_12pxCircle;


Implementation

          { tLWCETConfig }

Constructor
          tLWCETConfig.create();
Begin
          // colors

          col_TabLight      := ccol_TabLight                   ;
          col_TabShadow     := ccol_TabShadow                  ;

          col_TabEmporeUnSel:= ccol_TabEmporeUnSel             ;

          col_TabEmporeSlctd:= ccol_TabEmporeSlctd             ;

          col_TabFontUnSel  := ccol_TabFontUnSel               ;
          col_TabFontSlctd  := ccol_TabFontSlctd               ;

          // font specific

          str_TabFontName   := cstr_TabFontName                ;
          int_TabFontHeight := cint_TabFontHeight              ;
          int_TabFontWidth  := cint_TabFontWidth               ;

          // padding
          bte_TabPaddingX   := cbte_TabPaddingX                ;
          bte_TabPaddingY   := cbte_TabPaddingY                ;

          // close buttons
          cbs_CloseBtnStyle := tCloseButtonStyle.cbs_12pxCircle;  // cbs_None; .

          ApplyCB           := Nil;

End;

Constructor
          tLWCETConfig.create( aApplyCB: tApplyCallBack);
Begin
          create();
          ApplyCB           := aApplyCB;
End;

Procedure
          tLWCETConfig.assign( aTemplate: tLWCETConfig);
Begin
          If Not ( assigned( aTemplate))
             Then
             Exit;

          // colors

          col_TabLight      := aTemplate.col_TabLight       ;
          col_TabShadow     := aTemplate.col_TabShadow      ;

          col_TabEmporeUnSel:= aTemplate.col_TabEmporeUnSel ;

          col_TabEmporeSlctd:= aTemplate.col_TabEmporeSlctd ;

          col_TabFontUnSel  := aTemplate.col_TabFontUnSel   ;
          col_TabFontSlctd  := aTemplate.col_TabFontSlctd   ;

          // font specific

          str_TabFontName   := aTemplate.str_TabFontName    ;
          int_TabFontHeight := aTemplate.int_TabFontHeight  ;
          int_TabFontWidth  := aTemplate.int_TabFontWidth   ;

          // padding
          bte_TabPaddingX   := aTemplate.bte_TabPaddingX    ;
          bte_TabPaddingY   := aTemplate.bte_TabPaddingY    ;

          // close buttons
          cbs_CloseBtnStyle := aTemplate.cbs_CloseBtnStyle  ;

          // apply
          ApplyCB           := aTemplate.ApplyCB;

End;


Function
          tLWCETConfig.clone(): tLWCETConfig;
Begin
          Result:= tLWCETConfig.create();
          Result.assign( Self);
End;




End.

