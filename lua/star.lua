-- Meta class Star
function random_type()
	randomNum = random_int(0,100);
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


Star = {
	exists = false,
	type = 1,
	planets = {},
	x = 0,
	y = 0,
	existsAt = function(self, x, y)
		randomize_seed(self.x, self.y)
		return random_int(0, 43) == 0
	end,	
	init = function(self, x, y)
		self.planets = {}
		self.x = x
		self.y = y
		if (not self:existsAt(x, y)) then return
		else
			self.exists = true
			self.type = random_type()
			self.amount_planets = random_int(1, 9)
			for x = 0, self.amount_planets, 1 
				do
					planet = {["type"] = random_type()}
					self.planets[x] = planet
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


