local input = require "util.input"

local lost = {}

local previousState, screenshot, score, controls
local pingTimer, session = 0, false

function lost:enter(previous, screenImageData, totalScore, gameControls, gamejoltSession)
	log("Game lost.")
	previousState = previous
	screenshot = love.graphics.newImage(screenImageData)
	score = totalScore
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

function lost:update(dt)
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

function lost:draw()
	-- draw the screenshot
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(screenshot)
	-- draw a partial transparency black to fade out the screenshot
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	-- print info
	love.graphics.setNewFont(40)
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 4 - 20, love.graphics.getWidth(), "center")
	love.graphics.setNewFont(50)
	love.graphics.printf(string.format("Final Score: %.1f", score), 0, love.graphics.getHeight() / 2 - 25, love.graphics.getWidth(), "center")
	love.graphics.setNewFont(16)
	love.graphics.printf("(Press Esc to restart.)", 0, love.graphics.getHeight() * 3/4 - 8, love.graphics.getWidth(), "center")
end

---[[
function lost:mousepressed(x, y, button)
	if input(button, controls.select) or input(button, controls.back) then
		log("Restarting game...")
		Gamestate.pop("LOST")
	end
end
--]]

function lost:keypressed(key, unicode)
	if input(key, controls.pause) then
		log("Restarting game...")
		Gamestate.pop("LOST")
	elseif input(key, controls.back) then
		log("Restarting game...")
		Gamestate.pop("LOST")
	end
end

return lost
