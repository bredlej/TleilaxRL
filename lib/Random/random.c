#include "random.h"
#include "pcg_basic.h"

pcg32_random_t rng;

unsigned int rnd() 
{
	return pcg32_random_r(&rng);
} 

double rndDouble(double min, double max) 
{
	return ((double) rnd() / (double) (0xFFFFFFFF)) * (max - min) + min;
}

int rndInt(int min, int max)
{
	return (rnd() % (max - min)) + min;
}

unsigned int randomize_seed_xy(const int x, const int y)
{
	pcg32_srandom_r(&rng, ((x + y) >> 1) * (x + y + 1) +y, ((x + y) >> 1) );
	return rnd();
}

struct random Random = {
	.rnd = rnd,
	.rnd_double_range = rndDouble,
	.rnd_int_range = rndInt,
	.randomize_seed_xy = randomize_seed_xy
};

