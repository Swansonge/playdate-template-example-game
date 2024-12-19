import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Player
local playerVelocity = 3
local playerImage = gfx.image.new("images/capybara")
local playerSprite = gfx.sprite.new(playerImage)
playerSprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap
playerSprite:setCollideRect(0, 0, playerSprite:getSize())
playerSprite:moveTo(200, 120)
playerSprite:add()

-- Game State
local GAME_STATE = {
    STOPPED = 1,
    ACTIVE = 2
}

local gameState = GAME_STATE.STOPPED
local pickupCount = 0
local gameTime = 5 * 1000
local gameTimer

-- Pickup
local TAGS = {
    PICKUP = 1
}

local pickupImage = gfx.image.new("images/grass")
local function spawnPickup()
    local minX, maxX = 0, 400
    local minY, maxY = 0, 240
    local pickupSprite = gfx.sprite.new(pickupImage)
    pickupSprite:setTag(TAGS.PICKUP)
    pickupSprite:setCollideRect(0, 0, pickupSprite:getSize())
    pickupSprite:moveTo(math.random(minX, maxX), math.random(minY, maxY))
    pickupSprite:add()
end

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()

    if gameState == GAME_STATE.STOPPED then
        gfx.drawTextAligned("Press A to Start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gfx.sprite.removeAll()
            playerSprite:moveTo(200, 120)
            playerSprite:add()
            gameTimer = pd.timer.new(gameTime, gameTime / 1000, 0)
            gameTimer.timerEndedCallback = function()
                gameState = GAME_STATE.STOPPED
            end
            pickupCount = 0
            gameState = GAME_STATE.ACTIVE
            spawnPickup()
        end
    elseif gameState == GAME_STATE.ACTIVE then
        local crankPosition = pd.getCrankPosition() - 90
        local xVelocity = math.cos(math.rad(crankPosition)) * playerVelocity
        local yVelocity = math.sin(math.rad(crankPosition)) * playerVelocity
        local targetX = playerSprite.x + xVelocity
        local targetY = playerSprite.y + yVelocity

        if xVelocity < 0 then
            playerSprite:setImageFlip(gfx.kImageFlippedX)
        elseif xVelocity > 0 then
            playerSprite:setImageFlip(gfx.kImageUnflipped)
        end

        local actualX, actualY, collisions, len = playerSprite:moveWithCollisions(targetX, targetY)
        for i=1, len do
            local collision = collisions[i]
            local collidedSprite = collision.other
            if collidedSprite:getTag() == TAGS.PICKUP then
                pickupCount += 1
                collidedSprite:remove()
                spawnPickup()
            end
        end

        gfx.drawTextAligned("Time: " .. math.ceil(gameTimer.value), 396, 4, kTextAlignment.right)
    end

    gfx.drawText("Score: " .. pickupCount, 4, 4)
end
