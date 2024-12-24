-- Step 6: Add an obstacle

import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- Player
local playerStartX = 40
local playerStartY = 120
local playerVelocity = 0
local playerAcceleration = 0.2
local playerImage = gfx.image.new("images/capybara")
local playerSprite = gfx.sprite.new(playerImage)
playerSprite:setCollideRect(0, 0, 64, 48)
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

-- Game State
local gameState = "stopped"

-- Obstacle
local obstacleVelocity = 5
local obstacleImage = gfx.image.new("images/rock")
local obstacleSprite = gfx.sprite.new(obstacleImage)
obstacleSprite:setCollideRect(0, 0, 48, 48)
obstacleSprite:moveTo(450, 240)
obstacleSprite:add()

function pd.update()
    gfx.sprite.update()

    if gameState == "stopped" then
        gfx.drawTextAligned("Press A to Start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = "active"
            playerVelocity = 0
            playerSprite:moveTo(playerStartX, playerStartY)
            obstacleSprite:moveTo(450, math.random(40, 200))
        end
    elseif gameState == "active" then
        local crankPosition = pd.getCrankPosition()
        if crankPosition <= 90 or crankPosition >= 270 then
            playerVelocity -= playerAcceleration
        else
            playerVelocity += playerAcceleration
        end
        playerSprite:moveBy(0, playerVelocity)

        obstacleSprite:moveBy(-obstacleVelocity, 0)
        if obstacleSprite.x < -20 then
            obstacleSprite:moveTo(450, math.random(40, 200))
        end

        if playerSprite.y > 270 or playerSprite.y < -30 then
            gameState = "stopped"
        end
    end
end
