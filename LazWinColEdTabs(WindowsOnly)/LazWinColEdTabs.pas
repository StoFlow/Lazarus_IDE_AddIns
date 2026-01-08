{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit LazWinColEdTabs;

{$warn 5023 off : no warning about unused units}
interface

uses
  LazWinColEdTabsImpl, iu_DateTime, iu_LWCETConf, su_LWCETConf, iu_BGRColor, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('LazWinColEdTabsImpl', @LazWinColEdTabsImpl.Register);
end;

initialization
  RegisterPackage('LazWinColEdTabs', @Register);
end.
