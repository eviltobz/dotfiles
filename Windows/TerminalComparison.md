*ConEmu*

- Quick cursor motions on the commandline (scroll history, edit line) sometimes throw out command codes instead  [A [D or some such. Doesn't seem to happen in raw powershell, does in nix & powershells hosted therein.
- Can go borky when terminal sizes change, notably when connecting to a different tmux session from a differently, previously sized terminal (see windows term not allowing you to interact when reconnecting!)


*ConsoleZ*

- Doesn't like CTRL key for tmux prefix - this is a keyboard binding thing that needs deconfiguring, so not that bad.
- Doesn't seem to want to draw a tmux session to the full screen. This is that bad.



*Windows Terminal*

- Reconnecting to a running tmux session - shows what was on the screen, you can move around panes, but doesn't let you interact!
