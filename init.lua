--- === FinSupports ===
---
--- Fin Supports - A Spoon for Hammerspoon
--- Builds "fin style" supports for Chitubox on OS X, which are a line of
--- supports connected together, suitable for delicate geometries like dice.
---
--- ## Usage
--- In your `~/.hammerspoon/init.lua`, add the following:
---
--- ```
--- hs.loadSpoon("FinSupports")
--- -- Use the default keybinds:
--- spoon.FinSupports:bindHotkeys({})
--- -- OR, customize some/all of them:
--- spoon.FinSupports:bindHotkeys({
---   startPosition  = {{"ctrl", "alt", "cmd"}, "1"},
---   endPosition    = {{"ctrl", "alt", "cmd"}, "2"},
---   buildFins      = {{"ctrl", "alt", "cmd"}, "3"},
---   resetPositions = {{"ctrl", "alt", "cmd"}, "4"}
--- })
--- ```
---
--- Next, open Chitubox and load the .STL file of your choice.
---
--- Once ready, hit the supports tab and orient the model where you want
--- your supports to start. Then you can hit the keystroke to set the
--- start position, move your mouse to where you want the line of fin
--- supports to end. Hit the keystroke to set the end position.
---
--- Finally, hit the keystroke for building fins and watch the supports
--- fly into existence.
---
--- You may need to change the value of `divisions` to build the supports
--- closer to each other, or farther away, depending on your needs. To do
--- this, add this to your `~/.hammerspoon/init.lua` after binding the hotkeys:
---
--- `spoon.FinSupports.divisions = 40`
---
--- ## Compatibility Note
--- This was tested with Chitubox, but there's no reason it shouldn't work on
--- other slicers that use a left mouse click to add a support. That being said,
--- there is currently an issue with my favorite slicer, Lychee, that is
--- preventing it from placing the support. So YMMV.
---
--- ## About
--- This project was inspired by
--- [FinSupport for AutoHotkey by Montahc](https://github.com/Montahc/FinSupport)
---
--- Recently I started exploring the art of creating custom resin dice
--- and I found that the most annoying part of the entire process is creating
--- the supports needed to properly print dice masters. Youtuber
--- [Rybonator has a great video](https://www.youtube.com/watch?v=cG1zigTs0-k)
--- explaining why "fin style" supports are pretty much a necessary thing.
---
--- ## License
---
--- Copyright 2021 Tim Gourley
--- 
--- Permission is hereby granted, free of charge, to any person obtaining a copy
--- of this software and associated documentation files (the "Software"), to
--- deal in the Software without restriction, including without limitation the
--- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
--- sell copies of the Software, and to permit persons to whom the Software is
--- furnished to do so, subject to the following conditions:
--- 
--- The above copyright notice and this permission notice shall be included in
--- all copies or substantial portions of the Software.
--- 
--- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
--- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
--- DEALINGS IN THE SOFTWARE.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "FinSupports"
obj.version = "1.0.0"
obj.author = "Tim Gourley <tgourley@gmail.com>"
obj.homepage = "https://github.com/bratta/FinSupports"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- FinSupports.defaultMappings
--- Variable
--- Default hot keys used when setting positions or generating the clicks
---
--- Notes:
---   * Defaults:
---      ```
---      obj.defaultMappings = {
---        startPosition  = {{"ctrl", "alt", "cmd"}, "1"},
---        endPosition    = {{"ctrl", "alt", "cmd"}, "2"},
---        buildFins      = {{"ctrl", "alt", "cmd"}, "3"},
---        resetPositions = {{"ctrl", "alt", "cmd"}, "4"}
---      }
---      ```
obj.defaultMappings = {
  startPosition  = {{"ctrl", "alt", "cmd"}, "1"},
  endPosition    = {{"ctrl", "alt", "cmd"}, "2"},
  buildFins      = {{"ctrl", "alt", "cmd"}, "3"},
  resetPositions = {{"ctrl", "alt", "cmd"}, "4"}
}

--- FinSupports.divisions
--- Variable
--- How often will clicks occur between points.
---
--- Notes:
---   * Defaults: `80`
---   * The larger the number, the closer together the supports will be.
obj.divisions = 80

--- FinSupports.logger
--- Variable
--- Logger object for this Spoon.
obj.logger = hs.logger.new('FinSupports')

--- FinSupports.pos1
--- Variable
--- The starting position
obj.pos1 = {0, 0}

--- FinSupports.pos2
--- Variable
--- The ending position
obj.pos2 = {0, 0}

-- ############################################################################
-- Private functions
-- ############################################################################

-- Documenting these similarly to public methods, but with only two --'s
-- to remain internal to the class

-- FinSupports:notify(msg)
-- Method
-- Wrapper method around sending a system-level notification.
--
-- Parameters:
--   * msg - string message to display
--
-- Notes:
--   * You will need to allow notification access to Hammerspoon.
local function notify(msg)
  hs.notify.new({title="Fin Supports", informativeText=msg}):send()
end

-- FinSupports:round(x)
-- Method
-- A naive implementation of rounding a number.
--
-- Parameters:
--   * x - any number, eg. 1.2
--
-- Returns:
--   * An integer, rounded from the input. eg. 1
local function round(x)
  if (x == nil) then
    return 0
  end
  return x >= 0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

-- FinSupports:positionTuple(pos)
-- Method
-- Given a "tuple" table with two elements, return a string (x,y)
--
-- Parameters:
--   * pos - position variable, a table with two numeric values. eg. `{1,2}`
--
-- Returns:
--   * string formatted like (1,2)
local function positionTuple(pos)
  return "(" .. round(pos[0]) .. ", " .. round(pos[1]) .. ")"
end

-- FinSupports:setPosition(pos, title)
-- Method
-- Sets the supplied position to the current mouse location
--
-- Parameters:
--   * pos - the position variable
--   * title - title text to use in the notification (eg. "Start")
local function setPosition(pos, title)
  mousepoint = hs.mouse.absolutePosition()
  pos[0]=mousepoint.x
  pos[1]=mousepoint.y
  notify("" .. title .. " position set to " .. positionTuple(pos))
end

-- FinSupports:is_table_equal(t1, t2, ignore_mt)
-- Method
-- Compares two tables to see if they are equal.
--
-- Parameters:
--   * t1 - table object
--   * t2 - table object
--   * ignore_mt - Ignores comparison based on metamethod __eq if present
--
-- Returns:
--   * true if tables are equal, false otherwise
--
-- Notes:
--   * From: https://stackoverflow.com/questions/20325332/how-to-check-if-two-tablesobjects-have-the-same-value-in-lua
local function is_table_equal(t1, t2, ignore_mt)
  local ty1 = type(t1)
  local ty2 = type(t2)
  if ty1 ~= ty2 then return false end
  -- non-table types can be directly compared
  if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
  -- as well as tables which have the metamethod __eq
  local mt = getmetatable(t1)
  if not ignore_mt and mt and mt.__eq then return t1 == t2 end
  for k1,v1 in pairs(t1) do
     local v2 = t2[k1]
     if v2 == nil or not is_table_equal(v1,v2) then return false end
  end
  for k2,v2 in pairs(t2) do
     local v1 = t1[k2]
     if v1 == nil or not is_table_equal(v1,v2) then return false end
  end
  return true
end

-- FinSupports:isPositionEmpty(pos)
-- Method
-- Check a position variable is the default value, i.e. `{0,0}`
--
-- Parameters:
--   * pos - a table with two numeric elements
--
-- Returns:
--   * true if `{0,0}`, or false otherwise
local function isPositionEmpty(pos)
  if (is_table_equal(pos, {0, 0})) then
    return true
  else
    return false
  end
end

-- FinSupports:copy(obj, seen)
-- Method
-- Naive deep copy of a table
--
-- Parameters:
--   * obj - object to copy
--   * seen - parameter for this method to track recursive progress 
--
-- Returns:
--   * A copy of the table
local function copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
  
    local s = seen or {}
    local res = {}
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return setmetatable(res, getmetatable(obj))
end

-- FinSupports:merge(t1, t2)
-- Method
-- Naive merging of two table objects in a non-destructive manner.
--
-- Parameters:
--   * t1 - table object containing the source data
--   * t2 - table object containing the extra data
--
-- Returns:
--   * The merged table
--
-- Notes:
--   Overwrites any values of t1 with the contents of t2 and returns
--   the new table.
local function merge(t1, t2)
  local results = copy(t1)
  for k,v in pairs(t2) do results[k] = v end
  return results
end

-- ############################################################################
-- Public functions
-- ############################################################################

--- FinSupports:initializePositions
--- Method
--- Reset the start/ending positions to (0,0)
---
--- Parameters:
---  * None
function obj:initializePositions()
  self.pos1={0, 0}
  self.pos2={0, 0}
end

--- FinSupports:startPosition()
--- Method
--- Sets the starting position for the fin supports.
---
--- Parameters:
---  * None
---
--- Notes:
---  * Based on the mouse pointer's current location.
function obj:startPosition()
  setPosition(self.pos1, "First")
end

--- FinSupports:endPosition()
--- Method
--- Sets the end position for the fin supports.
---
--- Parameters:
---  * None
---
--- Notes:
---  * Based on the mouse pointer's current location.
function obj:endPosition()
  setPosition(self.pos2, "Second")
end

--- FinSupports:resetPositions()
--- Method
--- Resets (i.e. forgets) the positions saved.
---
--- Parameters:
---  * None
function obj:resetPositions()
  self:initializePositions()
  notify("Positions reset")
end

--- FinSupports:buildFins()
--- Method
--- Build the fin supports
---
--- Parameters:
---  * None
---
--- Notes:
---   If a start and end position are set, it will navigate
---   between the two spots and click at a regular interval (based on
---   the `divisions` variable). In a slicer program like Chitubox, this
---   will add a support each time it clicks, as long as you are in the
---   proper mode for adding supports to your model.
function obj:buildFins()
  if (isPositionEmpty(self.pos1) and isPositionEmpty(self.pos2)) then
    notify("Please set both start and end positions.")
  elseif (is_table_equal(self.pos1, self.pos2)) then
    notify("Start and end locations are the same.")
  else
    local focusedWindow = hs.window.focusedWindow()
    local currentx = self.pos1[0]
    local currenty = self.pos1[1]
    local incx = (self.pos2[0] - self.pos1[0]) / self.divisions
    local incy = (self.pos2[1] - self.pos1[1]) / self.divisions
    local i = 0
    while (i < self.divisions) do
      currentx = currentx + incx
      currenty = currenty + incy
      local newPoint = hs.geometry.point(currentx, currenty)
      hs.mouse.absolutePosition(newPoint)
      hs.eventtap.leftClick(newPoint)
      i = i + 1
    end
  end 
end

--- FinSupports:init()
--- Method
--- Sets the default start and end position
---
--- Parameters:
---  * None
---
--- Returns:
---   * FinSupports object instance
function obj:init()
  self:initializePositions()
  return self
end

--- FinSupports:bindHotkeys(mapping)
--- Method
--- Binds keyboard shortcuts to the proper functions
---
--- Parameters:
---  * mapping - The keyboard mappings you wish to use
---
--- Notes:
---   Defaults:
---      ```
---      mappings = {
---        startPosition = {{"ctrl", "alt", "cmd"}, "1"},
---        endPosition = {{"ctrl", "alt", "cmd"}, "2"},
---        buildFins = {{"ctrl", "alt", "cmd"}, "3"},
---        resetPositions = {{"ctrl", "alt", "cmd"}, "4"}
---      }
---      ```
function obj:bindHotkeys(mapping)
  local spec = {
    startPosition = hs.fnutils.partial(self.startPosition, self),
    endPosition = hs.fnutils.partial(self.endPosition, self),
    buildFins = hs.fnutils.partial(self.buildFins, self),
    resetPositions = hs.fnutils.partial(self.resetPositions, self)
  }
  if (mapping == nil) then mapping = {} end
  local finalMapping = merge(self.defaultMappings, mapping)
  hs.spoons.bindHotkeysToSpec(spec, finalMapping)
  return self
end

-- ############################################################################
-- Show me the object instance!
-- ############################################################################
return obj