*ConEmu*
*Version: 200713 preview - 07/2020
- Resizing a window doesn't reflow content already in it very well - going smaller will wrap long lines, but not with the line after it, going wider will unwrap them, up to the point that they were originally written, but won't flow the longer lines that were initially broken.
- It won't use a symlinked config file any more. So I can't keep it nicely source controlled! THIS SUCKS!!!

*ConsoleZ*
*Version: 1.19.0.19104 - 07/2020
- Resizing a window doesn't reflow content already in it very well - going smaller will wrap long lines, but not with the line after it, going wider will unwrap them, up to the point that they were originally written, but won't flow the longer lines that were initially broken.

*Windows Terminal - Not currently available with current windows build & store access policies*
*<version>



Note: All mentions below were from some indeterminate version back from when I was at 15below. And the versions could have already been old & out of date when I was checking them, as I didn't tend to update conemu & consolez (windows terminal had self-updating from the store)
*ConEmu*

- Quick cursor motions on the commandline (scroll history, edit line) sometimes throw out command codes instead  [A [D or some such. Doesn't seem to happen in raw powershell, does in nix & powershells hosted therein.
- Can go borky when terminal sizes change, notably when connecting to a different tmux session from a differently, previously sized terminal (see windows term not allowing you to interact when reconnecting!)


*ConsoleZ*

- Doesn't like CTRL key for tmux prefix - this is a keyboard binding thing that needs deconfiguring, so not that bad.
- Doesn't seem to want to draw a tmux session to the full screen. This is that bad.



*Windows Terminal*

- Reconnecting to a running tmux session - shows what was on the screen, you can move around panes, but doesn't let you interact!
