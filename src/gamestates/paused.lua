local input = require "util.input"

local paused = {}

local previousState, screenshot, controls
local pingTimer, session = 0, false

function paused:enter(previous, screenImageData, gameControls, gamejoltSession)
	log("Game paused.")
	previousState = previous
	screenshot = love.graphics.newImage(screenImageData)
	controls = gameControls
	session = gamejoltSession
	-- ping our idle state immediately
	if session then
		local idleSuccess = Gamejolt.pingSession(false)
		if not idleSuccess then
			log("Couldn't ping Game Jolt session. Session may close.")
		end
	end
end

function paused:update(dt)
	-- ping every 30 seconds if in a session
	pingTimer = pingTimer + dt
	if pingTimer >= 30 then
		if session then
			local idleSuccess = Gamejolt.pingSession(false)
			if not idleSuccess then
				log("Couldn't ping Game Jolt session. Session may close.") --this is lazy but I don't care
			end
		end
		pingTimer = pingTimer - 30
	end
end

function paused:draw()
	-- draw the screenshot
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(screenshot)
	-- draw a partial transparency black to fade out the screenshot
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	-- print info
	love.graphics.setNewFont(40)
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("Paused", 0, love.graphics.getHeight() * 2/5 - 20, love.graphics.getWidth(), "center")
	love.graphics.setNewFont(20)
	love.graphics.printf("(Press Esc to resume.)", 0, love.graphics.getHeight() * 3/5 - 10, love.graphics.getWidth(), "center")
end

---[[
function paused:mousepressed(x, y, button)
	if input(button, controls.select) or input(button, controls.back) then
		Gamestate.pop("UNPAUSED")
	end
end
--]]

function paused:keypressed(key, unicode)
	if input(key, controls.pause) then
		Gamestate.pop("UNPAUSED")
	elseif input(key, controls.back) then
		Gamestate.pop("UNPAUSED")
	end
end

return paused
