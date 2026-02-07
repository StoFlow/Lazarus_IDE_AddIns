# Lazarus_IDE_AddIns

## Lazarus Messages Window Pal (LazMsgWndPal)

Purpose

- Is just and only to make the messages in the messages window better readable (font size)

Warnings

- Ugly hack - first backup current lazarus.exe before compiling/installing
- After an update of lazarus the hack might fail - check tMessagesCtrl(fake) then

Hints

- First shot - size of lines and font is only configurable by changing code (see folder "doc")
- Should work with a broad range of Windows and Linux Versions of Lazarus (it does for me)
- This add-in is an experimental one, it's working for me (see folder "doc")

But it still has limitations and restrictions :

- The "magic" is done by using a timer - this is always ugly :/ - would need (to know) some events 8-0
- No config dialog
  