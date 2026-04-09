          { Copyright (C) 2026  StOver }
Unit
          iu_LOIPConf;

          {$mode ObjFPC}{$H+}

Interface



Type

          { tLOIPConfig }

          tLOIPConfig                      = Class( tObject)

          Public

             Type
                tApplyCallBack              = Procedure ( aSender: tLOIPConfig) Of Object;

          Protected

             acb                            : tApplyCallBack;

          Private


          Public

             // font specific

             int_FontHeight                 : intEger  ;

             Constructor                    create();
             Constructor                    create( aApplyCB: tApplyCallBack);

             Procedure                      assign( aTemplate: tLOIPConfig);

             Function                       clone(): tLOIPConfig;

             Property                       ApplyCB: tApplyCallBack Read acb Write acb;

          End;

Const
          cstr_CfgConfigVersion             = '1';

          cstr_CfgFileName                  = 'LazObjInspPalImpl.xml';

          cstr_CfgXMLPathUIFont             = 'UI/Font/'           ;


          //---------------- Config names


             // font specific

          cstr_CfgValNmeFontHeight          = 'FontHeight';


          //---------------- Default values


             // font specific

          cint_FontHeight                   : intEger  = 26;





Implementation

          { tLOIPConfig }

Constructor
          tLOIPConfig.create();
Begin

          // font specific

          int_FontHeight    := cint_FontHeight                 ;

          // buttons
          // apply

          ApplyCB           := Nil;

End;

Constructor
          tLOIPConfig.create( aApplyCB: tApplyCallBack);
Begin
          create();
          ApplyCB           := aApplyCB;
End;

Procedure
          tLOIPConfig.assign( aTemplate: tLOIPConfig);
Begin
          If Not ( assigned( aTemplate))
             Then
             Exit;

          // font specific

          int_FontHeight    := aTemplate.int_FontHeight     ;

          // apply
          ApplyCB           := aTemplate.ApplyCB;

End;


Function
          tLOIPConfig.clone(): tLOIPConfig;
Begin
          Result:= tLOIPConfig.create();
          Result.assign( Self);
End;




End.

