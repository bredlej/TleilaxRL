local G = require 'lua/galaxy_c_bindings'
local C = require 'lua/c_bindings'
local machine = require 'lua/statemachine'
local inspect = require "lua/inspect"

require 'lua/config'
require 'lua/star'

local ui_state = machine.create({
	initial = 'galaxy_view',
	events = {
		{ name = 'view_star_system', from = 'galaxy_view', to = 'starsystem_view' },
		{ name = 'view_galaxy', from = 'starsystem_view', to = 'galaxy_view' },
	}
})

local toggle_states = function ()
	C.clear()
	if (ui_state["current"] == "galaxy_view")
	then
		ui_state:view_star_system()
	elseif (ui_state["current"] == "starsystem_view")
	then
		ui_state:view_galaxy()
	end
end

local entities = {
	[0] = {
		["position"] = {
			["x"] = screen_width / 2,
			["y"] = screen_height / 2
		}
	}
}

local player = {
	["move"] = {
		["left"] = function()
			player_has_moved = true 
			entities[0]["position"]["x"] = entities[0]["position"]["x"] - 1
		end,
		["right"] = function()
			player_has_moved = true 
			entities[0]["position"]["x"] = entities[0]["position"]["x"] + 1
		end,
		["down"] = function()
			player_has_moved = true 
			entities[0]["position"]["y"] = entities[0]["position"]["y"] + 1
		end,
		["up"] = function()
			player_has_moved = true 
			entities[0]["position"]["y"] = entities[0]["position"]["y"] - 1
		end
	}
}

local player_has_moved = false

local states = {
	["galaxy_view"] = require ("lua/states/galaxymap"),
	["starsystem_view"] = require ("lua/states/planets")
}


key_actions = {
	["a"] = states[ui_state.current].handle_events["scroll_left"],

	["d"] = states[ui_state.current].handle_events["scroll_right"],
	["w"] = states[ui_state.current].handle_events["scroll_up"],
	["s"] = states[ui_state.current].handle_events["scroll_down"],
	["c"] = C.clear,
	["q"] = C.stop,
	["h"] = player["move"]["left"],
	["k"] = player["move"]["up"],
	["j"] = player["move"]["down"],
	["l"] = player["move"]["right"],
	["o"] = toggle_states
}

function key_pressed(key, time_ms)
	if (key_actions[key]) 
	then
		key_actions[key](time_ms)
	end
end

C.init_color_pair(1, G.color["YELLOW"], G.color["BLACK"])
C.init_color_pair(2, G.color["CYAN"], G.color["BLACK"])
C.init_color_pair(3, G.color["MAGENTA"], G.color["BLACK"])



function draw_galaxy(elapsed_ms)
	states[ui_state.current]:draw({["elapsed"] = elapsed_ms, ["entities"] = entities})
end
