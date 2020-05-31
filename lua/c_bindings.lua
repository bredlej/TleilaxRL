local c = {

	stop = function()
		HOST_stop()
	end,

	randomize_seed = function(x, y)
		return HOST_randomize_seed_xy(x, y) 
	end,

	random_int = function (x, y)
		return HOST_random_int(x, y)
	end,

	random_double = function (x, y)
		return HOST_random_double(x, y)
	end,
	
	draw_string = function (char, x, y, color)
		HOST_draw_char(char, x, y, color)
	end,

	init_color_pair = function (index, fg_color, bg_color)
		HOST_init_color_pair(index, fg_color, bg_color)
	end,

	clear = function ()
		HOST_clear()
	end

}

return c
