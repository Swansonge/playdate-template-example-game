local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Player
local playerX = 40
local playerY = 120
local playerImage = gfx.image.new("images/capybara")

function pd.update()
    gfx.clear()
    local crankPosition = pd.getCrankPosition()
    if crankPosition <= 90 or crankPosition >= 270 then
        playerY -= 3
    else
        playerY += 3
    end
    playerImage:draw(playerX, playerY)
end
