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
	/* -- public  -- */
	struct config (*load_configuration) (const char*);
	int (*randomize_seed) (const char *, const int x, const int y);

	/* -- private -- */
	/* pointer to a randomize_seed(x,y) function used by Lua scripts */
	int (*p_randomize_seed_xy_function) (const int, const int);
};

/* Export as a "namespaced" global variable */
extern struct lua Lua;
#endif
