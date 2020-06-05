local machine = require 'lua/statemachine'
local inspect = require "lua/inspect"
local G = require 'lua/globals'
local C = require 'lua/c_bindings'

local modules = {
	hull = {on = true, color = 5, lines = G.file_read_lines("lua/states/spaceship.0.txt")},
	cpu = {on = false, color = 3, lines = G.file_read_lines("lua/states/spaceship.1.txt")},
	sensors = {on = false, color = 7, lines = G.file_read_lines("lua/states/spaceship.2.txt")}
}

local player = {
	components = {
		["position"] = {
			x = 46, y = 18
		}
	}
}

local check_if_cpu = function () 
	if (player.components["position"].x == 51 and player.components["position"].y == 18)
		then
			if (modules.cpu.on == true and modules.sensors.on == false) 
				then
				C.draw_string("As you login to the ships interface, green lights from", 2, 36, 0)
				C.draw_string("the screens fill the otherwise dark room.", 2, 37, 0)
				C.draw_string("In one of the screens you see a familiar prompt", 2, 39, 0)
				C.draw_string("asking if you'd like to activate the ships sensors.", 2, 40, 0)
				end
			if (modules.cpu.on == true and modules.sensors.on == true)
				then
				C.draw_string("You confirm the prompt and hear a light buzz coming", 2, 36, 0)
				C.draw_string("from everywhere around you, as electrons travel through ", 2, 37, 0)
				C.draw_string("the ships mainframe.", 2, 38, 0)
				C.draw_string("Suddenly there are millions of brilliantly colored stars", 2, 40, 0)
				C.draw_string("appearing on a screen in front of you.", 2, 41, 0)
				C.draw_string("You see a blinking prompt asking:", 2, 43, 0)
				C.draw_string("'What is your destination?'", 35, 44, 0)
				C.draw_string("{■", 52, 18, 6)
				end
			if (modules.cpu.on == false and modules.sensors.on == false)
				then
				C.draw_string("You sit on the cockpit chair in front of which is a desktop", 2, 36, 0)
				C.draw_string("covered with many buttons and levers.", 2, 37, 0)
				C.draw_string("Various rectangular screens fill the wall above you.", 2, 39, 0)
				end
		end
end
local player_moved = false
local handle_events = {
		["move_left"] = function(time_ms) player.components["position"].x = player.components["position"].x - 1 player_moved = true end,
		["move_right"] = function(time_ms) player.components["position"].x = player.components["position"].x + 1 player_moved = true end,
		["move_up"] = function(time_ms) player.components["position"].y = player.components["position"].y - 1 player_moved = true end,
		["move_down"] = function(time_ms) player.components["position"].y = player.components["position"].y + 1 player_moved = true end,
		["turn_on_cpu"] = function(time_ms) modules.cpu.on = true end,
		["turn_on_sensors"] = function(time_ms) modules.sensors.on = true end
	}
function draw_spaceship_status ()
	if (modules.cpu.on) then
		C.draw_string("CPU is ON", 70 , 5, 0)
		G.utf8_draw_lines(modules.cpu.lines, 0, 0, modules.cpu.color)
		else
		C.draw_string("CPU is OFF", 70 , 5, 0)
	end
	if (modules.sensors.on) then
		C.draw_string("Sensors are ON", 70 , 7, 0)
		G.utf8_draw_lines(modules.sensors.lines, 0, 0, modules.sensors.color)
		else
		C.draw_string("Sensors are OFF", 70 , 7, 0)
		end
end
local spaceship = {
	draw = function (self, args)
		G.clear_window["status"]()
		G.clear_window["attributes"]()
		G.utf8_draw_lines(modules.hull.lines, 0, 0, modules.hull.color)
		C.draw_string("@", player.components["position"].x, player.components["position"].y, 0)
		draw_spaceship_status()
		check_if_cpu()
		if (not player_moved) then
				C.draw_string("The darkness fades and you wake up.", 2, 36, 0)
				C.draw_string("A moment passes until you remember where you are.", 2, 37, 0)
				C.draw_string("You recognize the shapes of your space ships main", 2, 39, 0)
				C.draw_string("corridor. The room is filled with cold and silence", 2, 40, 0)
				C.draw_string("and you struggle to remember what happened.", 2, 41, 0)
				C.draw_string("Suddenly a terrifying thought enters your mind:", 2, 42, 0)
				C.draw_string("'Is the ship still alive?'", 35, 44, 0)
			end
	end,
	input_map = {
		["a"] = handle_events["move_left"],
		["s"] = handle_events["move_down"],
		["d"] = handle_events["move_right"],
		["w"] = handle_events["move_up"],
		["1"] = handle_events["turn_on_cpu"],
		["2"] = handle_events["turn_on_sensors"]
	},
}

return spaceship
