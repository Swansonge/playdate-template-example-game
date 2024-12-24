-- Step 3: Turn player into a sprite

import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- Player
local playerStartX = 40
local playerStartY = 120
local playerImage = gfx.image.new("images/capybara")
local playerSprite = gfx.sprite.new(playerImage)
playerSprite:setCollideRect(0, 0, 32, 24)
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

function pd.update()
    gfx.sprite.update()

    local crankPosition = pd.getCrankPosition()
    if crankPosition <= 90 or crankPosition >= 270 then
        playerSprite:moveBy(0, -3)
    else
        playerSprite:moveBy(0, 3)
    end
end
