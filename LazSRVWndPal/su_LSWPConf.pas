          { Copyright (C) 2026  StOver }
Unit
          su_LSWPConf;

          {$mode ObjFPC}{$H+}

Interface


Uses
          iu_LSWPConf
          ,
          LazConfigStorage
          ,
          typInfo
          ,
          clAsses
          ,
          SysUtils;

Function
          getConfig(): tLSWPConfig;
Function
          setConfig( aCfg: tLSWPConfig): boolEan;



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
          getConfig(): tLSWPConfig;
Var
          csCfgStg                       : tConfigStorage;
Begin
          Result  := tLSWPConfig.create();
          csCfgStg:= getCfgStg();

          If ( Nil= csCfgStg)
             Then
             Exit;

          {$IFDEF FUN}
          // colors

          Result.col_Font           := csCfgStg.GetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeFont           , ccol_Font)          ;
          Result.col_Back           := csCfgStg.GetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeBack           , ccol_Back)          ;
          {$ENDIF}

          // font
          Result.int_FontHeight     := csCfgStg.GetValue( cstr_CfgXMLPathUIFont   + cstr_CfgValNmeFontHeight     , cint_FontHeight)    ;

End;

Function
          setConfig( aCfg: tLSWPConfig): boolEan;
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
             {$IFDEF FUN}
             // colors

             csCfgStg.SetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeFont           , aCfg.col_Font)   ;
             csCfgStg.SetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeBack           , aCfg.col_Back)   ;
             {$ENDIF}

             // font
             csCfgStg.SetValue( cstr_CfgXMLPathUIFont   + cstr_CfgValNmeFontHeight     , aCfg.int_FontHeight)   ;

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

