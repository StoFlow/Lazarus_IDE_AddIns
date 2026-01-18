Unit
          su_LWCETConf;

          {$mode ObjFPC}{$H+}

Interface


Uses
          idecmdline
          ,
          iu_LWCETConf
          ,
          LazConfigStorage
          ,
          typInfo
          ,
          clAsses
          ,
          SysUtils;

Function
          getConfig(): tLWCETConfig;
Function
          setConfig( aCfg: tLWCETConfig): boolEan;

Function  // #todo : to be moved to another unit later
          fillEnumNames( aTypeInfo: pTypeInfo; aList: tStrings; aLeftCut: Byte= 4): intEger;

Function
          fillCloseButtonStyles( aStylesList: tStrings; aLeftCut: Byte= 4): intEger;


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
          getConfig(): tLWCETConfig;
Var
          csCfgStg                       : tConfigStorage;
Begin
          Result  := tLWCETConfig.create();
          csCfgStg:= getCfgStg();

          If ( Nil= csCfgStg)
             Then
             Exit;

          // colors
          Result.col_TabLight       := csCfgStg.GetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabLight       , ccol_TabLight)      ;
          Result.col_TabShadow      := csCfgStg.GetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabShadow      , ccol_TabShadow)     ;

          Result.col_TabEmporeSlctd := csCfgStg.GetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabEmporeSlctd , ccol_TabEmporeSlctd);
          Result.col_TabEmporeUnSel := csCfgStg.GetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabEmporeUnSel , ccol_TabEmporeUnSel);

          Result.col_TabFontSlctd   := csCfgStg.GetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabFontSlctd   , ccol_TabFontSlctd)  ;
          Result.col_TabFontUnSel   := csCfgStg.GetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabFontUnSel   , ccol_TabFontUnSel)  ;

          // font
          Result.str_TabFontName    := csCfgStg.GetValue( cstr_CfgXMLPathUIFont   + cstr_CfgValNmeTabFontName    , cstr_TabFontName)   ;
          Result.int_TabFontHeight  := csCfgStg.GetValue( cstr_CfgXMLPathUIFont   + cstr_CfgValNmeTabFontHeight  , cint_TabFontHeight) ;
          Result.int_TabFontWidth   := csCfgStg.GetValue( cstr_CfgXMLPathUIFont   + cstr_CfgValNmeTabFontWidth   , cint_TabFontWidth)  ;

          // padding
          Result.bte_TabPaddingX    := csCfgStg.GetValue( cstr_CfgXMLPathUIPadding+ cstr_CfgValNmeTabPaddingX    , cbte_TabPaddingX)   ;
          Result.bte_TabPaddingY    := csCfgStg.GetValue( cstr_CfgXMLPathUIPadding+ cstr_CfgValNmeTabPaddingY    , cbte_TabPaddingY)   ;

          // close buttons
          Result.cbs_CloseBtnStyle  := tLWCETConfig.tCloseButtonStyle( csCfgStg.GetValue( cstr_CfgXMLPathUIPadding+ cstr_CfgValNmeCloseBtnStyle  , intEger( ccbs_CloseBtnStyle))) ;
End;

Function
          setConfig( aCfg: tLWCETConfig): boolEan;
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
             // colors
             csCfgStg.SetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabLight       , aCfg.col_TabLight);
             csCfgStg.SetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabShadow      , aCfg.col_TabShadow);

             csCfgStg.SetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabEmporeSlctd , aCfg.col_TabEmporeSlctd);
             csCfgStg.SetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabEmporeUnSel , aCfg.col_TabEmporeUnSel);

             csCfgStg.SetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabFontSlctd   , aCfg.col_TabFontSlctd);
             csCfgStg.SetValue( cstr_CfgXMLPathUIColors + cstr_CfgValNmeTabFontUnSel   , aCfg.col_TabFontUnSel);


             // font
             csCfgStg.SetValue( cstr_CfgXMLPathUIFont   + cstr_CfgValNmeTabFontName    , aCfg.str_TabFontName);
             csCfgStg.SetValue( cstr_CfgXMLPathUIFont   + cstr_CfgValNmeTabFontHeight  , aCfg.int_TabFontHeight);
             csCfgStg.SetValue( cstr_CfgXMLPathUIFont   + cstr_CfgValNmeTabFontWidth   , aCfg.int_TabFontWidth);

             // padding
             csCfgStg.SetValue( cstr_CfgXMLPathUIPadding+ cstr_CfgValNmeTabPaddingX    , aCfg.bte_TabPaddingX);
             csCfgStg.SetValue( cstr_CfgXMLPathUIPadding+ cstr_CfgValNmeTabPaddingY    , aCfg.bte_TabPaddingY);

             // close buttons
             csCfgStg.SetValue( cstr_CfgXMLPathUIPadding+ cstr_CfgValNmeCloseBtnStyle  , intEger( aCfg.cbs_CloseBtnStyle));

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

Function  // #todo : to be moved to another unit later
          fillEnumNames( aTypeInfo: pTypeInfo; aList: tStrings; aLeftCut: Byte= 4): intEger;
Var
          vInOne                            : intEger;
          vInCnt                            : intEger;
          vStOne                            : String;
          vInLen                            : intEger;
Begin
          Result:= -1;
          If ( Not assigned( aList))
             Or
             ( Not assigned( aTypeInfo))
             Then
             Exit;

          Try
             aList.clear();
          Except
             Exit;
          End;

          vInCnt := getEnumNameCount( aTypeInfo);

          For vInOne:= 0 To vInCnt- 1
              Do
              Begin
                   vStOne:= getEnumName( aTypeInfo, vInOne);

                   vInLen:= vStOne.length;
                   If ( vInLen> aLeftCut)
                      Then
                      vStOne:= copy( vStOne, aLeftCut+ 1, vInLen- aLeftCut);

                   aList.addObject( vStOne, tObject( IntPtr( vInOne)));
          End;

          Result:= aList.Count;
End;


Function
          fillCloseButtonStyles( aStylesList: tStrings; aLeftCut: Byte= 4): intEger;
Var
          //vInOne                            : intEger;
          //vInCnt                            : intEger;
          //vStOne                            : String;
          vpTpInf                           : pTypeInfo;
          //vInLen                            : intEger;
Begin
          vpTpInf:= typeInfo( tLWCETConfig.tCloseButtonStyle);
          Result:= fillEnumNames( vpTpInf, aStylesList, aLeftCut);
          //Result:= -1;
          //If ( Not assigned( aStylesList))
          //   Then
          //   Exit;
          //
          //Try
          //   aStylesList.clear();
          //Except
          //   Exit;
          //End;
          //
          //vpTpInf:= typeInfo( tLWCETConfig.tCloseButtonStyle);
          //vInCnt := getEnumNameCount( vpTpInf);
          //
          //For vInOne:= 0 To vInCnt- 1
          //    Do
          //    Begin
          //         vStOne:= getEnumName( vpTpInf, vInOne);
          //
          //         vInLen:= vStOne.length;
          //         If ( vInLen> aLeftCut)
          //            Then
          //            vStOne:= copy( vStOne, aLeftCut+ 1, vInLen- aLeftCut);
          //
          //         aStylesList.addObject( vStOne, tObject( IntPtr( vInOne)));
          //End;
          //
          //Result:= aStylesList.Count;
End;


initIalization
Begin

End;

End.

