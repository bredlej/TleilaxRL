CC=gcc
CFLAGS=-Wall -I -fsyntax-only
CLIBS=-lncurses -llua5.3 
OUT=tleilax
OBJ_DIR=obj
OBJS=tleilax.o random.o galaxy.o ncurses_tools.o lua_utils.o
INCDIR=lib 
DEPS=lib/Random/random.h lib/Galaxy/galaxy.h lib/NcursesTools/ncurses_tools.h lib/Lua/lua_utils.h
CDEPS=lib/Random/random.c lib/Galaxy/galaxy.c lib/NcursesTools/ncurses_tools.c lib/Lua/lua_utils.c

all: tleilax

$(OUT): $(OBJS)
	$(CC) $(CFLAGS) -o $(OUT) $(OBJS) $(CLIBS)

tleilax.o: tleilax.c $(DEPS)
	$(CC) $(CFLAGS) -I/usr/include/lua5.3 -c $(OUT).c $(CDEPS) 

random.o: lib/Random/random.h
	$(CC) $(CFLAGS) -c lib/Random/random.c

galaxy.o: lib/Galaxy/galaxy.h 
	$(CC) $(CFLAGS) -c lib/Galaxy/galaxy.c

ncurses_tools.o: lib/NcursesTools/ncurses_tools.h 
	$(CC) $(CFLAGS) -c lib/NcursesTools/ncurses_tools.c -lncurses

lua_utils.o: lib/Lua/lua_utils.h 
	$(CC) $(CFLAGS) lib/Lua/lua_utils.c -llua5.3

clean:
	rm -rf *.o tleilax 


