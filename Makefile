CC=gcc
CFLAGS=-Wall -I -fsyntax-only
CLIBS=-lncurses -llua5.3 
OUT=tleilax
OBJ_DIR=obj
OBJS=tleilax.o random.o pcg_basic.o ncurses_tools.o lua_utils.o
INCDIR=lib 
DEPS=lib/Random/random.h lib/Random/pcg_basic.h lib/NcursesTools/ncurses_tools.h lib/Lua/lua_utils.h
CDEPS=lib/Random/random.c lib/Random/pcg_basic.c lib/NcursesTools/ncurses_tools.c lib/Lua/lua_utils.c

all: tleilax

$(OUT): $(OBJS)
	$(CC) $(CFLAGS) -o $(OUT) $(OBJS) $(CLIBS)

tleilax.o: tleilax.c $(DEPS)
	$(CC) $(CFLAGS) -I/usr/include/lua5.3 -c $(OUT).c $(CDEPS) 

random.o: lib/Random/random.h
	$(CC) $(CFLAGS) -c lib/Random/random.c

ncurses_tools.o: lib/NcursesTools/ncurses_tools.h 
	$(CC) $(CFLAGS) -c lib/NcursesTools/ncurses_tools.c -lncurses

lua_utils.o: lib/Lua/lua_utils.h 
	$(CC) $(CFLAGS) lib/Lua/lua_utils.c -llua5.3

pcg_basic.o: lib/Random/pcg_basic.h
	$(CC) $(CFLAGS) lib/Random/pcg32_basic.c

clean:
	rm -rf *.o tleilax 


