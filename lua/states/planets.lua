local inspect = require ("lua/inspect")
local C = require("lua/c_bindings")
local planets_state = {
	draw = function (self, args)
		C.draw_string(string.format("Star system view args=[%s]", inspect(args)), 5, 5, 2)					
	end
}

return planets_state
