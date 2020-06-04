local G = require "lua/globals"
local C = require "lua/c_bindings"
local names = {
	[0] = G.file_read_lines("lua/names/greek"),
	[1] = G.file_read_lines("lua/names/indian")
}
local suffixes = {
	" I ",
	" II ",
	" III ",
	" IV ",
	" X ",
	" Prime ",
	" Polaris ",
}
local random_name = function()
		local all_names = C.random_int(0, #names + 1)
		return string.format("%s", names[all_names][C.random_int(1, #names[all_names])])
end
namegen = {

	random_name = function () 
		local has_suffix = C.random_int(0, 100) <= 50
		local name = random_name()
		if (has_suffix) then
			local is_suffix_name = C.random_int(0, 100) <= 50
			if (is_suffix_name) then
				name = string.format("%s %s", name, random_name())
			else
				name = string.format("%s %s", name, suffixes[C.random_int(1, #suffixes)])
			end
		end
		return name
	end
}

return namegen
