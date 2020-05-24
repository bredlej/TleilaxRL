#ifndef _LUA_UTILS_H_
#define _LUA_UTILS_H_

struct config {
	int screen_width;
	int screen_height;
	int scroll_speed;
	int ms_per_update_logic;
	int ms_per_update_graphics;
};

struct lua {
	struct config (*load_configuration) (const char*);
};

extern struct lua Lua;
#endif
