local lost = {}

local previousState, screenshot

function lost:enter(previous, screenImageData)
	previousState = previous
	screenshot = love.graphics.newImage(screenImageData)
	love.graphics.setNewFont(40)
end

function lost:draw()
	-- draw the screenshot
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(screenshot)
	-- draw a partial transparency black to fade out the screenshot
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	-- print info
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
	--[[
	love.graphics.printf(string.format("Total Score: %.1f", totalScore), 0, 3, screenWidth / 2, "center")
	--love.graphics.printf(string.format("Best Score: %.1f", bestScore), screenWidth / 2, 3, screenWidth / 2, "center")

	-- bottom of screen stuff
	love.graphics.printf(string.format("Time: %.1f", time), 0, screenWidth / 2 + 25, screenWidth / 2, "center")
	love.graphics.printf("Level: "..level, 0, screenWidth / 2 + 25, screenWidth, "center")
	love.graphics.printf(string.format("Current Score: %.1f", score), screenWidth / 2, screenWidth / 2 + 25, screenWidth / 2, "center")
	]]
end

function lost:mousepressed(x, y, button)
	if button == "l" then
		Gamestate.pop()
		--Gamestate.switch(previousState)
	end
end

return lost
