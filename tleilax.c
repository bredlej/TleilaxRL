#include <sys/time.h>
#include <sys/types.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <ncurses.h>
#include <unistd.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include "lib/TimeOps/timeops.h"
#include "lib/Random/random.h"
#include "lib/Galaxy/galaxy.h"
#include "lib/NcursesTools/ncurses_tools.h"
#include "lib/Lua/lua_utils.h"

#define MS_PER_UPDATE_GRAPHICS 16
#define MS_PER_UPDATE_LOGIC 1000 

struct application {
	struct config Config; 
} Application;

/** 
 * Global variable determining if main loop should run 
 */
static volatile sig_atomic_t program_is_running = 1;

/** 
 * Stops the program from running 
 */
static void stop (int sig) 
{
	program_is_running = 0;
}

int init_lua_bindings()
{
	/* Set which randomize seed function Lua should use. */
	Lua.p_randomize_seed_xy_function = Random.randomize_seed_xy;
	Lua.p_rnd_int_range_function = Random.rnd_int_range;
	Lua.p_rnd_double_range_function = Random.rnd_double_range;
	Lua.p_draw_char_function = Ncurses.draw_char;
	return 0;	
}

/**
 * Initializes the program instance
 */
int init() 
{
	init_lua_bindings();
	return 0;
}

int move_galaxy_on_input(double *galaxy_offset_x, double *galaxy_offset_y, const float speed, const float elapsed_ms)
{
	if (Ncurses.kbhit()) {
		char ch = getch();
		if (ch == 'a') {
			*galaxy_offset_x -= speed * elapsed_ms;
		}
		if (ch == 's') {
			*galaxy_offset_y += speed * elapsed_ms;
		}
		if (ch == 'w') {
			*galaxy_offset_y -= speed * elapsed_ms;
		}
		if (ch == 'd') {
			*galaxy_offset_x += speed * elapsed_ms;
		}
	}		

	return 0;
}

/**
 * Main program
 * 
 * 1. Initialize state
 * 2. Run update-render loop
 * 3. On exit free memory & turn off OLED screen
 *
 */  
int main(int argc, char **argv)
{
	init();
	Application.Config = Lua.load_configuration("./lua/config.lua");
	int lua_output = Lua.randomize_seed("./lua/galaxy.lua", 1, 10);
	
	Ncurses.init_config();

	long previous_ms = 0, current_ms = 0, elapsed_ms = 0, lag_ms = 0, count_ms = 0;
	
	previous_ms = get_current_time();

	/* Stop program on CTRL+c */
	signal(SIGINT, stop);


	char debug_galaxy_xy[100];

	//Lua.p_randomize_seed_xy_function = test_function;
	lua_State *L = lua_load_galaxy_script("lua/galaxy.lua");
	/*
	 * Main program loop
	 */
	while(program_is_running)
	{
		current_ms = get_current_time();

		/* Update if enough time elapsed */
		if (count_ms > Application.Config.ms_per_update_logic) {
			count_ms = 0;
		}
		
		/* FPS calculations */
		elapsed_ms = current_ms - previous_ms;
		previous_ms = current_ms;
		count_ms += elapsed_ms;
		lag_ms += elapsed_ms;
		
		/* Update the background according to lag */
		while (lag_ms >= Application.Config.ms_per_update_graphics) 
		{
			lag_ms -= Application.Config.ms_per_update_graphics;
		}

		move_galaxy_on_input(&Galaxy.offset_x, &Galaxy.offset_y, Application.Config.scroll_speed, elapsed_ms);
		refresh();
		
		Lua.draw_galaxy(L, 64, 32);	
		
		wmove(stdscr, 0 ,0);
		sprintf(debug_galaxy_xy, "x=[%.02f] y=[%0.2f], Lua=[%d]", Galaxy.offset_x, Galaxy.offset_y, lua_output);
		mvaddstr(3, Application.Config.screen_width >> 1, debug_galaxy_xy);
		mvaddstr(40, 0, "Press one of WSAD to move the screen.");
		mvaddstr(41, 0, "Press CTRL+c to exit.");
	}
	/* Exit program */
	endwin();
	close_galaxy_script(L);	
	/* Exit */	
	return 0;
}
