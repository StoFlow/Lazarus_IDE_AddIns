# Lazarus_IDE_AddIns

## Lazarus for Windows Colored Editor Tabs (LazWinColEdTabs)

This add-in is an experimental one, it's working for me (see folder "doc").
But it still has limitations and restrictions :

- ~~No multi-editor-window support~~
- ~~Only manual reinitialization support (via Tools-command)~~
- ~~Tabs on left or on right are not being displayed correctly~~
- Font, dimensions and colors must be changed using customized XML-files (no UI to change)
- ~~Changing settings for the pages in tools-options requires restarting of lazarus~~
- ~~Changing settings for the pages in tools-options may also lead to unexpected behavior~~
- ~~Manual reinitialization required after loading another project~~
- The "magic" is done by using a timer - this is always ugly :/ - would need (to know) some events 8-0
