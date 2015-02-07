love.math.setRandomSeed(os.time())

local Gamestate = require "lib.gamestate"

local game = {}

local boxes = {}
local boxSize = 20
local wAmount = math.floor(love.graphics.getWidth() / boxSize) - 1
local hAmount = math.floor(love.graphics.getHeight() / boxSize) - 5

local level = 0
local score = 0
local totalScore = 0
local time = 0
local colorStep = 80 -- difficulty setting

local function nextLevel()
	totalScore = totalScore + score
	level = level + 1
	score = 0
	time = 0

	-- initial black boxes
	for i=0,wAmount do
		boxes[i] = {}
		for j=0,hAmount do
			boxes[i][j] = {0, 0, 0}
		end
	end
	for i=1,math.floor(level * 1.2 + 2) do
		local x, y = love.math.random(0, #boxes), love.math.random(0, #boxes[1])
		boxes[x][y] = {love.math.random(0, 255), love.math.random(0, 255), love.math.random(0, 255)}
		boxes[x][y][1] = boxes[x][y][1] - boxes[x][y][1] % colorStep --is this right?
		boxes[x][y][2] = boxes[x][y][2] - boxes[x][y][2] % colorStep
		boxes[x][y][3] = boxes[x][y][3] - boxes[x][y][3] % colorStep
	end
end

local function equalColor(A, B)
	if A[1] == B[1] and A[2] == B[2] and A[3] == B[3] then
		return true
	end
	return false
end

local function copyColor(A)
	return {A[1], A[2], A[3]}
end

function game:update(dt)
	-- check if level complete
	local coloredBoxes = {}
	for i=0,#boxes do
		for j=0,#boxes[i] do
			if not equalColor(boxes[i][j], {0, 0, 0}) then
				table.insert(coloredBoxes, boxes[i][j])
			end
		end
	end
	local won, color
	if #coloredBoxes >= 2 then
		won = true
		color = copyColor(coloredBoxes[1])
		for i=2,#coloredBoxes do
			if not equalColor(color, coloredBoxes[i]) then
				won = false
			end
		end
	end
	if won then
		nextLevel()
	end

	-- else increment time
	time = time + dt

	score = #coloredBoxes / math.pow(time, 0.02) * colorStep --difficulty
end

function game:draw()
	--boxes
	for i=0,#boxes do
		for j=0,#boxes[i] do
			love.graphics.setColor(boxes[i][j])
			love.graphics.rectangle("fill", i * boxSize, j * boxSize + boxSize * 2, boxSize, boxSize)
		end
	end

	--lines
	-- vertical
	love.graphics.setColor(255, 255, 255)
	for i=0,wAmount+1 do
		love.graphics.line(i * boxSize, 0 + boxSize * 2, i * boxSize, love.graphics.getHeight() - boxSize * 2)

	end
	-- horizontal
	for j=0,hAmount+1 do
		love.graphics.line(0, j * boxSize + boxSize * 2, love.graphics.getWidth(), j * boxSize + boxSize * 2)
	end

	--time elapsed
	love.graphics.setNewFont(28)
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf(string.format("Total Score: %.1f", totalScore), 0, 3, 400, "center")
	--love.graphics.printf(string.format("Best Score: %.1f", bestScore), 400, 3, 400, "center")
	love.graphics.printf(string.format("Time: %.1f", time), 0, 425, 400, "center")
	love.graphics.printf(string.format("Level: %i", level), 0, 425, 800, "center")
	love.graphics.printf(string.format("Score: %.1f", score), 400, 425, 400, "center")
end

function game:mousepressed(x, y, button)
	local nx = math.floor(x / boxSize)
	local ny = math.floor((y - boxSize * 2) / boxSize)
	if boxes[nx][ny] then
		if button == "l" then
			boxes[nx][ny][1] = boxes[nx][ny][1] + colorStep
			if boxes[nx][ny][1] > 255 then
				boxes[nx][ny][1] = 0
			end
		elseif button == "m" or button == "wu" or button == "wd" then
			boxes[nx][ny][2] = boxes[nx][ny][2] + colorStep
			if boxes[nx][ny][2] > 255 then
				boxes[nx][ny][2] = 0
			end
		elseif button == "r" then
			boxes[nx][ny][3] = boxes[nx][ny][3] + colorStep
			if boxes[nx][ny][3] > 255 then
				boxes[nx][ny][3] = 0
			end
		end
	end
end

local menuState
function game:enter(previous)
	menuState = previous
	nextLevel()
end

function game:leave()
	level = 0
	score = 0
	totalScore = 0
	time = 0
end

function game:keypressed(key, unicode)
	if key == "escape" then
		--love.event.quit()
		Gamestate.switch(menuState)
	end
end

return game
