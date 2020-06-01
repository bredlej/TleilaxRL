-- Module to define C/Lua bindings used in galaxy.lua
-- see lib/Lua/lua_utils.h for which HOST_* functions need to be defined here

local globals = {

	color = {
		["BLACK"]   = 0,
		["RED"]     = 1,
		["GREEN"]   = 2,
		["YELLOW"]  = 3,
		["BLUE"]    = 4,
		["MAGENTA"] = 5,
		["CYAN"]    = 6,
		["WHITE"]   = 7
	},

	galaxy = {
		["offset_x"] = 0,
		["offset_y"] = 0,
	},
	rnd = {},

	galaxy_set_offset = function (x, y)
		galaxy["offset_x"] = x
		galaxy["offset_y"] = y
	end

}

return globals

