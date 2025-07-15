{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit deleteOutPut;

{$warn 5023 off : no warning about unused units}
interface

uses
  deleteOutPutImpl, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('deleteOutPutImpl', @deleteOutPutImpl.Register);
end;

initialization
  RegisterPackage('deleteOutPut', @Register);
end.
