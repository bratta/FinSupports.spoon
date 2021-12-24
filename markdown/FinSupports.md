# [docs](index.md) » FinSupports
---

Fin Supports - A Spoon for Hammerspoon
Builds "fin style" supports for Chitubox on OS X, which are a line of
supports connected together, suitable for delicate geometries like dice.

## Usage
In your `~/.hammerspoon/init.lua`, add the following:

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

## API Overview
* Variables - Configurable values
 * [defaultMappings](#defaultMappings)
 * [divisions](#divisions)
 * [logger](#logger)
 * [pos1](#pos1)
 * [pos2](#pos2)
* Methods - API calls which can only be made on an object returned by a constructor
 * [bindHotkeys](#bindHotkeys)
 * [buildFins](#buildFins)
 * [endPosition](#endPosition)
 * [init](#init)
 * [initializePositions](#initializePositions)
 * [resetPositions](#resetPositions)
 * [startPosition](#startPosition)

## API Documentation

### Variables

| [defaultMappings](#defaultMappings)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports.defaultMappings`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | Default hot keys used when setting positions or generating the clicks                                                                     |
| **Notes**                                   | <ul><li> Defaults:</li><li>     ```</li><li>     obj.defaultMappings = {</li><li>       startPosition  = {{"ctrl", "alt", "cmd"}, "1"},</li><li>       endPosition    = {{"ctrl", "alt", "cmd"}, "2"},</li><li>       buildFins      = {{"ctrl", "alt", "cmd"}, "3"},</li><li>       resetPositions = {{"ctrl", "alt", "cmd"}, "4"}</li><li>     }</li><li>     ```</li></ul>                |

| [divisions](#divisions)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports.divisions`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | How often will clicks occur between points.                                                                     |
| **Notes**                                   | <ul><li> Defaults: `80`</li><li> The larger the number, the closer together the supports will be.</li></ul>                |

| [logger](#logger)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports.logger`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | Logger object for this Spoon.                                                                     |

| [pos1](#pos1)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports.pos1`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | The starting position                                                                     |

| [pos2](#pos2)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports.pos2`                                                                    |
| **Type**                                    | Variable                                                                     |
| **Description**                             | The ending position                                                                     |

### Methods

| [bindHotkeys](#bindHotkeys)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports:bindHotkeys(mapping)`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Binds keyboard shortcuts to the proper functions                                                                     |
| **Parameters**                              | <ul><li>mapping - The keyboard mappings you wish to use</li></ul> |
| **Returns**                                 | <ul></ul>          |
| **Notes**                                   | <ul><li>  Defaults:</li><li>     ```</li><li>     mappings = {</li><li>       startPosition = {{"ctrl", "alt", "cmd"}, "1"},</li><li>       endPosition = {{"ctrl", "alt", "cmd"}, "2"},</li><li>       buildFins = {{"ctrl", "alt", "cmd"}, "3"},</li><li>       resetPositions = {{"ctrl", "alt", "cmd"}, "4"}</li><li>     }</li><li>     ```</li></ul>                |

| [buildFins](#buildFins)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports:buildFins()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Build the fin supports                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul></ul>          |
| **Notes**                                   | <ul><li>  If a start and end position are set, it will navigate</li><li>  between the two spots and click at a regular interval (based on</li><li>  the `divisions` variable). In a slicer program like Chitubox, this</li><li>  will add a support each time it clicks, as long as you are in the</li><li>  proper mode for adding supports to your model.</li></ul>                |

| [endPosition](#endPosition)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports:endPosition()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Sets the end position for the fin supports.                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul></ul>          |
| **Notes**                                   | <ul><li>Based on the mouse pointer's current location.</li></ul>                |

| [init](#init)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports:init()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Sets the default start and end position                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul><li> FinSupports object instance</li></ul>          |
| **Notes**                                   | <ul></ul>                |

| [initializePositions](#initializePositions)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports:initializePositions`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Reset the start/ending positions to (0,0)                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul></ul>          |
| **Notes**                                   | <ul></ul>                |

| [resetPositions](#resetPositions)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports:resetPositions()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Resets (i.e. forgets) the positions saved.                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul></ul>          |
| **Notes**                                   | <ul></ul>                |

| [startPosition](#startPosition)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `FinSupports:startPosition()`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Sets the starting position for the fin supports.                                                                     |
| **Parameters**                              | <ul><li>None</li></ul> |
| **Returns**                                 | <ul></ul>          |
| **Notes**                                   | <ul><li>Based on the mouse pointer's current location.</li></ul>                |

