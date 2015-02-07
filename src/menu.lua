local Gamestate = require "lib.gamestate"
local game = require "game"

local menu = {}

function menu:draw()
	love.graphics.setNewFont(30)
	love.graphics.printf("RGB - The Color Chooser", 0, 100, 800, "center")
	love.graphics.setNewFont(16)
	love.graphics.printf("1. Left click to cycle red.\n2. Middle click or scroll to cycle green.\n3. Right click to cycle blue.", 0, 200, 800, "center")
	love.graphics.printf("Your goal is to get every panel that is not black to be the same color.", 0, 300, 800, "center")
	love.graphics.printf("Click to begin.", 0, 350, 800, "center")
	love.graphics.setNewFont(12)
	love.graphics.printf("(Esc exits the game.)", 0, 440, 800, "center")
end

function menu:mousepressed(x, y, button)
	if button == "l" then
		Gamestate.switch(game)
	end
end

function menu:keypressed(key, unicode)
	if key == "escape" then
		love.event.quit()
	end
end

return menu
