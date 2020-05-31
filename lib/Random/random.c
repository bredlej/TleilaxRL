#include "random.h"

#include "pcg_basic.h"

pcg32_random_t rng;

uint32_t rnd(void) { return pcg32_random_r(&rng); }

double rndDouble(const double min, const double max) {
    return ((double)rnd() / (double)(0xFFFFFFFF)) * (max - min) + min;
}

uint32_t rndInt(const uint32_t min, const uint32_t max) {
    return (rnd() % (max - min)) + min;
}

uint32_t randomize_seed_xy(const uint32_t x, const uint32_t y) {
    pcg32_srandom_r(&rng, ((x + y) >> 1) * (x + y + 1) + y, ((x + y) >> 1));
    return rnd();
}

struct random Random = {.rnd = rnd,
			.rnd_double_range = rndDouble,
			.rnd_int_range = rndInt,
			.randomize_seed_xy = randomize_seed_xy};

