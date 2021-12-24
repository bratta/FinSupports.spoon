# Fin Supports - A Spoon for Hammerspoon

Builds "fin style" supports for Chitubox on OS X, which are a line of
supports connected together, suitable for delicate geometries like dice.

## Usage
You will need to install [Hammerspoon](https://www.hammerspoon.org/) for OS X.

Download the latest release of this Spoon
[FOUND HERE](https://github.com/bratta/FinSupports.spoon/releases), or 
clone this repository to your `~/.hammerspoon/Spoons` directory.

Then, in your `~/.hammerspoon/init.lua`, add the following:

```
hs.loadSpoon("FinSupports")
-- Use the default keybinds:
spoon.FinSupports:bindHotkeys({})
-- OR, customize some/all of them:
spoon.FinSupports:bindHotkeys({
  startPosition  = {{"ctrl", "alt", "cmd"}, "1"},
  endPosition    = {{"ctrl", "alt", "cmd"}, "2"},
  buildFins      = {{"ctrl", "alt", "cmd"}, "3"},
  resetPositions = {{"ctrl", "alt", "cmd"}, "4"}
})
```

Next, open Chitubox and load the .STL file of your choice.

Once ready, hit the supports tab and orient the model where you want
your supports to start. Then you can hit the keystroke to set the
start position, move your mouse to where you want the line of fin
supports to end. Hit the keystroke to set the end position.

Finally, hit the keystroke for building fins and watch the supports
fly into existence.

You may need to change the value of `divisions` to build the supports
closer to each other, or farther away, depending on your needs. To do
this, add this to your `~/.hammerspoon/init.lua` after binding the hotkeys:

`spoon.FinSupports.divisions = 40`

## Compatibility Note
This was tested with Chitubox, but there's no reason it shouldn't work on
other slicers that use a left mouse click to add a support. That being said,
there is currently an issue with my favorite slicer, Lychee, that is
preventing it from placing the support. So YMMV.

## About
This project was inspired by
[FinSupport for AutoHotkey by Montahc](https://github.com/Montahc/FinSupport)

Recently I started exploring the art of creating custom resin dice
and I found that the most annoying part of the entire process is creating
the supports needed to properly print dice masters. Youtuber
[Rybonator has a great video](https://www.youtube.com/watch?v=cG1zigTs0-k)
explaining why "fin style" supports are pretty much a necessary thing.

## License

Copyright 2021 Tim Gourley

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
