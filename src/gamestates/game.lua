love.math.setRandomSeed(os.time())

local input = require "util.input"

-- Gamestates
--local won = require "gamestates.won" --TODO MAKE THIS
local lost = require "gamestates.lost"
local paused = require "gamestates.paused"

-- This Gamestate
local game = {}

-- Locals
local boxes = {}
local score, totalScore = 0, 0
local level, time, startingTime = 0, 0, 0
local previousState, gameSettings, controls
--these are defined on each entry to this gamestate
local screenWidth, screenHeight              --defines where things are rendered
local boxColumns, boxRows                    --defines how many boxes
--these are loaded from values passed on entry to this gamestate
local boxSize, colorStep, timeLimit = 20, 80, 60 --default values just in case

local function nextLevel()
	log("Creating the next level!")

	totalScore = totalScore + score
	score = 0
	level = level + 1
	time = time + timeLimit --your remaining time is added on to the next level
	startingTime = time     --save where you started on this level for scoring

	-- (re)create black boxes
	boxes = {}
	for i=0,boxColumns do
		boxes[i] = {}
		for j=0,boxRows do
			boxes[i][j] = {0, 0, 0}
		end
	end

	-- assign a random set of boxes random colors
	for i=1,math.floor(math.pow(level, 1.07) * 1.03 + 2) do --(level * 1.5 + 2)
		local x, y = love.math.random(0, #boxes), love.math.random(0, #boxes[1])
		boxes[x][y] = {love.math.random(0, 255), love.math.random(0, 255), love.math.random(0, 255)}
		boxes[x][y][1] = boxes[x][y][1] - boxes[x][y][1] % colorStep --is this right?
		boxes[x][y][2] = boxes[x][y][2] - boxes[x][y][2] % colorStep
		boxes[x][y][3] = boxes[x][y][3] - boxes[x][y][3] % colorStep
	end

	log("Done!")
end

local function colorsEqual(A, B)
	if A[1] == B[1] and A[2] == B[2] and A[3] == B[3] then
		return true
	end
	return false
end

local function copyColor(A)
	return {A[1], A[2], A[3]}
end

function game:enter(previous, settings, gameControls)
	log("Entering game...")
	-- save the state we came from
	previousState = previous
	-- set locals based on screen size
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	boxColumns = math.floor(screenWidth / boxSize) - 1
	boxRows = math.floor(screenHeight / boxSize) - 5
	-- save the settings for later use
	gameSettings = settings or gameSettings
	controls = gameControls or controls
	-- set how to play the game based on settings
	boxSize = gameSettings.boxSize
	colorStep = gameSettings.colorStep
	timeLimit = gameSettings.timeLimit
	-- set the font we're going to use
	love.graphics.setNewFont(28)
	-- this is nextLevel shit
	nextLevel()
end

function game:resume(previous, action)
	if action == "LOST" then
		game:enter(previousState) --we want to keep the old values
		totalScore = 0            --this should have happened in game:leave() but does not for an unknown reason
	end
	if action == "UNPAUSED" then
		love.graphics.setNewFont(28) -- fix our font!
	end
end

function game:update(dt)
	-- check if level complete
	local coloredBoxes = {}
	for i=0,#boxes do
		for j=0,#boxes[i] do
			if not colorsEqual(boxes[i][j], {0, 0, 0}) then
				table.insert(coloredBoxes, boxes[i][j])
			end
		end
	end
	local won, color
	if #coloredBoxes >= 2 then
		won = true
		color = copyColor(coloredBoxes[1])
		for i=2,#coloredBoxes do
			if not colorsEqual(color, coloredBoxes[i]) then
				won = false
			end
		end
	end
	if won then
		-- TODO we need a brief push/pop of gamestate to display a winning message
		nextLevel()
	end

	-- else decrement time, and check if out of time
	time = time - dt
	if time <= 0 then
		-- TODO we need to pass an image of the screen and data about time of losing
		Gamestate.push(lost, love.graphics.newScreenshot(), totalScore + score)
		-- call leave to clean up the gamestate
		game:leave()
	end

	-- update the current score
	score = #coloredBoxes / math.pow(startingTime - time, 0.02) * colorStep
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
	for i=0,boxColumns+1 do
		love.graphics.line(i * boxSize, 0 + boxSize * 2, i * boxSize, screenHeight - boxSize * 2)

	end
	-- horizontal
	for j=0,boxRows+1 do
		love.graphics.line(0, j * boxSize + boxSize * 2, screenWidth, j * boxSize + boxSize * 2)
	end

	-- Info Overlays
	--love.graphics.setNewFont(28) --purposely stays same no matter screen res
	love.graphics.setColor(255, 255, 255)
	-- top of screen stuff
	love.graphics.printf(string.format("Total Score: %.1f", totalScore), 0, 3, screenWidth / 2, "center")
	--love.graphics.printf(string.format("Best Score: %.1f", bestScore), screenWidth / 2, 3, screenWidth / 2, "center")

	-- bottom of screen stuff
	love.graphics.printf(string.format("Time: %.1f", time), 0, screenWidth / 2 + 25, screenWidth / 2, "center")
	love.graphics.printf("Level: "..level, 0, screenWidth / 2 + 25, screenWidth, "center")
	love.graphics.printf(string.format("Current Score: %.1f", score), screenWidth / 2, screenWidth / 2 + 25, screenWidth / 2, "center")
end

function game:mousepressed(x, y, button)
	-- new x/y adjusted for where boxes actually are
	local nx = math.floor(x / boxSize)
	local ny = math.floor((y - boxSize * 2) / boxSize)
	-- check if we are actually over a box first
	if boxes[nx][ny] then
		-- left, red
		if input(button, controls.red) then
			boxes[nx][ny][1] = boxes[nx][ny][1] + colorStep
			if boxes[nx][ny][1] > 255 then
				boxes[nx][ny][1] = 0
			end
		-- middle, green
		elseif input(button, controls.green) then
			boxes[nx][ny][2] = boxes[nx][ny][2] + colorStep
			if boxes[nx][ny][2] > 255 then
				boxes[nx][ny][2] = 0
			end
		-- right, blue
		elseif input(button, controls.blue) then
			boxes[nx][ny][3] = boxes[nx][ny][3] + colorStep
			if boxes[nx][ny][3] > 255 then
				boxes[nx][ny][3] = 0
			end
		end
	end
end

function game:keypressed(key, unicode)
	if input(key, controls.back) then
		Gamestate.switch(previousState)
	elseif input(key, controls.pause) then
		Gamestate.push(paused, love.graphics.newScreenshot())
	end
end

function game:focus(isFocused)
	if not isFocused then
		Gamestate.push(paused, love.graphics.newScreenshot())
	end
end

function game:leave()
	--double check the correctness of this
	level = 0
	score = 0
	totalScore = 0
	time = 0
	startingTime = 0
end

return game
