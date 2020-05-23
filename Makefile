CC=gcc
CFLAGS=-Wall -I -fsyntax-only
CLIBS=-lncurses 
OUT=tleilax
OBJ_DIR=obj
OBJS=tleilax.o random.o galaxy.o ncurses_tools.o
INCDIR=lib 
DEPS=lib/Random/random.h lib/Galaxy/galaxy.h lib/NcursesTools/ncurses_tools.h
CDEPS=lib/Random/random.c lib/Galaxy/galaxy.c lib/NcursesTools/ncurses_tools.c

all: tleilax

$(OUT): $(OBJS)
	$(CC) $(CFLAGS) -o $(OUT) $(OBJS) -lncurses

tleilax.o: tleilax.c $(DEPS)
	$(CC) $(CFLAGS) -c $(OUT).c $(CDEPS)

random.o: lib/Random/random.c 
	$(CC) $(CFLAGS) -c random.c

galaxy.o: lib/Galaxy/galaxy.c 
	$(CC) $(CFLAGS) -c galaxy.c

ncurses_tools.o: lib/NcursesTools/ncurses_tools.c 
	$(CC) $(CFLAGS) -c ncurses_tools.c -lncurses

clean:
	rm -rf *.o tleilax 


