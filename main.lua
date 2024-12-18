import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local TAGS = {
    PICKUP = 1
}

local GAME_STATE = {
    STOPPED = 1,
    ACTIVE = 2
}
local gameState = GAME_STATE.STOPPED

local playerVelocity = 3
local playerImage = gfx.image.new(32, 32, gfx.kColorBlack)
local playerSprite = gfx.sprite.new(playerImage)
playerSprite:setCollideRect(0, 0, playerSprite:getSize())
playerSprite:moveTo(200, 120)
playerSprite:add()

local minX, maxX = 0, 400
local minY, maxY = 0, 240

local function checkBoundary()
    if playerSprite.x < minX then
        playerSprite:moveTo(minX, playerSprite.y)
    elseif playerSprite.x > maxX then
        playerSprite:moveTo(maxX, playerSprite.y)
    end
    if playerSprite.y < minY then
        playerSprite:moveTo(playerSprite.x, minY)
    elseif playerSprite.y > maxY then
        playerSprite:moveTo(playerSprite.x, maxY)
    end
end

local pickupImage = gfx.image.new(16, 16)
gfx.pushContext(pickupImage)
    gfx.setColor(gfx.kColorBlack)
    gfx.drawCircleInRect(0, 0, pickupImage:getSize())
gfx.popContext()

local function spawnPickup()
    local pickupSprite = gfx.sprite.new(pickupImage)
    pickupSprite:setTag(TAGS.PICKUP)
    pickupSprite:setCollideRect(0, 0, pickupSprite:getSize())
    pickupSprite:moveTo(math.random(minX, maxX), math.random(minY, maxY))
    pickupSprite:add()
end

local pickupCount = 0
local gameTime = 10 * 1000
local gameTimer = nil

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
        local actualX, actualY, collisions, len = playerSprite:moveWithCollisions(targetX, targetY)
        checkBoundary()
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
