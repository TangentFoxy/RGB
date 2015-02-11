Gamestate = require "lib.gamestate"
Gamejolt = require "lib.gamejolt"

local inifile = require "lib.inifile"

local menu = require "gamestates.menu"

function love.load()
	-- set custom window icon
	local icon = love.image.newImageData("icon.png")
	love.window.setIcon(icon)

	-- initialize Game Jolt
	Gamejolt.init(48728, "b8e4a0eae1509d3edef3d8451bae1842")

	-- load settings and change if needed
	local gamejoltSession = false --whether or not we have an active session
	if love.filesystem.isFile("settings.ini") then
		local settings = inifile.parse("settings.ini")
		love.window.setMode(settings.display.width, settings.display.height, {fullscreen = settings.display.fullscreen, borderless = settings.display.borderless})
		-- login if we have the data to do so
		if settings.gamejolt.username and settings.gamejolt.usertoken then
			local authSuccess = Gamejolt.authUser(settings.gamejolt.username, settings.gamejolt.usertoken)
			if authSuccess then
				-- check if the player has been banned
				local userInfo = Gamejolt.fetchUserByName(settings.gamejolt.username)
				if userInfo.status == "Banned" then
					settings.gamejolt.username = false
					settings.gamejolt.usertoken = false
					inifile.save("settings.ini", settings)
					error("You have been banned from Game Jolt. Your login data has been deleted, re-open RGB to continue playing without Game Jolt account integration.")
				end
				local sessionSuccess = Gamejolt.openSession() -- tell Game Jolt the user is playing
				if sessionSuccess then
					--[[ -- we don't ping immediately, also the menu DOES ping immediately
					local idleSuccess = Gamejolt.pingSession(false)
					if not idleSuccess then
						log("Couldn't ping Gamejolt session. Session may close.") --this is lazy but I don't care
					end
					--]]
					gamejoltSession = true
				else
					log("Couldn't open a session with Game Jolt.")
				end
			else
				log("Failed to log into Game Jolt. Please report this error (with a screenshot) to: paul.liverman.iii@gmail.com")
			end
		end
	end

	Gamestate.registerEvents()
	Gamestate.switch(menu, gamejoltSession)
end
