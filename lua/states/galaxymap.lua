local G = require('lua/galaxy_c_bindings')
local C = require('lua/c_bindings')
require ('lua/config')

local galaxy_state = {
	draw = function (self, args)
		elapsed_ms = args["elapsed"]
		entities = args["entities"]
		C.draw_string(elapsed_ms, 100, 100, 1)

	G.player_pos = entities[0]["position"]
	-- C.draw_string(string.format("galaxy(x=[%.02f], y=[%0.2f]) player(x=[%d], y=[%d])", galaxy["offset_x"], galaxy["offset_y"], player_pos["x"], player_pos["y"]), 0 ,3 ,0)
	local player_at_star = nil
	for x = 0, screen_width, 1
		do
		for y = 0, screen_height, 1
			do
				star = Star:new(nil)
				star:init(x + math.floor(G.galaxy["offset_x"]), y + math.floor(G.galaxy["offset_y"]))
				if (star.exists)
				then
					C.draw_string(type_to_char[star.type], x+5, y+5, star.type)					
				else
					C.draw_string(" ", x+5, y+5, 1);
				end
				if (star.exists and x + math.floor(G.galaxy["offset_x"]) == G.player_pos["x"] and y + math.floor(G.galaxy["offset_y"]) == G.player_pos["y"])
						then
							if (player_has_moved)
								then
									player_has_moved = false
									C.clear()
								end
							player_at_star = star
						end
				if (x + math.floor(G.galaxy["offset_x"]) == G.player_pos["x"] and y + math.floor(G.galaxy["offset_y"]) == G.player_pos["y"])
					then
						C.draw_string("@", x+5, y+5, 0);
					end
		end
	end	
	if (player_at_star)
		then
			C.draw_string(string.format("Encountered Star!"), screen_width + 6, 5, 0)
			i = 0
			for planet_idx = 0, player_at_star.amount_planets, 1
				do
					planets = player_at_star.planets
					C.draw_string(string.format("Planets"), screen_width + 6, 7 , 0)
					C.draw_string(string.format(" O "), screen_width + 15 +(i*3), 7 , planets[i]["type"])
					i = i + 1
				end
		else
			for i = 0, 10, 1
				do
					C.draw_string(string.format("                                          "), screen_width + 6, 5 + i, 0)
				end
			C.draw_string(string.format("                     "), screen_width + 6, 5, 0)
		end
	C.draw_string("Press one of w s a d to scroll the galaxy.", 0, 40, 0)
	C.draw_string("Press one of h j k l to control the spaceship.", 0, 41, 0)
	C.draw_string("Press CTRL+c to exit.", 0, 43, 0)
	end,
	handle_events = {
		["scroll_left"] = function(time_ms) G.galaxy["offset_x"] = G.galaxy["offset_x"] - scroll_speed * time_ms end,
		["scroll_right"] = function(time_ms) G.galaxy["offset_x"] = G.galaxy["offset_x"] + scroll_speed * time_ms end,
		["scroll_up"] = function(time_ms) G.galaxy["offset_y"] = G.galaxy["offset_y"] - scroll_speed * time_ms end,
		["scroll_down"] = function(time_ms) G.galaxy["offset_y"] = G.galaxy["offset_y"] + scroll_speed * time_ms end,
	}

}
return galaxy_state
