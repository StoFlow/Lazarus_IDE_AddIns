Unit
          iu_DateTime;

          {$mode ObjFPC}{$H+}
          {$ModeSwitch typehelpers}

Interface


Uses
          Classes
          ,
          SysUtils;

Type
          { tHTypeHelperDtTme }

          //tDtTme                            = System.tDateTime;
          tHTypeHelperDtTme                 = Type Helper For tDateTime

          Type
             tDtElPos                       = 0.. 8;

             Function                       toString(
                                                      aYrPos: tDtElPos= 1;
                                                      aMtPos: tDtElPos= 2;
                                                      aDyPos: tDtElPos= 3;
                                                      aMdPos: tDtElPos= 4;
                                                      aHrPos: tDtElPos= 5;
                                                      aMnPos: tDtElPos= 6;
                                                      aSsPos: tDtElPos= 7;
                                                      aMsPos: tDtElPos= 8;
                                                      aDtSep: String  = '-';
                                                      aMdSep: String  = '-';
                                                      aTmSep: String  = '-'
                                            ): String;

          End;


Implementation

          { tHTypeHelperDtTme }

Function
          tHTypeHelperDtTme.toString(
                                       aYrPos: tDtElPos= 1;
                                       aMtPos: tDtElPos= 2;
                                       aDyPos: tDtElPos= 3;
                                       aMdPos: tDtElPos= 4;
                                       aHrPos: tDtElPos= 5;
                                       aMnPos: tDtElPos= 6;
                                       aSsPos: tDtElPos= 7;
                                       aMsPos: tDtElPos= 8;
                                       aDtSep: String  = '-';
                                       aMdSep: String  = '-';
                                       aTmSep: String  = '-'
                                      ): String;
Var
          vStFmtStr                         : String;
          vDtElCnt                          : tDtElPos;
          vDtElOne                          : tDtElPos;
          vBoMdSep                          : boolEan;
Begin
          vStFmtStr:= '';
          Result   := '';
          vDtElCnt := 0;
          vBoMdSep := False;

          If ( aYrPos<> 0) Then vDtElCnt+= 1;
          If ( aMtPos<> 0) Then vDtElCnt+= 1;
          If ( aDyPos<> 0) Then vDtElCnt+= 1;
          If ( aMdPos<> 0) Then vDtElCnt+= 1;
          If ( aHrPos<> 0) Then vDtElCnt+= 1;
          If ( aMnPos<> 0) Then vDtElCnt+= 1;
          If ( aSsPos<> 0) Then vDtElCnt+= 1;
          If ( aMsPos<> 0) Then vDtElCnt+= 1;

          If ( 0< vDtElCnt)
             Then
             Begin

                  For vDtElOne:= 1 To vDtElCnt
                      Do
                      Begin
                           If ( vStFmtStr<> '') And ( Not vBoMdSep)
                              Then
                              Begin
                                   If ( aYrPos= vDtElOne) Then vStFmtStr+= aDtSep;
                                   If ( aMtPos= vDtElOne) Then vStFmtStr+= aDtSep;
                                   If ( aDyPos= vDtElOne) Then vStFmtStr+= aDtSep;

                                   If ( aMdPos= vDtElOne) Then Begin vStFmtStr+= aMdSep; vBoMdSep:= True; conTinue; End;

                                   If ( aHrPos= vDtElOne) Then vStFmtStr+= aTmSep;
                                   If ( aMnPos= vDtElOne) Then vStFmtStr+= aTmSep;
                                   If ( aSsPos= vDtElOne) Then vStFmtStr+= aTmSep;
                                   If ( aMsPos= vDtElOne) Then vStFmtStr+= aTmSep;
                           End;
                           vBoMdSep:= False;

                           If ( aYrPos= vDtElOne) Then vStFmtStr+= 'yyyy';
                           If ( aMtPos= vDtElOne) Then vStFmtStr+= 'mm';
                           If ( aDyPos= vDtElOne) Then vStFmtStr+= 'dd';

                           If ( aHrPos= vDtElOne) Then vStFmtStr+= 'hh';
                           If ( aMnPos= vDtElOne) Then vStFmtStr+= 'nn';
                           If ( aSsPos= vDtElOne) Then vStFmtStr+= 'ss';
                           If ( aMsPos= vDtElOne) Then vStFmtStr+= 'zzz';
                  End;

                  Try
                     dateTimeToString( Result, vStFmtStr, now());
                  Except End;
          End;
End;


End.
