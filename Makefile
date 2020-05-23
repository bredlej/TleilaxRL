CC=gcc
CFLAGS=-Wall -I
CLIBS=-lncurses 
OUT=tleilax
OBJ_DIR=obj
OBJS=tleilax.o random.o
INCDIR=lib 
DEPS=lib/Random/random.h

all: tleilax

tleilax: $(OBJS)
	gcc -Wall -o tleilax tleilax.o random.o galaxy.o -lncurses

tleilax.o: tleilax.c lib/Random/random.h lib/Galaxy/galaxy.h
	gcc -Wall -c tleilax.c lib/Random/random.c lib/Galaxy/galaxy.c

random.o: lib/Random/random.c lib/Random/random.h
	gcc -Wall -c random.c

galaxy.o: lib/Galaxy/galaxy.c 
	gcc -Wall -c galaxy.c

clean:
	rm -rf *.o tleilax lib/Random/*.gch lib/Galaxy/*.gch lib/TimeOps/*.gch


