#ifndef _LUA_UTILS_H_
#define _LUA_UTILS_H_

typedef struct lua_State lua_State;

/**
 * Lua interface declaration
 */
struct lua {
	/* -- public  -- */

	/* Functions made available by lua struct */

	lua_State* (*load_script) (const char *);
	int (*close_script)	(lua_State*);
	void (*render_state) (lua_State *);
	void (*key_pressed) (lua_State *, const char *, const long);
	
	/* -- private -- */

	/* Functions needed to be bound for use in Lua scripts */

	unsigned int (*p_randomize_seed_xy_function) (const int, const int);
	int (*p_rnd_int_range_function) (const int, const int);
	double (*p_rnd_double_range_function) (const double, const double);
	int (*p_draw_char_function) (const int, const int, const char *, const int);
};


/* Export as a "namespaced" global variable */
extern struct lua Lua;
#endif
