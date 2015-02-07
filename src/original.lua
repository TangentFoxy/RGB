local game = {}

local boxes = {}
local boxSize = 20
local wAmount = math.floor(love.graphics.getWidth() / boxSize)
local hAmount = math.floor(love.graphics.getHeight() / boxSize)

-- initial black boxes
for i=0,wAmount do
	boxes[i] = {}
	for j=0,hAmount do
		boxes[i][j] = {0, 0, 0}
	end
end

function game:draw()
	--boxes
	for i=0,#boxes do
		for j=0,#boxes[i] do
			love.graphics.setColor(boxes[i][j])
			love.graphics.rectangle("fill", i * boxSize, j * boxSize, boxSize, boxSize)
		end
	end

	--lines
	love.graphics.setColor(255, 255, 255)
	for i=0,wAmount do
		love.graphics.line(i * boxSize, 0, i * boxSize, love.graphics.getHeight())

	end
	for j=0,hAmount do
		love.graphics.line(0, j * boxSize, love.graphics.getWidth(), j * boxSize)
	end
end

function game:mousepressed(x, y, button)
	print(button) --debug
	if button == "l" then
		boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][1] = boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][1] + 40
		if boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][1] > 255 then
			boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][1] = 0
		end
	elseif button == "m" or button == "wu" or button == "wd" then
		boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][2] = boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][2] + 40
		if boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][2] > 255 then
			boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][2] = 0
		end
	elseif button == "r" then
		boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][3] = boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][3] + 40
		if boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][3] > 255 then
			boxes[math.floor(x / boxSize)][math.floor(y / boxSize)][3] = 0
		end
	end
end

function game:keypressed(key, unicode)
	if key == "escape" then
		love.event.quit()
	end
end

return game
