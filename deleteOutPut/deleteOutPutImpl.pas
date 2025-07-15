          { Copyright (C) 2025  StOver }
          {$CODEPAGE UTF8}
Unit
          deleteOutPutImpl;

          {$mode objfpc}{$H+}
          {$ModeSwitch typehelpers}

          // not in current win laz because no PseudoTerminalDlg

Interface


Procedure
          Register;

implementation

Uses
          Classes,
          SysUtils,
          Forms,
          Dialogs,
          menuintf,
          IDECommands,
          ToolBarIntf,
          IDEWindowIntf,
          BaseDebugManager,
          Debugger,
          PseudoTerminalDlg,
          lcltype;

          {$R deleteOutPut_Images.res}

Const
          // command
          SDEL_OUTPUT                       = 'delete_output';

Resourcestring

          SDEL_OUTPT_IDEMenuCaption         = 'Ausgabe löschen';

Type

          { tHelpObj }

          tHelpObj                          = Class( tObject)

          Public

             Procedure                      delOutPt( aSender: tObject);

             Constructor                    create();
          End;


Var
          imcCmd_SELOUTPT                   : tIDEMenuCommand= Nil;

          {%H-}ho_Obj                       : tHelpObj= Nil;
          {%H+}

          {$hints off}
Procedure
          nOp( aSender : tObject);
Begin

End;

          {$hints on}

Function
          registerOneCmd( aCmdId: String; aCmdCaption: String; aObjMthd: tNotifyEvent): tIDEMenuCommand;
Var
          Key                               : tIDEShortCut;
          Cat                               : tIdeCommandCategory;
          Cmd                               : tIdeCommand;
Begin
          Result:= Nil;

          Try
             Key:= IDEShortCut( vk_unknown, []);
             Cat:= IDECommandList.FindCategoryByName( CommandCategoryToolMenuName);

             Cmd:= RegisterIDECommand( Cat, aCmdId, aCmdCaption, Key, aObjMthd, Nil);
             RegisterIDEButtonCommand( Cmd);
             Result:= RegisterIDEMenuCommand( itmSecondaryTools, aCmdId, aCmdCaption, aObjMthd, Nil, Cmd, AnsiLowerCase( aCmdId));

          Except End;
End;

Procedure
          Register;
Begin
          imcCmd_SELOUTPT    := registerOneCmd( SDEL_OUTPUT, SDEL_OUTPT_IDEMenuCaption, @ho_Obj.delOutPt);

          If Not HasConsoleSupport
             Then
             imcCmd_SELOUTPT.Enabled:= False;

End;



          { tHelpObj }

Procedure
          tHelpObj.delOutPt( aSender: tObject);
Var
          vtIWCr                            : tIDEWindowCreator;
          vtCf1                             : tCustomForm;
Begin
          nOp( aSender);

          If not assigned( IDEWindowCreators)
             Then
             Exit;

          vtIWCr:= IDEWindowCreators.FindWithName( DebugDialogNames[ tDebugDialogType.ddtPseudoTerminal]);
          If ( Nil= vtIWCr)
             Then
             showMessage( 'vtIWCr== NIL')
          Else
             Begin
                  vtCf1:= IDEWindowCreators.GetForm( vtIWCr.FormName, False, True);
                  If ( Nil= vtCf1)
                     Then
                     showMessage( 'vtCf1== Nil')
                  Else
                     Begin
                          If Not ( vtCf1 Is tPseudoConsoleDlg)
                             Then
                             showMessage( 'Not ( vtCf1 Is tPseudoConsoleDlg)')
                          Else
                             Begin
                                  tPseudoConsoleDlg( vtCf1).Clear();
                          End;
                  End;

          End;
End;


Constructor
          tHelpObj.create();
Begin
          // maybe later
End;


Initialization
Begin
          ho_Obj:= tHelpObj.Create();

End;

Finalization
Begin
          // maybe later
End;

End.

