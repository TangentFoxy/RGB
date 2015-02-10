function love.conf(t)
	t.identity = "rgb"
	t.version = "0.9.1"
	--t.author = "Guard13007"
	--t.console = true

	t.window = {}
	t.window.title = "RGB - The Color Chooser"
	t.window.width = 960  --800
	t.window.height = 540 --460
	t.window.fullscreen = false
	t.window.borderless = true
	t.window.resizable = false

	--t.modules = {}
	t.modules.joystick = false
	t.modules.physics = false
end
