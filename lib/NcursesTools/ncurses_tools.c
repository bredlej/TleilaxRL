#include "ncurses_tools.h"
#include <ncurses.h>

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

int draw_char(const int x, const int y, const char *character, const int color) 
{
	attron(COLOR_PAIR(color));
	mvaddstr(y, x, character);
	attroff(COLOR_PAIR(color));

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

struct ncurses_tools Ncurses = {
	.init_config = init_ncurses_config,
	.draw_char = draw_char,
	.kbhit = kbhit
};
