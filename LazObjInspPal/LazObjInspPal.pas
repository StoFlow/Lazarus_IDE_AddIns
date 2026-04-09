{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit LazObjInspPal;

{$warn 5023 off : no warning about unused units}
interface

uses
  LazObjInspPalImpl, frm_LOIPEdtCfg, iu_LOIPConf, su_LOIPConf, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('LazObjInspPalImpl', @LazObjInspPalImpl.Register);
end;

initialization
  RegisterPackage('LazObjInspPal', @Register);
end.
