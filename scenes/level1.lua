-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" );
local scene = storyboard.newScene();

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause();

--------------------------------------------

-- forward declarations and other locals
local HEIGHT = display.actualContentHeight;
local WIDTH = display.actualContentWidth;
print(HEIGHT);
print(WIDTH);
local screenW, screenH, cntX, cntY = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5;
print(screenH);
print(screenW);
-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )

	local group = self.view;

	-- create a grey rectangle as the backdrop
	local background = display.newRect( 0, 0, screenW, screenH );
	background.anchorX = 0;
	background.anchorY = 0;
	background:setFillColor( .5 );

	local leftBounds = display.newRect( -10, cntY , 5, screenH);
	leftBounds:setFillColor(.5, .9, .4);
	physics.addBody( leftBounds, "static", { friction=0.3});

	local rightBounds = display.newRect( screenW + 10, cntY , 5, screenH);
	rightBounds:setFillColor(.5, .9, .4);
	physics.addBody( rightBounds, "static", { friction=0.3});


	
	-- make a crate (off-screen), position it, and rotate slightly
	local ball = display.newCircle( 0, 0, 20 );
	ball.x, ball.y = screenW - 20, -50;
	ball.rotation = 15;
	ball:setFillColor( .5, .3, .8 );
	
	-- add physics to the crate
	physics.addBody( ball, { density=2.0, friction=0.1, bounce=0.2 } );
	
	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "grass.png", screenW, 82 );
	grass.anchorX = 0;
	grass.anchorY = 1;
	grass.x, grass.y = 0, display.contentHeight;
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -cntX,-34, cntX,-34, cntX,34, -cntX,34 };
	physics.addBody( grass, "static", { friction=0.1, shape=grassShape } );
	
	-- all display objects must be inserted into group
	group:insert( background );
	group:insert( grass);
	group:insert( ball );
	group:insert( leftBounds );
	group:insert( rightBounds );


end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	physics.start()
	Runtime:addEventListener("touch", draw_line);
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end


-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene );

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene );

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene );

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene );



-----------------------------------------------------------------------------------------

return scene