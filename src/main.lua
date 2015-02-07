local Gamestate = require "lib.gamestate"
local menu = require "menu"

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(menu)
end
