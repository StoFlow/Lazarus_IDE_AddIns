Unit
          iu_LWCETConf;

          {$mode ObjFPC}{$H+}

Interface

Uses
          iu_BGRColor;

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

Type

          { tLWCETConfig }

          tLWCETConfig                      = Class( tObject)

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

             Constructor                    create();

          End;


Implementation

          { tLWCETConfig }

Constructor
          tLWCETConfig.create();
Begin
          // colors

          col_TabLight      := ccol_TabLight       ;
          col_TabShadow     := ccol_TabShadow      ;

          col_TabEmporeUnSel:= ccol_TabEmporeUnSel ;

          col_TabEmporeSlctd:= ccol_TabEmporeSlctd ;

          col_TabFontUnSel  := ccol_TabFontUnSel   ;
          col_TabFontSlctd  := ccol_TabFontSlctd   ;

          // font specific

          str_TabFontName   := cstr_TabFontName    ;
          int_TabFontHeight := cint_TabFontHeight  ;
          int_TabFontWidth  := cint_TabFontWidth   ;

          // padding
          bte_TabPaddingX   := cbte_TabPaddingX    ;
          bte_TabPaddingY   := cbte_TabPaddingY    ;

End;

End.

