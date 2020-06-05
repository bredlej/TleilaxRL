local C = require "lua/c_bindings"

local function is_empty_char(char)
	return string.match(char, " ") or string.match(char, "%s")
end

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
	end,

	utf8_draw_lines = function (line_table, offset_x, offset_y, color)
		for row,v in pairs(line_table) do
				local column = 0
				for uchar in string.gmatch(v, "([%z\1-\127\194-\244][\128-\191]*)") do
					if (not is_empty_char(uchar)) then
						C.draw_string(string.format("%s", uchar), column + offset_x, row + offset_y, color)
					end
					column = column + 1
				end
		end
	end,
	file_read_lines = function (file)
		lines = {}
		for line in io.lines(file) do
			lines[#lines + 1] = line
		end
		return lines
	end,
	clear_window = {
		["status"] = function()
		 for y = 35, 45, 1 do
			 C.draw_string("                                                                ", 1, y, 0)
		 end
		end,
		["attributes"] = function()
		 for y = 2, 45, 1 do
			 C.draw_string("                                                     ", 66, y, 0)
		 end
		end
	}
}

return globals
