Unit
          iu_BGRColor;

          {$mode ObjFPC}{$H+}
          {$ModeSwitch typehelpers}

Interface

Type

          tBGRColor                         = $000000.. $FFFFFF;

          { tHTypeHelperBGRColor }

          tHTypeHelperBGRColor              = Type Helper For tBGRColor

             Function                       toColorRef(): longInt;

          End;

Const
          ccolWhite                         = $FFFFFF;
          ccolBlue                          = $0000FF;

          ccolDarkOchre                     = $999975;
          ccolLghtOchre                     = $E7E8A8;


Implementation

          { tHTypeHelperBGRColor }

Function
          tHTypeHelperBGRColor.toColorRef(): longInt;

Begin
          Result:= ( ( Self And $0000FF) Shl 16)
                   Or
                   ( ( Self And $00FF00)       )
                   Or
                   ( ( Self And $FF0000) Shr 16)
                   ;
End;


End.

