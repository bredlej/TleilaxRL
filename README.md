# Tleilax

A roguelike in space!

![Screenshot](https://bredlej.github.io//TleilaxRL_modern//assets/tleilaxrl.gif)

## Prerequisites

Needs a linux system or something with a bash console & support for Ncurses and Lua.

On a Debian like environment install Ncurses & Lua with
```
> sudo apt-get install libncurses-dev
> sudo apt-get install liblua5.3-dev
```
Or download both libraries and compile them with
```
cd path/to/lib
> make
> sudo make install
```

For running the program, clone it from github then go inside the folder and type in:
```
> make
> ./tleilax
```
The program uses Lua scripts for generation of the stars, user input etc. which are in the ./lua/ folder.

Please contact me if there are any issues or you need help with getting it to run.

## Author

**Patryk Szczypień** (https://github.com/bredlej) - patryk.szczypien@gmail.com

## License

This project (with exceptions) is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

### Exceptions of licensing:
This project uses the PCG Random Minimal C Implementation - https://github.com/imneme/pcg-c-basic which is under the Apache License 2.0.

