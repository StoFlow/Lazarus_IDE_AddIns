          { Copyright (C) 2026  StOver }
Unit
          su_LMWPConf;

          {$mode ObjFPC}{$H+}

Interface


Uses
          iu_LMWPConf
          ,
          LazConfigStorage
          ,
          typInfo
          ,
          clAsses
          ,
          SysUtils;

Function
          getConfig(): tLMWPConfig;
Function
          setConfig( aCfg: tLMWPConfig): boolEan;



Implementation

Uses
          ideOptionDefs
          ,
          diaLogs
          ;

Function
          getCfgStg(): tConfigStorage;
Begin
          Result:= Nil;

          Try
             Result:= getLazIDEConfigStorage( cstr_CfgFileName, True);
          Except
             On E: Exception
                Do
                Begin
                     // #todo: do smtg useful
             End;
          End;

          If ( Nil= Result)
             Then
             Try
                Result:= getLazIDEConfigStorage( cstr_CfgFileName, False);
             Except
                On E: Exception
                   Do
                   Begin
                     // #todo: do smtg useful
                End;
             End;
End;


Function
          getConfig(): tLMWPConfig;
Var
          csCfgStg                       : tConfigStorage;
Begin
          Result  := tLMWPConfig.create();
          csCfgStg:= getCfgStg();

          If ( Nil= csCfgStg)
             Then
             Exit;

          // font
          Result.int_FontHeight     := csCfgStg.GetValue( cstr_CfgXMLPathUIFont   + cstr_CfgValNmeFontHeight     , cint_FontHeight)    ;

          // padding
          Result.int_ItemHeight     := csCfgStg.GetValue( cstr_CfgXMLPathUIPadding+ cstr_CfgValNmeItemHeight     , cint_ItemHeight)    ;
End;

Function
          setConfig( aCfg: tLMWPConfig): boolEan;
Var
          csCfgStg                       : tConfigStorage;
Begin
          Result  := False;
          csCfgStg:= getCfgStg();

          If ( Nil= csCfgStg)
             Then
             Exit;

          If ( Nil= aCfg)
             Then
             Exit;

          Try
             // font
             csCfgStg.SetValue( cstr_CfgXMLPathUIFont   + cstr_CfgValNmeFontHeight     , aCfg.int_FontHeight)   ;

             // padding
             csCfgStg.SetValue( cstr_CfgXMLPathUIPadding+ cstr_CfgValNmeItemHeight     , aCfg.int_ItemHeight);

             csCfgStg.writeToDisk();
             Result:= True;

          Except
            On E: Exception
               Do
               Begin
                    // #todo: do smtg useful
            End;
          End;
End;



initIalization
Begin

End;

End.

