#include <ctype.h>
#include <errno.h>
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
#include <ncurses.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#include "lib/Lua/lua_utils.h"
#include "lib/NcursesTools/ncurses_tools.h"
#include "lib/Random/random.h"
#include "lib/TimeOps/timeops.h"

#define MS_PER_UPDATE_GRAPHICS 16
#define MS_PER_UPDATE_LOGIC 1000

/**
 * Global variable determining if main loop should run
 */
static volatile sig_atomic_t program_is_running = 1;

/**
 * Stops the program from running
 */
static void stop(int sig) { program_is_running = 0; }

/**
 * Declaration of Lua <-> C function bindings
 */
int init_lua_bindings() {
    Lua.p_randomize_seed_xy_function = Random.randomize_seed_xy;
    Lua.p_rnd_int_range_function = Random.rnd_int_range;
    Lua.p_rnd_double_range_function = Random.rnd_double_range;
    Lua.p_draw_char_function = Ncurses.draw_char;
    Lua.p_clear_function = clear;
    Lua.p_stop_function = stop;
    Lua.p_init_pair_function = init_pair;

    return 0;
}

/**
 * Initializes the program instance
 */
int init() {
    init_lua_bindings();

    return 0;
}

/**
 * Parse key catched by Ncurses and pass it to Lua script
 */
int handle_user_input(lua_State *L, const float elapsed_ms) {
    if (Ncurses.kbhit()) {
		char ch = getch();
		if (isascii(ch)) {
			/* If char pressed is a valid ASCII char convert it to a string and
			 * pass to Lua */
			char key[2];
			sprintf(key, "%c", (char)ch);
			Lua.key_pressed(L, key, elapsed_ms);
		}
    }

    return 0;
}

/**
 * Main program
 *
 * 1. Initialize state
 * 2. Load Lua script
 * 2. Run update-render loop
 * 3. On exit close Lua handler and free memory
 */
int main(int argc, char **argv) {
    init();

    Ncurses.init_config();

    uint32_t previous_ms = 0, current_ms = 0, elapsed_ms = 0, lag_ms = 0,
	     count_ms = 0;
    previous_ms = get_current_time();

    /* Stop program on CTRL+c */
    signal(SIGINT, stop);

    lua_State *L = Lua.load_script("lua/galaxy.lua");

    /*
     * Main program loop
     */
    while (program_is_running) {
	current_ms = get_current_time();

	/* Update if enough time elapsed */
	if (count_ms > MS_PER_UPDATE_LOGIC) {
	    count_ms = 0;
	}

	/* FPS calculations */
	elapsed_ms = current_ms - previous_ms;
	previous_ms = current_ms;
	count_ms += elapsed_ms;
	lag_ms += elapsed_ms;

	/* Update the background according to lag */
	while (lag_ms >= MS_PER_UPDATE_GRAPHICS) {
	    lag_ms -= MS_PER_UPDATE_GRAPHICS;
	}

	/* Catch user keypress and pass to Lua handler */
	handle_user_input(L, elapsed_ms);

	/* Ncurses screen refresh */
	refresh();

	/* Call Lua render function */
	Lua.render_state(L, elapsed_ms);
    }

    /* Ncurses close window */
    endwin();

    Lua.close_script(L);  // Close running Lua handler

    /* Exit */
    return 0;
}
