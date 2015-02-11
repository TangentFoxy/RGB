local inifile = require "lib.inifile"
local trophies = require "trophies"

local state = {}

local previousState

function state:init()
	-- load or create our actual trophy state
	if love.filesystem.isFile("trophies.ini") then
		local trophyStates = inifile.parse("trophies.ini")
	else
		trophyStates = {
			16814 = false,
			16815 = false,
			16816 = false,
			16821 = false
		}
		-- TODO write these to file with inifile
	end
end

function state:enter(previous)
	--
end

function state:draw()
	--
end

return state
