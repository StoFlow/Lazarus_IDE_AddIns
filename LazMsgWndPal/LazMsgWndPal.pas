{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit LazMsgWndPal;

{$warn 5023 off : no warning about unused units}
interface

uses
  LazMsgWndPalImpl, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('LazMsgWndPalImpl', @LazMsgWndPalImpl.Register);
end;

initialization
  RegisterPackage('LazMsgWndPal', @Register);
end.
