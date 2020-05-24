#include "lua_utils.h"
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

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

struct lua Lua = {
	.load_configuration = lua_load_configuration
};
