Unit
          LitteBmpMgr;

          {$mode ObjFPC}{$H+}
          {$ModeSwitch typehelpers}


          {$If ( FPC_RELEASE< 3)}
               {$Define belowFPC331}
          {$Else}
          {$EndIf}

Interface

Uses
          Classes
          ,
          graPhics
          ,
          SysUtils
          ;


Type
          pBitmap                           =^tBitmap;

          { tHTypeHelpertStrArr }

          tHTypeHelpertStrArr               = Type Helper For tStringArray

             Class Function                 fromOpenAOS( aStrings: Array Of String): tStringArray; Static;

          End;


          tLitteBmpMgr                      = Class( tObject)

          Public

             Type

                tLBMInfo                    = Class( tObject)

                End;

          Protected

             sl_Bmps                        : tStringList;


             Function                       _bm_get( aName: String) : tBitMap;

          Public

             Function                       loadOnePic( aName: String): tBitmap;
             Function                       loadPics( aBmpNames: tStringArray): dWord;

             Constructor                    create( aBmpNames: tStringArray );
             Constructor                    create( aBmpNames: Array Of String);

             Procedure                      unLoadOnePic( aPic: pBitmap);
             Procedure                      unLoadPics();
             Procedure                      reLoadPics();

             Property                       Bitmap[ aName: String]: tBitMap Read _bm_get; Default;

          End;


Implementation

Uses
          diaLogs
          //,
          //SysUtils
          ;


          { tHTypeHelpertStrArr }

Class Function
           tHTypeHelpertStrArr.fromOpenAOS( aStrings: Array Of String): tStringArray;
           {$IFDEF belowFPC331}
Var
           vIn1                              : intEger;
           vIn2                              : intEger;
           {$ENDIF}
Begin
           {$IFDEF belowFPC331}
           vIn2:= length( aStrings);
           Result:= [];
           setLength( Result, vIn2);
           For vIn1:= 0 To vIn2- 1
               Do
               Begin
                    Result[ vIn1]:= aStrings[ vIn1];
           End;
           {$ELSE}
           Result:= copy( aStrings, 0, length( aStrings));
           {$ENDIF}
End;


Function
          tLitteBmpMgr._bm_get( aName: String) : tBitMap;
Var
          vSt1fnd                           : String;
          vInIdx                            : intEger;
Begin
          Result:= Nil;
          If ( assigned( sl_Bmps))
             And
             ( 0< sl_Bmps.Count)
             Then
             Begin
                  vSt1fnd:= aName.trim().toLower();
                  vInIdx := sl_Bmps.indexof( vSt1fnd);
                  If ( -1< vInIdx)
                     Then
                     Result:= tBitMap( sl_Bmps.Objects[ vInIdx]);
          End;
End;

Function
          tLitteBmpMgr.loadOnePic( aName: String): tBitmap;
Var
          vStResName                        : String;
Begin
          Result:= tBitmap.create();
          Try
             vStResName:= aName;
             If ( ''<> vStResName)
                Then
                Begin
                     Result.loadFromResourceName( hINSTANCE, vStResName);
             End;
          Except
             On E: Exception
                Do
                showMessage( E.Message);
          End;
End;


Function  // Array Of String
          tLitteBmpMgr.loadPics( aBmpNames: tStringArray): dWord;
Var
          vStOne                            : String;
          vSt1fnd                           : String;
          vtBm1                             : tBitMap;
Begin
          Result:= 0;
          If ( Nil= sl_Bmps)
             Or
             ( 1  > length( aBmpNames))
             Then
             Exit;

          For vStOne In aBmpNames
              Do
              Begin
                   vSt1fnd:= vStOne.trim().toLower();
                   If ( ''= vSt1fnd)
                      Then
                      conTinue;

                   If ( sl_Bmps.indexOf( vSt1fnd)< 0)
                      Then
                      Begin
                           vtBm1:= loadOnePic( vSt1fnd);
                           sl_Bmps.addObject( vSt1fnd, vtBm1);
                           vtBm1:= Nil;
                   End;
          End;
          Result:= sl_Bmps.Count;
End;

Constructor
          tLitteBmpMgr.create( aBmpNames: tStringArray );
Begin
          inHerited create();

          {$IFDEF belowFPC331}
          sl_Bmps:= tStringList.create();
          {$ELSE}
          sl_Bmps:= tStringList.create( True);
          {$ENDIF}

          loadPics( aBmpNames);
End;


Constructor
          tLitteBmpMgr.create( aBmpNames: Array Of String);
Begin
          inHerited create();

          {$IFDEF belowFPC331}
          sl_Bmps:= tStringList.create();
          {$ELSE}
          sl_Bmps:= tStringList.create( True);
          {$ENDIF}
          loadPics( tStringArray.fromOpenAOS( aBmpNames));
End;



Procedure
          tLitteBmpMgr.unLoadOnePic( aPic: pBitmap);
Begin
          If Nil= aPic
             Then
             Exit;

          If not assigned( aPic^)
             Then
             Exit;

          Try
             aPic^.freeImage();
             aPic^.clear();
          Finally
             Try
                aPic^:= Nil;
             Except End;
          End;
End;

Procedure
          tLitteBmpMgr.unLoadPics();
Var
          vStOne                            : String;
Begin
          If ( Nil= sl_Bmps)
             Or
             ( 1  > sl_Bmps.Count)
             Then
             Exit;

          For vStOne In sl_Bmps
              Do
              Begin

          End;
End;

Procedure
          tLitteBmpMgr.reLoadPics();
Var
          aos_Strings                       : tStringArray;
Begin
          If ( Nil= sl_Bmps)
             Or
             ( 1  > sl_Bmps.Count)
             Then
             Exit;

          aos_Strings:= sl_Bmps.toStringArray();

          unLoadPics();
          loadPics( aos_Strings);
End;



End.
