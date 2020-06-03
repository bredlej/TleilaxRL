CC=clang
CFLAGS=-Wall -I -fsyntax-only -g
CLIBS=-lncursesw -llua5.3 
OUT=tleilax
OBJS=tleilax.o random.o pcg_basic.o ncurses_tools.o lua_utils.o
OBJ_DIR=obj
INCDIR=lib 
DEPS=lib/Random/random.h lib/Random/pcg_basic.h lib/NcursesTools/ncurses_tools.h lib/Lua/lua_utils.h

all: tleilax

$(OUT): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) $(CLIBS) -o $(OUT) 

tleilax.o: tleilax.c $(DEPS)
	$(CC) $(CFLAGS) -I/usr/include/lua5.3 -c $(OUT).c  

random.o: lib/Random/random.c lib/Random/random.h
	$(CC) -c $(CFLAGS) lib/Random/random.c

ncurses_tools.o: lib/NcursesTools/ncurses_tools.c lib/NcursesTools/ncurses_tools.h 
	$(CC) -c $(CFLAGS) lib/NcursesTools/ncurses_tools.c 

lua_utils.o: lib/Lua/lua_utils.c lib/Lua/lua_utils.h 
	$(CC) -c -I -fsyntax-only -g lib/Lua/lua_utils.c -I/usr/include/lua5.3

pcg_basic.o: lib/Random/pcg_basic.h
	$(CC) -c $(CFLAGS) lib/Random/pcg_basic.c

clean:
	rm -rf *.o tleilax 


