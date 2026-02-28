          { Copyright (C) 2026  StOver }
Unit
          iu_LMWPConf;

          {$mode ObjFPC}{$H+}

Interface

//Uses
//          iu_BGRColor;



Type

          { tLMWPConfig }

          tLMWPConfig                      = Class( tObject)

          Public

             Type
                tApplyCallBack              = Procedure ( aSender: tLMWPConfig) Of Object;

          Protected

             acb                            : tApplyCallBack;

          Private


          Public


             // font specific

             int_FontHeight                 : intEger  ;

             // padding
             int_ItemHeight                 : intEger  ;


             Constructor                    create();
             Constructor                    create( aApplyCB: tApplyCallBack);

             Procedure                      assign( aTemplate: tLMWPConfig);

             Function                       clone(): tLMWPConfig;

             Property                       ApplyCB: tApplyCallBack Read acb Write acb;

          End;

Const
          cstr_CfgConfigVersion             = '1';

          cstr_CfgFileName                  = 'LazMsgWndPalImpl.xml';

          cstr_CfgXMLPathUIFont             = 'UI/Font/'           ;
          cstr_CfgXMLPathUIPadding          = 'UI/Padding/'        ;


          //---------------- Config names

             // font specific

          cstr_CfgValNmeFontHeight          = 'FontHeight';

             // padding

          cstr_CfgValNmeItemHeight          = 'ItemHeight';

          //---------------- Default values


             // font specific

          cint_FontHeight                   : intEger  = 26;


             // padding

          cint_ItemHeight                   : intEger  = 26;



Implementation

          { tLMWPConfig }

Constructor
          tLMWPConfig.create();
Begin
          // font specific

          int_FontHeight    := cint_FontHeight                 ;

          // padding
          int_ItemHeight    := cint_ItemHeight                 ;

          // close buttons

          ApplyCB           := Nil;

End;

Constructor
          tLMWPConfig.create( aApplyCB: tApplyCallBack);
Begin
          create();
          ApplyCB           := aApplyCB;
End;

Procedure
          tLMWPConfig.assign( aTemplate: tLMWPConfig);
Begin
          If Not ( assigned( aTemplate))
             Then
             Exit;

          // font specific

          int_FontHeight    := aTemplate.int_FontHeight     ;

          // padding
          int_ItemHeight    := aTemplate.int_ItemHeight     ;

          // apply
          ApplyCB           := aTemplate.ApplyCB;

End;


Function
          tLMWPConfig.clone(): tLMWPConfig;
Begin
          Result:= tLMWPConfig.create();
          Result.assign( Self);
End;




End.

