import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Player
local playerStartX = 40
local playerStartY = 120
local playerVelocity = 0
local playerAcceleration = 0.4
local playerImage = gfx.image.new("images/capybara")
local playerSprite = gfx.sprite.new(playerImage)
playerSprite:setCollideRect(0, 0, 32, 24)
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

-- Game State
local GAME_STATE = {
    STOPPED = 1,
    ACTIVE = 2
}

local gameState = GAME_STATE.STOPPED
local score = 0

-- Obstacle
local obstacleVelocity = 5
local obstacleImage = gfx.image.new(20, 40, gfx.kColorBlack)
local obstacleSprite = gfx.sprite.new(obstacleImage)
obstacleSprite:moveTo(450, 120)
obstacleSprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap
obstacleSprite:setCollideRect(0, 0, 20, 40)
obstacleSprite:add()

function pd.update()
    gfx.sprite.update()

    if gameState == GAME_STATE.STOPPED then
        gfx.drawTextAligned("Press A to Start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = GAME_STATE.ACTIVE
            score = 0
            playerVelocity = 0
            obstacleVelocity = 5
            playerSprite:moveTo(playerStartX, playerStartY)
            obstacleSprite:moveTo(450, math.random(40, 200))
        end
    elseif gameState == GAME_STATE.ACTIVE then
        local crankPosition = pd.getCrankPosition()
        if crankPosition <= 90 or crankPosition >= 270 then
            playerVelocity -= playerAcceleration
        else
            playerVelocity += playerAcceleration
        end
        playerSprite:moveBy(0, playerVelocity)

        local actualX, actualY, collisions, length = obstacleSprite:moveWithCollisions(obstacleSprite.x - obstacleVelocity, obstacleSprite.y)
        if length > 0 or playerSprite.y > 290 or playerSprite.y < -50 then
            gameState = GAME_STATE.STOPPED
        elseif actualX < -20 then
            obstacleSprite:moveTo(450, math.random(40, 200))
            score += 1
            obstacleVelocity += 0.2
        end
    end

    gfx.drawTextAligned("Score: " .. score, 390, 10, kTextAlignment.right)
end
