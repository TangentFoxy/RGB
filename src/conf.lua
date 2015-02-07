function love.conf(t)
	t.identity = "RGB"
	t.version = "0.9.1"
	--t.author = "Guard13007"
	t.console = true

	t.window = {}
	t.window.title = "RGB - The Color Chooser"
	t.window.width = 800
	t.window.height = 460
	t.window.borderless = true

	--t.modules = {}
	t.modules.joystick = false
	t.modules.physics = false
end
