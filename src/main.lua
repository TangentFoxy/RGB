Gamestate = require "lib.gamestate"
Gamejolt = require "gamejolt"

local menu = require "menu"

function love.load()
	local icon = love.image.newImageData("icon.png")
	love.window.setIcon(icon)

	-- load settings and change if needed
	--love.window.setMode(800, 460, {borderless = true}) --temporary

	Gamestate.registerEvents()
	Gamestate.switch(menu)
end
