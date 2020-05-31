#ifndef _RANDOM_H_
#define _RANDOM_H_

#include <stdint.h>

struct random {
    uint32_t (*rnd)(void);
    double (*rnd_double_range)(const double, const double);
    uint32_t (*rnd_int_range)(const uint32_t, const uint32_t);
    uint32_t (*randomize_seed_xy)(const uint32_t, const uint32_t);
};

extern struct random Random;
#endif
