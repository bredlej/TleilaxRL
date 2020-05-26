require 'lua/galaxy_c_bindings'
require 'lua/config'
require 'lua/star'

local entities = {
	[0] = {
		["position"] = {
			["x"] = 32,
			["y"] = 32
		}
	}
}

local key_actions = {
	["a"] = galaxy["scroll_left"],
	["d"] = galaxy["scroll_right"],
	["w"] = galaxy["scroll_up"],
	["s"] = galaxy["scroll_down"],
	["q"] = stop,
	["h"] = function () entities[0]["position"]["x"] = entities[0]["position"]["x"] - 1 end,
	["k"] = function () entities[0]["position"]["y"] = entities[0]["position"]["y"] - 1 end,
	["j"] = function () entities[0]["position"]["y"] = entities[0]["position"]["y"] + 1 end,
	["l"] = function () entities[0]["position"]["x"] = entities[0]["position"]["x"] + 1 end
}


function key_pressed(key, time_ms)
	if (key_actions[key]) 
	then
		key_actions[key](time_ms)
	end
end

function draw_galaxy() 

	player_pos = entities[0]["position"]
	-- draw_string(string.format("galaxy(x=[%.02f], y=[%0.2f]) player(x=[%d], y=[%d])", galaxy["offset_x"], galaxy["offset_y"], player_pos["x"], player_pos["y"]), 0 ,3 ,0)
	player_at_star = 0
	for x = 0, screen_width, 1
		do
		for y = 0, screen_height, 1
			do
				star = Star:new(nil)
				star:init(x + math.floor(galaxy["offset_x"]), y + math.floor(galaxy["offset_y"]))
				if (star.exists)
				then
					draw_string(star.type, x+5, y+5, star.type)
				else
					draw_string(" ", x+5, y+5, 1);
				end
				if (star.exists and x + math.floor(galaxy["offset_x"]) == player_pos["x"] and y + math.floor(galaxy["offset_y"]) == player_pos["y"])
						then
							player_at_star = star.type
						end
				if (x + math.floor(galaxy["offset_x"]) == player_pos["x"] and y + math.floor(galaxy["offset_y"]) == player_pos["y"])
					then
						draw_string("@", x+5, y+5, 0);
					end
		end
	end	
	if (player_at_star > 0)
		then
			draw_string(string.format("Encountered Star=[%d]", player_at_star), screen_width + 6, 5, 0)
		else
			draw_string(string.format("                     "), screen_width + 6, 5, 0)
		end
	draw_string("Press one of WSAD keys to scroll the galaxy.", 0, 40, 0)
	draw_string("Press CTRL+c to exit.", 0, 41, 0)
end
