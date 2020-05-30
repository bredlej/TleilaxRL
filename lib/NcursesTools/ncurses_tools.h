#ifndef _NCURSES_TOOLS_H_
#define _NCURSES_TOOLS_H_

#include <stdint.h>

struct ncurses_tools {
	uint32_t (*init_config) (void);
	uint32_t (*kbhit) (void);
	uint32_t (*draw_char) (const uint32_t x, const uint32_t y, const char *character, const uint32_t color);
};
extern struct ncurses_tools Ncurses;
#endif
