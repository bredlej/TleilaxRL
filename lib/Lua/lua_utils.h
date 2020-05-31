#ifndef _LUA_UTILS_H_
#define _LUA_UTILS_H_
#include <stdint.h>

typedef struct lua_State lua_State;

/**
 * Lua interface declaration
 */
struct lua {
    /* -- public  -- */

    /* Functions made available by lua struct */

    lua_State *(*load_script)(const char *);
    uint32_t (*close_script)(lua_State *);
    void (*render_state)(lua_State *, const uint32_t);
    void (*key_pressed)(lua_State *, const char *, const uint32_t);
    int (*stop)(lua_State *);
    /* -- private -- */

    /* Functions needed to be bound for use in Lua scripts */

    uint32_t (*p_randomize_seed_xy_function)(const uint32_t, const uint32_t);
    uint32_t (*p_rnd_int_range_function)(const uint32_t, const uint32_t);
    double (*p_rnd_double_range_function)(const double, const double);
    uint32_t (*p_draw_char_function)(const uint32_t, const uint32_t,
				     const char *, const uint32_t);
    void (*p_stop_function)(const int);
    int (*p_init_pair_function)(const short, const short, const short);
    int (*p_clear_function)(void);
};

/* Export as a "namespaced" global variable */
extern struct lua Lua;
#endif
