local paused = {}

local previousState, screenshot

function paused:enter(previous, screenImageData)
	previousState = previous
	screenshot = love.graphics.newImage(screenImageData)
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
	if button == "l" then
		Gamestate.pop("UNPAUSED")
	end
end
--]]

function paused:keypressed(key, unicode)
	if key == " " then
		Gamestate.pop("UNPAUSED")
	elseif key == "escape" then
		Gamestate.pop("UNPAUSED")
	end
end

return paused
