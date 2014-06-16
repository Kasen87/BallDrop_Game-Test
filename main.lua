-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local storyboard = require "storyboard"

-- load menu screen
storyboard.gotoScene( "scenes.menu" )

--Starting the main code
--Drawing Lines Below Here

local widget = require "widget"
local physics = require "physics"
    -- This is only included because I used the widget.newButton API for the example "undo" & "erase" buttons. It's not required for the drawing functionality.
 
math.randomseed( os.time() )
    -- This is only included to help generate truly random line colors in this example. It is not required.
 
        
-----------------------------------
-- VARIABLES & LINE TABLE (required)
-----------------------------------
local lines = {}
local line_number = 1
local line_width = 10
local prev_x, prev_y, ball
 
 
function draw_line(e)
 
  if e.phase == "began" then
    prev_x = e.x
    prev_y = e.y
 
  elseif e.phase == "moved" then
    lines[line_number] = display.newLine(prev_x, prev_y, e.x, e.y) 
    lines[line_number]:setStrokeColor(math.random(255), math.random(255), math.random(255))
    lines[line_number].strokeWidth = line_width
    dist_x = e.x - prev_x
    dist_y = e.y - prev_y
    -- Add a physics body that's a flat polygon that follows each segment of the line
    physics.addBody(lines[line_number], "static", { density = 1, friction = 0.01, bounce = 0, shape = {0, 0, dist_x, dist_y, 0, 0} } )
    prev_x = e.x
    prev_y = e.y
    line_number = line_number + 1
  elseif e.phase == "ended" then
  end
end
 
 
-----------------------------------
-- UNDO & ERASE FUNCTIONS (not required)
-----------------------------------
--[[local undo = function()
        if #lineTable>0 then
                lineTable[#lineTable]:removeSelf()
                lineTable[#lineTable]=nil
        end
        return true
end
 
local erase = function()
        for i = 1, #lineTable do
                lineTable[i]:removeSelf()
                lineTable[i] = nil
        end
        return true
end
 
 
-----------------------------------
-- UNDO & ERASE BUTTONS (not required)
-----------------------------------
local undoButton = widget.newButton{
        left = 25,
        top = display.contentHeight - 50,
        label = "Undo",
        width = 100, height = 28,
        cornerRadius = 8,
        onRelease = undo
        }
        
local eraseButton = widget.newButton{
        left = display.contentWidth-125,
        top = display.contentHeight - 50,
        label = "Erase",
        width = 100, height = 28,
        cornerRadius = 8,
        onRelease = erase
        }
 
        
-----------------------------------
-- EVENT LISTENER TO DRAW LINES (required)
-----------------------------------
--]]

        -- NOTE: I set this up as a Runtime listener, but you can certainly add the listener to display objects instead, to control where the user can touch to begin drawing.