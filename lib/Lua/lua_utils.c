#include "lua_utils.h"
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <stdlib.h>

/** 
 * Handle Lua stack for 'randomize_seed(x, y)' call of C function
 */
static int lua_stackprepare_randomize_seed_xy(lua_State *L) 
{
	int x = luaL_checknumber(L, 1);
	int y = luaL_checknumber(L, 2);
	lua_pushnumber(L, Lua.p_randomize_seed_xy_function(x, y));

	return 1; // number of results in output from Lua function call
}

/** 
 * Handle Lua stack for 'random_int(x, y)' call of C function
 */
static int lua_stackprepare_rnd_int_range(lua_State *L) 
{
	int x = luaL_checknumber(L, 1);
	int y = luaL_checknumber(L, 2);
	lua_pushnumber(L, Lua.p_rnd_int_range_function(x, y));

	return 1;
}

/** 
 * Handle Lua stack for 'random_double(x, y)' call of C function
 */
static int lua_stackprepare_rnd_double_range(lua_State *L) 
{
	double x = luaL_checknumber(L, 1);
	double y = luaL_checknumber(L, 2);
	lua_pushnumber(L, Lua.p_rnd_double_range_function(x, y));

	return 1;
}

/** 
 * Handle Lua stack for draw_string(text, x, y, color_index) call of C function
 */
static int lua_stackprepare_draw_string(lua_State *L)
{
	const char *c = (const char *) luaL_checkstring(L, 1);
	int x = (int) luaL_checknumber(L, 2);
	int y = (int) luaL_checknumber(L, 3);
	int color = (int) luaL_checknumber(L, 4);
	
	Lua.p_draw_char_function(x, y, c, color);

	return 0;
}

static int lua_init_color_pair(lua_State *L)
{
	short index = luaL_checknumber(L, 1);
	short fg_color = luaL_checknumber(L, 2);
	short bg_color = luaL_checknumber(L, 3);

	Lua.p_init_pair_function(index, fg_color, bg_color);

	return 1;
}

static int lua_stop() 
{
	Lua.p_stop_function(1);

	return 0;
}

static int lua_clear()
{
	Lua.p_clear_function();

	return 0;
}

/** 
 * Glue Lua and C functions together
 */
void register_lua_function_bindings (lua_State *L) 
{
	lua_register(L, FUNC_NAME_RANDOMIZE_SEED_XY, lua_stackprepare_randomize_seed_xy);
	lua_register(L, FUNC_NAME_RANDOM_INT, lua_stackprepare_rnd_int_range);
	lua_register(L, FUNC_NAME_RANDOM_DOUBLE, lua_stackprepare_rnd_double_range);
	lua_register(L, FUNC_NAME_DRAW_CHAR, lua_stackprepare_draw_string);	
	lua_register(L, FUNC_NAME_STOP, lua_stop);
	lua_register(L, FUNC_NAME_INIT_COLOR_PAIR, lua_init_color_pair);
	lua_register(L, FUNC_NAME_CLEAR, lua_clear);
}

/** 
 * Opens a Lua script and registers C function bindings
 *
 * @param filename - path to script
 * @return lua_State - Lua interpreter instance
 */
lua_State *lua_load_script(const char *filename) {
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);
	
	register_lua_function_bindings(L);

	if (luaL_loadfile(L, filename)|| lua_pcall(L, 0, 0, 0)) error (L, "Error loading file. :%s", lua_tostring(L, -1));
	return L;
}

/**
 * Closes a Lua interpreter
 *
 * @param L - Lua interpreter instance
 */
int close_lua_State(lua_State *L) {
	lua_close(L);
	return 0;
}

/**
 * Performs a call to Lua render it's state
 *
 * TODO declare content as Lua.p_renderer_function call, instead of specific implementation.
 *
 * @param L - Lua interpreter instance
 */
void lua_render_state(lua_State *L)
{
	lua_getglobal(L, LUA_FUNC_DRAW_GALAXY);
	if (lua_isfunction(L, -1)) {
		if (lua_pcall(L, 0, 0, 0)) error (L, "Error %s\n", lua_tostring(L, -1));
	}
	else {
		error (L, "Error: %s\n", lua_tostring(L, -1));
	}
}

/**
 * Calls Lua key_pressed function
 *
 * @param L - Lua interpreter instance
 * @param key - valid ASCII key that was pressed, formatted as string
 * @param time_ms - value telling how much miliseconds elapsed since last main loop turn
 */
void lua_key_pressed(lua_State *L, const char* key, const long time_ms) 
{
	lua_getglobal(L, LUA_FUNC_KEY_PRESSED);
	if (lua_isfunction(L, -1)) {
		lua_pushstring(L, key);
		lua_pushnumber(L, time_ms);
		if (lua_pcall(L, 2, 0, 0)) error (L, "Error %s\n", lua_tostring(L, -1));
	}
}

/** 
 * Export prepared functions inside "namespaced" global variable 
 */
struct lua Lua = {
	.render_state = lua_render_state,
	.load_script = lua_load_script,
	.close_script = close_lua_State,
	.key_pressed = lua_key_pressed,
	.stop = lua_stop,
};
