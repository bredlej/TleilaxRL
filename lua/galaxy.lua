require 'lua/galaxy_c_bindings'
require 'lua/config'

local key_actions = {
	["a"] = galaxy["scroll_left"],
	["d"] = galaxy["scroll_right"],
	["w"] = galaxy["scroll_up"],
	["s"] = galaxy["scroll_down"]
}


function key_pressed(key, time_ms)
	if (key_actions[key]) 
	then
		key_actions[key](time_ms)
	end
end

function draw_galaxy() 
	draw_string(string.format("x=[%.02f] y=[%0.2f]", galaxy["offset_x"], galaxy["offset_y"]), screen_width /2 ,3 ,0)
	for x = 0, screen_width, 1
		do
		for y = 0, screen_height, 1
			do
			randomize_seed(x + math.floor(galaxy["offset_x"]), y + math.floor(galaxy["offset_y"] ))

			randomNum = random_int(0, 43);
			if (randomNum == 0)
			then
				randomNum = random_int(0,100);
				
				if (randomNum < 10) 
					then
						draw_string("O", x+5, y+5, 1)
					else if (randomNum >= 10 and randomNum < 50)
					then
						draw_string("o", x+5, y+5, 2)
					else
						draw_string("*", x+5, y+5, 3)
					end			
				end
			else
				draw_string(" ", x+5, y+5, 1);
			end
		end
	end
	draw_string("Press one of WSAD keys to scroll the galaxy.", 0, 40, 0)
	draw_string("Press CTRL+c to exit.", 0, 41, 0)
end
