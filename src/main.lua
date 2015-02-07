local Gamestate = require "lib.gamestate"
local menu = require "menu"

function love.load()
	local icon = love.image.newImageData("icon.png")
	love.window.setIcon(icon)

	Gamestate.registerEvents()
	Gamestate.switch(menu)
end
