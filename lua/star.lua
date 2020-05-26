-- Meta class Star
Star = {
	exists = false,
	type = 1,
	existsAt = function(self, x, y)
		randomize_seed(x, y)
		return random_int(0, 43) == 0
	end,
	init = function(self, x, y)
		if (not self:existsAt(x, y)) then return
		else
		self.exists = true
		randomNum = random_int(0,100);
		if (randomNum < 10) 
			then
				self.type = 1
			else if (randomNum >= 10 and randomNum < 50)
			then
				self.type = 2
			else
				self.type = 3
			end			
		end
		end
	end
}

-- Constructor


function Star:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

--function Star:exitsAt(x, y)
	--randomize_seed(x, y)	
	--return random_int(0, 43) == 0
--	return 100
--end

