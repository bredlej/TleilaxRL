local C = require('lua/c_bindings')
local namegen = require("lua/namegen")

-- Meta class Star
local function random_type()
	local randomNum = C.random_int(0,100);
	if (randomNum < 10) 
		then
			return 1
		else if (randomNum >= 10 and randomNum < 50)
		then
			return 2
		else
			return 3 
		end
	end
end


local type_to_color = {
	[1] = 6,
	[2] = 7,
	[3] = 5
}

Star = {
	exists = false,
	type = 1,
	color_idx = 1,
	planets = {},
	x = 0,
	y = 0,
	existsAt = function(self, x, y)
		C.randomize_seed(self.x, self.y)
		return C.random_int(0, 43) == 0
	end,
	init = function(self, x, y)
		self.planets = {}
		self.x = x
		self.y = y
		if (not self:existsAt(x, y)) then return
		else
			self.exists = true
			self.type = random_type()
			self.name = namegen.random_name()
			self.color_idx = type_to_color[self.type]
			self.amount_planets = C.random_int(1, 9)
			for i = 0, self.amount_planets, 1
				do
					local planet = {["type"] = random_type()}
					self.planets[i] = planet
				end
		end
	end
}

-- Constructor
type_to_char = {
	[1] = "O",
	[2] = "o",
	[3] = "."
}

function Star:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end


