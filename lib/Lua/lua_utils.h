#ifndef _LUA_UTILS_H_
#define _LUA_UTILS_H_

typedef struct lua_State lua_State;

#define FUNC_NAME_RANDOMIZE_SEED_XY "HOST_randomize_seed_xy"
#define FUNC_NAME_RANDOM_INT "HOST_random_int"
#define FUNC_NAME_RANDOM_DOUBLE "HOST_random_double"
#define FUNC_NAME_DRAW_CHAR "HOST_draw_char"
#define FUNC_NAME_STOP "HOST_stop"
#define FUNC_NAME_INIT_COLOR_PAIR "HOST_init_color_pair"
#define FUNC_NAME_CLEAR "HOST_clear"

#define LUA_FUNC_RANDOMIZE_SEED "randomize_seed"
#define LUA_FUNC_RANDOM_INT "random_int"
#define LUA_FUNC_RANDOM_DOUBLE "random_double"
#define LUA_FUNC_GALAXY_SET_OFFSET "galaxy_set_offset"
#define LUA_FUNC_DRAW_STRING "draw_string"
#define LUA_FUNC_DRAW_GALAXY "draw_galaxy"
#define LUA_FUNC_KEY_PRESSED "key_pressed"
#define LUA_FUNC_INIT_COLOR_PAIR "init_color_pair"
#define LUA_FUNC_CLEAR "clear"

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
	int (*stop) ();
	/* -- private -- */

	/* Functions needed to be bound for use in Lua scripts */

	unsigned int (*p_randomize_seed_xy_function) (const int, const int);
	int (*p_rnd_int_range_function) (const int, const int);
	double (*p_rnd_double_range_function) (const double, const double);
	int (*p_draw_char_function) (const int, const int, const char *, const int);
	void (*p_stop_function) (int);
	int (*p_init_pair_function) (const short, const short, const short);
	int (*p_clear_function) (void);
};


/* Export as a "namespaced" global variable */
extern struct lua Lua;
#endif
