          { Copyright (C) 2026  StOver }
Unit
          su_LOIPConf;

          {$mode ObjFPC}{$H+}

Interface


Uses
          iu_LOIPConf
          ,
          LazConfigStorage
          ,
          typInfo
          ,
          clAsses
          ,
          SysUtils;

Function
          getConfig(): tLOIPConfig;
Function
          setConfig( aCfg: tLOIPConfig): boolEan;



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
          getConfig(): tLOIPConfig;
Var
          csCfgStg                       : tConfigStorage;
Begin
          Result  := tLOIPConfig.create();
          csCfgStg:= getCfgStg();

          If ( Nil= csCfgStg)
             Then
             Exit;


          // font
          Result.int_FontHeight     := csCfgStg.GetValue( cstr_CfgXMLPathUIFont   + cstr_CfgValNmeFontHeight     , cint_FontHeight)    ;

End;

Function
          setConfig( aCfg: tLOIPConfig): boolEan;
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

