#include "ncurses_tools.h"
#include <ncurses.h>
#include <locale.h>
uint32_t init_ncurses_config() 
{
	setlocale(LC_ALL, "");
	initscr();
	cbreak();
	noecho();
	start_color();
/*	init_pair(1, COLOR_YELLOW, COLOR_BLACK);
	init_pair(2, COLOR_BLUE, COLOR_BLACK);
	init_pair(3, COLOR_GREEN, COLOR_BLACK);*/
	curs_set(false);
	nodelay(stdscr, TRUE);
	scrollok(stdscr, TRUE);

	return 0;
}

uint32_t draw_char(const uint32_t x, const uint32_t y, const char *character, const uint32_t color) 
{
	attron(COLOR_PAIR(color));
	mvaddstr(y, x, character);
	attroff(COLOR_PAIR(color));

	return 0;
}

uint32_t kbhit(void)
{
	uint32_t ch = getch();
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
