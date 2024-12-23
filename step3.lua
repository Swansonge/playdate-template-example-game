import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Player
local playerStartX = 40
local playerStartY = 120
local playerImage = gfx.image.new("images/capybara")
local playerSprite = gfx.sprite.new(playerImage)
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

function pd.update()
    gfx.sprite.update()
end