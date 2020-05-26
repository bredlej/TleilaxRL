#ifndef _NCURSES_TOOLS_H_
#define _NCURSES_TOOLS_H_
struct ncurses_tools {
	int (*init_config) (void);
	int (*kbhit) (void);
	int (*draw_char) (const int x, const int y, const char *character, const int color);
};
extern struct ncurses_tools Ncurses;
#endif
