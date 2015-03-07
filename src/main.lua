Gamestate = require "lib.gamestate"
GameJolt = require "lib.gamejolt"
debug = require "conf" -- a bit redundant but makes it obvious what is global

local startDate = os.date("*t", os.time())
local logFile = "logs/" .. startDate.year .. "." .. startDate.month .. "." .. startDate.day .. "-" .. startDate.hour .. "." .. startDate.min .. ".log"
function log(...)
	---[[
	local strings = ""
	if type(arg) == "table" then
		for _,v in ipairs(arg) do
			strings = strings .. v
		end
	else
		strings = arg
	end
	-- make sure logs exists
	if love.filesystem.exists("logs") then
		if not love.filesystem.isDirectory("logs") then
			love.filesystem.remove()
			love.filesystem.createDirectory("logs")
		end
	else
		love.filesystem.createDirectory("logs")
	end
	-- append new data to logFile
	local success, errorMsg = love.filesystem.append(logFile, strings)
	if not success then
		print("Failed to write to log file.", errorMsg)
	end
	--]]
	if debug then print(...) end
end

local inifile = require "lib.inifile"

local menu = require "gamestates.menu"

function love.load()
	log("Loading...")
	love.window.setIcon(love.image.newImageData("icon.png"))
	log("Window icon set.")

	-- initialize Game Jolt
	GameJolt.init(48728, "b8e4a0eae1509d3edef3d8451bae1842")
	log("Game Jolt initialized.")

	-- load settings and change if needed
	local gamejoltSessionOpen = false --set true if we get a session open
	if love.filesystem.isFile("settings.ini") then
		log("Loading settings...")
		local settings = inifile.parse("settings.ini")
		love.window.setMode(settings.display.width, settings.display.height, {fullscreen = settings.display.fullscreen, borderless = settings.display.borderless})
		-- login if we have the data to do so
		if settings.gamejolt.username and settings.gamejolt.usertoken then
			log("Logging in to Game Jolt.")
			local authSuccess = GameJolt.authUser(settings.gamejolt.username, settings.gamejolt.usertoken)
			if authSuccess then
				-- check if the player has been banned
				local userInfo = GameJolt.fetchUserByName(settings.gamejolt.username)
				if userInfo.status == "Banned" then
					log("Player has been banned from Game Jolt.")
					settings.gamejolt.username = false
					settings.gamejolt.usertoken = false
					inifile.save("settings.ini", settings)
					error("You have been banned from Game Jolt. Your login data has been deleted, re-open RGB to continue playing without Game Jolt account integration.")
				end
				if GameJolt.openSession() then -- tell Game Jolt the user is playing
					-- we don't ping immediately, also the menu DOES ping immediately
					gamejoltSessionOpen = true
					log("Game Jolt session opened.")
				else
					gamejoltSessionOpen = false
					-- TODO make this known to user
					log("Couldn't open a session with Game Jolt.")
				end
			else
				-- TODO make this better, also detect if online somehow
				log("Failed to log into Game Jolt. Please report this error (with a screenshot) to: paul.liverman.iii@gmail.com")
			end
		end
	end

	Gamestate.registerEvents()
	log("Loaded, switching to main menu...")
	Gamestate.switch(menu, gamejoltSessionOpen)
end
