local G = require('lua/globals')
local C = require('lua/c_bindings')
local config = require ('lua/config')
local inspect = require ('lua/inspect')
local handle_events = {
--		["scroll_left"] = function(time_ms) G.galaxy["offset_x"] = G.galaxy["offset_x"] - config.scroll_speed * time_ms end,
--		["scroll_right"] = function(time_ms) G.galaxy["offset_x"] = G.galaxy["offset_x"] + config.scroll_speed * time_ms end,
--		["scroll_up"] = function(time_ms) G.galaxy["offset_y"] = G.galaxy["offset_y"] - config.scroll_speed * time_ms end,
--		["scroll_down"] = function(time_ms) G.galaxy["offset_y"] = G.galaxy["offset_y"] + config.scroll_speed * time_ms end,
	}
local type_to_color = {
	[1] = 6,
	[2] = 7,
	[3] = 5
}
local offset = {
	["x"] = 1,
	["y"] = 2
}
local function draw_fuel_indicator(fuel_component, x, y)
	C.draw_string(string.format("Fuel [           ]: %d/%d", fuel_component["current"], fuel_component["max"]), x, y, 0)
	local color
	for i = 0, math.floor(11 * (fuel_component["current"] / fuel_component["max"])) - 1, 1
		do
			if (i < 4) then color = 6
			elseif (i >= 4)  and (i < 8) then color = 5
			else color = 7 end
			C.draw_string("#", x+6+i, y, color)
		end
end
local galaxy_state = {
	draw = function (self, args)
	local elapsed_ms = args["elapsed"]
	local entities = args["entities"]

	G.player_pos = entities[0]["position"]
	local player_at_star = nil
	for x = 0, config.screen_width, 1
		do
		for y = 0, config.screen_height, 1
			do
				local star = Star:new(nil)
				star:init(x + math.floor(G.galaxy["offset_x"]), y + math.floor(G.galaxy["offset_y"]))
				if (star.exists)
				then
					C.draw_string(type_to_char[star.type], x + offset["x"], y + offset["y"], star.color_idx)
				else
					C.draw_string(" ", x+offset["x"], y+offset["y"], 1);
				end
				if (star.exists and x + math.floor(G.galaxy["offset_x"]) == math.floor(G.player_pos["x"])
					and y + math.floor(G.galaxy["offset_y"]) == math.floor(G.player_pos["y"]))
						then
							if (player_has_moved)
								then
									player_has_moved = false
									C.clear()
								end
							player_at_star = star
						end
				if (x + math.floor(G.galaxy["offset_x"]) == math.floor(G.player_pos["x"])
					and y + math.floor(G.galaxy["offset_y"]) == math.floor(G.player_pos["y"]))
					then
						C.draw_string("@", x+offset["x"], y+offset["y"], 0);
					end
		end
	end	
		local message_offset_x = 6
		local message_offset_y = 10
	if (player_at_star)
		then
			C.draw_string(string.format("You found a star system!"), config.screen_width + message_offset_x, 10, 0)
			local i = 0
			for planet_idx = 0, player_at_star.amount_planets, 1
				do
					planets = player_at_star.planets
					C.draw_string (string.format("- %s -", player_at_star.name), math.floor(config.screen_width / 2 - 5), 2, 0)
					C.draw_string(string.format("Planets"), config.screen_width + message_offset_x, 12 , 0)
					C.draw_string(string.format(" O "), config.screen_width + message_offset_x +(i*3), 13 , type_to_color[planets[i]["type"]])
					i = i + 1
				end
		else
			for i = 0, 10, 1
				do
					C.draw_string (string.format("                         "), math.floor(config.screen_width / 2 - 5), 2, 0)
					C.draw_string(string.format("                         "), config.screen_width + message_offset_x, 5 + i, 0)
				end
			C.draw_string(string.format("                 "), config.screen_width + message_offset_x, 5, 0)
	draw_fuel_indicator(entities[0]["fuel"], config.screen_width + 7, 6)
	C.draw_string("Press one of w s a d to scroll the galaxy.", 3, 43, 0)
	C.draw_string("Press one of h j k l to control the spaceship.", 3, 44, 0)
	C.draw_string("Press CTRL+c to exit.", 3, 45, 0)
		end
	end,
	input_map = {
		["a"] = handle_events["scroll_left"],
		["s"] = handle_events["scroll_down"],
		["d"] = handle_events["scroll_right"],
		["w"] = handle_events["scroll_up"]
	},

}
return galaxy_state
