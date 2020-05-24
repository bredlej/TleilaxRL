#include "random.h"


/**
 * Below are Lehmer RNG calculations from:
 * https://github.com/OneLoneCoder/olcPixelGameEngine/blob/master/Videos/OneLoneCoder_PGE_ProcGen_Universe.cpp
 *
 * Calculations converted to C language.
 */

unsigned int seed = 0;

unsigned int rnd(unsigned int n_proc_gen) 
{
	n_proc_gen += 0xe120fc15;
	unsigned long tmp;
	tmp = n_proc_gen * 0x4a39b70d;
	unsigned int m1 = (tmp >> 32) ^ tmp;
	tmp = m1 * 0x12fad5c9;
	unsigned int m2 = (tmp >> 32) ^ tmp;
	seed = n_proc_gen;
	return m2;
} 

double rndDouble(double min, double max) 
{
	return ((double) rnd(seed) / (double) (0xFFFFFFFF)) * (max - min) + min;
}

int rndInt(int min, int max)
{
	return (rnd(seed) % (max - min)) + min;
}

unsigned int randomize_seed_xy(const int x, const int y)
{
	return Random.rnd(((x + y) >> 1) * (x + y + 1) +y);
}

struct random Random = {
	.rnd = rnd,
	.rnd_double_range = rndDouble,
	.rnd_int_range = rndInt,
	.randomize_seed_xy = randomize_seed_xy
};

