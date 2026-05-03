# Lazarus_IDE_AddIns

## Lazarus for Windows Colored Editor Tabs (LazWinColEdTabs)

Hints

- This versions addresses the moving of "IDEEditorOptions" from IDEOptEditorIntf to EditorOptionsIntf
- Pls. use a recent version of lazarus or use fpc-deluxe from <https://github.com/LongDirtyAnimAlf/fpcupdeluxe/releases>

This add-in is an experimental one, it's working for me (see folder "doc").

- If you miss the coolbar buttons as shown in the video(s), then goto Tools->Options->Environment->IDE Coolbar and configure your buttons.

But it still has limitations and restrictions :

- The "magic" is done by using a timer - this is always ugly :/ - would need (to know) some events 8-0
- After changing of config, the look might by not perfect - just size the editor window then once
  