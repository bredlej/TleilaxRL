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
#include "lib/TimeOps/timeops.h"
#include "lib/Random/random.h"
#include "lib/Galaxy/galaxy.h"
#define MS_PER_UPDATE_GRAPHICS 16
#define MS_PER_UPDATE_LOGIC 1000 

/** 
 * Global variable determining if main loop should run 
 */
static volatile sig_atomic_t program_is_running = 1;

/** 
 * Stops the program from running 
 */
static void stop (int sig) {
	program_is_running = 0;
}

/**
 * Initializes the program instance
 */
int init() 
{
	return 0;
}


int kbhit(void)
{
	int ch = getch();
	if (ch != ERR) {
		ungetch(ch);
		return 1;
	} else { 
		return 0;
	}
}

int move_galaxy_on_input(double *galaxy_offset_x, double *galaxy_offset_y, const float speed, const float elapsed_ms)
{
	if (kbhit()) {
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

int init_ncurses_config() 
{
	initscr();
	cbreak();
	noecho();
	start_color();
	init_pair(1, COLOR_YELLOW, COLOR_BLACK);
	init_pair(2, COLOR_BLUE, COLOR_BLACK);
	init_pair(3, COLOR_GREEN, COLOR_BLACK);
	curs_set(false);
	nodelay(stdscr, TRUE);
	scrollok(stdscr, TRUE);

	return 0;
}
int draw_char(const int x, const int y, const char character, const int color) 
{
	attron(COLOR_PAIR(color));
	mvwaddch(stdscr, y, x, character);
	attroff(COLOR_PAIR(color));

	return 0;
}

/**
 * Draw all screen components
 */
int render_stars_on_screen(const int amount_sectors_x, const int amount_sectors_y) 
{
	for (int x = 0; x < amount_sectors_x; x++) {
		for (int y = 0; y < amount_sectors_y; y++) {

			Random.randomize_seed_xy( x + (int)Galaxy.offset_x, y + (int)Galaxy.offset_y );

			int randomNum = Random.rnd_int_range(0, Galaxy.CHANCE_OF_STAR);
			if (randomNum == 0) {
				randomNum = Random.rnd_int_range(0,100);
				
				if (randomNum < 10) {
					draw_char(x+5, y+5, 'O', 1);
				} else if (randomNum >= 10 && randomNum < 50) {
					draw_char(x+5, y+5, 'o', 2);
				} else {
					draw_char(x+5, y+5, '*', 3);
				}
			} else {
				mvwaddch(stdscr, y+5, x+5, ' ');
			}
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
	init_ncurses_config();

	long previous_ms = 0, current_ms = 0, elapsed_ms = 0, lag_ms = 0, count_ms = 0;
	
	previous_ms = get_current_time();

	/* Stop program on CTRL+c */
	signal(SIGINT, stop);
	
	int amount_sectors_x = 64;	
	int amount_sectors_y = 32;
	
	char elapsed[20];
	
	float speed = 3.0f;

	/*
	 * Main program loop
	 */
	while(program_is_running)
	{
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
		while (lag_ms >= MS_PER_UPDATE_GRAPHICS) 
		{
			lag_ms -= MS_PER_UPDATE_GRAPHICS;
		}

		move_galaxy_on_input(&Galaxy.offset_x, &Galaxy.offset_y, speed, elapsed_ms);
		
		refresh();
		
		render_stars_on_screen(amount_sectors_x, amount_sectors_y); 
		
		wmove(stdscr, 0 ,0);
		sprintf(elapsed, "x=[%.02f] y=[%0.2f]", Galaxy.offset_x, Galaxy.offset_y);
		mvaddstr(3, amount_sectors_x >> 1, elapsed);
		mvaddstr(40, 0, "Press one of WSAD to move the screen.");
		mvaddstr(41, 0, "Press CTRL+c to exit.");
	}
	/* Exit program */
	endwin();
	
	/* Exit */	
	return 0;
}
