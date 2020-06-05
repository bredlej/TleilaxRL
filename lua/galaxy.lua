require 'lua/star'
local G = require 'lua/globals'
local C = require 'lua/c_bindings'
local machine = require 'lua/statemachine'
local inspect = require "lua/inspect"


local gui_layer_0 = G.file_read_lines("lua/states/galaxymap.gui")
--local gui_layer_1 = G.file_read_lines("lua/states/galaxymap.gui.layer1")

local config = require 'lua/config'

local ui_state = machine.create({
	initial = 'spaceship_view',
	events = {
		{ name = 'view_star_system', from = 'galaxy_view', to = 'starsystem_view' },
		{ name = 'view_galaxy', from = {'starsystem_view', 'spaceship_view'}, to = 'galaxy_view' },
		{ name = 'view_spaceship', from = {'galaxy_view', 'starsystem_view'}, to = 'spaceship_view' },
	}
})

local toggle_states = function ()
	C.clear()
	if (ui_state["current"] == "galaxy_view")
	then
		ui_state:view_spaceship()
--	elseif (ui_state["current"] == "starsystem_view")
--	then
--		ui_state:view_spaceship()
	elseif (ui_state["current"] == "spaceship_view")
	then
		ui_state:view_galaxy()
	end
end

local entities = {
	[0] = {
		["position"] = {
			["x"] = config.screen_width / 2,
			["y"] = config.screen_height / 2
		},
		["fuel"] = {
			["current"] = 500,
			["max"] = 500
		}
	}
}

local player = {
	["move"] = {
		["left"] = function()
			if ((entities[0])["fuel"]["current"] > 0) 
				then
					player_has_moved = true
					G.galaxy["offset_x"] = G.galaxy["offset_x"] - 1
					entities[0]["position"]["x"] = entities[0]["position"]["x"] - 1
					entities[0]["fuel"]["current"] = entities[0]["fuel"]["current"] - 1
				end
		end,
		["right"] = function()
			if ((entities[0])["fuel"]["current"] > 0) 
				then
					player_has_moved = true
					G.galaxy["offset_x"] = G.galaxy["offset_x"] + 1
					entities[0]["position"]["x"] = entities[0]["position"]["x"] + 1
					entities[0]["fuel"]["current"] = entities[0]["fuel"]["current"] - 1
				end
		end,
		["down"] = function()
			if ((entities[0])["fuel"]["current"] > 0) 
				then
					player_has_moved = true
					G.galaxy["offset_y"] = G.galaxy["offset_y"] + 1
					entities[0]["position"]["y"] = entities[0]["position"]["y"] + 1
					entities[0]["fuel"]["current"] = entities[0]["fuel"]["current"] - 1
				end
		end,
		["up"] = function()
			if ((entities[0])["fuel"]["current"] > 0) 
				then
					player_has_moved = true
					G.galaxy["offset_y"] = G.galaxy["offset_y"] - 1
					entities[0]["position"]["y"] = entities[0]["position"]["y"] - 1
					entities[0]["fuel"]["current"] = entities[0]["fuel"]["current"] - 1
				end
		end
	}
}

local states = {
	["galaxy_view"] = require ("lua/states/galaxymap"),
	["starsystem_view"] = require ("lua/states/planets"),
	["spaceship_view"] = require ("lua/states/spaceship")
}


local key_actions = {
	["a"] = states[ui_state.current].input_map["a"],
	["d"] = states[ui_state.current].input_map["d"],
	["w"] = states[ui_state.current].input_map["w"],
	["s"] = states[ui_state.current].input_map["s"],
	["1"] = states[ui_state.current].input_map["1"],
	["2"] = states[ui_state.current].input_map["2"],
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



function draw_galaxy(elapsed_ms)
	G.utf8_draw_lines(gui_layer_0, 0, 0, 5)
	states[ui_state.current]:draw({["elapsed"] = elapsed_ms, ["entities"] = entities})
end

C.init_color_pair(1, G.color["BLACK"], G.color["BLACK"])
C.init_color_pair(2, G.color["RED"], G.color["BLACK"])
C.init_color_pair(3, G.color["GREEN"], G.color["BLACK"])
C.init_color_pair(4, G.color["YELLOW"], G.color["BLACK"])
C.init_color_pair(5, G.color["BLUE"], G.color["BLACK"])
C.init_color_pair(6, G.color["MAGENTA"], G.color["BLACK"])
C.init_color_pair(7, G.color["CYAN"], G.color["BLACK"])
C.init_color_pair(8, G.color["WHITE"], G.color["BLACK"])
