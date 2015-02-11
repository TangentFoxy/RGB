local input = require "util.input"
local inifile = require "lib.inifile"
local ser = require "lib.ser"

local Gamestate = require "lib.gamestate"
local game = require "gamestates.game"

local menu = {}

local screenWidth, screenHeight
local settings, controls

function menu:init()
	log("Initializing menu...")
	-- load or create settings
	if love.filesystem.isFile("settings.ini") then
		log("Loading settings (again)...")
		settings = inifile.parse("settings.ini")
	else
		log("Creating settings...")
		settings = {
			display = {
				width = love.graphics.getWidth(),
				height = love.graphics.getHeight(),
				fullscreen = false,
				borderless = true,
			},
			gamejolt = {
				username = false,
				usertoken = false
			},
			sound = {
				music = 0,
				sfx = 0
			},
			difficulty = {
				preset = "normal",
				timeLimit = 60,
				colorStep = 80,
				boxSize = 20
			}
		}
	end
	-- load or create controls
	if love.filesystem.isFile("controls.lua") then
		log("Loading controls...")
		controls = require "controls"
	else
		log("Creating controls...")
		controls = {
			select = {
				clicks = {"l"},
				buttons = {}
			},
			back = {
				clicks = {},
				buttons = {"escape"}
			},
			pause = {
				clicks = {},
				buttons = {" ", "escape"}
			},
			red = {
				clicks = {"l"},
				buttons = {}
			},
			green = {
				clicks = {"wd", "wu", "m"},
				buttons = {}
			},
			blue = {
				clicks = {"r"},
				buttons = {}
			}
		}
	end
end

function menu:enter()
	log("Entering menu...")
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
	if input(button, controls.select) then
		Gamestate.switch(game, {boxSize = settings.difficulty.boxSize, colorStep = settings.difficulty.colorStep, timeLimit = settings.difficulty.timeLimit}, controls)
	end
end

function menu:keypressed(key, unicode)
	if input(key, controls.back) then
		log("Quitting.")
		love.event.quit()
	end
end

return menu
