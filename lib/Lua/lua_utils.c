#include "lua_utils.h"
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <stdlib.h>

#define FUNC_NAME_RANDOMIZE_SEED_XY "HOST_randomize_seed_xy"
#define FUNC_NAME_RANDOM_INT "HOST_random_int"
#define FUNC_NAME_RANDOM_DOUBLE "HOST_random_double"

#define LUA_FUNC_RANDOMIZE_SEED "randomize_seed"
#define LUA_FUNC_RANDOM_INT "random_int"
#define LUA_FUNC_RANDOM_DOUBLE "random_double"

/** 
 * Load configuration in script given by the filename and return as config struct 
 */
struct config lua_load_configuration(const char* filename)
{
	struct config configuration;

	lua_State *L = luaL_newstate();
	luaL_openlibs(L);
	if (luaL_loadfile(L, filename)  || lua_pcall(L, 0, 0, 0)) {
		error(L, "Can't run configuration file %s\n", lua_tostring(L, -1));		
	}
	lua_getglobal(L, "screen_width");
	lua_getglobal(L, "screen_height");
	lua_getglobal(L, "scroll_speed");
	lua_getglobal(L, "ms_per_update_graphics");
	lua_getglobal(L, "ms_per_update_logic");
	
	if (!lua_isnumber(L, -1)) error (L, "'ms_per_update_logic' should be a number\n");
	if (!lua_isnumber(L, -2)) error (L, "'ms_per_update_graphics' should be a number\n");
	if (!lua_isnumber(L, -3)) error (L, "'scroll_speed' should be a number\n");
	if (!lua_isnumber(L, -4)) error (L, "'screen_height' should be a number\n");
	if (!lua_isnumber(L, -5)) error (L, "'screen_width' should be a number\n");

	configuration.ms_per_update_logic = (int) lua_tonumber(L, -1);
	configuration.ms_per_update_graphics = (int) lua_tonumber(L, -2);
	configuration.scroll_speed = (float) lua_tonumber(L, -3);
	configuration.screen_height = (int) lua_tonumber(L, -4);
	configuration.screen_width = (int) lua_tonumber(L, -5);

	lua_close(L);

	return configuration;
}

/**
 *	Bind function pointed by Lua.p_randomize_seed_xy_function to Lua handler
 *	and push its parameters on the stack.
 */
static int lua_stackprepare_randomize_seed_xy(lua_State *L) 
{
	int x = luaL_checknumber(L, 1);
	int y = luaL_checknumber(L, 2);
	lua_pushnumber(L, Lua.p_randomize_seed_xy_function(x, y));

	return 1; // number of results in output from Lua function call
}

static int lua_stackprepare_rnd_int_range(lua_State *L) 
{
	int x = luaL_checknumber(L, 1);
	int y = luaL_checknumber(L, 2);
	lua_pushnumber(L, Lua.p_rnd_int_range_function(x, y));

	return 1;
}

static int lua_stackprepare_rnd_double_range(lua_State *L) 
{
	double x = luaL_checknumber(L, 1);
	double y = luaL_checknumber(L, 2);
	lua_pushnumber(L, Lua.p_rnd_double_range_function(x, y));

	return 1;
}

/**
 *	Runs the randomize_seed(x,y) function inside Lua script with given filename and parameters
 */
int lua_randomize_seed(const char * filename, int x, int y)
{
	/* Open Lua handler and load libraries */
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	/* Bind Lua global name to C function */
	lua_register(L, FUNC_NAME_RANDOMIZE_SEED_XY, lua_stackprepare_randomize_seed_xy);

	/* Load script with given file name */
	if (luaL_loadfile(L, filename)|| lua_pcall(L, 0, 0, 0)) error (L, "Error loading file. :%s", lua_tostring(L, -1));

	/* Find function to call inside Lua script */
	lua_getglobal(L, LUA_FUNC_RANDOMIZE_SEED);
	
	/* If there's a function on the stack, push attributes and call it */
	if (lua_isfunction(L, -1)){
		lua_pushnumber(L, x);
		lua_pushnumber(L, y);

		/* Takes 2 parameters and gives 1 result */
		if (lua_pcall(L, 2, 1, 0)) error (L, "Error %s\n", lua_tostring(L, -1));
	}
	else {
		error (L, "Error: %s\n", lua_tostring(L, -1));
	}

	/* If result is not a number something went wrong */	
	if (!lua_isnumber(L, -1)) error (L, "Got wrong result type from %s call.\n", LUA_FUNC_RANDOMIZE_SEED);

	/* Get result from Lua function call */
	int result = (int) lua_tonumber(L, -1);
	
	/* Close handler and return result to caller*/
	lua_close(L);

	return result;
}	

int lua_draw_galaxy(const char * filename, const int x, const int y)
{
	/* Open Lua handler and load libraries */
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	/* Bind Lua global name to C function */
	lua_register(L, FUNC_NAME_RANDOM_INT, lua_stackprepare_rnd_int_range);

	/* Load script with given file name */
	if (luaL_loadfile(L, filename)|| lua_pcall(L, 0, 0, 0)) error (L, "Error loading file. :%s", lua_tostring(L, -1));

	/* Find function to call inside Lua script */
	lua_getglobal(L, LUA_FUNC_RANDOM_INT);
	
	/* If there's a function on the stack, push attributes and call it */
	if (lua_isfunction(L, -1)){
		lua_pushnumber(L, x);
		lua_pushnumber(L, y);

		/* Takes 2 parameters and gives 1 result */
		if (lua_pcall(L, 2, 1, 0)) error (L, "Error %s\n", lua_tostring(L, -1));
	}
	else {
		error (L, "Error: %s\n", lua_tostring(L, -1));
	}

	/* If result is not a number something went wrong */	
	if (!lua_isnumber(L, -1)) error (L, "Got wrong result type from %s call.\n", LUA_FUNC_RANDOMIZE_SEED);

	/* Get result from Lua function call */
	int result = (int) lua_tonumber(L, -1);
	
	/* Close handler and return result to caller*/
	lua_close(L);

	return result;

}

/* Export prepared functions inside "namespaced" global variable */
struct lua Lua = {
	.load_configuration = lua_load_configuration,
	.randomize_seed = lua_draw_galaxy	
};
