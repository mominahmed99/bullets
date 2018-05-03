-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- created by Momin Ahmed
-- created on April 2018
--
-- when you click on one of the arrows the object will move, the red button lets the 
-- character jump
-----------------------------------------------------------------------------------------
--
local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 )
physics.setDrawMode( "hybrid" )  

local playerBullets = {} 

local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
 leftWall.strokeWidth = 3
 leftWall:setFillColor( 0.5 )
 leftWall:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 0.0
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround = display.newImage( "./assets/sprites/land.png" )
theGround.x = 1500 
theGround.y = 500 
theGround.id = "the ground"
physics.addBody( theGround, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theuperGround = display.newImage( "./assets/sprites/land.png" )
theuperGround.x = 800 
theuperGround.y =  1300 
theuperGround.id = "the uperground"
physics.addBody( theuperGround, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local landSquare = display.newImage( "./assets/sprites/landSquare.png" )
landSquare.x = 1520
landSquare.y = display.contentHeight - 1000
landSquare.id = "land Square"
physics.addBody( landSquare, "dynamic", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local dPad = display.newImage( "./assets/sprites/d-pad.png" )
dPad.x = 150
dPad.y = display.contentHeight - 200
dPad.id = "d-pad"

local upArrow = display.newImage( "./assets/sprites/upArrow.png" )
upArrow.x = 150
upArrow.y = display.contentHeight - 310
upArrow.id = "up arrow"

local theCharacter = display.newImage( "./assets/sprites/bird.png" )
theCharacter.x = display.contentCenterX 
theCharacter.y = 200
theCharacter.id = "the character"
physics.addBody( theCharacter, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3
    } )
theCharacter.isFixedRotation = true

local downArrow = display.newImage( "./assets/sprites/downArrow.png" )
downArrow.x = 150
downArrow.y = display.contentHeight - 88
downArrow.id = "down arrow"

local rightArrow = display.newImage( "./assets/sprites/rightArrow.png" )
rightArrow.x = 260
rightArrow.y = display.contentHeight - 198
rightArrow.id = "right arrow"

local leftArrow = display.newImage( "./assets/sprites/leftArrow.png" )
leftArrow.x = 40
leftArrow.y = display.contentHeight - 198
leftArrow.id = "left arrow"

local jumpButton = display.newImage( "./assets/sprites/jumpButton.png" )
jumpButton.x = display.contentWidth - 80
jumpButton.y = display.contentHeight - 80
jumpButton.id = "jump button"
jumpButton.alpha = 0.5

local shootButton = display.newImage( "./assets/sprites/jumpButton.png" )
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5

local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

function checkPlayerBulletsOutOfBounds()
	-- check if any bullets have gone off the screen
	local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end
 
function upArrow:touch( event )
    if ( event.phase == "ended" ) then
        transition.moveBy( theCharacter, { 
        	x = 0, 
        	y = -50, 
        	time = 100 
        	} )
    end

    return true
end

function downArrow:touch( event )
    if ( event.phase == "ended" ) then
        transition.moveBy( theCharacter, { 
        	x = 0,  
        	y = 50, 
        	time = 100 
        	} )
    end

    return true
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = 50,  
        	y = 0,
        	time = 100
        	} )
    end

    return true
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        transition.moveBy( theCharacter, { 
        	x = -50,  
        	y = 0, 
        	time = 100 
        	} )
    end

    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        theCharacter:setLinearVelocity( 0, -750 )
    end

    return true
end

function checkCharacterPosition( event )
    if theCharacter.y > display.contentHeight + 500 then
        theCharacter.x = display.contentCenterX - 200
        theCharacter.y = display.contentCenterY
    end
end

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleBullet = display.newImage( "./assets/sprites/Kunai.png" )
        aSingleBullet.x = theCharacter.x
        aSingleBullet.y = theCharacter.y
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.gravityScale = 0
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( 1500, 0 )

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if theCharacter.y > display.contentHeight + 500 then
        theCharacter.x = display.contentCenterX - 200
        theCharacter.y = display.contentCenterY
    end
end


upArrow:addEventListener( "touch", upArrow )

downArrow:addEventListener( "touch", downArrow )

rightArrow:addEventListener( "touch", rightArrow )

leftArrow:addEventListener( "touch", leftArrow )

jumpButton:addEventListener( "touch", jumpButton )

Runtime:addEventListener( "enterFrame", checkCharacterPosition )

Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )

shootButton:addEventListener( "touch", shootButton )