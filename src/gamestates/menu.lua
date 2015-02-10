local Gamestate = require "lib.gamestate"
local game = require "gamestates.game"

local menu = {}

local screenWidth, screenHeight

function menu:enter()
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
end

function menu:draw()
	love.graphics.setNewFont(30 * screenWidth / 800)
	love.graphics.printf("RGB - The Color Chooser", 0, screenHeight / 7, screenWidth, "center")
	love.graphics.setNewFont(16 * screenWidth / 800)
	love.graphics.printf("1. Left click to cycle red.\n2. Middle click or scroll to cycle green.\n3. Right click to cycle blue.", 0, screenHeight / 3, screenWidth, "center")
	love.graphics.printf("Your goal is to get every panel that is not black to be the same color.", 0, screenHeight / 1.75, screenWidth, "center")
	love.graphics.printf("Click to begin.", 0, screenHeight / 1.3, screenWidth, "center")
	love.graphics.setNewFont(12 * screenWidth / 800)
	love.graphics.printf("(Esc exits the game.)", 0, screenHeight - 20 * screenHeight / 400, screenWidth, "center")
end

function menu:mousepressed(x, y, button)
	if button == "l" then
		-- TODO replace constructed settings object with actual loaded settings
		Gamestate.switch(game, {boxSize = 20, colorStep = 80, timeLimit = 10})
	end
end

function menu:keypressed(key, unicode)
	if key == "escape" then
		love.event.quit()
	end
end

return menu
