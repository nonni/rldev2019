# r/RoguelikeDev Does The Complete Roguelike Tutorial

![RoguelikeDev Does the Complete Roguelike Tutorial Event Logo](https://i.imgur.com/3MAzEp1.png)

At [r/roguelikedev](https://www.reddit.com/r/roguelikedev/) we're doing a dev-along following [The Complete Roguelike Tutorial](http://rogueliketutorials.com/tutorials/tcod/)

# Introduction

This repository is me working my way through the Python+TCOD roguelike tutorial found [here](http://rogueliketutorials.com/) by using Lua instead of Python.
Since functional lua bindings for TCOD are not available at this time I will be using [Bearlibterminal](http://foo.wyrd.name/en:bearlibterminal) instead of TCOD for rendering and [rotLove](https://github.com/paulofmandown/rotLove) instead of TCOD for helper functions.

To view the code at the end of a particular part of the tutorial look for the commits with "Part XX - Finished" messages.

# Running

* You will need to put the BearLibTerminal [library](http://foo.wyrd.name/en:bearlibterminal#download) in the root directory. For windows that would be BearLibTerminal.dll, BearLibTerminal.so for linux and BearLibTerminal.dylib for MacOS.

* Obtain a copy of the rotlove library and put it in the lib folder.

* Start project by running >lua main.lua
