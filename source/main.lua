import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd = playdate
local gfx = pd.graphics

-- Player
local playerStartX = 40
local playerStartY = 120
local playerVertSpeed = 3
local playerHorizSpeed = 3
local playerImage = gfx.image.new("images/capybara")
local playerSprite = gfx.sprite.new(playerImage)
playerSprite:setCollideRect(4, 4, 56, 40)
-- move player to position at start of game
playerSprite:moveTo(playerStartX, playerStartY)
-- add player sprite to sprite draw list 
playerSprite:add()

-- Game State
local gameState = "stopped"
local score = 0

-- Obstacle
local obstacleSpeed = 5
local obstacleImage = gfx.image.new("images/rock")
local obstacleSprite = gfx.sprite.new(obstacleImage)
obstacleSprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap
obstacleSprite:setCollideRect(0, 0, 48, 48)
obstacleSprite:moveTo(450, 240)
obstacleSprite:add()

function pd.update()
    gfx.sprite.update()

    -- start the game on player input
    if gameState == "stopped" then

        gfx.drawTextAligned("Press A to Start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = "active"

            -- reset score and speed
            score = 0
            obstacleSpeed = 5

            playerSprite:moveTo(playerStartX, playerStartY)
            obstacleSprite:moveTo(450, math.random(40, 200))
        end

    elseif gameState == "active" then

        -- crank controls vertical position
        local crankPosition = pd.getCrankPosition()
        if crankPosition <= 90 or crankPosition >= 270 then
            playerSprite:moveBy(0, -playerVertSpeed)
        else
            playerSprite:moveBy(0, playerVertSpeed)
        end
        
        -- d-pad controls horizontal position
        local rightPressed = pd.buttonIsPressed(pd.kButtonRight)
        local leftPressed = pd.buttonIsPressed(pd.kButtonLeft)
        if rightPressed then
            playerSprite:moveBy(playerHorizSpeed, 0)
        elseif leftPressed then
            playerSprite:moveBy(-playerHorizSpeed, 0)
        end

        local actualX, actualY, collisions, length =  obstacleSprite:moveWithCollisions(obstacleSprite.x - obstacleSpeed, obstacleSprite.y)
        --reset obstacle to right side (offscreen) if it goes left offscreen
        if obstacleSprite.x < -20 then
            obstacleSprite:moveTo(450, math.random(40, 200))
            score += 1
            -- make game harder as score gets higher
            obstacleSpeed += 0.2
            print(obstacleSpeed)
        end

        -- check if player moves out of bounds or collides with obstacle
        --because there is only 1 obstacle, length of collision list will be 1
        if length > 0 or playerSprite.y > 270 or playerSprite.y < -30 or playerSprite.x > 430 or playerSprite.x < -30 then
            gameState = "stopped"
        end
    end

    gfx.drawTextAligned("Score: " .. score, 390, 10, kTextAlignment.right)
end